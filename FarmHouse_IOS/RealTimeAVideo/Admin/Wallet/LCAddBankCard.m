//
//  LCAddBankCard.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCAddBankCard.h"
#import "LCBankCardVC.h"
#import "LCPasswordVC.h"

@interface LCAddBankCard ()
{
    NSTimer *verifTimer;
    NSInteger counter;
    dispatch_source_t _timer;
    
    BOOL realBankNum;
    BOOL equalBankNum;
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UITextField *phoneNumField;
@property(nonatomic, strong) UITextField *verifCodeField;
@property(nonatomic, strong) UIButton *verifCodeBtn;

@property(nonatomic, strong) UITextField *cardField1;
@property(nonatomic, strong) UITextField *cardField2;
@property(nonatomic, strong) UITextField *cardField3;
@property(nonatomic, strong) UITextField *cardField4;
@property(nonatomic, strong) UITextField *cardField5;
@property(nonatomic, strong) UITextField *cardField6;
@property(nonatomic, strong) UITextField *cardField7;
@property(nonatomic, strong) UITextField *cardField8;
@property(nonatomic, strong) UITextField *cardField9;


@end

@implementation LCAddBankCard


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (_timer != NULL) {
        dispatch_source_cancel(_timer);

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TabBGColor;
    
    if (self.type == AddBankcardCerifCode) {
        self.title = @"找回密码";
        [self creatVerificationUI];
    }else if (self.type == AddBankcardNewCard) {
        self.title = @"添加银行卡";
        [self creatAddCardUI];
    }
}

- (void)setTimer {
    
}


//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        
//        _contentView = [[UIView alloc] init];
//        _contentView.backgroundColor = [UIColor cyanColor];
//        [_contentView makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(UIEdgeInsetsZero);
//            make.width.equalTo(_scrollView);
//        }];
//    }
//    return _scrollView;
//}

- (void)creatVerificationUI {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(_scrollView);
    }];
    
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView1];
    UILabel *numLab = [LCTools createLable:@"手机号" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [bgView1 addSubview:numLab];
    _phoneNumField = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleNone withPlaceholder:@"请输入手机号"];
    _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView1 addSubview:_phoneNumField];
    [_phoneNumField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [_phoneNumField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    
    
    UIView *bgView2 = [[UIView alloc] init];
    bgView2.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView2];
    UILabel *codeLab = [LCTools createLable:@"验证码" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [bgView2 addSubview:codeLab];
    
    _verifCodeBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"获取验证码" titleColor:[UIColor whiteColor] font:kFontSize14 bgColor:MainColor];
    [_verifCodeBtn addTarget:self action:@selector(verifCodeBtnAction1:) forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:_verifCodeBtn];
    _verifCodeField = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleNone withPlaceholder:@"请输入验证码"];
    _verifCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView2 addSubview:_verifCodeField];
    [_verifCodeField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [_verifCodeField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    
    
    UIButton *nextBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"下一步" titleColor:[UIColor whiteColor] font:kFontSize14 bgColor:MainColor cornerRadius:5.0f borderColor:nil borderWidth:0.0];
    [nextBtn addTarget:self action:@selector(submitBtnAvtion:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:nextBtn];
    
    [bgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.height.equalTo(AutoWHGetHeight(50));
    }];
    
    [numLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView1).offset(20);
        make.centerY.equalTo(bgView1);
    }];
    
    [_phoneNumField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLab.right).offset(10);
        make.centerY.equalTo(bgView1);
        make.right.equalTo(bgView1).offset(10);
        make.height.equalTo(bgView1);
    }];
    
    [codeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView2).offset(20);
        make.centerY.equalTo(bgView2);
    }];
    
    [_verifCodeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView2);
        make.centerY.equalTo(bgView2);
        make.height.equalTo(bgView2);
        make.width.equalTo(110);
    }];
    
    [_verifCodeField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeLab.right).offset(10);
        make.centerY.equalTo(bgView2);
        make.right.equalTo(_verifCodeBtn.left).offset(10);
        make.height.equalTo(bgView2);

    }];
    
    
    [bgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView1.bottom).offset(1);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.height.equalTo(AutoWHGetHeight(50));
    }];
    
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView2.bottom).offset(60);
        make.left.equalTo(_contentView).offset(20);
        make.right.equalTo(_contentView).offset(-20);
        make.height.equalTo(AutoWHGetHeight(40));
        
        make.bottom.equalTo(_contentView);
    }];

}

- (void)startGCDTimerButton:(UIButton *)button {
    _phoneNumField.enabled = NO;
    button.enabled = NO;

    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                _phoneNumField.enabled = YES;
                button.enabled = YES;
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];

            });
            
        }else{
            
//            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [button setTitle:[NSString stringWithFormat:@"%ld秒重获", time] forState:UIControlStateNormal];
                button.enabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);

}


