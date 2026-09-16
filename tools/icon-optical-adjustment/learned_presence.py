"""Shared apparent-size correction from fixed geometry and visual descriptors.

Inference uses one canonical rendering of authored geometry. The correction is
constant while output scale is solved, preserving the base score's monotonicity.
This leaf reads fixed model parameters and verified local weights; it neither
fits parameters nor downloads files. Icon names never enter its public API.
"""

from __future__ import annotations

import hashlib
import importlib.metadata
import itertools
import json
import math
import threading
from collections import OrderedDict
from pathlib import Path

import numpy as np
from svg_measurement import FRAME, render_alpha, unwrap, wrap

MODEL_PATH = Path(__file__).with_name("optical-model.json")
DEFAULT_CACHE = Path.home() / ".cache" / "mateo-icons"
REFERENCE_SOURCE = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20"><circle cx="10" cy="10" r="10" fill="black"/></svg>'
BASE_NAMES = (
    "unoccupied_fraction",
    "log_feret_over_axis",
    "log_filled_over_ink",
    *(f"log_alex_layer_{i + 1}_distance_over_disk" for i in range(5)),
)
PAIRS = tuple((i, j) for i in range(8) for j in range(i + 1, 8))
CUBIC_TRIPLES = tuple(itertools.combinations_with_replacement(range(8), 3))
CUBIC_WEIGHTS = tuple(
    math.sqrt(6 / math.prod(math.factorial(triple.count(i)) for i in set(triple)))
    for triple in CUBIC_TRIPLES
)
FEATURE_NAMES = (
    tuple(f"linear:{name}" for name in BASE_NAMES)
    + tuple(f"square:{name}" for name in BASE_NAMES)
    + tuple(f"cross:{BASE_NAMES[i]}*{BASE_NAMES[j]}" for i, j in PAIRS)
    + tuple("cubic:" + "*".join(BASE_NAMES[i] for i in triple) for triple in CUBIC_TRIPLES)
)
PHASE_OFFSETS = tuple((dy, dx) for dy in (-2, -1, 0, 1) for dx in (-2, -1, 0, 1))
SYMMETRIES = tuple((turns, reflected) for reflected in (False, True) for turns in range(4))
PIXELS_PER_UNIT = 32
_INSTANCE = None
_INSTANCE_KEY = None
_INSTANCE_LOCK = threading.RLock()


class ModelSetupError(RuntimeError):
    """The fixed inference dependencies or verified local weights are absent."""


def digest_file(path):
    digest = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _vector(value, length, label, *, positive=False):
    result = np.asarray(value, dtype=float)
    if (
        result.shape != (length,)
        or not np.isfinite(result).all()
        or (positive and np.any(result <= 0))
    ):
        raise ValueError(
            f"{label} must be a finite length-{length} vector"
            + (" with positive values" if positive else "")
        )
    return result


def read_model(path=MODEL_PATH):
    """Read the portable parameter artifact without initializing a network."""
    data = json.loads(Path(path).read_text())
    if not isinstance(data, dict):
        raise ValueError("The icon presence model must be a JSON object")
    try:
        _validate_model(data)
    except (KeyError, TypeError, OverflowError) as error:
        raise ValueError(f"Missing or invalid icon model field: {error}") from error
    return data


