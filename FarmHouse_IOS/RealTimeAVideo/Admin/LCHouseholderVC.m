//
//  LCHouseholderVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/26.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCHouseholderVC.h"
#import "LCFarmDetailVC.h" //新增户主 web
#import "LCGatherInfoVC.h"
#import "MJRefresh.h"
#import "LCNonghuInfoVC.h" //nognhu 详情


@interface LCHouseholderVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageIndex;
    NSInteger maxPageNo;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString *cellID = @"TableViewCell";

@implementation LCHouseholderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
//    [self creatData];
    [self initMainViews];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tebleViewRefreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewLoadMoreData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initMainViews {
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addNewFarmCount)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];

    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.contentMode = UIViewContentModeBottomLeft;
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.tintColor = [UIColor lightGrayColor];
    _searchBar.placeholder = @"输入户主姓名进行查询";
    self.navigationItem.titleView = _searchBar;
    
}

- (void)addNewFarmCount {
    LCGatherInfoVC *gatherVC = [[LCGatherInfoVC alloc] init];
    gatherVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gatherVC animated:YES];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCHouseholderModel *model = self.dataArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     LCHouseholderModel *houseModel = self.dataArray[indexPath.row];
    if (_isChoose) {
        if (_chooseBlcok) {
            _chooseBlcok(houseModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
//        LCFarmDetailVC *detailVC = [[LCFarmDetailVC alloc] init];
//        detailVC.hidesBottomBarWhenPushed = YES;
//        detailVC.hholdeModel = houseModel;
//        [self.navigationController pushViewController:detailVC animated:YES];
        LCHouseHoldModel *houseHold = [[LCHouseHoldModel alloc] init];
        houseHold.name = houseModel.name;
        houseHold.address = houseModel.address;
        houseHold.nhid = houseModel.masterid;

        LCNonghuInfoVC *vc = [[LCNonghuInfoVC alloc] init];
        vc.houseHold = houseHold;
        @WeakObj(self);
        vc.refreshBlock = ^(){
            [selfWeak tebleViewRefreshData];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    DLog(@"%@--%@",_searchBar.text, searchText);
    [self tableViewRequestIsLoad:NO];
}



#pragma mark - Network
- (void)tebleViewRefreshData {
    pageIndex = 1;
    [self tableViewRequestIsLoad:NO];
}

- (void)tableViewLoadMoreData {
    if (pageIndex > maxPageNo) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }

    pageIndex ++;
    [self tableViewRequestIsLoad:YES];
}


- (void)tableViewRequestIsLoad:(BOOL)isload {
    NSDictionary *sendDic = @{@"flag":@"searchFarmerBasicInfo",
                              @"name":_searchBar.text?_searchBar.text:@" ",
                              @"userId":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@" ",
                              @"pageNo":@(pageIndex),
                              @"pageSize":@"10"};
    DLog(@"dic=%@", sendDic);
    [LCAFNetWork POST:@"farmerBasicInfo" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([responseObject[STATE] intValue] == 1) {
            maxPageNo = pageIndex;
            [self convertIntoModelWithData:responseObject isload:isload];
        }else {
            [self.view makeToast:responseObject[MESSAGE] duration:1.0 position:CSToastPositionCenter];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"error==%@", [error localizedDescription]);
    }];
}

- (void)convertIntoModelWithData:(id)reponse isload:(BOOL)isload {
    NSMutableArray *tempArray = [NSMutableArray array];

    for (NSDictionary *dic in reponse[@"data"]) {
        LCHouseholderModel *model = [LCHouseholderModel yy_modelWithDictionary:dic];
        [tempArray addObject:model];
    }
    DLog(@"tempArr%@", tempArray);
    if (isload) {
        [self.dataArray addObjectsFromArray:tempArray];
    }else {
        [self.dataArray setArray:tempArray];
    }
    [self.tableView reloadData];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
