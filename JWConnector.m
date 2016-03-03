#import <ObjFW/ObjFW.h>
#import "JWConnector.h"

@interface JWConnector()
{
	OFURL* _baseURL;
	OFHTTPClient* _client;
}

@end


@implementation JWConnector

@synthesize host = _host;
@synthesize port = _port;

- (instancetype)init
{
	OF_UNRECOGNIZED_SELECTOR
}

- (instancetype)initWithHost:(OFString *)host port:(uint16_t)port
{
	self = [super init];

	_host = [host copy];
	_port = port;

	_baseURL = [OFURL new];
	_baseURL.host = self.host;
	_baseURL.port = self.port;
	_baseURL.path = [@[@"wd", @"hub"] componentsJoinedByString: @"/"];

	_client = [OFHTTPClient new];

	return self;
}

+ (instancetype)connectorWithHost:(OFString *)host port:(uint16_t)port
{
	return [[[self alloc] initWithHost:host port:port] autorelease];
}


- (OFDictionary *)performGetRequestToPath:(OFString *)path
{
	void* pool = objc_autoreleasePoolPush();

	OFURL* url = [OFURL URLWithString:path relativeToURL:_baseURL];

	OFHTTPRequest* request = [OFHTTPRequest requestWithURL:url];

	request.method = OF_HTTP_REQUEST_METHOD_GET;

	OFHTTPResponse* response = nil;

	@try {
		response = [_client performRequest:request];
	} @catch (id e) {
		of_log(@"Exception on GET request:\r\n%@\r\nURL:%@\r\nRequest:%@\r\nResponse:%@", e, url, ([e isKindOfClass:[OFHTTPRequestFailedException class]]) ? ((OFHTTPRequestFailedException *)e).request : request, ([e isKindOfClass:[OFHTTPRequestFailedException class]]) ? ((OFHTTPRequestFailedException *)e).response : response);
		objc_autoreleasePoolPop(pool);
		return nil;
	}

	id result = [[response string] JSONValue];

	if (result != nil && [result isKindOfClass:[OFDictionary class]]) {
		OFDictionary* answer = (OFDictionary *)result;
		[answer retain];
		objc_autoreleasePoolPop(pool);
		return [answer autorelease];
	} else {
		of_log(@"Unxpected result!\r\n%@", result);
		objc_autoreleasePoolPop(pool);
		@throw [OFException exception];
	}

	return nil;
}

- (OFDictionary *)performPostRequestToPath:(OFString *)path postData:(OFDictionary *)data
{
	void* pool = objc_autoreleasePoolPush();

	OFURL* url = [OFURL URLWithString:path relativeToURL:_baseURL];

	OFHTTPRequest* request = [OFHTTPRequest requestWithURL:url];

	request.method = OF_HTTP_REQUEST_METHOD_POST;

	if (data == nil)
		data = [OFDictionary dictionary];

	OFDictionary* headers = @{
		@"Accept": @"application/json, image/png",
		@"Content-Type": @"application/json;charset=utf-8"
	};

	request.headers = headers;

	OFMutableString* body = [OFMutableString string];
	BOOL firstPair = YES;

	@autoreleasepool {
		for (OFString* key in [data allKeys]) {
			if (firstPair) {
				[body appendFormat:@"%@=%@", key, [data objectForKey:key]];
				firstPair = NO;
			}

			[body appendFormat:@"&%@=%@", key, [data objectForKey:key]];
		}
	}

	[body makeImmutable];

	OFDataArray* bodyData = [OFDataArray dataArray];
	[bodyData addItems:[body UTF8String] count:[body UTF8StringLength]];

	request.body = bodyData;

	OFHTTPResponse* response = nil;

	@try {
		response = [_client performRequest:request];
	}@catch (id e) {
		of_log(@"Exception on POST request:\r\n%@\r\nURL:%@\r\nRequest:%@\r\nResponse:%@", e, url, ([e isKindOfClass:[OFHTTPRequestFailedException class]]) ? ((OFHTTPRequestFailedException *)e).request : request, ([e isKindOfClass:[OFHTTPRequestFailedException class]]) ? ((OFHTTPRequestFailedException *)e).response : response);
		objc_autoreleasePoolPop(pool);
		return nil;
	}

	id result = [[response string] JSONValue];

	if (result != nil && [result isKindOfClass:[OFDictionary class]]) {
		OFDictionary* answer = (OFDictionary *)result;
		[answer retain];
		objc_autoreleasePoolPop(pool);
		return [answer autorelease];
	} else {
		of_log(@"Unxpected result!\r\n%@", result);
		objc_autoreleasePoolPop(pool);
		@throw [OFException exception];
	}

	return nil;

}

- (OFDictionary *)performDeleteRequestToPath:(OFString *)path
{
	void* pool = objc_autoreleasePoolPush();

	OFURL* url = [OFURL URLWithString:path relativeToURL:_baseURL];

	OFHTTPRequest* request = [OFHTTPRequest requestWithURL:url];

	request.method = OF_HTTP_REQUEST_METHOD_DELETE;

	OFHTTPResponse* response = nil;

	@try {
		response = [_client performRequest:request];
	} @catch (id e) {
		of_log(@"Exception on GET request:\r\n%@\r\nURL:%@\r\nRequest:%@\r\nResponse:%@", e, url, ([e isKindOfClass:[OFHTTPRequestFailedException class]]) ? ((OFHTTPRequestFailedException *)e).request : request, ([e isKindOfClass:[OFHTTPRequestFailedException class]]) ? ((OFHTTPRequestFailedException *)e).response : response);
		objc_autoreleasePoolPop(pool);
		return nil;
	}

	id result = [[response string] JSONValue];

	if (result != nil && [result isKindOfClass:[OFDictionary class]]) {
		OFDictionary* answer = (OFDictionary *)result;
		[answer retain];
		objc_autoreleasePoolPop(pool);
		return [answer autorelease];
	} else {
		of_log(@"Unxpected result!\r\n%@", result);
		objc_autoreleasePoolPop(pool);
		@throw [OFException exception];
	}

	return nil;



}

- (void)client: (OFHTTPClient*)client didCreateSocket: (OFTCPSocket*)socket request: (OFHTTPRequest*)request
{
	of_log(@"Client %@ connected to socket %@ to perform request %@", client, socket, request);
}
    
- (void)client: (OFHTTPClient*)client didReceiveHeaders: (OFDictionary OF_GENERIC(OFString*, OFString*)*)headers statusCode: (int)statusCode request: (OFHTTPRequest*)request
{
	of_log(@"Client %@ recived headers %@ with HTTP status %d of request %@", client, headers, statusCode, request);
}
    
- (bool)client: (OFHTTPClient*)client shouldFollowRedirect: (OFURL*)URL statusCode: (int)statusCode request: (OFHTTPRequest*)request
{
	of_log(@"Client %@ redirect to %@ (HTTP %d) for request %@", client, URL, statusCode, request);
}

- (void)dealloc
{
	[_baseURL release];
	[_client release];
	[_host release];
	[_port release];

	[super dealloc];
}

@end