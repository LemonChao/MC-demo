//
//  LCCollectionHeader.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCCollectionHeader.h"
#import "OfflineModel+CoreDataClass.h"
#import "GatherPhoto+CoreDataClass.h" //照片采集

/// 离线拍照区头
@interface LCCollectionHeader ()
{
    UIButton *selectBtn;
}
@property(nonatomic, strong) UIButton *yesBtn;
@property(nonatomic, strong) UIButton *noBtn;
@end

@implementation LCCollectionHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat padding = 5.0f;
//        self.backgroundColor = [UIColor cyanColor];
        UILabel *caseInfo = [LCTools createLable:@"案件信息" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
       // caseInfo.backgroundColor = [UIColor yellowColor];
        [self addSubview:caseInfo];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = MainColor;
        [self addSubview:lineView1];
        
        UILabel *houseLab = [LCTools createLable:@" 户主姓名：" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        houseLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:houseLab];
        
        UIButton *choseBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"选 择" titleColor:MainColor font:kFontSize14 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
        [choseBtn addTarget:self action:@selector(choseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//                choseBtn.backgroundColor = [UIColor redColor];
        [self addSubview:choseBtn];

        
        self.houseField = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleRoundedRect withPlaceholder:@"选择或输入户主姓名"];
        [_houseField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_houseField addTarget:self action:@selector(textFieldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [_houseField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
//        _houseField.backgroundColor = [UIColor redColor];
        [self addSubview:_houseField];
        
        UILabel *autoload = [LCTools createLable:@" 自动上传：" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        autoload.backgroundColor = [UIColor yellowColor];
        [self addSubview:autoload];
        
        UIView *bgView = [[UIView alloc] init];
//        bgView.backgroundColor = [UIColor redColor];
        [self addSubview:bgView];
        
        _yesBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"是" titleColor:[UIColor blackColor] font:kFontSize14 bgColor:[UIColor whiteColor]];
        [_yesBtn setImage:[UIImage imageNamed:@"select_true"] forState:UIControlStateSelected];
        [_yesBtn setImage:[UIImage imageNamed:@"select_false"] forState:UIControlStateNormal];
        [_yesBtn addTarget:self action:@selector(uploadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //                choseBtn.backgroundColor = [UIColor redColor];
        [_yesBtn setSelected:YES];
        selectBtn = _yesBtn;

        [_yesBtn setImagePosition:ZXImagePositionLeft spacing:AutoWHGetWidth(5)];
        [bgView addSubview:_yesBtn];

        _noBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"否" titleColor:[UIColor blackColor] font:kFontSize14 bgColor:[UIColor whiteColor]];
        [_noBtn setImage:[UIImage imageNamed:@"select_true"] forState:UIControlStateSelected];
        [_noBtn setImage:[UIImage imageNamed:@"select_false"] forState:UIControlStateNormal];
        [_noBtn addTarget:self action:@selector(uploadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //                choseBtn.backgroundColor = [UIColor redColor];
        [_noBtn setImagePosition:ZXImagePositionLeft spacing:AutoWHGetWidth(5)];
        [bgView addSubview:_noBtn];
        
        UILabel *photoLab = [LCTools createLable:@"案件图片" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
      //  photoLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:photoLab];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = MainColor;
        [self addSubview:lineView2];

        [caseInfo makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(padding);
            make.left.equalTo(self).offset(padding+3);
            make.height.equalTo(AutoWHGetHeight(25));
        }];
        
        [lineView1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(caseInfo.bottom).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(1);
        }];
        
        [choseBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView1.bottom).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(AutoWHGetHeight(31));
            make.width.equalTo(AutoWHGetWidth(65));
        }];

        [houseLab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(choseBtn);
            make.left.equalTo(self).offset(padding+3);
            make.right.equalTo(_houseField.left);
        }];
        
        [_houseField makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(choseBtn.left).offset(-padding);
            make.centerY.equalTo(houseLab);
        }];
        
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-padding);
            make.top.equalTo(choseBtn.bottom).offset(padding);
            make.height.equalTo(AutoWHGetHeight(31));
            make.width.equalTo(AutoWHGetWidth(150));
        }];
        
        [autoload makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding);
            make.centerY.equalTo(bgView);
        }];

        [_yesBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView);
            make.top.equalTo(bgView);
            make.bottom.equalTo(bgView);
            make.width.equalTo(AutoWHGetWidth(65));
        }];
        
        [_noBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView);
            make.top.equalTo(bgView);
            make.bottom.equalTo(bgView);
            make.width.equalTo(AutoWHGetWidth(65));
        }];
        
        [lineView2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.bottom.equalTo(self);
            make.height.equalTo(1);
        }];
        
        [photoLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding+3);
            make.bottom.equalTo(lineView2.top).offset(-padding);
            make.height.equalTo(caseInfo.height);
        }];
        
    }
    return self;
}

