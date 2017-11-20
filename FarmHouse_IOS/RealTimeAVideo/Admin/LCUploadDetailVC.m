//
//  LCUNuploadDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/21.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCUploadDetailVC.h"
#import "LCOfflineImgCell.h"
#import "LCOfflineModel.h"
#import "UIImage+water.h" //水印图片
#import "JCAlertView.h" //cell大图显示，依赖 Accelerate.framework
#import "LCCollectionHeader.h"
#import "OfflineModel+CoreDataClass.h"
#import "EWLTabBar.h"
#import "LCLonginVC.h"

@interface LCUploadDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,EWLTabBarDelegate, MBProgressHUDDelegate>{
    NSString *_userId;
    LCHeadUpload *elementView;
    NSString *houseName;
    MBProgressHUD *_hud;
}

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) EWLTabBar *tabBar;
@end

@implementation LCUploadDetailVC
static NSString *imgCellid = @"offimgCell";
static NSString *uploadHead = @"uploadHead";

#define isEndCell (indexPath.row == (self.dataArray.count - 1))

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.dataArray setArray:(NSArray*)self.model.offlineArray];

    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.tabBar];

}

- (EWLTabBar *)tabBar {
    if (!_tabBar) {
        NSDictionary *dict1 = @{NORMAL_IMAGE:[UIImage imageNamed:@"offline_delete"],
                                SELECTED_IMAGE:[UIImage imageNamed:@"offline_delete"],
                                ITEM_TITLE:@"删除"};
        NSDictionary *dict2 = @{NORMAL_IMAGE:[UIImage imageNamed:@"offline_upload"],
                                SELECTED_IMAGE:[UIImage imageNamed:@"offline_upload"],
                                ITEM_TITLE:@"上传"};
        
        NSArray *contentArr = @[dict1,
                                dict2];

        _tabBar = [[EWLTabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHT-64-49, SCREEN_WIDTH, 49) contentArray:contentArr style:EWLTabBatStylePlain];
        _tabBar.delegate = self;
    }
    return _tabBar;
}

// 懒加载 先放一个空model占着
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
        flowLayout.itemSize = CGSizeMake(80, 100);
        //滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //最小行间距
        flowLayout.minimumLineSpacing = 25;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 10;
        //分区间距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //区头大小
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, AutoWHGetHeight(150));
        //区尾大小
        //        flowLayout.footerReferenceSize =CGSizeMake(SCREEN_WIDTH, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64-49) collectionViewLayout:flowLayout];
        
        //集合视图的创建
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //注册cell(好像必须要注册)
        [_collectionView registerClass:[LCOfflineImgCell class] forCellWithReuseIdentifier:imgCellid];
        
        //        //注册区头
        [_collectionView registerClass:[LCHeadUpload class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:uploadHead];
        //        //注册区尾
        //        [collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
        
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCOfflineImgModel *imgModel = self.dataArray[indexPath.row];
    
    
    
    LCOfflineImgCell *imgCell = [LCOfflineImgCell createCellWithCollection:collectionView reuseIdentifier:imgCellid atIndexPath:indexPath];
    
    [imgCell setValueWithModel:imgModel isEnd:NO];
    return imgCell;
    
}

//创建附加视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //附加视图: 区头, 区尾
    //kind: 用于区分区头, 区尾
    //区头:UICollectionElementKindSectionHeader
    //区尾:UICollectionElementKindSectionFooter
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        elementView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:uploadHead forIndexPath:indexPath];
        [elementView setUploadHead:self.model];
        
    }
    
    return elementView;
    
}



- (void)tabBar:(EWLTabBar *)tabBar didSelectedIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"确定要删除这条离线数据吗?" cancelTitle:@"确定" cancelHandler:^{
                [self deleteModelFromDataBase];
            }];
        }
            break;
        case 1:{
            [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"确定要再次上传这条离线数据吗?" cancelTitle:@"确定" cancelHandler:^{
                [self createZipAndTxt];
            }];

        }
        default:
            break;
    }
}

