//
//  LCRegisterVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/14.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCRegisterVC.h"
#import "NSString+md5String.h"

@interface LCRegisterVC ()
{
    NSInteger counter;
    NSTimer  *verifTimer;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *verifCode;
@property (weak, nonatomic) IBOutlet UIButton *verifButton;
@property (weak, nonatomic) IBOutlet UITextField *passWorldField;
@property (weak, nonatomic) IBOutlet UITextField *passWorldAgain;
@property (weak, nonatomic) IBOutlet UITextField *inviteFeild;
- (IBAction)registBtnClick:(id)sender;
- (IBAction)verifButtonClick:(id)sender;

@end

@implementation LCRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    [_phoneNumField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [verifTimer invalidate];
}

- (void)textChange:(NSNotification *)notif {
    if (_phoneNumField.text.length == 11) {
        _verifButton.enabled = YES;
    }else {
        _verifButton.enabled = NO;
    }
}

- (void)getTimer:(NSTimer *)timer {

    counter--;
    counter = (counter < 0) ? 0 : counter;
    
    [_verifButton setTitle:[NSString stringWithFormat:@"%ld秒重获", counter] forState:UIControlStateNormal];
    _verifButton.enabled = NO;
    
    if (counter == 0)
    {   _phoneNumField.enabled = YES;
        _verifButton.enabled = YES;
        [_verifButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer invalidate];
    }

}

/** 注册 */
- (IBAction)registBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    if (![self.passWorldField.text isEqualToString:self.passWorldAgain.text]) {
        [self.view makeToast:@"两次输入密码不一致" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    NSDictionary *sendDic = @{@"flag":@"RegisterUser",
                              @"phonenumber":self.phoneNumField.text,
                              @"code":self.verifCode.text,
                              @"password":[NSString md5String:self.passWorldField.text],
                              @"invitecode":self.inviteFeild.text};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //pop back to loginVC
        
        if ([[responseObject objectForKey:@"state"] integerValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
}

/** 获取验证码 */
- (IBAction)verifButtonClick:(id)sender {
    
    //校验手机号码
    if (![LCTools isMobileNumber:self.phoneNumField.text]) {
        
        [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"手机号不正确\n请输入正确的手机号" buttonTitle:nil buttonStyle:UIAlertActionStyleDefault];
        return;
    }
    
    
    NSDictionary *sendDic = @{@"flag":@"GetCode",
                              @"phonenumber":self.phoneNumField.text};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //60S 限制
        if ([[responseObject objectForKey:@"state"] integerValue]) {
            verifTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getTimer:) userInfo:nil repeats:YES];
            counter = 60;
            _phoneNumField.enabled = NO;
            _verifButton.enabled = NO;
        }else {
            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
}

- (void)dealloc {
    DLog(@"%@ dealloc", [self class]);
}

@end
