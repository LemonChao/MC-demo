//
//  LCPhotoDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPhotoDetailVC.h"
#import "LCGatherPhotoCell.h"
#import "LCOfflineImgCell.h"
#import "LCPhotoModel.h"
#import "UIImage+water.h" //水印图片
#import "UIImage+compress.h" //压缩图片
#import "JCAlertView.h" //cell大图显示，依赖 Accelerate.framework
#import "LCCollectionHeader.h"
#import "GatherPhoto+CoreDataClass.h"
#import "UUID.h"
#import "UITextViewPlaceholder.h"
//#import "LCPhotoListVC.m"
#import "LCHouseholderVC.h"
#import "LCFarmNewsModel.h"  // 使用LCHouseholderModel
#import "EWLTabBar.h"
#import "LCLonginVC.h"



@interface LCPhotoDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EWLTabBarDelegate>{
    NSString *_userId;
    LCHeadGather *elementView;
    NSString *reportNum; //报案号
    NSString *houseAddress; //选择户主产生的房屋地址
    UITextViewPlaceholder *desTextView;
    JCAlertView *alert;
    NSIndexPath *selectIndex;
    
    MBProgressHUD *_hud;
    BOOL imgDesChange; //图片描述是否改变
    NSMutableArray *originArray; //保留初始数组，用于比较
}

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LCPhotoDetailVC
static NSString *imgCellid = @"offimgCell";
static NSString *addCellid = @"addCell";
static NSString *sectionHe = @"sectionHead";

#define isEndCell (indexPath.row == (self.dataArray.count))


- (void)viewDidLoad {
    [super viewDidLoad];
    reportNum = self.gatherPhoto.reportNum;
    
    //这两种方法备份的数组，后面对model的修改仍然能影响到备份数组
//    [originArray setArray:(NSArray*)self.gatherPhoto.photoArray];
//    originArray = [NSArray setarr ];
    originArray =  @[].mutableCopy;
    [(NSArray*)self.gatherPhoto.photoArray enumerateObjectsUsingBlock:^(LCPhotoModel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LCPhotoModel *model = [[LCPhotoModel alloc] init];
        model.filePath = obj.filePath;
        model.imgDescrip = obj.imgDescrip;
        model.image = obj.image;
        
        [originArray addObject:model];
    }];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:[self creatTabBar]];
    
    _userId =[NSString stringWithFormat:@"%@", UDSobjectForKey(USERID)];
}


/**
 是否应该保存

 @return YES,需要保存
 */
- (BOOL)shouldSaved{
    
    __block BOOL shouldsave = NO;
    
    //1.校验name
    if (![self.gatherPhoto.houseName isEqualToString:elementView.farmerName]) {
        return shouldsave = YES;
    }
    
    //1.校验图片描述
    if (originArray.count == self.dataArray.count) {
        
        shouldsave = NO;
        [_dataArray enumerateObjectsUsingBlock:^(LCPhotoModel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LCPhotoModel *model = originArray[idx];
            NSString *objDes = obj.imgDescrip ? obj.imgDescrip:@"";
            NSString *oriDes = model.imgDescrip ? model.imgDescrip:@"";
            
            if (![objDes isEqualToString:oriDes]) {//数组中图片描述出现更改
                *stop = YES;
                shouldsave = YES;
                return;
            }
        }];

    }else {
        return shouldsave = YES;
    }

    
    return shouldsave;
}

-(BOOL)navigationShouldPopOnBackButton {
    
    if ([self shouldSaved]) {
        @WeakObj(self)
        
        [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"是否保存当前修改信息?" cancelTitle:@"保存" defaultTitle:@"取消" cancelHandler:^{
            [selfWeak rightBarItemClick];
        } defaultHandler:^{
            [selfWeak.navigationController popViewControllerAnimated:YES];
        }];

        return NO;
    }else {
        
        return YES;
    }
}


