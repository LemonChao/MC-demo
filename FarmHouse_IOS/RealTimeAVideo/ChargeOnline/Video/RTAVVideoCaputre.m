//
//  RTAVVideoCaputre.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "RTAVVideoCaputre.h"
#import "RTAVVideoConfiguration.h"
#import "RTAVVideoEncoder.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+water.h"
#import "UIImage+compress.h"


@interface RTAVVideoCaputre ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureVideoPreviewLayer * _preViewLayer;
    
}
@property (nonatomic,strong)RTAVVideoEncoder *videoEncoder;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)RTAVVideoConfiguration *videoConfiguration;
@property (nonatomic, strong)AVCaptureDeviceInput *videoInput;

/** 图片输出流*/
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;

@end
@implementation RTAVVideoCaputre

#pragma mark - 拉伸镜头
- (void)tensileLes:(CGFloat)zoomValue{
    if (!_videoInput.device.isRampingVideoZoom) {
        NSError *error;
        if ([_videoInput.device lockForConfiguration:&error]) {              // 4
            // Provide linear feel to zoom slider
            CGFloat zoomFactor = pow([self maxZoomFactor], zoomValue);      // 5
            _videoInput.device.videoZoomFactor = zoomFactor;
            [_videoInput.device unlockForConfiguration];                     // 6
        }
    }
}

#pragma mark - 打开关闭闪光灯
- (void)openFlashWith:(UIButton *)sender{
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = _videoInput.device;
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    }else{//关闭闪光灯
        AVCaptureDevice *device = _videoInput.device;
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

#pragma mark - 自动模式和微距模式
- (void)setFocusWithNeed:(BOOL)isSeleted{
    if (isSeleted) {
        return;
    }
    AVCaptureDevice *captureDevice = _videoInput.device;
    NSError *error = nil;
    [captureDevice lockForConfiguration:&error];
    captureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    [captureDevice unlockForConfiguration];
}

#pragma mark - 微距模式改变焦点位置
- (void)changeFocusWith:(CGPoint)point{
    AVCaptureDevice *captureDevice = _videoInput.device;
    NSError *error = nil;
    [captureDevice lockForConfiguration:&error];
    captureDevice.focusPointOfInterest = point;
    captureDevice.focusMode = AVCaptureFocusModeAutoFocus;
    [captureDevice unlockForConfiguration];
}

- (CGFloat)maxZoomFactor {
    return MIN(_videoInput.device.activeFormat.videoMaxZoomFactor, 4.0f);    // 2
}


- (instancetype)initWithVideoConfiguration:(RTAVVideoConfiguration *)configuration
{
    if (self = [super init]) {
        _videoConfiguration = configuration;
//        [self addPreVideo];
    }
    return self;
}
#pragma mark - Method & Notification
- (void)addPreVideo
{
    AVCaptureVideoPreviewLayer * preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    preViewLayer.frame = [UIScreen mainScreen].bounds;
    preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //横屏模式下，旋转layer
    _preViewLayer = preViewLayer;
    
}

- (void)captureSessionWasInterrupt:(NSNotification *)notif {
    DLog(@"notif = %@", notif);
    NSDictionary *notiInfo = notif.userInfo;
    
    AVCaptureSessionInterruptionReason reason =  [notiInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
    if (reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableInBackground) {
        //encoder pause
        [self.videoEncoder compressSessionIncalid];
    }
}

- (void)sessionInterruptionEnded:(NSNotification *)notif {
    DLog(@"notif = %@", notif);
    [self.videoEncoder compressSessionCreat];
    
}

- (void)sessionDidStopRunning:(NSNotification *)notif {
    DLog(@"notif = %@", notif);
}

- (void)sessionDidStartRunning:(NSNotification *)notif {
    DLog(@"notif = %@", notif);
}




#pragma mark - delegate

#pragma mark AVCaptureSessionDelegete
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer  = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (imageBuffer != NULL) {
        
        [self.videoEncoder encoderVideoData:imageBuffer timeStamp:0];
    }
}

#pragma mark - setter & getter
-(RTAVVideoEncoder *)videoEncoder
{
    if (!_videoEncoder) {
        RTAVVideoEncoder * encoder = [[RTAVVideoEncoder alloc]initWithVideoConfiguration:_videoConfiguration];
        _videoEncoder = encoder;
    }
    return _videoEncoder;
}

- (AVCaptureSession *)session
{
    if (!_session) {
        //4.
        AVCaptureSession * session = [[AVCaptureSession alloc]init];
        session.sessionPreset = _videoConfiguration.avsessionPreset;
       
        //Session 被打断
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureSessionWasInterrupt:) name:AVCaptureSessionWasInterruptedNotification object:session];
        //session 打断结束
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:session];
        //session 已经停止
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionDidStopRunning:) name:AVCaptureSessionDidStopRunningNotification object:session];
        //session 已经运转
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionDidStartRunning:) name:AVCaptureSessionDidStartRunningNotification object:session];

        
        //1.
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError * error = nil;
        //2.
        AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        self.videoInput = videoInput;
      
        //3.
        AVCaptureVideoDataOutput *  videoOutput = [[AVCaptureVideoDataOutput alloc]init];
        dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [videoOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];

