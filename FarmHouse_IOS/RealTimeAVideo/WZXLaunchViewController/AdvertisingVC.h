//
//  AdvertisingVC.h
//  E-VillageUI
//
//  Created by Lemon on 16/11/9.
//  Copyright © 2016年 LemonChao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WebBack)();

@interface AdvertisingVC : UIViewController

@property (nonatomic,copy)NSString *urlStr;

@property (nonatomic,assign)int AppDelegateSele;

@property (nonatomic,copy) WebBack WebBack;

@end
