//
//  SEJsonWireClient.h
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "SESession.h"
#import "SECapabilities.h"
#import "SEWebElement.h"
#import "SEBy.h"
#import "SEEnums.h"
#import "SELocation.h"

@class SEBy;
@class SECapabilities;
@class SEStatus;
@class SESession;
@class SEWebElement;
@class SELocation;
@class SETouchAction;

@interface SEJsonWireClient : OFObject

@property OFError *lastError;
@property OFMutableArray *errors;

-(id) initWithServerAddress:(OFString*)address port:(ssize_t)port error:(OFError**)error;
-(void) addError:(OFError*)error;

#pragma mark - JSON-Wire Protocol Implementation

// GET /status
-(SEStatus*) getStatusAndReturnError:(OFError**)error;

// POST /session
-(SESession*) postSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities andRequiredCapabilities:(SECapabilities*)requiredCapabilities error:(OFError**)error;

// GET /sessions
-(OFArray*) getSessionsAndReturnError:(OFError**)error;

// GET /session/:sessionId
-(SESession*) getSessionWithSession:(OFString*)sessionId error:(OFError**)error;

// DELETE /session/:sessionId
-(void) deleteSessionWithSession:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionid/contexts
-(OFArray*) getContextsForSession:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionid/context
-(OFString*) getContextForSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionid/context
-(void) postContext:(OFString*)context session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/timeouts
-(void) postTimeout:(ssize_t)timeoutInMilliseconds forType:(SETimeoutType)type session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/timeouts/async_script
-(void) postAsyncScriptWaitTimeout:(ssize_t)timeoutInMilliseconds session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/timeouts/implicit_wait
-(void) postImplicitWaitTimeout:(ssize_t)timeoutInMilliseconds session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/window_handle
-(OFString*) getWindowHandleWithSession:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/window_handles
-(OFArray*) getWindowHandlesWithSession:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/url
-(OFURL*) getURLWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/url
-(void) postURL:(OFURL*)url session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/forward
-(void) postForwardWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/back
-(void) postBackWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/refresh
-(void) postRefreshWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/execute
-(OFDictionary*) postExecuteScript:(OFString*)script arguments:(OFArray*)arguments session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/execute_async
-(OFDictionary*) postExecuteAsyncScript:(OFString*)script arguments:(OFArray*)arguments session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/screenshot
-(IMAGE_TYPE*) getScreenshotWithSession:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/ime/available_engines
-(OFArray*) getAvailableInputMethodEnginesWithSession:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/ime/active_engine
-(OFString*) getActiveInputMethodEngineWithSession:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/ime/activated
-(BOOL) getInputMethodEngineIsActivatedWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/ime/deactivate
-(void) postDeactivateInputMethodEngineWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/ime/activate
-(void) postActivateInputMethodEngine:(OFString*)engine session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/frame
-(void) postSetFrame:(id)name session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/window
-(void) postSetWindow:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error;

// DELETE /session/:sessionId/window
-(void) deleteWindowWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/window/:windowHandle/size
-(void) postSetWindowSize:(SIZE_TYPE)size window:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/window/:windowHandle/size
-(SIZE_TYPE) getWindowSizeWithWindow:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/window/:windowHandle/position
-(void) postSetWindowPosition:(POINT_TYPE)position window:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/window/:windowHandle/position
-(POINT_TYPE) getWindowPositionWithWindow:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/window/:windowHandle/maximize
-(void) postMaximizeWindow:(OFString*)windowHandle session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/cookie
-(OFArray*) getCookiesWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/cookie
-(void) postCookie:(OFHTTPCookie*)cookie session:(OFString*)sessionId error:(OFError**)error;

// DELETE /session/:sessionId/cookie
-(void) deleteCookiesWithSession:(OFString*)sessionId error:(OFError**)error;

// DELETE /session/:sessionId/cookie/:name
-(void) deleteCookie:(OFString*)cookieName session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/source
-(OFString*) getSourceWithSession:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/title
-(OFString*) getTitleWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/element
-(SEWebElement*) postElement:(SEBy*)locator session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/elements
-(OFArray*) postElements:(SEBy*)locator session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/element/active
-(SEWebElement*) postActiveElementWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/element/:id
// FUTURE (NOT YET IMPLEMENTED)

