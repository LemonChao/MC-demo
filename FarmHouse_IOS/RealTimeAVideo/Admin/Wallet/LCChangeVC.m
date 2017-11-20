//
//  LCChangeVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCChangeVC.h"
#import "LCWithdrawVC.h"
#import "LCChangeDetailVC.h"
#import "LCWalletModel.h"
#import "LCBankCardVC.h"

@interface LCChangeVC ()
{
    NSString *_userid;
    BOOL hasCard;
    UILabel *numLab;
}

@property(nonatomic, strong)LCChangeModel *changeModle;

@end

@implementation LCChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _userid = UDSobjectForKey(USERID);
    self.title = @"零钱";
    
    self.view.backgroundColor = TabBGColor;

    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self creatMainView];
    
    [self requestForChange];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self performSelectorInBackground:@selector(requestForBankCard) withObject:nil];
    
}

- (void)creatMainView {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_change_small"]];
    [bgView addSubview:imgView];
    
    UILabel *titleLab = [LCTools createLable:@"零钱余额" withFont:kFontSize13 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
//    titleLab.backgroundColor = [UIColor redColor];
    [bgView addSubview:titleLab];
    
    numLab = [LCTools createLable:@"¥ ***" withFont:kFontSizeBold18 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
//    numLab.backgroundColor = [UIColor cyanColor];
    [bgView addSubview:numLab];
    
    UIButton *OKButton = [LCTools createWordButton:UIButtonTypeCustom title:@"提现" titleColor:[UIColor whiteColor] font:kFontSize17 bgColor:MainColor cornerRadius:5.0f borderColor:nil borderWidth:0.0];
    [OKButton addTarget:self action:@selector(OKButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:OKButton];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view.width).multipliedBy(0.48);
    }];
    
    [numLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.bottom);
        make.centerX.equalTo(bgView);
        make.height.equalTo(AutoWHGetHeight(25));
    }];
    
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(numLab.top);
        make.centerX.equalTo(bgView);
        make.height.equalTo(AutoWHGetHeight(15));
        make.top.equalTo(imgView.bottom).offset(20);
    }];
    
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.height.equalTo(AutoWHGetHeight(60));
        make.width.equalTo(imgView.height);
    }];
    
    [OKButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(AutoWHGetHeight(40));
    }];
    
}

- (void)OKButtonAction:(UIButton *)button {
    
    if (hasCard) {
        
        LCWithdrawVC *withdraw = [[LCWithdrawVC alloc] init];
        @WeakObj(self);
        withdraw.refreshBlock = ^(){
            [selfWeak requestForChange];
        };
        withdraw.totalAmout = self.changeModle.monery;
        withdraw.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:withdraw animated:YES];
    }
    else {
        [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"添加提现使用的储蓄卡" cancelTitle:@"添加" cancelHandler:^{
            LCBankCardVC *bankCard = [[LCBankCardVC alloc] init];
            [self.navigationController pushViewController:bankCard animated:YES];
        }];
    }
    
}

- (void)rightBarItemClick {
    LCChangeDetailVC *changeDetail = [[LCChangeDetailVC alloc] init];
    changeDetail.changeid = self.changeModle.primaryid;
    changeDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeDetail animated:YES];
}

/** 查询账户余额 */
- (void)requestForChange {
    NSDictionary *sendDic = @{@"flag":@"searchChange",
                              @"userid":_userid};
    [self.view makeToastActivity];
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.view hideToastActivity];

        if ([responseObject[STATE] intValue] == 1) {
            self.changeModle = [LCChangeModel yy_modelWithDictionary:responseObject[DATA]];
            
            numLab.text = StrFormat(@"¥ %@", self.changeModle.monery);
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view hideToastActivity];

    }];
    
}

/** 查询银行卡信息 */
- (void)requestForBankCard {
    
    NSDictionary *sendDic = @{@"flag":@"changeandbank",
                              @"userid":_userid};
    
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[STATE] integerValue] == 1) {
            hasCard = YES;
        }else {
            hasCard = NO;
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        hasCard = NO;
    }];

}



@end
