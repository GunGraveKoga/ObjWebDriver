#import <ObjFW/ObjFW.h>
#import "JWCapabilities.h"
#import "JWProxy.h"


@interface JWCapabilities()
{
	OFDictionary* _dict;
}

@end

@implementation SELCapabilities

@synthesize browserName = _browserName;
@synthesize version = _version;
@synthesize platform = _platform;
@synthesize javascriptEnabled = _javascriptEnabled;
@synthesize takeScreenshot = _takeScreenshot;
@synthesize handlesAlerts = _handlesAlerts;
@synthesize databaseEnabled = _databaseEnabled;
@synthesize locationContextEnabled = _locationContextEnabled;
@synthesize applicationCacheEnabled = _applicationCacheEnabled;
@synthesize browserConnectionEnabled = _browserConnectionEnabled;
@synthesize cssSelectorsEnabled = _cssSelectorsEnabled;
@synthesize webStorageEnabled = _webStorageEnabled;
@synthesize rotatable = _rotatable;
@synthesize acceptSslCerts = _acceptSslCerts;
@synthesize nativeEvents = _nativeEvents;
@synthesize proxy = _proxy;

- (instancetype) init
{
	OF_UNRECOGNIZED_SELECTOR
}

- (instancetype)initWithDictionary:(OFDictionary *)dict
{
	self = [super init];

	if (dict == nil)
		return self;

	_dict = [dict copy];

	OFIntrospection* inspector = [[OFIntrospection alloc] initWithClass:[self class]];

	OFArray* props = inspector.properties;

	OFArray* keys = [_dict allKeys];

	BOOL hasError = NO;

	@autoreleasepool {
		for (OFProperty* prop in props) {
			if ([keys containsObject:prop.name]) {

				id obj = [_dict objectForKey:prop.name];
				
				SEL sel = sel_registerName([prop.setter UTF8String]);

				if([obj isKindOfClass:[OFNumber class]]) {

					OFNumber* boolValue = (OFNumber *)obj;

					BOOL value = (BOOL)[boolValue boolValue];

					IMP impl = [[self class] instanceMethodForSelector:sel];

					impl(self, sel, value);

					continue;

				}

				if (![obj isKindOFClass:[OFString class]] && ![obj isKindOfClass:[SELProxy class]]) {
					hasError = YES;
					break;
				}

				[self performSelector:sel withObject:obj];
			}
		}
	}

	if (hasError) {
		[props release];
		[keys release];
		[inspector release];
		[self release];
		@throw [OFInvalidArgumentException exception];
	}

	return self;

}

+ (instancetype)capabilitiesWithDictionary:(OFDictionary *)dict
{
	return [[[self alloc] initWithDictionary:dict] autorelease];
}

@end