//        videoOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
        
    
        //5.
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        //添加照片输出
        [self.stillImageOutput setOutputSettings:outputSettings];
        
        if ([session canAddOutput:self.stillImageOutput]) {
            [session addOutput:self.stillImageOutput];
        }

        if ([session canAddInput:videoInput]) {
            [session addInput:videoInput];
        }
        if ([session canAddOutput:videoOutput]) {
            [session addOutput:videoOutput];
        }
        
        //此设置要放到addDeviceInput之后才能获取到
        AVCaptureConnection * connection =  [videoOutput connectionWithMediaType:AVMediaTypeVideo] ;
        connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
//        UIInterfaceOrientation statusBar = [[UIApplication sharedApplication] statusBarOrientation];
//        if(_videoConfiguration.landscape){
//            if(statusBar != UIInterfaceOrientationLandscapeLeft && statusBar != UIInterfaceOrientationLandscapeRight){
//                NSLog(@"当前设置方向出错");
//                NSLog(@"当前设置方向出错");
//                if (connection.isVideoOrientationSupported) {
//                    [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
//                }
//            }else{
//                
//                if (connection.isVideoOrientationSupported) {
//                    [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
//                }
//            }
//        }else{
//            if(statusBar != UIInterfaceOrientationPortrait && statusBar != UIInterfaceOrientationPortraitUpsideDown){
//                NSLog(@"当前设置方向出错");
//                NSLog(@"当前设置方向出错");
//                NSLog(@"当前设置方向出错");
//                if (connection.isVideoOrientationSupported) {
//                    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
//                }
//            }else{
//                if (connection.isVideoOrientationSupported) {
//                    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
//                }
//            }
//        }
        //设置帧率
        if ([device respondsToSelector:@selector(setActiveVideoMaxFrameDuration:)] && [device respondsToSelector:@selector(setActiveVideoMinFrameDuration:)]) {
            NSError * error ;
            if (nil == error) {
#if defined (__IPHONE_7_0)
             CMTime videoFrameRate =  CMTimeMake(1, (int32_t)_videoConfiguration.videoFrameRate);
                NSArray *supportedFrameRateRanges = [device.activeFormat videoSupportedFrameRateRanges];
                BOOL frameRateSupported = NO;
                for (AVFrameRateRange *range in supportedFrameRateRanges) {
                    if (CMTIME_COMPARE_INLINE(videoFrameRate, >=, range.minFrameDuration) &&
                        CMTIME_COMPARE_INLINE(videoFrameRate, <=, range.maxFrameDuration)) {
                        frameRateSupported = YES;
                    }
                }
                if (frameRateSupported && [device lockForConfiguration:&error]) {
                    device.activeVideoMaxFrameDuration = videoFrameRate;
                    device.activeVideoMinFrameDuration = videoFrameRate;
                    [device unlockForConfiguration];
                }
#endif
            }
        }else
        {
            for (AVCaptureConnection * connection in videoOutput.connections) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                if ([connection respondsToSelector:@selector(setVideoMinFrameDuration:)])
                    connection.videoMinFrameDuration = CMTimeMake(1,  (int32_t)_videoConfiguration.videoMinFrameRate);
                
                if ([connection respondsToSelector:@selector(setVideoMaxFrameDuration:)])
                    connection.videoMaxFrameDuration = CMTimeMake(1, (int32_t)_videoConfiguration.videoMaxFrameRate);
#pragma clang diagnostic pop
            }
        }

        
        //光学防抖
        AVCaptureVideoStabilizationMode stabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        if ([device.activeFormat isVideoStabilizationModeSupported:stabilizationMode]) {
            [connection setPreferredVideoStabilizationMode:stabilizationMode];
        }
        
        _session = session;
        
    }
    return _session;
}
- (void)setPreView:(UIView *)preView
{
    _preView = preView;
    if (_preViewLayer.superlayer ) {
        [_preViewLayer removeFromSuperlayer];
    }
    if (_preViewLayer) {
//        [preView.layer addSublayer:_preViewLayer];
        _preViewLayer.frame = preView.bounds;
        [_preViewLayer setAffineTransform:CGAffineTransformMakeRotation(-M_PI/2)];

        [preView.layer insertSublayer:_preViewLayer atIndex:0];
    }
//    [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
    

}
- (void)setRuning:(BOOL)runing
{
    if (_runing == runing) return;
    
    _runing = runing;
    
    if (runing) {
        [self.session  startRunning];
    }else
    {
        [self.session stopRunning];
    }
}

