//
//  LCWithDrawManager.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/26.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCWithDrawManager.h"
#import "LCPasswordVC.h"
#import "LCAddBankCard.h"

@interface LCWithDrawManager ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString *cellid = @"systemcell";
@implementation LCWithDrawManager

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现管理";
    self.dataArray = @[@"修改提现密码",@"忘记提现密码"].mutableCopy;
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellid];
        _tableView.backgroundColor = TabBGColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        LCPasswordVC *vc = [[LCPasswordVC alloc] init];
        vc.type = PasswordReset;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        LCAddBankCard *addVC = [[LCAddBankCard alloc] init];
        addVC.type = AddBankcardCerifCode;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}



@end
