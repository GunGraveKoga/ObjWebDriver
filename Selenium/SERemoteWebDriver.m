//
//  SERemoteWebDriver.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SERemoteWebDriver.h"

@interface SERemoteWebDriver ()
        @property SEJsonWireClient *jsonWireClient;
@end

@implementation SERemoteWebDriver

#pragma mark - Public Methods
/*
-(id) init
{
  if ([self class] != [SERemoteWebDriver class]) {
      self = [super init];

      return self;
    }

  OF_UNRECOGNIZED_SELECTOR;
  OF_UNREACHABLE;
    //@throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   //reason:@"-init is not a valid initializer for the class SERemoteWebDriver"
                                 //userInfo:nil];
    //return nil;
}
*/
-(id) initWithServerAddress:(OFString *)address port:(ssize_t)port
{
        self = [super init];
    if (self) {
                OFError *error;
        [self setJsonWireClient:[[SEJsonWireClient alloc] initWithServerAddress:address port:port error:&error]];
                [self addError:error];
    }
    return self;
}

-(id) initWithServerAddress:(OFString*)address port:(ssize_t)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(OFError**)error
{
    self = [self initWithServerAddress:address port:port];
    if (self) {
        [self setJsonWireClient:[[SEJsonWireClient alloc] initWithServerAddress:address port:port error:error]];
                [self addError:*error];

		// get session
		[self setSession:[self startSessionWithDesiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites]];
	if (self.session == nil)
	    return nil;
    }
    return self;
}

-(void)addError:(OFError*)error
{
    [self.jsonWireClient addError:error];
}

-(OFArray*) errors {
    return self.jsonWireClient.errors;
}

-(OFError*) lastError {
    return self.jsonWireClient.lastError;
}

-(void)quit
{
    OFError *error;
    [self quitWithError:&error];
        [self addError:error];
}

-(void)quitWithError:(OFError**)error {
    [self.jsonWireClient deleteSessionWithSession:self.session.sessionId error:error];
}

-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites
{
	// get session
	OFError *error;
    SESession* session = [self startSessionWithDesiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites error:&error];
        [self addError:error];
    return session;
}

-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(OFError**)error
{
    // get session
    [self setSession:[self.jsonWireClient postSessionWithDesiredCapabilities:desiredCapabilities andRequiredCapabilities:requiredCapabilites error:error]];
    if ([*error code] != 0)
        return nil;
    return [self session];
}

-(OFArray*) allSessions
{
        OFError *error;
    OFArray *sessions = [self allSessionsWithError:&error];
        [self addError:error];
        return sessions;
}

-(OFArray*) allSessionsWithError:(OFError**)error {
    return [self.jsonWireClient getSessionsAndReturnError:error];
}

- (SEStatus *)status
{
  OFError *error;
  SEStatus *status = [self.jsonWireClient getStatusAndReturnError:&error];
  [self addError:error];

  return status;
}

-(OFArray*) allContexts {
    OFError *error;
    OFArray *contexts = [self allContextsWithError:&error];
    [self addError:error];
    return contexts;
}

-(OFArray*) allContextsWithError:(OFError**)error
{
    return [self.jsonWireClient getContextsForSession:self.session.sessionId error:error];
}

-(OFString*) context
{
    OFError *error;
    OFString* context = [self contextWithError:&error];
    [self addError:error];
    return context;
}

-(OFString*) contextWithError:(OFError**)error
{
    return [self.jsonWireClient getContextForSession:self.session.sessionId error:error];
}

-(void) setContext:(OFString*)context
{
    OFError *error;
    [self setContext:context error:&error];
    [self addError:error];
}

-(void) setContext:(OFString*)context error:(OFError**)error
{
    [self.jsonWireClient postContext:context session:self.session.sessionId error:error];
}

-(void) setTimeout:(ssize_t)timeoutInMilliseconds forType:(SETimeoutType)type
{
    OFError *error;
    [self setTimeout:timeoutInMilliseconds forType:type error:&error];
        [self addError:error];
}

-(void) setTimeout:(ssize_t)timeoutInMilliseconds forType:(SETimeoutType)type error:(OFError**)error
{

    [self.jsonWireClient postTimeout:timeoutInMilliseconds forType:type session:self.session.sessionId error:error];
}

-(void) setAsyncScriptTimeout:(ssize_t)timeoutInMilliseconds
{
        OFError *error;
    [self setAsyncScriptTimeout:timeoutInMilliseconds error:&error];
        [self addError:error];
}

-(void) setAsyncScriptTimeout:(ssize_t)timeoutInMilliseconds error:(OFError**)error
{
    [self.jsonWireClient postAsyncScriptWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:error];
}

-(void) setImplicitWaitTimeout:(ssize_t)timeoutInMilliseconds
{
        OFError *error;
    [self setImplicitWaitTimeout:timeoutInMilliseconds error:&error];
        [self addError:error];
}

-(void) setImplicitWaitTimeout:(ssize_t)timeoutInMilliseconds error:(OFError**)error
{
    [self.jsonWireClient postImplicitWaitTimeout:timeoutInMilliseconds session:self.session.sessionId error:error];
}

-(OFString*) window
{
        OFError *error;
    OFString* window = [self windowWithError:&error];
        [self addError:error];
        return window;
}

