#import "methods.h"

%group DetectionsMethods

%hookf(Method *, class_copyMethodList, Class cls, unsigned int *outCount) {
    int64_t link_register = 0;
    __asm ("MOV %[output], LR" : [output] "=r" (link_register));
    
    if (is_in_process((int64_t) cls) == 0 && is_in_process(link_register) == 0) {
        // NSLog(@"[SnapHide] > Hiding method for class %s", [NSStringFromClass(cls) UTF8String]);
        *outCount = 0;
        return (Method *) calloc(1, sizeof(void *));
    }

    return %orig(cls, outCount);
}

%end

void loadMethodHooks() {
    // NSLog(@"[SnapHide] Loading method hooks.");
    %init(DetectionsMethods);
}