//
//  LCNotifCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/24.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCNotifCell.h"

static NSString *cellID = @"notifCell";

@interface LCNotifCell ()
{
    CGFloat levelWidth;
    CGFloat timeWidth;
}

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIView *subBGView;
@property (nonatomic,strong) UILabel *levelLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *companyLab;

@end

@implementation LCNotifCell


+ (instancetype)creatCellWithTableView:(UITableView *)tableView {
    LCNotifCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[LCNotifCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //UIView
        self.backgroundColor = TabBGColor;
        self.bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.borderWidth = 0.75;
        _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        //img
        self.imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"notification_non_read"];
        [self.bgView addSubview:_imgView];
        
        //subBG
        self.subBGView = [[UIView alloc] init];
//        _subBGView.backgroundColor = [UIColor yellowColor];
        [self.bgView addSubview:_subBGView];
        
        //levelLab 水平抗拉
        self.levelLab = [[UILabel alloc] init];
        _levelLab.text = @"【紧急】";
//        _levelLab.backgroundColor = [UIColor redColor];
        _levelLab.textColor = [UIColor lightGrayColor];
        _levelLab.font = kFontSize14;
        [self.subBGView addSubview:_levelLab];

        //title
        self.titleLab = [[UILabel alloc] init];
        _titleLab.text = @"到底是范德萨";
//        _titleLab.backgroundColor = [UIColor cyanColor];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = kFontSize16;
        [_titleLab setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLab setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [self.subBGView addSubview:_titleLab];
        
        //timeLab
        self.timeLab = [[UILabel alloc] init];
        _timeLab.text = @"11-23 14:34";
//        _timeLab.backgroundColor = [UIColor purpleColor];
        _timeLab.textColor = [UIColor lightGrayColor];
        _timeLab.font = kFontSize14;
        [self.subBGView addSubview:_timeLab];
        
        self.companyLab = [[UILabel alloc] init];
//        _companyLab.backgroundColor = [UIColor cyanColor];
        _companyLab.text = @"易万联";
        _companyLab.textColor = [UIColor blackColor];
        _companyLab.font = kFontSize16;
        [self.bgView addSubview:_companyLab];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"width:%f",levelWidth++);
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(20, 10, 0, 10));
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(10);
        make.left.equalTo(self.bgView.left).offset(10);
        make.size.equalTo(AutoWHGetWidth(20));
    }];
    
    [self.subBGView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(10);
        make.right.equalTo(self.bgView).offset(-10);
        make.left.equalTo(self.imgView.right).offset(3);
        make.height.equalTo(AutoWHGetHeight(30));
    }];
    
    [self.levelLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subBGView).offset(0);
        make.left.equalTo(self.subBGView).offset(0);
        make.height.equalTo(self.subBGView.height);
    }];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_levelLab);
        make.height.equalTo(_levelLab);
        make.left.equalTo(_levelLab.right).offset(0);
    }];
    
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_levelLab);
        make.height.equalTo(_levelLab);
        make.left.equalTo(_titleLab.right).offset(1);
        make.right.equalTo(_subBGView.right).offset(0);
    }];
    
    [self.companyLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subBGView.bottom).offset(10);
        make.right.equalTo(_subBGView.right).offset(0);
    }];
}

- (void)setValueWithDataDictionary:(NotificationNews *)model {
    
    self.levelLab.text = [NSString stringWithFormat:@"【%@】", model.type];
    
    self.titleLab.text = model.title;
    
    self.timeLab.text = model.time;
    
    self.imgView.image = model.isRead ? [UIImage imageNamed:@"notification_has_read"] : [UIImage imageNamed:@"notification_non_read"];
}


@end
