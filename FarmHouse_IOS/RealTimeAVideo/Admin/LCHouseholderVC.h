//
//  LCHouseholderVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/26.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFarmNewsModel.h"


typedef void(^ChooseModelBlock)(LCHouseholderModel *chooseModel);

@interface LCHouseholderVC : LCBaseVC

//添加接受属性
@property (nonatomic, assign)BOOL isChoose;

//传回选择界面的model
@property (nonatomic, copy)ChooseModelBlock chooseBlcok;

@end
