//
//  LCUserInfoCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/16.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UserInfoCell   65.0
typedef void(^Block)(NSString *editString);
@interface LCUserInfoCell : UITableViewCell

@property (nonatomic, copy) Block block;

+ (instancetype)creatCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath infoDic:(NSDictionary *)infoDic;

- (void)setValue:(NSDictionary *)infoDic indexPath:(NSIndexPath *)indexPath;
@end




//头像
@interface LCUserPortraitCell : LCUserInfoCell
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UIImageView *photoView;
@end

//手机
@interface LCUserPhoneCell : LCUserInfoCell
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UILabel *phoneLab;
@property(nonatomic, strong) UIImageView*arrowIV;
@end

//姓名
@interface LCUserNameCell : LCUserInfoCell
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UITextField *txtField;
@property(nonatomic, strong) UILabel *xiebaoLab;

@end

//地址
@interface LCUserAddressCell : LCUserInfoCell
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UIButton *addressBtn;
@end