-(OFString*) windowWithError:(OFError**)error
{
    return [self.jsonWireClient getWindowHandleWithSession:self.session.sessionId error:error];
}

-(OFArray*) allWindows
{
        OFError *error;
    OFArray * windows = [self allWindowsWithError:&error];
        [self addError:error];
        return windows;
}

-(OFArray*) allWindowsWithError:(OFError**)error
{
    return [self.jsonWireClient getWindowHandlesWithSession:self.session.sessionId error:error];
}

-(OFURL*) url
{
        OFError *error;
    OFURL *url = [self urlWithError:&error];
        return url;
}

-(OFURL*) urlWithError:(OFError**)error
{
    return [self.jsonWireClient getURLWithSession:self.session.sessionId error:error];
}

-(void) setUrl:(OFURL*)url
{
        OFError *error;
    [self setUrl:url error:&error];
        [self addError:error];
}

-(void) setUrl:(OFURL*)url error:(OFError**)error
{
    [self.jsonWireClient postURL:url session:self.session.sessionId error:error];

}

-(void) forward
{
        OFError *error;
    [self forwardWithError:&error];
        [self addError:error];
}

-(void) forwardWithError:(OFError**)error
{
    [self.jsonWireClient postForwardWithSession:self.session.sessionId error:error];
}

-(void) back
{
        OFError *error;
    [self backWithError:&error];
        [self addError:error];
}

-(void) backWithError:(OFError**)error
{
    [self.jsonWireClient postBackWithSession:self.session.sessionId error:error];
}

-(void) refresh
{
        OFError *error;
    [self refreshWithError:&error];
        [self addError:error];
}

-(void) refreshWithError:(OFError**)error
{
    [self.jsonWireClient postRefreshWithSession:self.session.sessionId error:error];
}

-(OFDictionary*) executeScript:(OFString*)script
{
        return [self executeScript:script arguments:nil];
}

-(OFDictionary*) executeScript:(OFString*)script arguments:(OFArray*)arguments
{
        OFError *error;
    OFDictionary *output = [self executeScript:script arguments:arguments error:&error];
        [self addError:error];
        return output;
}

-(OFDictionary*) executeScript:(OFString*)script arguments:(OFArray*)arguments error:(OFError**)error
{
    return [self.jsonWireClient postExecuteScript:script arguments:arguments session:self.session.sessionId error:error];
}

-(OFDictionary*) executeAnsynchronousScript:(OFString*)script
{
        return [self executeAnsynchronousScript:script arguments:nil];
}

-(OFDictionary*) executeAnsynchronousScript:(OFString*)script arguments:(OFArray*)arguments
{
        OFError *error;
    OFDictionary *output = [self executeAnsynchronousScript:script arguments:arguments error:&error];
        [self addError:error];
        return output;
}

-(OFDictionary*) executeAnsynchronousScript:(OFString*)script arguments:(OFArray*)arguments error:(OFError**)error
{

    return [self.jsonWireClient postExecuteAsyncScript:script arguments:arguments session:self.session.sessionId error:error];
}

-(IMAGE_TYPE*) screenshot
{
        OFError *error;
    IMAGE_TYPE *image = [self screenshotWithError:&error];
        return image;
}

-(IMAGE_TYPE*) screenshotWithError:(OFError**)error
{
    return [self.jsonWireClient getScreenshotWithSession:self.session.sessionId error:error];
}

-(OFArray*) availableInputMethodEngines
{
        OFError *error;
    OFArray *engines = [self availableInputMethodEnginesWithError:&error];
        [self addError:error];
        return engines;
}

-(OFArray*) availableInputMethodEnginesWithError:(OFError**)error
{

    return[self.jsonWireClient getAvailableInputMethodEnginesWithSession:self.session.sessionId error:error];
}

-(OFString*) activeInputMethodEngine
{
    OFError *error;
    OFString *engine = [self activeInputMethodEngineWithError:&error];
        [self addError:error];
        return engine;
}

-(OFString*) activeInputMethodEngineWithError:(OFError**)error
{
    return [self.jsonWireClient getActiveInputMethodEngineWithSession:self.session.sessionId error:error];
}

-(BOOL) inputMethodEngineIsActive
{
    OFError *error;
    BOOL isActive = [self inputMethodEngineIsActiveWithError:&error];
        [self addError:error];
        return isActive;
}

-(BOOL) inputMethodEngineIsActiveWithError:(OFError**)error
{
    return [self.jsonWireClient getInputMethodEngineIsActivatedWithSession:self.session.sessionId error:error];
}

-(void) deactivateInputMethodEngine
{
    OFError *error;
    [self deactivateInputMethodEngineWithError:&error];
        [self addError:error];
}

-(void) deactivateInputMethodEngineWithError:(OFError**)error
{
    [self.jsonWireClient postDeactivateInputMethodEngineWithSession:self.session.sessionId error:error];
}

-(void) activateInputMethodEngine:(OFString*)engine
{
    OFError *error;
    [self activateInputMethodEngine:engine error:&error];
        [self addError:error];
}

-(void) activateInputMethodEngine:(OFString*)engine error:(OFError**)error
{
    [self.jsonWireClient postActivateInputMethodEngine:engine session:self.session.sessionId error:error];
}

