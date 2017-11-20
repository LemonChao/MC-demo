//
//  LCAddBankCard.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AddBankcardType) {
    AddBankcardCerifCode = 0,
    AddBankcardNewCard,
};

@interface LCAddBankCard : UIViewController

@property(nonatomic, assign) AddBankcardType type;

@end
