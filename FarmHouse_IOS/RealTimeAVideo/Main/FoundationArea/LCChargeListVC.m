//
//  LCChargeListVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/28.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCChargeListVC.h"
#import "LCFarmNewsModel.h"
#import "MJRefresh.h"
#import "ViewController.h"
#import "HouseHold+CoreDataProperties.h"
#import "LCLonginVC.h"
#import "LCHistoryCell.h"
#import "LCGatherInfoVC.h"//添加户主


@interface LCChargeListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>
{
    NSInteger pageIndex;
    //collectionView height
    CGFloat colHeight;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *historyArr;

@property (nonatomic, strong) UICollectionView *collectionView;


@end

static NSString *cellID = @"ChargeTableViewCell";
static NSString *historyID = @"LCHistoryCell";
static NSString *colHeader = @"CollectionHeader";

@implementation LCChargeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColor;
    self.dataArray = [NSMutableArray array];
    self.historyArr = [self searchModel];
    [self caculateColHeight];
    
    [self initMainViews];
    self.navigationController.delegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tebleViewRefreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewLoadMoreData)];
    [self.tableView.mj_header beginRefreshing];
//    [self tableViewRequestIsLoad:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

#pragma mark - views

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        //UICollectionViewLayout, 继承于NSObject, 控制集合视图的样式, 是一个抽象基类
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //cell 默认值(50,50)
        flowLayout.itemSize = CGSizeMake(HisCellW, HisCellH);
        //滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //最小行间距
        flowLayout.minimumLineSpacing = 5;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 0;
        //分区间距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //区头大小
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
        //区尾大小
        //        flowLayout.footerReferenceSize =CGSizeMake(SCREEN_WIDTH, 20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];

        
        //集合视图的创建
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        //注册cell(好像必须要注册)
        [_collectionView registerClass:[LCHistoryCell class] forCellWithReuseIdentifier:historyID];
//        [_collectionView registerClass:[LCOfflineAddCell class] forCellWithReuseIdentifier:addCellid];
//        
        //        //注册区头
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:colHeader];
        //        //注册区尾
        //        [collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
        
    }
    return _collectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, colHeight, SCREEN_WIDTH, SCREEN_HIGHT-64-colHeight)style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [self tableHeadView];
    }
    return _tableView;
}

- (void)initMainViews {
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"定损" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.contentMode = UIViewContentModeBottomLeft;
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.tintColor = [UIColor lightGrayColor];
    _searchBar.placeholder = @"输入户主姓名进行查询";
    self.navigationItem.titleView = _searchBar;
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.tableView];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(colHeight);
    }];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_collectionView.bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}

- (void)caculateColHeight {
    if (self.historyArr.count == 0) {
        colHeight = 0.f;
        return;
    }
    
    NSInteger row = (self.historyArr.count - 1) / 4 + 1;
    if (self.historyArr.count > 8) {
        row = 2;
    }
    colHeight = 50 + row*(HisCellH+5) + 20;

}

- (void)rightBarItemClick {
    [[HouseHold MR_findAll] enumerateObjectsUsingBlock:^(__kindof HouseHold * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj MR_deleteEntity];
    }];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


- (UIView *)tableHeadView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UILabel *titleLab = [LCTools createLable:@"房屋户主" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    UIButton *button = [LCTools createWordButton:UIButtonTypeCustom title:@"添加户主" titleColor:[UIColor redColor] font:kFontSize16 bgColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [LCTools createLineView:[UIColor lightGrayColor]];
    
    [bgView addSubview:line];
    [bgView addSubview:titleLab];
    [bgView addSubview:button];
    
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.left).offset(10);
        make.centerY.equalTo(bgView.centerY);
    }];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.right).offset(-10);
        make.centerY.equalTo(bgView.centerY);
    }];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0.5);
        make.left.equalTo(bgView);
        make.right.equalTo(bgView);
        make.bottom.equalTo(bgView);
    }];
    
    
    return bgView;
}

- (void)buttonClickAction:(UIButton *)button {
    
    LCGatherInfoVC *gatherVC = [[LCGatherInfoVC alloc] init];
    gatherVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gatherVC animated:YES];

}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCHouseholderModel *model = self.dataArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCHouseholderModel *model = self.dataArray[indexPath.row];
    [self requestForReportNumber:model];
}



#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    DLog(@"%@--%@",_searchBar.text, searchText);
    [self tableViewRequestIsLoad:NO];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HouseHold *model = self.historyArr[indexPath.row];
    LCHistoryCell *cell = [LCHistoryCell createCellWithCollection:collectionView reuseIdentifier:historyID atIndexPath:indexPath];
    [cell setValueWithModel:model];
    return cell;

}


//控制item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(HisCellW, HisCellH);
    
}

//分区间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

