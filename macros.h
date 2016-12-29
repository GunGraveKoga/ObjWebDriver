#if defined(__cplusplus)
#define OBJC_EXPORT_BEGIN extern "C" {
#define OBJC_EXPORT_END }
#else
#define OBJC_EXPORT_BEGIN
#define OBJC_EXPORT_END
#endif

#define OBJC_EXPORT extern

// Enums and Options
#if (__cplusplus && __cplusplus >= 201103L && (__has_extension(cxx_strong_enums) || __has_feature(objc_fixed_enum))) || (!__cplusplus && __has_feature(objc_fixed_enum))
  #define OF_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
  #if (__cplusplus)
    #define OF_OPTIONS(_type, _name) _type _name; enum : _type
  #else
    #define OF_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
  #endif
#else
  #define OF_ENUM(_type, _name) _type _name; enum
  #define OF_OPTIONS(_type, _name) _type _name; enum
#endif


#if !defined(__clang__) || (defined(__clang__) && !__has_feature(objc_arc))
  #define OBJC_AUTORELEASEPOOL_NEW(x) OFAutoreleasePool* (x) = [OFAutoreleasePool new]
  #define OBJC_AUTORELEASEPOOL_DELETE(x) [(x) drain]
  #define OBJC_AUTORELEASE_OBJECT(x) [(x) autorelease]
  #define OBJC_RETAIN_OBJECT(x) [(x) retain]
  #define OBJC_RELEASE_OBJECT(x) [(x) release]
  #define OBJC_WEAKSELF_SET_OBJECT(x) void *weak_##x = (__bridge void *)(x)
  #define OBJC_WEAKSELF_GET_OBJECT(x) __typeof__((x))strong_##x = (__bridge __typeof__((x)))(weak_##x)
  #define OBJC_WEAKSELF(x) strong_##x
  #define OBJC_STRONG_PROPERTY retain
  #define OBJC_WEAK_PROPERTY assign
  #define OBJC_WEAK
  #define OBJC_STRONG
  #define OBJC_AUTORELEASING
  #define OBJC_UNSAFE_UNRETAINED
  #define PRAGMA_OBJC_ARC_BEGIN
  #define PRAGMA_OBJC_ARC_END
  #if !defined(__clang__)
  #define OBJC_BRIDGE_CAST(_type) (_type)
  #else
  #define OBJC_BRIDGE_CAST(_type) (__bridge _type)
  #endif
#else
  #define OBJC_AUTORELEASEPOOL_NEW(x) void* (x) = objc_autoreleasePoolPush()
  #define OBJC_AUTORELEASEPOOL_DELETE(x) objc_autoreleasePoolPop((x))
  #define OBJC_AUTORELEASE_OBJECT(x) (x)
  #define OBJC_RETAIN_OBJECT(x) (x)
  #define OBJC_RELEASE_OBJECT(x)
  #define OBJC_WEAKSELF_SET_OBJECT(x) __weak __typeof__((x))weak_##x = (x)
  #define OBJC_WEAKSELF_GET_OBJECT(x) __strong __typeof__((x))strong_##x = weak_##x
  #define OBJC_WEAKSELF(x) strong_##x
  #define OBJC_STRONG_PROPERTY strong
  #define OBJC_WEAK_PROPERTY weak
  #define OBJC_WEAK __weak
  #define OBJC_STRONG __strong
  #define OBJC_AUTORELEASING __autoreleasing
  #define OBJC_UNSAFE_UNRETAINED __unsafe_unretained
  #define PRAGMA_OBJC_ARC_BEGIN _Pragma("clang diagnostic push") \
                                _Pragma("clang diagnostic ignored \"-Wunused-value\"")

  #define PRAGMA_OBJC_ARC_END _Pragma("clang diagnostic pop")
  #define OBJC_BRIDGE_CAST(_type) (__bridge _type)
  #define OBJC_BRIDGE_CAST_RETAINED(_type) (__bridge_retained _type)
  #define OBJC_BRIDGE_CAST_TRANSFER(_type) (__bridge_transfer _type)
#endif

#if __has_feature(objc_arc)
#define CFBridgingRelease(o) ((__bridge_transfer id)(o))
#define CFBridgingRetain(o) ((__bridge_retained void *)(o))
#endif

