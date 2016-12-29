//
//  SECapabilities.h
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface SECapabilities : OFObject

@property OFString* browserName;
@property OFString* version;
@property OFString* platform;
@property BOOL javascriptEnabled;
@property BOOL takesScreenShot;
@property BOOL handlesAlerts;
@property BOOL databaseEnabled;
@property BOOL locationContextEnabled;
@property BOOL applicationCacheEnabled;
@property BOOL browserConnectionEnabled;
@property BOOL cssSelectorsEnabled;
@property BOOL webStorageEnabled;
@property BOOL rotatable;
@property BOOL acceptSslCerts;
@property BOOL nativeEvents;
// TODO: add proxy object

@property OFString *app;
@property OFString *automationName;
@property OFString *deviceName;
@property OFString *platformName;
@property OFString *platformVersion;

-(id) initWithDictionary:(OFDictionary*)dict;
-(id) getCapabilityForKey:(OFString*)key;
-(void) addCapabilityForKey:(OFString*)key andValue:(id)value;
-(OFDictionary*) dictionary;

@end
