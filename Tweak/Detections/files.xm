#import "files.h"

const int allowedPathsCount = 2;
const char *allowedPaths[] = {
    "/Snapchat.app/Snapchat",
    "/Snapchat.app/PlugIns"
};

int32_t sysAccessHook(const char *path) {
    for (int i = 0; i < allowedPathsCount; i++) {
        if (ends_with(path, allowedPaths[i]) != 0) {
            // NSLog(@"[SnapHide] Allowed %s", path);
            return 0;
        }
    }

    // NSLog(@"[SnapHide] Denied  %s", path);

    return -1;
}

// Hook idea from https://stackoverflow.com/a/45283531.
void hookAccessSyscallCallback(uint8_t* match) {
    uint8_t patch[] = {
        0x63, 0x00, 0x00, 0x58, // LDR X3, .+12
        0x60, 0x00, 0x3F, 0xD6, // BLR X3
        0x03, 0x00, 0x00, 0x94, // BL #12
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00
    };

    *(int32_t (**)(const char *))(patch + 12) = sysAccessHook;

    MSHookMemory(match, patch, sizeof(patch));

    // NSLog(@"[SnapHide] Hooked sys_access at %p", match);
}

void hookAccessSyscall() {
    const uint8_t target[] = {
        0x01, 0x00, 0x80, 0xD2, // MOV  X1, #0
		0x30, 0x04, 0x80, 0xD2, // MOV  X16, #0x21
        0x01, 0x10, 0x00, 0xD4, // SVC  0x80
        0x00, 0x00, 0x80, 0x92, // MOV  X0, #0xFFFFFFFFFFFFFFFF
        0x00, 0x20, 0x9F, 0x9A  // CSEL X0, X0, XZR, CS
	};

	scan_executable_memory(target, sizeof(target), &hookAccessSyscallCallback);
}

void loadFileHooks() {
    hookAccessSyscall();
}
