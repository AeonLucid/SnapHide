#import "codesign.h"

void hookCodesignStatusCallback(uint8_t* match) {
    const uint8_t patch[] = {
        0x21, 0x60, 0x86, 0x52, // MOV  W1, #0x3301
        0x01, 0x40, 0xA4, 0x72, // MOVK W1, #0x2200, LSL#16
        0x41, 0x00, 0x00, 0xF9, // STR  X1, [X2]
        0x00, 0x00, 0x80, 0xD2, // MOV  X0, #0
        0x00, 0x00, 0x80, 0xD2  // MOV  X0, #0
	};

    MSHookMemory(match + 8, patch, sizeof(patch));
    // NSLog(@"[SnapHide] Hooked sys_csops at %p", match);
}

void hookCodesignStatus() {
    const uint8_t target[] = {
		0x01, 0x00, 0x80, 0xD2, // MOV x1, #0
        0xFF, 0xFF, 0xFF, 0xFF, // 
        0x03, 0x00, 0x80, 0xD2, // MOV x3, #0
        0x30, 0x15, 0x80, 0xD2, // MOV x16, #169
        0x01, 0x10, 0x00, 0xD4  // SVC 0x80
    };

	scan_executable_memory(target, sizeof(target), &hookCodesignStatusCallback);
}

void loadCodesignHooks() {
    hookCodesignStatus();
}
