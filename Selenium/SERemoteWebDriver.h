//
//  SERemoteWebDriver.h
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "SECapabilities.h"
#import "SEBy.h"
#import "SEWebElement.h"
#import "SESession.h"
#import "SEEnums.h"
#import "SETouchAction.h"

@class SECapabilities;
@class SEBy;
@class SEWebElement;
@class SESession;

@interface SERemoteWebDriver : OFObject

@property SESession *session;
@property (readonly) SEStatus *status;
@property (readonly) OFError *lastError;
@property (readonly) OFArray *errors;

@property (readonly) OFString *alertText;
@property (readonly) OFArray *allContexts;
@property (readonly) OFArray *allLogTypes;
@property (readonly) OFArray *allSessions;
@property (readonly) OFArray *allWindows;
@property (readonly) OFDictionary *appiumSettings;
@property OFString *context;
@property (readonly) OFArray *cookies;
@property SELocation *location;
@property (readonly) SEScreenOrientation orientation;
@property (readonly) OFString *pageSource;
@property (readonly) IMAGE_TYPE *screenshot;
@property (readonly) OFString *title;
@property OFURL *url;
@property OFString *window;

-(id) initWithServerAddress:(OFString *)address port:(ssize_t)port;
-(id) initWithServerAddress:(OFString*)address port:(ssize_t)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(OFError**)error;
-(void)quit;
-(void)quitWithError:(OFError**)error;
-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites;
-(SESession*) startSessionWithDesiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(OFError**)error;
-(OFArray*) allSessions;
-(OFArray*) allSessionsWithError:(OFError**)error;
-(OFArray*) allContexts;
-(OFArray*) allContextsWithError:(OFError**)error;
-(OFString*) context;
-(OFString*) contextWithError:(OFError**)error;
-(void) setContext:(OFString*)context;
-(void) setContext:(OFString*)context error:(OFError**)error;
-(void) setTimeout:(ssize_t)timeoutInMilliseconds forType:(SETimeoutType)type;
-(void) setTimeout:(ssize_t)timeoutInMilliseconds forType:(SETimeoutType)type error:(OFError**)error;
-(void) setAsyncScriptTimeout:(ssize_t)timeoutInMilliseconds;
-(void) setAsyncScriptTimeout:(ssize_t)timeoutInMilliseconds error:(OFError**)error;
-(void) setImplicitWaitTimeout:(ssize_t)timeoutInMilliseconds;
-(void) setImplicitWaitTimeout:(ssize_t)timeoutInMilliseconds error:(OFError**)error;
-(OFString*) window;
-(OFString*) windowWithError:(OFError**)error;
-(OFArray*) allWindows;
-(OFArray*) allWindowsWithError:(OFError**)error;
-(OFURL*) url;
-(OFURL*) urlWithError:(OFError**)error;
-(void) setUrl:(OFURL*)url;
-(void) setUrl:(OFURL*)url error:(OFError**)error;
-(void) forward;
-(void) forwardWithError:(OFError**)error;
-(void) back;
-(void) backWithError:(OFError**)error;
-(void) refresh;
-(void) refreshWithError:(OFError**)error;
-(OFDictionary*) executeScript:(OFString*)script;
-(OFDictionary*) executeScript:(OFString*)script arguments:(OFArray*)arguments;
-(OFDictionary*) executeScript:(OFString*)script arguments:(OFArray*)arguments error:(OFError**)error;
-(OFDictionary*) executeAnsynchronousScript:(OFString*)script;
-(OFDictionary*) executeAnsynchronousScript:(OFString*)script arguments:(OFArray*)arguments;
-(OFDictionary*) executeAnsynchronousScript:(OFString*)script arguments:(OFArray*)arguments error:(OFError**)error;
-(IMAGE_TYPE*) screenshot;
-(IMAGE_TYPE*) screenshotWithError:(OFError**)error;
-(OFArray*) availableInputMethodEngines;
-(OFArray*) availableInputMethodEnginesWithError:(OFError**)error;
-(OFString*) activeInputMethodEngine;
-(OFString*) activeInputMethodEngineWithError:(OFError**)error;
-(BOOL) inputMethodEngineIsActive;
-(BOOL) inputMethodEngineIsActiveWithError:(OFError**)error;
-(void) deactivateInputMethodEngine;
-(void) deactivateInputMethodEngineWithError:(OFError**)error;
-(void) activateInputMethodEngine:(OFString*)engine;
-(void) activateInputMethodEngine:(OFString*)engine error:(OFError**)error;
-(void) setFrame:(OFString*)name;
-(void) setFrame:(OFString*)name error:(OFError**)error;
-(void) setWindow:(OFString*)windowHandle;
-(void) setWindow:(OFString*)windowHandle error:(OFError**)error;
-(void) closeWindow:(OFString*)windowHandle;
-(void) closeWindow:(OFString*)windowHandle error:(OFError**)error;
-(void) setWindowSize:(SIZE_TYPE)size window:(OFString*)windowHandle;
-(void) setWindowSize:(SIZE_TYPE)size window:(OFString*)windowHandle error:(OFError**)error;
-(SIZE_TYPE) windowSizeForWindow:(OFString*)windowHandle;
-(SIZE_TYPE) windowSizeForWindow:(OFString*)windowHandle error:(OFError**)error;
-(void) setWindowPosition:(POINT_TYPE)position window:(OFString*)windowHandle;
-(void) setWindowPosition:(POINT_TYPE)position window:(OFString*)windowHandle error:(OFError**)error;
-(POINT_TYPE) windowPositionForWindow:(OFString*)windowHandle;
-(POINT_TYPE) windowPositionForWindow:(OFString*)windowHandle error:(OFError**)error;
-(void) maximizeWindow:(OFString*)windowHandle;
-(void) maximizeWindow:(OFString*)windowHandle error:(OFError**)error;
-(OFArray*) cookies;
-(OFArray*) cookiesWithError:(OFError**)error;
-(void) setCookie:(OFHTTPCookie*)cookie;
-(void) setCookie:(OFHTTPCookie*)cookie error:(OFError**)error;
-(void) deleteCookies;
-(void) deleteCookiesWithError:(OFError**)error;
-(void) deleteCookie:(OFString*)cookieName;
-(void) deleteCookie:(OFString*)cookieName error:(OFError**)error;
-(OFString*) pageSource;
-(OFString*) pageSourceWithError:(OFError**)error;
-(OFString*) title;
-(OFString*) titleWithError:(OFError**)error;
-(SEWebElement*) findElementBy:(SEBy*)by;
-(SEWebElement*) findElementBy:(SEBy*)by error:(OFError**)error;
-(OFArray*) findElementsBy:(SEBy*)by;
-(OFArray*) findElementsBy:(SEBy*)by error:(OFError**)error;
-(SEWebElement*) activeElement;
-(SEWebElement*) activeElementWithError:(OFError**)error;
-(void) sendKeys:(OFString*)keyString;
-(void) sendKeys:(OFString*)keyString error:(OFError**)error;
-(SEScreenOrientation) orientation;
-(SEScreenOrientation) orientationWithError:(OFError**)error;
-(void) setOrientation:(SEScreenOrientation)orientation;
-(void) setOrientation:(SEScreenOrientation)orientation error:(OFError**)error;
-(OFString*)alertText;
-(OFString*)alertTextWithError:(OFError**)error;
-(void) setAlertText:(OFString*)text;
-(void) setAlertText:(OFString*)text error:(OFError**)error;
-(void) acceptAlert;
-(void) acceptAlertWithError:(OFError**)error;
-(void) dismissAlert;
-(void) dismissAlertWithError:(OFError**)error;
-(void) moveMouseWithXOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset;
-(void) moveMouseToElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset;
-(void) moveMouseToElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset error:(OFError**)error;
-(void) clickPrimaryMouseButton;
-(void) clickMouseButton:(SEMouseButton)button;
-(void) clickMouseButton:(SEMouseButton)button error:(OFError**)error;
-(void) mouseButtonDown:(SEMouseButton)button;
-(void) mouseButtonDown:(SEMouseButton)button error:(OFError**)error;
-(void) mouseButtonUp:(SEMouseButton)button;
-(void) mouseButtonUp:(SEMouseButton)button error:(OFError**)error;
-(void) doubleclick;
-(void) doubleclickWithError:(OFError**)error;
-(void) tapElement:(SEWebElement*)element;
-(void) tapElement:(SEWebElement*)element error:(OFError**)error;
-(void) fingerDownAt:(POINT_TYPE)point;
-(void) fingerDownAt:(POINT_TYPE)point error:(OFError**)error;
-(void) fingerUpAt:(POINT_TYPE)point;
-(void) fingerUpAt:(POINT_TYPE)point error:(OFError**)error;
-(void) moveFingerTo:(POINT_TYPE)point;
-(void) moveFingerTo:(POINT_TYPE)point error:(OFError**)error;
-(void) scrollfromElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset;
-(void) scrollfromElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset error:(OFError**)error;
-(void) scrollTo:(POINT_TYPE)position;
-(void) scrollTo:(POINT_TYPE)position error:(OFError**)error;
-(void) doubletapElement:(SEWebElement*)element;
-(void) doubletapElement:(SEWebElement*)element error:(OFError**)error;
-(void) pressElement:(SEWebElement*)element;
-(void) pressElement:(SEWebElement*)element error:(OFError**)error;
-(void) performTouchAction:(SETouchAction *)touchAction;
-(void) performTouchAction:(SETouchAction *)touchAction error:(OFError**)error;
-(void) flickfromElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset speed:(ssize_t)speed;
-(void) flickfromElement:(SEWebElement*)element xOffset:(ssize_t)xOffset yOffset:(ssize_t)yOffset speed:(ssize_t)speed error:(OFError**)error;
-(void) flickWithXSpeed:(ssize_t)xSpeed ySpeed:(ssize_t)ySpeed;
-(void) flickWithXSpeed:(ssize_t)xSpeed ySpeed:(ssize_t)ySpeed error:(OFError**)error;
-(SELocation*) location;
-(SELocation*) locationWithError:(OFError**)error;
-(void) setLocation:(SELocation*)location;
-(void) setLocation:(SELocation*)location error:(OFError**)error;
-(OFArray*) allLocalStorageKeys;
-(OFArray*) allLocalStorageKeysWithError:(OFError**)error;
-(void) setLocalStorageValue:(OFString*)value forKey:(OFString*)key;
-(void) setLocalStorageValue:(OFString*)value forKey:(OFString*)key error:(OFError**)error;
-(void) clearLocalStorage;
-(void) clearLocalStorageWithError:(OFError**)error;
-(void) localStorageItemForKey:(OFString*)key;
-(void) localStorageItemForKey:(OFString*)key error:(OFError**)error;
-(void) deleteLocalStorageItemForKey:(OFString*)key;
-(void) deleteLocalStorageItemForKey:(OFString*)key error:(OFError**)error;
-(ssize_t) countOfItemsInLocalStorage;
-(ssize_t) countOfItemsInLocalStorageWithError:(OFError**)error;
-(OFArray*) allSessionStorageKeys;
-(OFArray*) allSessionStorageKeysWithError:(OFError**)error;
-(void) setSessionStorageValue:(OFString*)value forKey:(OFString*)key;
-(void) setSessionStorageValue:(OFString*)value forKey:(OFString*)key error:(OFError**)error;
-(void) clearSessionStorage;
-(void) clearSessionStorageWithError:(OFError**)error;
-(void) sessionStorageItemForKey:(OFString*)key;
-(void) sessionStorageItemForKey:(OFString*)key error:(OFError**)error;
-(void) deleteStorageItemForKey:(OFString*)key;
-(void) deleteStorageItemForKey:(OFString*)key error:(OFError**)error;
-(ssize_t) countOfItemsInStorage;
-(ssize_t) countOfItemsInStorageWithError:(OFError**)error;
-(OFArray*) getLogForType:(SELogType)type;
-(OFArray*) getLogForType:(SELogType)type error:(OFError**)error;
-(OFArray*) allLogTypes;
-(OFArray*) allLogTypesWithError:(OFError**)error;
-(SEApplicationCacheStatus) applicationCacheStatus;
-(SEApplicationCacheStatus) applicationCacheStatusWithError:(OFError**)error;

