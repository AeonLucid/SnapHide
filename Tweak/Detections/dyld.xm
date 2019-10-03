#import "dyld.h"

extern const char** environ;

uint32_t dyldCount = 0;
char **dyldNames = 0;
struct mach_header **dyldHeaders = 0;

void syncDyldArray() {
    uint32_t count = _dyld_image_count();
    uint32_t counter = 0;
    
    // NSLog(@"[SnapHide] There are %u images", count);

    dyldNames = (char **) calloc(count, sizeof(char **));
    dyldHeaders = (struct mach_header **) calloc(count, sizeof(struct mach_header **));

    for (int i = 0; i < count; i++) {
        const char *charName = _dyld_get_image_name(i);
        if (!charName) {
            continue;
        }

        NSString *name = [NSString stringWithUTF8String: charName];
        if (!name) {
            continue;
        }

        NSString *lower = [name lowercaseString];
        if ([lower containsString:@"tweakinject"] ||
            [lower containsString:@"cephei"] ||
            [lower containsString:@"substrate"] ||
            [lower containsString:@"substitute"] ||
            [lower containsString:@"applist"] ||
            [lower containsString:@"rocketbootstrap"] ||
            [lower containsString:@"colorpicker"] ||
            [lower containsString:@"frida"] ||
            [lower containsString:@"flex"]) {
                // NSLog(@"[SnapHide] > Hidden %@", name);
                continue;
            }

        uint32_t idx = counter++;
        
        dyldNames[idx] = strdup(charName);
        dyldHeaders[idx] = (struct mach_header *) _dyld_get_image_header(i);
    }

    dyldCount = counter;
}

void hijackEnvironment() {
    const struct mach_header_64 *header = (const struct mach_header_64*) _dyld_get_image_header(0);
    const struct section_64 *section = getsectbynamefromheader_64(header, "__DATA", "__got");

    const intptr_t startAddress = (intptr_t) header + section->offset;
    const intptr_t endAddress = startAddress + section->size;
    const intptr_t target = (intptr_t) environ;

    char ****environStolen = 0;

    for (uint64_t current = startAddress; current < endAddress; current += 8) {
        intptr_t *ptrOne = *(intptr_t **)current;
        if (ptrOne != 0) {
            intptr_t ptrTwo = *ptrOne;
            if (ptrTwo == target) {
                environStolen = (char ****) current;
                break;
            }
        }
    }

    if (environStolen == 0) {
        // NSLog(@"[SnapHide] Failed to hijack environ.");
        return;
    }

    int environSize = 0;
    char** ogEnviron = **environStolen;

    while (ogEnviron[environSize]) {
        // char *entry = ogEnviron[environSize++];
        // NSLog(@"[SnapHide] %s", entry);
        environSize++;
    }

    char** newEnviron = (char **) malloc((environSize + 1) * sizeof(char *));
    int newEnvironCounter = 0;

    for (int i = 0; i < environSize; i++) {
        char *entry = ogEnviron[i];
        const char needle[22] = "DYLD_INSERT_LIBRARIES";

        if (strstr(entry, needle) != 0 || entry[0] == '_') {
            continue;
        }

        newEnviron[newEnvironCounter++] = entry;
    }

    newEnviron[newEnvironCounter] = 0;

    char*** newEnvironPtr = (char***) malloc(sizeof(char***));
    *newEnvironPtr = newEnviron;
    *environStolen = newEnvironPtr;

    // NSLog(@"[SnapHide] Hijacked environment.");
}

%group DetectionsDYLD

%hookf(uint32_t, _dyld_image_count) {
    return dyldCount;
}

%hookf(const char *, _dyld_get_image_name, uint32_t image_index) {
    return dyldNames[image_index];
}

%hookf(struct mach_header *, _dyld_get_image_header, uint32_t image_index) {
    return dyldHeaders[image_index];
}

%hookf(kern_return_t, task_info, task_name_t target_task, task_flavor_t flavor, task_info_t task_info_out, mach_msg_type_number_t *task_info_outCnt) {
    if (flavor == TASK_DYLD_INFO) {
        kern_return_t ret = %orig(target_task, flavor, task_info_out, task_info_outCnt);

        if (ret == KERN_SUCCESS) {
            struct task_dyld_info *task_info = (struct task_dyld_info *) task_info_out;
            struct dyld_all_image_infos *dyld_info = (struct dyld_all_image_infos *) task_info->all_image_info_addr;

            dyld_info->infoArrayCount = 1;
        }

        return ret;
    }

    return %orig(target_task, flavor, task_info_out, task_info_outCnt);
}

%end

void loadDyldHooks() {
    // NSLog(@"[SnapHide] Loading dyld hooks.");

    syncDyldArray();
    hijackEnvironment();
    %init(DetectionsDYLD);
}