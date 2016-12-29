//
//  SEStatus.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface SEStatus : OFObject

@property OFString *buildVersion;
@property OFString *buildRevision;
@property OFString *buildTime;
@property OFString *osArchitecture;
@property OFString *osName;
@property OFString *osVersion;

-(id) initWithDictionary:(OFDictionary*)dict;

@end