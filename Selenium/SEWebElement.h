//
//  SEWebElement.h
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "SEJsonWireClient.h"
#import "SEBy.h"
#import "SEEnums.h"
#import "OFError.h"

@class SEJsonWireClient;
@class SEBy;

@interface SEWebElement : OFObject

@property OFString *opaqueId;
@property OFString *sessionId;
@property (readonly) OFString *text;
@property (readonly) BOOL isDisplayed;
@property (readonly) BOOL isEnabled;
@property (readonly) BOOL isSelected;
@property (readonly) POINT_TYPE location;
@property (readonly) POINT_TYPE locationInView;
@property (readonly) SIZE_TYPE size;
@property (readonly) OFDictionary *elementJson;

-(id) initWithOpaqueId:(OFString*)opaqueId jsonWireClient:(SEJsonWireClient*)jsonWireClient session:(OFString*)sessionId;

-(void) click;
-(void) clickAndReturnError:(OFError**)error;
-(void) submit;
-(void) submitAndReturnError:(OFError**)error;
-(OFString*) text;
-(OFString*) textAndReturnError:(OFError**)error;
-(void) sendKeys:(OFString*)keyString;
-(void) sendKeys:(OFString*)keyString error:(OFError**)error;
-(OFString*) tagName;
-(OFString*) tagNameAndReturnError:(OFError**)error;
-(void) clear;
-(void) clearAndReturnError:(OFError**)error;
-(BOOL) isSelected;
-(BOOL) isSelectedAndReturnError:(OFError**)error;
-(BOOL) isEnabled;
-(BOOL) isEnabledAndReturnError:(OFError**)error;
-(OFString*) attribute:(OFString*)attributeName;
-(OFString*) attribute:(OFString*)attributeName error:(OFError**)error;
-(BOOL) isEqualToElement:(SEWebElement*)element;
-(BOOL) isEqualToElement:(SEWebElement*)element error:(OFError**)error;
-(BOOL) isDisplayed;
-(BOOL) isDisplayedAndReturnError:(OFError**)error;
-(POINT_TYPE) location;
-(POINT_TYPE) locationAndReturnError:(OFError**)error;
-(POINT_TYPE) locationInView;
-(POINT_TYPE) locationInViewAndReturnError:(OFError**)error;
-(SIZE_TYPE) size;
-(SIZE_TYPE) sizeAndReturnError:(OFError**)error;
-(OFString*) cssProperty:(OFString*)propertyName;
-(OFString*) cssProperty:(OFString*)propertyName error:(OFError**)error;

-(SEWebElement*) findElementBy:(SEBy*)by;
-(SEWebElement*) findElementBy:(SEBy*)by error:(OFError**)error;
-(OFArray*) findElementsBy:(SEBy*)by;
-(OFArray*) findElementsBy:(SEBy*)by error:(OFError**)error;

-(OFDictionary*)elementJson;

-(void) setValue:(OFString*)value;
-(void) setValue:(OFString*)value isUnicode:(BOOL)isUnicode;
-(void) setValue:(OFString*)value isUnicode:(BOOL)isUnicode error:(OFError**)error;

-(void) replaceValue:(OFString*)value element:(SEWebElement*)element;
-(void) replaceValue:(OFString*)value element:(SEWebElement*)element isUnicode:(BOOL)isUnicode;
-(void) replaceValue:(OFString*)value isUnicode:(BOOL)isUnicode error:(OFError**)error;

@end
