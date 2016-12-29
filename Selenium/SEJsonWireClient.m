//
//  SEJsonWireClient.m
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/OFURL.h>
#import "SEJsonWireClient.h"
#import "SEUtility.h"
#import "SEStatus.h"
#import "SETouchAction.h"
#import "SETouchActionCommand.h"



@interface SEJsonWireClient ()
	@property (readonly) OFString *httpCommandExecutor;
	@property OFString *serverAddress;
	@property ssize_t serverPort;
@end

@implementation SEJsonWireClient

-(id) initWithServerAddress:(OFString*)address port:(ssize_t)port error:(OFError**)error
{
    self = [super init];
    if (self) {
        [self setServerAddress:address];
        [self setServerPort:port];
        [self setErrors:[OFMutableArray new]];

        // get status
        [self getStatusAndReturnError:error];
        if ([*error code] != 0)
            return nil;
    }
    return self;
}

-(void)addError:(OFError*)error
{
    if (error == nil || error.code == 0)
        return;
    of_log(@"Selenium Error: %ld - %@", error.code, error.description);
    [self setLastError:error];
    [self.errors addObject:error];
}

-(OFString*) httpCommandExecutor
{
    return [OFString stringWithFormat:@"http://%@:%d/wd/hub", self.serverAddress, (int)self.serverPort];
}

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(SEStatus*) getStatusAndReturnError:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/status", self.httpCommandExecutor];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        SEStatus *webdriverStatus = [[SEStatus alloc] initWithDictionary:json];
        return webdriverStatus;
}

// POST /session
-(SESession*) postSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities andRequiredCapabilities:(SECapabilities*)requiredCapabilities error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session", self.httpCommandExecutor];

	OFMutableDictionary *postDictionary = [OFMutableDictionary new];
	[postDictionary setValue:[desiredCapabilities dictionary] forKey:@"desiredCapabilities"];
	if (requiredCapabilities != nil)
	{
		[postDictionary setValue:[requiredCapabilities dictionary] forKey:@"requiredCapabilities"];
	}

	OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
	SESession *session = [[SESession alloc] initWithDictionary:json];
	return session;
}

// GET /sessions
-(OFArray*) getSessionsAndReturnError:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/sessions", self.httpCommandExecutor];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];

	OFMutableArray *sessions = [OFMutableArray new];
	OFArray *jsonItems = (OFArray*)[json objectForKey:@"value"];
	for(size_t i =0; i < [jsonItems count]; i++)
	{
		SESession *session = [[SESession alloc] initWithDictionary:[jsonItems objectAtIndex:i]];
		[sessions addObject:session];
	}
	return sessions;
}

// GET /session/:sessionid/contexts
-(OFArray*) getContextsForSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/contexts", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    OFMutableArray *contexts = [OFMutableArray new];
    OFArray *jsonItems =(OFArray*)[json objectForKey:@"value"];
    for(size_t i=0; i < [jsonItems count]; i++)
    {
        OFString *context =[[OFString alloc] initWithString:(OFString*)[jsonItems objectAtIndex:i]];
        [contexts addObject:context];
    }
    return contexts;
}

// GET /session/:sessionid/context
-(OFString*) getContextForSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/context", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    return [json objectForKey:@"value"];
}

// POST /session/:sessionid/context
-(void) postContext:(OFString*)context session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/context", self.httpCommandExecutor, sessionId];
    OFDictionary *postDictionary = [[OFDictionary alloc] initWithKeysAndObjects: @"context", context, nil];
    [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// GET /session/:sessionId
-(SESession*) getSessionWithSession:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        SESession *session = [[SESession alloc] initWithDictionary:json];
        return session;
}

