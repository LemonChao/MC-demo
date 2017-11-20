//
//  LCModifyPasswordVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/18.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCModifyPasswordVC.h"
#import "LCLonginVC.h"
#import "NSString+md5String.h"

@interface LCModifyPasswordVC ()
{
    NSDictionary *infoDic;
}
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;
- (IBAction)modifyPasswordBtnClick:(id)sender;

@end

@implementation LCModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    infoDic = UDSobjectForKey(USERINFO);
}


- (IBAction)modifyPasswordBtnClick:(id)sender {
    
    NSDictionary *sendDic = @{@"flag":@"ChangeUser",
                              USERID:UDSobjectForKey(USERID),
                              SESSID:UDSobjectForKey(SESSID),
                              @"password":[NSString md5String:self.oldPasswordField.text],
                              @"password1":[NSString md5String:self.passwordAgainField.text]};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if ([responseObject objectForKey:@"state"]) {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[LCLonginVC class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
        
        [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