//上传先创建zip, txt文本
- (void)createZipAndTxt{
    
    if (UDSobjectForKey(ISLOGIN) == NO) {
        __weak typeof (self)weakSelf = self;
        [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"您还没有登录,请先登录!" cancelTitle:@"登录" cancelHandler:^{
            LCLonginVC *logVC = [[LCLonginVC alloc] init];
            [weakSelf.navigationController pushViewController:logVC animated:YES];
        }];
        
        return;
    }

    
    
     _userId = [NSString stringWithFormat:@"%@", UDSobjectForKey(USERID)];
    
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];;
    _hud.labelText = @"0%";
    _hud.detailsLabelText = @"正在上传";

    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    [self.dataArray enumerateObjectsUsingBlock:^(LCOfflineImgModel   *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [SandBoxManager writeToDirectory:[SandBoxManager creatPathUnderCaches:@"/OfflineImg"]
                               WithImage:model.image
                               imageName:[model.filePath componentsSeparatedByString:@"."].firstObject
                                 imgType:@"jpg"];
    }];

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *cachePath1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) firstObject];
        NSString *cachePath = [SandBoxManager creatPathUnderCaches:@"/OfflineImg"];
        //目标路径
        NSString *zipFilePath = [NSString stringWithFormat:@"%@/%@.zip",cachePath, self.model.reserveOne];
        
        //转化txt文本
        NSMutableArray *txtZipArray = @[].mutableCopy;
        for (LCOfflineImgModel *texImageModel in self.dataArray) {
            //文本存储
            NSString *titleStr = [[texImageModel.filePath componentsSeparatedByString:@"."] firstObject];
            NSString *txtPath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@.txt", titleStr]];
            [texImageModel.imgDescrip writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [txtZipArray addObject:txtPath];
            //图片存储
            
            NSString *zipFilePath = [cachePath1 stringByAppendingString:[NSString stringWithFormat:@"/OfflineImg/%@",texImageModel.filePath]];
            [txtZipArray addObject:zipFilePath];
        }

        
        
        if ([SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:txtZipArray]) {
            NSLog(@"压缩成功%@", zipFilePath);
            [self uploadZipdata:[NSData dataWithContentsOfFile:zipFilePath] fileName:[NSString stringWithFormat:@"%@.zip", self.model.reserveOne]];
            
        }else {
            NSLog(@"压缩失败");
        }
    });
}

/** 上传zip */
- (void)uploadZipdata:(NSData *)data fileName:(NSString *)fileName{ //remark
    
    NSDictionary *sendDic = @{@"flag":@"app",
                              @"Farmerid":self.model.farmerId,
                              @"userid":_userId,
                              @"zip":fileName};
    
    NSLog(@"sendDic:%@", sendDic);
    
    __weak typeof(self)weakSelf = self;
    [LCAFNetWork uploadWithURL:@"remark" params:sendDic fileData:data name:@"upload" fileName:fileName mimeType:@"zip" progress:^(NSProgress *progress) {
        NSLog(@"%@", progress);

        dispatch_async(dispatch_get_main_queue(), ^{
            _hud.progress = progress.fractionCompleted;
            _hud.labelText = [NSString stringWithFormat:@"%.f%%", progress.fractionCompleted * 100];
            if (progress.fractionCompleted == 1) {
                _hud.detailsLabelText = @"上传成功";
            } else {
                _hud.detailsLabelText = @"正在上传";
            }
        });

    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //上传成功保存数据已上传, 清空zip文件夹
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
        [weakSelf performSelectorInBackground:@selector(emiptyUploadFile) withObject:nil];

        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@", [error localizedDescription]);
        //上传失败保存数据未上传, 清空zip文件夹
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _hud.detailsLabelText = @"上传失败";
            [_hud hide:YES];
        });
     //   [weakSelf emiptyUploadFile];
        [weakSelf performSelectorInBackground:@selector(emiptyUploadFile) withObject:nil];

    }];
}


