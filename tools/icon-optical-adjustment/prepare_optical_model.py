#!/usr/bin/env python3
"""Prepare verified local weights for optical icon sizing.

Run after installing the script requirements. The large backbone comes from
the official URL recorded in optical-model.json; the small calibration file
comes from the pinned LPIPS package. Every file is verified before an atomic
replacement. Icon measurement itself never downloads weights.
"""

import argparse
import importlib.util
import os
import tempfile
import urllib.request
from pathlib import Path

import learned_presence as presence


def _install_stream(stream, destination, expected):
    """Keep an existing file intact until its complete replacement is verified."""
    destination = Path(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary = tempfile.mkstemp(
        prefix=f".{destination.name}.", suffix=".tmp", dir=destination.parent
    )
    temporary = Path(temporary)
    try:
        size = 0
        with os.fdopen(descriptor, "wb") as output:
            while chunk := stream.read(1024 * 1024):
                size += len(chunk)
                if size > expected["bytes"]:
                    raise presence.ModelSetupError("Model download exceeds its fixed expected size")
                output.write(chunk)
            output.flush()
            os.fsync(output.fileno())
        if size != expected["bytes"] or presence.digest_file(temporary) != expected["sha256"]:
            raise presence.ModelSetupError(
                "Model file does not match its expected size and SHA-256 digest"
            )
        os.replace(temporary, destination)
    finally:
        temporary.unlink(missing_ok=True)


def prepare(
    *, cache_dir=presence.DEFAULT_CACHE, model_path=presence.MODEL_PATH, backbone_source=None
):
    data = presence.read_model(model_path)
    presence.require_packages(data)
    root = Path(cache_dir).expanduser().resolve()
    backbone = data["weights"]["backbone"]
    destination = root / backbone["filename"]
    if not destination.is_file() or presence.digest_file(destination) != backbone["sha256"]:
        if backbone_source is not None:
            with Path(backbone_source).expanduser().open("rb") as stream:
                _install_stream(stream, destination, backbone)
        else:
            print(
                f"Downloading the {backbone['bytes'] / 1024**2:.1f} MiB fixed backbone...",
                flush=True,
            )
            with urllib.request.urlopen(backbone["url"], timeout=60) as stream:
                _install_stream(stream, destination, backbone)
    calibration = data["weights"]["calibration"]
    destination = root / calibration["filename"]
    if not destination.is_file() or presence.digest_file(destination) != calibration["sha256"]:
        spec = importlib.util.find_spec("lpips")
        if spec is None or spec.origin is None:
            raise presence.ModelSetupError(
                "Install the pinned LPIPS package before preparing its calibration weights"
            )
        bundle = Path(spec.origin).parent / "weights" / "v0.1" / "alex.pth"
        with bundle.open("rb") as stream:
            _install_stream(stream, destination, calibration)
    return presence.verified_weight_paths(data, root)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cache-dir", type=Path, default=presence.DEFAULT_CACHE)
    parser.add_argument(
        "--backbone-source",
        type=Path,
        help="Copy an existing backbone file after verifying its full digest, instead of downloading",
    )
    args = parser.parse_args(argv)
    try:
        paths = prepare(cache_dir=args.cache_dir, backbone_source=args.backbone_source)
    except (presence.ModelSetupError, OSError, ValueError) as error:
        parser.exit(1, f"{error}\n")
    print(f"Verified icon model weights in {paths['backbone'].parent}")


if __name__ == "__main__":
    main()
