"""Utilidades internas de red, descarga y extracción de archivos."""

from __future__ import annotations

import tempfile
from datetime import datetime, timezone
from pathlib import Path

#: Headers por defecto para todas las peticiones HTTP del paquete.
DEFAULT_HEADERS: dict[str, str] = {
    "User-Agent": "geoidep-python/0.2.0 (+https://github.com/ambarja/geoidep)",
}


def download_file(
    url: str,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 60,
    verify: bool = False,        # los servidores peruanos suelen tener SSL mal configurado
    chunk_size: int = 1 << 15,   # 32 KiB
) -> Path:
    """Descarga ``url`` a disco devolviendo la ruta.

    Equivalente Python del patrón ``httr::GET + write_disk + progress``
    usado en el paquete R original.

    Parameters
    ----------
    url
        URL a descargar.
    dsn
        Ruta de salida. Si es ``None``, se crea un archivo temporal con
        la extensión inferida del URL.
    show_progress
        Si ``True`` muestra una barra ``tqdm`` con bytes descargados.
    timeout
        Timeout en segundos para la conexión.
    verify
        Verificar el certificado SSL. Muchos servicios IDEP tienen
        certificados expirados, por eso el default es ``False``.
    """
    import requests
    from tqdm.auto import tqdm

    if dsn is None:
        suffix = Path(url.split("?")[0]).suffix or ".bin"
        dsn = Path(tempfile.mkstemp(suffix=suffix)[1])
    else:
        dsn = Path(dsn)
        dsn.parent.mkdir(parents=True, exist_ok=True)

    with requests.get(
        url,
        stream=True,
        timeout=timeout,
        headers=DEFAULT_HEADERS,
        verify=verify,
    ) as resp:
        resp.raise_for_status()
        total = int(resp.headers.get("Content-Length") or 0)

        bar = (
            tqdm(total=total, unit="B", unit_scale=True, desc=dsn.name)
            if show_progress
            else None
        )
        try:
            with open(dsn, "wb") as fh:
                for chunk in resp.iter_content(chunk_size=chunk_size):
                    if chunk:
                        fh.write(chunk)
                        if bar is not None:
                            bar.update(len(chunk))
        finally:
            if bar is not None:
                bar.close()

    return dsn


def extract_rar(archive_path: str | Path, dest_dir: str | Path | None = None) -> Path:
    """Extrae un ``.rar`` y devuelve el directorio destino.

    Requiere la librería ``rarfile`` y un binario ``unrar`` o ``bsdtar``
    accesible en el ``PATH``. INEI distribuye sus capas en este formato.
    """
    try:
        import rarfile  # noqa: WPS433  (import diferido a propósito)
    except ImportError as e:  # pragma: no cover
        raise ImportError(
            "Se requiere `rarfile` para extraer archivos INEI. "
            "Instala además el binario `unrar` (Linux/macOS: apt install unrar / "
            "brew install unrar; Windows: agregar unrar.exe al PATH)."
        ) from e

    archive_path = Path(archive_path)
    dest_dir = Path(dest_dir) if dest_dir else Path(tempfile.mkdtemp(prefix="geoidep_"))
    dest_dir.mkdir(parents=True, exist_ok=True)

    with rarfile.RarFile(archive_path) as rf:
        rf.extractall(path=dest_dir)
    return dest_dir


def extract_zip(archive_path: str | Path, dest_dir: str | Path | None = None) -> Path:
    """Extrae un ``.zip`` y devuelve el directorio destino.

    Alternativa a :func:`extract_rar` para los servicios que devuelven ZIP
    (MIDAGRI, SENAMHI WFS).
    """
    import zipfile

    archive_path = Path(archive_path)
    dest_dir = Path(dest_dir) if dest_dir else Path(tempfile.mkdtemp(prefix="geoidep_"))
    dest_dir.mkdir(parents=True, exist_ok=True)

    with zipfile.ZipFile(archive_path) as zf:
        zf.extractall(path=dest_dir)
    return dest_dir


def find_first(directory: str | Path, pattern: str) -> Path:
    """Busca el primer archivo en ``directory`` (recursivo) que case con ``pattern``.

    Por ejemplo, ``find_first(d, "*.gpkg")``.
    """
    directory = Path(directory)
    matches = list(directory.rglob(pattern))
    if not matches:
        raise FileNotFoundError(
            f"No se encontró ningún archivo {pattern!r} bajo {directory}"
        )
    return matches[0]


def as_datetime(ms_since_epoch: float | int | None) -> datetime | None:
    """Convierte timestamps en milisegundos (estilo ArcGIS) a ``datetime`` UTC.

    Equivalente del helper R ``as_data_time``.
    """
    if ms_since_epoch is None:
        return None
    try:
        return datetime.fromtimestamp(float(ms_since_epoch) / 1000.0, tz=timezone.utc)
    except (TypeError, ValueError, OverflowError):
        return None
