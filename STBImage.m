#import <ObjFW/ObjFW.h>
#import "STBImage.h"
#import "STBImageException.h"

_Pragma("clang diagnostic push")
_Pragma("clang diagnostic ignored \"-Wunused-parameter\"")
_Pragma("clang diagnostic ignored \"-Wunused-function\"")
_Pragma("clang diagnostic ignored \"-Wunused-variable\"")

#define STB_IMAGE_IMPLEMENTATION 1
#define STBI_NO_STDIO 1
#define STBI_FAILURE_USERMSG 1
#define STBI_OBJFW_ERROR_MESSAGE 1

OFString * const STBIErrorMessage = @"STBIErrorMessage";

static int stbi__err_thread_safe(const char *errmsg);
static const char *stbi_failure_reason_thread_safe(void);

#define STBI_ERROR_FUNCTIONS 1
#define STBI_INTERNAL_ERROR_MESSAGE stbi_failure_reason_thread_safe()
#define STBI_SET_INTERNAL_ERROR_MESSAGE(x) stbi__err_thread_safe(x)

#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION 1
#define STBI_WRITE_NO_STDIO 1

#include "stb_image_write.h"

STBIWDEF int stbi_write_bmp_to_block(void (^block)(void*, int), int x, int y, int channels, const void *bitmap);
STBIWDEF int stbi_write_tga_to_block(void (^block)(void*, int), int x, int y, int channels, const void *bitmap);
STBIWDEF int stbi_write_hdr_to_block(void (^block)(void*, int), int x, int y, int channels, const float *hdr);

#define STB_IMAGE_RESIZE_IMPLEMENTATION

#include "stb_image_resize.h"

_Pragma("clang diagnostic pop")

@interface STBImage ()

@property(readwrite) STBImageType imageType;
@property(readwrite, nullable) STBImage *nextFrame;

- (instancetype)initWithBuffer:(const void *)buffer size:(size_t)size copy:(BOOL)flag;

- (void)STBI_load;
- (void)STBI_loadAsJPEG:(stbi__result_info *)info;
- (void)STBI_loadAsPNG:(stbi__result_info *)info;
- (void)STBI_loadAsBMP:(stbi__result_info *)info;
- (void)STBI_loadAsGIF:(stbi__result_info *)info;
- (void)STBI_loadAsPSD:(stbi__result_info *)info;
- (void)STBI_loadAsPIC:(stbi__result_info *)info;
- (void)STBI_loadAsPNM:(stbi__result_info *)info;
- (void)STBI_loadAsHDR:(stbi__result_info *)info;
- (void)STBI_loadAsTGA:(stbi__result_info *)info;
- (void)STBI_postprocess:(stbi__result_info *)info;

@end


@implementation STBImage {
  uint8_t *_bitmapBuffer;
  size_t _bitmapBufferLength;
  STBImageType _imageType;
  STBImageBitsPerChannel _bitsPerChannel;
  STBImageChannels _imageChannels;

  STBImage *_nextFrame;
  uint16_t _delay;

  stbi_io_callbacks *_callBacks;
  stbi__context _imageContext;

  of_dimension_t _imageSize;
  int _width;
  int _height;

  OFDataArray *_originalImageData;

  __weak OFStream *_streamToRead;
  __weak id<STBImageStreamReader> _reader;
}

@dynamic bitmapBuffer;
@synthesize bitmapBufferLength = _bitmapBufferLength;
@synthesize imageType = _imageType;
@dynamic imageSize;
@dynamic imageHeight;
@dynamic imageWidth;
@synthesize  imageChannels = _imageChannels;
@dynamic bitsPerChannel;
@synthesize nextFrame = _nextFrame;
@synthesize delay = _delay;

