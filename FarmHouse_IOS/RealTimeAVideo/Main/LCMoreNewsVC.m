//
//  LCMoreNewsVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/24.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCMoreNewsVC.h"
#import "UITableView+EXT.h"
#import "LCNewsCell.h"
#import "LCFarmNewsDetailVC.h"
#import "MJRefresh.h"


@interface LCMoreNewsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageIndex;
}
@property (nonatomic, strong) UITableView *myTabelView;

@property (nonatomic, strong) NSMutableArray *mdataArr;

@end

static NSString *cellID = @"moreNews";

@implementation LCMoreNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mdataArr = [NSMutableArray array];
    [self.view addSubview:self.myTabelView];
    
    self.myTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tebleViewRefresh)];
    self.myTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewLoadMore)];
    [self.myTabelView.mj_header beginRefreshing];
}


- (UITableView *)myTabelView {
    if (!_myTabelView) {
        self.myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStylePlain];
        _myTabelView.delegate = self;
        _myTabelView.dataSource = self;
        _myTabelView.tableFooterView = [UIView new];
//        [_myTabelView cellEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [_myTabelView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    return _myTabelView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mdataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return AutoWHGetHeight(NewsCellH)+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCFarmNewsModel *model = self.mdataArr[indexPath.row];
    LCNewsCell *cell = [LCNewsCell creatCellWithTableView:tableView reuseIdentifier:cellID];
    [cell setValueWithModel:model];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCFarmNewsModel *newsModel = self.mdataArr[indexPath.row];
    LCFarmNewsDetailVC *detailVC = [[LCFarmNewsDetailVC alloc] init];
    detailVC.newsid = newsModel.newsid;
    [self.navigationController pushViewController:detailVC animated:YES];

}

#pragma mark - NetworkRequest

- (void)tebleViewRefresh {
    pageIndex = 1;
    
    [self tableViewRequestIsLoad:NO];
}

- (void)tableViewLoadMore {
    pageIndex++;
    
    [self tableViewRequestIsLoad:YES];
}

/** 新闻列表 */
- (void)tableViewRequestIsLoad:(BOOL)isload {
    NSDictionary *sendDic = @{@"pageSize":@"10",
                              @"pageNo":@(pageIndex)};
    [LCAFNetWork POST:@"news" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.myTabelView.mj_header endRefreshing];
        [self.myTabelView.mj_footer endRefreshing];
        
        if ([responseObject[STATE] intValue]==1) {
            
            [self convertIntoModelWithData:responseObject isload:isload];
        }else {
            [self.view makeToast:responseObject[MESSAGE] duration:1.0 position:CSToastPositionCenter];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.myTabelView.mj_header endRefreshing];
        [self.myTabelView.mj_footer endRefreshing];
        [self.view makeToast:[error localizedDescription]];
    }];
}

- (void)convertIntoModelWithData:(id)reponse isload:(BOOL)isload {
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *dic in reponse[@"data"]) {
        LCFarmNewsModel *model = [LCFarmNewsModel yy_modelWithDictionary:dic];
        [tempArray addObject:model];
    }
//    DLog(@"tempArr%@", tempArray);
    if (isload) {
        [self.mdataArr addObjectsFromArray:tempArray];
    }else {
        [self.mdataArr setArray:tempArray];
    }
    [self.myTabelView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
