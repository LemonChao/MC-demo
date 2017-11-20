//
//  LCFindPasswordVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/14.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCFindPasswordVC.h"
#import "LCTypeNewPasswordVC.h"

@interface LCFindPasswordVC ()
{
    NSInteger counter;
    NSTimer *verifTimer;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *verifCodeField;
@property (weak, nonatomic) IBOutlet UIButton *verifButton;
- (IBAction)verifBtnClick:(id)sender;
- (IBAction)nextStepBtnClick:(id)sender;

@end

@implementation LCFindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"找回密码";
    [_phoneNumField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [verifTimer invalidate];
}
- (void)textChange:(NSNotification *)notif{
    if (_phoneNumField.text.length == 11) {
        //
        _verifButton.enabled = YES;
    }else {
        _verifButton.enabled = NO;
    }
}

- (void)getTimer:(NSTimer *)timer
{
    counter--;
    counter = (counter < 0) ? 0 : counter;
    
    [_verifButton setTitle:[NSString stringWithFormat:@"%d秒重获", counter] forState:UIControlStateNormal];
    _verifButton.enabled = NO;
    
    if (counter == 0)
    {   _phoneNumField.enabled = YES;
        _verifButton.enabled = YES;
        [_verifButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer invalidate];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 找回密码 发送验证码 */
- (IBAction)verifBtnClick:(id)sender {
    NSDictionary *sendDic = @{@"flag":@"GetVerCode",
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
        //show error
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
}

/** 找回密码 验证验证码 */
- (IBAction)nextStepBtnClick:(id)sender {
    
//    if (self.phoneNumField.text) {
//        [self.view makeToast:@"输入号码不能为空" duration:1 position:CSToastPositionCenter];
//        return;
//    }
    
    if (![LCTools isMobileNumber:self.phoneNumField.text]) {
        [self.view makeToast:@"请输入正确的手机号" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    NSDictionary *sendDic = @{@"flag":@"CheckCode",
                              @"phonenumber":self.phoneNumField.text,
                              @"code":self.verifCodeField.text};

    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //next VC
        if ([[responseObject objectForKey:@"state"] integerValue]) {
            
            //stop timer otherwise the VC can't be dealloc right now
            [verifTimer invalidate];
            LCTypeNewPasswordVC *newPasswordVC = [[LCTypeNewPasswordVC alloc] init];
            [self.navigationController pushViewController:newPasswordVC animated:YES];
        }else {
            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //show error
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];

}

- (void)dealloc {
    DLog(@"%@ dealloc", [self class]);
}
@end
