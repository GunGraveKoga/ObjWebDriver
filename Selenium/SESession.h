//
//  SESession.h
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "SECapabilities.h"

@interface SESession : OFObject

@property SECapabilities *capabilities;
@property OFString *sessionId;

-(id) initWithDictionary:(OFDictionary*)dict;

@end
