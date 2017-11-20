//
//  LCGatherVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/5.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCGatherVC.h"
#import "LCNonghuWebVC.h"
#import "LCGatherPhotoVC.h"
#import "LCPhotoColumnCell.h"
#import "LCGatherWebVC.h" //web采集

@interface LCGatherVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@end
static NSString *cellid = @"gatherCell";
@implementation LCGatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"采集";
    [self.view addSubview:self.collectionView];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"imageName":@"gather_addnh",@"title":@"新增保户"},
                       @{@"imageName":@"gather_photo",@"title":@"照片采集"},
                       @{@"imageName":@"gather_plant",@"title":@"种植采集"},
                       @{@"imageName":@"gather_farming",@"title":@"养殖采集"},
                       @{@"imageName":@"gather_equipment",@"title":@"设备采集"},
                       @{@"imageName":@"gather_special",@"title":@"特产采集"}].mutableCopy;
    }
    return _dataArray;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //UICollectionViewLayout, 继承于NSObject, 控制集合视图的样式, 是一个抽象基类
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //cell 默认值(50,50)
        CGFloat width = (SCREEN_WIDTH-1)/2;
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
        LCNonghuWebVC *vc = [[LCNonghuWebVC alloc] init];
        vc.webType = NonghuAddHouseHold;
        vc.title = [_dataArray[indexPath.row] objectForKey:@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1) {
        LCGatherPhotoVC *vc = [[LCGatherPhotoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = [_dataArray[indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2) {
        LCGatherWebVC *vc = [[LCGatherWebVC alloc] init];
        vc.webType = GatherWebTypePlant;
        vc.operationType = GatherWebOperationPlain;
        vc.title = [_dataArray[indexPath.row] objectForKey:@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 3) {
        LCGatherWebVC *vc = [[LCGatherWebVC alloc] init];
        vc.webType = GatherWebTypeFarming;
        vc.operationType = GatherWebOperationPlain;
        vc.title = [_dataArray[indexPath.row] objectForKey:@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 4) {
        LCGatherWebVC *vc = [[LCGatherWebVC alloc] init];
        vc.webType = GatherWebTypeEquipment;
        vc.operationType = GatherWebOperationPlain;
        vc.title = [_dataArray[indexPath.row] objectForKey:@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 5) {
        LCGatherWebVC *vc = [[LCGatherWebVC alloc] init];
        vc.webType = GatherWebTypeSpecial;
        vc.operationType = GatherWebOperationPlain;
        vc.title = [_dataArray[indexPath.row] objectForKey:@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}




@end
