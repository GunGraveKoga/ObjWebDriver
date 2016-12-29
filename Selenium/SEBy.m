//
//  SEBy.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SEBy.h"

@implementation SEBy

-(id) initWithLocationStrategy:(OFString*)locationStrategy value:(OFString*)value
{
    self = [super init];
    if (self) {
        [self setLocationStrategy:locationStrategy];
		[self setValue:value];
    }
    return self;
}

+(SEBy*) className:(OFString*)className
{
	return [[SEBy alloc] initWithLocationStrategy:@"class name" value:className];
}

+(SEBy*) cssSelector:(OFString*)cssSelector
{
	return [[SEBy alloc] initWithLocationStrategy:@"css selector" value:cssSelector];
}

+(SEBy*) idString:(OFString*)idString
{
	return [[SEBy alloc] initWithLocationStrategy:@"id" value:idString];
}

+(SEBy*) name:(OFString*)name
{
	return [[SEBy alloc] initWithLocationStrategy:@"name" value:name];
}

+(SEBy*) linkText:(OFString*)linkText
{
	return [[SEBy alloc] initWithLocationStrategy:@"link text" value:linkText];
}

+(SEBy*) partialLinkText:(OFString*)partialLinkText
{
	return [[SEBy alloc] initWithLocationStrategy:@"partial link text" value:partialLinkText];
}

+(SEBy*) tagName:(OFString*)tagName
{
	return [[SEBy alloc] initWithLocationStrategy:@"tag name" value:tagName];
}

+(SEBy*) xPath:(OFString*)xPath
{
	return [[SEBy alloc] initWithLocationStrategy:@"xpath" value:xPath];
}

+(SEBy*) accessibilityId:(OFString*)accessibilityId
{
	return [[SEBy alloc] initWithLocationStrategy:@"accessibility id" value:accessibilityId];
}

+(SEBy*) androidUIAutomator:(OFString*)uiAutomatorExpression
{
	return [[SEBy alloc] initWithLocationStrategy:@"-android uiautomator" value:uiAutomatorExpression];
}


+(SEBy*) iOSUIAutomation:(OFString*)uiAutomationExpression
{
	return [[SEBy alloc] initWithLocationStrategy:@"-ios uiautomation" value:uiAutomationExpression];
}

@end
