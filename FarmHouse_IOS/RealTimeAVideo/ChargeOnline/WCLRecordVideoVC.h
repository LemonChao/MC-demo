//
//  WCLRecordVideoVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/9/3.
//  Copyright © 2016年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChargeCompleteBlock)();

@interface WCLRecordVideoVC : UIViewController

@property(nonatomic, copy) ChargeCompleteBlock completeBlock;

@property(nonatomic,strong) NSDictionary *ChargeReqDic;


@end