// 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
        [(NSArray*)self.gatherPhoto.photoArray enumerateObjectsUsingBlock:^(LCPhotoModel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LCPhotoModel *model = [[LCPhotoModel alloc] init];
            model.filePath = obj.filePath;
            model.imgDescrip = obj.imgDescrip;
            model.image = obj.image;
            
            [_dataArray addObject:model];
        }];
        
//这种初始化赋值，后面取消对图片描述修改，仍旧会显示修改过后的
//        _dataArray = [NSMutableArray arrayWithArray:(NSArray*)self.gatherPhoto.photoArray];
    }
    return _dataArray;
}


- (EWLTabBar *)creatTabBar {
    
    NSDictionary *dict1 = @{NORMAL_IMAGE:[UIImage imageNamed:@"offline_delete"],
                            SELECTED_IMAGE:[UIImage imageNamed:@"offline_delete"],
                            ITEM_TITLE:@"删除"};
    NSDictionary *dict2 = @{NORMAL_IMAGE:[UIImage imageNamed:@"offline_save"],
                            SELECTED_IMAGE:[UIImage imageNamed:@"offline_save"],
                            ITEM_TITLE:@"保存"};
    NSDictionary *dict3 = @{NORMAL_IMAGE:[UIImage imageNamed:@"offline_upload"],
                            SELECTED_IMAGE:[UIImage imageNamed:@"offline_upload"],
                            ITEM_TITLE:@"上传"};
    
    NSArray *contentArr = @[dict1,
                            dict2,
                            dict3];
    
    
    EWLTabBar *tabBar = [[EWLTabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHT-64-49, SCREEN_WIDTH, 49) contentArray:contentArr style:EWLTabBatStylePlain];
    tabBar.delegate = self;
    return tabBar;
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
        [_collectionView registerClass:[LCGatherPhotoCell class] forCellWithReuseIdentifier:imgCellid];
        [_collectionView registerClass:[LCOfflineAddCell class] forCellWithReuseIdentifier:addCellid];
        
        //        //注册区头
        [_collectionView registerClass:[LCHeadGather class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHe];
        //        //注册区尾
        //        [collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
        
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count+1;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isEndCell) {
        LCOfflineAddCell *imgCell = [LCOfflineAddCell createCellWithCollection:collectionView reuseIdentifier:addCellid atIndexPath:indexPath];
        return imgCell;
        
    }else {
        LCPhotoModel *imgModel = self.dataArray[indexPath.row];
        
        LCGatherPhotoCell *imgCell = [LCGatherPhotoCell createCellWithCollection:collectionView reuseIdentifier:imgCellid atIndexPath:indexPath];
        [imgCell setValueWithModel:imgModel isEnd:isEndCell];
       
        return imgCell;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, AutoWHGetHeight(130));
}

//创建附加视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //附加视图: 区头, 区尾
    //kind: 用于区分区头, 区尾
    //区头:UICollectionElementKindSectionHeader
    //区尾:UICollectionElementKindSectionFooter
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        elementView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHe forIndexPath:indexPath];
        elementView.headType = HeadGatherFieldUnable;
        [elementView setGatherHead:self.gatherPhoto];
        
        __weak typeof (self)weakSelf = self;
        __weak typeof(LCHeadGather *) weakView = elementView;
        elementView.btnBlock = ^(){
            LCHouseholderVC *houseHolderVC = [[LCHouseholderVC alloc] init];
            houseHolderVC.chooseBlcok = ^(LCHouseholderModel *chooseModel){
                weakView.nameField.text = chooseModel.name;
                weakView.farmerName = chooseModel.name;
                weakView.farmerId = [NSString stringWithFormat:@"%@", chooseModel.masterid];
                houseAddress = chooseModel.address;
            };
            houseHolderVC.isChoose = YES;
            [weakSelf.navigationController pushViewController:houseHolderVC animated:YES];
        };
    }
    
    return elementView;
}


