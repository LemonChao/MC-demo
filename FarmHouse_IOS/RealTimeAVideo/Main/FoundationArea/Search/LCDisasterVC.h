//
//  LCDisasterVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/28.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchModel.h"

typedef void(^PopBlock)();

typedef NS_ENUM(NSInteger, VCType) {
    VCTypeDisaster = 0,         //受损情况
    VCTypeRelief,               //民政救助
};

@interface LCDisasterVC : BaseViewController

@property(nonatomic, strong) LCSearchModel *model;

@property(nonatomic, copy) PopBlock popBlock;

@property(nonatomic, assign) VCType type;

@end
