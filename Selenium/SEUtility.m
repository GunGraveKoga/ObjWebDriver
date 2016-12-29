//
//  SEUtility.m
//  Selenium
//
//  Created by Dan Cuellar on 3/18/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SEUtility.h"
#import "SEError.h"

#define DEFAULT_TIMEOUT 120

static OFHTTPClient *__globalHTTPClient = nil;

@interface SEInternalHTTPDelegate: OFObject<OFHTTPClientDelegate>
@end

_Pragma("clang diagnostic push")
_Pragma("clang diagnostic ignored \"-Wunused-parameter\"")

@implementation SEInternalHTTPDelegate
- (void)client:(OFHTTPClient *)client didCreateSocket:(OFTCPSocket *)socket request:(OFHTTPRequest *)request
{
  //of_log(@"Creating socket for request %@", request);
}

- (void)client:(OFHTTPClient *)client didReceiveHeaders:(OFDictionary<OFString*,OFString*> *)headers statusCode:(int)statusCode request:(OFHTTPRequest *)request
{
  //of_log(@"Request %@", request);
  //of_log(@"Recive header HTTP %d", statusCode);
  //of_log(@"%@", headers);
}

- (bool)client:(OFHTTPClient *)client shouldFollowRedirect:(OFURL *)URL statusCode:(int)statusCode request:(OFHTTPRequest *)request response:(OFHTTPResponse *)response
{
  //of_log(@"Redirection to %@", URL);
  //of_log(@"Request %@", request);
  //of_log(@"StatusCode %d", statusCode);
  //of_log(@"Response %@", response);

  return true;
}

@end

_Pragma("clang diagnostic pop")

static SEInternalHTTPDelegate *__globalHTTPDelegate = nil;

@implementation SEUtility

+ (void)initialize
{
  if (self != [SEUtility class])
    return;

  __globalHTTPDelegate = [SEInternalHTTPDelegate new];
  __globalHTTPClient = [[OFHTTPClient alloc] init];
  [__globalHTTPClient setDelegate:__globalHTTPDelegate];
}

+(OFDictionary*) performGetRequestToUrl:(OFString*)urlString error:(OFError**)error
{
	OFURL *url = [OFURL URLWithString:urlString];//[urlString stringByURLEncoding]];
	OFHTTPRequest *request = [OFHTTPRequest requestWithURL:url];

	request.method = OF_HTTP_REQUEST_METHOD_GET;

	OFHTTPResponse *response;
	int errCode = -1;

	@try {
	  response = [__globalHTTPClient performRequest:request];
	} @catch (id e) {

	  if (error != NULL) {

	      if ([e respondsToSelector:@selector (errNo)]) {
		  errCode = [e errNo];

		} else if ([e respondsToSelector:@selector(response)]) {

		  OFHTTPResponse *r = [e response];

		  errCode = (int)r.statusCode;
		}

	      *error = [OFError errorWithDomain:OFObjFWErrorDomain code:errCode userInfo:[OFDictionary dictionaryWithKeysAndObjects:OFLocalizedDescriptionKey, [e description], nil]];
	    }

	  return nil;
	}


    OFDictionary *json;

    @try {

      json = [[response string] JSONValue];

    } @catch(id e) {
      if (error != NULL) {

	  if ([e respondsToSelector:@selector (errNo)]) {
	      errCode = [e errNo];
	    }

	  *error = [OFError errorWithDomain:OFObjFWErrorDomain code:errCode userInfo:[OFDictionary dictionaryWithKeysAndObjects:OFLocalizedDescriptionKey, [e description], nil]];
	}

      return nil;

    }

    if (error != NULL) {
        *error = [SEError errorWithResponseDict:json];
        if ([*error code] != 0)
            return nil;
      } else {
        SEError *se_error = [SEError errorWithResponseDict:json];
        if ([se_error code] != 0) {
            *error = se_error;

            return nil;
          }
      }

    return json;
}