//选中哪一个item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectIndex = indexPath;
    NSLog(@"%ld, %ld--%p  %p", indexPath.section, indexPath.item, indexPath, selectIndex);
    
    if (isEndCell) {
        [self collectionView:collectionView addNewCellIndex:indexPath];
    }else {
        [self collectionView:collectionView showDetailIndex:indexPath];
    }
}


#pragma mark - EWLTabBarDelegate
- (void)tabBar:(EWLTabBar *)tabBar didSelectedIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"确定要删除这条离线数据吗?" cancelTitle:@"确定" cancelHandler:^{
                [self deleteModelFromCoreData];
            }];
        }
            break;
        case 1:{
            
            if ([self shouldSaved]) {
                [self rightBarItemClick];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }

        }
            break;
        case 2:{
            [self createZipAndTxt];
        }
        default:
            break;
    }
    
}

// 删除
- (void)deleteModelFromCoreData{
    [self.gatherPhoto MR_deleteEntity];
    
    __weak typeof(self)weakSelf = self;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (weakSelf.saveBlock) {
            weakSelf.saveBlock(nil);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

// 保存
- (void)rightBarItemClick {
    
    //如果房屋位置和案件图片不为空则可以存储, 否则不可以存储
    if ([elementView.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0 && _dataArray.count != 0) {
        //3.这里是增加操作，属于更新，保存有问题（每次修改都会增加一个新表）
        __weak typeof(self)weakSelf = self;
        
        self.gatherPhoto.photoArray = _dataArray;
        self.gatherPhoto.houseInfo = houseAddress;
        self.gatherPhoto.userid = _userId;
        self.gatherPhoto.isUpload = NO;
        self.gatherPhoto.houseName = elementView.farmerName;
//        self.gatherPhoto.nhid = elementView.farmerId;
//        self.gatherPhoto.reportNum = reportNum;
        //修改专用
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {//reportNum
            GatherPhoto *dataModel  = [GatherPhoto MR_findFirstByAttribute:@"reportNum" withValue:weakSelf.gatherPhoto.reportNum inContext:localContext];
            
            dataModel.houseName = elementView.farmerName;
            dataModel.houseInfo = houseAddress;
            dataModel.userid = _userId;
            dataModel.isUpload = NO;
            dataModel.photoArray = _dataArray;
            dataModel.reportNum = self.gatherPhoto.reportNum;
            dataModel.nhid = elementView.farmerId;
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            if (contextDidSave) {
                if (weakSelf.saveBlock) {
                    weakSelf.saveBlock(weakSelf.gatherPhoto);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }

            }
            
        }];
    }else{
        [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"房屋位置/案件图片信息不完整" buttonTitle:nil buttonStyle:UIAlertActionStyleDefault];
        return;
    }
    
    
}


// 上传
- (void)createZipAndTxt {
    
    _userId =[NSString stringWithFormat:@"%@", UDSobjectForKey(USERID)];
    
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN];
    
    if (result == NO) {
        __weak typeof (self)weakSelf = self;
        [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"您还没有登录,请先登录!" cancelTitle:@"登录" cancelHandler:^{
            LCLonginVC *logVC = [[LCLonginVC alloc] init];
            [weakSelf.navigationController pushViewController:logVC animated:YES];
        }];
        
        return;
    }
    
    if (![self judgeCanUpOrSave]) {
        return;
    }
    
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    _hud.labelText = @"0%";
    _hud.detailsLabelText = @"正在上传";
    
    _hud.mode = MBProgressHUDModeAnnularDeterminate;

    
    //1.图片存到沙盒 & coreData
    __weak typeof(self)weakSelf = self;
    
    self.gatherPhoto.photoArray = _dataArray;
    self.gatherPhoto.houseInfo = houseAddress;
    self.gatherPhoto.isUpload = NO;
    self.gatherPhoto.houseName = elementView.farmerName;
    self.gatherPhoto.nhid = elementView.farmerId;
    //修改专用
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        GatherPhoto *dataModel  = [GatherPhoto MR_findFirstByAttribute:@"reportNum" withValue:weakSelf.gatherPhoto.reportNum inContext:localContext];
        
        dataModel.houseName = elementView.farmerName;
        dataModel.houseInfo = houseAddress;
        dataModel.userid = _userId;
        dataModel.isUpload = NO;
        dataModel.photoArray = _dataArray;
        dataModel.reportNum = self.gatherPhoto.reportNum;
        dataModel.nhid = elementView.farmerId;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        DLog(@"保存coreData成功");
    }];

    [self.dataArray enumerateObjectsUsingBlock:^(LCPhotoModel   *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [SandBoxManager writeToDirectory:[SandBoxManager creatPathUnderCaches:@"/uploadzip"]
                               WithImage:model.image
                               imageName:[model.filePath componentsSeparatedByString:@"."].firstObject
                                 imgType:@"jpg"];
    }];
    
    DLog(@"写入沙盒完成");
    
    //2.压缩
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *cachePath1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) firstObject];
        NSString *cachePath = [SandBoxManager creatPathUnderCaches:@"/uploadzip"];
        
        //目标路径
        NSString *zipFilePath = [NSString stringWithFormat:@"%@/%@.zip",cachePath,reportNum];
        //转化txt文本
        NSMutableArray *txtZipArray = @[].mutableCopy;
        for (LCPhotoModel *texImageModel in self.dataArray) {
            //文本存储
            NSString *titleStr = [[texImageModel.filePath componentsSeparatedByString:@"."] firstObject];
            NSString *txtPath = [NSString stringWithFormat:@"%@/%@.txt",cachePath, titleStr];
            [texImageModel.imgDescrip writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [txtZipArray addObject:txtPath];
            //图片存储
            
            NSString *zipFilePath = [cachePath1 stringByAppendingString:[NSString stringWithFormat:@"/uploadzip/%@",texImageModel.filePath]];
            [txtZipArray addObject:zipFilePath];
        }
        if ([SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:txtZipArray]) {
              NSLog(@"----压缩成功%@", zipFilePath);
            
            //3.上传
            [self uploadZipdata:[NSData dataWithContentsOfFile:zipFilePath] fileName:[NSString stringWithFormat:@"%@.zip", self.gatherPhoto.reportNum]];
            
        }else {
            NSLog(@"压缩失败");
        }
    });

    
}


