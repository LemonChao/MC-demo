//
//  LCTypeNewPasswordVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/16.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCTypeNewPasswordVC.h"
#import "LCLonginVC.h"
#import "NSString+md5String.h"

@interface LCTypeNewPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;
- (IBAction)OKButtonClick:(id)sender;

@end

@implementation LCTypeNewPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (IBAction)OKButtonClick:(id)sender {
    [self.view endEditing:YES];

    
    if (!(self.phoneNumField.text || self.passwordNewField.text || self.passwordAgainField.text)) {
        [self.view makeToast:@"输入不能为空" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    if (![LCTools isMobileNumber:self.phoneNumField.text]) {
        [self.view makeToast:@"请输入正确的手机号" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    if (![self.passwordNewField.text isEqualToString:self.passwordAgainField.text]) {
        //show alert
        [self.view makeToast:@"两次输入的密码不一致" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    NSDictionary *sendDic = @{@"flag":@"ChangePass",
                              @"phonenumber":self.phoneNumField.text,
                              @"password":[NSString md5String:self.passwordNewField.text]};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //navigation to loginVC; myVC->loginVC->findPasswordVC->newPasswordVC(self)
        for (UIViewController *tempVC in self.navigationController.viewControllers) {
            
            if ([[responseObject objectForKey:@"state"] integerValue]) {
                if ([tempVC isKindOfClass:[LCLonginVC class]]) {
                    [self.navigationController popToViewController:tempVC animated:YES];
                    break;//跳出整个for in 不再遍历
                }
            }else {
                [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
            }
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //show error
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
}

@end
