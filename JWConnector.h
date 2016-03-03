#import <ObjFW/OFObject.h>
#import <ObjFW/OFHTTPClient.h>

@class OFDictionary;
@class OFString;
@class OFURL;

@interface JWConnector: OFObject<OFHTTPClientDelegate>
{

}

@property (copy, readonly) OFString* host;
@property (readonly) uint16_t port;

- (instancetype)initWithHost:(OFString *)host port:(uint16_t)port;
+ (instancetype)connectorWithHost:(OFString *)host port:(uint16_t)port;

- (OFDictionary *)performGetRequestToPath:(OFString *)path;
- (OFDictionary *)performPostRequestToPath:(OFString *)path postData:(OFDictionary *)data;
- (OFDictionary *)performDeleteRequestToPath:(OFString *)path;

@end