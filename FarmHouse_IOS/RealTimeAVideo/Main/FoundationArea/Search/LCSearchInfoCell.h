//
//  LCSearchInfoCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchModel.h"

@class LCSearchInfoCell;
@protocol InfoCellDelegate <NSObject>

- (void)infoCell:(LCSearchInfoCell *)cell topEditButtonClick:(UIButton *)button;

- (void)infoCell:(LCSearchInfoCell *)cell bottomEditButtonClick:(UIButton *)button;

@end

typedef void (^PicButtonBlock)();
@interface LCSearchInfoCell : UITableViewCell

@property(nonatomic, copy)PicButtonBlock picBtnBlock;

@property(nonatomic, weak)id<InfoCellDelegate> delegate;

+ (instancetype)creatWithTableView:(UITableView *)tableView reuseidentifier:(NSString *)reuseidentifier;


- (void)setValueWithModel:(LCDisasterModel *)model;

@end


@interface LCSearchHeader : UIView


@property(nonatomic, assign) NSInteger index;

- (void)setValueWithModel:(LCSearchModel *)model;

@end
