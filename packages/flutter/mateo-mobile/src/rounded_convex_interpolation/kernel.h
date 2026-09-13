#ifndef MATEO_ROUNDED_CONVEX_KERNEL_H
#define MATEO_ROUNDED_CONVEX_KERNEL_H
#include <stddef.h>
#include "exports.h"
#ifdef __cplusplus
extern "C" {
#endif
MATEO_EXPORT void* mateo_create_checked(const double* a, size_t alen, const double* b, size_t blen,
                                        const double* pa, int na, size_t pacap, const double* pb,
                                        int nb, size_t pbcap, int rounded);
MATEO_EXPORT void* mateo_create_physical_checked(double aw, double ah, double bw, double bh,
                                                 const double* pa, int na, size_t pacap,
                                                 const double* pb, int nb, size_t pbcap);
MATEO_EXPORT const double* mateo_frame(void* handle, double progress, int* count);
MATEO_EXPORT size_t mateo_retained_bytes(void* handle);
MATEO_EXPORT void* mateo_reverse(void* handle);
MATEO_EXPORT void mateo_destroy(void* handle);
MATEO_EXPORT const char* mateo_error(void);
MATEO_EXPORT void* mateo_allocate(size_t count, size_t size);
MATEO_EXPORT void mateo_release(void* pointer);
#ifdef __cplusplus
}
#endif
#endif
