//
//  StepProgressView.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StepProgressStyle) {
    StepProgressAverage,        //平均分布，默认
    StepProgressExtreme,        //上下极端分布
};

@interface StepProgressView : UIView

@property (nonatomic,assign) NSInteger stepIndex;


+(instancetype)progressView:(CGRect)frame titleArray:(NSArray *)titleArray style:(StepProgressStyle)style;

@end
