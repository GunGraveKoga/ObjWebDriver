//
//  SEUtility.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@class OFError;

@interface SEUtility : OFObject

+(OFDictionary*) performGetRequestToUrl:(OFString*)urlString error:(OFError**)error;
+(OFDictionary*) performPostRequestToUrl:(OFString*)urlString postParams:(OFDictionary*)postParams error:(OFError**)error;
+(OFDictionary*) performDeleteRequestToUrl:(OFString*)urlString error:(OFError**)error;
+(OFHTTPCookie*) cookieWithJson:(OFDictionary*)json;

@end