// DELETE /session/:sessionId
-(void) deleteSessionWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// /session/:sessionId/timeouts
-(void) postTimeout:(ssize_t)timeoutInMilliseconds forType:(SETimeoutType)type session:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/timeouts", self.httpCommandExecutor, sessionId];
    OFString *timeoutType = [SEEnums stringForTimeoutType:type];
        OFDictionary *postDictionary = [[OFDictionary alloc] initWithKeysAndObjects: @"type", timeoutType, @"ms", [OFString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], nil];
        [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/timeouts/async_script
-(void) postAsyncScriptWaitTimeout:(ssize_t)timeoutInMilliseconds session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/timeouts/async_script", self.httpCommandExecutor, sessionId];
	OFDictionary *postDictionary = [[OFDictionary alloc] initWithKeysAndObjects: @"ms", [OFString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/timeouts/implicit_wait
-(void) postImplicitWaitTimeout:(ssize_t)timeoutInMilliseconds session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/timeouts/implicit_wait", self.httpCommandExecutor, sessionId];
	OFDictionary *postDictionary = [[OFDictionary alloc] initWithKeysAndObjects:@"ms", [OFString stringWithFormat:@"%d", ((int)timeoutInMilliseconds)], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// GET /session/:sessionId/window_handle
-(OFString*) getWindowHandleWithSession:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window_handle", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        OFString *handle = [[OFString alloc] initWithString:(OFString*)[json objectForKey:@"value"]];
        return handle;
}

// GET /session/:sessionId/window_handles
-(OFArray*) getWindowHandlesWithSession:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window_handles", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];

	OFMutableArray *handles = [OFMutableArray new];
	OFArray *jsonItems = (OFArray*)[json objectForKey:@"value"];
	for(size_t i =0; i < [jsonItems count]; i++)
	{
		OFString *handle = [[OFString alloc] initWithString:(OFString*)[jsonItems objectAtIndex:i]];
		[handles addObject:handle];
	}
	return handles;
}

// GET /session/:sessionId/url
-(OFURL*) getURLWithSession:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/url", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        OFString *url = [json objectForKey:@"value"];
        return [[OFURL alloc] initWithString:url];
}

// POST /session/:sessionId/url
-(void) postURL:(OFURL*)url session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/url", self.httpCommandExecutor, sessionId];
	OFDictionary *postDictionary = [[OFDictionary alloc] initWithKeysAndObjects:@"url", [url string], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /session/:sessionId/forward
-(void) postForwardWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/forward", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/back
-(void) postBackWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/back", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/refresh
-(void) postRefreshWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/refresh", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/execute
-(OFDictionary*) postExecuteScript:(OFString*)script arguments:(OFArray*)arguments session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/execute", self.httpCommandExecutor, sessionId];
	OFMutableDictionary *postParams = [OFMutableDictionary new];
	[postParams setObject:script forKey:@"script"];
	if (arguments == nil || arguments.count < 1)
	{
		arguments = [OFArray new];
	}
	[postParams setObject:arguments forKey:@"args"];
	return [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/execute_async
-(OFDictionary*) postExecuteAsyncScript:(OFString*)script arguments:(OFArray*)arguments session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/execute_async", self.httpCommandExecutor, sessionId];
	OFMutableDictionary *postParams = [OFMutableDictionary new];
	[postParams setObject:script forKey:@"script"];
	if (arguments == nil || arguments.count < 1)
	{
		arguments = [OFArray new];
	}
	[postParams setObject:arguments forKey:@"args"];
	return [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/screenshot
-(IMAGE_TYPE*) getScreenshotWithSession:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/screenshot", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        OFString *pngString = [json objectForKey:@"value"];
        OFDataArray *pngData = [OFDataArray dataArrayWithBase64EncodedString:pngString];
        IMAGE_TYPE *image = [[IMAGE_TYPE alloc] initWithData:pngData];
        return image;
}

// GET /session/:sessionId/ime/available_engines
-(OFArray*) getAvailableInputMethodEnginesWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/ime/available_engines", self.httpCommandExecutor, sessionId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFArray *jsonItems = (OFArray*)[json objectForKey:@"value"];
	OFMutableArray *engines = [OFMutableArray new];
	for (size_t i=0; i < [jsonItems count]; i++)
	{
		OFString *engine = [jsonItems objectAtIndex:i];
		[engines addObject:engine];
	}
	return engines;
}

// GET /session/:sessionId/ime/active_engine
-(OFString*) getActiveInputMethodEngineWithSession:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/ime/active_engine", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        OFString *activeEngine = [json objectForKey:@"value"];
        return activeEngine;
}

// GET /session/:sessionId/ime/activated
-(BOOL) getInputMethodEngineIsActivatedWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/ime/activated", self.httpCommandExecutor, sessionId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isActivated = [[json objectForKey:@"value"] boolValue];
	return isActivated;
}

// POST /session/:sessionId/ime/deactivate
-(void) postDeactivateInputMethodEngineWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/ime/deactivate", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/ime/activate
-(void) postActivateInputMethodEngine:(OFString*)engine session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/ime/activate", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"engine", engine, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/frame
-(void) postSetFrame:(id)name session:(OFString*)sessionId error:(OFError**)error
{
	if ([name isKindOfClass:[SEWebElement class]])
	{
		name = (SEWebElement*)[name elementJson];
	}
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/frame", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"name", name, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/window
-(void) postSetWindow:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"name", windowHandle, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// DELETE /session/:sessionId/window
-(void) deleteWindowWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// POST /session/:sessionId/window/:windowHandle/size
-(void) postSetWindowSize:(SIZE_TYPE)size window:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window/%@/size", self.httpCommandExecutor, sessionId, windowHandle];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"width",  [NSNumber numberWithInt:(size.width/1)], @"height", [NSNumber numberWithInt:(size.height/1)], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/window/:windowHandle/size
-(SIZE_TYPE) getWindowSizeWithWindow:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window/%@/size", self.httpCommandExecutor, sessionId, windowHandle];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFDictionary *valueJson = [json objectForKey:@"value"];
	float width = [[valueJson objectForKey:@"width"] floatValue];
	float height = [[valueJson objectForKey:@"height"] floatValue];
	SIZE_TYPE size = SIZE_TYPE_MAKE(width,height);
	return size;
}