- (void)verifCodeBtnAction1:(UIButton *)button {
    if (![_phoneNumField.text trueStr]) {
        [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"电话号码不能为空" buttonTitle:nil buttonStyle:1];
        return;
    }
    
    NSDictionary *sendDic = @{@"flag":@"GetVerCode",
                              @"phonenumber":_phoneNumField.text};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //60S 限制
        if ([[responseObject objectForKey:@"state"] integerValue] == 1) {
            
            [self startGCDTimerButton:button];
            
        }else {
            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];

}

- (void)getTimer:(NSTimer *)timer {
    counter--;
    counter = (counter < 0) ? 0 : counter;
    
    [_verifCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒重获", counter] forState:UIControlStateNormal];
    _verifCodeBtn.enabled = NO;
    
    if (counter == 0)
    {
        _phoneNumField.enabled = YES;
        _verifCodeBtn.enabled = YES;
        [_verifCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer invalidate];
    }

}


/** 校验验证码 */
- (void)submitBtnAvtion:(UIButton *)button {
    
    
    if (![LCTools isMobileNumber:self.phoneNumField.text]) {
        [self.view makeToast:@"请输入正确的手机号" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    NSDictionary *sendDic = @{@"flag":@"CheckCode",
                              @"phonenumber":self.phoneNumField.text,
                              @"code":self.verifCodeField.text};
    @WeakObj(self);
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //next VC
        if ([[responseObject objectForKey:@"state"] integerValue]) {
            
            //stop timer otherwise the VC can't be dealloc right now
            [verifTimer invalidate];
            LCPasswordVC *vc = [[LCPasswordVC alloc] init];
            vc.type = PasswordNew;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        }else {
            [selfWeak.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //show error
        [selfWeak.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];

}


/* **************************************************************************/

- (void)creatAddCardUI {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(_scrollView);
    }];

    UILabel *titleLab = [LCTools createLable:@"   添加持卡人本人银行卡" withFont:kFontSize14 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
    titleLab.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:titleLab];
    
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView1];
    UILabel *numLab1 = [LCTools createLable:@"持卡人 " withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [bgView1 addSubview:numLab1];
    _cardField1 = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleNone withPlaceholder:@"请输入持卡人"];
    [bgView1 addSubview:_cardField1];
    [_cardField1 setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [_cardField1 setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    UIView *bgView2 = [[UIView alloc] init];
    bgView2.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView2];
    UILabel *numLab2 = [LCTools createLable:@"手机号 " withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [bgView2 addSubview:numLab2];
    _cardField2 = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleNone withPlaceholder:@"请输入手机号"];
    _cardField2.keyboardType = UIKeyboardTypeNumberPad;
    [bgView2 addSubview:_cardField2];
    [_cardField2 setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [_cardField2 setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    UIView *bgView3 = [[UIView alloc] init];
    bgView3.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView3];
    UILabel *numLab3 = [LCTools createLable:@"开户行 " withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [bgView3 addSubview:numLab3];
    _cardField3 = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleNone withPlaceholder:@"请输入开户行"];
    [bgView3 addSubview:_cardField3];
    [_cardField3 setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [_cardField3 setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    UIView *bgView4 = [[UIView alloc] init];
    bgView4.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView4];
    UILabel *numLab4 = [LCTools createLable:@"卡 号 " withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [bgView4 addSubview:numLab4];
    _cardField4 = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleNone withPlaceholder:@"请输入卡号"];
    _cardField4.keyboardType = UIKeyboardTypeNumberPad;
    [_cardField4 addTarget:self action:@selector(cardField4EndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [bgView4 addSubview:_cardField4];
    [_cardField4 setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [_cardField4 setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    UIView *bgView5 = [[UIView alloc] init];
    bgView5.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:bgView5];
    UILabel *numLab5 = [LCTools createLable:@"确认卡号" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [bgView5 addSubview:numLab5];
    _cardField5 = [LCTools createTextField:kFontSize14 borderStyle:UITextBorderStyleNone withPlaceholder:@"请再次确认卡号"];
    _cardField5.keyboardType = UIKeyboardTypeNumberPad;
    [_cardField5 addTarget:self action:@selector(cardField5EndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [bgView5 addSubview:_cardField5];
    [_cardField5 setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [_cardField5 setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    UIButton *OKButton = [LCTools createWordButton:UIButtonTypeCustom title:@"确定" titleColor:[UIColor whiteColor] font:kFontSize14 bgColor:MainColor cornerRadius:5.0f borderColor:nil borderWidth:0.0];
    [OKButton addTarget:self action:@selector(saveBankCard) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:OKButton];

    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.height.equalTo(AutoWHGetHeight(30));
    }];
    
    [bgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.bottom);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.height.equalTo(AutoWHGetHeight(50));
    }];
    
    [numLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView1).offset(20);
        make.centerY.equalTo(bgView1);
    }];
    
    [_cardField1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLab1.right).offset(10);
        make.centerY.equalTo(bgView1);
        make.right.equalTo(bgView1).offset(10);
        make.height.equalTo(bgView1);
    }];

    [bgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView1.bottom).offset(0.7);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.height.equalTo(AutoWHGetHeight(50));
    }];
    
    [numLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView2).offset(20);
        make.centerY.equalTo(bgView2);
    }];
    
    [_cardField2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLab2.right).offset(10);
        make.centerY.equalTo(bgView2);
        make.right.equalTo(bgView2).offset(10);
        make.height.equalTo(bgView2);
    }];
    
    [bgView3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView2.bottom).offset(0.7);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.height.equalTo(AutoWHGetHeight(50));
    }];
    
    [numLab3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView3).offset(20);
        make.centerY.equalTo(bgView3);
    }];
    
    [_cardField3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLab3.right).offset(10);
        make.centerY.equalTo(bgView3);
        make.right.equalTo(bgView3).offset(10);
        make.height.equalTo(bgView3);
    }];

    [bgView4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView3.bottom).offset(10);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.height.equalTo(AutoWHGetHeight(50));
    }];
    
    [numLab4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView4).offset(20);
        make.centerY.equalTo(bgView4);
    }];
    
    [_cardField4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLab4.right).offset(10);
        make.centerY.equalTo(bgView4);
        make.right.equalTo(bgView4).offset(10);
        make.height.equalTo(bgView4);
    }];

    [bgView5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView4.bottom).offset(0.7);
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.height.equalTo(AutoWHGetHeight(50));
    }];
    
    [numLab5 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView5).offset(20);
        make.centerY.equalTo(bgView5);
    }];
    
    [_cardField5 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLab5.right).offset(10);
        make.centerY.equalTo(bgView5);
        make.right.equalTo(bgView5).offset(10);
        make.height.equalTo(bgView5);
    }];
    
    [OKButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView5.bottom).offset(30);
        make.left.equalTo(_contentView).offset(20);
        make.right.equalTo(_contentView).offset(-20);
        make.height.equalTo(AutoWHGetHeight(40));
        
        make.bottom.equalTo(_contentView);
    }];

    
}

