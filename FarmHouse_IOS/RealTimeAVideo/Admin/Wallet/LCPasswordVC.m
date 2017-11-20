//
//  LCPasswordVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPasswordVC.h"
#import "LCInputKeyWordView.h"
#import "LCAddBankCard.h"
#import "NSString+md5String.h"
#import "LCWalletVC.h"


@interface LCPasswordVC ()<WCLPassWordViewDelegate>
{
    NSString *titleString;
}

@property(nonatomic, strong)LCInputKeyWordView *keywordView;
@end

@implementation LCPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.type == PasswordVerification || self.type == PasswordRemoveBinding || self.type == PasswordAddNewCard) {
        self.title = @"验证密码";
        titleString = @"请输入密码，已验证身份";
    }
    else if (self.type == PasswordNew) {
        self.title = @"请输入新密码";
        titleString = @"请输入新密码";
    }
    else if (self.type == PasswordAgain) {
        titleString = @"请再次输入密码";
    }
    else if (self.type == PasswordReset) {
        self.title = @"修改密码";
        titleString = @"请输入旧密码，已验证身份";
    }
    
    
    [self createPasswordUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.keywordView.passWordView empty];
}

- (void)createPasswordUI {
    
    self.keywordView = [LCInputKeyWordView initFromeNibWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 170)];
    _keywordView.title.text = titleString;
    _keywordView.passWordView.delegate = self;
    [self.view addSubview:_keywordView];
    
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
    NSLog(@"+++++++密码输入完成:%@", passWord.textStore);
    
    if (self.type == PasswordRemoveBinding) {
        
        [self removeBindPassword:passWord];
    }
    else if (self.type == PasswordAddNewCard) {
        
        [self verificationPassword:passWord];//添加银行卡
    }
    else if (self.type == PasswordNew) {
        
        LCPasswordVC *vcNew = [[LCPasswordVC alloc] init];
        vcNew.infoString = passWord.textStore;
        vcNew.type = PasswordAgain;
        [self.navigationController pushViewController:vcNew animated:YES];
        
    }
    else if (self.type == PasswordAgain) {
        
        if ([passWord.textStore isEqualToString:self.infoString]) {
            [self insertOrResetPassword];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.type == PasswordReset) {
        
        @WeakObj(self);
        [self verificationForReset:passWord success:^{
            
            [selfWeak resetForNewPassword];
            
        }];
    }
}

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(WCLPassWordView *)passWord {
    NSLog(@"-------密码开始输入");
}

#pragma mark - Netword

/** 验证密码正确性 */
- (void)verificationPassword:(WCLPassWordView *)passwordView {
    NSDictionary *send = @{@"flag":@"checkChangePassword",
                           @"userid":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"",
                           @"password":[NSString md5String:passwordView.textStore]};
    
    [self.view makeToastActivity];
    
    @WeakObj(self);
    [LCAFNetWork POST:@"monery" params:send success:^(NSURLSessionDataTask *task, id responseObject) {
        [selfWeak.view hideToastActivity];
        if ([responseObject[STATE] integerValue] == 1) {
            
            LCAddBankCard *addBank = [[LCAddBankCard alloc] init];
            addBank.type = AddBankcardNewCard;
            addBank.hidesBottomBarWhenPushed = YES;
            [selfWeak.navigationController pushViewController:addBank animated:YES];
        }else {
            
            [LCAlertTools showTipAlertViewWith:selfWeak title:@"提 示" message:@"密码不正确" cancelTitle:@"重试" defaultTitle:@"忘记密码" cancelHandler:^{// 重试
                
                [passwordView empty];
                
            } defaultHandler:^{// 找回密码
                
                LCAddBankCard *addBank = [[LCAddBankCard alloc] init];
                addBank.type = AddBankcardCerifCode;
                addBank.hidesBottomBarWhenPushed = YES;
                [selfWeak.navigationController pushViewController:addBank animated:YES];

            }];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak.view hideToastActivity];

        [self.view makeToast:[error localizedDescription]];
    }];
}


