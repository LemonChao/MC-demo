//
//  LCUserInfoCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/16.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCUserInfoCell.h"

@implementation LCUserInfoCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath infoDic:(NSDictionary *)infoDic{
    

    LCUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [[LCUserPortraitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
                    [cell setValue:infoDic indexPath:indexPath];
                }
                    break;
                    
                case 1:
                {
                    cell = [[LCUserPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
                    [cell setValue:infoDic indexPath:indexPath];
                }
                    break;
                    
                case 2:
                {
                    cell = [[LCUserPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
                }
                    break;
                    
                default:
                {
                    cell = [[LCUserPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
                }
                    break;
            }
            
        }
        
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [[LCUserNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
                    [cell setValue:infoDic indexPath:indexPath];
                }
                    break;
                    
                case 1:
                {
                    cell = [[LCUserAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
                    [cell setValue:infoDic indexPath:indexPath];

                }
                    break;
                    
                case 2:
                {
                    cell = [[LCUserNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
                    [cell setValue:infoDic indexPath:indexPath];
                }
                    break;
                    
                case 3:
                {
                    cell = [[LCUserNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
                    [cell setValue:infoDic indexPath:indexPath];
                }
                    break;
                    
                default:
                {
                    cell = [[LCUserPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];

                }
                    break;
            }
            
        }
    }
    return cell;
}

- (void)setValue:(NSDictionary *)infoDic indexPath:(NSIndexPath *)indexPath{
    NSLog(@"让子类继承并实现，消除警告用");
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end




///////////////////
// 头像
//////////////////
@implementation LCUserPortraitCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //label
        self.titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = kFontSize17;
        _titleLab.text = @"头 像";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        
        //imageView
        self.photoView = [LCTools createImageView:nil placeHolder:[UIImage imageNamed:@"head"] cornerRadius:AutoWHGetHeight(UserInfoCell-8)/2];
        [self addSubview:_photoView];
        
    }
    return self;
}

- (void)setValue:(NSDictionary *)infoDic indexPath:(NSIndexPath *)indexPath{
    NSString *imgUrl;
    if (infoDic != nil) {
        imgUrl = StrFormat(@"%@%@", [ActivityApp shareActivityApp].baseURL, infoDic[@"headurl"]);
        NSLog(@"imgurl%@", imgUrl);
    }

    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"head"]];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.left).offset(10);
    }];
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(AutoWHGetHeight(UserInfoCell-8), AutoWHGetHeight(UserInfoCell-8)));
        make.right.equalTo(self.right).offset(-20);

    }];
}


@end


///////////////////
// 手机 & 密码
//////////////////
@implementation LCUserPhoneCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //titleLab
        self.titleLab = [LCTools createLable:@"密 码" withFont:kFontSize17 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLab];
        
        self.phoneLab = [LCTools createLable:@"修 改" withFont:kFontSize17 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [self addSubview:_phoneLab];
        
        //arrow
        self.arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greyarrow"]];
        [self addSubview:_arrowIV];
        
    }
    return self;
}

- (void)setValue:(NSDictionary *)infoDic indexPath:(NSIndexPath *)indexPath {
    self.titleLab.text = @"手 机";
    self.phoneLab.text = infoDic[@"phone"];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.left).offset(10);
    }];
    
    [self.arrowIV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.right).offset(-15);
        make.size.equalTo(AutoCGSizeMake(7, 11));
    }];

    [self.phoneLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_arrowIV.left).offset(-10);
    }];
    
    
}

@end


///////////////////
// 姓名 住址 邀请码
//////////////////

@implementation LCUserNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //titleLab
        self.titleLab = [LCTools createLable:@"姓 名" withFont:kFontSize17 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLab];
        
        //nameLab
        self.txtField = [LCTools createTextField:kFontSize17 borderStyle:UITextBorderStyleNone withPlaceholder:@""];
        [_txtField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_txtField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_txtField addTarget:self action:@selector(completeEdit:) forControlEvents:UIControlEventEditingDidEnd];
        _txtField.backgroundColor = [UIColor yellowColor];
        [self addSubview:_txtField];
        
        //xiebaoLab
        self.xiebaoLab = [LCTools createLable:@"协保员" withFont:kFontSize17 textColor:[UIColor colorwithHex:@"5C5E66"] textAlignment:NSTextAlignmentCenter];
        _xiebaoLab.hidden = YES;
        [self addSubview:_xiebaoLab];
    }
    return self;
}

- (void)completeEdit:(UITextField *)textField {
    if (self.block) {
        self.block(textField.text);
    }
}

- (void)setValue:(NSDictionary *)infoDic indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) { //姓名
        self.txtField.text = infoDic[@"name"];
        
        _xiebaoLab.hidden = [infoDic[@"power"] intValue] ? NO : NO;

    }else if (indexPath.row == 2) { // 住址
        _titleLab.text = @"住 址";
        _txtField.text = infoDic[@"address"];
        
    }else { // 邀请码
        _titleLab.text = @"邀请码";
        _txtField.placeholder = @"协保员邀请码";
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.left).offset(10);
    }];
    
    
    [self.xiebaoLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.right).offset(-15).priorityHigh();
    }];

    [self.txtField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_titleLab.right).offset(10);
        make.right.equalTo(_xiebaoLab.left).offset(10);
    }];

    
}

@end


///////////////////
// 地区
//////////////////
@implementation LCUserAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //titleLab
        self.titleLab = [LCTools createLable:@"地 区" withFont:kFontSize17 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLab];
        
        //addressBtn
        self.addressBtn = [LCTools createWordButton:UIButtonTypeCustom title:nil titleColor:[UIColor blackColor] font:kFontSize17 bgColor:nil];
        [_addressBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addressBtn];
    }
    return self;
}

- (void)setValue:(NSDictionary *)infoDic indexPath:(NSIndexPath *)indexPath {
    NSString *areaStr = StrFormat(@"%@ %@ %@",infoDic[@"province"], infoDic[@"city"], infoDic[@"county"]);
    [_addressBtn setTitle:areaStr forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.left).offset(10);
    }];
    
    [self.addressBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_titleLab.right).offset(10);
    }];

}

- (void)clickButton:(UIButton *)button {
    
    if (self.block) {
        self.block(button.titleLabel.text);
    }
}

@end


