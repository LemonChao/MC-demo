//
//  LCNullView.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/25.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCNullView.h"

@interface LCNullView ()


@end

@implementation LCNullView



- (instancetype)initWithFrame:(CGRect)frame imgString:(NSString *)imgStr labTitleString:(NSString *)titleStr {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = BGColor;

        self.imgView = [[UIImageView alloc] init];
        self.imgView.image = [UIImage imageNamed:imgStr];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];

        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(AutoWHGetWidth(150), AutoWHGetWidth(150)));
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.top).offset(AutoWHGetHeight(125));
        }];

        if (titleStr) {
            self.titleLab = [[UILabel alloc] init];
            _titleLab.font = kFontSize18;
            _titleLab.textColor = [UIColor colorwithHexString:@"#999999"];
            _titleLab.textAlignment = NSTextAlignmentCenter;
            _titleLab.numberOfLines = 0;
            _titleLab.text = titleStr;
            
            [self addSubview:_titleLab];
            
            [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(SCREEN_WIDTH, 35));
                make.top.equalTo(_imgView.bottom).offset(40);
                make.left.equalTo(self).offset(0);
            }];
        }
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imgString:(NSString *)imgStr labTitle:(NSString *)titleStr buttonTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat  width = self.frame.size.width;
        
        self.imgView = [[UIImageView alloc] init];
        self.imgView.image = [UIImage imageNamed:imgStr];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        
        self.titleLab = [[UILabel alloc] init];
        _titleLab.font = kFontSize16;
        _titleLab.textColor = [UIColor colorwithHexString:@"#999999"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.numberOfLines = 0;
        _titleLab.text = titleStr;
        [self addSubview:_titleLab];
        
        self.desLab = [[UILabel alloc] init];
        _desLab.font = kFontSize16;
        _desLab.textColor = [UIColor colorwithHexString:@"#999999"];
        _desLab.textAlignment = NSTextAlignmentCenter;
        _desLab.numberOfLines = 0;
        _desLab.text = @"";
        [self addSubview:_desLab];

        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(AutoWHGetWidth(150), AutoWHGetWidth(150)));
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.top).offset(AutoWHGetHeight(125));
        }];
        
        [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH, 35));
            make.top.equalTo(_imgView.bottom).offset(40);
            make.left.equalTo(self).offset(0);
        }];
        
        [self.desLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLab.bottom).offset(5);
            make.left.equalTo(self.left);
            make.right.equalTo(self.right);
            make.height.equalTo(35);
        }];
        
        if (title) {
            UIButton *button = [LCTools createWordButton:UIButtonTypeCustom title:title titleColor:[UIColor whiteColor] font:kFontSize15 bgColor:MainColor cornerRadius:5.0f borderColor:nil borderWidth:0];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(width*0.65, AutoWHGetHeight(40)));
                make.bottom.equalTo(self.bottom).offset(-40);
                make.centerX.equalTo(self.centerX);
            }];
        }
        
    }
    return self;
}




- (void)buttonAction:(UIButton *)button {
    if (_block) {
        _block();
    }
}


@end
