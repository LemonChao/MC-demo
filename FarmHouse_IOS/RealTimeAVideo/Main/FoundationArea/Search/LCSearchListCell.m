//
//  LCSearchListCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/20.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCSearchListCell.h"
#import "LCSearchModel.h"

@interface LCSearchListCell ()

@property(nonatomic, strong) UIView *topBg;

@property(nonatomic, strong) UILabel *repTitle;

@property(nonatomic, strong) UILabel *repNum;

@property(nonatomic, strong) UIImageView *arrowImg;

@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UIView *bottomBg;

@property(nonatomic, strong) UIImageView *portraitImg;

@property(nonatomic, strong) UIImageView *locationImg;

@property(nonatomic, strong) UILabel *nameLab;

@property(nonatomic, strong) UILabel *addressLab;

@property(nonatomic, strong) UILabel *timeLab;


@end

@implementation LCSearchListCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellID {
    LCSearchListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LCSearchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorwithHex:@"0xf0f0f0"];
        
        _topBg = [[UIView alloc] init];
        _topBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topBg];
        
        _repTitle = [LCTools createLable:@"报案号：" withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
        [_topBg addSubview:_repTitle];
        
        _repNum = [LCTools createLable:@"100003244354354643" withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
        [_repNum setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_repNum setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
//        _repNum.backgroundColor = [UIColor cyanColor];
        [_topBg addSubview:_repNum];
        
        _arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlackArrowRight"]];
        [_topBg addSubview:_arrowImg];
        
        _lineView = [LCTools createLineView:[UIColor lightGrayColor]];
        [_topBg addSubview:_lineView];
        
        _bottomBg = [[UIView alloc] init];
        _bottomBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomBg];
        
        _portraitImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_protrait"]];
        [_bottomBg addSubview:_portraitImg];
        
        _nameLab = [LCTools createLable:@"大婶" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [_bottomBg addSubview:_nameLab];
        
        _locationImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_location"]];
        [_bottomBg addSubview:_locationImg];
        
        _addressLab = [LCTools createLable:@"dsfsdfsgads" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [_bottomBg addSubview:_addressLab];
        
        _timeLab = [LCTools createLable:@"2017/03/20 18:34:23" withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
        [_bottomBg addSubview:_timeLab];
        
    }
    return self;
}

- (void)setValueWithModel:(LCSearchModel *)model {
    self.repNum.text = model.number;
    self.nameLab.text = model.farmer.name;
    self.addressLab.text = model.farmer.address;
    self.timeLab.text = model.starttime;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //
    
    NSInteger padding = 10;
    [_topBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(SeaListCellH*0.28);
    }];
    
    [_repTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBg).offset(padding);
        make.left.equalTo(_topBg).offset(padding);
        make.right.equalTo(_repNum.left);
        make.bottom.equalTo(_topBg).offset(-padding);
    }];
    
    [_arrowImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topBg).offset(-padding);
        make.centerY.equalTo(_topBg);
        make.size.equalTo(AutoCGSizeMake(6, 15.5));
    }];

    [_repNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBg).offset(padding);
//        make.left.equalTo(_topBg).offset(padding);
        make.right.equalTo(_arrowImg.left).offset(-padding);
        make.bottom.equalTo(_topBg).offset(-padding);
    }];
    
    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBg);
        make.right.equalTo(_topBg);
        make.bottom.equalTo(_topBg);
        make.height.equalTo(0.5f);
    }];
    
    
    [_bottomBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBg.bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [_portraitImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomBg).offset(padding);
        make.left.equalTo(_bottomBg).offset(padding*2);
        make.size.equalTo(AutoCGSizeMake(13, 15));
    }];
    
    [_nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_portraitImg);
        make.left.equalTo(_portraitImg.right).offset(10);
        make.right.equalTo(_bottomBg.right).offset(-padding);
    }];
    
    [_locationImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_portraitImg.bottom).offset(padding);
        make.left.equalTo(_bottomBg).offset(padding*2);
        make.size.equalTo(AutoCGSizeMake(13, 15));
    }];
    
    [_addressLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_locationImg);
        make.left.equalTo(_locationImg.right).offset(padding);
        make.right.equalTo(_bottomBg.right).offset(-padding);
    }];
    
    [_timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomBg).offset(-padding);
        make.bottom.equalTo(_bottomBg).offset(-padding);
    }];
    
    
}



@end
