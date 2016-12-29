//
// Created by Mark Corbyn on 08/01/15.
// Copyright (c) 2015 Mark Corbyn. All rights reserved.
//

#import <ObjFW/ObjFW.h>


@interface SETouchActionCommand : OFObject

@property (nonatomic, copy) OFString *name;
@property (nonatomic, strong) OFMutableDictionary *options;

-(instancetype) initWithName:(OFString *)name;

-(void) addParameterWithKey:(OFString *)keyName value:(id)value;

@end