//
//  LCSearchListCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/20.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCSearchModel;

#define SeaListCellH AutoWHGetHeight(120)

@interface LCSearchListCell : UITableViewCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellID;

- (void)setValueWithModel:(LCSearchModel *)model;

@end
