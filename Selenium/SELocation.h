//
//  SELocation.h
//  Selenium
//
//  Created by Khyati Dave on 3/25/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface SELocation : OFObject


@property float latitude;
@property float longitude;
@property float altitude;


-(id) initWithDictionary:(OFDictionary*)dict;

@end
