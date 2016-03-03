#import <ObjFW/ObjFW.h>
#import "SELProxy.h"

@implementation JWProxy

@synthesize proxyType = _proxyType;
@synthesize proxyAutoconfigUrl = _proxyAutoconfigUrl;
@synthesize ftpProxy = _ftpProxy;
@synthesize httpProxy = _httpProxy;
@synthesize sslProxy = _sslProxy;
@synthesize socksProxy = _socksProxy;
@synthesize sockUserName = _sockUserName;
@synthesize sockPassword = _sockPassword;
@synthesize noProxy = _noProxy;

- (instancetype)init
{
	OF_UNRECOGNIZED_SELECTOR
}

- (instancetype)initWithDictionary:(OFDictionary *)dict
{
	self = [super init];

	if (dict == nil)
		return self;

	OFDictionary* _dict = [dict copy];
	OFArray* keys = [_dict allKeys];
	OFIntrospection* inspector = [[OFIntrospection alloc] initWithClass:[self class]];

	OFArray* props = inspector.properties;

	BOOL hasError = NO;

	@autoreleasepool {
		for (OFProperty* prop in props) {
			if ([keys containsObject:prop.name]) {

				id obj = [_dict objectForKey:prop.name];

				if (![obj isKindOfClass:[OFString class]]) {
					hasError = YES;
					break;
				}

				SEL sel = sel_registerName([prop.setter UTF8String]);

				[self performSelector:sel withObject:obj];
				continue;
			}
		}
	}

	if (hasError) {
		[props release];
		[inspector release];
		[keys release];
		[_dict release];
		[self release];

		@throw [OFInvalidArgumentException exception];
	}

	return self;
}

+ (instancetype)proxyWithDictionary:(OFDictionary *)dict
{
	return [[[self alloc] initWithDictionary:dict] autorelease];
}

@end