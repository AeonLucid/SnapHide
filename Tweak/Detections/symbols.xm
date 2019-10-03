#import "symbols.h"

const int symbolsHideCount = 11;
const char *symbolsHide[] = {
    "MSHookMessageEx",
    "MSHookFunction",
    "_Z17replaced_readlinkPKcPcm",
    "hooksArray",
    "_OBJC_METACLASS_$__xxx",
    "_OBJC_CLASS_$_PHSSaverV2",
    "plist",
    "flexBreakPoint",
    "convert_coordinates_from_device_to_interface",
    "OBJC_METACLASS_$_DzSnapHelper",
    "ChKey2"
};

const int symbolsFakeCount = 8;
const char *symbolsFake[] = {
    "dlsym",
    "objc_getClass",
    "class_getInstanceMethod",
    "sel_registerName",
    "class_copyMethodList",
    "_dyld_image_count",
    "_dyld_get_image_header",
    "dladdr"
};

const uint8_t fakePrologue[] = {
    0xff, 0xc3, 0x02, 0xd1 // SUB SP, SP, #0xB0
};

bool dlsymReal = true;

void *(*orig_dlsym)(void *, const char *);

void *hooked_dlsym(void *handle, const char *symbol) {
    int64_t link_register = 0;
    __asm ("MOV %[output], LR" : [output] "=r" (link_register));

    if (is_in_process(link_register) == 0) {
        for (int i = 0; i < symbolsHideCount; i++) {
            if (strcmp(symbol, symbolsHide[i]) == 0) {
                // NSLog(@"[SnapHide] > Denied dlsym of %s, was actually %p", symbol, orig_dlsym(handle, symbol));
                return 0;
            }
        }

        if (strstr(symbol, "dlsym") != 0) {
            if (dlsymReal) {
                dlsymReal = false;
                // NSLog(@"[SnapHide] > Replaced dlsym of %s", symbol);
                return (void *)&hooked_dlsym;
            }

            dlsymReal = true;
        }

        for (int i = 0; i < symbolsFakeCount; i++) {
            if (strcmp(symbol, symbolsFake[i]) == 0) {
                // NSLog(@"[SnapHide] > Need to fake %s", symbol);
                return (void *) fakePrologue;
            }
        }
    }

    return orig_dlsym(handle, symbol);
}

void loadSymbolHooks() {
    // NSLog(@"[SnapHide] Loading symbol hooks.");
	MSHookFunction(&dlsym, &hooked_dlsym, &orig_dlsym);
    // NSLog(@"[SnapHide] Hooked dlsym.");
}