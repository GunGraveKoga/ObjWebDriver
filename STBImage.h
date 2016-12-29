#import <ObjFW/OFObject.h>
#import "macros.h"

@class OFArray<ObjectType>;
@class OFString;
@class OFDictionary<KeyType,ObjectType>;
@class OFDataArray;
@class OFStream;
@class OFURL;

typedef OF_ENUM(int, STBImageType)
{
  STBImageTypeUnknown = -1,
  STBImageTypePNG,
  STBImageTypeJPEG,
  STBImageTypeBMP,
  STBImageTypePSD,
  STBImageTypeTGA,
  STBImageTypeHDR,
  STBImageTypePNM,
  STBImageTypePIC,
  STBImageTypeGIF
};

typedef OF_ENUM(int, STBImageBitsPerChannel)
{
  STBImageBPCUnknown = -1,
  STBImage8BPC,
  STBImage16BPC
};

typedef OF_ENUM(int, STBImageChannels)
{
  STBImageChannelsUnknown = 0,
  STBImageGrey,
  STBImageGreyAlpha,
  STBImageRGB,
  STBImageRGBAlpha
};

@class STBImage;

@protocol STBImageStreamReader <OFObject>
@end

OF_ASSUME_NONNULL_BEGIN

@interface STBImage: OFObject

@property(readonly) const void* bitmapBuffer;
@property(readonly) size_t bitmapBufferLength;
@property(readonly) STBImageType imageType;
@property of_dimension_t imageSize;
@property int imageWidth;
@property int imageHeight;
@property(readonly) STBImageChannels imageChannels;
@property STBImageBitsPerChannel bitsPerChannel;
@property(readonly) uint16_t delay;
@property(readonly, nullable) STBImage *nextFrame;

- (instancetype)initWithBuffer:(const void *)buffer size:(size_t)size;

- (instancetype)initWithData:(OFDataArray *)data;

- (instancetype)initWithFile:(OFString *)path;

- (instancetype)initWithURL:(OFURL *)url;

- (instancetype)initWithStream:(OFStream *)stream;

- (instancetype)initWithStream:(OFStream *)stream
                reader:(id<STBImageStreamReader>)reader;

- (instancetype)initWithStream:(OFStream *)stream
                readBlock:(int (^)(OFStream *streamToRead, void *buffer, int size))readBlock
                skipBlock:(void (^)(OFStream *streamToRead, int bytesToSkip))skipBlock
                eofBlock:(bool (^)(OFStream *streamToRead))isAtEOFBlock;

- (void)writeToFile:(OFString *)path;

- (void)writeToURL:(OFURL *)url;

- (void)writeToFile:(OFString *)path
        type:(STBImageType)type;

- (void)writeToURL:(OFURL *)url
        type:(STBImageType)type;

- (OFDataArray * _Nonnull)dataArrayRepresantation;

- (OFDataArray * _Nonnull)dataArrayRepresantationForType:(STBImageType)type;

- (void)verticallyFlip;

@end

OF_ASSUME_NONNULL_END