/**
 删除存放zip和txt的文本
 */
- (void)emiptyUploadFile{
    [SandBoxManager deleteCacheFileWithPath:@"/OfflineImg"];
}


//删除
- (void)deleteModelFromDataBase{
    [self.model MR_deleteEntity];
    __weak typeof(self)weakSelf = self;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (weakSelf.upBlock) {
            weakSelf.upBlock(nil);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma mark - UICollectionViewDelegateFlowLayout

//控制item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return AutoCGSizeMake(140, 205);
    
}

//分区间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //1.save to cache file
    NSDate *date = [NSDate date];
    
    NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
    [array replaceObjectAtIndex:0 withObject:[date format:@"YYYY/MM/dd/ HH:mm:ss"]];
    
    UIImage *waterImg = [[info valueForKey:UIImagePickerControllerOriginalImage] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
    
    NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatPathUnderCaches:@"/OfflineImg"]
                                               WithImage:waterImg
                                               imageName:[date format:@"YYYYMMddHHmmss"]
                                                 imgType:@"jpg"];
    
    if (imgPath == nil) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [LCAlertTools showTipAlertViewWith:self title:@"存储失败" message:nil buttonTitle:@"确定" buttonStyle:UIAlertActionStyleDefault];
        }];
        return;
    }
    
    
    //2.赋值model
    LCOfflineImgModel *imgModel = [[LCOfflineImgModel alloc] initWithImageContentsOfFile:imgPath description:@"shuole也没用"];
    [self.dataArray insertObject:imgModel atIndex:self.dataArray.count-1];
    
    
    //3.刷新表
    [self.collectionView reloadData];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Others
/** 倒二位置添加一个cell */
//- (void)collectionView:(UICollectionView *)collectionView addNewCellIndex:(NSIndexPath *)indexPath {
//    
//    NSArray *titleArr = @[@"拍照",@"从相册中选取"];
//    NSArray *styleArr = @[[NSNumber numberWithInteger:UIAlertActionStyleDefault],
//                          [NSNumber numberWithInteger:UIAlertActionStyleDefault]];
//    
//    [LCAlertTools showActionSheetWith:self title:nil message:nil cancelButtonTitle:@"取消" actionTitleArray:titleArr actionStyleArray:styleArr cancelHandler:nil callbackBlock:^(NSInteger actionIndex) {
//        DLog(@"%@-%ld", titleArr[actionIndex], actionIndex);
//        
//        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
//        pickerVC.delegate = self;
//        
//        if (actionIndex == 0) { //拍照
//            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"没有找到可用的相机" buttonTitle:@"确定" buttonStyle:UIAlertActionStyleCancel];
//                return;
//            }
//            pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//        }else {
//            pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        }
//        pickerVC.videoQuality = UIImagePickerControllerQualityType640x480;
//        
//        [self presentViewController:pickerVC animated:YES completion:nil];
//    }];
//    
//}

/** 显示cell大图，并编辑 */
- (void)collectionView:(UICollectionView *)collectionView showDetailIndex:(NSIndexPath *)indexPath {
    LCOfflineImgModel *model = self.dataArray[indexPath.row];
    
    UIView *cusView = [self creatItemDetailView:model.filePath describe:model.imgDescrip];
    
    JCAlertView *alert = [[JCAlertView alloc] initWithCustomView:cusView dismissWhenTouchedBackground:YES];
    
    [alert show];
}

