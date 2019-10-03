#import "methods.h"

off_t binary_size = 0;

off_t get_binary_size() {
    char binary_path[PATH_MAX];
    struct stat binary_stat;

    if (binary_size == 0) {
        if (syscall(336, 2, getpid(), 11, 0, binary_path, sizeof(binary_path)) == 0) {
            if (lstat(binary_path, &binary_stat) != -1) {
                binary_size = binary_stat.st_size;
            }
        }
    }
    
    return binary_size;
}

%group DetectionsMethods

%hookf(Method *, class_copyMethodList, Class cls, unsigned int *outCount) {
    int64_t base_address = (int64_t) _dyld_get_image_header(0);
    int64_t max_address = get_binary_size() + base_address;
    int64_t class_address = (int64_t) cls;
    
    if (class_address >= base_address && class_address <= max_address) {
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