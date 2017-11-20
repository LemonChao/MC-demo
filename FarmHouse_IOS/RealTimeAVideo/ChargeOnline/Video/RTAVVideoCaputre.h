//
//  RTAVVideoCaputre.h
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import AVFoundation;

@class RTAVVideoCaputre,RTAVVideoConfiguration;
@protocol RTAVVideoCaputreDelegate <NSObject>

- (void)captureOutput:(nullable RTAVVideoCaputre *)capture pixelBuffer:(nullable CVImageBufferRef)pixelBuffer;

@end

@interface RTAVVideoCaputre : NSObject
@property (nonatomic,assign)BOOL runing;
@property (nonatomic,strong, nullable)UIView *preView;
@property (nonatomic,weak,nullable)id <RTAVVideoCaputreDelegate> delegate;

@property (nonatomic,strong,nullable) AVCaptureVideoPreviewLayer *capturePreviewLayer;


/** 点击拍照*/
- (void)takePhotoButtonClick:(NSDictionary *)paramDic;

- (void)takePhotoButtonClick:(nullable NSDictionary *)paramDic savedImg:(void (^)(char *url))task;

/** 坐席拍拍 */
- (void)clinkTakePhotoButtonClick:(nullable NSDictionary *)paramDic savedImg:(void (^)(char *url))task;

- (nullable instancetype)initWithVideoConfiguration:(nullable RTAVVideoConfiguration *)configuration;

#pragma mark - 拉伸镜头
- (void)tensileLes:(CGFloat)zoomValue;

#pragma mark - 打开关闭闪光灯
- (void)openFlashWith:(UIButton *)sender;

#pragma mark - 自动模式
- (void)setFocusWithNeed:(BOOL)isSeleted;

#pragma mark - 微距模式改变焦点位置
- (void)changeFocusWith:(CGPoint)point;

@end