/** 点击拍照 */
- (void)takePhotoButtonClick:(NSDictionary *)paramDic
{
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    NSLog(@"takephotoClick...");
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    //    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            NSLog(@"没有权限");
            
            return ;
        }
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
            
            NSDate *date = [NSDate date];
            NSString *nameStr = [date format:@"YYYYMMddHHmmss"];
            NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
            [array replaceObjectAtIndex:0 withObject:[date format:@"YYYY/MM/dd/ HH:mm:ss"]];
            
            //save to sandbox
            UIImage *waterImg = [[UIImage imageWithData:jpegData] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
            NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatFileUnderCaches]
                                                       WithImage:waterImg
                                                       imageName:nameStr
                                                         imgType:@"jpeg"];
            char *pic_name = (char *)[imgPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
            
            //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\
            
            NSString *pathStr = [paramDic objectForKey:@"client_path"];
            NSString *clientPath= StrFormat(@"%@%@_%@_dev.jpg",pathStr, [ActivityApp shareActivityApp].reportNum, nameStr);
            //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\0011100000194246735518_20161206160339_dev.jpg
            
            char *fileName = (char *)[clientPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
            
            printf("fileName = %s, pic_name = %s ---\n",fileName, pic_name);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                jinglian_authed_send_picture(30, (int)jpegData.length, 0, 1, fileName, pic_name);


            });
            
            
            

        }];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        NSString *nameStr = [formatter stringFromDate:[NSDate date]];

        //save to sandbox
        NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatFileUnderCaches]
                                                   WithImage:[UIImage imageWithData:jpegData]
                                                   imageName:nameStr
                                                     imgType:@"jpeg"];
        char *pic_name = (char *)[imgPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        
//        
//        NSError *jsonError = nil;
//        NSDictionary *authINfo = [NSJSONSerialization JSONObjectWithData:[UDSobjectForKey(@"%d",VA_EVENT_AUTH_DEV_SNAP) dataUsingEncoding:NSUTF8StringEncoding]
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//        if (jsonError) {
//            DLog(@"JSONSerialization Error :%@", jsonError);
//            return;
//        }
        
//        NSDictionary *dic = [authINfo objectForKey:@"TJPuAuthSnap"];
        NSString *pathStr = [paramDic objectForKey:@"client_path"];
//        NSString *pathStr = @"D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000267246820468_1\\";
        NSString *reportNum = [ActivityApp shareActivityApp].reportNum;
        NSString *clientPath= StrFormat(@"%@%@_%@_dev.jpg",pathStr, reportNum, nameStr);

        //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\
        
//        NSString *clientPath= StrFormat(@"C:\\Program Files (x86)\\E定损\\客户端\\root_pic\\zhengchao_BeiHuan4S_222333_1\\222333_%@_dev.jpg", nameStr);
        
        char *fileName = (char *)[clientPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//        char *fileName = (char *)[clientPath cStringUsingEncoding:NSUTF8StringEncoding];

        
        
        DLog(@"fileName = %s, pic_name = %s",fileName, pic_name);
        
        jinglian_authed_send_picture(30, (int)jpegData.length, 0, 1, fileName, pic_name);
        
//        jinglian_charge_pic_filedata_send(0, 0, pic_name, 0);

    }];
    
    
}

/**
 * 坐席授权手机拍照
 */