//区头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //附加视图: 区头, 区尾
    //kind: 用于区分区头, 区尾
    //区头:UICollectionElementKindSectionHeader
    //区尾:UICollectionElementKindSectionFooter

    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:colHeader forIndexPath:indexPath];
            UILabel *titleLab = [LCTools createLable:@"最近定损" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
            [header addSubview:titleLab];
            UIView *lineView = [LCTools createLineView:[UIColor lightGrayColor]];
            [header addSubview:lineView];
            
            [titleLab makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(header).offset(10);
                make.centerY.equalTo(header.centerY);
            }];
            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(header);
                make.right.equalTo(header);
                make.height.equalTo(0.5);
                make.bottom.equalTo(header.bottom).offset(-2);
            }];
            
            return header;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HouseHold *model = self.historyArr[indexPath.row];
    ViewController *viewController = [[ViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [ActivityApp shareActivityApp].reportNum = model.reportNum;
    NSString *reportStr = [NSString stringWithFormat:@"RNO：%@", model.reportNum];
    [[ActivityApp shareActivityApp].waterTxtArr replaceObjectAtIndex:1 withObject:reportStr];
    viewController.reportNum = model.reportNum;
    [self.navigationController pushViewController:viewController animated:YES];

    [self updateHouseHold:model];
}

//代理方法获取pop push
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        self.historyArr = [self searchModel];
        [self caculateColHeight];
        [self.collectionView reloadData];
        [_collectionView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(10);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(colHeight);
        }];
        
        [_tableView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_collectionView.bottom).offset(10);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    
    return nil;
}




#pragma mark - Network
- (void)tebleViewRefreshData {
    pageIndex = 1;
    [self tableViewRequestIsLoad:NO];
}

- (void)tableViewLoadMoreData {
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

#pragma mark - database
//1.查询数据 校验数据有效期
//2.有效加入数据源数据，无效删除,控制最多8个
- (NSMutableArray *)searchModel {
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[HouseHold MR_findAllSortedBy:@"timestamp" ascending:NO]];
    unsigned int ints = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].unsignedIntValue;
    
    [mArray enumerateObjectsUsingBlock:^(HouseHold *houseModel, NSUInteger idx, BOOL * _Nonnull stop) {
        DLog(@"1");
        if (ints - houseModel.timestamp >= 172800) {//超过48h
            [houseModel MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        NSLog(@"========%@", houseModel.name);
    }];
    DLog(@"2");
    return mArray;
}


//3.老数据更新
- (void)updateHouseHold:(HouseHold *)houseModle{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        DLog(@"model = %@ %@", houseModle, houseModle.masterid);
        HouseHold *houseModel = [HouseHold MR_findFirstByAttribute:@"masterid" withValue:[NSString stringWithString:houseModle.masterid] inContext:localContext];

        houseModel.timestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].unsignedIntValue;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        DLog(@"All = %@", [HouseHold MR_findAll]);

    }];
    
    
}

//1.tableView点击增加或更新
- (void)addHouseHold:(LCHouseholderModel *)model reportNum:(NSString *)reportNum {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        //1.判断当前有没有这一条
        HouseHold *houseModel = [HouseHold MR_findFirstByAttribute:@"masterid" withValue:model.masterid inContext:localContext];

        if (houseModel == nil) {
            houseModel = [HouseHold MR_createEntityInContext:localContext];
        }
        
        houseModel.timestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].intValue;
        houseModel.reportNum = reportNum;
        houseModel.masterid = model.masterid;
        houseModel.nhid = model.nhid;
        houseModel.name = model.name;
        houseModel.cardid = model.cardid;
        houseModel.maritalStatus = model.maritalStatus;
        houseModel.tel = model.tel;
        houseModel.sum = model.sum;
        houseModel.address = model.address;
        houseModel.zipCode = model.zipCode;
        houseModel.income = model.income;
        houseModel.sex = model.sex;
        houseModel.nation = model.nation;
        houseModel.familytype = model.familytype;
        houseModel.openbank = model.openbank;
        houseModel.banknumber = model.banknumber;
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
//        DLog(@"All = %@", [HouseHold MR_findAll]);
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestForReportNumber:(LCHouseholderModel *)hhModel {
    NSDictionary *sendDic = @{@"flag":@"GetCaseNum",
                              @"nhId":hhModel.masterid,
                              USERID:UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@" ",
                              SESSID:UDSobjectForKey(SESSID)?UDSobjectForKey(SESSID):@" "};
    DLog(@"send%@", sendDic);
    [LCAFNetWork POST:ewlWebServerReport params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        // 状态值 0失败，1成功 2失败 如果状态值为2的话就跳到登录页面重新登录
        if ([responseObject[@"state"] intValue] == 0) {
            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
            return;
        }
        if ([responseObject[@"state"] intValue] == 1) {
            
            NSString *reportNum = responseObject[@"message"];
            [ActivityApp shareActivityApp].reportNum = reportNum;
            [self addHouseHold:hhModel reportNum:reportNum];
            
            ViewController *viewController = [[ViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.reportNum = reportNum;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
        
        if ([responseObject[@"state"] intValue] == 2) {
            LCLonginVC *loginVC = [[LCLonginVC alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
    
}


@end
