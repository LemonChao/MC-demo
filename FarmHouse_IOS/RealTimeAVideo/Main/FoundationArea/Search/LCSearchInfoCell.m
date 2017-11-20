//
//  LCSearchInfoCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCSearchInfoCell.h"
#import "StepProgressView.h"

@interface LCSearchInfoCell ()

@property(nonatomic, strong) UILabel *stateLab;

@property(nonatomic, strong) UILabel *damageLab;

@property(nonatomic, strong) UIButton *editBtn1;

@property(nonatomic, strong) UIButton *picInfoBtn;

@property(nonatomic, strong) UILabel *civilSalve;

@property(nonatomic, strong) UIButton *editBtn2;

@property(nonatomic, strong) UILabel *helpLab;

@end

@implementation LCSearchInfoCell

+ (instancetype)creatWithTableView:(UITableView *)tableView reuseidentifier:(NSString *)reuseidentifier {
    LCSearchInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier];
    if (!cell) {
        cell = [[LCSearchInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _stateLab = [LCTools createLable:@"受损状况" withFont:kFontSize16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self addSubview:_stateLab];

        _damageLab = [LCTools createLable:@"尚未录入" withFont:kFontSize14 textColor:BGColor textAlignment:NSTextAlignmentLeft];
        [self addSubview:_damageLab];

        _editBtn1 = [LCTools createWordButton:UIButtonTypeCustom title:@"编辑" titleColor:MainColor font:kFontSize16 bgColor:[UIColor whiteColor] cornerRadius:5.0f borderColor:MainColor borderWidth:0.3f];
        [_editBtn1 addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editBtn1];
        
        _picInfoBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"图片详情" titleColor:BGColor font:kFontSize15 bgColor:[UIColor whiteColor]];
        [_picInfoBtn addTarget:self action:@selector(picButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_picInfoBtn setImage:[UIImage imageNamed:@"greyarrow"] forState:UIControlStateNormal];
        [self addSubview:_picInfoBtn];
        
        _civilSalve = [LCTools createLable:@"民政救助" withFont:kFontSize16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self addSubview:_civilSalve];
        
        _helpLab = [LCTools createLable:@"尚未录入" withFont:kFontSize14 textColor:BGColor textAlignment:NSTextAlignmentLeft];
        [self addSubview:_helpLab];
        
        _editBtn2 = [LCTools createWordButton:UIButtonTypeCustom title:@"编辑" titleColor:MainColor font:kFontSize16 bgColor:[UIColor whiteColor] cornerRadius:5.0f borderColor:MainColor borderWidth:0.5f];
        [_editBtn2 addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editBtn2];

    }
    return self;
}

- (void)setValueWithModel:(LCDisasterModel *)model {
    if (!model) return;
    
    self.damageLab.text = model.disaster;
    self.helpLab.text = model.relief_material;
}


- (void)picButtonClick:(UIButton *)button {
    if (_picBtnBlock) {
        _picBtnBlock();
    }
}

- (void)topButtonAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(infoCell:topEditButtonClick:)]) {
        [_delegate infoCell:self topEditButtonClick:button];
    }
}

- (void)bottomButtonAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(infoCell:bottomEditButtonClick:)]) {
        [_delegate infoCell:self bottomEditButtonClick:button];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10;
    [_stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(padding);
        make.left.equalTo(self).offset(padding*2);
    }];
    
    [_editBtn1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stateLab.bottom).offset(padding);
        make.right.equalTo(self.right).offset(-padding);
        make.size.equalTo(CGSizeMake(70, 35));
    }];
    
    [_damageLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stateLab.bottom).offset(padding);
        make.left.equalTo(_stateLab).offset(padding);
        make.right.equalTo(_editBtn1.left).offset(-padding);
    }];
    
    [_picInfoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_editBtn1.bottom).offset(padding*1.5);
        make.left.equalTo(_damageLab);
        make.right.equalTo(self).offset(-padding);
    }];
    
    [_picInfoBtn setImagePosition:ZXImagePositionRight WithMargin:5];

    [_editBtn2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-padding);
        make.bottom.equalTo(self.bottom).offset(-padding*2);
        make.size.equalTo(CGSizeMake(70, 35));
    }];
    
    [_helpLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_editBtn2.centerY);
        make.right.equalTo(_editBtn2.left).offset(-padding);
        make.left.equalTo(_damageLab.left);
    }];
    
    [_civilSalve makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(padding*2);
        make.bottom.equalTo(_helpLab.top).offset(-padding);
    }];
}


