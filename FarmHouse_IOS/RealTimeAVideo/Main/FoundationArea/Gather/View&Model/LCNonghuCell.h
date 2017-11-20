//
//  LCNonghuCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/5.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCNonghuModel.h"


@interface LCNonghuCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView reuseid:(NSString *)reuseid;

- (void)setValueWithModel:(LCHouseHoldModel *)model;

@end


/// 





/// 表头显示户主
@interface LCNonghuHead : UIView

- (void)setHeadView;

@end
