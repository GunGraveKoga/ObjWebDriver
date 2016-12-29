# ObjWebDriver
Reimplemented version of [Selenium.framework](https://github.com/appium/selenium-objective-c) for compatibility with [ObjFW](https://github.com/Midar/objfw).

### Features

- Support for several webdriver servers - [GeckoDriver](https://github.com/mozilla/geckodriver), [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/), [InternetExplorerWebdriverServer](https://github.com/SeleniumHQ/selenium/wiki/InternetExplorerDriver), [MicrosoftWebDriver](https://developer.microsoft.com/en-us/microsoft-edge/platform/documentation/dev-guide/tools/webdriver/) (Edge Browser)
- Screenshot support via [stb_image](https://github.com/nothings/stb) - PNG, BMP, TGA and HDR are supported.

### Usage
#### RemoteWebDriver (aka SeleniumServer)
```objc
#import <ObjFW/ObjFW.h>
#import <Selenium/Selenium.h>

@interface AppDelegate: OFObject<OFApplicationDelegate>
@end

OF_APPLICATION_DELEGATE(AppDelegate)

@implementation AppDelegate

- (void)applicationDidFinishLaunching
{
	SECapabilities *c = [SECapabilities new];
 	c.browserName = @"firefox";

 	SERemoteWebDriver *driver = [[SERemoteWebDriver alloc] initWithServerAddress:@"localhost" port:4444 desiredCapabilities:c requiredCapabilities:nil error:NULL];

 	driver.url = [OFURL URLWithString:@"https://google.com"];

 	[driver quit];

 	[OFApplication terminate];
}
@end
```

#### GeckoDriver (FireFox browser)

```objc
#import <ObjFW/ObjFW.h>
#import <Selenium/Selenium.h>

@interface AppDelegate: OFObject<OFApplicationDelegate>
@end

OF_APPLICATION_DELEGATE(AppDelegate)

@implementation AppDelegate

- (void)applicationDidFinishLaunching
{
	SERemoteWebDriver *driver = [[SEGeckoDriver alloc] initWithExecutable:@"/usr/local/bin/geckodriver"];

 	SECapabilities *c = [SECapabilities new];

  	[driver startSessionWithDesiredCapabilities:c requiredCapabilities:nil];

  	driver.url = [OFURL URLWithString:@"https://google.com"];

  	[driver quit];

  	[OFApplication terminate];
}
@end
```

#### GeckoDriver (already executed webdriver server usage)

```objc
#import <ObjFW/ObjFW.h>
#import <Selenium/Selenium.h>

@interface AppDelegate: OFObject<OFApplicationDelegate>
@end

OF_APPLICATION_DELEGATE(AppDelegate)

@implementation AppDelegate

- (void)applicationDidFinishLaunching
{
	SERemoteWebDriver *driver = [[SEGeckoDriver alloc] initWithServerAddress:@"localhost" port:4444];

 	SECapabilities *c = [SECapabilities new];

  	[driver startSessionWithDesiredCapabilities:c requiredCapabilities:nil];

  	driver.url = [OFURL URLWithString:@"https://google.com"];

  	[driver quit];

  	[OFApplication terminate];
}
@end
```

###### OR

```objc
#import <ObjFW/ObjFW.h>
#import <Selenium/Selenium.h>

@interface AppDelegate: OFObject<OFApplicationDelegate>
@end

OF_APPLICATION_DELEGATE(AppDelegate)

@implementation AppDelegate

- (void)applicationDidFinishLaunching
{
	SECapabilities *c = [SECapabilities new];

 	SERemoteWebDriver *driver = [[SEGeckoDriver alloc] initWithServerAddress:@"localhost" port:4444 desiredCapabilities:c requiredCapabilities:nil error:NULL];

 	driver.url = [OFURL URLWithString:@"https://google.com"];

 	[driver quit];

 	[OFApplication terminate];
}
@end
```

For more information and examples look at [Appium.app](https://github.com/appium/appium-dot-app) or source.

### Requirements

- Clang 3.8+
- ObjFW v0.9-dev+

### How to build

###### objf-compile --arc -I/path/to/repo -I/path/to/repo/Selenium main.m /path/to/repo/*.m /path/to/repo/Selenium/*.m -o myapp