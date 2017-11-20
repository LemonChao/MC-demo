//
//  LCManagerVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/17.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCManagerVC.h"
#import "LCPhotoColumnCell.h"
#import "LCPhotoListVC.h" //图片上传
#import "LCDataOfflineVC.h"
#import "LCHouseholderVC.h"
#import "LCSearchVC.h"
#import "LCLonginVC.h"
#import "OfflineModel+CoreDataProperties.h"
#import "GatherPhoto+CoreDataProperties.h"

@interface LCManagerVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@end
static NSString *cellid = @"managerCell";
static NSString *badgeValue;
static NSString *offlineCount = @"";
static NSString *gatherCount = @"";

@implementation LCManagerVC

+ (void)initialize {
    [self getTabBarItemValue];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableBar) name:@"refreshTableBarValueNotification" object:nil];

}

+ (void)getTabBarItemValue {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpload == 0"];
    NSArray *offlinemodelArray = [NSMutableArray arrayWithArray:[OfflineModel MR_findAllWithPredicate:predicate]];
    offlineCount = offlinemodelArray.count ? [NSString stringWithFormat:@"%ld", offlinemodelArray.count] : nil;
    
    NSArray *gatherPhotoArray = [NSMutableArray arrayWithArray:[GatherPhoto MR_findAll]];
    gatherCount = gatherPhotoArray.count ? [NSString stringWithFormat:@"%ld", gatherPhotoArray.count] : nil;
    
    NSInteger badgeCount = offlinemodelArray.count + gatherPhotoArray.count;
    badgeValue = badgeCount > 0 ? [NSString stringWithFormat:@"%ld", badgeCount] : nil;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableBar) name:@"refreshTableBarValueNotification" object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __FUNCTION__);
    self.title = @"管理";
    [self.view addSubview:self.collectionView];
    [self.navigationController.tabBarItem setBadgeValue:badgeValue];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self class] getTabBarItemValue];
    
    [self.navigationController.tabBarItem setBadgeValue:badgeValue];
    
    [self.collectionView reloadData];

}

- (void)refreshTableBar {
    NSLog(@"+++++++++++++");
    [[self class] getTabBarItemValue];
    
    [self.navigationController.tabBarItem setBadgeValue:badgeValue];
    
//    [self.collectionView reloadData];

}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"imageName":@"manager_household",@"title":@"户主管理"},
                       @{@"imageName":@"manager_inquire",@"title":@"案件查询"},
                       @{@"imageName":@"manager_case",@"title":@"案件上传"},
                       @{@"imageName":@"manager_upload",@"title":@"照片上传"}].mutableCopy;
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //UICollectionViewLayout, 继承于NSObject, 控制集合视图的样式, 是一个抽象基类
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //cell 默认值(50,50)
        CGFloat width = (SCREEN_WIDTH-3)/4;
        flowLayout.itemSize = CGSizeMake(width, width*0.78);
        //滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //最小行间距
        flowLayout.minimumLineSpacing = 1;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 1;
        //分区间距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        //区头大小
        //        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 10);
        //区尾大小
        //        flowLayout.footerReferenceSize =CGSizeMake(SCREEN_WIDTH, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) collectionViewLayout:flowLayout];
        
        //集合视图的创建
        _collectionView.backgroundColor = [UIColor colorwithHex:@"0xf0f0f0"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //注册cell(好像必须要注册)
        [_collectionView registerClass:[LCManagerCell class] forCellWithReuseIdentifier:cellid];
        //        [_collectionView registerClass:[LCOfflineAddCell class] forCellWithReuseIdentifier:addCellid];
        //
        //        //注册区头
        //        [_collectionView registerClass:[LCHeadUNupload class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:upuploadHead];
        //        //注册区尾
        //        [collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LCManagerCell *cell = [LCManagerCell createCellWithCollection:collectionView reuseIdentifier:cellid atIndexPath:indexPath];
    [cell setValueWith:self.dataArray[indexPath.row]];
    
    if (indexPath.row == 2) {
        [cell setBadgeValue:offlineCount];
    }
    else if (indexPath.row == 3) {
        [cell setBadgeValue:gatherCount];
    }else {
        [cell setBadgeValue:nil];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    [LCAlertTools checkLoginIfNecessary:self];
    
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN];
    
    if (!result) {
        
        [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"您还没有登录, 请先登录！" cancelTitle:@"确定" cancelHandler:^{
            LCLonginVC *loginVC = [[LCLonginVC alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        
        return;
    }

    UIViewController *viewController;
    switch (indexPath.row) {
        case 0: //householManager
        {
            LCHouseholderVC *houseVC = [[LCHouseholderVC alloc] init];
            viewController = houseVC;
        }
            break;
        case 1: //案件查询
        {
            LCSearchVC *search = [[LCSearchVC alloc] init];
            search.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:search animated:YES];

        }
            break;
        case 2: //dataOffline 案件上传
        {
            LCDataOfflineVC *dataOfflineVC = [[LCDataOfflineVC alloc] init];
            viewController = dataOfflineVC;
        }
            break;
        case 3:  //photo update
        {
            LCPhotoListVC *photoList = [[LCPhotoListVC alloc] init];
            viewController = photoList;
        }
            break;
            
        default:
            break;
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = self.navigationItem.title;
    self.navigationItem.backBarButtonItem = backItem;
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.navigationItem.title = [self.dataArray[indexPath.section] objectForKey:@"title"];
    [self.navigationController pushViewController:viewController animated:YES];

    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTableBarValueNotification" object:nil];
}

@end
