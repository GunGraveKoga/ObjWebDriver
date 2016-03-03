#import <ObjFW/OFObject.h>

@class OFString;
@class OFDictionary;
@class JWProxy;


@interface JWCapabilities: OFObject
{

}

@property (copy)OFString* browserName;
@property (copy)OFString* version;
@property (copy)OFString* platform;
@property BOOL javascriptEnabled;
@property BOOL takeScreenshot;
@property BOOL handlesAlerts;
@property BOOL databaseEnabled;
@property BOOL locationContextEnabled;
@property BOOL applicationCacheEnabled;
@property BOOL browserConnectionEnabled;
@property BOOL cssSelectorsEnabled;
@property BOOL webStorageEnabled;
@property BOOL rotatable;
@property BOOL acceptSslCerts;
@property BOOL nativeEvents;
@property (retain) JWProxy* proxy;

- (instancetype)initWithDictionary:(OFDictionary *)dict;
+ (instancetype)capabilitiesWithDictionary:(OFDictionary *)dict;

@end