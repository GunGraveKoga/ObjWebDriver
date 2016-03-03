#import <ObjFW/OFObject.h>

@class OFString;
@class OFDictionary;

@interface JWProxy: OFObject
{

}

@property (copy)OFString* proxyType;
@property (copy)OFString* proxyAutoconfigUrl;
@property (copy)OFString* ftpProxy;
@property (copy)OFString* httpProxy;
@property (copy)OFString* sslProxy;
@property (copy)OFString* socksProxy;
@property (copy)OFString* sockUserName;
@property (copy)OFString* sockPassword;
@property (copy)OFString* noProxy;

- (instancetype)initWithDictionary:(OFDictionary *)dict;
+ (instancetype)proxyWithDictionary:(OFDictionary *)dict;

@end