- (void)takePhotoButtonClick:(nullable NSDictionary *)paramDic savedImg:(void (^)(char *url))task {
    NSLog(@"takephotoClick...");
    
    //添加了切换分辨率, 高分辨率图片压缩,
    [self changeSessionPresentPhoto];
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    //    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
          
          NSDate *date = [NSDate date];
          NSString *nameStr = [date format:@"YYYYMMddHHmmss"];
          NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
          [array replaceObjectAtIndex:0 withObject:[date format:@"YYYY/MM/dd/ HH:mm:ss"]];

          NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
          
          UIImage *waterImg = [[UIImage imageWithData:jpegData] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];

          NSData *compressData = [UIImage zipImageWithImage:waterImg];

          
          
          //save to sandbox
//          这里保存UIImage 跟保存 NSData 发送时大小能差4倍，Why？？
//          NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatFileUnderCaches]
//                                                     WithImage:waterImg
//                                                     imageName:nameStr
//                                                       imgType:@"jpg"];
          
          NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatFileUnderCaches]
                                                      WithData:compressData
                                                     imageName:nameStr
                                                       imgType:@"jpg"];
          
          if (!imgPath) return;
          
          char *pic_name = (char *)[imgPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
          //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\
          
          NSString *pathStr = [paramDic objectForKey:@"client_path"];
          NSString *clientPath= StrFormat(@"%@%@_%@_dev.jpg",pathStr, [ActivityApp shareActivityApp].reportNum, nameStr);
          //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\0011100000194246735518_20161206160339_dev.jpg
          NSLog(@"原始路径 = %@ -- clientPath = %@",pathStr, clientPath);
          char *fileName = (char *)[clientPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
          
          printf("fileName = %s, pic_name = %s ---\n",fileName, pic_name);
          
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              
              jinglian_authed_send_picture(30, (int)compressData.length, 0, 1, fileName, pic_name);
              
              NSLog(@"-----------jinglian_authed_send_picture");
          });
          
          task(fileName);
          
          
          CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                      imageDataSampleBuffer,
                                                                      kCMAttachmentMode_ShouldPropagate);
          
          ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
          if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
              //无权限
              NSLog(@"没有权限");
              return ;
          }
          ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
          
          [library writeImageToSavedPhotosAlbum:[waterImg CGImage] metadata:(__bridge id)attachments completionBlock:nil];

          [self changeSessionPresentVideo];

      }];
      
        
  });
    
    
    
//    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
//    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
//    [stillImageConnection setVideoOrientation:avcaptureOrientation];
//    //    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
//    
//    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        
//        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
//                                                                    imageDataSampleBuffer,
//                                                                    kCMAttachmentMode_ShouldPropagate);
//        
//        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
//            //无权限
//            NSLog(@"没有权限");
//            
//            return ;
//        }
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//            
//            
//            NSDate *date = [NSDate date];
//            NSString *nameStr = [date format:@"YYYYMMddHHmmss"];
//            NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
//            [array replaceObjectAtIndex:0 withObject:[date format:@"YYYY/MM/dd/ HH:mm:ss"]];
//             
//            //save to sandbox
//            UIImage *waterImg = [[UIImage imageWithData:jpegData] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
//
//            NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatFileUnderCaches]
//                                                       WithImage:[UIImage imageWithData:UIImageJPEGRepresentation(waterImg, 0.2)]
//                                                       imageName:nameStr
//                                                         imgType:@"jpg"];
//            if (!imgPath) return;
//            
//            char *pic_name = (char *)[imgPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//            //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\
//            
//            NSString *pathStr = [paramDic objectForKey:@"client_path"];
//            NSString *clientPath= StrFormat(@"%@%@_%@_dev.jpg",pathStr, [ActivityApp shareActivityApp].reportNum, nameStr);
//            //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\0011100000194246735518_20161206160339_dev.jpg
//            NSLog(@"原始路径 = %@ -- clientPath = %@",pathStr, clientPath);
//            char *fileName = (char *)[clientPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//            
//            printf("fileName = %s, pic_name = %s ---\n",fileName, pic_name);
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                jinglian_authed_send_picture(30, (int)jpegData.length, 0, 1, fileName, pic_name);
//                
//                NSLog(@"-----------jinglian_authed_send_picture");
//            });
//            
//            task(fileName);
//            
//            
//        }];
//
//    }];

}


/**
 * 坐席主动拍照
 */
