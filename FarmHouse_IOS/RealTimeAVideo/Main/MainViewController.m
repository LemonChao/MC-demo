//
//  MainViewController.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/10.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//
#import "MainViewController.h"
#import "UITableView+EXT.h"
#import <WebKit/WKWebView.h>
#import "CycleImageCell.h"
#import "LCColumnCell.h"
#import "LCNewsCell.h"
#import "LCFounctionCell.h"
#import "LCWaterfallCell.h" //跑马灯cell
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "LCLonginVC.h" //身份验证
#import "ViewController.h" //定损
#import "LCAddressCodeVC.h" //地址编码
#import "LCGatherVC.h"       //查询
#import "LCFarmNewsDetailVC.h" //news detail
#import "LCMoreNewsVC.h"
#import "LCNotificationVC.h" //notif
#import "LCCycleImgModel.h"
#import "LCCycleImgDetailVC.h"  //轮播详情
#import "LCFarmNewsModel.h"
#import "LCFarmNewsDetailVC.h" //
#import "LCOfflineChargeVC.h"  //离线定损
#import "LCSearchVC.h" //查询
#import "LCCommonWebVC.h" //webvc
#import "CustomPopUpViewController.h" //报案弹出框
#import "LCDataOfflineVC.h" //案件上传

#import "NotificationNewsManager.h"
#import "BadgeButton.h" //小红点button

#import "RSAEncryptor.h" //test

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TXScrollLabelViewDelegate>
{
    NSInteger pageIndex;
    NSInteger maxPageNo;
    RACSubject *subject;
    CGFloat notifCellHight;
    BadgeButton *notifBtn;
    //添加
    int iiii;
}
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *dataArr12;

/** 轮播图路径数组 */
@property (nonatomic, strong) NSMutableArray *cycleImgArr;

/** 农讯数据 */
@property (nonatomic, strong) NSMutableArray *mdataArr;

/** 栏目数据源 */
@property(nonatomic, strong) NSMutableArray *columnArr;

/** 通知消息数组 */
@property(nonatomic, strong) NSMutableArray *notifNewsArr;

@property (nonatomic, strong) SDCycleScrollView *cycleView;
@end

static NSString *columnCell = @"columnCell";
static NSString *lcFuncCell = @"founctionCell";
static NSString *lcNewsCell = @"lcNewsCell";
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mdataArr = [NSMutableArray array];
    self.cycleImgArr = [NSMutableArray array];
    self.columnArr = [NSMutableArray array];
    self.notifNewsArr = [NSMutableArray array];
    notifCellHight = 0;
    [self authenticatUserIdentity];         //登陆是否过期
    [self checkVersion];                    //检查版本
        
    [self.view addSubview:self.mTableView];
    [self createNotificationBtn];
    [[NotificationNewsManager alloc] createForNotificationNewsTimer];
    self.mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tebleViewRefreshData)];
    self.mTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewLoadMoreData)];
    [self.mTableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceivedFreshNotificationNews) name:@"ReceivedFreshNotificationNews" object:nil];
    
    
    subject = [RACSubject subject];
    
    [subject subscribeNext:^(NSMutableArray *array) {
        
        if (array.count) {
            notifCellHight = 40;
            notifBtn.badgeValue = [NSString stringWithFormat:@"%ld", array.count];
        }else {
            notifCellHight = 0;
            notifBtn.badgeValue = nil;
        }
        
        [_mTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

    }];
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor clearColor];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor blackColor];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (UITableView *)mTableView{
    if (!_mTableView) {
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT) style:UITableViewStyleGrouped];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.estimatedRowHeight = 100;
        _mTableView.tableHeaderView = self.headerView;
        _mTableView.tableFooterView = [UIView new];