- (void)STBI_load
{
  stbi__result_info info;
  memset(&info, 0, sizeof(stbi__result_info));

  info.bits_per_channel = 8;
  info.channel_order = STBI_ORDER_RGB;
  info.num_channels = 0;

  _width = 0;
  _height = 0;
  _imageChannels = STBImageChannelsUnknown;

  if (stbi__jpeg_test(&_imageContext)) {
      self.imageType = STBImageTypeJPEG;

      [self STBI_loadAsJPEG:&info];
    }
  else if (stbi__png_test(&_imageContext)) {
      self.imageType = STBImageTypePNG;

      [self STBI_loadAsPNG:&info];
    }
  else if (stbi__bmp_test(&_imageContext)) {
      self.imageType = STBImageTypeBMP;

      [self STBI_loadAsBMP:&info];
    }
  else if (stbi__gif_test(&_imageContext)) {
      self.imageType = STBImageTypeGIF;

      [self STBI_loadAsGIF:&info];
    }
  else if (stbi__psd_test(&_imageContext)) {
      self.imageType = STBImageTypePSD;

      [self STBI_loadAsPSD:&info];
    }
  else if (stbi__pic_test(&_imageContext)) {
      self.imageType = STBImageTypePIC;

      [self STBI_loadAsPIC:&info];
    }
  else if (stbi__pnm_test(&_imageContext)) {
      self.imageType = STBImageTypePNM;

      [self STBI_loadAsPNM:&info];
    }
  else if (stbi__hdr_test(&_imageContext)) {
      self.imageType = STBImageTypeHDR;

      [self STBI_loadAsHDR:&info];
    }
  else if (stbi__tga_test(&_imageContext)) {
      self.imageType = STBImageTypeTGA;

      [self STBI_loadAsTGA:&info];
    }
  else {
      @throw [STBInvalidImageTypeException exception];
    }

  [self STBI_postprocess:&info];

}

- (void)STBI_postprocess:(stbi__result_info *)info
{
  _imageSize = of_dimension((float)_width, (float)_height);

  if (!_bitmapBufferLength)
    _bitmapBufferLength = (int)_imageChannels * _width *_height;

  if (info->bits_per_channel != 8) {
      STBI_ASSERT(info->bits_per_channel == 16);

      [self setBitsPerChannel:STBImage16BPC];

      return;
    }

  _bitsPerChannel = STBImage8BPC;
}

- (void)STBI_loadAsJPEG:(stbi__result_info *)info
{
  _bitmapBuffer = (uint8_t *)stbi__jpeg_load(&_imageContext, &_width, &_height, (int *)(&_imageChannels), 0, info);

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];
}

- (void)STBI_loadAsPNG:(stbi__result_info *)info
{
  _bitmapBuffer = (uint8_t *)stbi__png_load(&_imageContext, &_width, &_height, (int *)(&_imageChannels), 0, info);

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];
}

- (void)STBI_loadAsBMP:(stbi__result_info *)info
{
  _bitmapBuffer = (uint8_t *)stbi__bmp_load(&_imageContext, &_width, &_height, (int *)(&_imageChannels), 0, info);

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];
}