- (void)cardField4EndEditing:(UITextField *)textField {
    if (textField.text.length >= 4) {
        realBankNum = YES;
        return;
    }
    else {
        realBankNum = NO;
        [LCAlertTools showTipAlertViewWith:self title:nil message:@"银行卡号长度异常" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
    }
    

}

- (void)cardField5EndEditing:(UITextField *)textField {
    
    if ([_cardField4.text isEqualToString:textField.text]) {
        equalBankNum = YES;
        return;
    }else {
        equalBankNum = NO;
        [LCAlertTools showTipAlertViewWith:self title:nil message:@"银行卡号输入不一致" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];

    };
    
    
}


- (void)saveBankCard {
    if (!([_cardField1.text trueStr]
        && [_cardField2.text trueStr]
        && [_cardField3.text trueStr]
        && [_cardField4.text trueStr]
        && [_cardField5.text trueStr])) {
        //alert
        [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"信息填写不完整" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
        return;
    }
    
    if (realBankNum) {
        [LCAlertTools showTipAlertViewWith:self title:nil message:@"银行卡号长度异常" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
        return;

    }
    else if (equalBankNum) {
        
        [LCAlertTools showTipAlertViewWith:self title:nil message:@"银行卡号输入不一致" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
        return;
    }
    
    NSDictionary *sendDic = @{@"flag":@"insertbank",
                              @"userid":UDSobjectForKey(USERID),
                              @"bankname":_cardField1.text,
                              @"bank":_cardField3.text,
                              @"banknumber":_cardField4.text,
                              @"tel":_cardField2.text};
    [self.view makeToastActivity];
    @WeakObj(self);
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [selfWeak.view hideToastActivity];
        
        if ([responseObject[STATE] integerValue] == 1) {
            
            for (UIViewController *VC in selfWeak.navigationController.viewControllers) {
                if ([VC isKindOfClass:[LCBankCardVC class]]) {
                    [selfWeak.navigationController popToViewController:VC animated:YES];
                }
            }
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak.view hideToastActivity];
        [selfWeak.view makeToast:[error localizedDescription]];
    }];
    
}

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

@end
