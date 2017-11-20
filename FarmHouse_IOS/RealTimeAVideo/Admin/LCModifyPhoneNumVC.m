//
//  LCModifyPhoneNumVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/18.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCModifyPhoneNumVC.h"
#import "LCLonginVC.h"

@interface LCModifyPhoneNumVC ()
{
    NSInteger counter;
    NSTimer  *verifTimer;
    NSString *userid;
    NSString *sessid;
    
    NSDictionary *infoDic;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *verifCodeField;
@property (weak, nonatomic) IBOutlet UIButton *verifCodeBtn;
- (IBAction)verifCodeButtonClick:(id)sender;
- (IBAction)OKButtonClick:(id)sender;

@end

@implementation LCModifyPhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    infoDic = UDSobjectForKey(USERINFO);
    NSLog(@"userid = %@", infoDic[@"id"]);
    [_phoneNumField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChange:(NSNotification *)notif {
    if (_phoneNumField.text.length == 11) {
        _verifCodeBtn.enabled = YES;
    }else {
        _verifCodeBtn.enabled = NO;
    }
}

- (void)getTimer:(NSTimer *)timer {
    
    counter--;
    counter = (counter < 0) ? 0 : counter;
    
    [_verifCodeBtn setTitle:[NSString stringWithFormat:@"%d秒重获", counter] forState:UIControlStateNormal];
    _verifCodeBtn.enabled = NO;
    
    if (counter == 0)
    {
        _phoneNumField.enabled = YES;
        _verifCodeBtn.enabled = YES;
        [_verifCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer invalidate];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [verifTimer invalidate];
}

/** get verification code */
- (IBAction)verifCodeButtonClick:(id)sender {
    
    NSDictionary *sendDic = @{@"flag":@"SendtoNew",
                              USERID:UDSobjectForKey(USERID),
                              SESSID:UDSobjectForKey(SESSID),
                              @"newphonenumber":self.phoneNumField.text};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //60S 限制
        if ([[responseObject objectForKey:@"state"] integerValue]) {
            verifTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getTimer:) userInfo:nil repeats:YES];
            counter = 60;
            _phoneNumField.enabled = NO;
            _verifCodeBtn.enabled = NO;
        }else {
            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
    
}

- (IBAction)OKButtonClick:(id)sender {
    
    NSDictionary *sendDic = @{@"flag":@"ChangeForNew",
                              USERID:infoDic[@"id"],
                              SESSID:UDSobjectForKey(SESSID),
                              @"newphonenumber":self.phoneNumField.text,
                              @"code":self.verifCodeField.text};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        DLog(@"sendDic=%@", sendDic);
        
        [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];

        if ([responseObject objectForKey:@"state"]) {
            
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[LCLonginVC class]]) {
                    
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@ Class dealloced", [self class]);
}

@end
