//
//  LCBaseNavController.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/27.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCBaseNavController.h"

@interface LCBaseNavController ()

@end

@implementation LCBaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setNavigationBarHidden:NO animated:YES];
    //barItem 以及返回箭头颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //navigationBar 颜色
    self.navigationBar.barTintColor = MainColor;
    self.navigationBar.shadowImage = nil;
    //半透明渲染效果
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];

}


//self.topViewController是当前导航显示的UIViewController，这样就可以控制每个UIViewController所支持的方向啦！
-(BOOL)shouldAutorotate{
    
    return [self.topViewController shouldAutorotate];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.topViewController supportedInterfaceOrientations];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
