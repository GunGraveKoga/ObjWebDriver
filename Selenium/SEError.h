//
//  SEError.h
//  Selenium
//
//  Created by Dan Cuellar on 3/16/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "OFError.h"

@interface SEError : OFError

+(SEError*) errorWithCode:(ssize_t)code;
+(SEError*) errorWithResponseDict:(OFDictionary*)dict;

+(SEError*) success;
+(SEError*) noSuchDriver;
+(SEError*) noSuchElement;
+(SEError*) noSuchFrame;
+(SEError*) unknownCommand;
+(SEError*) staleElementReference;
+(SEError*) elementNotVisible;
+(SEError*) invalidElementState;
+(SEError*) unknownError;
+(SEError*) elementIsNotSelectable;
+(SEError*) javaScriptError;
+(SEError*) xpathLookupError;
+(SEError*) timeout;
+(SEError*) noSuchWindow;
+(SEError*) invalidCookieDomain;
+(SEError*) unableToSetCookie;
+(SEError*) unexpectedAlertOpen;
+(SEError*) noAlertOpenError;
+(SEError*) scriptTimeout;
+(SEError*) invalidElementCoordinates;
+(SEError*) imeNotAvailable;
+(SEError*) imeEngineActivationFailed;
+(SEError*) invalidSelector;
+(SEError*) sessionNotCreatedException;
+(SEError*) moveTargetOutOfBounds;

@end
