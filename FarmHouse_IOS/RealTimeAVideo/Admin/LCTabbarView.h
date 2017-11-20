//
//  LCTabbarView.h
//  标签栏视图
//
//  Created by Lemon on 17/2/22.
//  Copyright © 2017年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HYScreenW [UIScreen mainScreen].bounds.size.width
#define HYScreenH [UIScreen mainScreen].bounds.size.height

@interface LCTabbarView : UIView


/**
 *  添加一个view
 */
- (void)addSubItemWithView:(UIView *)view title:(NSString *)title;


@end
