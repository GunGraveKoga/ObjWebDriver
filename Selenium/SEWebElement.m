//
//  SEWebElement.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SEWebElement.h"

@interface SEWebElement ()
        @property SEJsonWireClient *jsonWireClient;
@end

@implementation SEWebElement

-(id) initWithOpaqueId:(OFString*)opaqueId jsonWireClient:(SEJsonWireClient*)jsonWireClient session:(OFString*)sessionId
{
    self = [super init];
    if (self) {
        [self setOpaqueId:opaqueId];
                [self setJsonWireClient:jsonWireClient];
                [self setSessionId:sessionId];
    }
    return self;
}

-(void) click
{
	OFError *error;
	[self clickAndReturnError:&error];
    [self.jsonWireClient addError:error];
}

-(void) clickAndReturnError:(OFError**)error
{
        [self.jsonWireClient postClickElement:self session:self.sessionId error:error];
}

-(void) submit
{
	OFError *error;
	[self submitAndReturnError:&error];
    [self.jsonWireClient addError:error];
}

-(void) submitAndReturnError:(OFError**)error
{
        [self.jsonWireClient postSubmitElement:self session:self.sessionId error:error];
}

-(OFString*) text
{
	OFError *error;
	OFString *text = [self textAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return text;
}

-(OFString*) textAndReturnError:(OFError**)error
{
        return [self.jsonWireClient getElementText:self session:self.sessionId error:error];
}

-(void) sendKeys:(OFString*)keyString
{
	OFError *error;
	[self sendKeys:keyString error:&error];
    [self.jsonWireClient addError:error];
}

-(void) sendKeys:(OFString*)keyString error:(OFError**)error
{
	of_unichar_t keys[keyString.length+1];
	for(size_t i=0; i < keyString.length; i++)
		keys[i] = [keyString characterAtIndex:i];
	keys[keyString.length] = '\0';
	return [self.jsonWireClient postKeys:keys element:self session:self.sessionId error:error];
}

-(OFString*) tagName
{
	OFError *error;
	OFString *tagName = [self tagNameAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return tagName;
}

-(OFString*) tagNameAndReturnError:(OFError**)error
{
        return [self.jsonWireClient getElementName:self session:self.sessionId error:error];
}

-(void) clear
{
	OFError *error;
	[self clearAndReturnError:&error];
    [self.jsonWireClient addError:error];
}

-(void) clearAndReturnError:(OFError**)error
{
        [self.jsonWireClient postClearElement:self session:self.sessionId error:error];
}

-(BOOL) isSelected
{
	OFError *error;
	return [self isSelectedAndReturnError:&error];
}

-(BOOL) isSelectedAndReturnError:(OFError**)error
{
	return [self.jsonWireClient getElementIsSelected:self session:self.sessionId error:error];
}

-(BOOL) isEnabled
{
	OFError *error;
	return [self isEnabledAndReturnError:&error];
}

-(BOOL) isEnabledAndReturnError:(OFError**)error
{
	return [self.jsonWireClient getElementIsEnabled:self session:self.sessionId error:error];
}

-(OFString*) attribute:(OFString*)attributeName
{
	OFError *error;
	OFString *attribute = [self attribute:attributeName error:&error];
    [self.jsonWireClient addError:error];
    return attribute;
}

-(OFString*) attribute:(OFString*)attributeName error:(OFError**)error
{
        return [self.jsonWireClient getAttribute:attributeName element:self session:self.sessionId error:error];
}

-(BOOL) isEqualToElement:(SEWebElement*)element
{
	OFError *error;
	BOOL result = [self isEqualToElement:element error:&error];
    [self.jsonWireClient addError:error];
    return result;
}

-(BOOL) isEqualToElement:(SEWebElement*)element error:(OFError**)error
{
        return [self.jsonWireClient getEqualityForElement:self element:element session:self.sessionId error:error];
}

-(BOOL) isDisplayed
{
	OFError *error;
	BOOL isDisplayed = [self isDisplayedAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return isDisplayed;
}

-(BOOL) isDisplayedAndReturnError:(OFError**)error
{
        return [self.jsonWireClient getElementIsDisplayed:self session:self.sessionId error:error];
}

-(POINT_TYPE) location
{
        OFError *error;
    POINT_TYPE location = [self locationAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return location;
}

-(POINT_TYPE) locationAndReturnError:(OFError**)error
{
        return [self.jsonWireClient getElementLocation:self session:self.sessionId error:error];
}

-(POINT_TYPE) locationInView
{
	OFError *error;
	POINT_TYPE locationInView = [self locationInViewAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return locationInView;
}

-(POINT_TYPE) locationInViewAndReturnError:(OFError**)error
{
        return [self.jsonWireClient getElementLocationInView:self session:self.sessionId error:error];
}

-(SIZE_TYPE) size
{
	OFError *error;
	SIZE_TYPE size = [self sizeAndReturnError:&error];
    [self.jsonWireClient addError:error];
    return size;
}

-(SIZE_TYPE) sizeAndReturnError:(OFError**)error
{
        return [self.jsonWireClient getElementSize:self session:self.sessionId error:error];
}

-(OFString*) cssProperty:(OFString*)propertyName
{
	OFError *error;
	OFString *property = [self cssProperty:propertyName error:&error];
    [self.jsonWireClient addError:error];
    return property;
}

-(OFString*) cssProperty:(OFString*)propertyName error:(OFError**)error
{
        return [self.jsonWireClient getCSSProperty:propertyName element:self session:self.sessionId error:error];
}

-(SEWebElement*) findElementBy:(SEBy*)by
{
	OFError *error;
	SEWebElement *element = [self findElementBy:by error:&error];
    [self.jsonWireClient addError:error];
    return element;
}

-(SEWebElement*) findElementBy:(SEBy*)by error:(OFError**)error
{
        SEWebElement *element = [self.jsonWireClient postElementFromElement:self by:by session:self.sessionId error:error];
    return element != nil && element.opaqueId != nil ? element : nil;
}

-(OFArray*) findElementsBy:(SEBy*)by
{
	OFError *error;
	OFArray *elements = [self findElementsBy:by error:&error];
    [self.jsonWireClient addError:error];
    return elements;
}

-(OFArray*) findElementsBy:(SEBy*)by error:(OFError**)error
{
        OFArray *elements = [self.jsonWireClient postElementsFromElement:self by:by session:self.sessionId error:error];
    if (elements == nil || elements.count < 1) {
        return [OFArray new];
    }
    SEWebElement *element = [elements objectAtIndex:0];
    if (element == nil || element.opaqueId == nil) {
        return [OFArray new];
    }
    return elements;
}

-(OFDictionary*)elementJson
{
	OFDictionary* json = [[OFDictionary alloc] initWithKeysAndObjects:@"ELEMENT", self.opaqueId, nil];
	return json;
}

-(void) setValue:(OFString*)value {
    [self setValue:value isUnicode:NO];
}

-(void) setValue:(OFString*)value isUnicode:(BOOL)isUnicode {
    OFError *error;
    [self setValue:value isUnicode:isUnicode error:&error];
    [self.jsonWireClient addError:error];
}

-(void) setValue:(OFString*)value isUnicode:(BOOL)isUnicode error:(OFError**)error
{
    [self.jsonWireClient postSetValueForElement:self value:value isUnicode:isUnicode session:self.sessionId error:error];
}

-(void) replaceValue:(OFString*)value element:(SEWebElement*)element {
    [self replaceValue:value element:element isUnicode:NO];
}

-(void) replaceValue:(OFString*)value element:(SEWebElement*)element isUnicode:(BOOL)isUnicode {
    OFError *error;
    [self replaceValue:value isUnicode:isUnicode error:&error];
    [self.jsonWireClient addError:error];
}

-(void) replaceValue:(OFString*)value isUnicode:(BOOL)isUnicode error:(OFError**)error
{
    [self.jsonWireClient postReplaceValueForElement:self value:value isUnicode:isUnicode session:self.sessionId error:error];
}

@end
