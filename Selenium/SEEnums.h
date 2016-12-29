//
//  SEEnums.h
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "STBImage.h"
#import "OFError.h"

#if TARGET_OS_IPHONE
#define POINT_TYPE CGPoint
#define SIZE_TYPE CGSize
#define IMAGE_TYPE UIImage
#define POINT_TYPE_MAKE CGPointMake
#define SIZE_TYPE_MAKE CGSizeMake
#import <UIKit/UIKit.h>
#else
#define POINT_TYPE of_point_t
#define SIZE_TYPE of_dimension_t
#define IMAGE_TYPE STBImage
#define POINT_TYPE_MAKE of_point
#define SIZE_TYPE_MAKE of_dimension
#endif


@interface SEEnums : OFObject

typedef enum seleniumScreenOrientationTypes
{
	SELENIUM_SCREEN_ORIENTATION_PORTRAIT,
	SELENIUM_SCREEN_ORIENTATION_LANDSCAPE,
	SELENIUM_SCREEN_ORIENTATION_UNKOWN
} SEScreenOrientation;

typedef enum seleniumTimeoutTypes
{
	SELENIUM_TIMEOUT_IMPLICIT,
	SELENIUM_TIMEOUT_SCRIPT,
	SELENIUM_TIMEOUT_PAGELOAD
} SETimeoutType;


typedef enum seleniumApplicationCacheStatusTypes
{
    SELENIUM_APPLICATION_CACHE_STATUS_UNCACHED,
    SELENIUM_APPLICATION_CACHE_STATUS_IDLE,
    SELENIUM_APPLICATION_CACHE_STATUS_CHECKING,
    SELENIUM_APPLICATION_CACHE_STATUS_DOWNLOADING,
    SELENIUM_APPLICATION_CACHE_STATUS_UPDATE_READY,
    SELENIUM_APPLICATION_CACHE_STATUS_OBSOLETE
} SEApplicationCacheStatus;

typedef enum seleniumMouseButtonTypes
{
	SELENIUM_MOUSE_LEFT_BUTTON = 0,
	SELENIUM_MOUSE_MIDDLE_BUTTON = 1,
	SELENIUM_MOUSE_RIGHT_BUTTON = 2
} SEMouseButton;


typedef enum seleniumLogTypes
{
    SELENIUM_LOG_TYPE_CLIENT,
    SELENIUM_LOG_TYPE_DRIVER,
    SELENIUM_LOG_TYPE_BROWSER,
    SELENIUM_LOG_TYPE_SERVER
}SELogType;

+(OFString*) stringForTimeoutType:(SETimeoutType)type;
+(SEApplicationCacheStatus) applicationCacheStatusWithInt:(ssize_t)applicationCacheStatusInt;
+(ssize_t) intForMouseButton:(SEMouseButton)button;
+(OFString*) stringForLogType:(SELogType)logType;

@end
