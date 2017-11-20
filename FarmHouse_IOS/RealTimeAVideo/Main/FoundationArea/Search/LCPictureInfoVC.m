//
//  LCPictureInfoVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/27.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPictureInfoVC.h"
#import "LCPictureCell.h"
#import "MWPhotoBrowser.h"

@interface LCPictureInfoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataArray;

//MWPhotoBrowser dataSource
@property (nonatomic, strong) NSMutableArray *photos;

@end

static NSString *pictureCell = @"PictureCell";
@implementation LCPictureInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片详情";
    [self requestNetwork];

    [self.view addSubview:self.collectionView];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //UICollectionViewLayout, 继承于NSObject, 控制集合视图的样式, 是一个抽象基类
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //cell 默认值(50,50)
//        flowLayout.itemSize = CGSizeMake(80, 100);
        //滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //最小行间距
        flowLayout.minimumLineSpacing = 1;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 1;
        //分区间距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //区头大小
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 10);
        //区尾大小
        //        flowLayout.footerReferenceSize =CGSizeMake(SCREEN_WIDTH, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT) collectionViewLayout:flowLayout];
        
        //集合视图的创建
        _collectionView.backgroundColor = [UIColor colorwithHex:@"0xf0f0f0"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //注册cell(好像必须要注册)
        [_collectionView registerClass:[LCPictureCell class] forCellWithReuseIdentifier:pictureCell];
//        [_collectionView registerClass:[LCOfflineAddCell class] forCellWithReuseIdentifier:addCellid];
//        
//        //        //注册区头
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
    LCReportImgModel *model = self.dataArray[indexPath.row];
    LCPictureCell *cell = [LCPictureCell createCellWith:collectionView reuseIdentifier:pictureCell forIndexPath:indexPath];
    [cell setValueWithModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate

//控制item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SCREEN_WIDTH-20-2)/3.0f;
    return CGSizeMake(width, width*1.1);
}

//分区间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self collectionView:collectionView showMwphotoBrowser:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView showMwphotoBrowser:(NSIndexPath *)indexPath {
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    
    // Photos
    for (LCReportImgModel *model in self.dataArray) {
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:model.imagepath]]];
    }
    
    self.photos = photos;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    //导航右侧分享btn 默认YES
    browser.displayActionButton = displayActionButton;
    //底部是否分页切换导航，默认否
    browser.displayNavArrows = displayNavArrows;
    //是否显示选择按钮在图片上,默认否
    browser.displaySelectionButtons = displaySelectionButtons;
    //控制条控件是否显示(顶部1/3),默认否
    browser.alwaysShowControls = NO;
    //自动适用大小,默认是YES
    browser.zoomPhotosToFill = YES;
    //是否允许用网格查看所有图片,默认是 NO
    browser.enableGrid = enableGrid;
    //是否第一张,默认否
    browser.startOnGrid = startOnGrid;
    //是否开始对缩略图网格代替第一张照片
    browser.enableSwipeToDismiss = NO;
    //是否自动播放视频
    browser.autoPlayOnAppear = autoPlayOnAppear;
    //播放页码
    [browser setCurrentPhotoIndex:indexPath.row];
    
    //show
    [self.navigationController pushViewController:browser animated:YES];

}

//有多少个图片要显示
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;

}
//在具体的index中，显示网络加载或者本地的某一个图片
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;

}

//加载多张网络缩略图（enableGrid＝ YES）时，才可以实现该委托方法

//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index{
//    if (index <self.photos.count) {
//        return [self.photos objectAtIndex:index];
//    }
//    return nil;
//}



//自定义标题
//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)index,(unsigned long)self.photos.count];
//}

#pragma mark - Network

- (void)requestNetwork {
    NSDictionary *sendDic = @{@"flag":@"GetReportImages",
                              @"reportid":self.model.caseid};
    
    @WeakObj(self);
    [LCAFNetWork POST:@"report" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[STATE] intValue]==1) {
            [self convertIntoModelWithData:responseObject isload:NO];
        }else {
            [self.view configBlankPage:EaseBlankPageTypeView hasData:NO hasError:NO reloadButtonBlock:^(id sender) {
                [selfWeak requestNetwork];
            }];
        }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view configBlankPage:EaseBlankPageTypeView hasData:NO hasError:YES reloadButtonBlock:^(id sender) {
            [selfWeak requestNetwork];
        }];
    }];
}

- (void)convertIntoModelWithData:(id)reponse isload:(BOOL)isload {
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in reponse[DATA]) {
        LCReportImgModel *model = [LCReportImgModel yy_modelWithDictionary:dic];
        [tempArr addObject:model];
    }

    [self.dataArray setArray:tempArr];

    [self.collectionView reloadData];
}
@end