-(void) setFrame:(OFString*)name
{
        OFError* error;
    [self setFrame:name error:&error];
        [self addError:error];
}

-(void) setFrame:(OFString*)name error:(OFError**)error
{
    [self.jsonWireClient postSetFrame:name session:self.session.sessionId error:error];
}

-(void) setWindow:(OFString*)windowHandle
{
        OFError* error;
    [self setWindow:windowHandle error:&error];
        [self addError:error];
}

-(void) setWindow:(OFString*)windowHandle error:(OFError**)error
{
    [self.jsonWireClient postSetWindow:windowHandle session:self.session.sessionId error:error];
}

-(void) closeWindow:(OFString*)windowHandle
{
        OFError* error;
    [self closeWindow:windowHandle error:&error];
        [self addError:error];
}

-(void) closeWindow:(OFString*)windowHandle error:(OFError**)error
{
    [self.jsonWireClient deleteWindowWithSession:self.session.sessionId error:error];
}

-(void) setWindowSize:(SIZE_TYPE)size window:(OFString*)windowHandle
{
        OFError *error;
    [self setWindowSize:size window:windowHandle error:&error];
        [self addError:error];
}

-(void) setWindowSize:(SIZE_TYPE)size window:(OFString*)windowHandle error:(OFError**)error
{
    [self.jsonWireClient postSetWindowSize:size window:windowHandle session:self.session.sessionId error:error];
}

-(SIZE_TYPE) windowSizeForWindow:(OFString*)windowHandle
{
        OFError *error;
    SIZE_TYPE size = [self windowSizeForWindow:windowHandle error:&error];
        [self addError:error];
        return size;
}

-(SIZE_TYPE) windowSizeForWindow:(OFString*)windowHandle error:(OFError**)error
{
    return [self.jsonWireClient getWindowSizeWithWindow:windowHandle session:self.session.sessionId error:error];
}

-(void) setWindowPosition:(POINT_TYPE)position window:(OFString*)windowHandle
{
        OFError *error;
    [self setWindowPosition:position window:windowHandle error:&error];
        [self addError:error];
}

-(void) setWindowPosition:(POINT_TYPE)position window:(OFString*)windowHandle error:(OFError**)error
{
    [self.jsonWireClient postSetWindowPosition:position window:windowHandle session:self.session.sessionId error:error];
}

-(POINT_TYPE) windowPositionForWindow:(OFString*)windowHandle
{
        OFError *error;
    POINT_TYPE position = [self windowPositionForWindow:windowHandle error:&error];
        [self addError:error];
        return position;
}

-(POINT_TYPE) windowPositionForWindow:(OFString*)windowHandle error:(OFError**)error
{
    return [self.jsonWireClient getWindowPositionWithWindow:windowHandle session:self.session.sessionId error:error];
}

-(void) maximizeWindow:(OFString*)windowHandle
{
        OFError *error;
    [self maximizeWindow:windowHandle error:&error];
        [self addError:error];
}

-(void) maximizeWindow:(OFString*)windowHandle error:(OFError**)error
{
    [self.jsonWireClient postMaximizeWindow:windowHandle session:self.session.sessionId error:error];
}

-(OFArray*) cookies
{
        OFError *error;
    OFArray *cookies = [self cookiesWithError:&error];
        [self addError:error];
        return cookies;
}

-(OFArray*) cookiesWithError:(OFError**)error
{
    return [self.jsonWireClient getCookiesWithSession:self.session.sessionId error:error];
}

-(void) setCookie:(OFHTTPCookie*)cookie
{
        OFError *error;
    [self setCookie:cookie error:&error];
        [self addError:error];
}

-(void) setCookie:(OFHTTPCookie*)cookie error:(OFError**)error
{
    [self.jsonWireClient postCookie:cookie session:self.session.sessionId error:error];
}

-(void) deleteCookies
{
        OFError *error;
    [self deleteCookiesWithError:&error];
        [self addError:error];
}

-(void) deleteCookiesWithError:(OFError**)error
{
    [self.jsonWireClient deleteCookiesWithSession:self.session.sessionId error:error];
}

-(void) deleteCookie:(OFString*)cookieName
{
        OFError *error;
    [self deleteCookie:cookieName error:&error];
        [self addError:error];
}

-(void) deleteCookie:(OFString*)cookieName error:(OFError**)error
{
    [self.jsonWireClient deleteCookie:cookieName session:self.session.sessionId error:error];
}

-(OFString*) pageSource
{
    OFError *error;
    OFString *source = [self pageSourceWithError:&error];
        [self addError:error];
        return source;
}

-(OFString*) pageSourceWithError:(OFError**)error
{
    return [self.jsonWireClient getSourceWithSession:self.session.sessionId error:error];
}

-(OFString*) title
{
    OFError *error;
    OFString *title = [self titleWithError:&error];
        return title;
}

-(OFString*) titleWithError:(OFError**)error
{
    return [self.jsonWireClient getTitleWithSession:self.session.sessionId error:error];
}

-(SEWebElement*) findElementBy:(SEBy*)by
{
        OFError *error;
    SEWebElement *element = [self findElementBy:by error:&error];
        [self addError:error];
    return element;
}

