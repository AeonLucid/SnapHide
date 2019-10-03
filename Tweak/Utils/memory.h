#import <mach-o/dyld.h>
#import <mach-o/getsect.h>

void scan_executable_memory(const uint8_t *, const uint32_t, void (*)(uint8_t *));