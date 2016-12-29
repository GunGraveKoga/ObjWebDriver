//
//  SEStatus.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SEStatus.h"

@implementation SEStatus

-(id) initWithDictionary:(OFDictionary*)dict
{
	self = [super init];
    if (self) {
		OFDictionary *value = [dict objectForKey:@"value"];
		
		OFDictionary *build = [value objectForKey:@"build"];
		[self setBuildVersion:[build objectForKey:@"version"]];
		[self setBuildRevision:[build objectForKey:@"revision"]];
		[self setBuildTime:[build objectForKey:@"time"]];
		
		OFDictionary *os = [value objectForKey:@"os"];
		[self setOsArchitecture:[os objectForKey:@"arch"]];
		[self setOsName:[os objectForKey:@"name"]];
		[self setOsVersion:[os objectForKey:@"version"]];
    }
    return self;
}

@end
