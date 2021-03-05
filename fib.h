#pragma once

#ifdef _WIN32
#ifdef _BUILD
#define _EXTERN __declspec(dllexport)
#else
#define _EXTERN __declspec(dllimport)
#endif
#elif __GNUC__ >= 4
#define _EXTERN __attribute__((visibility("default")))
#else
#define _EXTERN
#endif

_EXTERN int fib(int number);
