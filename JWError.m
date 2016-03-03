#import <ObjFW/ObjFW.h>
#import "JWError.h"

static OFArray *const __SeleniumErrors = @[
		@"Success: The command executed successfully.",	//0
		nil,	//1
		nil,	//2
		nil,	//3
		nil,	//4
		nil,	//5
		@"NoSuchDriver: A session is either terminated or not started.",	//6
		@"NoSuchElement: An element could not be located on the page using the given search parameters.",	//7
		@"NoSuchFrame: A request to switch to a frame could not be satisfied because the frame could not be found.",	//8
		@"UnknownCommand: The requested resource could not be found, or a request was received using an HTTP method that is not supported by the mapped resource.",	//9
		@"StaleElementReference: An element command failed because the referenced element is no longer attached to the DOM.",	//10
		@"ElementNotVisible: An element command could not be completed because the element is not visible on the page.",	//11
		@"InvalidElementState: An element command could not be completed because the element is in an invalid state (e.g. attempting to click a disabled element).",	//12
		@"UnknownError: An unknown server-side error occurred while processing the command.",	//13
		nil,	//14
		@"ElementIsNotSelectable: An attempt was made to select an element that cannot be selected.",	//15
		nil,	//16
		@"JavaScriptError: An error occurred while executing user supplied JavaScript.",	//17
		nil,	//18
		@"XPathLookupError: An error occurred while searching for an element by XPath.",	//19
		nil,	//20
		@"Timeout: An operation did not complete before its timeout expired.",	//21
		nil,	//22
		@"NoSuchWindow: A request to switch to a different window could not be satisfied because the window could not be found.",	//23
		@"InvalidCookieDomain: An illegal attempt was made to set a cookie under a different domain than the current page.",	//24
		@"UnableToSetCookie: A request to set a cookie's value could not be satisfied.",	//25
		@"UnexpectedAlertOpen: A modal dialog was open, blocking this operation",	//26
		@"NoAlertOpenError: An attempt was made to operate on a modal dialog when one was not open.",	//27
		@"ScriptTimeout: A script did not complete before its timeout expired.",	//28
		@"InvalidElementCoordinates: The coordinates provided to an interactions operation are invalid.",	//29
		@"IMENotAvailable: IME was not available.",	//30
		@"IMEEngineActivationFailed: An IME engine could not be started.",	//31
		@"InvalidSelector: Argument was an invalid selector (e.g. XPath/CSS).",	//32
		@"SessionNotCreatedException: A new session could not be created.",	//33
		@"MoveTargetOutOfBounds: Target provided for a move action is out of bounds."	//34
	];

@interface JWError()
- (instancetype)SEL_Private_initWithCode:(int32_t)code;
- (instancetype)SEL_Private_initWithDictionary:(OFDictionary *)dict;
@end

@implementation JWError

@synthesize code = _code;
@synthesize message = _message;



- (instancetype)init
{
	OF_UNRECOGNIZED_SELECTOR
}

- (instancetype)JW_Private_initWithCode:(int32_t)code
{
	self = [super init];

	if (code >= [__SeleniumErrors count]) {
		[self release];
		@throw [OFInvalidArgumentException exception];
	}

	_code = code;
	_message = [__SeleniumErrors[code] copy];

	return self;
}

- (instancetype)JW_Private_initWithDictionary:(OFDictionary *)dict
{

}

+ (instancetype)errorWithCode:(int32_t)code
{

}

+ (instancetype)errorWithDictionary:(OFDictionary *)dict
{

}


@end