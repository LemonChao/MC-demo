//
//  RTAVVideoEncoder.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "RTAVVideoEncoder.h"
#import "RTAVVideoConfiguration.h"
#import "RTAVVideoFrame.h"

int encode_length;
int isFindKeyFrame;
int out_video_len[1];
Byte video_buffer[500000];
unsigned short video_seq;

@interface RTAVVideoEncoder ()
{
    VTCompressionSessionRef  compressSession;
    NSUInteger frameCount;
    
    NSData * sps;
    NSData * pps;
    FILE *fp;
    BOOL enabledWriteVideoFile;
    
    //视频传输添加
    NSMutableData *sendData;
}
@property (nonatomic,strong)RTAVVideoConfiguration *configuration;
@end
@implementation RTAVVideoEncoder
- (nullable instancetype)initWithVideoConfiguration:(nullable RTAVVideoConfiguration *)configuration;
{
    if (self = [super init]) {
        _configuration = configuration;
        [self compressSessionCreat];
        sendData = [[NSMutableData alloc] init];
        

        enabledWriteVideoFile = YES;
#ifdef DEBUG
        [self initForFilePath];
#endif
    }
    return self;
}

- (void)compressSessionIncalid {
    
    //如果存在强制将当前的会话结束帧编码
    VTCompressionSessionCompleteFrames(compressSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(compressSession);
    CFRelease(compressSession);
    compressSession = NULL;
    
}


- (void)compressSessionCreat
{
    if (compressSession) {
        //如果存在强制将当前的会话结束帧编码
        VTCompressionSessionCompleteFrames(compressSession, kCMTimeInvalid);
        VTCompressionSessionInvalidate(compressSession);
        CFRelease(compressSession);
        compressSession = NULL;
    }

    VTCompressionSessionCreate(NULL, _configuration.videoSize.width, _configuration.videoSize.height, kCMVideoCodecType_H264, NULL, NULL, NULL, customCallBack, (__bridge void *)self, &compressSession);
//    _currentVideoBitRate = _configuration.videoBitRate;
    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_MaxKeyFrameInterval,(__bridge CFTypeRef)@(25));//_configuration.videoMaxBitRate
//    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration,(__bridge CFTypeRef)@(_configuration.videoMaxKeyframeInterval));
    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_ExpectedFrameRate, (__bridge CFTypeRef)@(_configuration.videoFrameRate));
    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_AverageBitRate, (__bridge CFTypeRef)@(_configuration.videoBitRate));
    NSArray *limit = @[@(_configuration.videoBitRate * 1.5/8),@(1)];
    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_DataRateLimits, (__bridge CFArrayRef)limit);
    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_RealTime, kCFBooleanFalse);
    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Main_AutoLevel);
    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanFalse);
    VTSessionSetProperty(compressSession, kVTCompressionPropertyKey_H264EntropyMode, kVTH264EntropyMode_CABAC);
    VTCompressionSessionPrepareToEncodeFrames(compressSession);
}

- (void)initForFilePath
{
    char *path = [self GetFilePathByfileName:"IOSCamDemo.h264"];
    NSLog(@"%s",path);
    self->fp = fopen(path,"wb");
}
- (char*)GetFilePathByfileName:(char*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *strName = [NSString stringWithFormat:@"%s",filename];
    
    NSString *writablePath = [documentsDirectory stringByAppendingPathComponent:strName];
    
    NSUInteger len = [writablePath length];
    
    char *filepath = (char*)malloc(sizeof(char) * (len + 1));
    
    [writablePath getCString:filepath maxLength:len + 1 encoding:[NSString defaultCStringEncoding]];
    
    return filepath;
}
- (void)encoderVideoData:(CVPixelBufferRef)pixelBuffer timeStamp:(int64_t)timestamp
{
    frameCount++;
    CMTime presentationTimeStamp = CMTimeMake(frameCount, 1000); //固定压缩为每秒1000帧
    CMTime duration = CMTimeMake(1, (int32_t) _configuration.videoFrameRate); //当前帧的时间
    NSDictionary * dic = nil;
    if (frameCount % _configuration.videoFrameRate == 0) {
        dic = @{(__bridge NSString *)kVTEncodeFrameOptionKey_ForceKeyFrame: @YES};
    }
    VTEncodeInfoFlags  flags;
    VTCompressionSessionEncodeFrame(compressSession, pixelBuffer, presentationTimeStamp,duration, (CFDictionaryRef)dic, NULL, &flags);
}

