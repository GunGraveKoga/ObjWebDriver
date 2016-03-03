#import <ObjFW/OFObject.h>

@class OFDictionary;

@interface JWError: OFObject
{

}

@property (readonly)int32_t code;
@property (copy, readonly) OFString* message;

+ (instancetype)errorWithCode:(int32_t)code;
+ (instancetype)errorWithDictionary:(OFDictionary *)dict;

@end