- (void)clinkTakePhotoButtonClick:(nullable NSDictionary *)paramDic savedImg:(void (^)(char *url))task {
    NSLog(@"takephotoClick...");
 
    //添加了切换分辨率, 高分辨率图片压缩,
    [self changeSessionPresentPhoto];
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
 
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSDate *date = [NSDate date];
        NSString *nameStr = [date format:@"YYYYMMddHHmmss"];
        NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
        [array replaceObjectAtIndex:0 withObject:[date format:@"YYYY/MM/dd/ HH:mm:ss"]];
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *waterImg = [[UIImage imageWithData:jpegData] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
        
        NSData *compressData = [UIImage zipImageWithImage:waterImg];
        
        
        
        //save to sandbox
//      这里保存UIImage 跟保存 NSData 发送时大小能差4倍，Why？？
//      NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatFileUnderCaches]
//                                                 WithImage:waterImg
//                                                imageName:nameStr
//                                                  imgType:@"jpg"];
        
        NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatFileUnderCaches]
                                                    WithData:compressData
                                                   imageName:nameStr
                                                     imgType:@"jpg"];
        
        
        char *pic_name = (char *)[imgPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        
        //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\
        
        NSString *pathStr = [paramDic objectForKey:@"m_szClientPicFullPath"];
        //            NSString *clientPath= StrFormat(@"%@%@_%@_dev.jpg",pathStr, [ActivityApp shareActivityApp].reportNum, nameStr);
        //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\0011100000194246735518_20161206160339_dev.jpg
        
        char *fileName = (char *)[pathStr cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        
        printf("fileName = %s, pic_name = %s ---\n",fileName, pic_name);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            jinglian_charge_pic_filedata_send(0, 0, pic_name, 0);
            
            
        });
        
        task(fileName);
        
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            NSLog(@"没有权限");
            return ;
        }
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:compressData metadata:(__bridge id)attachments completionBlock:nil];
        [self changeSessionPresentVideo];
        
    }];
    
  });
    //没有切换分辨率，不是循环压缩控制大小
//    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
//    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
//    [stillImageConnection setVideoOrientation:avcaptureOrientation];
//
//    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        
//        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
//                                                                    imageDataSampleBuffer,
//                                                                    kCMAttachmentMode_ShouldPropagate);
//        
//        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
//            //无权限
//            NSLog(@"没有权限");
//            
//            return ;
//        }
//        
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//            
//            NSDate *date = [NSDate date];
//            NSString *nameStr = [date format:@"YYYYMMddHHmmss"];
//            NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
//            [array replaceObjectAtIndex:0 withObject:[date format:@"YYYY/MM/dd/ HH:mm:ss"]];
//            
//            //save to sandbox
//            UIImage *waterImg = [[UIImage imageWithData:jpegData] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
//            NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatFileUnderCaches]
//                                                       WithImage:[UIImage imageWithData:UIImageJPEGRepresentation(waterImg, 0.2)]
//                                                       imageName:nameStr
//                                                         imgType:@"jpg"];
//            char *pic_name = (char *)[imgPath cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//            
//            //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\
//            
//            NSString *pathStr = [paramDic objectForKey:@"m_szClientPicFullPath"];
////            NSString *clientPath= StrFormat(@"%@%@_%@_dev.jpg",pathStr, [ActivityApp shareActivityApp].reportNum, nameStr);
//            //D:\\Program Files (x86)\\E定损\\客户端\\root_pic\\123456_正安县_0011100000194246735518_1\\0011100000194246735518_20161206160339_dev.jpg
//            
//            char *fileName = (char *)[pathStr cStringUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//            
//            printf("fileName = %s, pic_name = %s ---\n",fileName, pic_name);
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                jinglian_charge_pic_filedata_send(0, 0, pic_name, 0);
//                
//                
//            });
//            
//            task(fileName);
//            
//            
//        }];
//        
//    }];

    
}



/** 设备捕获方向*/
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return AVCaptureVideoOrientationLandscapeRight;
}

/** 切换到拍照分辨率*/
- (void)changeSessionPresentPhoto
{

    [self.session stopRunning];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    }else {
        self.session.sessionPreset = AVCaptureSessionPreset640x480;

    }
    NSLog(@"%@",self.session.sessionPreset);
    [self.session startRunning];
}
/** 切换到视频分辨率*/
- (void)changeSessionPresentVideo
{
    [self.session stopRunning];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
    }else {
        self.session.sessionPreset = AVCaptureSessionPreset352x288;
        
    }

    NSLog(@"%@",self.session.sessionPreset);
    [self.session startRunning];

}


- (AVCaptureVideoPreviewLayer *)capturePreviewLayer {
    
    if (!_capturePreviewLayer) {
        
        //通过AVCaptureSession初始化
        AVCaptureVideoPreviewLayer *preViewLayer;
        preViewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        //设置比例为铺满全屏
        preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [preViewLayer setAffineTransform:CGAffineTransformMakeRotation(-M_PI/2)];
        
        _capturePreviewLayer = preViewLayer;

    }
    return _capturePreviewLayer;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureSessionWasInterruptedNotification object:self.session];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureSessionInterruptionEndedNotification object:self.session];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureSessionDidStartRunningNotification object:self.session];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureSessionDidStopRunningNotification object:self.session];
    
}


@end
