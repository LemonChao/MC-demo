//
//  LCChangeIPVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/24.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCChangeIPVC.h"

@interface LCChangeIPVC ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *detailLab;
@end

@implementation LCChangeIPVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = TabBGColor;
    [self initMainView];
    
}

- (void)initMainView {
    UIView *topBG = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, AutoWHGetHeight(40))];
    topBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBG];
    
    //leftlabel
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.textColor = [UIColor blackColor];
    leftLab.text = @"中心服务器地址";
    leftLab.font = kFontSize15;
    [topBG addSubview:leftLab];
    [leftLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topBG);
        make.left.equalTo(topBG.left).offset(20);
        make.width.equalTo(AutoWHGetWidth(110));
    }];
    
    //textfild
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    [topBG addSubview:textField];
    self.textField = textField;
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topBG);
        make.left.equalTo(leftLab.right).offset(10);
        make.right.equalTo(topBG.right).offset(10);
        make.height.equalTo(35);
    }];
    
    //label
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.textColor = [UIColor lightGrayColor];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.font = kFontSize13;
    detailLab.text = [NSString stringWithFormat:@"%@:%@", leftLab.text, [ActivityApp shareActivityApp].serverIP];
    [self.view addSubview:detailLab];
    self.detailLab = detailLab;
    [detailLab makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.top.equalTo(topBG.bottom).offset(10);
    }];
    
    //button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"更换地址" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeServerIP:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFontSize16;
    [self.view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLab.bottom).offset(30);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(AutoWHGetHeight(40));
    }];
     
    
    
}

- (void)changeServerIP:(UIButton *)button {
    if (_textField.text.length == 0) return;
    [self.view endEditing:YES];
    [ActivityApp shareActivityApp].serverIP = self.textField.text;
    self.detailLab.text = [NSString stringWithFormat:@"中心服务器地址:%@",[ActivityApp shareActivityApp].serverIP];
    DLog(@"serverIP:%@", [ActivityApp shareActivityApp].serverIP);
    [LCAlertTools showTipAlertViewWith:self title:@"更换成功" message:@"请回到主页面刷新重试" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISLOGIN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkLoginToRefreshUI" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
