//
//  LCColumnCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCColumnCell.h"
#import "UIButton+WebCache.h"

@interface LCColumnCell ()
@end

@implementation LCColumnCell

- (IBAction)columnButtonClick:(UIButton *)sender {
    if (_buttonTypeBlock) {
        _buttonTypeBlock(sender.tag);
    }
}

- (void)setValueWithModle:(ColumnModel *)model {
    
}


- (void)setValueWithArray:(NSMutableArray *)array {
    
    
    for (UIButton *subButton in self.contentView.subviews) {
        
        ColumnModel *model = array[subButton.tag-1000];
        
        [subButton setTitle:model.type forState:UIControlStateNormal];
        [subButton sd_setImageWithURL:[NSURL URLWithString:model.imageurl] forState:UIControlStateNormal];
    }
    
    
    
}


@end