- (UIView *)creatItemDetailView:(NSString *)imgName describe:(NSString *)description {
    CGFloat padding = 10.f;
    
    UIView *cusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, SCREEN_HIGHT - 80)];
    cusView.backgroundColor = [UIColor whiteColor];
    cusView.layer.cornerRadius = 5.0f;
    cusView.clipsToBounds = YES;
    
    //desLab
    UILabel *desLab = [LCTools createLable:@"描述：" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    //    desLab.backgroundColor = [UIColor redColor];
    [cusView addSubview:desLab];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = kFontSize14;
    [cusView addSubview:textView];
    
    
    //image
    NSString *imgPath =  [[SandBoxManager creatPathUnderCaches:@"/OfflineImg/"] stringByAppendingString:imgName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgPath]];
    [cusView addSubview:imageView];
    
    //deleteBtn
    UIButton *deleteBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"删 除" titleColor:[UIColor redColor] font:kFontSize17 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cusView addSubview:deleteBtn];
    
    //saveBtn
    UIButton *saveBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"保 存" titleColor:[UIColor blueColor] font:kFontSize17 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
    [deleteBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cusView addSubview:saveBtn];
    
    
    
    [desLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.top).offset(5);
        make.left.equalTo(cusView.left).offset(padding);
        make.right.equalTo(textView.left);
        make.height.equalTo(AutoWHGetHeight(25));
        
    }];
    
    [textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cusView.top).offset(padding);
        make.right.equalTo(cusView.right).offset(-padding);
        make.height.equalTo(AutoWHGetHeight(40));
    }];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.bottom).offset(padding);
        make.left.equalTo(cusView.left).offset(padding);
        make.right.equalTo(cusView.right).offset(-padding);
        make.bottom.equalTo(deleteBtn.top).offset(-padding);
    }];
    
    [deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusView.left).offset(padding);
        make.right.equalTo(saveBtn.left).offset(-padding);
        make.bottom.equalTo(cusView.bottom).offset(-padding);
        make.height.equalTo(AutoWHGetHeight(40));
    }];
    
    [saveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deleteBtn.top);
        make.right.equalTo(cusView.right).offset(-padding);
        make.height.equalTo(deleteBtn.height);
        make.width.equalTo(deleteBtn.width);
    }];
    
    return cusView;
}

- (void)deleteBtnAction:(UIButton *)button {
    NSLog(@"delete cell");
}


- (void)saveBtnAction:(UIButton *)button {
}


- (UICollectionReusableView *)creatHeaderView {
    
    //    FooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footer forIndexPath:indexPath];
    //    footerView.label.text = @"来一场说走就走的旅行";
    
    
    CGFloat padding = 5.0f;
    
    UICollectionReusableView *bgView = [[UICollectionReusableView alloc] init];
    UILabel *caseInfo = [LCTools createLable:@"案件信息" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:caseInfo];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = MainColor;
    [bgView addSubview:lineView1];
    
    UILabel *houseLab = [LCTools createLable:@"房屋位置：" withFont:kFontSize16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:houseLab];
    
    UITextField *houseField = [LCTools createTextField:kFontSize16 borderStyle:UITextBorderStyleNone withPlaceholder:@"请输入房屋地址"];
    [bgView addSubview:houseField];
    
    UILabel *photoLab = [LCTools createLable:@"案件图片" withFont:kFontSize16 textColor:[UIColor orangeColor] textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:photoLab];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = MainColor;
    [bgView addSubview:lineView2];
    
    
    [caseInfo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(padding);
        make.left.equalTo(bgView).offset(padding);
        make.height.equalTo(@[houseLab, photoLab]);
    }];
    
    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseInfo).offset(padding);
        make.left.equalTo(bgView).offset(padding);
        make.right.equalTo(bgView).offset(-padding);
    }];
    
    [houseLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1).offset(padding);
        make.left.equalTo(bgView).offset(padding);
        make.right.equalTo(bgView).offset(-padding);
        make.bottom.equalTo(photoLab.top).offset(-padding);
    }];
    
    [photoLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(padding);
        make.bottom.equalTo(lineView2.top).offset(-padding);
    }];
    
    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(padding);
        make.right.equalTo(bgView).offset(-padding);
    }];
    
    return bgView;
}

@end