- (void)choseBtnAction:(UIButton *)button {
    if (_btnBlock) {
        _btnBlock();
    }
}

- (void)uploadBtnAction:(UIButton *)button {
    if (selectBtn == button) {
        return;
    }
    
    button.selected = YES;
    selectBtn.selected = NO;
    
    selectBtn = button;
    
}

- (BOOL)autoUpdate {
    _autoUpdate = _yesBtn.selected;
    return _autoUpdate;
}

- (void)setGatherHead:(OfflineModel *)model {
    self.houseField.text = model.farmerName;
    self.farmerId = model.farmerId;
    self.farmerName = model.farmerName;
}


- (void)textFieldEndEditing:(UITextField *)nameField {
    if ([_farmerName isEqualToString:_houseField.text]) {
        return;
    }else {
        _farmerName = _houseField.text;
        _farmerId = @"-1";
    }
}



@end



/// 未上传区头
@interface LCHeadUNupload ()

@end
@implementation LCHeadUNupload

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      //  self.backgroundColor = [UIColor cyanColor];
        UILabel *caseInfo = [LCTools createLable:@"案件信息" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
      //  caseInfo.backgroundColor = [UIColor yellowColor];
        [self addSubview:caseInfo];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = MainColor;
        [self addSubview:lineView1];
        
//        UILabel *houseLab = [LCTools createLable:@"房屋位置：" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//      //  houseLab.backgroundColor = [UIColor yellowColor];
//        [self addSubview:houseLab];
//        
//        self.houseField = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleRoundedRect withPlaceholder:@"请输入房屋位置"];
//        [_houseField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
//        [_houseField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
//        _houseField.backgroundColor = [UIColor redColor];
//        [self addSubview:_houseField];
        
        UILabel *farmerTitleLab = [LCTools createLable:@"户主姓名:" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:0];
//        farmerTitleLab.backgroundColor = [UIColor grayColor];

//        [farmerTitleLab setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
//        [farmerTitleLab setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:farmerTitleLab];
        
        
        _houseName = [LCTools createLable:@"" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        //减小扛拉伸，扛压缩系数
        [_houseName setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_houseName setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
//        _houseName.backgroundColor = [UIColor redColor];
        [self addSubview:_houseName];
        
        UIButton *choseBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"选 择" titleColor:MainColor font:kFontSize14 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
        [choseBtn addTarget:self action:@selector(choseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //    choseBtn.backgroundColor = [UIColor redColor];
        [self addSubview:choseBtn];
        
        UILabel *photoLab = [LCTools createLable:@"案件图片" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
     //   photoLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:photoLab];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = MainColor;
        [self addSubview:lineView2];        
        
        CGFloat padding = 5.0f;

        
        [caseInfo makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(padding);
            make.left.equalTo(self).offset(padding+3);
            make.height.equalTo(AutoWHGetHeight(25));
        }];
        
        [lineView1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(caseInfo.bottom).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(1);
        }];
        
        [choseBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView1.bottom).offset(padding*2);
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(AutoWHGetHeight(28));
            make.width.equalTo(AutoWHGetWidth(65));
        }];
        
        [farmerTitleLab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(choseBtn);
            make.left.equalTo(self).offset(padding+3);

        }];
        
        [_houseName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(farmerTitleLab.right).offset(10);
            make.right.equalTo(choseBtn.left).offset(-padding);
            make.centerY.equalTo(farmerTitleLab);

        }];
        
        [lineView2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.bottom.equalTo(self);
            make.height.equalTo(1);

        }];
        
        [photoLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding+3);
            make.bottom.equalTo(lineView2.top).offset(-padding);
            make.height.equalTo(caseInfo.height);

        }];
        
        