def _validate_model(data):
    if data.get("schema") != "mateo.icon-presence-model.v1":
        raise ValueError("Unsupported icon presence model schema")
    if data["polynomial_degree"] != 3 or data["feature_mapping"] != "complete-cubic":
        raise ValueError("The model requires the complete cubic feature mapping")
    if (
        tuple(data["feature_names"]) != FEATURE_NAMES
        or tuple(data["input_feature_names"]) != BASE_NAMES
    ):
        raise ValueError(
            f"The model must contain all eight cues and all {len(FEATURE_NAMES)} terms in the fixed order"
        )
    for label in ("reference_diameter", "max_extent"):
        value = data[label]
        if (
            isinstance(value, bool)
            or not isinstance(value, (int, float))
            or not math.isfinite(value)
            or value <= 0
        ):
            raise ValueError(f"{label} must be positive and finite")
    if not data["reference_diameter"] <= data["max_extent"] <= FRAME:
        raise ValueError(
            "The reference diameter must fit inside the maximum extent and the 20-unit frame"
        )
    input_reference = _vector(data["input_reference_features"], 8, "Input reference")
    if np.any(input_reference[3:] != 0):
        raise ValueError("The five learned disk-reference log ratios must be exactly zero")
    _vector(data["input_feature_standard_deviations"], 8, "Input units", positive=True)
    reference = _vector(data["reference_features"], len(FEATURE_NAMES), "Expanded reference")
    if np.any(reference != 0):
        raise ValueError("The complete polynomial map must preserve an exactly zero reference")
    _vector(
        data["feature_standard_deviations"], len(FEATURE_NAMES), "Expanded units", positive=True
    )
    _vector(data["coefficients"], len(FEATURE_NAMES), "Shared coefficients")
    _vector(data["reference_layer_means"], 5, "Visual reference", positive=True)
    if (
        data["bound"] != math.log(1.2)
        or data["correction_gate"] != "ink-over-enclosure-and-dense-ink"
    ):
        raise ValueError("Unsupported correction bound or gate")
    dense_start = data["dense_ink_start"]
    reference_ink = (1 - input_reference[0]) * math.exp(-max(0.0, input_reference[2]))
    if (
        isinstance(dense_start, bool)
        or not isinstance(dense_start, (int, float))
        or not math.isfinite(dense_start)
        or not 0 <= dense_start < reference_ink <= 1
    ):
        raise ValueError("Dense ink transition must start below the reference disk ink fraction")
    if data["reference_authored_sha256"] != hashlib.sha256(REFERENCE_SOURCE.encode()).hexdigest():
        raise ValueError("The model must use the fixed 20-unit solid disk reference")
    context = data["canonical_context"]
    if (
        data["pixels_per_unit"] != PIXELS_PER_UNIT
        or context["canonicalization"] != "integrated"
        or context["canonical_extent_css_px"] != 20
        or context["button_css_px"] != 48
        or context["dpr"] != 2
        or context["native_canvas_pixels"] != 96
        or context["permanent_white_margin_pixels"] != 4
        or context["network_input_pixels"] != 104
        or tuple(map(tuple, context["phase_offsets_dy_dx"])) != PHASE_OFFSETS
        or context.get("symmetry_group") != "d4"
        or tuple(
            map(tuple, context["orientation_transforms_quarter_turns_and_horizontal_reflection"])
        )
        != SYMMETRIES
    ):
        raise ValueError(
            "The model requires the fixed 32-sample geometry, D4 symmetries and 16-phase visual context"
        )
    if set(data["weights"]) != {"backbone", "calibration"}:
        raise ValueError("The model requires exactly the backbone and calibration weights")
    for label in ("backbone", "calibration"):
        weight = data["weights"][label]
        if (
            Path(weight["filename"]).name != weight["filename"]
            or len(weight["sha256"]) != 64
            or any(c not in "0123456789abcdef" for c in weight["sha256"])
        ):
            raise ValueError("Model weights require a local basename and a full SHA-256 digest")
        if type(weight["bytes"]) is not int or weight["bytes"] <= 0:
            raise ValueError("Model weight byte counts must be positive integers")


def require_packages(data):
    for package, expected in data["packages"].items():
        try:
            actual = importlib.metadata.version(package)
        except importlib.metadata.PackageNotFoundError as error:
            raise ModelSetupError(
                f"Install the icon script requirements before preparing the model; missing {package}=={expected}"
            ) from error
        cpu_build = package in ("torch", "torchvision") and actual == f"{expected}+cpu"
        if actual != expected and not cpu_build:
            raise ModelSetupError(f"The icon model requires {package}=={expected}; found {actual}")


def verified_weight_paths(data, cache_dir=DEFAULT_CACHE):
    root = Path(cache_dir).expanduser().resolve()
    result = {}
    for label, weight in data["weights"].items():
        path = root / weight["filename"]
        if not path.is_file() or digest_file(path) != weight["sha256"]:
            raise ModelSetupError(
                f'Icon model weights are missing or invalid in {root}. Run prepare_optical_model.py --cache-dir "{root}" first.'
            )
        result[label] = path
    return result


