//
//  LCMyViewCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/31.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMyViewCell : UITableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView reuseid:(NSString *)reuseid;
@end
