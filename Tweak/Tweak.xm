#import "Detections/dyld.h"
#import "Detections/symbols.h"
#import "Detections/classes.h"
#import "Detections/files.h"
#import "Detections/codesign.h"
#import "Detections/methods.h"

%ctor {
	loadDyldHooks();
	loadSymbolHooks();
	loadClassHooks();
	loadFileHooks();
	loadCodesignHooks();
	loadMethodHooks();
}