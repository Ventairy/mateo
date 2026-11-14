"""Continuous enclosure cues for rasterized monochrome icon geometry.

Gaussian filtering makes narrow openings contribute gradually. Grayscale hole
filling then raises each basin only to its lowest escape barrier. This is a
geometry cue, not a fitted model of perceived size or a binary topology test.
"""

import math

import numpy as np
from scipy import ndimage
from scipy.spatial import ConvexHull, QhullError, distance
from skimage.morphology import reconstruction

_CONNECTIVITY = ndimage.generate_binary_structure(2, 1)


def _coverage(image):
    image = np.asarray(image, dtype=np.float64)
    if (
        image.ndim != 2
        or min(image.shape, default=0) < 2
        or not np.isfinite(image).all()
        or image.min() < 0
        or image.max() > 1
    ):
        raise ValueError("Expected a finite 2D alpha field between zero and one")
    return image


def soft_fill(image):
    """Return the minimum escape-barrier height at every pixel.

    For every path from a pixel to the image boundary, find its maximum value;
    take the minimum of these maxima. Paths use four neighboring pixels. This
    is grayscale reconstruction by erosion, preserving unclosed valleys and
    changing continuously with their barrier height. No alpha threshold is used.
    """
    image = _coverage(image)
    seed = np.full_like(image, image.max())
    seed[0], seed[-1] = image[0], image[-1]
    seed[:, 0], seed[:, -1] = image[:, 0], image[:, -1]
    return reconstruction(seed, image, method="erosion", footprint=_CONNECTIVITY)


def layer_span(alpha, pixels_per_unit):
    """Integrate occupied width, height, and maximum Feret over all alpha cuts.

    Normalize by peak alpha, then integrate every interval between its exact
    observed values. A partially opaque appendage contributes proportionally;
    crossing any particular opacity never adds its whole contour at once.
    Each sample occupies a square pixel cell. Widths are exact for that raster
    representation; curved vector contours converge with sampling resolution.
    """
    alpha = _coverage(alpha)
    if (
        not isinstance(pixels_per_unit, (int, float))
        or not math.isfinite(pixels_per_unit)
        or pixels_per_unit <= 0
    ):
        raise ValueError("pixels_per_unit must be finite and positive")
    ys, xs = np.nonzero(alpha > 0)
    if not len(xs):
        raise ValueError("Icon has no visible area")
    levels, inverse = np.unique(alpha[ys, xs], return_inverse=True)
    # The renderer supplies at most 255 positive coverage values. Retain exact
    # values instead of binning them; bound accidental use on huge float fields.
    if len(levels) > 4096:
        raise ValueError("Layer span exceeds 4096 distinct alpha values")
    levels = levels / levels[-1]
    intervals = np.diff(np.r_[0.0, levels])
    order = np.argsort(inverse, kind="stable")
    offsets = np.r_[0, np.cumsum(np.bincount(inverse))]
    points = np.column_stack((xs, ys)).astype(np.float64)[order]
    hull = np.empty((0, 2))
    widths = np.zeros(2)
    diameter = 0.0
    for index in range(len(levels) - 1, -1, -1):
        candidates = np.concatenate((hull, points[offsets[index] : offsets[index + 1]]))
        if len(candidates) > 2:
            try:
                hull = candidates[ConvexHull(candidates).vertices]
            except QhullError:
                # Collinear pixel centers are valid; their cells still have area.
                axis = int(np.argmax(np.ptp(candidates, axis=0)))
                hull = candidates[[np.argmin(candidates[:, axis]), np.argmax(candidates[:, axis])]]
        else:
            hull = candidates
        widths += intervals[index] * (np.ptp(hull, axis=0) + 1)
        # Hull(pixel cells) = hull(centers) + a unit square. For a center-pair
        # difference (dx,dy), the farthest cell corners are (|dx|+1,|dy|+1).
        squared = distance.pdist(hull, "sqeuclidean") + 2 * distance.pdist(hull, "cityblock") + 2
        layer_diameter = math.sqrt(float(squared.max())) if squared.size else math.sqrt(2)
        diameter += intervals[index] * layer_diameter
    width, height = widths / pixels_per_unit
    return dict(
        width=float(width),
        height=float(height),
        axis_extent=float(max(width, height)),
        diameter=float(diameter / pixels_per_unit),
    )


