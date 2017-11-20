//
//  RootViewController.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/10.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "RootViewController.h"
#import "LCBaseNavController.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "EWLTabBar.h"


@interface RootViewController ()<EWLTabBarDelegate>
{
    EWLTabBar *ewlTabBar;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Y起点在导航条下面，无论导航是不是半透明
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    MainViewController *vc1 = [[MainViewController alloc] init];
    MyViewController   *vc2   = [[MyViewController alloc] init];
    
    LCBaseNavController *nav1 = [[LCBaseNavController alloc] initWithRootViewController:vc1];
    LCBaseNavController *nav2 = [[LCBaseNavController alloc] initWithRootViewController:vc2];
    
    self.viewControllers = @[nav1,
                             nav2];
    
    NSDictionary *dict1 = @{NORMAL_IMAGE:[UIImage imageNamed:@"shouyemoren"],
                          SELECTED_IMAGE:[UIImage imageNamed:@"shouye"],
                              ITEM_TITLE:@"首页"};
    NSDictionary *dict2 = @{NORMAL_IMAGE:[UIImage imageNamed:@"womoren"],
                          SELECTED_IMAGE:[UIImage imageNamed:@"wo"],
                              ITEM_TITLE:@"我"};
    
    NSArray *contentArr = @[dict1,
                            dict2];
    
    ewlTabBar = [[EWLTabBar alloc] initWithFrame:self.tabBar.bounds contentArray:contentArr style:EWLTabBatStyleMain];
    ewlTabBar.delegate = self;
    [self.tabBar addSubview:ewlTabBar];
    
    
}

#pragma mark-  **EWLTabBarDelegate Method

- (void)tabBar:(EWLTabBar *)tabBar didSelectedIndex:(NSInteger)index
{
    [self setSelectedIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- ZWTabBarDelegate


#pragma mark 转屏方法重写
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.firstObject supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate{
    return self.viewControllers.firstObject.shouldAutorotate;
}

@end