// POST /session/:sessionId/window/:windowHandle/position
-(void) postSetWindowPosition:(POINT_TYPE)position window:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window/%@/position", self.httpCommandExecutor, sessionId, windowHandle];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"x", [NSNumber numberWithInt:(position.x / 1)], @"y", [NSNumber numberWithInt:(position.y/1)], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/window/:windowHandle/position
-(POINT_TYPE) getWindowPositionWithWindow:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window/%@/position", self.httpCommandExecutor, sessionId, windowHandle];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	POINT_TYPE position = POINT_TYPE_MAKE(x,y);
	return position;
}

// POST /session/:sessionId/window/:windowHandle/maximize
-(void) postMaximizeWindow:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/window/%@/maximize", self.httpCommandExecutor, sessionId, windowHandle];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}


// GET /session/:sessionId/cookie
-(OFArray*) getCookiesWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFArray *jsonItems = (OFArray*)[json objectForKey:@"value"];
	OFMutableArray *cookies = [OFMutableArray new];
	for (size_t i=0; i < [jsonItems count]; i++)
	{
		OFMutableDictionary *cookieInfo = (OFMutableDictionary*)[jsonItems objectAtIndex:i];
		OFHTTPCookie *cookie = [SEUtility cookieWithJson:cookieInfo];
		[cookies addObject:cookie];
	}
	return cookies;
}

// POST /session/:sessionId/cookie
-(void) postCookie:(OFHTTPCookie*)cookie session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	OFMutableDictionary *cookieJson = [OFMutableDictionary new];
	[cookieJson setObject:cookie.name forKey:@"name"];
	[cookieJson setObject:cookie.value forKey:@"value"];
	[cookieJson setObject:cookie.path forKey:@"path"];
	[cookieJson setObject:cookie.domain forKey:@"domain"];
	[cookieJson setObject:[NSNumber numberWithBool:cookie.isSecure] forKey:@"secure"];
	[cookieJson setObject:[NSNumber numberWithDouble:[cookie.expires timeIntervalSince1970]] forKey:@"expiry"];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"cookie", cookieJson, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// DELETE /session/:sessionId/cookie
-(void) deleteCookiesWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/cookie", self.httpCommandExecutor, sessionId];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// DELETE /session/:sessionId/cookie/:name
-(void) deleteCookie:(OFString*)cookieName session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/cookie/%@", self.httpCommandExecutor, sessionId, cookieName];
	[SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/source
-(OFString*) getSourceWithSession:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/source", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        OFString *source = [json objectForKey:@"value"];
        return source;
}

// GET /session/:sessionId/title
-(OFString*) getTitleWithSession:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/title", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        OFString *title = [json objectForKey:@"value"];
        return title;
}

// POST /session/:sessionId/element
-(SEWebElement*) postElement:(SEBy*)locator session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"using", [locator locationStrategy], @"value", [locator value], nil];
	OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	OFString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return element;
}

// POST /session/:sessionId/elements
-(OFArray*) postElements:(SEBy*)locator session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/elements", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"using", [locator locationStrategy], @"value",	[locator value], nil];
	OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	OFArray *matches = (OFArray*)[json objectForKey:@"value"];
	OFMutableArray *elements = [OFMutableArray new];
	for (size_t i=0; i < [matches count]; i++)
	{
		OFString *elementId = [[matches objectAtIndex:i] objectForKey:@"ELEMENT"];
		SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
		[elements addObject:element];
	}
	return elements;
}

// POST /session/:sessionId/element/active
-(SEWebElement*) postActiveElementWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/active", self.httpCommandExecutor, sessionId];
	OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
	OFString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return element;
}

// /session/:sessionId/element/:id (FUTURE)
//
// IMPLEMENT ME
//
//

// POST /session/:sessionId/element/:id/element
-(SEWebElement*) postElementFromElement:(SEWebElement*)element by:(SEBy*)locator session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/elements", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"using", [locator locationStrategy], @"value", [locator value], nil];
	OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	OFString *elementId = [[json objectForKey:@"value"] objectForKey:@"ELEMENT"];
	SEWebElement *foundElement = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
	return foundElement;
}
// POST /session/:sessionId/element/:id/elements
-(OFArray*) postElementsFromElement:(SEWebElement*)element by:(SEBy*)locator session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/elements", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"using", [locator locationStrategy], @"value", [locator value], nil];
	OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
	OFArray *matches = (OFArray*)[json objectForKey:@"value"];
	OFMutableArray *elements = [OFMutableArray new];
	for (size_t i=0; i < [matches count]; i++)
	{
		OFString *elementId = [[matches objectAtIndex:i] objectForKey:@"ELEMENT"];
		SEWebElement *element = [[SEWebElement alloc] initWithOpaqueId:elementId jsonWireClient:self session:sessionId];
		[elements addObject:element];
	}
	return elements;
}

// POST /session/:sessionId/element/:id/click
-(void) postClickElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/click", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/element/:id/submit
-(void) postSubmitElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/submit", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// GET /session/:sessionId/element/:id/text
-(OFString*) getElementText:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/text", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFString *text = [json objectForKey:@"value"];
	return text;
}

