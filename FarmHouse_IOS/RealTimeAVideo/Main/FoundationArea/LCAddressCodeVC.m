//
//  LCAddressCodeVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/11/17.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCAddressCodeVC.h"
#import "LCAddressCodePick.h"
#import "LCChargeListVC.h"

@interface LCAddressCodeVC ()

@property(nonatomic, strong) UIButton *addressBtn;

@property(nonatomic, strong) NSString *location;

@end

@implementation LCAddressCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    self.view.backgroundColor = TabBGColor;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *titleLab = [LCTools createLable:@"报案地址" withFont:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    titleLab.backgroundColor = [UIColor cyanColor];
    [view addSubview:titleLab];
    
    [view addSubview:self.addressBtn];
    
    UIButton *nextStep = [LCTools createWordButton:UIButtonTypeCustom title:@"下一步" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:19] bgColor:MainColor cornerRadius:3.0 borderColor:nil borderWidth:0];
    [nextStep addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStep];
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(60);
    }];
    
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.bottom.equalTo(view);
        make.left.equalTo(view);
        make.width.equalTo(100);
    }];
    
    [_addressBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.right);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
        make.right.equalTo(view);
    }];
    
    [nextStep makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.bottom).offset(110);
        make.height.equalTo(45);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
}

- (UIButton *)addressBtn {
    if (!_addressBtn) {
        _addressBtn = [LCTools createWordButton:UIButtonTypeCustom title:nil titleColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:17] bgColor:[UIColor redColor]];
        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addressBtn addTarget:self action:@selector(addressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressBtn;
}

- (void)addressButtonClick:(UIButton *)button {
    
    LCAddressCodePick *picker = [[LCAddressCodePick alloc] initWithTWFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT) TWselectCityTitle:@"选择地区"];
    
    [picker showCityView:^(NSString *proviceStr, NSString *cityStr, NSDictionary *distDic) {
        NSString *district = distDic[@"name"];
        self.location = distDic[@"location"];
        [self.addressBtn setTitle:StrFormat(@"%@ %@ %@",proviceStr, cityStr, district) forState:UIControlStateNormal];
        
    }];
    
    
}

/** 请求设备号 */
- (void)requestDeviceCode {
    
    if (self.location == nil) return;
    NSDictionary *sendDic = @{@"flag":@"appdevicecodeL",
                              @"location":self.location,
                              USERID:UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@" "};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        if ([responseObject[STATE] integerValue]) {
//            NSString *numStrign = responseObject[@"data"];
//            
//            [[ActivityApp shareActivityApp] resetlibDeviceNum:[numStrign intValue]];
//        }
        
        NSLog(@"response %@", responseObject);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:[error localizedDescription] duration:1.0 position:CSToastPositionCenter];
    }];
    
}


- (void)nextStepAction:(UIButton *)button {
    
    [self requestDeviceCode];
    
    LCChargeListVC *chargeVC = [[LCChargeListVC alloc] init];
    chargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chargeVC animated:YES];
    
}


@end
