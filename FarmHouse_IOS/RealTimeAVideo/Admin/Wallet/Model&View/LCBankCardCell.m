//
//  LCBankCardCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCBankCardCell.h"

@interface LCBankCardCell ()

@property(nonatomic, strong) UIImageView *bgImgView;

@property(nonatomic, strong) UILabel *bankNameLab;

@property(nonatomic, strong) UILabel *cardNumLab;

@end

@implementation LCBankCardCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseid:(NSString *)reuseid {
    
    LCBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[LCBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_deposit_card"]];
        [self addSubview:_bgImgView];
        
        _bankNameLab = [LCTools createLable:nil withFont:kFontSize16 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
        [_bgImgView addSubview:_bankNameLab];
        
        _cardNumLab = [LCTools createLable:nil withFont:kFontSize15 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight];
        [_bgImgView addSubview:_cardNumLab];
        
        CGFloat padding = 10;
        
        [_bgImgView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
        
        [_bankNameLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(padding);
            make.left.equalTo(25);
        }];
        
        [_cardNumLab makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bgImgView).offset(-padding);
            make.bottom.equalTo(_bgImgView).offset(-15);
        }];
        
    }
    
    return self;
}

- (void)setValueWith:(LCBankCardModel *)model {
    _bankNameLab.text = model.bank;
    
    NSString *bankNum = [NSString stringWithFormat:@"**** **** **** %@", [model.banknumber substringFromIndex:model.banknumber.length -4]];
    _cardNumLab.text = bankNum;
}

@end
