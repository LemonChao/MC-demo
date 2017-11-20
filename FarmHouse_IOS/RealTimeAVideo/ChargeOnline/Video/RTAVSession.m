//
//  RTAVSession.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "RTAVSession.h"
//#import "RTAVVideoEncoder.h"
@interface RTAVSession ()//<RTAVVideoCaputreDelegate>
//@property (nonatomic,strong)RTAVVideoEncoder *videoEncoder;
@property (nonatomic,strong)RTAVVideoConfiguration *configuration;
@end

@implementation RTAVSession

- (instancetype)initWithRTAVVideoConfiguration:(RTAVVideoConfiguration *)configuration;
{
    if (self= [super init]) {
        _configuration = configuration;
    }
    return  self;
}
#pragma mark - RTAVVideoCaputreDelegate
- (void)captureOutput:(RTAVVideoCaputre *)capture pixelBuffer:(CVImageBufferRef)pixelBuffer
{
    //[self.videoEncoder encoderVideoData:pixelBuffer timeStamp:0];
}
#pragma mark - setter & getter
- (void)setRunning:(BOOL)running
{
    if (_running == running ) return;
    _running = running;
    self.videoCapture.runing = running;
}


- (RTAVVideoCaputre *)videoCapture
{
    if (!_videoCapture) {
        RTAVVideoCaputre * videoCapture = [[RTAVVideoCaputre alloc]initWithVideoConfiguration:_configuration];
        //videoCapture.delegate = self;
        _videoCapture = videoCapture;
    }
    return _videoCapture;
}
- (void)setPreView:(UIView *)preView
{
//    _preView = preView;
//    self.videoCapture.preView = preView;
    
    //拿到videoCapture.layer
    
    //设置layer属性
    self.videoCapture.capturePreviewLayer.frame = preView.bounds;
    //添加到view上
    [preView.layer insertSublayer:self.videoCapture.capturePreviewLayer atIndex:0];
}
//-(RTAVVideoEncoder *)videoEncoder
//{
//    if (!_videoEncoder) {
//        RTAVVideoEncoder * encoder = [[RTAVVideoEncoder alloc]initWithVideoConfiguration:_configuration];
//        _videoEncoder = encoder;
//    }
//    return _videoEncoder;
//}

/** 坐席主动拍照 */
- (void)takePholtoWithParam:(NSDictionary *)paramDic clientblock:(void (^)(char *path))task{
    [self.videoCapture clinkTakePhotoButtonClick:paramDic savedImg:^(char *url) {
        task(url);
    }];
}


/** 坐席授权手机拍照 */
- (void)takePholtoWithParam:(NSDictionary *)paramDic imageUrl:(void (^)(char *path))task {
    [self.videoCapture takePhotoButtonClick:paramDic savedImg:^(char *url) {
        task(url);
    }];
    
}

@end