- (void)STBI_loadAsGIF:(stbi__result_info *)info
{
  int comp = 0;
  stbi__gif gifContext;
  uint8_t *data = NULL;
  uint8_t *delayPtr = NULL;

  STBImage *frame = nil;
  __weak STBImage *prev = nil;

#define SET_DELAY(p, d) \
  p[0] = d & 0xFF; \
  p[1] = (d & 0xFF00) >> 8

  while ((data = stbi__gif_load_next(&_imageContext, &gifContext, &comp, 0)) != NULL) {
      if (data == (uint8_t *)&_imageContext) {
          break;
        }

      if (_bitmapBuffer == NULL) {
          _imageChannels = (STBImageChannels)comp;
          _width = gifContext.w;
          _height = gifContext.h;

          _bitmapBufferLength = comp * _width * _height;

          _bitmapBuffer = (uint8_t *)stbi__malloc(_bitmapBufferLength);

          if (_bitmapBuffer == NULL)
            @throw [OFOutOfMemoryException exceptionWithRequestedSize:_bitmapBufferLength];

          memcpy(_bitmapBuffer, data, _bitmapBufferLength);

          delayPtr = (uint8_t *)&_delay;

          SET_DELAY(delayPtr, gifContext.delay);

          prev = self;
          delayPtr = NULL;
          data = NULL;

          continue;

        }

      frame = [[STBImage alloc] init];
      frame->_imageChannels = (STBImageChannels)comp;
      frame->_width = gifContext.w;
      frame->_height = gifContext.h;
      frame->_imageType = self->_imageType;
      frame->_bitmapBufferLength = comp * gifContext.w * gifContext.h;

      frame->_bitmapBuffer = (uint8_t *)stbi__malloc(frame->_bitmapBufferLength);

      if (frame->_bitmapBuffer == NULL)
        @throw [OFOutOfMemoryException exceptionWithRequestedSize:frame->_bitmapBufferLength];

      memcpy(frame->_bitmapBuffer, data, frame->_bitmapBufferLength);

      delayPtr = (uint8_t *)&(frame->_delay);
      SET_DELAY(delayPtr, gifContext.delay);

      frame->_imageContext = self->_imageContext;

      [frame STBI_postprocess:info];

      prev.nextFrame = frame;
      prev = frame;

      delayPtr = NULL;

    }

#undef SET_DELAY

  if (_bitmapBuffer == NULL)
    @throw [STBInvalidImageTypeException exception];

  if (prev)
    prev.nextFrame = nil;

  STBI_FREE(gifContext.out);

  return;

}

- (void)STBI_loadAsPSD:(stbi__result_info *)info
{
  _bitmapBuffer = (uint8_t *)stbi__psd_load(&_imageContext, &_width, &_height, (int *)(&_imageChannels), 0, info, 8);

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];
}

- (void)STBI_loadAsPIC:(stbi__result_info *)info
{
  _bitmapBuffer = (uint8_t *)stbi__pic_load(&_imageContext, &_width, &_height, (int *)(&_imageChannels), 0, info);

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];
}

- (void)STBI_loadAsPNM:(stbi__result_info *)info
{
  _bitmapBuffer = (uint8_t *)stbi__pnm_load(&_imageContext, &_width, &_height, (int *)(&_imageChannels), 0, info);

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];
}

- (void)STBI_loadAsHDR:(stbi__result_info *)info
{
  float *hdr = stbi__hdr_load(&_imageContext, &_width, &_height, (int *)(&_imageChannels), 0, info);

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];

  _bitmapBuffer = (uint8_t *)stbi__hdr_to_ldr(hdr, _width, _height, (int)(_imageChannels));

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];
}

- (void)STBI_loadAsTGA:(stbi__result_info *)info
{
  _bitmapBuffer = (uint8_t *)stbi__tga_load(&_imageContext, &_width, &_height, (int *)(&_imageChannels), 0, info);

  if (_bitmapBuffer == NULL)
    @throw [STBIFailureException exception];
}

- (instancetype)initWithBuffer:(const void *)buffer size:(size_t)size copy:(BOOL)flag
{
  self = [super init];
  _bitmapBuffer = NULL;
  _bitmapBufferLength = 0;
  _imageType = STBImageTypeUnknown;
  _bitsPerChannel = STBImageBPCUnknown;

  memset(&_imageContext, 0, sizeof(stbi__context));

  stbi__start_mem(&_imageContext, (const uint8_t *)buffer, size);

  [self STBI_load];

  if (flag) {
      _originalImageData = [[OFDataArray alloc] initWithCapacity:size];

      [_originalImageData addItems:buffer count:size];
    }

  return self;
}

- (void)dealloc
{
  if (_bitmapBuffer != NULL)
    STBI_FREE(_bitmapBuffer);
}

- (instancetype)initWithBuffer:(const void *)buffer size:(size_t)size
{
  return [self initWithBuffer:buffer size:size copy:YES];
}

- (const void *)bitmapBuffer OF_RETURNS_INNER_POINTER
{
 return (const void *)_bitmapBuffer;
}