// POST /session/:sessionId/element/:id/value
-(void) postKeys:(of_unichar_t *)keys element:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/value", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFMutableArray *keyArray = [OFMutableArray new];
	for(size_t i=0; keys[i] != '\0'; i++)
	{
		[keyArray addObject:[OFString stringWithFormat:@"%C", keys[i]]];
	}
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"value", keyArray, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/keys
-(void) postKeys:(of_unichar_t *)keys session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/keys", self.httpCommandExecutor, sessionId];
	OFMutableArray *keyArray = [OFMutableArray new];
	for(size_t i=0; keys[i] != '\0'; i++)
	{
		[keyArray addObject:[OFString stringWithFormat:@"%C", keys[i]]];
	}
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"value", keyArray, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/element/:id/name
-(OFString*) getElementName:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/name", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFString *name = [json objectForKey:@"value"];
	return name;
}

// POST /session/:sessionId/element/:id/clear
-(void) postClearElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/clear", self.httpCommandExecutor, sessionId, element.opaqueId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// GET /session/:sessionId/element/:id/selected
-(BOOL) getElementIsSelected:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/selected", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isSelected = [[json objectForKey:@"value"] boolValue];
	return isSelected;
}

// GET /session/:sessionId/element/:id/enabled
-(BOOL) getElementIsEnabled:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/enabled", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isEnabled = [[json objectForKey:@"value"] boolValue];
	return isEnabled;
}

// GET /session/:sessionId/element/:id/attribute/:name
-(OFString*) getAttribute:(OFString*)attributeName element:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/attribute/%@", self.httpCommandExecutor, sessionId, element.opaqueId, attributeName];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFString *value = [json objectForKey:@"value"];
	return value;
}

// GET /session/:sessionId/element/:id/equals/:other
-(BOOL) getEqualityForElement:(SEWebElement*)element element:(SEWebElement*)otherElement session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/equals/%@", self.httpCommandExecutor, sessionId, element.opaqueId,[otherElement opaqueId]];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isEqual = [[json objectForKey:@"value"] boolValue];
	return isEqual;
}

// GET /session/:sessionId/element/:id/displayed
-(BOOL) getElementIsDisplayed:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/displayed", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	BOOL isDisplayed = [[json objectForKey:@"value"] boolValue];
	return isDisplayed;
}

// GET /session/:sessionId/element/:id/location
-(POINT_TYPE) getElementLocation:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/location", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	POINT_TYPE point = POINT_TYPE_MAKE(x,y);
	return point;
}

// GET /session/:sessionId/element/:id/location_in_view
-(POINT_TYPE) getElementLocationInView:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/location_in_view", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"x"] floatValue];
	float y = [[valueJson objectForKey:@"y"] floatValue];
	POINT_TYPE point = POINT_TYPE_MAKE(x,y);
	return point;
}

// GET /session/:sessionId/element/:id/size
-(SIZE_TYPE) getElementSize:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/size", self.httpCommandExecutor, sessionId, element.opaqueId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFDictionary *valueJson = [json objectForKey:@"value"];
	float x = [[valueJson objectForKey:@"width"] floatValue];
	float y = [[valueJson objectForKey:@"height"] floatValue];
	SIZE_TYPE size = SIZE_TYPE_MAKE(x,y);
	return size;
}

// GET /session/:sessionId/element/:id/css/:propertyName
-(OFString*) getCSSProperty:(OFString*)propertyName element:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/element/%@/css/%@", self.httpCommandExecutor, sessionId, element.opaqueId, propertyName];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFString *value = [json objectForKey:@"value"];
	return value;
}

// GET /session/:sessionId/orientation
-(SEScreenOrientation) getOrientationWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/orientation", self.httpCommandExecutor, sessionId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	if ([*error code] != 0)
		return SELENIUM_SCREEN_ORIENTATION_UNKOWN;
	OFString *value = [json objectForKey:@"value"];
	return ([value isEqual:@"LANDSCAPE"] ? SELENIUM_SCREEN_ORIENTATION_LANDSCAPE : SELENIUM_SCREEN_ORIENTATION_PORTRAIT);
}

// POST /session/:sessionId/orientation
-(void) postOrientation:(SEScreenOrientation)orientation session:(OFString*)sessionId error:(OFError**)error
{
	if (orientation == SELENIUM_SCREEN_ORIENTATION_UNKOWN)
		return;
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/orientation", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"orientation", (orientation == SELENIUM_SCREEN_ORIENTATION_LANDSCAPE) ? @"LANDSCAPE" : @"PORTRAIT" , nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// GET /session/:sessionId/alert_text
-(OFString*) getAlertTextWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/alert_text", self.httpCommandExecutor, sessionId];
	OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
	OFString *alertText = [json objectForKey:@"value"];
	return alertText;
}

