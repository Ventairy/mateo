"""Bounded light-background appearance evidence for static artwork sizing.

Encoded-channel RMS contrast is design calibration, not a perceptual color
space or a fitted human-size predictor. Alpha still owns physical bounds and
placement. RGB is sampled after SVG painting, so hidden paint is irrelevant.
"""

import math

import numpy as np


def smooth_progress(value, interval):
    low, high = interval
    progress = min(1.0, max(0.0, (value - low) / (high - low)))
    return progress * progress * (3 - 2 * progress)


def appearance(raster, model):
    """Return normalized size coverage and bounded absolute contrast evidence."""
    alpha = raster.alpha / float(raster.alpha.max())
    # Composite on white after removing only global authored opacity. For this
    # reference, RMS(1 - composite RGB) equals alpha * RMS(1 - straight RGB).
    difference = (255 - raster.rgb.astype(np.float64)) / 255
    contrast = alpha * np.sqrt(
        np.einsum("...c,c->...", difference * difference, model["appearance_channel_weights"])
    )
    peak = float(contrast.max())
    mass = float(contrast.sum())
    amplitude = float(np.square(contrast).sum() / mass) if mass > 0 else 0.0
    confidence = smooth_progress(amplitude, model["appearance_contrast_range"])

    # Saturation keeps ordinary black glyphs on their established calibration,
    # irrespective of the fraction of antialiased edge pixels they contain.
    shoulder = smooth_progress(amplitude, model["appearance_saturation_range"])
    calibrated_amplitude = amplitude + (1 - amplitude) * shoulder
    if confidence == 0:
        coverage = alpha
    else:
        # Normalize by distributed contrast, not its brightest single pixel.
        # A tiny dark accent must not halve the rest of a colored body's weight.
        normalized_contrast = np.minimum(contrast / min(peak, calibrated_amplitude), 1)
        coverage = (1 - confidence) * alpha + confidence * normalized_contrast
        # Color gradients can have many more levels than 8-bit alpha. Keep
        # topology/span integration bounded at the same density as the renderer.
        levels = model["appearance_levels"]
        coverage = np.rint(np.clip(coverage, 0, 1) * levels) / levels

    log_correction = max(
        -math.log(model["appearance_max_enlargement"]),
        model["appearance_weight"] * math.log(max(calibrated_amplitude, 1e-15)),
    ) * confidence
    return coverage, dict(
        contrast_peak=peak,
        contrast_amplitude=amplitude,
        contrast_effective_amplitude=calibrated_amplitude,
        contrast_confidence=confidence,
        color_presence_factor=math.exp(log_correction),
    )