//
//void  outputCallBack(void * CM_NULLABLE outputCallbackRefCon,void * CM_NULLABLE sourceFrameRefCon,OSStatus status,VTEncodeInfoFlags infoFlags,CM_NULLABLE CMSampleBufferRef sampleBuffer )
//{
//    //不存在则代表压缩不成功或帧丢失
//    if(!sampleBuffer) return;
//    if (status != noErr) return;
//    //返回sampleBuffer中包括可变字典的不可变数组,如果有错误则为NULL
//   CFArrayRef  array =  CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true);
//    if (!array)  return;
//   
//    static int frameCount123 = 0;
//    frameCount123++;
//    
////    NSLog(@"didCompressH264 called with status %d infoFlags %d FrameCount %d", (int)status, (int)infoFlags, frameCount123);
//   
//    static int keyFrameCount123 = 0;
//    
//   CFDictionaryRef dic = CFArrayGetValueAtIndex(array, 0);
//    if (!dic) return;
//    
//   //kCMSampleAttachmentKey_NotSync:没有这个键意味着同步, yes: 异步. no:同步
//    BOOL keyframe = !CFDictionaryContainsKey(dic, kCMSampleAttachmentKey_NotSync); //此代表为同步
//    RTAVVideoEncoder * encoder = (__bridge RTAVVideoEncoder *)(outputCallbackRefCon);
//    
//    //
//    if (keyframe) {
//        keyFrameCount123 = 0;
//        //获取sample buffer 中的 CMVideoFormatDesc
//        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
//        
//        //获取H264参数集合中的SPS和PPS
//        const uint8_t * sparameterSet;
//        size_t sparameterSetSize,sparameterSetCount ;
//       OSStatus statusCode =    CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 0, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0);
//        if (statusCode == noErr) {
//            size_t pparameterSetSize, pparameterSetCount;
//            const uint8_t *pparameterSet;
//         OSStatus statusCode =    CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 1, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0);
//            if (statusCode == noErr) {
//                encoder->sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
//                encoder->pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
//                
//                if(encoder->enabledWriteVideoFile){
//                    NSMutableData *data = [[NSMutableData alloc] init];
//                    uint8_t header[] = {0x00,0x00,0x00,0x01};
//                    [data appendBytes:header length:4];
//                    [data appendData:encoder->sps];
//                    [data appendBytes:header length:4];
//                    [data appendData:encoder->pps];
//                    fwrite(data.bytes, 1,data.length,encoder->fp);
//                }
//            }
//        }
//    }
//    keyFrameCount123++;
////    NSLog(@"keyFrameCount = %d", keyFrameCount123);
//    
//    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
//    size_t  lengthAtOffset,totalLength;
//    char *dataPointer;
//    //接收到的数据展示
//    OSStatus blockBufferStatus = CMBlockBufferGetDataPointer(blockBuffer, 0, &lengthAtOffset, &totalLength, &dataPointer);
//    if (blockBufferStatus == kCMBlockBufferNoErr)
//    {
//        size_t bufferOffset = 0;
//        static const int AVCCHeaderLength = 4;
//        while (bufferOffset < totalLength -  AVCCHeaderLength) {
//            // Read the NAL unit length
//            uint32_t NALUnitLength = 0;
//            /**
//             *  void *memcpy(void *dest, const void *src, size_t n);
//             *  从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中
//             */
//            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
//            //字节从高位反转到低位
//            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
//            
//            RTAVVideoFrame * frame = [RTAVVideoFrame new];
//            frame.sps = encoder -> sps;
//            frame.pps = encoder -> pps;
//            frame.data = [NSData dataWithBytes:(dataPointer+bufferOffset+AVCCHeaderLength) length:NALUnitLength];
//            if(encoder->enabledWriteVideoFile){
//                NSMutableData *data = [[NSMutableData alloc] init];
//                if(keyframe){
//                    uint8_t header[] = {0x00,0x00,0x00,0x01};
//                    [data appendBytes:header length:4];
//                }else{
//                    uint8_t header[] = {0x00,0x00,0x01};
//                    [data appendBytes:header length:3];
//                }
//                [data appendData:frame.data];
//                
//                fwrite(data.bytes, 1,data.length,encoder->fp);
//                unsigned short width = encoder->_configuration.videoSize.width;
//                unsigned short height= encoder->_configuration.videoSize.height;
//                sendVideoData((void *)encoder->sendData.bytes, encoder->sendData.length, keyframe, width, height);
//
//                
////                fwrite(frame.data.bytes, 1,frame.data.length,encoder->fp);
////                sendVideoData(frame.data.bytes, frame.data.length, keyframe);
//
//            }
//
//            bufferOffset += NALUnitLength + AVCCHeaderLength;
//        }
//    }
//}

