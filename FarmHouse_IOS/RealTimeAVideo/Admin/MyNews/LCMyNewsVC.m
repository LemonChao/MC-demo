
//
//  LCMyNewsVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/15.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCMyNewsVC.h"
#import "LCNullView.h"

@interface LCMyNewsVC ()

@end

@implementation LCMyNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *nullView = [[LCNullView alloc] initWithFrame:self.view.bounds imgString:@"no_network" labTitleString:@"暂无任何新消息哦！！"];
    [self.view addSubview:nullView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