- (void)removeBindPassword:(WCLPassWordView *)passwordView {
    NSDictionary *send = @{@"flag":@"checkChangePassword",
                           @"userid":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"",
                           @"password":[NSString md5String:passwordView.textStore]};
    
    [self.view makeToastActivity];
    
    @WeakObj(self);
    [LCAFNetWork POST:@"monery" params:send success:^(NSURLSessionDataTask *task, id responseObject) {
        [selfWeak.view hideToastActivity];
        if ([responseObject[STATE] integerValue] == 1) {
            
            [selfWeak deleteCard];
        }else {
            
            [LCAlertTools showTipAlertViewWith:selfWeak title:@"提 示" message:@"密码不正确" cancelTitle:@"重试" defaultTitle:@"忘记密码" cancelHandler:^{// 重试
                
                [passwordView empty];
                
            } defaultHandler:^{// 找回密码
                
                LCAddBankCard *addBank = [[LCAddBankCard alloc] init];
                addBank.type = AddBankcardCerifCode;
                addBank.hidesBottomBarWhenPushed = YES;
                [selfWeak.navigationController pushViewController:addBank animated:YES];
                
            }];

        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak.view hideToastActivity];
        
        [self.view makeToast:[error localizedDescription]];
    }];
}


- (void)deleteCard {
    NSDictionary *sendDic = @{@"flag":@"delbanktable",
                              @"id":self.infoString};
    
    [self.view makeToastActivity];
    @WeakObj(self);
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [selfWeak.view hideToastActivity];
        [selfWeak.view makeToast:@"shangchusdfn"];

        if ([responseObject[STATE] integerValue] == 1) {
            [selfWeak.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak.view makeToast:[error localizedDescription]];
    }];
    
}

/** 找回密码二次确认 */
- (void)verificationForFindBackPassword:(WCLPassWordView *)passwordView {
    
    
    if ([passwordView.textStore isEqualToString:self.infoString]) {
        [self insertOrResetPassword];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}

/** 添加/修改(找回)银行卡密码 */
- (void)insertOrResetPassword {
    
    NSDictionary *sendDic = @{@"flag":@"insertchange",
                              @"userid":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"",
                              @"password":[NSString md5String:self.infoString]};
    
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[STATE] integerValue] == 1) {
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LCWalletVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    [[UIApplication sharedApplication].keyWindow makeToast:@"修改密码成功"];
                    break;
                }
            }
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:[error localizedDescription]];
    }];
    
}

/** 验证密码正确性 for reset */
- (void)verificationForReset:(WCLPassWordView *)passwordView success:(void(^)()) success {
    NSDictionary *send = @{@"flag":@"checkChangePassword",
                           @"userid":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"",
                           @"password":[NSString md5String:passwordView.textStore]};
    
    [self.view makeToastActivity];
    
    @WeakObj(self);
    [LCAFNetWork POST:@"monery" params:send success:^(NSURLSessionDataTask *task, id responseObject) {
        [selfWeak.view hideToastActivity];
        if ([responseObject[STATE] integerValue] == 1) {
            
            success();
            
        }else {
            
            [LCAlertTools showTipAlertViewWith:selfWeak title:@"提 示" message:@"密码不正确" cancelTitle:@"重试" defaultTitle:@"忘记密码" cancelHandler:^{// 重试
                
                [passwordView empty];
                
            } defaultHandler:^{// 找回密码
                
                LCAddBankCard *addBank = [[LCAddBankCard alloc] init];
                addBank.type = AddBankcardCerifCode;
                addBank.hidesBottomBarWhenPushed = YES;
                [selfWeak.navigationController pushViewController:addBank animated:YES];
                
            }];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak.view hideToastActivity];
        
        [self.view makeToast:[error localizedDescription]];
    }];
}


- (void)resetForNewPassword {
    [self.keywordView.passWordView empty];
    self.keywordView.title.text = @"设置新的提现密码";
    self.type = PasswordNew;
    
}

@end
