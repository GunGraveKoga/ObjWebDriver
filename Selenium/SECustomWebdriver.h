#import <ObjFW/OFObject.h>

@class OFString;

@protocol SECustomWebdriver<OFObject>
@required
- (instancetype)initWithExecutable:(OFString *)path;
- (instancetype)initWithExecutable:(OFString *)path serverAddress:(OFString *)serverAddress port:(ssize_t)port;
@end
