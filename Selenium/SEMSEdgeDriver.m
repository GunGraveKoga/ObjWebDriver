#import <ObjFW/ObjFW.h>
#import "SEMSEdgeDriver.h"
#import "SEJsonWireClient.h"

@interface SEJsonWireClient_EdgeDriver: SEJsonWireClient
@end


@implementation SEJsonWireClient_EdgeDriver

-(OFString*) httpCommandExecutor
{
    return [OFString stringWithFormat:@"http://%@:%@", [self valueForKey:@"serverAddress"], [self valueForKey:@"serverPort"]];
}

@end


@interface SEMSEdgeDriver()
@property(nullable, nonatomic) OFProcess *webdriverServer;
@end

@implementation SEMSEdgeDriver

- (instancetype)initWithExecutable:(OFString *)path
{
  return [self initWithExecutable:path serverAddress:@"localhost" port:17556];
}

- (instancetype)initWithExecutable:(OFString *)path serverAddress:(OFString *)serverAddress port:(ssize_t)port
{
  if (path == nil)
    return [self initWithServerAddress:serverAddress port:port];

  self = [super init];

  self.webdriverServer = [OFProcess processWithProgram:path arguments:@[
      [OFString stringWithFormat:@"-host=%@", serverAddress],
      [OFString stringWithFormat:@"-port=%d", port],
      @"-verbose"
      ]];

  OFError *error;
  SEJsonWireClient_EdgeDriver *jsonWireClient = [[SEJsonWireClient_EdgeDriver alloc] initWithServerAddress:serverAddress port:port error:&error];

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
    SEJsonWireClient_EdgeDriver *jsonWireClient = [[SEJsonWireClient_EdgeDriver alloc] initWithServerAddress:address port:port error:&error];

    if (jsonWireClient == nil)
      return nil;

    [self performSelector:@selector(setJsonWireClient:) withObject:jsonWireClient];

    [self performSelector:@selector(addError:) withObject:error];

    return self;
}

-(id) initWithServerAddress:(OFString*)address port:(ssize_t)port desiredCapabilities:(SECapabilities*)desiredCapabilities requiredCapabilities:(SECapabilities*)requiredCapabilites error:(OFError**)error
{
    self = [self initWithServerAddress:address port:port];


    SEJsonWireClient_EdgeDriver *jsonWireClient = [[SEJsonWireClient_EdgeDriver alloc] initWithServerAddress:address port:port error:error];

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
