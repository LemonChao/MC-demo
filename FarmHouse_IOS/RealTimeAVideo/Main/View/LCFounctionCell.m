//
//  LCFounctionCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/19.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCFounctionCell.h"

@implementation LCFounctionCell

- (IBAction)functionButtonClick:(UIButton *)sender {
    if (_buttonTypeBlock) {
        _buttonTypeBlock(sender.tag);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView.subviews enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setImagePosition:ZXImagePositionTop spacing:10];
    }];
    
}


@end
