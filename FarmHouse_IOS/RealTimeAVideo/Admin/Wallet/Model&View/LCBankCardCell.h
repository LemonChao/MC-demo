//
//  LCBankCardCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCWalletModel.h"

@interface LCBankCardCell : UITableViewCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseid:(NSString *)reuseid;

- (void)setValueWith:(LCBankCardModel *)model;

@end
