//
//  LCInputKeyWordView.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCInputKeyWordView.h"

@implementation LCInputKeyWordView

+ (instancetype)initFromeNibWithFrame:(CGRect)frame {
    LCInputKeyWordView *nibView = [[[UINib nibWithNibName:@"LCInputKeyWordView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    nibView.frame = frame;
    return nibView;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _titleLab = [LCTools createLable:@"输入验证码，以验证身份" withFont:kFontSize12 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
//        [self addSubview:_titleLab];
//        
//        _passWordView = [[WCLPassWordView alloc] init];
//        [self addSubview:_passWordView];
//        
//        [_titleLab makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.left.equalTo(self);
//            make.right.equalTo(self);
//            make.bottom.equalTo(_passWordView.top);
//        }];
//        
//        [_passWordView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self);
//            make.right.equalTo(self);
//            make.bottom.equalTo(self);
//            make.height.equalTo(72);
//        }];
//        
//        [self layoutIfNeeded];
//    }
//    return self;
//}


@end
