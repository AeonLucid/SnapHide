#import "methods.h"

const int methodCount = 6;
const char *methods[] = {
    "NSMutableString a",
    "NSMutableString b",
    "NSMutableString c",
    "SCAppDelegate MZ42SGH98C:",
    "SCOperaPageViewController saveButtonPressed",
    "UIViewController dzDidTapGalleryButton"
};

%group DetectionsMethods

%hookf(Method *, class_getInstanceMethod, Class cls, SEL selector) {
    int64_t link_register = 0;
    __asm ("MOV %[output], LR" : [output] "=r" (link_register));

    if (is_in_process(link_register) == 0) {
        const char *clazzMethod = [[NSString stringWithFormat:@"%@ %@", 
            NSStringFromClass(cls), 
            NSStringFromSelector(selector)] UTF8String];

        for (int i = 0; i < methodCount; i++) {
            if (strstr(clazzMethod, methods[i]) != 0) {
                // NSLog(@"[SnapHide] > Hiding '%s'", clazzMethod);
                return NULL;
            }
        }
    }

    return %orig(cls, selector);
}

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