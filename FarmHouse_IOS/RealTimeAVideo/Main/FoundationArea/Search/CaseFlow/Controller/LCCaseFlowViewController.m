//
//  LCCaseFlowViewController.m
//  RealTimeAVideo
//
//  Created by sunpeng on 2017/3/28.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCCaseFlowViewController.h"
#import "CaseFlowCell.h"
#import <MJRefresh.h>
#import "CommentVC.h"

#define TextViewTrimmingStr(text) [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

static NSString *Identifier = @"CaseFlowCell";

@interface LCCaseFlowViewController (){
    NSInteger page, totalPage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation LCCaseFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BGColor;
    [self setleftBarButtonItm];
    [self initViews];
}
- (void)initViews{
    _dataArray = @[].mutableCopy;
    [_tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
    page = 1;
    [self getNetData];
    __weak typeof(self)weakSelf = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf getNetData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        if (page > totalPage) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf getNetData];
        }
    }];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CaseFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = NO;
    cell.vc = self;
    cell.block = ^(){
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    };
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CaseFlowModel *model = _dataArray[indexPath.row];
    if (model.isFull) {
        return model.cellHeight;
    }else{
        return model.normalHeight;
    }
}



#pragma mark - NetWork
- (void)getNetData{
    __weak typeof(self)weakSelf = self;
    NSDictionary *dic = @{@"flag":@"GetDialogueList",@"userid":UDSobjectForKey(USERID),@"reportid":_model.caseid,@"pageNo":@(page),@"pageNo":@(10)};
    [LCAFNetWork POST:@"report" params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"state"] intValue] == 1) {
            if (page == 1) {
                [_dataArray removeAllObjects];
                totalPage = [responseObject[@"count"] integerValue];
            }
            NSLog(@"responseObject:%@", responseObject);
            for (NSDictionary *dic in responseObject[@"data"]) {
                CaseFlowModel *model = [CaseFlowModel yy_modelWithDictionary:dic];
                model.userheadimage = StrFormat(@"%@%@", BASEURL, model.userheadimage);
                //  model.content = [model.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if (TextViewTrimmingStr(model.content).length != 0)
                {
                    model.contentHeight = [LCTools heightWithString:model.content font:[UIFont systemFontOfSize:15] constrainedToWidth:SCREEN_WIDTH - 80];
                }else{
                    model.contentHeight = 1;
                }
                
                if (model.imagepath.count == 0) {
                    model.photoViewHeight = 0;
                }else{
                    model.photoViewHeight = ((model.imagepath.count - 1)/3 + 1) * ((SCREEN_WIDTH - 100)/3 + 5);
                }
                if (model.contentHeight > 90) {
                    model.normalHeight = 90 + 90 + model.photoViewHeight + 21;
                    model.ishideFillBtn = NO;
                }else{
                    model.normalHeight = 90 + model.contentHeight + model.photoViewHeight;
                    model.ishideFillBtn = YES;
                }
                model.cellHeight = 90 + model.contentHeight + model.photoViewHeight;
                [_dataArray addObject:model];
            }
            [self performSelectorOnMainThread:@selector(reloadTableViewVV) withObject:nil waitUntilDone:YES];
        }
        if (page == 1) {
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
//        [weakSelf.view configBlankPage:EaseBlankPageTypeView hasData:weakSelf.dataArray.count hasError:(weakSelf.dataArray.count>0) reloadButtonBlock:^(id sender) {
//            page = 1;
//            [weakSelf.tableView.mj_header beginRefreshing];
//            [weakSelf getNetData];
//        }];
        [weakSelf.view configBlankPage:EaseBlankPageTypeNoButton hasData:NO hasError:NO reloadButtonBlock:nil];

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.view makeToast:error.localizedDescription duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)reloadTableViewVV{
    [self.tableView reloadData];
}


- (void)setleftBarButtonItm{
    self.navigationItem.title = @"案件跟进";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBefore)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *rightItem= [[UIBarButtonItem alloc] initWithTitle:@"发表意见" style:(UIBarButtonItemStyleDone) target:self action:@selector(editMsg)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//进入发表意见界面
- (void)editMsg{
    CommentVC *commentVC = [CommentVC new];
    commentVC.model = _model;
    __weak typeof(self)weakSelf = self;
    commentVC.blcok = ^(){
        page = 1;
        [weakSelf getNetData];
    };
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)backBefore{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
