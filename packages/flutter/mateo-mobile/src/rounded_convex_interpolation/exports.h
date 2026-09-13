#ifndef MATEO_ROUNDED_CONVEX_EXPORTS_H
#define MATEO_ROUNDED_CONVEX_EXPORTS_H

#if defined(_WIN32)
#define MATEO_EXPORT __declspec(dllexport)
#else
#define MATEO_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

#endif