#pragma mark - 3.0 methods
/////////////////
// 3.0 METHODS //
/////////////////

-(void) shakeDevice;
-(void) shakeDeviceWithError:(OFError**)error;
-(void) lockDeviceScreen:(ssize_t)seconds;
-(void) lockDeviceScreen:(ssize_t)seconds error:(OFError**)error;
-(void) unlockDeviceScreen:(ssize_t)seconds;
-(void) unlockDeviceScreen:(ssize_t)seconds error:(OFError**)error;
-(BOOL) isDeviceLocked;
-(BOOL) isDeviceLockedWithError:(OFError**)error;
-(void) pressKeycode:(ssize_t)keycode metaState:(ssize_t)metastate error:(OFError**)error;
-(void) longPressKeycode:(ssize_t)keycode metaState:(ssize_t)metastate error:(OFError**)error;
-(void) triggerKeyEvent:(ssize_t)keycode metaState:(ssize_t)metastate error:(OFError**)error;
-(void) rotateDevice:(SEScreenOrientation)orientation;
-(void) rotateDevice:(SEScreenOrientation)orientation error:(OFError**)error;
-(OFString*)currentActivity;
-(OFString*)currentActivityWithError:(OFError**)error;
-(void)installAppAtPath:(OFString*)appPath;
-(void)installAppAtPath:(OFString*)appPath error:(OFError**)error;
-(void)removeApp:(OFString*)bundleId;
-(void)removeApp:(OFString*)bundleId error:(OFError**)error;
-(BOOL)isAppInstalled:(OFString*)bundleId;
-(BOOL)isAppInstalled:(OFString*)bundleId error:(OFError**)error;
-(void) hideKeyboard;
-(void) hideKeyboardWithError:(OFError**)error;
-(void) pushFileToPath:(OFString*)filePath data:(OFDataArray*)data;
-(void) pushFileToPath:(OFString*)filePath data:(OFDataArray*)data error:(OFError**) error;
-(OFDataArray*) pullFileAtPath:(OFString*)filePath;
-(OFDataArray*) pullFileAtPath:(OFString*)filePath error:(OFError**) error;
-(OFDataArray*) pullFolderAtPath:(OFString*)filePath;
-(OFDataArray*) pullFolderAtPath:(OFString*)filePath error:(OFError**) error;
-(void) toggleAirplaneMode;
-(void) toggleAirplaneModeWithError:(OFError**)error;
-(void) toggleCellularData;
-(void) toggleCellularDataWithError:(OFError**)error;
-(void) toggleWifi;
-(void) toggleWifiWithError:(OFError**)error;
-(void) toggleLocationServices;
-(void) toggleLocationServicesWithError:(OFError**)error;
-(void) openNotifications;
-(void) openNotificationsWithError:(OFError**)error;
-(void) startActivity:(OFString*)activity package:(OFString*)package;
-(void) startActivity:(OFString*)activity package:(OFString*)package waitActivity:(OFString*)waitActivity waitPackage:(OFString*)waitPackage;
-(void) startActivity:(OFString*)activity package:(OFString*)package waitActivity:(OFString*)waitActivity waitPackage:(OFString*)waitPackage error:(OFError**)error;
-(void) launchApp;
-(void) launchAppWithError:(OFError**)error;
-(void) closeApp;
-(void) closeAppWithError:(OFError**)error;
-(void) resetApp;
-(void) resetAppWithError:(OFError**)error;
-(void) runAppInBackground:(ssize_t)seconds;
-(void) runAppInBackground:(ssize_t)seconds error:(OFError**)error;
-(void) endTestCodeCoverage;
-(void) endTestCodeCoverageWithError:(OFError**)error;
-(OFString*)appStrings;
-(OFString*)appStringsForLanguage:(OFString*)languageCode;
-(OFString*)appStringsForLanguage:(OFString*)languageCode error:(OFError**)error;
-(void) setAppiumSettings:(OFDictionary*)settings;
-(void) setAppiumSettings:(OFDictionary*)settings error:(OFError**)error;
-(OFDictionary*) appiumSettings;
-(OFDictionary*) appiumSettingsWithError:(OFError**)error;

@end