/** 上传zip */
- (void)uploadZipdata:(NSData *)data fileName:(NSString *)fileName{ //remark
    
    NSDictionary *sendDic = @{@"nhid":elementView.farmerId,
                              @"userid":_userId,
                              @"farmername":elementView.farmerName,
                              @"imagecontent":@"imagecontent"};
    
    
    
    __weak typeof(self)weakSelf = self;
    [LCAFNetWork uploadWithURL:@"farmerimage" params:sendDic fileData:data name:@"upload" fileName:fileName mimeType:@"zip" progress:^(NSProgress *progress) {
        
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
        //上传成功, 删除Coredata数据 清空zip文件夹
        [_hud hide:YES];
        [weakSelf deleteModelFromCoreData];
        [SandBoxManager deleteCacheFileWithPath:@"/uploadzip"];

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@", [error localizedDescription]);
        //上传失败, 清空zip文件夹
        _hud.progress = 0.0;
        _hud.labelText = nil;
        _hud.detailsLabelText = @"上传失败";
        [_hud hide:YES afterDelay:1.0];

        [SandBoxManager deleteCacheFileWithPath:@"/uploadzip"];
    }];
}


//判断是否可以上传或保存
- (BOOL)judgeCanUpOrSave{
    if (_dataArray.count != 0 && elementView.farmerId.length != 0){
        return YES;
    }
    [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"信息填写不完整" buttonTitle:nil buttonStyle:UIAlertActionStyleDefault];
    return NO;
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
    
    DLog(@"%p --%ld %ld", selectIndex, selectIndex.section, selectIndex.row);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dateStr = [NSDate format:@"YYYY/MM/dd/ HH:mm:ss"];
        NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
        [array replaceObjectAtIndex:0 withObject:dateStr];
        [array replaceObjectAtIndex:1 withObject:StrFormat(@"RNO：%@", reportNum)];
        
        UIImage *waterImg = [[info valueForKey:UIImagePickerControllerOriginalImage] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
        NSData *imgData = [UIImage zipImageWithImage:waterImg];
        NSString *imgName = [NSString stringWithFormat:@"%@_%@.jpg", reportNum, [NSDate format:@"YYYYMMddHHmmss"]];
        
        LCPhotoModel *imgModel = [[LCPhotoModel alloc] init];
        imgModel.filePath = imgName;
        imgModel.image = [UIImage imageWithData:imgData];
        imgModel.imgDescrip = nil;
        
        [self.dataArray addObject:imgModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //3.刷新表
            [self.collectionView reloadData];
        });

    });
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Others
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
        pickerVC.videoQuality = UIImagePickerControllerQualityType640x480;
        
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    
}