//        [caseInfo mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.left.mas_equalTo(AutoWHGetWidth(10));
//            make.width.offset(AutoWHGetWidth(150));
//            make.height.offset(AutoWHGetHeight(37));
//        }];
//        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(caseInfo.bottom).offset(0);
//            make.width.offset(SCREEN_WIDTH - AutoWHGetWidth(12));
//            make.height.offset(AutoWHGetHeight(1));
//            make.left.mas_equalTo(AutoWHGetWidth(6));
//        }];
//        [houseLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(AutoWHGetWidth(15));
//            make.top.mas_equalTo(lineView1.bottom).offset(0);
//            make.height.offset(AutoWHGetHeight(37));
//            make.width.offset(AutoWHGetWidth(85));
//        }];
//        [_houseField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(houseLab.right).offset(0);
//            make.width.mas_equalTo(SCREEN_WIDTH - AutoWHGetWidth(115));
//            make.height.mas_equalTo(AutoWHGetHeight(31));
//            make.top.mas_equalTo(lineView1.bottom).offset(3);
//        }];
//        [farmerTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.left.height.mas_equalTo(houseLab);
//            make.top.mas_equalTo(houseLab.bottom);
//        }];
//        [choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-AutoWHGetWidth(15));
//            make.height.mas_equalTo(AutoWHGetHeight(31));
//            make.centerY.mas_equalTo(farmerTitleLab);
//            make.width.mas_equalTo(AutoWHGetWidth(65));
//        }];
//        [_houseName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(farmerTitleLab.right);
//            make.right.mas_equalTo(choseBtn.left);
//            make.top.mas_equalTo(houseLab.bottom);
//            make.height.mas_equalTo(houseLab);
//        }];
//        [photoLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(farmerTitleLab.bottom);
//            make.left.right.height.mas_equalTo(caseInfo);
//        }];
//        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(AutoWHGetHeight(-2));
//            make.left.right.height.mas_equalTo(lineView1);
//        }];
    }
    return self;
}

- (void)choseBtnAction:(UIButton *)button {
    if (_btnBlock) {
        _btnBlock();
    }
}


- (void)setUnuploadHead:(OfflineModel *)model {
    
    self.farmerId = model.farmerId;
    self.houseName.text = model.farmerName;
    self.farmerNamer = model.farmerName;
    self.houseInfo = model.houseInfo;
}


@end


/// 已上传区头
@interface LCHeadUpload ()

@property(nonatomic, strong) UILabel *houseLab;

@property(nonatomic, strong) UILabel *houseName;

@end
@implementation LCHeadUpload

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat padding = 5.0f;
//        self.backgroundColor = [UIColor cyanColor];
        UILabel *caseInfo = [LCTools createLable:@"案件信息" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
//        caseInfo.backgroundColor = [UIColor yellowColor];
        [self addSubview:caseInfo];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = MainColor;
        [self addSubview:lineView1];
        
        UILabel *houseLab = [LCTools createLable:@" 房屋位置：" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        houseLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:houseLab];
        self.houseLab = houseLab;
        
        UILabel *houseName = [LCTools createLable:@" 户主姓名：看看" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        //减小扛拉伸，扛压缩系数
        //        [houseName setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        //        [houseName setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
//        houseName.backgroundColor = [UIColor greenColor];
        [self addSubview:houseName];
        self.houseName = houseName;

        
        UILabel *photoLab = [LCTools createLable:@"案件图片" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
//        photoLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:photoLab];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = MainColor;
        [self addSubview:lineView2];
        
        [caseInfo makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(padding);
            make.left.equalTo(self).offset(padding+3);
            make.height.equalTo(@[houseLab, photoLab, houseName]);
        }];
        
        [lineView1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(caseInfo.bottom).offset(padding);
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(1);
        }];
        
        [houseLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView1).offset(padding);
            make.left.equalTo(self).offset(padding+3);
            make.right.equalTo(self).offset(-padding);
            make.bottom.equalTo(houseName.top).offset(-padding);
        }];
        
        [houseName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding+3);
            make.right.equalTo(self).offset(-padding);
            make.bottom.equalTo(photoLab.top).offset(-padding);
        }];
        
        
        [photoLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding+3);
            make.bottom.equalTo(lineView2.top).offset(-padding);
        }];
        
        [lineView2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(1);
            make.bottom.equalTo(self);
        }];
        
    }
    return self;
}

