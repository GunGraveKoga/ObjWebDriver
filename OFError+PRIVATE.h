@interface OFError (PRIVATE)

+ (instancetype)OF_last;
+ (instancetype)OF_systemError:(int)eno;
+ (OFString *)OF_descriptionForSystemError:(int)eno;

@end
