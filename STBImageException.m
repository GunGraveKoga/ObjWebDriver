#import <ObjFW/ObjFW.h>
#import "STBImageException.h"

extern OFString * const STBIErrorMessage;

@implementation STBInvalidImageTypeException

- (OFString *)description
{
  return [OFString stringWithUTF8String:"Image not of any known type, or corrupt"];
}

@end


@implementation STBIFailureException {
  OFString *_failureReason;
}

- (instancetype)init
{
  self = [super init];

  _failureReason = [[OFThread threadDictionary] objectForKey:STBIErrorMessage];

  return self;
}

- (OFString *)description
{
  return [OFString stringWithString:_failureReason];
}

@end
