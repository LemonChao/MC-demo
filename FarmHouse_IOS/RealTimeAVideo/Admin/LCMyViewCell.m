//
//  LCMyViewCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/31.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCMyViewCell.h"

@interface LCMyViewCell ()

@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UILabel *titleLab;



@end

@implementation LCMyViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView reuseid:(NSString *)reuseid {
    LCMyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[LCMyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


@end
