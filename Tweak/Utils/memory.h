#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <mach/mach.h>
#import <dlfcn.h>
#import <substrate.h>

void scan_executable_memory(const uint8_t *, const uint32_t, void (*)(uint8_t *));

// Based on https://gist.github.com/Razzile/e06957b1dc6e865b7d8377f8afe96554.
typedef void (*mshookmemory_t)(void *target, const void *data, size_t size);

bool hook_memory(void *target, const void *data, size_t size);