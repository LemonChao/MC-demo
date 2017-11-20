//
//  LCNonghuInfoVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/5.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCNonghuModel.h"

typedef void(^DeletaRefresh)();

@interface LCNonghuInfoVC : UIViewController

/** 户主modle */
@property(nonatomic, strong) LCHouseHoldModel *houseHold;

@property(nonatomic, copy) DeletaRefresh refreshBlock;

/** 是否可以越级返回 */
@property(nonatomic, assign) BOOL superBack;

@end
