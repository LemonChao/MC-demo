//
//  LCNonghuWebVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/6.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCNonghuModel.h"

typedef void(^RefreshBlock)();

typedef NS_ENUM(NSInteger, NonghuWebType) {
    NonghuAddHouseHold = 0,         //添加户主
    NonghuAddHouseMember,           //添加家庭成员
    NonghuAddHouseInfo,             //添加房屋信息
    NonghuUpdateHouseHold,          //修改户主信息
    NonghuUpdateHouseMember,        //修改家庭成员信息
    NonghuUpdateHouseInfo,          //修改房屋信息
};

@interface LCNonghuWebVC : UIViewController

@property(nonatomic, assign) NonghuWebType webType;

@property(nonatomic, strong) LCHouseHoldModel *houseHoldModel;

@property(nonatomic, strong) LCHouseMemberModel *houseMemModel;

@property(nonatomic, strong) LCHouseInfoModel *houseInfoModel;


@property(nonatomic, copy) RefreshBlock refreshBlock;

@end
