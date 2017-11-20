//
//  LCLonginVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/12.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCLonginVC.h"
#import "LCRegisterVC.h"
#import "LCFindPasswordVC.h"
#import "UUID.h"
#import "NSString+md5String.h"

@interface LCLonginVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;

@end

@implementation LCLonginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登陆";

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
}

- (IBAction)loginBtnClick:(id)sender {
    
    NSDictionary *senDic = @{@"flag":@"Login",
                             @"phonenumber":self.phoneNumField.text,
                             @"password":[NSString md5String:self.passWordField.text],
                             @"device_number":[UUID getDeviceNum]};
    [self.view makeToastActivity];
    [LCAFNetWork POST:ewlWebServerUser params:senDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //pop back to last VC
        [self.view hideToastActivity];
        if ([[responseObject objectForKey:@"state"] integerValue]) {
            NSDictionary *dic = [[responseObject objectForKey:@"data"] copy];
            
            NSString *userid = [NSString stringWithFormat:@"%@", dic[@"id"]];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"sessid"] forKey:SESSID];
            [[NSUserDefaults standardUserDefaults] setObject:userid forKey:USERID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISLOGIN];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:USERINFO];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkLoginToRefreshUI" object:nil];
            
            DLog(@"data = %@", dic);
        }else {
            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view hideToastActivity];

        //show alert view
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
}

- (void)registBtnClick:(id)sender {
    LCRegisterVC *registVC = [[LCRegisterVC alloc] init];
    registVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registVC animated:YES];
    
}

- (IBAction)findPasswordBtnClick:(id)sender {
    LCFindPasswordVC *findVC = [[LCFindPasswordVC alloc] init];
    findVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findVC animated:YES];
}

- (void)dealloc {
    DLog(@"%@ class dealloc", [self class]);
}


@end
