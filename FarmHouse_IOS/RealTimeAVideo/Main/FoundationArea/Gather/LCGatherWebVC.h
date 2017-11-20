//
//  LCGatherWebVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/17.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCropModel.h"

typedef NS_ENUM(NSInteger, GatherWebType) {
    GatherWebTypePlant = 0, //种植页面
    GatherWebTypeFarming,   //养殖
    GatherWebTypeEquipment, //设备
    GatherWebTypeSpecial,   //特产
};
/*
 
 所有页面分为三种情况
1	从采集端进入，参数只要userid（协保员id）
2	从用户列表进入（新增），参数---farmerid（农户id）
3	从用户列表进入（修改），参数---farmerid（农户id），id（修改数据的id）
 
*/
typedef NS_ENUM(NSInteger, GatherWebOperationType) {
    GatherWebOperationPlain = 0,
    GatherWebOperationAdd,
    GatherWebOperationUpdate,
};

typedef void(^GatherWebBackRefresh)();

@interface LCGatherWebVC : UIViewController

@property(nonatomic, assign) GatherWebType webType;

@property(nonatomic, assign) GatherWebOperationType operationType;

@property(nonatomic, strong) LCCropModel *cropModel;

@property(nonatomic, copy) GatherWebBackRefresh backRefresh;

@end