// POST /session/:sessionId/element/:id/element
-(SEWebElement*) postElementFromElement:(SEWebElement*)element by:(SEBy*)locator session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/element/:id/elements
-(OFArray*) postElementsFromElement:(SEWebElement*)element by:(SEBy*)locator session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/element/:id/click
-(void) postClickElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/element/:id/submit
-(void) postSubmitElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/text
-(OFString*) getElementText:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// /session/:sessionId/element/:id/value
-(void) postKeys:(of_unichar_t *)keys element:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/keys
-(void) postKeys:(of_unichar_t *)keys session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/name
-(OFString*) getElementName:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/element/:id/clear
-(void) postClearElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/selected
-(BOOL) getElementIsSelected:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/enabled
-(BOOL) getElementIsEnabled:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/attribute/:name
-(OFString*) getAttribute:(OFString*)attributeName element:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/equals/:other
-(BOOL) getEqualityForElement:(SEWebElement*)element element:(SEWebElement*)otherElement session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/displayed
-(BOOL) getElementIsDisplayed:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/location
-(POINT_TYPE) getElementLocation:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/location_in_view
-(POINT_TYPE) getElementLocationInView:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/size
-(SIZE_TYPE) getElementSize:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/element/:id/css/:propertyName
-(OFString*) getCSSProperty:(OFString*)propertyName element:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/orientation
-(SEScreenOrientation) getOrientationWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/orientation
-(void) postOrientation:(SEScreenOrientation)orientation session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/alert_text
-(OFString*) getAlertTextWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/alert_text
-(void) postAlertText:(OFString*)text session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/accept_alert
-(void) postAcceptAlertWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/dismiss_alert
-(void) postDismissAlertWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/moveto
-(void) postMoveMouseToElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/click
-(void) postClickMouseButton:(SEMouseButton)button session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/buttondown
-(void) postMouseButtonDown:(SEMouseButton)button session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/buttonup
-(void) postMouseButtonUp:(SEMouseButton)button session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/doubleclick
-(void) postDoubleClickWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/click
-(void) postTapElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/down
-(void) postFingerDownAt:(POINT_TYPE)point session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/up
-(void) postFingerUpAt:(POINT_TYPE)point session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/move
-(void) postMoveFingerTo:(POINT_TYPE)point session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/scroll
-(void) postStartScrollingAtParticularLocation:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/scroll
-(void) postScrollfromAnywhereOnTheScreenWithSession:(POINT_TYPE)point session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/doubleclick
-(void) postDoubleTapElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/longclick
-(void) postPressElement:(SEWebElement*)element session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/perform
-(void) postTouchAction:(SETouchAction *)touchAction session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/flick
-(void) postFlickFromParticularLocation:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset  speed:(ssize_t)speed session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/touch/flick
-(void) postFlickFromAnywhere:(ssize_t)xSpeed ySpeed:(ssize_t)ySpeed session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/location
-(SELocation*) getLocationAndReturnError:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/location
-(void) postLocation:(SELocation*)location session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/local_storage
-(OFArray*) getAllLocalStorageKeys:(OFString*)sessionId error:(OFError**)error;

//POST /session/:sessionId/local_storage
-(void) postSetLocalStorageItemForKey:(OFString*)key value:(OFString*)value session:(OFString*)sessionId error:(OFError**)error;

// DELETE /session/:sessionId/local_storage
-(void) deleteLocalStorage:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/local_storage/key/:key
-(void) getLocalStorageItemForKey:(OFString*)key session:(OFString*)sessionId error:(OFError**)error;

//DELETE /session/:sessionId/local_storage/key/:key
-(void) deleteLocalStorageItemForGivenKey:(OFString*)key session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/local_storage/size
-(ssize_t) getLocalStorageSize:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/session_storage
-(OFArray*) getAllStorageKeys:(OFString*)sessionId error:(OFError**)error;

//POST /session/:sessionId/session_storage
-(void) postSetStorageItemForKey:(OFString*)key value:(OFString*)value session:(OFString*)sessionId error:(OFError**)error;

// DELETE /session/:sessionId/session_storage
-(void) deleteStorage:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/session_storage/key/:key
-(void) getStorageItemForKey:(OFString*)key session:(OFString*)sessionId error:(OFError**)error;

//DELETE /session/:sessionId/session_storage/key/:key
-(void) deleteStorageItemForGivenKey:(OFString*)key session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/session_storage/size
-(ssize_t) getStorageSize:(OFString*) sessionId error:(OFError**) error;

