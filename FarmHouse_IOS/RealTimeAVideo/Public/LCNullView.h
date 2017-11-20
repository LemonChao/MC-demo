//
//  LCNullView.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/25.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^buttonBlock)();

@interface LCNullView : UIView


/** 空白占位图片 */
@property(nonatomic, strong) UIImageView *imgView;

/** 标题1 */
@property(nonatomic, strong) UILabel *titleLab;

/** 标题2 */
@property(nonatomic, strong) UILabel *desLab;

/** button 的block */
@property(nonatomic, copy)buttonBlock block;

/** init null View */
- (instancetype)initWithFrame:(CGRect)frame imgString:(NSString *)imgStr labTitleString:(NSString *)titleStr;


/** 定损等待页面 */
- (instancetype)initWithFrame:(CGRect)frame imgString:(NSString *)imgStr labTitle:(NSString *)titleStr buttonTitle:(NSString *)title;

@end
