#ifndef MATEO_ROUNDED_CONVEX_PATH_H
#define MATEO_ROUNDED_CONVEX_PATH_H

#include <stddef.h>
#include "exports.h"

#ifdef __cplusplus
extern "C" {
#endif

MATEO_EXPORT void* mateo_path_create(void);
MATEO_EXPORT void mateo_path_destroy(void* handle);
MATEO_EXPORT size_t mateo_path_retained_bytes(void* handle);
MATEO_EXPORT const float* mateo_path_prepare(void* handle, const double* points, int count,
                                             double left, double top, double width, double height,
                                             double tolerance, int* output_count);

#ifdef __cplusplus
}
#endif

#endif
