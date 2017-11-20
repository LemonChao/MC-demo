//
//  LCChangeDetailCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCChangeDetailCell.h"

@interface LCChangeDetailCell ()

@property(nonatomic, strong) UILabel *withdrawLab;

@property(nonatomic, strong) UILabel *timeLab;

@property(nonatomic, strong) UILabel *countLab;

@end

@implementation LCChangeDetailCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseid:(NSString *)reuseid {
    
    LCChangeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[LCChangeDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIView *bgView = [[UIView alloc] init];
        [self addSubview:bgView];
        
        _withdrawLab = [LCTools createLable:@"提现" withFont:kFontSize16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _withdrawLab.numberOfLines = 1;
//        _withdrawLab.backgroundColor = [UIColor cyanColor];
        [bgView addSubview:_withdrawLab];
        
        _timeLab = [LCTools createLable:@"2017-04-26 18:45" withFont:kFontSize15 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
        _timeLab.numberOfLines = 1;
//        _timeLab.backgroundColor = [UIColor cyanColor];
        [bgView addSubview:_timeLab];

        _countLab = [LCTools createLable:@"- 135.00" withFont:kFontSize16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight];
        _countLab.numberOfLines = 1;
//        _countLab.backgroundColor = [UIColor cyanColor];
        [self addSubview:_countLab];
        
        
        [_countLab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
        }];
        
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.height.equalTo(self.height).multipliedBy(0.61);
            make.right.equalTo(_countLab.left).offset(10);
        }];
        
        [_withdrawLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView);
            make.top.equalTo(bgView);
        }];
        
        [_timeLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView);
            make.bottom.equalTo(bgView);
        }];
        

    }
    return self;
}

- (void)setValueWithModel:(LCTradRecordModel *)model {
    
    if ([model.type isEqualToString:@"充值"]) {
        _countLab.text = [NSString stringWithFormat:@"+ %@", model.monery];
    }else if ([model.type isEqualToString:@"提取"]){
        _countLab.text = [NSString stringWithFormat:@"- %@", model.monery];
    }
    _withdrawLab.text = model.type;
    _timeLab.text = model.time;
}


@end
