#import <ObjFW/OFObject.h>
#import "macros.h"

OF_ASSUME_NONNULL_BEGIN

@class OFString;
@class OFDictionary OF_GENERIC(KeyType,ObjectType);
@class OFNumber;
@class OFArray OF_GENERIC(ObjectType);

OBJC_EXPORT_BEGIN

/**
 * Key for user info dictionary component which describes the error in
 * a human readable format.
 */
OBJC_EXPORT OFString* const OFLocalizedDescriptionKey;
/**
 * Where one error has caused another, the underlying error can be stored
 * in the user info dictionary using this key.
 */
OBJC_EXPORT OFString* const OFUnderlyingErrorKey;
/**
 * Key for an [OFNumber] containing an string encoding number value.
 */
OBJC_EXPORT OFString* const OFStringEncodingErrorKey;
/**
 * This key can be used to store the file path of a resource involved
 * in the error (eg unreadable file).
 */
OBJC_EXPORT OFString* const OFFilePathErrorKey;
/**
 * This can be used to store the URLK involved in the error.
 */
OBJC_EXPORT OFString* const OFURLErrorKey;
/**
 * Key to store a string describing what caused the error to occur.
 */
OBJC_EXPORT OFString* const OFLocalizedFailureReasonErrorKey;
/**
 * Key to store an [OFArray] of strings suitable for use as the
 * titles of buttons in an alert panel used to attempt error
 * recovery in a GUI application.
 */
OBJC_EXPORT OFString* const OFLocalizedRecoveryOptionsErrorKey;
/**
 * Key to store a string providing a hint on how to use the buttons
 * in an alert panel.
 */
OBJC_EXPORT OFString* const OFLocalizedRecoverySuggestionErrorKey;
/**
 * Key to store an object which can be used to attempt to recover from
 * the error.
 */
OBJC_EXPORT OFString* const OFRecoveryAttempterErrorKey;
/**
 * NSURL to indicate the URL which did not load, in the NSURLErrorDomain.
 */
OBJC_EXPORT OFString* const OFURLErrorFailingURLErrorKey;
/**
 * NSString in the NSURLDomain to indicate the object for the URL that did not load.
 * This supersedes NSErrorFailingURLStringKey
 */
OBJC_EXPORT OFString* const OFURLErrorFailingURLStringErrorKey;
#if defined(OF_MACH_O)
/**
 * Domain for system errors (on MACH).
 */
OBJC_EXPORT OFString* const OFMACHErrorDomain;
#define NSMACHErrorDomain OFMACHErrorDomain
#endif
/**
 * Domain for system errors.
 */
OBJC_EXPORT OFString* const OFOSStatusErrorDomain;
#define NSOSStatusErrorDomain OFOSStatusErrorDomain
/**
 * Domain for ObjFW errors.
 */
OBJC_EXPORT OFString* const OFObjFWErrorDomain;
#define NSCocoaErrorDomain OFObjFWErrorDomain
/**
 * Domain for system and system library errors.
 */
OBJC_EXPORT OFString* const OFPOSIXErrorDomain;
#define NSPOSIXErrorDomain OFPOSIXErrorDomain

@interface OFError: OFObject
{
  int _code;
  OBJC_STRONG OFString* _domain;
  OBJC_STRONG OFDictionary* _userInfo;
}
/**
 * Creates and returns an autoreleased OFError instance by calling
 * -initWithDomain:code:userInfo:
 */
+ (instancetype) errorWithDomain: (OFString*)aDomain
		  code: (int)aCode
	      userInfo: (OFDictionary* _Nullable)aDictionary;
/**
 * Return the error code ... which is not globally unique, just unique for
 * a particular domain.
 */
- (int)code;
/**
 * Return last error.
 */
+ (instancetype)lastError;
/**
 * Sets last error object zeroing errno.
 */
+ (void)setLastError:(OFError * _Nullable)err;
/**
 * Return the domain for this instance.
 */
- (OFString *)domain;
/** <init />
 * Initialises the receiver using the supplied domain, code, and info.<br />
 * The domain must be non-nil.
 */
- (instancetype) initWithDomain: (OFString*)aDomain
		 code: (int)aCode
	     userInfo: (OFDictionary* _Nullable)aDictionary;

/**
 * Return a human readable description for the error.<br />
 * The default implementation uses the value from the user info dictionary
 * if it is available, otherwise it generates a generic one from domain
 * and code.
 */
- (OFString *) localizedDescription;
/**
 * Return a human readable explanation of the reason for the error
 * (if known).  This should normally be a more discursive explanation
 * then the short one provided by the -localizedDescription method.<br />
 * The default implementation uses the value from the user info dictionary
 * if it is available, otherwise it returns nil.
 */
- (OFString *) localizedFailureReason;

/**
 * Returns an array of strings to be used as titles of buttons in an
 * alert panel when offering the user optionbs to try to recover from
 * the error.<br />
 * The default implementation uses the value from the user info dictionary
 * if it is available, otherwise it returns nil.
 */
- (OFArray *) localizedRecoveryOptions;

/**
 * Returns a string used as the secondary text in an alert panel,
 * suggesting how the user might select an option to attempt to
 * recover from the error.<br />
 * The default implementation uses the value from the user info dictionary
 * if it is available, otherwise it returns nil.
 */
- (OFString *) localizedRecoverySuggestion;

/**
 * Not yet useful in GNUstep.<br />
 * The default implementation uses the value from the user info dictionary
 * if it is available, otherwise it returns nil.
 */
- (id) recoveryAttempter;
/**
 * Return the user info for this instance (or nil if none is set)<br />
 * The <code>OFLocalizedDescriptionKey</code> should locate a human readable
 * description in the dictionary.<br />
 * The <code>NSUnderlyingErrorKey</code> key should locate an
 * <code>OFError</code> instance if an error is available describing any
 * underlying problem.<br />
 */
- (OFDictionary*) userInfo;


@end

OBJC_EXPORT_END


OF_ASSUME_NONNULL_END