// POST /session/:sessionId/alert_text
-(void) postAlertText:(OFString*)text session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/alert_text", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"text", text, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/accept_alert
-(void) postAcceptAlertWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/accept_alert", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/dismiss_alert
-(void) postDismissAlertWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/dismiss_alert", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/moveto
-(void) postMoveMouseToElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/move_to", self.httpCommandExecutor, sessionId];
	OFMutableDictionary *postParams = [OFMutableDictionary new];
	if (element != nil)
	{
		[postParams setObject:element.opaqueId forKey:@"element"];
	}
	[postParams setObject:[NSNumber numberWithSSize:xOffset] forKey:@"xoffset"];
	[postParams setObject:[NSNumber numberWithSSize:yOffset] forKey:@"yoffset"];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/click
-(void) postClickMouseButton:(SEMouseButton)button session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/click", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"button",  [NSNumber numberWithSSize:[SEEnums intForMouseButton:button]], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/buttondown
-(void) postMouseButtonDown:(SEMouseButton)button session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/buttondown", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"button", [NSNumber numberWithSSize:[SEEnums intForMouseButton:button]], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/buttonup
-(void) postMouseButtonUp:(SEMouseButton)button session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/buttonup", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"button", [NSNumber numberWithSSize:[SEEnums intForMouseButton:button]], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/doubleclick
-(void) postDoubleClickWithSession:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/doubleclick", self.httpCommandExecutor, sessionId];
	[SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/touch/click
-(void) postTapElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/click", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"element", element.opaqueId, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/down
-(void) postFingerDownAt:(POINT_TYPE)point session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/down", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"x",  [NSNumber numberWithInt:(int)point.x], @"y",  [NSNumber numberWithInt:(int)point.y], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/up
-(void) postFingerUpAt:(POINT_TYPE)point session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/up", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"x", [NSNumber numberWithInt:(int)point.x], @"y", [NSNumber numberWithInt:(int)point.y], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/move
-(void) postMoveFingerTo:(POINT_TYPE)point session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/move", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"x", [NSNumber numberWithInt:(int)point.x], @"y", [NSNumber numberWithInt:(int)point.y], nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/scroll
-(void) postStartScrollingAtParticularLocation:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset session:(OFString*)sessionId error:(OFError**)error
{
            OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/scroll", self.httpCommandExecutor,sessionId];
        OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"element", element.opaqueId, @"xoffset", [NSNumber numberWithSSize:xOffset], @"yoffset", [NSNumber numberWithSSize:yOffset], nil];
            [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/scroll
-(void) postScrollfromAnywhereOnTheScreenWithSession:(POINT_TYPE)point session:(OFString*)sessionId error:(OFError**)error
{
	    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/touch/scroll", self.httpCommandExecutor, sessionId];
	    OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"x", [NSNumber numberWithInt:(int)point.x], @"y", [NSNumber numberWithInt:(int)point.y], nil];
	  [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}


// POST /session/:sessionId/touch/doubleclick
-(void) postDoubleTapElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/doubleclick", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"element", element.opaqueId, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/longclick
-(void) postPressElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error
{
	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/longclick", self.httpCommandExecutor, sessionId];
	OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"element", element.opaqueId, nil];
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/perform
-(void) postTouchAction:(SETouchAction *)touchAction session:(OFString*)sessionId error:(OFError**)error
{

	OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/perform", self.httpCommandExecutor, sessionId];

	OFMutableArray *actionsJson = [OFMutableArray array];
	for (SETouchActionCommand *command in touchAction.commands) {
		OFDictionary *action = @{
				@"action": command.name,
				@"options": [command.options copy]
		};
		[actionsJson addObject:action];
	}

	OFDictionary *postParams = @{@"actions": actionsJson};
	[SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}


// POST /session/:sessionId/touch/flick
-(void) postFlickFromParticularLocation:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset  speed:(ssize_t)speed session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/flick", self.httpCommandExecutor,sessionId];
    OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"element", element.opaqueId, @"xoffset", [NSNumber numberWithSSize:xOffset], @"yoffset", [NSNumber numberWithSSize:yOffset], @"speed",  [NSNumber numberWithSSize:speed], nil];
    [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}

// POST /session/:sessionId/touch/flick
-(void) postFlickFromAnywhere:(ssize_t)xSpeed ySpeed:(ssize_t)ySpeed session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/touch/flick", self.httpCommandExecutor,sessionId];
    OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"xSpeed", [NSNumber numberWithSSize:xSpeed], @"ySpeed", [NSNumber numberWithSSize:ySpeed], nil];
    [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}


// GET /session/:sessionId/location
-(SELocation*) getLocationAndReturnError:(OFString*)sessionId error:(OFError**)error
{
        OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/location", self.httpCommandExecutor,sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
        SELocation *currentGeoLocation = [[SELocation alloc] initWithDictionary:json];
        return currentGeoLocation ;
}

// POST /session/:sessionId/location
-(void) postLocation:(SELocation*)location session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/location", self.httpCommandExecutor,sessionId];
    OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects: @"location", location, nil];
    [SEUtility performPostRequestToUrl: urlString postParams:postParams error:error];
}