-(SEWebElement*) findElementBy:(SEBy*)by error:(OFError**)error
{
    SEWebElement *element = [self.jsonWireClient postElement:by session:self.session.sessionId error:error];
    return element != nil && element.opaqueId != nil ? element : nil;
}

-(OFArray*) findElementsBy:(SEBy*)by
{
        OFError *error;
    OFArray *elements = [self findElementsBy:by error:&error];
        [self addError:error];
        return elements;
}

-(OFArray*) findElementsBy:(SEBy*)by error:(OFError**)error
{
    OFArray *elements = [self.jsonWireClient postElements:by session:self.session.sessionId error:error];
    if (elements == nil || elements.count < 1) {
        return [OFArray new];
    }
    SEWebElement *element = [elements objectAtIndex:0];
    if (element == nil || element.opaqueId == nil) {
        return [OFArray new];
    }
    return elements;
}

-(SEWebElement*) activeElement
{
        OFError *error;
    SEWebElement *element = [self activeElementWithError:&error];
        [self addError:error];
        return element;
}

-(SEWebElement*) activeElementWithError:(OFError**)error
{
    return [self.jsonWireClient postActiveElementWithSession:self.session.sessionId error:error];
}

-(void) sendKeys:(OFString*)keyString
{
        OFError *error;
    [self sendKeys:keyString error:&error];
        [self addError:error];
}

-(void) sendKeys:(OFString*)keyString error:(OFError**)error
{
    of_unichar_t keys[keyString.length+1];
    for(size_t i=0; i < keyString.length; i++)
        keys[i] = [keyString characterAtIndex:i];
    keys[keyString.length] = '\0';
    [self.jsonWireClient postKeys:keys session:self.session.sessionId error:error];
}

-(SEScreenOrientation) orientation
{
        OFError *error;
    SEScreenOrientation orientation = [self orientationWithError:&error];
        [self addError:error];
        return orientation;
}

-(SEScreenOrientation) orientationWithError:(OFError**)error
{
    return [self.jsonWireClient getOrientationWithSession:self.session.sessionId error:error];
}

-(void) setOrientation:(SEScreenOrientation)orientation
{
        OFError* error;
    [self setOrientation:orientation error:&error];
        [self addError:error];
}

-(void) setOrientation:(SEScreenOrientation)orientation error:(OFError**)error
{
    [self.jsonWireClient postOrientation:orientation session:self.session.sessionId error:error];
}

-(OFString*)alertText
{
    OFError *error;
        OFString *alertText = [self alertTextWithError:&error];
        [self addError:error];
        return alertText;
}

-(OFString*)alertTextWithError:(OFError**)error
{
    return [self.jsonWireClient getAlertTextWithSession:self.session.sessionId error:error];
}

-(void) setAlertText:(OFString*)text
{
        OFError* error;
    [self setAlertText:text error:&error];
        [self addError:error];
}

-(void) setAlertText:(OFString*)text error:(OFError**)error
{
    [self.jsonWireClient postAlertText:text session:self.session.sessionId error:error];
}

-(void) acceptAlert
{
        OFError *error;
    [self acceptAlertWithError:&error];
        [self addError:error];
}

-(void) acceptAlertWithError:(OFError**)error
{
    [self.jsonWireClient postAcceptAlertWithSession:self.session.sessionId error:error];
}

-(void) dismissAlert
{
        OFError *error;
    [self dismissAlertWithError:&error];
        [self addError:error];
}

-(void) dismissAlertWithError:(OFError**)error
{
    [self.jsonWireClient postDismissAlertWithSession:self.session.sessionId error:error];
}

-(void) moveMouseWithXOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset
{
        [self moveMouseToElement:nil xOffset:xOffset yOffset:yOffset];
}

-(void) moveMouseToElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset
{
        OFError *error;
    [self moveMouseToElement:element xOffset:xOffset yOffset:yOffset error:&error];
        [self addError:error];
}

-(void) moveMouseToElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset
                     error:(OFError**)error {
    [self.jsonWireClient postMoveMouseToElement:element xOffset:xOffset yOffset:yOffset session:self.session.sessionId error:error];
}

-(void) clickPrimaryMouseButton
{
        [self clickMouseButton:SELENIUM_MOUSE_LEFT_BUTTON];
}

-(void) clickMouseButton:(SEMouseButton)button
{
        OFError *error;
    [self clickMouseButton:button error:&error];
        [self addError:error];
}

-(void) clickMouseButton:(SEMouseButton)button error:(OFError**)error
{
    [self.jsonWireClient postClickMouseButton:button session:self.session.sessionId error:error];
}

-(void) mouseButtonDown:(SEMouseButton)button
{
        OFError *error;
    [self mouseButtonDown:button error:&error];
        [self addError:error];
}

-(void) mouseButtonDown:(SEMouseButton)button error:(OFError**)error
{
    [self.jsonWireClient postMouseButtonDown:button session:self.session.sessionId error:error];
}

-(void) mouseButtonUp:(SEMouseButton)button
{
        OFError *error;
    [self mouseButtonUp:button error:&error];
        [self addError:error];
}

