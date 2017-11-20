//
//  BadgeButton.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "BadgeButton.h"

@interface BadgeButton ()

/** 右上小红点 */
@property(nonatomic, strong) UIButton *redPoint;

@end



@implementation BadgeButton


- (instancetype)init
{
    self = [super init];
    if (self) {
        _redPoint = [LCTools createWordButton:UIButtonTypeCustom title:nil titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:10] bgColor:[UIColor redColor] cornerRadius:6 borderColor:nil borderWidth:0];
        self.badgeValue = nil;
        [self addSubview:_redPoint];
        
        [_redPoint makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.equalTo(12);
        }];

    }
    return self;
}


- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    if ([badgeValue intValue] <= 0 || badgeValue == nil) {
        _redPoint.hidden = YES;
        return;
    };
    
    _redPoint.hidden = NO;
    [_redPoint setTitle:badgeValue forState:UIControlStateNormal];
    
    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:_redPoint.titleLabel.font, NSKernAttributeName:@(1)}];
    
    CGFloat width = size.width >= 12 ? size.width : 12;
    
    [_redPoint updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.equalTo(12);
        make.width.equalTo(width);
    }];
    
}


@end
