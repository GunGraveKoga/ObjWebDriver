#import <ObjFW/OFObject.h>

@class OFString;
@class OFNumber;
@class OFDate;

@interface JWCookie: OFObject
{

}

@property (copy)OFString* name;
@property (copy)OFString* value;
@property (copy)OFString* path;
@property (copy)OFString* domain;
@property BOOL secure;
@property BOOL httpOnly;
@property (copy)OFDate* expiry;

@end