//
//  LCSearchVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/20.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCSearchVC.h"
#import "LCSearchListCell.h"
#import "MJRefresh.h"
#import "LCCaseInfoVC.h"
#import "LCSearchModel.h"
@interface LCSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageIndex;
    NSInteger maxPageNo;
}
@property(nonatomic, strong)UISearchBar *searchBar;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@end

static NSString *listCellID = @"LCSearchListCell";
@implementation LCSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitleView];
    
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tebleViewRefreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tebleViewLoadMoreData)];
    
    [self.tableView.mj_header beginRefreshing];

}
//设置导航栏背景色
- (UIColor*)set_colorBackground {
    return MainColor;
}

//是否隐藏导航栏底部的黑线 默认也为NO
- (BOOL)hideNavigationBottomLine {
    return NO;
}

- (void)setTitleView {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.contentMode = UIViewContentModeBottomLeft;
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.tintColor = [UIColor lightGrayColor];
    _searchBar.placeholder = @"输入户主姓名进行查询";
    self.navigationItem.titleView = _searchBar;
    if ([_searchBar respondsToSelector:@selector(barTintColor)]) { //消除返回是一闪效果
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        [_searchBar setBackgroundColor:[UIColor clearColor]];
    }

}

//设置左边按键
- (UIButton*)set_leftButton {
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"back_64"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"back_64"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
- (void)left_button_event:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)set_rightButton {
    UIButton *right_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    right_button.backgroundColor = [UIColor yellowColor];
    [right_button setTitle:@"查询" forState:UIControlStateNormal];
    return right_button;
}

- (void)right_button_event:(UIButton *)sender {
    
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    NSString *text = _searchBar.text;
    if ([text isEqualToString:@""]) { //隐藏空白图
        [self.view configBlankPage:EaseBlankPageTypeNoButton hasData:YES hasError:NO reloadButtonBlock:^(id sender) {
        }];
    }
    [self requestNetWorkisLoad:NO nhname:text];

    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    DLog(@"text %@", searchText);
    if ([searchText isEqualToString:@""]) { //隐藏空白图
        [self.view configBlankPage:EaseBlankPageTypeNoButton hasData:YES hasError:NO reloadButtonBlock:^(id sender) {
        }];
    }
    [self requestNetWorkisLoad:NO nhname:searchText];

}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorwithHex:@"0xf0f0f0"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCSearchModel *model = self.dataArray[indexPath.row];
    LCSearchListCell *listCell = [LCSearchListCell creatCellWithTableView:tableView reuseIdentifier:listCellID];
    [listCell setValueWithModel:model];
    return listCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SeaListCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCSearchModel *model = self.dataArray[indexPath.row];
    LCCaseInfoVC *search = [[LCCaseInfoVC alloc] init];
    search.seaModel = model;
    [self.navigationController pushViewController:search animated:YES];
    
}



#pragma mark - Network

- (void)tebleViewRefreshData {
    if (_searchBar.isFirstResponder) {
        _searchBar.text = nil;
        [_searchBar resignFirstResponder];
    }
    pageIndex = 1;
    [self requestNetWorkisLoad:NO];
}

- (void)tebleViewLoadMoreData {
    if (pageIndex > maxPageNo) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    pageIndex++;
    [self requestNetWorkisLoad:YES];
}

- (void)requestNetWorkisLoad:(BOOL)isload {
    NSDictionary *senDic = @{@"flag":@"SearchReport",
                             USERID:UDSobjectForKey(USERID),
                             @"nhname":@"",
                             @"pageNo":@(pageIndex),
                             @"pageSize":@(10)};
    DLog(@"sendDic = %@", senDic);
    @WeakObj(self);
    [LCAFNetWork POST:@"report" params:senDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([responseObject[STATE] intValue]==1) {
            maxPageNo = pageIndex;
            [self convertIntoModelWithData:responseObject isload:isload];
        }else {
            if (pageIndex == 1) {
                [self.view configBlankPage:EaseBlankPageTypeView hasData:NO hasError:NO reloadButtonBlock:^(id sender) {
                    [selfWeak.tableView.mj_header beginRefreshing];
                }];
            }else {
                [self.view makeToast:responseObject[MESSAGE] duration:0.5f position:CSToastPositionCenter];
            }
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.view configBlankPage:EaseBlankPageTypeView hasData:NO hasError:YES reloadButtonBlock:^(id sender) {
            [selfWeak.tableView.mj_header beginRefreshing];
        }];
        
        
    }];
    
}


- (void)requestNetWorkisLoad:(BOOL)isload nhname:(NSString *)nhname{
    NSDictionary *senDic = @{@"flag":@"SearchReport",
                             USERID:UDSobjectForKey(USERID),
                             @"nhname":nhname ? nhname : @"",
                             @"pageNo":@(pageIndex),
                             @"pageSize":@(10)};
    DLog(@"sendDic = %@", senDic);
    [LCAFNetWork POST:@"report" params:senDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([responseObject[STATE] intValue]==1) {
            maxPageNo = pageIndex;
            [self convertIntoModelWithData:responseObject isload:isload];
        }else {

            [self.view makeToast:responseObject[MESSAGE] duration:0.5f position:CSToastPositionCenter];


        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)convertIntoModelWithData:(id)reponse isload:(BOOL)isload {
    DLog(@"reponse %@", reponse);
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in reponse[DATA]) {
        LCSearchModel *model = [LCSearchModel yy_modelWithDictionary:dic];
        NSLog(@"%@", model.farmer.name);
        [tempArr addObject:model];
    }
    
    if (isload) {
        [self.dataArray addObjectsFromArray:tempArr];
    }else {
        [self.dataArray setArray:tempArr];
    }
    [self.tableView reloadData];

    
    
}

@end
