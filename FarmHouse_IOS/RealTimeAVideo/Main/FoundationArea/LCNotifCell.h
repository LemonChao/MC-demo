//
//  LCNotifCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/24.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationNews+CoreDataProperties.h"

#define NtfCellH  AutoWHGetHeight(100)

@interface LCNotifCell : UITableViewCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView;

- (void)setValueWithDataDictionary:(NotificationNews *)model;

@end