+(OFDictionary*) performPostRequestToUrl:(OFString*)urlString postParams:(OFDictionary*)postParams error:(OFError**)error
{
  OFURL *url = [OFURL URLWithString:urlString];//[urlString stringByURLEncoding]];
  OFHTTPRequest *request = [OFHTTPRequest requestWithURL:url];

  request.method = OF_HTTP_REQUEST_METHOD_POST;

  if (postParams == nil)
    postParams = [OFDictionary new];

  request.headers = [OFDictionary dictionaryWithKeysAndObjects:@"Accept", @"application/json, image/png",
                                                               @"Content-Type", @"application/json;charset=utf-8", nil];
  request.body = [self jsonDataFromDictionary:postParams];

  OFHTTPResponse *response;
  int errCode = -1;

  @try {
    response = [__globalHTTPClient performRequest:request];
  } @catch (id e) {

    if (error != NULL) {

	if ([e respondsToSelector:@selector (errNo)]) {
	    errCode = [e errNo];
	  } else if ([e respondsToSelector:@selector(response)]) {

	    OFHTTPResponse *r = [e response];

	    errCode = (int)r.statusCode;
	  }

        *error = [OFError errorWithDomain:OFObjFWErrorDomain code:errCode userInfo:[OFDictionary dictionaryWithKeysAndObjects:OFLocalizedDescriptionKey, [e description], nil]];
      }

    return nil;
  }

  if (response.statusCode != 200 && response.statusCode != 303) {
      return nil;
    }

  OFDictionary *json;

  @try {

    json = [[response string] JSONValue];

  } @catch(id e) {
    if (error != NULL) {

	if ([e respondsToSelector:@selector (errNo)]) {
	    errCode = [e errNo];
	  }

        *error = [OFError errorWithDomain:OFObjFWErrorDomain code:errCode userInfo:[OFDictionary dictionaryWithKeysAndObjects:OFLocalizedDescriptionKey, [e description], nil]];
      }

    return nil;

  }


  if (error != NULL) {
      *error = [SEError errorWithResponseDict:json];
      if ([*error code] != 0)
          return nil;
    } else {
      SEError *se_error = [SEError errorWithResponseDict:json];
      if ([se_error code] != 0) {
          *error = se_error;

          return nil;
        }
    }

    return json;
}

+(OFDictionary*) performDeleteRequestToUrl:(OFString*)urlString error:(OFError**)error
{
    OFURL *url = [OFURL URLWithString:urlString];//[urlString stringByURLEncoding]];
    OFHTTPRequest *request = [OFHTTPRequest requestWithURL:url];

    request.method = OF_HTTP_REQUEST_METHOD_DELETE;

    OFHTTPResponse *response;
    int errCode = -1;

    @try {
      response = [__globalHTTPClient performRequest:request];
    } @catch (id e) {

      if (error != NULL) {

        if ([e respondsToSelector:@selector (errNo)]) {
            errCode = [e errNo];
          } else if ([e respondsToSelector:@selector(response)]) {

            OFHTTPResponse *r = [e response];

            errCode = (int)r.statusCode;
          }

        *error = [OFError errorWithDomain:OFObjFWErrorDomain code:errCode userInfo:[OFDictionary dictionaryWithKeysAndObjects:OFLocalizedDescriptionKey, [e description], nil]];
        }

      return nil;
    }


  OFDictionary *json;

  @try {

    json = [[response string] JSONValue];

  } @catch(id e) {
    if (error != NULL) {

        if ([e respondsToSelector:@selector (errNo)]) {
            errCode = [e errNo];
          }

        *error = [OFError errorWithDomain:OFObjFWErrorDomain code:errCode userInfo:[OFDictionary dictionaryWithKeysAndObjects:OFLocalizedDescriptionKey, [e description], nil]];
      }

    return nil;

  }

  if (error != NULL) {
      *error = [SEError errorWithResponseDict:json];
      if ([*error code] != 0)
          return nil;
    } else {
      SEError *se_error = [SEError errorWithResponseDict:json];
      if ([se_error code] != 0) {
          *error = se_error;

          return nil;
        }
    }

  return json;
}

+(OFDataArray*) jsonDataFromDictionary:(OFDictionary*)dictionary
{
	OFDataArray *jsonData = [OFDataArray dataArray];
	OFString *jsonString = [dictionary JSONRepresentation];

	[jsonData addItems:[jsonString UTF8String] count:[jsonString UTF16StringLength]];

	return jsonData;
}

+(OFString*) jsonStringFromDictionary:(OFDictionary*)dictionary
{
	return [dictionary JSONRepresentation];
}

+(OFHTTPCookie*) cookieWithJson:(OFDictionary*)json
{

	double unixTimeStamp = [[json objectForKey:@"expiry"] doubleValue];
	of_time_interval_t _interval=unixTimeStamp;
	OFDate *date = [OFDate dateWithTimeIntervalSince1970:_interval];

	OFHTTPCookie *cookie = [OFHTTPCookie cookieWithName:[json objectForKey:@"name"] value:[json objectForKey:@"value"]];

	cookie.secure = [[json objectForKey:@"secure"] boolValue];
	cookie.domain = [json objectForKey:@"domain"];
	cookie.path = [json objectForKey:@"path"];
	cookie.expires = date;

	return cookie;
}

@end