def geometry_features(measurement):
    f = measurement.features
    try:
        values = [
            f["unoccupied_fraction"],
            math.log(f["diameter"] / f["axis_extent"]),
            math.log(f["filled_area"] / f["ink_area"]),
        ]
    except (KeyError, ZeroDivisionError, ValueError) as error:
        raise ValueError("Expected the existing finite base geometry measurement") from error
    return _vector(values, 3, "Base geometry")


def expand(raw8, reference8, scales8):
    """Apply the fixed 164-term complete cubic map in order."""
    raw = _vector(raw8, 8, "Raw cues")
    reference = _vector(reference8, 8, "Input reference")
    scales = _vector(scales8, 8, "Input units", positive=True)
    with np.errstate(over="raise", invalid="raise", divide="raise"):
        try:
            x = (raw - reference) / scales
            values = np.r_[x, x * x, [math.sqrt(2) * x[i] * x[j] for i, j in PAIRS]]
            values = np.r_[
                values,
                [
                    weight * x[i] * x[j] * x[k]
                    for (i, j, k), weight in zip(CUBIC_TRIPLES, CUBIC_WEIGHTS, strict=True)
                ],
            ]
        except FloatingPointError as error:
            raise ValueError("Polynomial feature expansion exceeded finite units") from error
    return _vector(values, len(FEATURE_NAMES), "Expanded cues")


def readout(raw8, data):
    """Evaluate the fixed correction; no drawing identity or output scale enters."""
    raw = _vector(raw8, 8, "Raw cues")
    features = expand(
        raw, data["input_reference_features"], data["input_feature_standard_deviations"]
    )
    activation = float(
        ((features - data["reference_features"]) / data["feature_standard_deviations"])
        @ data["coefficients"]
    )
    gate = math.exp(-max(0.0, float(raw[2])))
    correction = data["bound"] * gate * math.tanh(activation)
    if correction < 0:
        # A negative score correction enlarges the final drawing. Fade that
        # enlargement out for dense silhouettes, where ink already supplies
        # substantial visual weight. Recover ink / axis_extent² from the two
        # existing geometric ratios; do not classify drawings by identity.
        ink_fraction = (1 - float(raw[0])) * gate
        reference = data["input_reference_features"]
        reference_ink = (1 - reference[0]) * math.exp(-max(0.0, reference[2]))
        start = data["dense_ink_start"]
        progress = min(1.0, max(0.0, (ink_fraction - start) / (reference_ink - start)))
        correction *= 1 - progress * progress * (3 - 2 * progress)
    return correction


def _axis_bounds(profile, pixels_per_unit, origin):
    occupied = np.flatnonzero(profile > 0)
    first, last = int(occupied[0]), int(occupied[-1])
    values = profile[first : last + 1] / profile.max()
    prefix = np.maximum.accumulate(values)
    suffix = np.maximum.accumulate(values[::-1])[::-1]
    left = origin + (first + np.sum(1 - prefix)) / pixels_per_unit
    right = origin + (first + suffix.sum()) / pixels_per_unit
    return float(left), float(right)


def integrated_bounds(alpha, pixels_per_unit, origin=(0.0, 0.0)):
    """Use peak-normalized alpha-layer integrals for descriptor coordinates."""
    alpha = np.asarray(alpha, dtype=float)
    if (
        alpha.ndim != 2
        or min(alpha.shape, default=0) < 1
        or not np.isfinite(alpha).all()
        or alpha.min() < 0
        or alpha.max() > 1
        or alpha.max() <= 0
    ):
        raise ValueError("Expected a finite nonempty alpha field in [0,1]")
    if not math.isfinite(pixels_per_unit) or pixels_per_unit <= 0:
        raise ValueError("Descriptor sampling density must be positive and finite")
    if len(origin) != 2 or not all(math.isfinite(value) for value in origin):
        raise ValueError("Descriptor origin must have two finite coordinates")
    left, right = _axis_bounds(alpha.max(axis=0), pixels_per_unit, origin[0])
    top, bottom = _axis_bounds(alpha.max(axis=1), pixels_per_unit, origin[1])
    return left, top, right, bottom