//        _mTableView.backgroundColor = BGColor;
        [_mTableView registerNib:[UINib nibWithNibName:@"LCFounctionCell" bundle:nil] forCellReuseIdentifier:lcFuncCell];
        [_mTableView registerNib:[UINib nibWithNibName:@"LCColumnCell" bundle:nil] forCellReuseIdentifier:columnCell];
    }
    return _mTableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        self.cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.61*SCREEN_WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage@3x.jpeg"]];
        self.cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _headerView = _cycleView;
    }
    return _headerView;
}

#pragma mark- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;//self.notifNewsArr.count > 0 ? 1 : 0;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return self.columnArr.count > 0 ? 1 : 0;
    }
    else {
        return self.mdataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LCWaterfallCell *cell = [LCWaterfallCell creatCellWithTableView:tableView reuseIdentifier:@"waterFallCell"];
        cell.scrollLabelView.scrollLabelViewDelegate = self;
        [cell setValueWithArray:self.notifNewsArr];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        LCFounctionCell *cell = [tableView dequeueReusableCellWithIdentifier:lcFuncCell];
        
        cell.buttonTypeBlock = ^(NSInteger tag){
            @WeakObj(self);
            //1.检查是否登陆
            BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN];
            
            switch (tag) {
                case 1130:{
                    
                    [[CustomPopUpViewController alloc] showPopUpViewController:self pickType:^(NSInteger pickType) {
                        NSLog(@"%ld", pickType);
                        
                        if (pickType == 0) { //在线报案
                            
                            if (result) {
                                //是否是协保员，1具有定损权限
                                NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
                                if ([userinfo[@"power"] integerValue]) {
                                    LCAddressCodeVC *addressCodeVC = [[LCAddressCodeVC alloc] init];
                                    addressCodeVC.hidesBottomBarWhenPushed = YES;
                                    [selfWeak.navigationController pushViewController:addressCodeVC animated:YES];
                                }else {
                                    [LCAlertTools showTipAlertViewWith:selfWeak title:@"提示" message:@"您还不是协保员，必须是协保员才能定损" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
                                }
                            }else {
                                [LCAlertTools showTipAlertViewWith:selfWeak title:@"提示" message:@"您还没有登录, 请先登录！" cancelTitle:@"确定" cancelHandler:^{
                                    LCLonginVC *loginVC = [[LCLonginVC alloc] init];
                                    loginVC.hidesBottomBarWhenPushed = YES;
                                    [selfWeak.navigationController pushViewController:loginVC animated:YES];
                                }];
                            }
                            
                        }
                        if (pickType == 1) { //离线定损
                            LCOfflineChargeVC *offlineVC = [[LCOfflineChargeVC alloc] init];
                            offlineVC.hidesBottomBarWhenPushed = YES;
                            [selfWeak.navigationController pushViewController:offlineVC animated:YES];
                            
                        }
                        if (pickType == 2) { //离线上传
                            LCDataOfflineVC *dataOfflineVC = [[LCDataOfflineVC alloc] init];
                            dataOfflineVC.hidesBottomBarWhenPushed = YES;
                            [selfWeak.navigationController pushViewController:dataOfflineVC animated:YES];
                        }
                        
                    }];
                    
                }
                    break;
                    
                case 1131:{
                    DLog(@"tag%ld", (long)tag);
                    if (result) {
                        LCGatherVC *gatherVC = [[LCGatherVC alloc] init];
                        gatherVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:gatherVC animated:YES];
                    }
                    else {
                        [LCAlertTools showTipAlertViewWith:selfWeak title:@"提示" message:@"您还没有登录, 请先登录！" cancelTitle:@"确定" cancelHandler:^{
                            LCLonginVC *loginVC = [[LCLonginVC alloc] init];
                            loginVC.hidesBottomBarWhenPushed = YES;
                            [selfWeak.navigationController pushViewController:loginVC animated:YES];
                        }];
                        
                    }
                }
                    break;
                case 1132:{
                    if (result) {
                        LCSearchVC *search = [[LCSearchVC alloc] init];
                        search.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:search animated:YES];
                    }
                    else {
                        [LCAlertTools showTipAlertViewWith:selfWeak title:@"提示" message:@"您还没有登录, 请先登录！" cancelTitle:@"确定" cancelHandler:^{
                            LCLonginVC *loginVC = [[LCLonginVC alloc] init];
                            loginVC.hidesBottomBarWhenPushed = YES;
                            [selfWeak.navigationController pushViewController:loginVC animated:YES];
                        }];
                        
                    }
                }
                    break;
                case 1133:{
                    LCCommonWebVC *webVC = [[LCCommonWebVC alloc] init];
                    webVC.hidesBottomBarWhenPushed = YES;
                    webVC.type = CommonWebInsurance;
                    [selfWeak.navigationController pushViewController:webVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
        
        return cell;

    }
    else if (indexPath.section == 2) {
        LCColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:columnCell];
        
        [cell setValueWithArray:self.columnArr];
        
        
        cell.buttonTypeBlock = ^(NSInteger tag){
            
            @WeakObj(self);
            LCCommonWebVC *webVC = [[LCCommonWebVC alloc] init];
            
            ColumnModel *model = self.columnArr[tag-1000];
            webVC.webStr = model.h5url;
            
            webVC.hidesBottomBarWhenPushed = YES;
//            switch (tag) {
//                case 1000:{
//                    webVC.type = CommonWebWeather;
//                }
//                    break;
//                    
//                case 1001:{
//                    webVC.type = CommonWebGame;
//                }
//                    break;
//                case 1002:{
//                    webVC.type = CommonWebSpecial;
//                }
//                    break;
//                case 1003:{
//                    webVC.type = CommonWebHome;
//                }
//                    break;
//                default:
//                    break;
//            }
        
        [selfWeak.navigationController pushViewController:webVC animated:YES];
            
        };
        return cell;

    }
    else {
        LCFarmNewsModel *model = self.mdataArr[indexPath.row];
        LCNewsCell *newsCell = [LCNewsCell creatCellWithTableView:tableView reuseIdentifier:lcNewsCell];
        [newsCell setValueWithModel:model];
        return newsCell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return notifCellHight;
    }
    else if (indexPath.section == 1) {
        return AutoWHGetHeight(90);
    }
    else if (indexPath.section == 2) {
        return AutoWHGetHeight(110);
    }
    else {
        return AutoWHGetHeight(NewsCellH)+20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView;
    if (section == 3) {
        headerView = [self creatSection1HeaderView];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return AutoWHGetHeight(35);
    }else {
        return 0.001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {

        LCNotificationVC *notificateNews = [[LCNotificationVC alloc] init];
        notificateNews.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notificateNews animated:YES];

    }else if (indexPath.section == 3) {
        LCFarmNewsModel *newsModel = self.mdataArr[indexPath.row];
        LCFarmNewsDetailVC *detailVC = [[LCFarmNewsDetailVC alloc] init];
        detailVC.dataDic = self.dataArr12[indexPath.row];
        detailVC.newsid = newsModel.newsid;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    

}

#pragma mark - NetWork

- (void)tebleViewRefreshData {
    pageIndex = 1;
    [self tableViewRequestIsLoad:NO];
    [self requestCycleImgURLStringsGroup];
    
    [self requestColumnUrl];
}

- (void)tableViewLoadMoreData {
    if (pageIndex > maxPageNo) {
        [_mTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    pageIndex ++;
    [self tableViewRequestIsLoad:YES];
}


/** 新闻列表 */
- (void)tableViewRequestIsLoad:(BOOL)isload {
    NSDictionary *sendDic = @{@"pageSize":@"5",
                              @"pageNo":@(pageIndex)};
    
    [LCAFNetWork POST:@"news" params:sendDic responseCache:^(id responseCache) {
        if (responseCache != nil) {
            [self convertIntoModelWithData:responseCache isload:isload];
        }

    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        
        if ([responseObject[STATE] intValue]==1) {
            maxPageNo = pageIndex;
            [self convertIntoModelWithData:responseObject isload:isload];
        }else {
            [self.view makeToast:responseObject[MESSAGE] duration:1.0 position:CSToastPositionCenter];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [[UIApplication sharedApplication].keyWindow makeToast:[error localizedDescription]];
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        
    }];
    
}


- (void)convertIntoModelWithData:(id)reponse isload:(BOOL)isload {
    NSMutableArray *tempArray = [NSMutableArray array];

    for (NSDictionary *dic in reponse[@"data"]) {
        LCFarmNewsModel *model = [LCFarmNewsModel yy_modelWithDictionary:dic];
        [tempArray addObject:model];
    }
    DLog(@"tempArr%@", tempArray);
    if (isload) {
        [self.mdataArr addObjectsFromArray:tempArray];
    }else {
        [self.mdataArr setArray:tempArray];
    }
    [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    
}

/** 获取轮播图 */
- (void)requestCycleImgURLStringsGroup {
    NSDictionary *sendDic = @{@"flag":@"GetAdvert"};
    
    [LCAFNetWork POST:@"advert" params:sendDic responseCache:^(id responseCache) {
        
        [self convertCycleImgModel:responseCache];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self convertCycleImgModel:responseObject];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

- (void)convertCycleImgModel:(id)responseObject {
    
    if ([responseObject[STATE] intValue] == 1) {
        NSMutableArray *mImgArr = [NSMutableArray array];
        NSMutableArray *mtitleArr = [NSMutableArray array];
        NSMutableArray *modelArr = [NSMutableArray array];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            LCCycleImgModel *cycleModel = [LCCycleImgModel yy_modelWithDictionary:dic];
            [modelArr addObject:cycleModel];
            [mImgArr addObject:cycleModel.downpath];
            [mtitleArr addObject:cycleModel.title];
        }
        [self.cycleImgArr setArray:modelArr];
//        DLog(@"imgArr=%@", _cycleImgArr);
        self.cycleView.imageURLStringsGroup = mImgArr;
//        self.cycleView.titlesGroup = mtitleArr;
    }

}

/** 验证是否长时间没有登陆 */
- (void)authenticatUserIdentity {
    
    NSDictionary *sendDic = @{@"flag":@"AuthDegree",
                              USERID:UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@" ",
                              SESSID:UDSobjectForKey(SESSID)?UDSobjectForKey(SESSID):@" "};
    
    [LCAFNetWork POST:ewlWebServerUser params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //  0失败，1成功 2失败 如果状态值为2的话就跳到登录页面重新登录
        if ([[responseObject objectForKey:@"state"] intValue] != 1) {
            //user login again
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISLOGIN];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO];
            
            // 通知更新UI
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkLoginToRefreshUI" object:nil];

        }else {
            
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

- (void)checkVersion {
    NSDictionary *sendDic = @{@"flag":@"GetVersionInfo"};
    
    @WeakObj(self);
    [LCAFNetWork POST:@"update" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[STATE] intValue] == 0) return;
        
        NSDictionary *dataDic = responseObject[@"data"];
        NSString *versionCtrl = dataDic[@"versioncontrol"];
        
        if ([AppBuildVersion intValue] >= [versionCtrl intValue]) return;
        
        NSString *version = dataDic[@"version"];
        NSString *desStr = dataDic[@"versioncontent"];
        DLog(@" %@  %@ %@ ", AppBuildVersion, version, versionCtrl);
        
        [LCAlertTools showTipAlertViewWith:selfWeak title:@"重要提示" message:desStr buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel cancelHandler:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1190181466"]];
        }];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

/** 获取栏目数据 */
- (void)requestColumnUrl {
    
    NSDictionary *sendDic = @{@"flag":@"searchurl"};
    
    @WeakObj(self);
    [LCAFNetWork POST:@"farmerBasicInfo" params:sendDic responseCache:^(id responseCache) {
        
        [selfWeak convertIntoColumnModel:responseCache];

    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[STATE] intValue]) {
            [selfWeak convertIntoColumnModel:responseObject];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}


- (void)convertIntoColumnModel:(id)response {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *dic in response[DATA]) {
        
        ColumnModel *model = [ColumnModel yy_modelWithDictionary:dic];
        
        [tempArray addObject:model];
    }
    
    [self.columnArr setArray:tempArray];
    
    [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    
}




#pragma mark - views
- (UIView *)creatSection1HeaderView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoWHGetHeight(35))];
    bgView.backgroundColor = [UIColor whiteColor];
    CGSize contentSize = [@"热点资讯" sizeWithAttributes:@{NSFontAttributeName:kFontSize14}];
    UILabel *leftlab = [LCTools createLable:CGRectMake(10, 0, contentSize.width, HEIGHT(bgView)-1) withName:@"热点资讯" withFont:kSize14];
    [bgView addSubview:leftlab];
    
    //button
    CGSize buttonSize = [@"查看更多 >" sizeWithAttributes:@{NSFontAttributeName:kFontSize13}];
    UIButton *rightBtn = [LCTools createButton:CGRectMake(SCREEN_WIDTH-10-buttonSize.width, 0, buttonSize.width, HEIGHT(bgView)-1) withName:@"查看更多 >" normalImg:nil highlightImg:nil selectImg:nil];
    rightBtn.titleLabel.font = kFontSize13;
    [rightBtn setTitleColor:[UIColor colorwithHex:@"0xf56c68"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(lookMore:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rightBtn];
        
    return bgView;
}

- (void)lookMore:(UIButton *)button {
    
    LCMoreNewsVC *moreNews = [[LCMoreNewsVC alloc] init];
    moreNews.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreNews animated:YES];
    
}

- (void)createNotificationBtn {
    
    notifBtn = [[BadgeButton alloc] init];
    notifBtn.frame = CGRectMake(SCREEN_WIDTH-30-10, 10, 30, 30);
    [notifBtn setImage:[UIImage imageNamed:@"notif_trumpet"] forState:UIControlStateNormal];
    [notifBtn addTarget:self action:@selector(jumpToNotificationVC) forControlEvents:UIControlEventTouchUpInside];
    [self.mTableView.tableHeaderView addSubview:notifBtn];
    
}


- (void)jumpToNotificationVC {
    
    //1.检查是否登陆
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN];
    
    if (!result) {
        
        [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"您还没有登录, 请先登录！" cancelTitle:@"确定" cancelHandler:^{
            LCLonginVC *loginVC = [[LCLonginVC alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        return;
    }
    
    LCNotificationVC *notificateNews = [[LCNotificationVC alloc] init];
    notificateNews.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notificateNews animated:YES];

}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%ld", index);
    LCCycleImgModel *model = self.cycleImgArr[index];
    if (![model.flag intValue]) return;
    
    LCCycleImgDetailVC *cycleDetailVC = [[LCCycleImgDetailVC alloc] init];
    cycleDetailVC.urlString = model.url;
    cycleDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cycleDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FreshNewsNotification

- (void)ReceivedFreshNotificationNews {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRead == 0"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    iiii++;
    [[NotificationNews MR_findAllWithPredicate:predicate] enumerateObjectsUsingBlock:^(NotificationNews *news, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tempArray addObject:news.content];
    }];
    [self.notifNewsArr setArray:tempArray];
    
    
    [subject sendNext:self.notifNewsArr];
}

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index {
    
    LCNotificationVC *notificateNews = [[LCNotificationVC alloc] init];
    notificateNews.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notificateNews animated:YES];

}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceivedFreshNotificationNews" object:nil];
}

@end