- (void)setUploadHead:(OfflineModel *)model {
    self.houseLab.text = StrFormat(@" 房屋位置：%@", model.houseInfo ? model.houseInfo : @"");
    self.houseName.text = StrFormat(@" 户主姓名：%@", model.farmerName ? model.farmerName : @"");
}


@end


/// 采集功能区->农户照片采集
@implementation LCHeadGather

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //  CGFloat padding = 5.0f;
//        self.backgroundColor = [UIColor cyanColor];
        self.headType = HeadGatherFieldEnable;
        UILabel *caseInfo = [LCTools createLable:@"案件信息" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
//        caseInfo.backgroundColor = [UIColor yellowColor];
        [self addSubview:caseInfo];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = MainColor;
        [self addSubview:lineView1];
        
        self.nameField = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleRoundedRect withPlaceholder:@"选择或输入户主姓名"];
        _nameField.borderStyle = UITextBorderStyleNone;
        [_nameField addTarget:self action:@selector(textFieldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [_nameField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_nameField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
//        _nameField.backgroundColor = [UIColor redColor];
        [self addSubview:_nameField];
        
        UILabel *farmerTitleLab = [LCTools createLable:@"户主姓名:" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:0];
//        farmerTitleLab.backgroundColor = [UIColor grayColor];
        
        [self addSubview:farmerTitleLab];
        
        UIButton *choseBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"选 择" titleColor:MainColor font:kFontSize14 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
        [choseBtn addTarget:self action:@selector(choseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        choseBtn.backgroundColor = [UIColor redColor];
        [self addSubview:choseBtn];
        
        UILabel *photoLab = [LCTools createLable:@"案件图片" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
//        photoLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:photoLab];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = MainColor;
        [self addSubview:lineView2];
        [caseInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(AutoWHGetWidth(10));
            make.width.offset(AutoWHGetWidth(90));
            make.height.offset(AutoWHGetHeight(37));
        }];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(caseInfo.bottom).offset(0);
            make.width.offset(SCREEN_WIDTH - AutoWHGetWidth(12));
            make.height.offset(AutoWHGetHeight(1));
            make.left.mas_equalTo(AutoWHGetWidth(6));
        }];
        [farmerTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(AutoWHGetWidth(15));
            make.top.mas_equalTo(lineView1.bottom).offset(10);
            make.height.offset(AutoWHGetHeight(37));
            make.width.offset(AutoWHGetWidth(75));
        }];
        [choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-AutoWHGetWidth(15));
            make.height.mas_equalTo(AutoWHGetHeight(31));
            make.centerY.mas_equalTo(farmerTitleLab);
            make.width.mas_equalTo(AutoWHGetWidth(65));
        }];
        [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(farmerTitleLab.right);
            make.right.mas_equalTo(choseBtn.left);
            make.centerY.equalTo(farmerTitleLab);
            make.height.equalTo(AutoWHGetHeight(37));
        }];
        [photoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(farmerTitleLab.bottom);
            make.left.right.height.mas_equalTo(caseInfo);
        }];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(AutoWHGetHeight(-2));
            make.left.right.height.mas_equalTo(lineView1);
        }];
    }
    return self;
}

- (void)choseBtnAction:(UIButton *)button {
    if (_btnBlock) {
        _btnBlock();
    }
}


- (void)setGatherHead:(GatherPhoto *)model {
    self.nameField.text = model.houseName;
    self.farmerId = model.nhid;
    self.farmerName = model.houseName;
    self.nameField.enabled = self.headType;
}


- (void)textFieldEndEditing:(UITextField *)nameField {
    if ([_farmerName isEqualToString:_nameField.text]) {
        return;
    }else {
        _farmerName = _nameField.text;
        _farmerId = @"-1";
    }
}


@end

