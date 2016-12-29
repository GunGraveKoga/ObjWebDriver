//
// Created by Mark Corbyn on 08/01/15.
// Copyright (c) 2015 Mark Corbyn. All rights reserved.
//

#import "SETouchActionCommand.h"

@interface SETouchActionCommand ()

@end

@implementation SETouchActionCommand {
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.options = [OFMutableDictionary dictionary];
    }
    return self;
}

-(instancetype) initWithName:(OFString *)name
{
    self = [self init];
    if (!self) return nil;

    self.name = name;

    return self;
}

-(void) addParameterWithKey:(OFString *)keyName value:(id)value
{
    self.options[keyName] = value;
}


@end