@end


@interface LCSearchHeader ()

@property(nonatomic, strong) UILabel *numLab;

@property(nonatomic, strong) UILabel *householder;

@property(nonatomic, strong) UILabel *addLab;

@property(nonatomic, strong) UILabel *timeLab;

@property(nonatomic, strong) UILabel *stateLab;

@property(nonatomic, strong) StepProgressView *stateView;

@property(nonatomic, strong) UILabel *paybackLab;

@property(nonatomic, strong) UIView *line;
@end

@implementation LCSearchHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numLab = [LCTools createLable:@"编号：" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self addSubview:_numLab];
        
        _householder = [LCTools createLable:@"户主：" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        _householder.backgroundColor = [UIColor yellowColor];
        [self addSubview:_householder];
        
        _addLab = [LCTools createLable:@"地址：" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self addSubview:_addLab];
        
        _timeLab = [LCTools createLable:@"时间：" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        _timeLab.backgroundColor = [UIColor cyanColor];
        [self addSubview:_timeLab];
        
        _stateLab = [LCTools createLable:@"状态：" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self addSubview:_stateLab];
        
        _stateView = [StepProgressView progressView:CGRectMake(25, self.frame.size.height*0.6, self.frame.size.width-50, self.frame.size.height*0.3) titleArray:@[@"查勘",@"定损",@"赔付",@"结案"] style:StepProgressAverage];
        [self addSubview:_stateView];
        
        _paybackLab = [LCTools createLable:@"赔付金额：" withFont:kFontSize14 textColor:BGColor textAlignment:NSTextAlignmentRight];
        _paybackLab.numberOfLines = 1;
        [self addSubview:_paybackLab];
        
        _line = [LCTools createLineView:[UIColor lightGrayColor]];
        [self addSubview:_line];
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    self.stateView.stepIndex = index;
}


- (void)setValueWithModel:(LCSearchModel *)model {
    self.numLab.text = StrFormat(@"编号：%@", model.number);
    self.addLab.text = StrFormat(@"地址：%@", model.farmer.address);
    self.householder.text = StrFormat(@"户主：%@", model.farmer.name);
    self.timeLab.text = StrFormat(@"时间：%@", model.starttime);
    self.stateView.stepIndex = [model.state integerValue]-1;
    self.paybackLab.text = StrFormat(@"赔付金额：%@",model.finally_amount);
    self.paybackLab.hidden = model.finally_amount ?  YES : NO;
}


/**
 这里拿到的子控件frame为0，他们调用sizeTofit后才有size
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.frame.size.height;
    CGFloat lableH = [@"收到" sizeWithAttributes:@{NSFontAttributeName:kFontSize15}].height;
    DLog(@"lab = %f, cau = %f", _numLab.frame.size.height, lableH);
    CGFloat padding = (height*0.7 - lableH*5)/6;
    CGFloat margin = 10.0f;

    [_stateLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.bottom.equalTo(_stateView.top).offset(-padding);
    }];
    
    [_timeLab makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_addLab.bottom).offset(padding);
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.bottom.equalTo(_stateLab.top).offset(-padding);
    }];
    
    [_addLab makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_householder.bottom).offset(padding);
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.bottom.equalTo(_timeLab.top).offset(-padding);
    }];
    
    [_householder makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_numLab.bottom).offset(padding);
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.bottom.equalTo(_addLab.top).offset(-padding);
    }];
    
    [_numLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(padding);
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.bottom.equalTo(_householder.top).offset(-padding);
    }];

    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(0.5f);
    }];
    
    [_paybackLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-margin);
        make.bottom.equalTo(_line.top).offset(-margin/2);
    }];

}

@end
