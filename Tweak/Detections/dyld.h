#import <mach-o/dyld.h>
#import <mach-o/dyld_images.h>
#import <mach-o/getsect.h>
#import <mach/task.h>
#import <dlfcn.h>
#import <substrate.h>
#import "../Utils/process.h"

void loadDyldHooks();