def rendered_button(authored, peak_alpha, *, pixels_per_unit=PIXELS_PER_UNIT):
    """Render an explicit 48px descriptor field, clipping distant weak details."""
    if pixels_per_unit != PIXELS_PER_UNIT:
        raise ValueError("The fixed icon model requires 32 geometry samples per unit")
    if not math.isfinite(peak_alpha) or not 0 < peak_alpha <= 1:
        raise ValueError("The base measurement must supply a positive peak alpha in [0,1]")
    original = unwrap(authored)
    raw = render_alpha(original, pixels_per_unit=PIXELS_PER_UNIT)
    x0, y0, x1, y1 = integrated_bounds(raw.alpha, raw.pixels_per_unit, raw.origin)
    scale = FRAME / max(x1 - x0, y1 - y0)
    tx, ty = FRAME / 2 - scale * (x0 + x1) / 2, FRAME / 2 - scale * (y0 + y1) / 2
    rx0, ry0, rx1, ry1 = raw.bounds
    overflow = max(
        0.0,
        -(rx0 * scale + tx),
        -(ry0 * scale + ty),
        rx1 * scale + tx - FRAME,
        ry1 * scale + ty - FRAME,
    )
    padding = max(14.0, math.ceil(overflow * 2 + 2) / 2)
    raster = render_alpha(wrap(original, scale, tx, ty), pixels_per_unit=2, padding=padding)
    start = round((padding - 14) * 2)
    window = raster.alpha[start : start + 96, start : start + 96]
    if window.shape != (96, 96):
        raise ValueError("The descriptor field must match the fixed native pixel grid")
    alpha = np.clip(window / peak_alpha, 0, 1)
    yy, xx = np.indices(alpha.shape)
    inside = (xx + 0.5 - 48) ** 2 + (yy + 0.5 - 48) ** 2 <= 48**2
    background = np.where(inside, 245 / 255, 1.0)
    return background * (1 - alpha), background


def _phase_tensors(value, torch):
    functional = torch.nn.functional
    padded = functional.pad(value, (2,) * 4, value=1.0)
    height, width = value.shape[-2:]
    return torch.cat(
        [
            padded[:, :, 2 - dy : 2 - dy + height, 2 - dx : 2 - dx + width]
            for dy, dx in PHASE_OFFSETS
        ],
        dim=0,
    )


def _orient(value, turns, reflected, torch):
    result = torch.rot90(value, turns, dims=(-2, -1))
    return torch.flip(result, dims=(-1,)) if reflected else result


