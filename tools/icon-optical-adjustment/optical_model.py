"""Validated, offline design calibration shared by the icon sizing tools."""

import hashlib
import importlib.metadata
import json
import math
from pathlib import Path

MODEL_PATH = Path(__file__).with_name("optical-model.json")
REFERENCE_SOURCE = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20"><circle cx="10" cy="10" r="10" fill="black"/></svg>'


class ModelSetupError(RuntimeError):
    """The pinned renderer or numerical runtime is unavailable."""


def digest_file(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read_model(path=MODEL_PATH):
    data = json.loads(Path(path).read_text())
    if not isinstance(data, dict) or data.get("schema") != "mateo.icon-presence-model.v2":
        raise ValueError("Unsupported icon presence model schema")
    try:
        _validate(data)
    except (KeyError, TypeError, OverflowError) as error:
        raise ValueError("Missing or invalid icon model field") from error
    return data


def _validate(data):
    if data["model"] != "mateo-optical-5.3":
        raise ValueError("Unsupported optical model")
    for name in (
        "reference_diameter",
        "max_extent",
        "orientation",
        "empty_space",
        "contrast_cue",
        "diagonal_extent",
        "body_evidence_gain",
        "body_area_weight",
        "broad_body_max_enlargement",
        "placement_weight",
        "placement_max_offset",
    ):
        value = data[name]
        if (
            isinstance(value, bool)
            or not isinstance(value, (int, float))
            or not math.isfinite(value)
        ):
            raise ValueError(f"Model {name} must be finite numeric calibration")
    if not 0 < data["reference_diameter"] <= data["max_extent"] <= 20:
        raise ValueError("Reference and maximum extent must fit the 20px frame")
    if not 0 <= data["body_area_weight"] <= 1 or not 0 < data["body_evidence_gain"] <= 16:
        raise ValueError("Invalid body calibration")
    if not 1 <= data["broad_body_max_enlargement"] <= 2:
        raise ValueError("Invalid broad-body enlargement limit")
    if not 0 <= data["placement_weight"] <= 1 or not 0 < data["placement_max_offset"] <= 2:
        raise ValueError("Invalid placement calibration")
    for name in (
        "compact_body_concentration_range",
        "compact_body_aspect_range",
        "broad_body_concentration_rise",
        "broad_body_concentration_fall",
        "detached_ink_range",
    ):
        interval = data[name]
        if (
            not isinstance(interval, list)
            or len(interval) != 2
            or any(
                isinstance(v, bool)
                or not isinstance(v, (int, float))
                or not math.isfinite(v)
                for v in interval
            )
            or not 0 <= interval[0] < interval[1] <= 1
        ):
            raise ValueError(f"Invalid model {name}")
    if data["broad_body_concentration_rise"][1] > data["broad_body_concentration_fall"][0]:
        raise ValueError("Broad-body concentration must finish rising before falling")
    if any(
        not 0 <= data[name] <= 1
        for name in ("orientation", "empty_space", "contrast_cue", "diagonal_extent")
    ):
        raise ValueError("Invalid span calibration")
    if data["pixels_per_unit"] != 32 or data["analysis_pixels_per_unit"] != 8:
        raise ValueError("Model requires 32 geometry and 8 enclosure samples per unit")
    for name in ("closure_sigmas", "display_sizes"):
        values = data[name]
        if (
            not isinstance(values, list)
            or not values
            or any(
                isinstance(v, bool)
                or not isinstance(v, (int, float))
                or not math.isfinite(v)
                or v <= 0
                for v in values
            )
            or values != sorted(set(values))
        ):
            raise ValueError(f"Invalid model {name}")
    if (
        not isinstance(data["packages"], dict)
        or set(data["packages"]) != {"numpy", "scipy", "Pillow", "resvg-py", "scikit-image"}
        or any(not isinstance(v, str) or not v for v in data["packages"].values())
    ):
        raise ValueError("Invalid pinned model packages")


def require_packages(data):
    for name, expected in data["packages"].items():
        try:
            actual = importlib.metadata.version(name)
        except importlib.metadata.PackageNotFoundError as error:
            raise ModelSetupError(
                f"Optical model requires {name}=={expected}; install requirements.txt"
            ) from error
        if actual != expected:
            raise ModelSetupError(f"Optical model requires {name}=={expected}, found {actual}")