// POST /session/:sessionId/log
-(OFArray*) getLogForGivenLogType:(SELogType)type session:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/log/types
-(OFArray*) getLogTypes:(OFString*)sessionId error:(OFError**)error;

// GET /session/:sessionId/application_cache/status
-(SEApplicationCacheStatus) getApplicationCacheStatusWithSession:(OFString*)sessionId error:(OFError**)error;


#pragma mark - 3.0 methods
/////////////////
// 3.0 METHODS //
/////////////////

// POST /wd/hub/session/:sessionId/appium/device/shake
-(void) postShakeDeviceWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/lock
-(void) postLockDeviceWithSession:(OFString*)sessionId seconds:(ssize_t)seconds error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/unlock
-(void) postUnlockDeviceWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/is_locked
-(BOOL) postIsDeviceLockedWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/press_keycode
-(void) postPressKeycode:(ssize_t)keycode metastate:(ssize_t)metaState session:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/long_press_keycode
-(void) postLongPressKeycode:(ssize_t)keycode metastate:(ssize_t)metaState session:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/keyevent
-(void) postKeyEvent:(ssize_t)keycode metastate:(ssize_t)metaState session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/appium/app/rotate
- (void)postRotate:(SEScreenOrientation)orientation session:(OFString*)sessionId error:(OFError **)error;

// GET /wd/hub/session/:sessionId/appium/device/current_activity
-(OFString*) getCurrentActivityForDeviceForSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/install_app
- (void)postInstallApp:(OFString*)appPath session:(OFString*)sessionId error:(OFError **)error;

// POST /wd/hub/session/:sessionId/appium/device/remove_app
- (void)postRemoveApp:(OFString*)appPath session:(OFString*)sessionId error:(OFError **)error;

// POST /wd/hub/session/:sessionId/appium/device/app_installed
-(BOOL) postIsAppInstalledWithBundleId:(OFString*)bundleId session:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/hide_keyboard
-(void) postHideKeyboardWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/push_file
- (void)postPushFileToPath:(OFString*)path data:(OFDataArray*)data session:(OFString*)sessionId error:(OFError **)error;

// POST /wd/hub/session/:sessionId/appium/device/pull_file
-(OFDataArray*) postPullFileAtPath:(OFString*)path session:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/pull_folder
-(OFDataArray*) postPullFolderAtPath:(OFString*)path session:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/toggle_airplane_mode
-(void) postToggleAirplaneModeWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/toggle_data
-(void) postToggleDataWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/toggle_wifi
-(void) postToggleWifiWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/toggle_location_services
-(void) postToggleLocationServicesWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/open_notifications
-(void) postOpenNotificationsWithSession:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/device/start_activity
-(void) postStartActivity:(OFString*)activity package:(OFString*)package waitActivity:(OFString*)waitActivity waitPackage:(OFString*)waitPackage session:(OFString*)sessionId error:(OFError**)error;

// POST /session/:sessionId/appium/app/launch
- (void)postLaunchAppWithSession:(OFString *)sessionId error:(OFError **)error;

// POST /session/:sessionId/appium/app/close
- (void)postCloseAppWithSession:(OFString *)sessionId error:(OFError **)error;

// POST /session/:sessionId/appium/app/reset
- (void)postResetAppWithSession:(OFString *)sessionId error:(OFError **)error;

// POST /session/:sessionId/appium/app/background
- (void)postRunAppInBackground:(ssize_t)seconds session:(OFString *)sessionId error:(OFError **)error;

// POST /wd/hub/session/:sessionId/appium/app/end_test_coverage
- (void)postEndTestCoverageWithSession:(OFString *)sessionId error:(OFError **)error;

// GET /wd/hub/session/:sessionId/appium/app/strings
-(OFString*) getAppStringsForLanguage:(OFString*)languageCode session:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/element/:elementId?/value
-(void) postSetValueForElement:(SEWebElement*)element value:(OFString*)value isUnicode:(BOOL)isUnicode session:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/element/:elementId?/replace_value
-(void) postReplaceValueForElement:(SEWebElement*)element value:(OFString*)value isUnicode:(BOOL)isUnicode session:(OFString*)sessionId error:(OFError**)error;

// POST /wd/hub/session/:sessionId/appium/settings
-(void) postSetAppiumSettings:(OFDictionary*)settings session:(OFString*)sessionId error:(OFError**)error;

// GET /wd/hub/session/:sessionId/appium/settings
-(OFDictionary*) getAppiumSettingsWithSession:(OFString*)sessionId error:(OFError**)error;

@end