// GET /session/:sessionId/local_storage
-(OFArray*) getAllLocalStorageKeys:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/local_storage",self.httpCommandExecutor,sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    OFMutableArray *keysList = [OFMutableArray new];
    OFArray *jsonItems = (OFArray*)[json objectForKey:@"value"];
    for(size_t i =0; i < [jsonItems count]; i++)
    {
        OFString *key = [[OFString alloc] initWithString:(OFString*)[jsonItems objectAtIndex:i]];
        [keysList addObject:key];
    }

    return keysList;
}

//POST /session/:sessionId/local_storage
-(void) postSetLocalStorageItemForKey:(OFString*)key value:(OFString*)value session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/local_storage",self.httpCommandExecutor,sessionId];
    OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"key", key,@"value", value, nil];
        [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];

}

// DELETE /session/:sessionId/local_storage
-(void) deleteLocalStorage:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/local_storage",self.httpCommandExecutor,sessionId];
    [SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/local_storage/key/:key
-(void) getLocalStorageItemForKey:(OFString*)key session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/local_storage/key/%@",self.httpCommandExecutor,sessionId,key];
    [SEUtility performGetRequestToUrl:urlString error:error];
}

//DELETE /session/:sessionId/local_storage/key/:key
-(void) deleteLocalStorageItemForGivenKey:(OFString*)key session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString=[OFString stringWithFormat:@"%@/session/%@/local_storage/key/%@",self.httpCommandExecutor,sessionId,key];
    [SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/local_storage/size
-(ssize_t) getLocalStorageSize:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString=[OFString stringWithFormat:@"%@/session/%@/local_storage/size",self.httpCommandExecutor,sessionId];
    OFDictionary *json=[SEUtility performGetRequestToUrl:urlString error:error];
    ssize_t numOfItemsInLocalStorage = [[json objectForKey:@"value"] sSizeValue];
    return numOfItemsInLocalStorage;
}

// GET /session/:sessionId/session_storage
-(OFArray*) getAllStorageKeys:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/session_storage",self.httpCommandExecutor,sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    OFMutableArray *keysList = [OFMutableArray new];
    OFArray *jsonItems = (OFArray*)[json objectForKey:@"value"];
        for(size_t i =0; i < [jsonItems count]; i++)
        {
            OFString *key = [[OFString alloc] initWithString:(OFString*)[jsonItems objectAtIndex:i]];
            [keysList addObject:key];
        }

    return keysList;
}

// POST /session/:sessionId/session_storage
-(void) postSetStorageItemForKey:(OFString*)key value:(OFString*)value session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/session_storage",self.httpCommandExecutor,sessionId];
    OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"key", key, @"value", value, nil];
        [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];

}

// DELETE /session/:sessionId/session_storage
-(void) deleteStorage:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/session_storage",self.httpCommandExecutor,sessionId];
    [SEUtility performDeleteRequestToUrl:urlString error:error];
}

// GET /session/:sessionId/session_storage/key/:key
-(void) getStorageItemForKey:(OFString*)key session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString =[OFString stringWithFormat:@"%@/session/%@/session_storage/key/%@",self.httpCommandExecutor,sessionId,key];
    [SEUtility performGetRequestToUrl:urlString error:error];
}

//DELETE /session/:sessionId/session_storage/key/:key
-(void) deleteStorageItemForGivenKey:(OFString*)key session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString=[OFString stringWithFormat:@"%@/session/%@/session_storage/key/%@",self.httpCommandExecutor,sessionId,key];
    [SEUtility performDeleteRequestToUrl:urlString error:error];
}


// GET /session/:sessionId/session_storage/size
-(ssize_t) getStorageSize:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString=[OFString stringWithFormat:@"%@/session/%@/session_storage/size",self.httpCommandExecutor,sessionId];
    OFDictionary *json=[SEUtility performGetRequestToUrl:urlString error:error];
    ssize_t numOfItemsInStorage = [[json objectForKey:@"value"] sSizeValue];
    return numOfItemsInStorage;
}


// POST /session/:sessionId/log
-(OFArray*) getLogForGivenLogType:(SELogType)type session:(OFString*)sessionId error:(OFError**)error
{
    OFString  *urlString = [OFString stringWithFormat:@"%@/session/%@/log",self.httpCommandExecutor,sessionId];
    OFString *logType = [SEEnums stringForLogType:type];
    OFDictionary *postParams = [[OFDictionary alloc] initWithKeysAndObjects:@"type", logType, nil];
    OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
    OFMutableArray *logEntries =[OFMutableArray new];
    OFArray *jsonItems = (OFArray*)[json objectForKey:@"value"];
    for(size_t i=0; i < [jsonItems count]; i++)
    {
        OFString *logEntry =[[OFString alloc] initWithString:(OFString*)[jsonItems objectAtIndex:i]];
        [logEntries addObject:logEntry];
    }
    return logEntries;
}