-(void) mouseButtonUp:(SEMouseButton)button error:(OFError**)error
{
    [self.jsonWireClient postMouseButtonUp:button session:self.session.sessionId error:error];
}

-(void) doubleclick
{
        OFError *error;
    [self doubleclickWithError:&error];
        [self addError:error];
}

-(void) doubleclickWithError:(OFError**)error
{
    [self.jsonWireClient postDoubleClickWithSession:self.session.sessionId error:error];
}

-(void) tapElement:(SEWebElement*)element
{
        OFError *error;
    [self tapElement:element error:&error];
        [self addError:error];
}

-(void) tapElement:(SEWebElement*)element error:(OFError**)error
{
    [self.jsonWireClient postTapElement:element session:self.session.sessionId error:error];
}

-(void) fingerDownAt:(POINT_TYPE)point
{
        OFError *error;
    [self fingerDownAt:point error:&error];
        [self addError:error];
}

-(void) fingerDownAt:(POINT_TYPE)point error:(OFError**)error
{
    [self.jsonWireClient postFingerDownAt:point session:self.session.sessionId error:error];
}

-(void) fingerUpAt:(POINT_TYPE)point
{
        OFError *error;
    [self fingerUpAt:point error:&error];
        [self addError:error];
}

-(void) fingerUpAt:(POINT_TYPE)point error:(OFError**)error
{
    [self.jsonWireClient postFingerUpAt:point session:self.session.sessionId error:error];
}

-(void) moveFingerTo:(POINT_TYPE)point
{
        OFError *error;
    [self moveFingerTo:point error:&error];
        [self addError:error];
}

-(void) moveFingerTo:(POINT_TYPE)point error:(OFError**)error
{
    [self.jsonWireClient postMoveFingerTo:point session:self.session.sessionId error:error];
}

-(void) scrollfromElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset
{
    OFError *error;
    [self scrollfromElement:element xOffset:xOffset yOffset:yOffset error:&error];
    [self addError:error];
}

-(void) scrollfromElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset error:(OFError**)error
{
    [self.jsonWireClient postStartScrollingAtParticularLocation:element xOffset:xOffset yOffset:yOffset session:self.session.sessionId error:error];
}

-(void) scrollTo:(POINT_TYPE)position
{
    OFError *error;
    [self scrollTo:position error:&error];
    [self addError:error];
}

-(void) scrollTo:(POINT_TYPE)position error:(OFError**)error
{
    [self.jsonWireClient postScrollfromAnywhereOnTheScreenWithSession:position session:self.session.sessionId error:error];
}

-(void) doubletapElement:(SEWebElement*)element
{
        OFError *error;
    [self doubletapElement:element error:&error];
        [self addError:error];
}

-(void) doubletapElement:(SEWebElement*)element error:(OFError**)error
{
    [self.jsonWireClient postDoubleTapElement:element session:self.session.sessionId error:error];
}

-(void) pressElement:(SEWebElement*)element
{
        OFError *error;
    [self pressElement:element error:&error];
        [self addError:error];
}

-(void) pressElement:(SEWebElement*)element error:(OFError**)error
{
    [self.jsonWireClient postPressElement:element session:self.session.sessionId error:error];
}

-(void) performTouchAction:(SETouchAction *)touchAction
{
    OFError *error;
    [self performTouchAction:touchAction error:&error];
    [self addError:error];
}

- (void) performTouchAction:(SETouchAction *)touchAction error:(OFError **)error {
    [self.jsonWireClient postTouchAction:touchAction session:self.session.sessionId error:error];
}


-(void) flickfromElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset speed:(ssize_t)speed
{
    OFError *error;
    [self flickfromElement:element xOffset:xOffset yOffset:yOffset speed:speed error:&error];
    [self addError:error];
}

-(void) flickfromElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset speed:(ssize_t)speed error:(OFError**)error
{
    [self.jsonWireClient postFlickFromParticularLocation:element xOffset:xOffset yOffset:yOffset speed:speed session:self.session.sessionId error:error];
}

-(void) flickWithXSpeed:(ssize_t)xSpeed ySpeed:(ssize_t)ySpeed
{
    OFError *error;
    [self flickWithXSpeed:xSpeed ySpeed:ySpeed error:&error];
    [self addError:error];
}

-(void) flickWithXSpeed:(ssize_t)xSpeed ySpeed:(ssize_t)ySpeed error:(OFError**)error
{
    [self.jsonWireClient postFlickFromAnywhere:xSpeed ySpeed:ySpeed session:self.session.sessionId error:error];
}

-(SELocation*) location
{
    OFError *error;
    SELocation *location = [self locationWithError:&error];
    [self addError:error];
    return location;
}

-(SELocation*) locationWithError:(OFError**)error
{
    return [self.jsonWireClient getLocationAndReturnError:self.session.sessionId error:error];
}

-(void) setLocation:(SELocation*)location
{
    OFError *error;
    [self setLocation:location error:&error];
    [self addError:error];
}

-(void) setLocation:(SELocation*)location error:(OFError**)error
{
    [self.jsonWireClient postLocation:location session:self.session.sessionId error:error];
}

-(OFArray*) allLocalStorageKeys
{
    OFError *error;
    OFArray *allLocalStorageKeys = [self allLocalStorageKeysWithError:&error];
    [self addError:error];
    return allLocalStorageKeys;

}