class LearnedPresence:
    """One frozen CPU network with serialized inference and a geometry cache."""

    def __init__(self, *, cache_dir=DEFAULT_CACHE, model_path=MODEL_PATH):
        self.data = read_model(model_path)
        require_packages(self.data)
        paths = verified_weight_paths(self.data, cache_dir)
        # These imports remain lazy so geometry tooling can read metadata and
        # diagnose missing setup without importing a neural-network runtime.
        import lpips
        import torch

        torch.set_num_threads(4)
        self._torch = torch
        self._lock = threading.RLock()
        self._layer_cache = OrderedDict()
        # Explicit random construction avoids every automatic weight-download
        # path. Both the backbone and calibration are replaced from verified
        # local files before any inference takes place.
        with torch.random.fork_rng(devices=[]):
            self._network = (
                lpips.LPIPS(
                    net="alex", version="0.1", pnet_rand=True, pretrained=False, verbose=False
                )
                .cpu()
                .eval()
            )
        backbone = torch.load(paths["backbone"], map_location="cpu", weights_only=True)
        expected = self._network.net.state_dict()
        mapped = {name: backbone["features." + name.split(".", 1)[1]] for name in expected}
        self._network.net.load_state_dict(mapped, strict=True)
        calibration = torch.load(paths["calibration"], map_location="cpu", weights_only=True)
        if set(calibration) != {f"lin{i}.model.1.weight" for i in range(5)}:
            raise ModelSetupError("The verified LPIPS bundle does not match the five-layer model")
        with torch.no_grad():
            for i in range(5):
                self._network.lins[i].model[1].weight.copy_(calibration[f"lin{i}.model.1.weight"])
        self._network.requires_grad_(False)
        self._network.pnet_rand = False
        self._reference = np.asarray(self.data["reference_layer_means"])
        observed = self.layer_means(REFERENCE_SOURCE, 1.0)
        if not np.allclose(observed, self._reference, rtol=1e-6, atol=1e-8):
            raise ModelSetupError(
                "Fresh disk inference differs from the fixed visual reference; check the pinned runtime and model files"
            )
        # Ratios use this runtime's validated disk so its reference remains exactly zero.
        self._reference = observed

    def layer_means(self, authored, peak_alpha):
        original = unwrap(authored)
        # Peak alpha is part of the numeric rendering input. Keeping it in the
        # cache key prevents a mismatched base measurement from reusing a cue.
        key = (hashlib.sha256(original.encode()).hexdigest(), float(peak_alpha))
        with self._lock:
            if key in self._layer_cache:
                self._layer_cache.move_to_end(key)
                return np.asarray(self._layer_cache[key])
            button, blank = rendered_button(original, peak_alpha)
            torch = self._torch
            images = np.stack((button, blank)).astype(np.float32)
            tensors = torch.from_numpy(images[:, None]).repeat(1, 3, 1, 1) * 2 - 1
            tensors = torch.nn.functional.pad(tensors, (4,) * 4, value=1.0)
            observations = []
            with torch.inference_mode():
                for turns, reflected in SYMMETRIES:
                    value = _orient(tensors[:1], turns, reflected, torch)
                    empty = _orient(tensors[1:], turns, reflected, torch)
                    total, layers = self._network(
                        _phase_tensors(value, torch), _phase_tensors(empty, torch), retPerLayer=True
                    )
                    values = torch.stack(layers, dim=-1).reshape(16, 5).numpy()
                    if not np.allclose(
                        values.sum(axis=1), total.reshape(-1).numpy(), rtol=1e-5, atol=1e-7
                    ):
                        raise ValueError(
                            "Canonical layer outputs do not sum to the full visual distance"
                        )
                    observations.append(values)
            # Orientation always precedes translation. Float64 accumulation
            # keeps a permuted D4 orbit from changing the averaged descriptor.
            array = np.concatenate(observations).astype(np.float64)
            means = array.mean(axis=0)
            if not np.isfinite(array).all() or not np.all(means > 0):
                raise ValueError(
                    "Every canonical visual layer must have a finite positive distance"
                )
            self._layer_cache[key] = tuple(float(value) for value in means)
            if len(self._layer_cache) > 512:
                self._layer_cache.popitem(last=False)
            return np.asarray(self._layer_cache[key])

    def verify_reference_geometry(self, base_measurement):
        expected = np.asarray(self.data["input_reference_features"])[:3]
        if not np.allclose(geometry_features(base_measurement), expected, rtol=1e-11, atol=1e-12):
            raise ValueError("Base geometry differs from the fixed solid-disk reference")

    def raw_features(self, authored, base_measurement, *, pixels_per_unit=PIXELS_PER_UNIT):
        if pixels_per_unit != PIXELS_PER_UNIT:
            raise ValueError("The fixed icon model requires 32 geometry samples per unit")
        means = self.layer_means(authored, base_measurement.features["peak_alpha"])
        return np.r_[geometry_features(base_measurement), np.log(means / self._reference)]


def get_model(*, cache_dir=DEFAULT_CACHE, model_path=MODEL_PATH):
    """Lazily initialize one process-wide model; inference never downloads files."""
    global _INSTANCE, _INSTANCE_KEY
    key = (
        str(Path(cache_dir).expanduser().resolve()),
        str(Path(model_path).expanduser().resolve()),
    )
    with _INSTANCE_LOCK:
        if _INSTANCE is None:
            instance = LearnedPresence(cache_dir=cache_dir, model_path=model_path)
            _INSTANCE, _INSTANCE_KEY = instance, key
        elif key != _INSTANCE_KEY:
            raise ValueError(
                "This process already initialized a different icon model or weight cache"
            )
    return _INSTANCE
