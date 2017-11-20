//
//  LCShopingWebVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/13.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FindColumnWebType) {
    FindColumnWebShoping = 0,       //购物
    FindColumnWebGame,              //游戏
};


@interface LCShopingWebVC : UIViewController

@property(nonatomic, assign) FindColumnWebType type;

@end
