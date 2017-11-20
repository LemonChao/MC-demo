//
//  RTAVSession.h
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RTAVVideoCaputre.h"

@class RTAVVideoConfiguration;
@interface RTAVSession : NSObject
@property (nonatomic,strong)RTAVVideoCaputre *videoCapture;
@property (nonatomic,assign)BOOL running;
@property (nonatomic,strong)UIView * preView;

- (instancetype)initWithRTAVVideoConfiguration:(RTAVVideoConfiguration *)configuration;

- (void)takePholtoWithParam:(NSDictionary *)paramDic clientblock:(void (^)(char *path))task;
- (void)takePholtoWithParam:(NSDictionary *)paramDic imageUrl:(void (^)(char *path))task;
@end
