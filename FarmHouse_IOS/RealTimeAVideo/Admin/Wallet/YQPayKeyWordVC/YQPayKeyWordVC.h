//
//  YQPayKeyWordVC.h
//  Youqun
//
//  Created by 王崇磊 on 16/6/1.
//  Copyright © 2016年 W_C__L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQInputPayKeyWordView.h"
#import "YQSelectPayStyleView.h"

@interface YQPayKeyWordVC : UIViewController

@property (strong, nonatomic) YQInputPayKeyWordView *keyWordView;
@property (strong, nonatomic) YQSelectPayStyleView *selectPayStyleView;

- (void)showInViewController:(UIViewController *)vc;
- (IBAction)disMissAction:(UIButton *)sender;
@end
