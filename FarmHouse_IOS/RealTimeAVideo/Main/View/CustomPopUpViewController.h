//
//  CustomPopUpViewController.h
//  ReactiveCocoa
//
//  Created by sunpeng on 2017/4/27.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPopUpViewController : UIViewController
//宽度
@property (nonatomic, assign)CGFloat width_customView;
//高度
@property (nonatomic, assign)CGFloat height_customView;
//背景视图
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
//弹出视图
@property (weak, nonatomic) IBOutlet UIView *customView;

- (void)showPopUpViewController:(UIViewController *)vc pickType:(void(^)(NSInteger pickType))block;

@end
