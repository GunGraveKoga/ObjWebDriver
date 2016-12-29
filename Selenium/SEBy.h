//
//  SEBy.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface SEBy : OFObject

@property OFString *locationStrategy;
@property OFString *value;

-(id) initWithLocationStrategy:(OFString*)locationStrategy value:(OFString*)value;

+(SEBy*) className:(OFString*)className;
+(SEBy*) cssSelector:(OFString*)cssSelector;
+(SEBy*) idString:(OFString*)idString;
+(SEBy*) name:(OFString*)name;
+(SEBy*) linkText:(OFString*)linkText;
+(SEBy*) partialLinkText:(OFString*)partialLinkText;
+(SEBy*) tagName:(OFString*)tagName;
+(SEBy*) xPath:(OFString*)xPath;

+(SEBy*) accessibilityId:(OFString*)accessibilityId;
+(SEBy*) androidUIAutomator:(OFString*)uiAutomatorExpression;
+(SEBy*) iOSUIAutomation:(OFString*)uiAutomationExpression;

@end
