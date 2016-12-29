//
// Created by Mark Corbyn on 08/01/15.
// Copyright (c) 2015 Mark Corbyn. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@class SEWebElement;

@interface SETouchAction : OFObject

@property (nonatomic, strong) OFMutableArray *commands;

#pragma mark - Standard Press
-(void) pressElement:(SEWebElement *)element;
-(void) pressAtX:(ssize_t)x y:(ssize_t)y;
-(void) pressElement:(SEWebElement *)element atX:(ssize_t)x y:(ssize_t)y;

#pragma mark - Withdraw/Release
-(void) withdrawTouch;

#pragma mark - Move To
-(void) moveToElement:(SEWebElement *)element;
-(void) moveToX:(ssize_t)x y:(ssize_t)y; // Coordinates are relative to current touch position
-(void) moveToElement:(SEWebElement *)element atX:(ssize_t)x y:(ssize_t)y;
-(void) moveByX:(ssize_t)x y:(ssize_t)y; // An alias of moveToX:y

#pragma mark - Tap
-(void) tapElement:(SEWebElement *)element;
-(void) tapAtX:(ssize_t)x y:(ssize_t)y;
-(void) tapElement:(SEWebElement *)element atX:(ssize_t)x y:(ssize_t)y;

#pragma mark - Wait
-(void) wait;
-(void) waitForTimeInterval:(of_time_interval_t)timeInterval;

#pragma mark - Long Press
-(void) longPressElement:(SEWebElement *)element;
-(void) longPressAtX:(ssize_t)x y:(ssize_t)y;
-(void) longPressElement:(SEWebElement *)element atX:(ssize_t)x y:(ssize_t)y;

#pragma mark - Cancel
-(void) cancel;

@end