- (int)imageWidth
{
  return _width;
}

- (int)imageHeight
{
  return _height;
}

- (void)setImageWidth:(int)width
{
  [self setImageSize:of_dimension((0.0 + width), (0.0 + _height))];
}

- (void)setImageHeight:(int)height
{
    [self setImageSize:of_dimension((0.0 + _width), (0.0 + height))];
}

- (of_dimension_t)imageSize
{
      return _imageSize;
}

- (void)setImageSize:(of_dimension_t)size
{
  if ((size.width < INT_MIN - 0.5 || size.width > INT_MAX + 0.5) ||
      (size.height < INT_MIN - 0.5 || size.height > INT_MAX + 0.5)) {
      @throw  [OFInvalidArgumentException exception];
    }

  int newWidth = (int)(size.width >= 0 ? size.width + 0.5 : size.width - 0.5);
  int newHeight = (int)(size.height >= 0 ? size.height + 0.5 : size.height - 0.5);

  stbir_datatype dataType;
  int multiplier = 0;
  int alpha;

  if (_imageChannels == STBImageGreyAlpha || _imageChannels == STBImageRGBAlpha)
    alpha = (int)_imageChannels - 1;
  else
    alpha = STBIR_ALPHA_CHANNEL_NONE;

  switch(_bitsPerChannel) {
    case STBImage8BPC:
      dataType = STBIR_TYPE_UINT8;
      multiplier = 1;
      break;
    case STBImage16BPC:
      dataType = STBIR_TYPE_UINT16;
      multiplier = 2;
      break;
    default:
      dataType = STBIR_MAX_TYPES;
      multiplier = (int)STBIR_MAX_TYPES + 1;
      break;
    }

  int newBufferSize = (newWidth * newHeight * _imageChannels) * multiplier;

  uint8_t *newBitmapBuffer = (uint8_t *)STBI_MALLOC(newBufferSize);

  if (newBitmapBuffer == NULL)
    @throw [OFOutOfMemoryException exceptionWithRequestedSize:newBufferSize];

  memset(newBitmapBuffer, 0, newBufferSize);

  int rc = stbir_resize(
          _bitmapBuffer,
          _width,
          _height,
          (_width * (int)_imageChannels) * multiplier,
          newBitmapBuffer,
          newWidth,
          newHeight,
          (newWidth * (int)_imageChannels) * multiplier,
          dataType,
          (int)_imageChannels,
          alpha,
          0,
          STBIR_EDGE_ZERO,
          STBIR_EDGE_ZERO,
          STBIR_FILTER_CUBICBSPLINE,
          STBIR_FILTER_CUBICBSPLINE,
          STBIR_COLORSPACE_SRGB,
          NULL
        );

  if (rc != 1) {
    STBI_FREE(newBitmapBuffer);
    @throw [OFException exception];
  }

  STBI_FREE(_bitmapBuffer);
  _bitmapBuffer = newBitmapBuffer;
  _width = newWidth;
  _height = newHeight;
  _imageSize = size;
}

- (STBImageBitsPerChannel)bitsPerChannel
{
      return _bitsPerChannel;
}

- (void)setBitsPerChannel:(STBImageBitsPerChannel)bpc
{
  if (_bitsPerChannel != bpc) {
      switch (bpc) {
          case STBImage8BPC:
            {
              switch (_bitsPerChannel) {
                  case STBImage16BPC:
                    {
                      _bitmapBuffer = (uint8_t *)stbi__convert_16_to_8((uint16_t *)_bitmapBuffer, _width, _height, (int)_imageChannels);

                      if (_bitmapBuffer == NULL)
                        @throw [STBIFailureException exception];

                      _bitmapBufferLength = (_bitmapBufferLength) ? (_bitmapBufferLength / 2) : ((int)_imageChannels * _width * _height);
                    }
                    break;
                  default:
                    @throw [OFInvalidArgumentException exception];
                }
            }
            break;
          case STBImage16BPC:
            {
              switch (_bitsPerChannel) {
                  case STBImage8BPC:
                    {
                      _bitmapBuffer = (uint8_t *)stbi__convert_8_to_16(_bitmapBuffer, _width, _height, (int)_imageChannels);

                      if (_bitmapBuffer == NULL)
                        @throw [STBIFailureException exception];

                      _bitmapBufferLength = (_bitmapBufferLength) ? (_bitmapBufferLength * 2) : ((int)_imageChannels * _width * _height * 2);
                    }
                    break;
                  default:
                    @throw [OFInvalidArgumentException exception];
                }
            }
            break;
          default:
            @throw [OFInvalidArgumentException exception];
        }
    }
}