// GET /session/:sessionId/log/types
-(OFArray*) getLogTypes:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/log/types",self.httpCommandExecutor,sessionId];
    OFDictionary *json =[SEUtility performGetRequestToUrl:urlString error:error];
    OFMutableArray *logTypes = [OFMutableArray new];
    OFArray *jsonItems =(OFArray*)[json objectForKey:@"value"];
    for(size_t i=0; i < [jsonItems count]; i++)
    {
        OFString *logType =[[OFString alloc] initWithString:(OFString*)[jsonItems objectAtIndex:i]];
        [logTypes addObject:logType];
    }
    return logTypes;
}


// GET /session/:sessionId/application_cache/status
-(SEApplicationCacheStatus) getApplicationCacheStatusWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/application_cache/status", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
         ssize_t appCacheStatus = [[json objectForKey:@"value"] sSizeValue];
    return [SEEnums applicationCacheStatusWithInt:appCacheStatus];
}


#pragma mark - 3.0 methods
  /////////////////
 // 3.0 METHODS //
/////////////////

// POST /wd/hub/session/:sessionId/appium/device/shake
-(void) postShakeDeviceWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/shake", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/lock
-(void) postLockDeviceWithSession:(OFString*)sessionId seconds:(ssize_t)seconds error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/lock", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"seconds" : [NSNumber numberWithSSize:seconds]} error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/unlock
-(void) postUnlockDeviceWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/unlock", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/is_locked
-(BOOL) postIsDeviceLockedWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/is_locked", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
    return [[json objectForKey:@"value"] boolValue];
}

// POST /wd/hub/session/:sessionId/appium/device/press_keycode
-(void) postPressKeycode:(ssize_t)keycode metastate:(ssize_t)metaState session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/press_keycode", self.httpCommandExecutor, sessionId];
    OFMutableDictionary *postParams = [OFMutableDictionary dictionaryWithKeysAndObjects:@"keycode", [NSNumber numberWithSSize:keycode], nil];
    if (metaState > 0) {
        [postParams setObject:[NSNumber numberWithSSize:metaState] forKey:@"metastate"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}


// POST /wd/hub/session/:sessionId/appium/device/long_press_keycode
-(void) postLongPressKeycode:(ssize_t)keycode metastate:(ssize_t)metaState session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/long_press_keycode", self.httpCommandExecutor, sessionId];
    OFMutableDictionary *postParams = [OFMutableDictionary dictionaryWithKeysAndObjects:@"keycode", [NSNumber numberWithSSize:keycode], nil];
    if (metaState > 0) {
        [postParams setObject:[NSNumber numberWithSSize:metaState] forKey:@"metastate"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/keyevent
-(void) postKeyEvent:(ssize_t)keycode metastate:(ssize_t)metaState session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/keyevent", self.httpCommandExecutor, sessionId];
    OFMutableDictionary *postParams = [OFMutableDictionary dictionaryWithKeysAndObjects:@"keycode", [NSNumber numberWithSSize:keycode], nil];
    if (metaState > 0) {
        [postParams setObject:[NSNumber numberWithSSize:metaState] forKey:@"metastate"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /session/:sessionId/appium/app/rotate
- (void)postRotate:(SEScreenOrientation)orientation session:(OFString*)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/rotate", self.httpCommandExecutor, sessionId];
    OFDictionary *postDictionary = @{@"orientation" : orientation == SELENIUM_SCREEN_ORIENTATION_LANDSCAPE ? @"LANDSCAPE" : @"PORTRAIT" };
    [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// GET /wd/hub/session/:sessionId/appium/device/current_activity
-(OFString*) getCurrentActivityForDeviceForSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/current_activity", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];
    return [json objectForKey:@"value"];
}

// POST /wd/hub/session/:sessionId/appium/device/install_app
- (void)postInstallApp:(OFString*)appPath session:(OFString*)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/install_app", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"appPath" : appPath } error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/remove_app
- (void)postRemoveApp:(OFString*)bundleId session:(OFString*)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/remove_app", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"bundleId" : bundleId } error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/app_installed
-(BOOL) postIsAppInstalledWithBundleId:(OFString*)bundleId session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/app_installed", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams: @{ @"bundleId" : bundleId } error:error];
    return [[json objectForKey:@"value"] boolValue];
}

// POST /wd/hub/session/:sessionId/appium/device/hide_keyboard
-(void) postHideKeyboardWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/hide_keyboard", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/push_file
- (void)postPushFileToPath:(OFString*)path data:(OFDataArray*)data session:(OFString*)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/push_file", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"path" : path, @"data": [data stringByBase64Encoding]} error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/pull_file
-(OFDataArray*) postPullFileAtPath:(OFString*)path session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/pull_file", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams: @{ @"path" : path } error:error];
    return [OFDataArray dataArrayWithBase64EncodedString:(OFString*)[json objectForKey:@"value"]];
}

// POST /wd/hub/session/:sessionId/appium/device/pull_folder
-(OFDataArray*) postPullFolderAtPath:(OFString*)path session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/pull_folder", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams: @{ @"path" : path } error:error];
    return [OFDataArray dataArrayWithBase64EncodedString:(OFString*)[json objectForKey:@"value"]];
}

// POST /wd/hub/session/:sessionId/appium/device/toggle_airplane_mode
-(void) postToggleAirplaneModeWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/toggle_airplane_mode", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/toggle_data
-(void) postToggleDataWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/toggle_data", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/toggle_wifi
-(void) postToggleWifiWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/toggle_wifi", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/toggle_location_services
-(void) postToggleLocationServicesWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/toggle_location_services", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/open_notifications
-(void) postOpenNotificationsWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/open_notifications", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/device/start_activity
-(void) postStartActivity:(OFString*)activity package:(OFString*)package waitActivity:(OFString*)waitActivity waitPackage:(OFString*)waitPackage session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/device/start_activity", self.httpCommandExecutor, sessionId];
    OFMutableDictionary *postParams = [OFMutableDictionary new];
    [postParams setObject:activity forKey:@"appActivity"];
    [postParams setObject:package forKey:@"appPackage"];
    if (waitActivity != nil ) { [postParams setObject:waitActivity forKey:@"appWaitActivity"]; }
    if (waitPackage != nil ) { [postParams setObject:waitPackage forKey:@"appWaitPackage"]; }

    [SEUtility performPostRequestToUrl:urlString postParams: postParams error:error];
}

// POST /session/:sessionId/appium/app/launch
- (void)postLaunchAppWithSession:(OFString *)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/app/launch", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/appium/app/close
- (void)postCloseAppWithSession:(OFString *)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/app/close", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/appium/app/reset
- (void)postResetAppWithSession:(OFString *)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/app/reset", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /session/:sessionId/appium/app/background
- (void)postRunAppInBackground:(ssize_t)seconds session:(OFString *)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/app/background", self.httpCommandExecutor, sessionId];
    OFDictionary *postDictionary = [[OFDictionary alloc] initWithKeysAndObjects:@"seconds", [NSNumber numberWithSSize:seconds], nil];
    [SEUtility performPostRequestToUrl:urlString postParams:postDictionary error:error];
}