void  customCallBack(void * CM_NULLABLE outputCallbackRefCon,void * CM_NULLABLE sourceFrameRefCon,OSStatus status,VTEncodeInfoFlags infoFlags,CM_NULLABLE CMSampleBufferRef sampleBuffer )
{
   //不存在则代表压缩不成功或丢帧
    if (!sampleBuffer) return;
    if (status != noErr) return;
    //返回sampleBuffer包括可变字典的不可变数组，如果有错误则为NULL
    CFArrayRef array = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true);
    if (!array) return;
    
    static int frameCount123 = 0;
    frameCount123++;
    
    static int keyFrameCount123 = 0;
    
    CFDictionaryRef dic = CFArrayGetValueAtIndex(array, 0);
    if (!dic) return;
    
    //kCMSampleAttachmentKey_NotSync:没有这个键意味着同步, yes: 异步. no:同步
    BOOL keyframe = !CFDictionaryContainsKey(dic, kCMSampleAttachmentKey_NotSync); //此代表同步
    RTAVVideoEncoder *encoder = (__bridge RTAVVideoEncoder *)(outputCallbackRefCon);
    
    if (keyframe) {
        keyFrameCount123 = 0;
        //获取sample buffer 中的 CMVideoFormatDesc
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        
        //获取H264参数集合中的SPS和PPS
        const uint8_t *sparameterSet;
        size_t sparameterSetSize,sparameterSetCount ;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,
                                                                                 0,
                                                                                 &sparameterSet,
                                                                                 &sparameterSetSize,
                                                                                 &sparameterSetCount,
                                                                                 0);
        if (statusCode == noErr) {
            size_t pparameterSetSize,pparameterSetCount;
            const uint8_t *pparameterSet;
            OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,
                                                                                     1,
                                                                                     &pparameterSet,
                                                                                     &pparameterSetSize,
                                                                                     &pparameterSetCount,
                                                                                     0);
            if (statusCode == noErr) {
                //Found pps
                encoder->sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                encoder->pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
                
                uint8_t header[] = {0x00,0x00,0x00,0x01};
                
                [encoder->sendData appendBytes:header length:4];
                [encoder->sendData appendData:encoder->sps];
                [encoder->sendData appendBytes:header length:4];
                [encoder->sendData appendData:encoder->pps];

//                if(encoder->enabledWriteVideoFile){
//                    uint8_t header[] = {0x00,0x00,0x00,0x01};
//                    
//                    [encoder->sendData appendBytes:header length:4];
//                    [encoder->sendData appendData:encoder->sps];
//                    [encoder->sendData appendBytes:header length:4];
//                    [encoder->sendData appendData:encoder->pps];
//                    
////                    fwrite(encoder->sendData.bytes, 1,encoder->sendData.length,encoder->fp);
//                }

            }
        }
    }
    
    keyFrameCount123++;
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t lengthAtOffset,totalLength;
    char *dataPointer;
    //接收到的数据展示
    OSStatus blockBufferStatus = CMBlockBufferGetDataPointer(blockBuffer,
                                                             0,
                                                             &lengthAtOffset,
                                                             &totalLength,
                                                             &dataPointer);
    
    
    if (blockBufferStatus == kCMBlockBufferNoErr)
    {
        size_t bufferOffset = 0;
        static const int AVCCHeaderLength = 4;
        while (bufferOffset < totalLength -  AVCCHeaderLength) {
            // Read the NAL unit length
            uint32_t NALUnitLength = 0;
            /**
             *  void *memcpy(void *dest, const void *src, size_t n);
             *  从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中
             */
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            //字节从高位反转到低位
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            
            RTAVVideoFrame * frame = [RTAVVideoFrame new];
            frame.sps = encoder -> sps;
            frame.pps = encoder -> pps;
            frame.data = [NSData dataWithBytes:(dataPointer+bufferOffset+AVCCHeaderLength) length:NALUnitLength];
            
            if(keyframe){
                uint8_t header[] = {0x00,0x00,0x00,0x01};
                [encoder->sendData appendBytes:header length:4];
            }else{
                uint8_t header[] = {0x00,0x00,0x01};
                [encoder->sendData appendBytes:header length:3];
            }
            [encoder->sendData appendData:frame.data];
            
            bufferOffset += NALUnitLength + AVCCHeaderLength;
        }
        unsigned short width = encoder->_configuration.videoSize.width;
        unsigned short height= encoder->_configuration.videoSize.height;
        sendVideoData((void *)encoder->sendData.bytes, encoder->sendData.length, keyframe, width, height);
//        fwrite(encoder->sendData.bytes, 1,encoder->sendData.length,encoder->fp);

        [encoder->sendData replaceBytesInRange:NSMakeRange(0, encoder->sendData.length) withBytes:NULL length:0];
    }
}


/**
 send video

 @param df 34
 */
void sendVideoData(void *mdata, unsigned int length, bool keyFrame, unsigned short width, unsigned short height)
{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    unsigned int tsInt = [[NSNumber numberWithDouble:nowtime] unsignedIntegerValue];
//    devavtp_send_video((char *)keyFrame, video_seq++, tsInt, 640, 480, length, mdata);
    devavtp_send_video((char *)keyFrame, video_seq++, tsInt, width, height, length, mdata);
//    printf("++++++++++++++ seq=%hu,  len=%u, keyFram = %d,  tsInt%u\n ", video_seq, length, keyFrame, tsInt);

}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterForeground" object:nil];
}


@end