def closure_measure(alpha, pixels_per_unit, *, sigmas=(0.35, 0.7, 1.4)):
    """Return enclosure size, spread, and body centroids in input-field units.

    ``sigmas`` are Gaussian standard deviations in the caller's SVG units;
    ``pixels_per_unit`` converts those units to samples. The caller supplies
    geometry at a canonical extent if source-scale invariance is required.
    Each Gaussian width has equal weight. No icon names, component counts,
    convex hulls, or binary hole counts affect this measure.
    """
    alpha = _coverage(alpha)
    if (
        not isinstance(pixels_per_unit, (int, float))
        or not math.isfinite(pixels_per_unit)
        or pixels_per_unit <= 0
    ):
        raise ValueError("pixels_per_unit must be finite and positive")
    sigmas = tuple(sigmas)
    if not sigmas or any(
        not isinstance(s, (int, float)) or not math.isfinite(s) or s <= 0 for s in sigmas
    ):
        raise ValueError("Gaussian widths must be finite and positive")
    weights = np.asarray([1.0] * len(sigmas), dtype=np.float64)
    weights = weights / weights.sum()
    occupied = alpha > 0
    xs = np.flatnonzero(occupied.any(axis=0))
    ys = np.flatnonzero(occupied.any(axis=1))
    if not len(xs):
        raise ValueError("Icon has no visible area")
    cropped = alpha[ys[0] : ys[-1] + 1, xs[0] : xs[-1] + 1]
    padding = math.ceil(5 * max(sigmas) * pixels_per_unit) + 1
    if max(cropped.shape) + 2 * padding > 4096:
        raise ValueError("Enclosure raster exceeds the 4096px side limit")
    field = np.pad(cropped, padding)
    pixel_area = 1 / pixels_per_unit**2
    ink_area = float(field.sum() * pixel_area)
    if not math.isfinite(ink_area) or ink_area <= 0:
        raise ValueError("Icon has no finite measurable area")
    filled_areas, body_spreads, distributed_holes, body_centers = [], [], [], []
    for sigma in sigmas:
        blurred = ndimage.gaussian_filter(
            field, sigma * pixels_per_unit, mode="constant", truncate=5
        )
        # A positive normalized kernel stays in [0, 1] mathematically; remove
        # convolution roundoff such as 1.0000000000000002 on solid interiors.
        np.clip(blurred, 0, 1, out=blurred)
        # Padding retains the Gaussian integral. Reconstruction is extensive;
        # max removes only floating-point error at the ink-area lower bound.
        filled = soft_fill(blurred)
        filled_area_at_scale = max(ink_area, float(filled.sum() * pixel_area))
        filled_areas.append(filled_area_at_scale)
        yy, xx = np.indices(filled.shape, dtype=float)
        mass = float(filled.sum())
        body_centers.append((
            float(((xx + .5) * filled).sum() / mass + xs[0] - padding) / pixels_per_unit,
            float(((yy + .5) * filled).sum() / mass + ys[0] - padding) / pixels_per_unit,
        ))
        body_variance, body_determinant = _spatial_moments(filled, pixels_per_unit)
        body_spreads.append(math.sqrt(body_variance))
        holes = np.maximum(filled - blurred, 0)
        added_area = float(holes.sum() * pixel_area)
        distribution = 0.0
        if added_area > 0:
            _, hole_determinant = _spatial_moments(holes, pixels_per_unit)
            # A covariance ellipse's linear scale is det(covariance) ** 1/4.
            # A small local cavity must not resize the whole enclosing symbol.
            distribution = min(1.0, (hole_determinant / body_determinant) ** 0.25)
        distributed_holes.append(added_area * distribution)
    filled_area = max(ink_area, float(np.dot(weights, filled_areas)))
    return dict(
        ink_area=ink_area,
        filled_area=filled_area,
        closure=1 - ink_area / filled_area,
        filled_areas=tuple(filled_areas),
        body_spreads=tuple(body_spreads),
        body_centers=tuple(body_centers),
        distributed_enclosure=float(np.dot(weights, distributed_holes)) / filled_area,
    )


def _spatial_moments(field, pixels_per_unit):
    """Return radial variance and covariance determinant of fractional cells."""
    mass = float(field.sum())
    yy, xx = np.indices(field.shape, dtype=float)
    cx, cy = float((xx * field).sum() / mass), float((yy * field).sum() / mass)
    # Each sample occupies a square cell, not a dimensionless point. This also
    # keeps the determinant positive for one-pixel and collinear coverage.
    cell_variance = 1 / (12 * pixels_per_unit**2)
    vx = float(((xx - cx) ** 2 * field).sum() / mass) / pixels_per_unit**2 + cell_variance
    vy = float(((yy - cy) ** 2 * field).sum() / mass) / pixels_per_unit**2 + cell_variance
    vxy = float(((xx - cx) * (yy - cy) * field).sum() / mass) / pixels_per_unit**2
    return vx + vy, max(vx * vy - vxy**2, cell_variance**2)


def ink_concentration(alpha, pixels_per_unit):
    """Measure packed ink relative to its covariance-equivalent ellipse.

    A uniformly filled ellipse approaches one; separated or spread-out strokes
    occupy less of their moment ellipse. Peak normalization removes opacity as
    a sizing cue. Covariance makes the measurement orientation-independent.
    """
    alpha = _coverage(alpha)
    if (
        not isinstance(pixels_per_unit, (int, float))
        or not math.isfinite(pixels_per_unit)
        or pixels_per_unit <= 0
    ):
        raise ValueError("Expected positive finite sampling density")
    peak = float(alpha.max())
    if peak <= 0:
        raise ValueError("Icon has no visible area")
    normalized = alpha / peak
    area = float(normalized.sum()) / pixels_per_unit**2
    _, determinant = _spatial_moments(normalized, pixels_per_unit)
    return min(1.0, area / (4 * math.pi * math.sqrt(determinant)))


def detached_ink_fraction(alpha):
    """Integrate ink outside the largest connected piece over all alpha cuts.

    Each cut uses four-neighbor connectivity. Integrating every observed alpha
    interval lets a faint piece or bridge contribute gradually, without choosing
    one opacity threshold. Overlapping source paths are measured as one drawing.
    """
    alpha = _coverage(alpha)
    levels = np.unique(alpha)
    levels = levels[levels > 0]
    if not len(levels):
        raise ValueError("Icon has no visible area")
    if len(levels) > 4096:
        raise ValueError("Detached ink exceeds 4096 distinct alpha values")
    intervals = np.diff(np.r_[0.0, levels / levels[-1]])
    detached = 0.0
    for level, interval in zip(levels, intervals, strict=True):
        labels, _ = ndimage.label(alpha >= level, structure=_CONNECTIVITY)
        areas = np.bincount(labels.ravel())[1:]
        detached += float(interval) * (1 - float(areas.max()) / float(areas.sum()))
    return detached