// POST /wd/hub/session/:sessionId/appium/app/end_test_coverage
- (void)postEndTestCoverageWithSession:(OFString *)sessionId error:(OFError **)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/app/end_test_coverage", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:nil error:error];
}

// POST /wd/hub/session/:sessionId/appium/app/strings
-(OFString*) getAppStringsForLanguage:(OFString*)languageCode session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/app/strings", self.httpCommandExecutor, sessionId];
    OFDictionary *postParams = languageCode == nil ? [OFDictionary new] : @{@"language" : languageCode};
    OFDictionary *json = [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
    return [[json objectForKey:@"value"] stringValue];
}

// POST /wd/hub/session/:sessionId/appium/element/:elementId?/value
-(void) postSetValueForElement:(SEWebElement*)element value:(OFString*)value isUnicode:(BOOL)isUnicode session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/element/%@/value", self.httpCommandExecutor, sessionId, element.opaqueId];
    OFMutableDictionary *postParams = [OFMutableDictionary dictionaryWithKeysAndObjects:@"text", value, nil];
    if (isUnicode) {
        [postParams setObject:[NSNumber numberWithBool:isUnicode] forKey:@"unicodeKeyboard"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /wd/hub/session/:sessionId/appium/element/:elementId?/replace_value
-(void) postReplaceValueForElement:(SEWebElement*)element value:(OFString*)value isUnicode:(BOOL)isUnicode session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/element/%@/replace_value", self.httpCommandExecutor, sessionId, element.opaqueId];
    OFMutableDictionary *postParams = [OFMutableDictionary dictionaryWithKeysAndObjects:@"text", value, nil];
    if (isUnicode) {
        [postParams setObject:[NSNumber numberWithBool:isUnicode] forKey:@"unicodeKeyboard"];
    }
    [SEUtility performPostRequestToUrl:urlString postParams:postParams error:error];
}

// POST /wd/hub/session/:sessionId/appium/settings
-(void) postSetAppiumSettings:(OFDictionary*)settings session:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/settings", self.httpCommandExecutor, sessionId];
    [SEUtility performPostRequestToUrl:urlString postParams:@{@"settings":settings} error:error];
}

// GET /wd/hub/session/:sessionId/appium/settings
-(OFDictionary*) getAppiumSettingsWithSession:(OFString*)sessionId error:(OFError**)error
{
    OFString *urlString = [OFString stringWithFormat:@"%@/session/%@/appium/settings", self.httpCommandExecutor, sessionId];
    OFDictionary *json = [SEUtility performGetRequestToUrl:urlString error:error];

    id dictionary = [json objectForKey:@"value"];

    if (![dictionary isKindOfClass:[OFDictionary class]])
      @throw [OFInvalidJSONException exception];

    return (OFDictionary *)dictionary;
}

@end