-(OFArray*) allLocalStorageKeysWithError:(OFError**)error
{
    return [self.jsonWireClient getAllLocalStorageKeys:self.session.sessionId error:error];
}

-(void) setLocalStorageValue:(OFString*)value forKey:(OFString*)key
{
    OFError *error;
    [self setLocalStorageValue:value forKey:key error:&error];
    [self addError:error];
}

-(void) setLocalStorageValue:(OFString*)value forKey:(OFString*)key error:(OFError**)error
{
    [self.jsonWireClient postSetLocalStorageItemForKey:key value:value session:self.session.sessionId error:error];
}

-(void) clearLocalStorage
{
    OFError *error;
    [self clearLocalStorageWithError:&error];
    [self addError:error];
}

-(void) clearLocalStorageWithError:(OFError**)error
{
    [self.jsonWireClient deleteLocalStorage:self.session.sessionId error:error];
}

-(void) localStorageItemForKey:(OFString*)key
{
    OFError *error;
    [self localStorageItemForKey:key error:&error];
    [self addError:error];
}

-(void) localStorageItemForKey:(OFString*)key error:(OFError**)error
{
    [self.jsonWireClient getLocalStorageItemForKey:key session:self.session.sessionId error:error];
}

-(void) deleteLocalStorageItemForKey:(OFString*)key
{
    OFError *error;
    [self deleteLocalStorageItemForKey:key error:&error];
    [self addError:error];
}

-(void) deleteLocalStorageItemForKey:(OFString*)key error:(OFError**)error
{
    [self.jsonWireClient deleteLocalStorageItemForGivenKey:key session:self.session.sessionId error:error];
}

-(ssize_t) countOfItemsInLocalStorage
{
    OFError *error;
    ssize_t numItems = [self countOfItemsInLocalStorageWithError:&error];
    [self addError:error];
    return numItems;
}

-(ssize_t) countOfItemsInLocalStorageWithError:(OFError**)error
{
    return [self.jsonWireClient getLocalStorageSize:self.session.sessionId error:error];
}

-(OFArray*) allSessionStorageKeys
{
    OFError *error;
    OFArray *allStorageKeys = [self allLocalStorageKeysWithError:&error];
    return allStorageKeys;
}

-(OFArray*) allSessionStorageKeysWithError:(OFError**)error
{
    return [self.jsonWireClient getAllStorageKeys:self.session.sessionId error:error];
}

-(void) setSessionStorageValue:(OFString*)value forKey:(OFString*)key
{
    OFError *error;
    [self setSessionStorageValue:value forKey:key error:&error];
    [self addError:error];
}

-(void) setSessionStorageValue:(OFString*)value forKey:(OFString*)key error:(OFError**)error
{
    [self.jsonWireClient postSetStorageItemForKey:key value:value session:self.session.sessionId error:error];
}

-(void) clearSessionStorage
{
    OFError *error;
    [self clearSessionStorageWithError:&error];
    [self addError:error];
}

-(void) clearSessionStorageWithError:(OFError**)error
{
    [self.jsonWireClient deleteStorage:self.session.sessionId error:error];
}

-(void) sessionStorageItemForKey:(OFString*)key
{
    OFError *error;
    [self sessionStorageItemForKey:key error:&error];
    [self addError:error];
}

-(void) sessionStorageItemForKey:(OFString*)key error:(OFError**)error
{
    [self.jsonWireClient getStorageItemForKey:key  session:self.session.sessionId error:error];
}

-(void) deleteStorageItemForKey:(OFString*)key
{
    OFError *error;
    [self deleteStorageItemForKey:key error:&error];
    [self addError:error];
}

-(void) deleteStorageItemForKey:(OFString*)key error:(OFError**)error
{
    [self.jsonWireClient deleteStorageItemForGivenKey:key session:self.session.sessionId error:error];
}

-(ssize_t) countOfItemsInStorage
{
    OFError *error;
    ssize_t numItems = [self countOfItemsInStorageWithError:&error];
    [self addError:error];
    return numItems;
}

-(ssize_t) countOfItemsInStorageWithError:(OFError**)error
{
    return [self.jsonWireClient getStorageSize:self.session.sessionId error:error];
}

-(OFArray*) getLogForType:(SELogType)type
{
    OFError *error;
    OFArray *logsForType = [self getLogForType:type error:&error];
    [self addError:error];
    return logsForType;
}

-(OFArray*) getLogForType:(SELogType)type error:(OFError**)error
{
    return [self.jsonWireClient  getLogForGivenLogType:type session:self.session.sessionId error:error];
}

-(OFArray*) allLogTypes
{
    OFError *error;
    OFArray *logTypes = [self allLogTypesWithError:&error];
    [self addError:error];
    return logTypes;
}

-(OFArray*) allLogTypesWithError:(OFError**)error
{
    return [self.jsonWireClient getLogTypes:self.session.sessionId error:error];
}

-(SEApplicationCacheStatus) applicationCacheStatus
{
    OFError* error;
    SEApplicationCacheStatus status = [self applicationCacheStatusWithError:&error];
        [self addError:error];
        return status;
}

