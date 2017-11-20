//
//  LCWithdrawVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteRefresh)();

@interface LCWithdrawVC : UIViewController

@property(nonatomic, strong) NSString *totalAmout;

@property(nonatomic, copy) CompleteRefresh refreshBlock;

@end
