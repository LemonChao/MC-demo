//
//  LCWaterfallCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXScrollLabelView.h"


@interface LCWaterfallCell : UITableViewCell

@property(nonatomic, strong) TXScrollLabelView *scrollLabelView;


+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellID;


- (void)setValueWithArray:(NSArray *)titles;
@end
