//
//  LCChangeDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCChangeDetailVC.h"
#import "LCChangeDetailCell.h"
#import "LCWalletModel.h"
#import "MJRefresh.h"

@interface LCChangeDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageIndex;
    NSInteger maxPageNo;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString *cellid = @"changeCell";

@implementation LCChangeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"明细";
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tebleViewRefreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewLoadMoreData)];
    [self.tableView.mj_header beginRefreshing];

    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCChangeDetailCell *cell = [LCChangeDetailCell creatCellWithTableView:tableView reuseid:cellid];
    [cell setValueWithModel:self.dataArray[indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Network

- (void)tebleViewRefreshData {
    pageIndex = 1;
    [self requestForMonerylogisload:NO];
}

- (void)tableViewLoadMoreData {
    if (pageIndex >= maxPageNo) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    pageIndex++;
    [self requestForMonerylogisload:YES];
}

/** 查询零钱明细 */
- (void)requestForMonerylogisload:(BOOL)isload {
    
    NSDictionary *sendDic = @{@"flag":@"searchMonerylog",
                              @"changeid":self.changeid,
                              @"pageNo":@(pageIndex),
                              @"pageSize":@"10"};
    
    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[STATE] integerValue] == 1) {
            [self convertModelWith:responseObject isload:isload];
        }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view makeToast:[error localizedDescription]];
    }];
    
}

- (void)convertModelWith:(id)respons isload:(BOOL)isload {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in respons[DATA]) {
        LCTradRecordModel *model = [LCTradRecordModel yy_modelWithDictionary:dic];
        [tempArray addObject:model];
    }
    
    maxPageNo = tempArray.count == 10 ? pageIndex+1 : pageIndex;
    
    if (isload) {
        [self.dataArray addObjectsFromArray:tempArray];
    }else {
        [self.dataArray setArray:tempArray];
    }
    [self.tableView reloadData];
    
}

@end
