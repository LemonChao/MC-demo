//
//  LCNewsCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFarmNewsModel.h"

#define NewsCellH   75

@interface LCNewsCell : UITableViewCell

@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellID;

- (void)setValueWithModel:(LCFarmNewsModel *)model;

@end