- (instancetype)initWithData:(OFDataArray *)data
{
      STBImage* instance = [self initWithBuffer:data.items size:(data.itemSize * data.count) copy:NO];

      instance->_originalImageData = data;

      return instance;
}

- (instancetype)initWithFile:(OFString *)path
{
    OFDataArray* data = [OFDataArray dataArrayWithContentsOfFile:path];

    STBImage* instance = [self initWithBuffer:data.items size:(data.itemSize * data.count) copy:NO];

    instance->_originalImageData = data;

    return instance;

}

- (instancetype)initWithURL:(OFURL *)url
{
    OFDataArray* data = [OFDataArray dataArrayWithContentsOfURL:url];

    STBImage* instance = [self initWithBuffer:data.items size:(data.itemSize * data.count) copy:NO];

    instance->_originalImageData = data;

    return instance;
}

- (instancetype)initWithStream:(OFStream *)stream
{
    OFDataArray* data = [stream readDataArrayTillEndOfStream];

    STBImage* instance = [self initWithBuffer:data.items size:(data.itemSize * data.count) copy:NO];

    instance->_originalImageData = data;

    return instance;
}

- (instancetype)initWithStream:(OFStream *)stream reader:(id<STBImageStreamReader>)reader
{
  OF_UNRECOGNIZED_SELECTOR;
  OF_UNREACHABLE;
}

- (instancetype)initWithStream:(OFStream *)stream
                readBlock:(int (^)(OFStream *streamToRead, void *buffer, int size))readBlock
                skipBlock:(void (^)(OFStream *streamToRead, int bytesToSkip))skipBlock
                eofBlock:(bool (^)(OFStream *streamToRead))isAtEOFBlock
{
  OF_UNRECOGNIZED_SELECTOR;
  OF_UNREACHABLE;
}

- (OFDataArray * _Nonnull)dataArrayRepresantation
{
    return [_originalImageData copy];
}

- (OFDataArray * _Nonnull)dataArrayRepresantationForType:(STBImageType)type
{

  int rc = 0;

  OFDataArray *result = nil;

  switch (type) {
    case STBImageTypePNG:
      {
        uint8_t *buffer = NULL;
        int size = 0;

        int stride_bytes = (_imageChannels * _width) * ((_bitsPerChannel == STBImage16BPC) ? 2 : 1);
        buffer = stbi_write_png_to_mem(_bitmapBuffer, stride_bytes, _width, _height, _imageChannels, &size);

        if (buffer == NULL)
          @throw [STBIFailureException exception];

          result = [OFDataArray dataArrayWithCapacity:(size_t)size];

          [result addItems:buffer count:(size_t)size];

          STBIW_FREE(buffer);
      }
      break;
    case STBImageTypeBMP:
      {
        result = [OFDataArray dataArray];

        __block __weak OFDataArray *tmpData = result;

        rc = stbi_write_bmp_to_block(^(void* data, int count){
                                       [tmpData addItems:data count:(size_t)count];

                                     }, _width, _height, _imageChannels, _bitmapBuffer);

        if (!rc) {
            result = nil;

            @throw [STBIFailureException exception];
          }
      }
      break;
    case STBImageTypeHDR:
      {
        stbi_uc *data = (stbi_uc *)STBI_MALLOC(_bitmapBufferLength);

        memcpy(data, _bitmapBuffer, _bitmapBufferLength);

        const float *hdr = stbi__ldr_to_hdr(data, _width, _height, _imageChannels);

        if (hdr == NULL)
          @throw [STBIFailureException exception];

        result = [OFDataArray dataArray];

        __block __weak OFDataArray *tmpData = result;

        rc = stbi_write_hdr_to_block(^(void* data, int count){
                                       [tmpData addItems:data count:(size_t)count];

                                     }, _width, _height, _imageChannels, hdr);

        STBI_FREE((void *)hdr);

        if (!rc) {
            result = nil;

            @throw [STBIFailureException exception];
          }
      }
      break;
    case STBImageTypeTGA:
      {
        result = [OFDataArray dataArray];

        __block __weak OFDataArray *tmpData = result;

        rc = stbi_write_tga_to_block(^(void* data, int count){
                                       [tmpData addItems:data count:(size_t)count];

                                     }, _width, _height, _imageChannels, _bitmapBuffer);

        if (!rc) {
            result = nil;

            @throw [STBIFailureException exception];
          }
      }
      break;
    default:
      @throw [OFInvalidArgumentException exception];
    }

  return result;
}

