//
//  LCWaterfallCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCWaterfallCell.h"


@interface LCWaterfallCell ()

@property(nonatomic, strong) UIImageView *notifImg;

@property(nonatomic, strong) UIView *lineView;


@end



@implementation LCWaterfallCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellID {
    LCWaterfallCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[LCWaterfallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    return cell;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _notifImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notif_trumpet_red"]];
        [self addSubview:_notifImg];
        
        _lineView = [LCTools createLineView:[UIColor lightGrayColor]];
        [self addSubview:_lineView];
        
        _scrollLabelView = [TXScrollLabelView scrollWithTextArray:nil type:TXScrollLabelViewTypeLeftRight velocity:1.0 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
        _scrollLabelView.textAlignment = NSTextAlignmentLeft;
        _scrollLabelView.frame = CGRectMake(0, 0, 200, 40);
        _scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
        _scrollLabelView.scrollSpace = 5;
        _scrollLabelView.font = [UIFont systemFontOfSize:15];
        _scrollLabelView.scrollTitleColor = [UIColor blackColor];
        _scrollLabelView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_scrollLabelView];

    }
    
    return self;
}

- (void)setValueWithArray:(NSArray *)titles {
    
    [_scrollLabelView startScrollingWithArray:titles];

}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10.0f;
    
    [_notifImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(padding);
        make.left.equalTo(self).offset(padding);
        make.bottom.equalTo(self).offset(-padding);
        make.width.equalTo(_notifImg.height);
    }];
    
    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(padding/2);
        make.bottom.equalTo(self).offset(-padding/2);
        make.left.equalTo(_notifImg.right).offset(padding);
        make.width.equalTo(0.5);
    }];
    
    [_scrollLabelView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(_lineView.right).offset(5);
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(5);
    }];
    

    
}

@end
