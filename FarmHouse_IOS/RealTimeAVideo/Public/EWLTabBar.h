//
//  EWLTabBar.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/10.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EWLTabBatStyle) {
    EWLTabBatStyleMain,         //rootVC
    EWLTabBatStylePlain,        //color unchanged
};


@protocol EWLTabBarDelegate;
@interface EWLTabBar : UIView

@property (nonatomic, weak) id<EWLTabBarDelegate> delegate;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign) NSInteger currentSelected;

/** 字体选中颜色 */
@property (nonatomic, strong) UIColor *selectColor;

- (instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray *)contentArray;

- (instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray *)contentArray style:(EWLTabBatStyle)style;


@end


@protocol EWLTabBarDelegate <NSObject>
@optional
- (void)tabBar:(EWLTabBar *)tabBar didSelectedIndex:(NSInteger )index;
@end
