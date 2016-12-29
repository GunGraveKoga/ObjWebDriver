#import <ObjFW/ObjFW.h>
#import "OFError.h"
#import "OFError+PRIVATE.h"

#include <error.h>
#include <errno.h>

PRAGMA_OBJC_ARC_BEGIN

OFString* const OFLocalizedDescriptionKey = @"OFLocalizedDescriptionKey";
OFString* const OFUnderlyingErrorKey = @"OFUnderlyingErrorKey";
OFString* const OFStringEncodingErrorKey = @"OFStringEncodingErrorKey";
OFString* const OFFilePathErrorKey = @"OFFilePathErrorKey";
OFString* const OFURLErrorKey = @"OFURLErrorKey";
OFString* const OFLocalizedFailureReasonErrorKey = @"OFLocalizedFailureReasonErrorKey";
OFString* const OFLocalizedRecoveryOptionsErrorKey = @"OFLocalizedRecoveryOptionsErrorKey";
OFString* const OFLocalizedRecoverySuggestionErrorKey = @"OFLocalizedRecoverySuggestionErrorKey";
OFString* const OFRecoveryAttempterErrorKey = @"OFRecoveryAttempterErrorKey";
OFString* const OFURLErrorFailingURLErrorKey = @"OFURLErrorFailingURLErrorKey";
OFString* const OFURLErrorFailingURLStringErrorKey = @"OFURLErrorFailingURLStringErrorKey";
#if defined(OF_MACH_O)
OFString* const OFMACHErrorDomain = @"OFMACHErrorDomain";
#endif
OFString* const OFOSStatusErrorDomain = @"OFOSStatusErrorDomain";
OFString* const OFPOSIXErrorDomain = @"OFPOSIXErrorDomain";
OFString* const OFObjFWErrorDomain = @"OFObjFWErrorDomain";

static OFString* const OFThreadLastErrorKey = @"OFThreadLsatErrorKey";

@implementation OFError

+ (instancetype)lastError
{
  OFError* OBJC_STRONG err = nil;

 OFDictionary* threadDictionary = [OFThread threadDictionary];

 if ((err = [threadDictionary objectForKey:OFThreadLastErrorKey])) {

     return err;
   }

  return [self OF_last];
}

+ (void)setLastError:(OFError *)err
{

  if (err != nil) {
      [[OFThread threadDictionary] setObject:err forKey:OFThreadLastErrorKey];

#if defined (OF_WINDOWS)
      int errNo = [err code];
        SetLastError(errNo);
        WSASetLastError(errNo);
#endif
        errno = 0;

        return;

    }

    if (err == nil) {
        [[OFThread threadDictionary] removeObjectForKey:OFThreadLastErrorKey];

#if defined (OF_WINDOWS)
        SetLastError(0);
        WSASetLastError(0);
#endif
        errno = 0;
    }
}

+ (instancetype) errorWithDomain: (OFString*)aDomain
		  code: (int)aCode
	      userInfo: (OFDictionary*)aDictionary
{
  return OBJC_AUTORELEASE_OBJECT([[self alloc] initWithDomain:aDomain code:aCode userInfo:aDictionary]);
}

- (instancetype) initWithDomain: (OFString*)aDomain
                   code: (int)aCode
               userInfo: (OFDictionary*)aDictionary
{
  self = [super init];
  _code = aCode;
  _domain = OBJC_RETAIN_OBJECT(aDomain);
  _userInfo = OBJC_RETAIN_OBJECT(aDictionary);

  return self;
}

- (instancetype)init
{
  self = [super init];
  _code = 0;
  _domain = nil;
  _userInfo = nil;

  return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
  [_domain release];
  [_userInfo release];

  [super dealloc];
}
#endif

- (int)code
{
  return _code;
}

- (OFString *)domain
{
  return _domain;
}

- (OFDictionary*) userInfo
{
  return _userInfo;
}

- (OFString *) localizedDescription
{
  OFString* desc = [_userInfo valueForKey:OFLocalizedDescriptionKey];

  if (desc == nil) {
      if ([_domain isEqual:OFOSStatusErrorDomain] || [_domain isEqual:OFPOSIXErrorDomain]
    #if defined (OF_MACH_O)
          || [_domain isEqual:OFMACHErrorDomain])
    #else
          )
    #endif
        desc = [OFError OF_descriptionForSystemError:_code];
      else
        desc = [OFString stringWithFormat:@"%@ %d", _domain, _code];
    }

  return  desc;
}

- (OFString *)description
{
  return [self localizedDescription];
}

- (OFString *) localizedFailureReason
{
  return [_userInfo valueForKey:OFLocalizedFailureReasonErrorKey];
}

- (OFArray *)localizedRecoveryOptions
{
  return [_userInfo valueForKey:OFLocalizedRecoveryOptionsErrorKey];
}

- (OFString *)localizedRecoverySuggestion
{
  return [_userInfo valueForKey:OFLocalizedRecoverySuggestionErrorKey];
}

- (id)recoveryAttempter
{
  return [_userInfo valueForKey:OFRecoveryAttempterErrorKey];
}

@end

@implementation OFError(PRIVATE)

+ (instancetype)OF_last
{
  int eno;
#if defined(OF_WINDOWS)
  eno = GetLastError();

  if (eno == 0) {
    eno = errno;
  }

  if (eno == 0) {
      eno = of_socket_errno();
    }

  SetLastError(0);
  errno = 0;
  WSASetLastError(0);

#else
  eno = errno;

  if (eno == 0) {
      eno = of_socket_errno();
    }
  errno = 0;
#endif

  if (eno == 0) return nil;

  return [self OF_systemError:eno];
}

+ (instancetype)OF_systemError:(int)eno
{
  OFMutableDictionary* userInfo = [OFMutableDictionary dictionary];
  OFString* errorMessage = [self OF_descriptionForSystemError:eno];

  if (errorMessage == nil)
    errorMessage = @"Unknown error";

  [userInfo setValue:errorMessage forKey:OFLocalizedDescriptionKey];
  [userInfo makeImmutable];

#if defined (OF_WINDOWS)
  OFString* domain = OFOSStatusErrorDomain;
#else
  OFString* domain = OFPOSIXErrorDomain;
#endif

  return [self errorWithDomain:domain code:eno userInfo:userInfo];

}

+ (OFString *)OF_descriptionForSystemError:(int)eno
{
#if defined (OF_WINDOWS)
  void* lpMsgBuf = NULL;
  if (eno != 0)
    FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
      NULL, eno, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
      (LPWSTR) &lpMsgBuf, 0, NULL );

  if (lpMsgBuf != NULL)
    return [OFString stringWithUTF16String:(const of_char16_t *)lpMsgBuf];

  return of_strerror(eno);
#else
  return of_strerror(eno);
#endif
}

@end

PRAGMA_OBJC_ARC_END
