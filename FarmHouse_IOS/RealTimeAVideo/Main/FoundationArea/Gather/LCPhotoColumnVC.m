//
//  LCPhotoColumnVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/11.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPhotoColumnVC.h"
#import "LCPhotoColumnCell.h"
#import "LCNonghuModel.h"
#import "MWPhotoBrowser.h"
#import "LCCaptionCustomView.h"
#import "UIImage+water.h"
#import "LCPhotoColumnDetail.h"
#import "UIImage+compress.h"



@interface LCPhotoColumnVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) NSMutableArray *photos;
@end


static NSString *imgCellid = @"offimgCell";
static NSString *addCellid = @"addCell";
#define isEndCell (indexPath.row == (self.dataArray.count))

@implementation LCPhotoColumnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestNetwork];
    self.title = @"照片";
    
    [self.view addSubview:self.collectionView];
    
    
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
        CGFloat width = (SCREEN_WIDTH-10*2)/3.0;
        flowLayout.itemSize = CGSizeMake(width, width);
        //滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //最小行间距
        flowLayout.minimumLineSpacing = 10;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 10;
        //分区间距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        //区头大小
        //        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, AutoWHGetHeight(120));
        //区尾大小
        //        flowLayout.footerReferenceSize =CGSizeMake(SCREEN_WIDTH, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64-49) collectionViewLayout:flowLayout];
        
        //集合视图的创建
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //注册cell(好像必须要注册)
        [_collectionView registerClass:[LCPhotoColumnCell class] forCellWithReuseIdentifier:imgCellid];
        [_collectionView registerClass:[LCColumnAddCell class] forCellWithReuseIdentifier:addCellid];
        
        //        //注册区头
//        [_collectionView registerClass:[LCHeadGather class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHe];
        //        //注册区尾
        //        [collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
        
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isEndCell) {
        LCColumnAddCell *addCell = [LCColumnAddCell createCellWithCollection:collectionView reuseIdentifier:addCellid atIndexPath:indexPath];
        return addCell;
        
    }else {
        LCHouseHoldImage *imgModel = self.dataArray[indexPath.row];
        
        LCPhotoColumnCell *imgCell = [LCPhotoColumnCell createCellWithCollection:collectionView reuseIdentifier:imgCellid atIndexPath:indexPath];
        [imgCell setModel:imgModel];
        
        return imgCell;
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isEndCell) {
        [self collectionView:collectionView addNewCellIndex:indexPath];
    }else {
        LCPhotoColumnDetail *detailVC = [[LCPhotoColumnDetail alloc] init];
        detailVC.dataArray = self.dataArray;
        detailVC.hidesBottomBarWhenPushed = YES;
        [detailVC setCurrentIndex:indexPath.row];
        
        @WeakObj(self);
        detailVC.deleteBlock = ^(){
            [selfWeak.collectionView reloadData];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
        
//        [self collectionView:collectionView showMwphotoBrowser:indexPath];
    }
}

/** 倒二位置添加一个cell */
- (void)collectionView:(UICollectionView *)collectionView addNewCellIndex:(NSIndexPath *)indexPath {
    
    NSArray *titleArr = @[@"拍照"];
    NSArray *styleArr = @[[NSNumber numberWithInteger:UIAlertActionStyleDefault],
                          [NSNumber numberWithInteger:UIAlertActionStyleDefault]];
    
    [LCAlertTools showActionSheetWith:self title:nil message:nil cancelButtonTitle:@"取消" actionTitleArray:titleArr actionStyleArray:styleArr cancelHandler:nil callbackBlock:^(NSInteger actionIndex) {
        DLog(@"%@-%ld", titleArr[actionIndex], actionIndex);
        
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        
        if (actionIndex == 0) { //拍照
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"没有找到可用的相机" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
                return;
            }
            pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else {
            pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//    DLog(@"%p --%ld %ld", selectIndex, selectIndex.section, selectIndex.row);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *reportNum = @"null";
        NSString *dateStr = [NSDate format:@"YYYY/MM/dd/ HH:mm:ss"];
        NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
        [array replaceObjectAtIndex:0 withObject:dateStr];
        [array replaceObjectAtIndex:1 withObject:StrFormat(@"RNO：%@",reportNum)];
        
        UIImage *waterImg = [[info valueForKey:UIImagePickerControllerOriginalImage] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
        
        [self uploadSingleImage:[UIImage zipImageWithImage:waterImg]];

    });
//    [self uploadSingleImage:UIImageJPEGRepresentation(waterImg, 0.1)];
    
//    NSString *imgName = [NSString stringWithFormat:@"%@_%@.jpg", reportNum, [NSDate format:@"YYYYMMddHHmmss"]];
//    
////    LCPhotoModel *imgModel = [[LCPhotoModel alloc] init];
////    imgModel.filePath = imgName;
////    imgModel.image = waterImg;
////    imgModel.imgDescrip = nil;
//    LCHouseHoldImage *imgModel = [[LCHouseHoldImage alloc] init];
//
//    
//    [self.dataArray addObject:imgModel];
//    
//    //3.刷新表
//    [self.collectionView reloadData];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    for (LCHouseHoldImage *model in self.dataArray) {
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:model.imageurl]]];
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



#pragma mark - Network

- (void)requestNetwork {
    NSDictionary *sendDic = @{@"flag":@"queryfarnerimage",
                              @"nhId":self.houseHold.nhid};
    
    [LCAFNetWork POST:@"farmerBasicInfo" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"state"] intValue] == 1 ) {
            [self convertIntoModelWithData:responseObject];
        }else {
            
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)convertIntoModelWithData:(id)reponse {
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dic in reponse[DATA]) {
        LCHouseHoldImage *model = [LCHouseHoldImage yy_modelWithDictionary:dic];
        [tempArr addObject:model];
    }
    
    [self.dataArray setArray:tempArr];
    [self.collectionView reloadData];
    
}


// 上传单张图片
- (void)uploadSingleImage:(NSData *)imgData {
    NSDictionary *sendDic = @{@"nhId":self.houseHold.nhid,
                              @"imagecontent":@""};
    
    NSString *nameStr = StrFormat(@"%@.jpg",[self dataWithFormat:@"YYYYMMddHHmmss"]);

    [self.view makeToastActivity];
    
    [LCAFNetWork uploadWithURL:@"oneimage" params:sendDic fileData:imgData name:@"upload" fileName:nameStr mimeType:@"image/jpeg" progress:^(NSProgress *progress) {
        DLog(@"+++%@", progress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject----%@",responseObject);
        
        [self.view hideToastActivity];
        if ([responseObject[STATE] intValue] == 1) {
            [self requestNetwork];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view hideToastActivity];
        DLog(@"error:%@", error);
    }];

}



@end
