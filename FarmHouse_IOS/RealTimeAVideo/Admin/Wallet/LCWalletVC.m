//
//  LCWalletVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCWalletVC.h"
#import "LCPhotoColumnCell.h"
#import "LCChangeVC.h" //零钱
#import "LCBankCardVC.h"
#import "LCWithDrawManager.h" //提现管理

@interface LCWalletVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString *_userid;
}
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@end
static NSString *cellid = @"gatherCell";
@implementation LCWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _userid = UDSobjectForKey(USERID);

    self.title = @"我的钱包";
    [self.view addSubview:self.collectionView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提现管理" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
//    [self requestForChange];
//    [self requestBankCardAll];
//    [self requestForBankCard];
//    [self requestForMonerylog];

}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"imageName":@"wallet_change",@"title":@"零钱"},
                       @{@"imageName":@"wallet_card",@"title":@"银行卡"}].mutableCopy;
    }
    return _dataArray;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //UICollectionViewLayout, 继承于NSObject, 控制集合视图的样式, 是一个抽象基类
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //cell 默认值(50,50)
        CGFloat width = (SCREEN_WIDTH-1)/2;
        flowLayout.itemSize = CGSizeMake(width, width*0.61);
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
        [_collectionView registerClass:[LCGatherCell class] forCellWithReuseIdentifier:cellid];
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
    
    LCGatherCell *cell = [LCGatherCell createCellWithCollection:collectionView reuseIdentifier:cellid atIndexPath:indexPath];
    [cell setValueWith:self.dataArray[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LCChangeVC *vc = [[LCChangeVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1) {
        LCBankCardVC *vc = [[LCBankCardVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


- (void)rightBarItemClick {
    LCWithDrawManager *vc = [[LCWithDrawManager alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

///** 查询账户余额 */
//- (void)requestForChange {
//    NSDictionary *sendDic = @{@"flag":@"searchChange",
//                              @"userid":_userid};
//    
//    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@", sendDic);
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//    
//}
//
///** 查询银行卡信息 */
//- (void)requestForBankCard {
//    
//    NSDictionary *sendDic = @{@"flag":@"changeandbank",
//                              @"userid":_userid};
//    
//    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@", sendDic);
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//    
//}
//
///** 查询零钱明细 */
//- (void)requestForMonerylog {
//    
//    NSDictionary *sendDic = @{@"flag":@"searchMonerylog",
//                              @"userid":_userid};
//    
//    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@", sendDic);
//        
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//    
//}
//
///** 查询银行卡全部信息 searchbanktable*/
//- (void)requestBankCardAll {
//    
//    NSDictionary *sendDic = @{@"flag":@"searchbanktable",
//                              @"userid":_userid};
//    
//    [LCAFNetWork POST:@"monery" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@", sendDic);
//        
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//    
//}
//


@end
