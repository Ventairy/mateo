# Performance and accessibility

`mateo_mobile` exclusively targets Android and iOS, with low-end mobile devices
as a design baseline. Keep swipe-feed builders lazy, bound cached windows,
avoid expensive work in paint/build paths, and precache only assets needed by
the current screen. Generated raster namespace precaching is sequential to
limit decode pressure.

Respect text scaling, safe areas, platform navigation expectations, reduced
motion preferences, and semantic labels. Test unbounded and narrow layouts for
reusable widgets, not only flagship phone dimensions.
