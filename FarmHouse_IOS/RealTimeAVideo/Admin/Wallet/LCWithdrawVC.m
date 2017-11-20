//
//  LCWithdrawVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCWithdrawVC.h"
#import "NSString+md5String.h"
#import "YQInputPayKeyWordView.h"
@interface LCWithdrawVC ()<WCLPassWordViewDelegate>
{
    NSString *banName;
    NSString *drawMonery;
    NSInteger verifCount; //密码验证次数
    UIButton *drawButton;
    UITextField *textField;
    YQInputPayKeyWordView *keyword;
}

@property(nonatomic, strong)UIScrollView *bgScrollView;

@property(nonatomic, strong)UIView *contentView;

/** 提现金额 */
@property(nonatomic, strong)NSString *drawCount;

@end

@implementation LCWithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"零钱提现";
    verifCount = 0;
    self.view.backgroundColor = TabBGColor;
    self.drawCount = [NSString string];
    
    [self requestForBankCard];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_refreshBlock) {
        _refreshBlock();
    }
}

- (void)creatMainView {
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _contentView = [[UIView alloc] init];
//    _contentView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_bgScrollView];
    [_bgScrollView addSubview:_contentView];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(_bgScrollView);
    }];
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView];
    
    UILabel *titleLab = [LCTools createLable:@"银行卡" withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:titleLab];
    
    UILabel *titleRight = [LCTools createLable:banName withFont:kFontSize14 textColor:[UIColor colorwithHex:@"0x407BA7"] textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:titleRight];

    UILabel *cashNum = [LCTools createLable:@"提现金额" withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    [cashNum setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [bgView addSubview:cashNum];

    
    textField = [[UITextField alloc] init];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.font = kFontSizeBold18;
    textField.textColor = [UIColor blackColor];
    [textField addTarget:self action:@selector(fieldEditChange:) forControlEvents:UIControlEventEditingChanged];
    textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RMB_32"]];
    textField.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:textField];
    
    UILabel *numLab = [LCTools createLable:StrFormat(@"当前零钱余额%@元，", self.totalAmout) withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:numLab];
    
    UIButton *drawBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"全部提现" titleColor:[UIColor colorwithHex:@"0x407BA7"] font:kFontSize14 bgColor:[UIColor clearColor]];
    [drawBtn addTarget:self action:@selector(drawButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:drawBtn];
    
    drawButton = [LCTools createWordButton:UIButtonTypeCustom title:@"提现" titleColor:[UIColor whiteColor] font:kFontSize16 bgColor:MainColor cornerRadius:5.0f borderColor:nil borderWidth:0.0];
    [drawButton addTarget:self action:@selector(OKButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [drawButton setBackgroundImage:[UIImage imageNamed:@"gray_round"] forState:UIControlStateDisabled];

    
    [_contentView addSubview:drawButton];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(18);
        make.left.equalTo(_contentView).offset(10);
        make.right.equalTo(_contentView).offset(-10);
        make.height.equalTo(AutoWHGetHeight(145));
    }];
    
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView).offset(15);
        make.height.equalTo(AutoWHGetHeight(45));
    }];
    
    [titleRight makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.right).offset(20);
        make.centerY.equalTo(titleLab);
        make.height.equalTo(titleLab);
    }];
    
    [cashNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.left).offset(15);
        make.top.equalTo(titleLab.bottom);
        make.height.equalTo(AutoWHGetHeight(55));
    }];
    
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cashNum.right).offset(15);
        make.centerY.equalTo(cashNum);
        make.right.equalTo(bgView).offset(-15);
        make.height.equalTo(cashNum.height);
    }];
    
    [numLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashNum.bottom);
        make.left.equalTo(bgView.left).offset(15);
        make.height.equalTo(AutoWHGetHeight(45));
    }];
    
    [drawBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLab);
        make.left.equalTo(numLab.right);
        make.height.equalTo(numLab);
    }];
    
    [drawButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.bottom).offset(40);
        make.left.equalTo(_contentView).offset(20);
        make.right.equalTo(_contentView).offset(-20);
        make.height.equalTo(AutoWHGetHeight(40));
        
        make.bottom.equalTo(_contentView.bottom);
    }];
    
    
}


- (void)fieldEditChange:(UITextField *)field {
    
//    if ([field.text intValue] > [self.totalAmout intValue]) {
//        drawButton.enabled = NO;
//    }else {
//        drawButton.enabled = YES;
//    }
    
}

- (void)OKButtonAction:(UIButton *)button {
    
    if ([textField.text floatValue] >= [self.totalAmout floatValue]) {
        
        [[UIApplication sharedApplication].keyWindow makeToast:@"余额不足，无法提现"];

    }else if (![textField.text trueStr]) {
        
        [[UIApplication sharedApplication].keyWindow makeToast:@"请输入提现金额"];

    }else {
        
        keyword = [YQInputPayKeyWordView initFromNib];
        keyword.passWord.delegate = self;
        keyword.payStyleLabel.text = [NSString stringWithFormat:@"￥%@",textField.text];
        [keyword showkeyBoard];

    }
    
//    if ([textField.text trueStr] && [self.totalAmout intValue] > 0) {
//        
//        keyword = [YQInputPayKeyWordView initFromNib];
//        keyword.passWord.delegate = self;
//        keyword.payStyleLabel.text = [NSString stringWithFormat:@"￥%@",textField.text];
//        [keyword showkeyBoard];
//        
//    }else {
//        [[UIApplication sharedApplication].keyWindow makeToast:@"余额不足，无法提现"];
//    }
}

