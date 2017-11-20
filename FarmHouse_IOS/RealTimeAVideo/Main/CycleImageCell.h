//
//  CycleImageCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleImageCell : UITableViewCell

@property (nonatomic, strong) NSArray *imgUrlArr;

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellID imagesArr:(NSArray *)imagesArr;
@end