-(SEApplicationCacheStatus) applicationCacheStatusWithError:(OFError**)error
{
    return [self.jsonWireClient getApplicationCacheStatusWithSession:self.session.sessionId error:error];
}


#pragma mark - 3.0 methods
/////////////////
// 3.0 METHODS //
/////////////////

-(void) shakeDevice {
    OFError *error;
    [self shakeDeviceWithError:&error];
    [self addError:error];
}

-(void) shakeDeviceWithError:(OFError**)error {
    [self.jsonWireClient postShakeDeviceWithSession:self.session.sessionId error:error];
}

-(void) lockDeviceScreen:(ssize_t)seconds {
    OFError *error;
    [self lockDeviceScreen:seconds error:&error];
    [self addError:error];
}

-(void) lockDeviceScreen:(ssize_t)seconds error:(OFError**)error {
    [self.jsonWireClient postLockDeviceWithSession:self.session.sessionId seconds:seconds error:error];
}

-(void) unlockDeviceScreen:(ssize_t)seconds {
    OFError *error;
    [self unlockDeviceScreen:seconds error:&error];
    [self addError:error];
}

-(void) unlockDeviceScreen:(ssize_t)seconds error:(OFError**)error {
    [self.jsonWireClient postUnlockDeviceWithSession:self.session.sessionId error:error];
}

-(BOOL) isDeviceLocked {
    OFError *error;
    BOOL locked = [self isDeviceLockedWithError:&error];
    [self addError:error];
    return locked;
}

-(BOOL) isDeviceLockedWithError:(OFError**)error {
    return [self.jsonWireClient postIsDeviceLockedWithSession:self.session.sessionId error:error];
}

