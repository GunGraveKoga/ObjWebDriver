#import <ObjFW/ObjFW.h>
#import "SEChromeDriver.h"
#import "SEJsonWireClient.h"

@interface SEJsonWireClient_ChromeDriver: SEJsonWireClient
@end


@implementation SEJsonWireClient_ChromeDriver

-(OFString*) httpCommandExecutor
{
    return [OFString stringWithFormat:@"http://%@:%@", [self valueForKey:@"serverAddress"], [self valueForKey:@"serverPort"]];
}

@end

@interface SEChromeDriver()
@property(nullable, nonatomic) OFProcess *webdriverServer;
@end

@implementation SEChromeDriver

- (instancetype)initWithExecutable:(OFString *)path
{
  return [self initWithExecutable:path serverAddress:@"127.0.0.1" port:9515];
}

- (instancetype)initWithExecutable:(OFString *)path serverAddress:(OFString *)serverAddress port:(ssize_t)port
{
  if (path == nil)
    return [self initWithServerAddress:serverAddress port:port];

  self = [super init];

  self.webdriverServer = [OFProcess processWithProgram:path arguments:@[
      [OFString stringWithFormat:@"--port=%d", port],
      @"--verbose"]];

  OFError *error;
  SEJsonWireClient_ChromeDriver *jsonWireClient = [[SEJsonWireClient_ChromeDriver alloc] initWithServerAddress:serverAddress port:port error:&error];

  if (jsonWireClient == nil)
    return nil;

  [self performSelector:@selector(setJsonWireClient:) withObject:jsonWireClient];

  [self performSelector:@selector(addError:) withObject:error];

  return self;
}

-(id) initWithServerAddress:(OFString *)address port:(ssize_t)port
{
    self = [super init];

    OFError *error;
    SEJsonWireClient_ChromeDriver *jsonWireClient = [[SEJsonWireClient_ChromeDriver alloc] initWithServerAddress:address port:port error:&error];

    if (jsonWireClient == nil)
      return nil;

    [self performSelector:@selector(setJsonWireClient:) withObject:jsonWireClient];

    [self performSelector:@selector(addError:) withObject:error];

    return self;
}

-(id) initWithServerAddress:(OFString*)address port:(ssize_t)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(OFError**)error
{
    self = [self initWithServerAddress:address port:port];


    SEJsonWireClient_ChromeDriver *jsonWireClient = [[SEJsonWireClient_ChromeDriver alloc] initWithServerAddress:address port:port error:error];

    if (jsonWireClient == nil)
      return nil;

    [self performSelector:@selector(setJsonWireClient:) withObject:jsonWireClient];

    [self performSelector:@selector(addError:) withObject:*error];

    [self setSession:[self startSessionWithDesiredCapabilities:desiredCapabilities requiredCapabilities:requiredCapabilites]];

    if (self.session == nil)
      return nil;

    return self;

}

-(void)quitWithError:(OFError**)error {

  [super quitWithError:error];

  if (self.webdriverServer)
    [self.webdriverServer close];
}

@end
