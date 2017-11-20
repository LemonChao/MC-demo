//
//  LCBankCardVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCBankCardVC.h"
#import "LCBankCardCell.h"
#import "LCPasswordVC.h"
#import "LCAddBankCard.h"
#import "LCWalletModel.h"


@interface LCBankCardVC ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL hasPassword; //用户是否设置有密码
    BOOL hasBankCard; //用户是否绑定有银行卡
}
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIToolbar *toolBar;

@property(nonatomic, strong) NSMutableArray *dataArray;

@end


static NSString *cellid = @"BankCardCell";
static NSString *systemCell = @"systemCell";
@implementation LCBankCardVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(ishavePassword) withObject:nil];
    
    [self requestBankCardAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TabBGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHT-64-44, SCREEN_WIDTH, 44)];
        _toolBar.tintColor = [UIColor lightGrayColor];
        _toolBar.translucent = YES;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"解除绑定" style:UIBarButtonItemStyleDone target:self action:@selector(removeBinding)];
        UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        [_toolBar setItems:@[leftSpace,item,leftSpace]];
    }
    return _toolBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (hasBankCard) {
        LCBankCardCell *cell = [LCBankCardCell creatCellWithTableView:tableView reuseid:cellid];
        [cell setValueWith:self.dataArray[indexPath.row]];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCell];
        }
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.imageView.image = [UIImage imageNamed:@"wallet_addCard"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"添加银行卡";
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return hasBankCard ? 100 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (hasBankCard) {
        @WeakObj(self);
        NSArray *titleArr = @[@"解除绑定"];
        NSArray *styleArr = @[[NSNumber numberWithInteger:UIAlertActionStyleDefault]];

        [LCAlertTools showActionSheetWith:self title:nil message:nil cancelButtonTitle:@"取消" actionTitleArray:titleArr actionStyleArray:styleArr cancelHandler:nil callbackBlock:^(NSInteger actionIndex) {
            LCBankCardModel *model = self.dataArray[indexPath.row];
            LCPasswordVC *passwordVC = [[LCPasswordVC alloc] init];
            passwordVC.type = PasswordRemoveBinding;
            passwordVC.infoString = model.primaryid;
            [selfWeak.navigationController pushViewController:passwordVC animated:YES];

        }];
        
        
    }else {
        
        if (hasPassword) {
            LCPasswordVC *passwordVC = [[LCPasswordVC alloc] init];
            passwordVC.type = PasswordAddNewCard;
            [self.navigationController pushViewController:passwordVC animated:YES];
            
        }else {
            
            [LCAlertTools showTipAlertViewWith:self title:nil message:@"未设置提现密码，是否现在设置" cancelTitle:@"设置提现密码" cancelHandler:^{
                LCAddBankCard *addBank = [[LCAddBankCard alloc] init];
                addBank.type = AddBankcardCerifCode;
                addBank.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addBank animated:YES];
                
            }];
            
        }
        
    }
    
    
}



- (void)removeBinding {
    
    LCPasswordVC *passwordVC = [[LCPasswordVC alloc] init];
    
    [self.navigationController pushViewController:passwordVC animated:YES];
}

#pragma mark - Network

/** 查询银行卡全部信息 searchbanktable*/
- (void)requestBankCardAll {
    
    NSDictionary *sendDic = @{@"flag":@"searchbanktable",
                              @"userid":UDSobjectForKey(USERID)};
    
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *tempArray = [NSMutableArray array];

        if ([responseObject[STATE] intValue] == 1) {
            
            for (NSDictionary *dic in responseObject[DATA]) {
                LCBankCardModel *model = [LCBankCardModel yy_modelWithDictionary:dic];
                [tempArray addObject:model];
            }
            hasBankCard = YES;
            
        }else {
            LCBankCardModel *model = [LCBankCardModel new];
            [tempArray addObject:model];

            hasBankCard = NO;
        }
        [self.dataArray setArray:tempArray];
        [self.tableView reloadData];

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:[error localizedDescription]];
    }];
    
}



- (void)ishavePassword {
    NSDictionary *sendDic = @{@"flag":@"checkpwdflag",
                              @"userid":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@""};
    
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[STATE] intValue] == 1) {
            hasPassword = YES;
        }else {
            hasPassword = NO;
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


@end