-(void) pressKeycode:(ssize_t)keycode metaState:(ssize_t)metastate error:(OFError**)error {
    [self.jsonWireClient postPressKeycode:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) longPressKeycode:(ssize_t)keycode metaState:(ssize_t)metastate error:(OFError**)error {
    [self.jsonWireClient postLongPressKeycode:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) triggerKeyEvent:(ssize_t)keycode metaState:(ssize_t)metastate error:(OFError**)error {
    [self.jsonWireClient postKeyEvent:keycode metastate:metastate session:self.session.sessionId error:error];
}

-(void) rotateDevice:(SEScreenOrientation)orientation
{
    OFError *error;
    [self rotateDevice:orientation error:&error];
    [self addError:error];
}

-(void) rotateDevice:(SEScreenOrientation)orientation error:(OFError**)error {
    [self.jsonWireClient postRotate:orientation session:self.session.sessionId error:error];
}

-(OFString*)currentActivity
{
    OFError *error;
    OFString *currentActivity = [self currentActivityWithError:&error];
    [self addError:error];
    return currentActivity;
}

-(OFString*)currentActivityWithError:(OFError**)error {
    return [self.jsonWireClient getCurrentActivityForDeviceForSession:self.session.sessionId error:error];
}

-(void)installAppAtPath:(OFString*)appPath {
    OFError *error;
    [self installAppAtPath:appPath error:&error];
    [self addError:error];
}

-(void)installAppAtPath:(OFString*)appPath error:(OFError**)error {
    [self.jsonWireClient postInstallApp:appPath session:self.session.sessionId error:error];
}

-(void)removeApp:(OFString*)bundleId {
    OFError *error;
    [self removeApp:bundleId error:&error];
    [self addError:error];
}

-(void)removeApp:(OFString*)bundleId error:(OFError**)error {
    [self.jsonWireClient postRemoveApp:bundleId session:self.session.sessionId error:error];
}

-(BOOL)isAppInstalled:(OFString*)bundleId
{
    OFError *error;
    BOOL installed = [self isAppInstalled:bundleId error:&error];
    [self addError:error];
    return installed;
}

-(BOOL)isAppInstalled:(OFString*)bundleId error:(OFError**)error {
    return [self.jsonWireClient postIsAppInstalledWithBundleId:bundleId session:self.session.sessionId error:error];
}

-(void) hideKeyboard {
    OFError *error;
    [self hideKeyboardWithError:&error];
    [self addError:error];
}

-(void) hideKeyboardWithError:(OFError**)error {
    [self.jsonWireClient postHideKeyboardWithSession:self.session.sessionId error:error];
}

-(void) pushFileToPath:(OFString*)filePath data:(OFDataArray*)data {
    OFError *error;
    [self pushFileToPath:filePath data:data error:&error];
    [self addError:error];
}

-(void) pushFileToPath:(OFString*)filePath data:(OFDataArray*)data error:(OFError**) error {
    [self.jsonWireClient postPushFileToPath:filePath data:data session:self.session.sessionId error:error];
}

-(OFDataArray*) pullFileAtPath:(OFString*)filePath {
    OFError *error;
    OFDataArray *data = [self pullFileAtPath:filePath error:&error];
    [self addError:error];
    return data;
}

-(OFDataArray*) pullFileAtPath:(OFString*)filePath error:(OFError**) error {
    return [self.jsonWireClient postPullFileAtPath:filePath session:self.session.sessionId error:error];
}


-(OFDataArray*) pullFolderAtPath:(OFString*)filePath {
    OFError *error;
    OFDataArray *data = [self pullFolderAtPath:filePath error:&error];
    [self addError:error];
    return data;
}

-(OFDataArray*) pullFolderAtPath:(OFString*)filePath error:(OFError**) error {
    return [self.jsonWireClient postPullFolderAtPath:filePath session:self.session.sessionId error:error];
}

-(void) toggleAirplaneMode {
    OFError *error;
    [self toggleAirplaneModeWithError:&error];
    [self addError:error];
}

-(void) toggleAirplaneModeWithError:(OFError**)error {
    [self.jsonWireClient postToggleAirplaneModeWithSession:self.session.sessionId error:error];
}

-(void) toggleCellularData {
    OFError *error;
    [self toggleCellularDataWithError:&error];
    [self addError:error];
}

-(void) toggleCellularDataWithError:(OFError**)error {
    [self.jsonWireClient postToggleDataWithSession:self.session.sessionId error:error];
}

-(void) toggleWifi {
    OFError *error;
    [self toggleWifiWithError:&error];
    [self addError:error];
}

-(void) toggleWifiWithError:(OFError**)error {
    [self.jsonWireClient postToggleWifiWithSession:self.session.sessionId error:error];
}

-(void) toggleLocationServices {
    OFError *error;
    [self toggleLocationServicesWithError:&error];
    [self addError:error];
}

-(void) toggleLocationServicesWithError:(OFError**)error {
    [self.jsonWireClient postToggleLocationServicesWithSession:self.session.sessionId error:error];
}

-(void) openNotifications {
    OFError *error;
    [self openNotificationsWithError:&error];
    [self addError:error];
}

-(void) openNotificationsWithError:(OFError**)error {
    [self.jsonWireClient postOpenNotificationsWithSession:self.session.sessionId error:error];
}

-(void) startActivity:(OFString*)activity package:(OFString*)package {
    [self startActivity:activity package:package waitActivity:nil waitPackage:nil];
}

-(void) startActivity:(OFString*)activity package:(OFString*)package waitActivity:(OFString*)waitActivity waitPackage:(OFString*)waitPackage {
    OFError *error;
    [self startActivity:activity package:package waitActivity:waitActivity waitPackage:waitPackage error:&error];
    [self addError:error];
}

-(void) startActivity:(OFString*)activity package:(OFString*)package waitActivity:(OFString*)waitActivity waitPackage:(OFString*)waitPackage error:(OFError**)error {
    [self.jsonWireClient postStartActivity:activity package:package waitActivity:waitActivity waitPackage:waitPackage session:self.session.sessionId error:error];
}

-(void) launchApp
{
    OFError *error;
    [self launchAppWithError:&error];
    [self addError:error];
}

-(void) launchAppWithError:(OFError**)error
{
    [self.jsonWireClient postLaunchAppWithSession:self.session.sessionId error:error];
}

-(void) closeApp
{
    OFError *error;
    [self closeAppWithError:&error];
    [self addError:error];
}

-(void) closeAppWithError:(OFError**)error
{
    [self.jsonWireClient postCloseAppWithSession:self.session.sessionId error:error];
}

-(void) resetApp
{
    OFError *error;
    [self resetAppWithError:&error];
    [self addError:error];
}

-(void) resetAppWithError:(OFError**)error
{
    [self.jsonWireClient postResetAppWithSession:self.session.sessionId error:error];
}

-(void) runAppInBackground:(ssize_t)seconds
{
    OFError *error;
    [self runAppInBackground:seconds error:&error];
    [self addError:error];
}

-(void) runAppInBackground:(ssize_t)seconds error:(OFError**)error
{
    [self.jsonWireClient postRunAppInBackground:seconds session:self.session.sessionId error:error];
}

-(void) endTestCodeCoverage
{
    OFError *error;
    [self endTestCodeCoverageWithError:&error];
    [self addError:error];
}

-(void) endTestCodeCoverageWithError:(OFError**)error
{
    [self.jsonWireClient postEndTestCoverageWithSession:self.session.sessionId error:error];
}

-(OFString*)appStrings {
    return [self appStringsForLanguage:nil];
}

-(OFString*)appStringsForLanguage:(OFString *)languageCode
{
    OFError *error;
    OFString *strings = [self appStringsForLanguage:languageCode error:&error];
    [self addError:error];
    return strings;
}

-(OFString*)appStringsForLanguage:(OFString*)languageCode error:(OFError**)error {
    return [self.jsonWireClient getAppStringsForLanguage:languageCode session:self.session.sessionId error:error];
}

-(void) setAppiumSettings:(OFDictionary*)settings {
    OFError *error;
    [self setAppiumSettings:settings error:&error];
    [self addError:error];
}

-(void) setAppiumSettings:(OFDictionary*)settings error:(OFError**)error {
    [self.jsonWireClient postSetAppiumSettings:settings session:self.session.sessionId error:error];
}

-(OFDictionary*) appiumSettings {
    OFError *error;
    OFDictionary *settings = [self appiumSettingsWithError:&error];
    [self addError:error];
    return settings;
}

-(OFDictionary*) appiumSettingsWithError:(OFError**)error {
    return [self.jsonWireClient getAppiumSettingsWithSession:self.session.sessionId error:error];
}

@end
