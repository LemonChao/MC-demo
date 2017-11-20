//
//  LCFindVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCFindVC.h"
#import "LCShopingWebVC.h"


@interface LCFindVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) NSMutableArray *imgArray;

@end

static NSString *cellid = @"findListCell";
@implementation LCFindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@[@"资讯"],
                       @[@"投保",@"游戏"],
                       @[@"团购",@"交易"],
                       @[@"信用"]].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = @[@[@"find_news"],
                      @[@"find_insurance",@"find_game"],
                      @[@"find_shopping",@"find_trade"],
                      @[@"find_credit"]].mutableCopy;
    }
    return _imgArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TabBGColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imgArray[indexPath.section][indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        LCShopingWebVC *webVC = [[LCShopingWebVC alloc] init];
        webVC.type = FindColumnWebGame;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else {
        
        LCShopingWebVC *webVC = [[LCShopingWebVC alloc] init];
        webVC.type = FindColumnWebShoping;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];

    }
    
}


@end
