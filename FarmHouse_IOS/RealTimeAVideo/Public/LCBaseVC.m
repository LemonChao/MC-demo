//
//  LCBaseVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/28.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCBaseVC.h"

@interface LCBaseVC ()

@end

@implementation LCBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}




@end
