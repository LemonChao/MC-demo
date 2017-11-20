//
//  ViewController.h
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/2.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFarmNewsModel.h"

typedef NS_ENUM(NSInteger, ViewControllerState) {
    ViewControllerState_Online,
    ViewControllerState_Offline,
    ViewControllerState_ChargeWait,
};

@interface ViewController : UIViewController

@property(nonatomic, strong) LCHouseholderModel *hhModel;

@property(nonatomic, copy) NSString *reportNum;
@end

