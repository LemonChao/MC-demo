//
//  EWLTabBar.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/10.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "EWLTabBar.h"

@interface EWLTabBar ()
@end

@implementation EWLTabBar
{
    NSMutableArray *contentMArray;
    UIButton       *currentBtn;
}


- (instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray *)contentArray
{
    self = [super initWithFrame:frame];

    if (self) {
        if (contentArray == nil || contentArray.count == 0) return self;
        self.backgroundColor = [UIColor whiteColor];
        
        contentMArray = [NSMutableArray array];
        [contentMArray setArray:contentArray];
        
        int i = 0;
        for (NSDictionary *dict in contentMArray) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(frame.size.width / contentMArray.count *i , 0,frame.size.width / contentMArray.count , frame.size.height);
            [button addTarget:self action:@selector(mainStyleTabBarItem:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            button.tag = 1000+i;
            if (i == 0) {
                button.selected = YES;
                currentBtn = button;
            }
            [button setImage:[dict objectForKey:NORMAL_IMAGE] forState:UIControlStateNormal];
            [button setImage:[dict objectForKey:SELECTED_IMAGE] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorwithHex:@"0x8e8f8f"] forState:UIControlStateNormal];
            [button setTitleColor:MainColor forState:UIControlStateSelected];
            [button setTitle:[dict objectForKey:ITEM_TITLE] forState:UIControlStateNormal];//
            [button setImagePosition:ZXImagePositionTop spacing:3];
            [self addSubview:button];
            i++;
        }

    }
    return self;
    
}




- (instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray *)contentArray style:(EWLTabBatStyle)style
{
    self = [super initWithFrame:frame];
    
    if (self) {
        if (contentArray == nil || contentArray.count == 0) return self;
        self.backgroundColor = [UIColor whiteColor];
        contentMArray = [NSMutableArray array];
        [contentMArray setArray:contentArray];
        
        int i = 0;
        for (NSDictionary *dict in contentMArray) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(frame.size.width / contentMArray.count *i , 0,frame.size.width / contentMArray.count , frame.size.height);
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            button.tag = 1000+i;
            if (i == 0) {
                button.selected = YES;
                currentBtn = button;
            }
            [button setImage:[dict objectForKey:NORMAL_IMAGE] forState:UIControlStateNormal];
            [button setImage:[dict objectForKey:SELECTED_IMAGE] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorwithHex:@"0x8e8f8f"] forState:UIControlStateNormal];
            [button setTitleColor:MainColor forState:UIControlStateSelected];
            [button setTitle:[dict objectForKey:ITEM_TITLE] forState:UIControlStateNormal];//
            [button setImagePosition:ZXImagePositionTop spacing:3];
            [self addSubview:button];
            i++;
            
            
            switch (style) {
                case EWLTabBatStyleMain:
                {
                    [button addTarget:self action:@selector(mainStyleTabBarItem:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                case EWLTabBatStylePlain:
                {
                    [button addTarget:self action:@selector(plainStyleTabBarItem:) forControlEvents:UIControlEventTouchUpInside];
                    [button setImage:[dict objectForKey:NORMAL_IMAGE] forState:UIControlStateSelected];
                    [button setTitleColor:[UIColor colorwithHex:@"0x8e8f8f"] forState:UIControlStateSelected];
                }
                    break;
                    
                default:
                    break;
            }

        }
        
    }
    return self;
    

}



/**
 离线定损tabBar plainStyle
 重复点击有响应
 */
- (void)plainStyleTabBarItem:(UIButton *)button
{
//    if (currentBtn == button) return;
    
    button.selected = YES;
    currentBtn.selected = NO;
    currentBtn = button;
    if (_delegate && [_delegate respondsToSelector:@selector(tabBar:didSelectedIndex:)]) {
        [_delegate tabBar:self didSelectedIndex:button.tag - 1000];
    }
    
}


/**
 主页tableBar mainStyle
 重复点击无响应
 */
- (void)mainStyleTabBarItem:(UIButton *)button
{
    if (currentBtn == button) return;
    
    button.selected = YES;
    currentBtn.selected = NO;
    currentBtn = button;
    if (_delegate && [_delegate respondsToSelector:@selector(tabBar:didSelectedIndex:)]) {
        [_delegate tabBar:self didSelectedIndex:button.tag - 1000];
    }
    
}



@end
