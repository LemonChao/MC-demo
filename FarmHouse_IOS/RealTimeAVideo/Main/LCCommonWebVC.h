//
//  LCCommonWebVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/20.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CommonWebType) {
    CommonWebWeather = 0,       //天气
    CommonWebGame,              //游戏
    CommonWebSpecial,           //特产展示
    CommonWebHome,              //村长之家
    CommonWebInsurance,         //保险
};


@interface LCCommonWebVC : UIViewController

@property(nonatomic, assign) CommonWebType type;

@property(nonatomic, copy) NSString *webStr;

@end