- (void)drawButtonAction:(UIButton *)button {
    
    if ([self.totalAmout intValue] > 0) {
        textField.text = self.totalAmout;
    }else {
        [self.view makeToast:@"没有零钱，不能提现哦"];
    }
    
    
}


/** 查询银行卡信息 */
- (void)requestForBankCard {
    
    NSDictionary *sendDic = @{@"flag":@"changeandbank",
                              @"userid":UDSobjectForKey(USERID)};
    [self.view makeToastActivity];
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.view hideToastActivity];
        
        if ([responseObject[STATE] integerValue] == 1) {
            banName = [NSString stringWithString:responseObject[DATA]];
            [self creatMainView];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view hideToastActivity];
    }];
    
}

/** 申请提现 */
- (void)applyWithdrawMonery {
    NSDictionary *senDic = @{@"flag":@"tixian",
                             @"userid":UDSobjectForKey(USERID),
                             @"monery":textField.text};
    
    [LCAFNetWork POST:@"monery" params:senDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[STATE] integerValue] == 1) {
            
            [self creatApplyView];
        }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [[UIApplication sharedApplication].keyWindow makeToast:[error localizedDescription]];
    }];
}


/***********************************************/

- (void)creatApplyView {
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _contentView = [[UIView alloc] init];
    //    _contentView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_bgScrollView];
    [_bgScrollView addSubview:_contentView];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(_bgScrollView);
    }];
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView];
    
    
    UILabel *topLab = [LCTools createLable:@"提现申请已提交" withFont:kFontSize18 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:topLab];
    
    UIView *lineView = [LCTools createLineView:TabBGColor];
    [bgView addSubview:lineView];
    
    UILabel *titleLab = [LCTools createLable:@"银行卡" withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:titleLab];
    
    UILabel *titleRight = [LCTools createLable:banName withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight];
    [bgView addSubview:titleRight];
    
    UILabel *cashNum = [LCTools createLable:@"提现金额" withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    [cashNum setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [bgView addSubview:cashNum];
    
    
    
    UILabel *cashNumRight = [LCTools createLable:[NSString stringWithFormat:@"￥%@",textField.text] withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight];
    [bgView addSubview:cashNumRight];
    
    
    UIButton *OKButton = [LCTools createWordButton:UIButtonTypeCustom title:@"完成" titleColor:[UIColor whiteColor] font:kFontSize16 bgColor:MainColor cornerRadius:5.0f borderColor:nil borderWidth:0.0];
    [OKButton addTarget:self action:@selector(completeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:OKButton];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(18);
        make.left.equalTo(_contentView).offset(10);
        make.right.equalTo(_contentView).offset(-10);
        make.height.equalTo(AutoWHGetHeight(163));
    }];
    
    
    [topLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView);
        make.right.equalTo(bgView);
        make.height.equalTo(AutoWHGetHeight(60));
    }];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLab.bottom).offset(-1);
        make.left.equalTo(bgView);
        make.right.equalTo(bgView);
        make.height.equalTo(1);
    }];
    
    
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(AutoWHGetHeight(8));
        make.left.equalTo(bgView).offset(15);
        make.height.equalTo(AutoWHGetHeight(50));
    }];
    
    [titleRight makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-15);
        make.centerY.equalTo(titleLab);
        make.height.equalTo(titleLab);
    }];
    
    [cashNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.left).offset(15);
        make.top.equalTo(titleLab.bottom);
        make.height.equalTo(AutoWHGetHeight(45));
    }];
    
    [cashNumRight makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-15);
        make.centerY.equalTo(cashNum);
        make.height.equalTo(cashNum);
    }];
    
    [OKButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.bottom).offset(40);
        make.left.equalTo(_contentView).offset(20);
        make.right.equalTo(_contentView).offset(-20);
        make.height.equalTo(AutoWHGetHeight(40));
        
        make.bottom.equalTo(_contentView.bottom);
    }];
    
    
}

- (void)completeBtnAction:(UIButton *)button {
    keyword = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - WCLPassWordViewDelegate
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(WCLPassWordView *)passWord {
    NSLog(@"======密码改变：%@",passWord.textStore);
}

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(WCLPassWordView *)passWord {
    NSLog(@"+++++++密码输入完成");
    verifCount++;
    if (verifCount >= 5) {
        
        [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"输入错误次数过于频繁，请确定密码后重试" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel cancelHandler:^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }
    
    [self verificationForReset:passWord success:^{
        
        [self applyWithdrawMonery];
        
        [keyword dissmissCompletion:nil];
        
        [_bgScrollView removeFromSuperview];
    }];
}

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(WCLPassWordView *)passWord {
    NSLog(@"-------密码开始输入");
}


/** 验证密码正确性 for reset */
- (void)verificationForReset:(WCLPassWordView *)passwordView success:(void(^)()) success {
    NSDictionary *send = @{@"flag":@"checkChangePassword",
                           @"userid":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"",
                           @"password":[NSString md5String:passwordView.textStore]};
    
    [LCAFNetWork POST:@"monery" params:send success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[STATE] integerValue] == 1) {
            
            success();
            
        }else {
            
            [[UIApplication sharedApplication].keyWindow makeToast:responseObject[MESSAGE]];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        [[UIApplication sharedApplication].keyWindow makeToast:[error localizedDescription]];
    }];
}



@end