- (void)writeToFile:(OFString *)path
{
    [_originalImageData writeToFile:path];
}

- (void)writeToURL:(OFURL *)url
{
    (void)url;
    OF_UNRECOGNIZED_SELECTOR;
}

- (void)writeToFile:(OFString *)path
        type:(STBImageType)type
{
    OFDataArray *data = [self dataArrayRepresantationForType:type];

    [data writeToFile:path];
}

- (void)writeToURL:(OFURL *)url
        type:(STBImageType)type
{
    (void)url;
    (void)type;
    OF_UNRECOGNIZED_SELECTOR;
}

- (void)verticallyFlip
{
      int row,col,z;
      stbi_uc *image = (stbi_uc *)_bitmapBuffer;
      stbi_uc temp;

      for (row = 0; row < (_height >> 1); row++) {
          for (col = 0; col < _width; col++) {
              for (z = 0; z < (int)_imageChannels; z++) {
                  temp = image[(row * _width + col) * (int)_imageChannels + z];

                  image[(row * _width + col) * (int)_imageChannels + z] = image[((_height - row - 1) * _width + col) * (int)_imageChannels + z];
                  image[((_height - row - 1) * _width + col) * (int)_imageChannels + z] = temp;
                }
            }
        }
}

@end

int stbi_write_bmp_to_block(void (^block)(void*, int), int x, int y, int channels, const void *bitmap) {
  of_block_literal_t *wb = (__bridge of_block_literal_t *)block;
  int rc = stbi_write_bmp_to_func((void *)wb->invoke, (void *)wb, x, y, channels, bitmap);

  return rc;
}

int stbi_write_tga_to_block(void (^block)(void*, int), int x, int y, int channels, const void *bitmap) {
  of_block_literal_t *wb = (__bridge of_block_literal_t *)block;
  int rc = stbi_write_tga_to_func((void *)wb->invoke, (void *)wb, x, y, channels, bitmap);

  return rc;
}

int stbi_write_hdr_to_block(void (^block)(void*, int), int x, int y, int channels, const float *hdr) {
  of_block_literal_t *wb = (__bridge of_block_literal_t *)block;
  int rc = stbi_write_hdr_to_func((void *)wb->invoke, (void *)wb, x, y, channels, hdr);

  return rc;
}

int stbi__err_thread_safe(const char *errmsg) {
  @autoreleasepool {
    OFMutableDictionary *thrDict = [OFThread threadDictionary];

    [thrDict setObject:[OFString stringWithUTF8String:errmsg] forKey:STBIErrorMessage];
  }

  return 0;
}

const char *stbi_failure_reason_thread_safe(void) {
  return [[[OFThread threadDictionary] objectForKey:STBIErrorMessage] UTF8String];
}
