#import "classes.h"

const int classCount = 46;
const char *classes[] = {
    "SCOthmanPrefs",
    "SCOthmanSnapSaver",
    "SCOFiltersOthman",
    "SCSnapchPrefs",
    "SCSnapchLocation",
    "SCOFiltersSnapch",
    "PHSnapSaver",
    "PHRegisterViewController",
    "phlite",
    "dfnvrknsv",
    "PHSSaver",
    "PHMainSettingsVC",
    "SCPPrivacySettings",
    "SCPSettings",
    "SCPSavedMediaSettings",
    "SNAPCHAT_SCPSnapUsageSettings",
    "SNAPCHAT_SCPSegmentedController",
    "SNAPCHAT_CZPickerView",
    "CTAdBase",
    "CTRequestModel",
    "CTBannerView",
    "CPAdManager",
    "MMNativeAdController",
    "TweakBoxStartupManager",
    "SNAPCHAT_GPHelper",
    "SCKsausaPrefs",
    "SCSCGoodSnapSaver",
    "SNAPCHAT_XXXXXXX_GPHelper",
    "SCOFiltersHelper",
    "_xxx",
    "PHSSaver",
    "SIGMAPOINT_GPHelper",
    "SCS     SnapSaver",
    "SCW    wSnapSaver",
    "CYJSObject",
    "P         D",
    "R              t",
    "AVCameraViewControlIer",
    "SCAppDeIegate",
    "FLEXManager",
    "oJXM",
    "fJWs",
    "yytp",
    "FLManager",
    "DecryptScriptAlertView",
    "DzAdsManager"
};

%group DetectionsClasses

%hookf(id, objc_getClass, const char* name) {
    for (int i = 0; i < classCount; i++) {
        if (strstr(name, classes[i]) != 0) {
            // NSLog(@"[SnapHide] > Denied objc_getClass of %s, was actually %p", name, %orig(name));
            return 0;
        }
    }

    return %orig(name);
}

%end

void loadClassHooks() {
    // NSLog(@"[SnapHide] Loading class hooks.");
    %init(DetectionsClasses);
}