//
//  TabBarController.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/31.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "LCManagerVC.h"
#import "LCBaseNavController.h"
#import "OfflineModel+CoreDataProperties.h" //上标
#import "GatherPhoto+CoreDataProperties.h"
#import "LCFindVC.h"

@interface TabBarController ()<UITabBarControllerDelegate>

@end

@implementation TabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTabBarController];
        
        self.tabBar.tintColor = MainColor;
        
    }
    return self;
}


- (void)setupTabBarController {
    /// 设置TabBar属性数组
    self.tabBarItemsAttributes =[self tabBarItemsAttributesForController];
    
    /// 设置控制器数组
    self.viewControllers =[self mpViewControllers];
    
    self.delegate = self;
//    self.moreNavigationController.navigationBarHidden = YES;
}


//控制器设置
- (NSArray *)mpViewControllers {
    
    MainViewController *main    = [[MainViewController alloc] init];
    LCFindVC           *find    = [[LCFindVC alloc] init];
    LCManagerVC        *manager = [[LCManagerVC alloc] init];
    MyViewController   *myvc    = [[MyViewController alloc] init];
    
    LCBaseNavController *nav1 = [[LCBaseNavController alloc] initWithRootViewController:main];
    LCBaseNavController *nav2 = [[LCBaseNavController alloc] initWithRootViewController:find];
    LCBaseNavController *nav3 = [[LCBaseNavController alloc] initWithRootViewController:manager];
    LCBaseNavController *nav4 = [[LCBaseNavController alloc] initWithRootViewController:myvc];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableBarValueNotification" object:nil];
    
    NSArray *viewControllers = @[nav1,
                                 nav2,
                                 nav3,
                                 nav4];
    return viewControllers;
}

//TabBar文字跟图标设置
- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"shouyemoren",
                                                 CYLTabBarItemSelectedImage : @"shouye",
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"发现",
                                                  CYLTabBarItemImage : @"findmoren",
                                                  CYLTabBarItemSelectedImage : @"find",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"管理",
                                                  CYLTabBarItemImage : @"managermoren",
                                                  CYLTabBarItemSelectedImage : @"manager",
                                                  };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"我",
                                                 CYLTabBarItemImage : @"womoren",
                                                 CYLTabBarItemSelectedImage : @"wo",
                                                 };
    
    NSArray *tabBarItemsAttributes = @[firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes];
    return tabBarItemsAttributes;
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController*)tabBarController shouldSelectViewController:(UINavigationController*)viewController {
    /// 特殊处理 - 是否需要登录
//    BOOL isBaiDuService = [viewController.topViewController isKindOfClass:[MPDiscoveryViewController class]];
//    if (isBaiDuService) {
//        NSLog(@"你点击了TabBar第二个");
//    }
    return YES;
}

#pragma mark 转屏方法重写
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.firstObject supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate{
    return self.viewControllers.firstObject.shouldAutorotate;
}



@end
