#import "Detections/dyld.h"
#import "Detections/symbols.h"
#import "Detections/classes.h"
#import "Detections/files.h"
#import "Detections/codesign.h"
#import "Detections/methods.h"

%group SnapchatCheck

%hook SCApplicationState

-(void)appDidFinishLaunching {
    %orig;
    
	UIAlertView *alert = [[UIAlertView alloc] 
		initWithTitle:@"SnapHide"
        message:@"Loaded successfully."
        delegate:self
        cancelButtonTitle:@"Close"
        otherButtonTitles:nil];

    [alert show];
}

%end

%end

%ctor {
	loadDyldHooks();
	loadSymbolHooks();
	loadClassHooks();
	loadFileHooks();
	loadCodesignHooks();
	loadMethodHooks();

    %init(SnapchatCheck);
}