/** 显示cell大图，并编辑 */
- (void)collectionView:(UICollectionView *)collectionView showDetailIndex:(NSIndexPath *)indexPath {
    
    LCPhotoModel *model = self.dataArray[indexPath.row];
    
    UIView *cusView = [self creatItemDetailView:model.image describe:model.imgDescrip Index:indexPath.row];
    
    alert = [[JCAlertView alloc] initWithCustomView:cusView dismissWhenTouchedBackground:YES];
    
    [alert show];
    
}

- (UIView *)creatItemDetailView:(UIImage *)img describe:(NSString *)description Index:(NSInteger)index{
    CGFloat padding = 10.f;
    
    UIView *cusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, SCREEN_HIGHT - 80)];
    cusView.backgroundColor = [UIColor whiteColor];
    cusView.layer.cornerRadius = 5.0f;
    cusView.clipsToBounds = YES;
    
    //desLab
    UILabel *desLab = [LCTools createLable:@"描述：" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    //    desLab.backgroundColor = [UIColor redColor];
    [cusView addSubview:desLab];
    
    UITextViewPlaceholder *textView = [[UITextViewPlaceholder alloc] init];
    textView.font = kFontSize14;
    textView.textColor = [UIColor blackColor];
    textView.placeholder = @"请输入照片描述";
    if (description) {
        textView.text = description;
    }
    [cusView addSubview:textView];
    desTextView = textView;
    
    
    //image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cusView addSubview:imageView];
    
    //deleteBtn
    UIButton *deleteBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"删 除" titleColor:[UIColor redColor] font:kFontSize17 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
    deleteBtn.tag = index + 1000;
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cusView addSubview:deleteBtn];
    
    //saveBtn
    UIButton *saveBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"保 存" titleColor:[UIColor blueColor] font:kFontSize17 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
    saveBtn.tag = index + 10000;
    [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [_dataArray removeObjectAtIndex:button.tag - 1000];
    [alert dismissWithCompletion:^{
        [_collectionView reloadData];
    }];
    
}

// alert save
- (void)saveBtnAction:(UIButton *)button {
    
    LCPhotoModel *imageModel = _dataArray[button.tag - 10000];
    imageModel.imgDescrip = [desTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [alert dismissWithCompletion:^{
        [_collectionView reloadData];
    }];
    
    
}

- (void)textExampleWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    
    [hud hide:YES afterDelay:3.f];
}




/**
 测试点击数据内容
 */
- (void)findData{
    NSArray *offlinemodelArray = [GatherPhoto MR_findAll];
    NSLog(@"%ld", offlinemodelArray.count);
    [offlinemodelArray enumerateObjectsUsingBlock:^(GatherPhoto  *offlineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = (NSArray *)offlineModel.photoArray;
        LCPhotoModel *model = array.lastObject;
        NSLog(@"%@, %@, %d, %@", offlineModel.houseInfo, offlineModel.userid, offlineModel.isUpload, model.description);
    }];
}




@end
