//
//  MyAccessoryView.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/31.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "MyAccessoryView.h"

@interface MyAccessoryView ()

@property(nonatomic, strong) UIButton *numButton;

@property(nonatomic, strong) UIImageView *arrowImg;

@end

@implementation MyAccessoryView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        _numButton = [LCTools createWordButton:UIButtonTypeCustom title:nil titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13] bgColor:[UIColor redColor] cornerRadius:AutoWHGetHeight(15)/2.0f borderColor:nil borderWidth:0.f];
        _numButton.backgroundColor = [UIColor redColor];
        [self addSubview:_numButton];
        
        _arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greyarrow"]];
//        _arrowImg.backgroundColor = [UIColor cyanColor];
        [self addSubview:_arrowImg];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _numButton.hidden = (title == nil) ? YES : NO;
    [_numButton setTitle:title forState:UIControlStateNormal];
    [_numButton setTitle:title forState:UIControlStateSelected];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = [_numButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:kFontSize15}].width;
    DLog(@"btn frame %@  -- %f  %f", NSStringFromCGRect(_numButton.frame), AutoWHGetHeight(15), width);
    
    if (width <= AutoWHGetHeight(15)) {
        width = AutoWHGetHeight(15);
    }
    
    [_arrowImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.greaterThanOrEqualTo(self.right).offset(0);
        make.size.equalTo(AutoCGSizeMake(10.5, 16.5));
    }];
    
    [_numButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.lessThanOrEqualTo(_arrowImg.left).offset(0);
        make.size.equalTo(CGSizeMake(width, AutoWHGetHeight(15)));
    }];

    
}


@end
