//
//  LCUNuploadDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/21.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCUNuploadDetailVC.h"
#import "LCOfflineImgCell.h"
#import "LCOfflineModel.h"
#import "UIImage+water.h" //水印图片
#import "UIImage+compress.h" //压缩图片
#import "JCAlertView.h" //cell大图显示，依赖 Accelerate.framework
#import "LCCollectionHeader.h"
#import "OfflineModel+CoreDataClass.h"
#import "UUID.h"
#import "UITextViewPlaceholder.h"
#import "EWLTabBar.h"
#import "LCHouseholderVC.h"
#import "LCFarmNewsModel.h"
#import "LCLonginVC.h"


@interface LCUNuploadDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EWLTabBarDelegate,MBProgressHUDDelegate>{
    NSString *_userId;
    LCHeadUNupload *elementView;
    NSString *houseName;
    NSInteger itemIndex;
    JCAlertView *alert;
    UITextView *desTextView;
    MBProgressHUD *_hud;
    
    NSString *_houseStr;
    NSString *_farmerId;
    NSMutableArray *_inforImageArray;
}

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) NSMutableArray *fileArray;

@end

@implementation LCUNuploadDetailVC
static NSString *imgCellid = @"offimgCell";
static NSString *addCellid = @"addCell";
static NSString *upuploadHead = @"sectionHead";

#define isEndCell (indexPath.row == (self.dataArray.count))


- (void)viewDidLoad {
    [super viewDidLoad];
    [self assignmentInstruction];
    [self.dataArray setArray:(NSArray*)self.model.offlineArray];
    _fileArray = @[].mutableCopy;


    [self.view addSubview:self.collectionView];
    
   
    
    [self.view addSubview:[self creatTabBar]];
    
    UIBarButtonItem *backItemUnload = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(backIfNeedSaveUnload)];
    backItemUnload.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItemUnload;
    
}

- (void)assignmentInstruction{
    _houseStr = self.model.houseInfo;
    _farmerId = self.model.farmerId?self.model.farmerId:@"";
    _inforImageArray = @[].mutableCopy;
    for (LCOfflineImgModel *model in (NSArray *)_model.offlineArray) {
        [_inforImageArray addObject:@{@"imgPath":model.filePath, @"des":model.imgDescrip?model.imgDescrip:@""}];
    }
}

- (void)backIfNeedSaveUnload{
   
//    NSString *houseAddress = [elementView.houseField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *farmerId = elementView.farmerId?elementView.farmerId:@"";
    __block BOOL isExist = NO;
    __weak typeof(self)weakSelf = self;
    if (_inforImageArray.count == _dataArray.count) {
        [_dataArray enumerateObjectsUsingBlock:^(LCOfflineImgModel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *imgModelDic = _inforImageArray[idx];
            NSString *objDes = obj.imgDescrip ? obj.imgDescrip:@"";
            NSString *imgDes = [imgModelDic objectForKey:@"des"];
            NSString *imgPath = [imgModelDic objectForKey:@"imgPath"];
            if (![obj.filePath isEqualToString:imgPath]||![objDes isEqualToString:imgDes]) {//数组中已经存在该对象
                *stop = YES;
                isExist = YES;
                [weakSelf alertAppear];
                return ;
            }
            if (idx == _dataArray.count - 1 && !isExist) {
                
                if (![farmerId isEqualToString:_farmerId]) {
                    [self alertAppear];
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }else{
        [self alertAppear];
    }
   
}

- (void)alertAppear{
     __weak typeof(self)weakSelf = self;
    [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"是否保存信息?" cancelTitle:@"不保存" defaultTitle:@"保存" cancelHandler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } defaultHandler:^{
        [weakSelf rightBarItemClick];
    }];
}

#pragma mark - 懒 加 载
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
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, AutoWHGetHeight(78)+50);
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
        [_collectionView registerClass:[LCOfflineAddCell class] forCellWithReuseIdentifier:addCellid];

//        //注册区头
        [_collectionView registerClass:[LCHeadUNupload class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:upuploadHead];
//        //注册区尾
//        [collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
        
    }
    return _collectionView;
}


#pragma mark - UI

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
        
        LCOfflineImgModel *imgModel = self.dataArray[indexPath.row];

        LCOfflineImgCell *imgCell = [LCOfflineImgCell createCellWithCollection:collectionView reuseIdentifier:imgCellid atIndexPath:indexPath];
        
        [imgCell setValueWithModel:imgModel isEnd:isEndCell];
//        imgCell.imgView.image = []
        return imgCell;

    }
    
    
}

//创建附加视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //附加视图: 区头, 区尾
    //kind: 用于区分区头, 区尾
    //区头:UICollectionElementKindSectionHeader
    //区尾:UICollectionElementKindSectionFooter
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        elementView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:upuploadHead forIndexPath:indexPath];
        [elementView setUnuploadHead:self.model];
        
        __weak typeof (self)weakSelf = self;
        __weak typeof(LCHeadUNupload *) weakView = elementView;
        elementView.btnBlock = ^(){
            LCHouseholderVC *houseHolderVC = [[LCHouseholderVC alloc] init];
            houseHolderVC.chooseBlcok = ^(LCHouseholderModel *chooseModel){
                weakView.houseName.text = chooseModel.name;
                weakView.farmerNamer = chooseModel.name;
                weakView.farmerId = [NSString stringWithFormat:@"%@", chooseModel.masterid];
                weakView.houseInfo = chooseModel.address;
            };
            houseHolderVC.isChoose = YES;
            [weakSelf.navigationController pushViewController:houseHolderVC animated:YES];
        };
    }
    return elementView;

}

//选中哪一个item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld, %ld", indexPath.section, indexPath.item);
    
    if (isEndCell) {
        [self collectionView:collectionView addNewCellIndex:indexPath];
    }else {
        [self collectionView:collectionView showDetailIndex:indexPath];
    }
    
    
}

- (void)tabBar:(EWLTabBar *)tabBar didSelectedIndex:(NSInteger )index {
    switch (index) {
        case 0:{
            [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"确定要删除这条离线数据吗?" cancelTitle:@"确定" cancelHandler:^{
                [self deleteModelFromDataBase];
            }];
        }
            break;
        case 1:{
            [self rightBarItemClick];
        }
            break;
        case 2:{
            [self createZipAndTxt];
        }
        default:
            break;
    }
}

#pragma mark - tabBar底部三按钮方法
//保存
- (void)rightBarItemClick {
    NSLog(@"save edit of cell");
    //1.将图片写到沙盒
    //2.路径写到coreData
    //如果房屋位置和案件图片不为空则可以存储, 否则不可以存储
    if (_dataArray.count != 0) {
        //3.这里是增加操作，属于更新，保存有问题（每次修改都会增加一个新表）
        
        
        if (self.saveBlock) {
            self.saveBlock(self.model);
            [self.navigationController popViewControllerAnimated:YES];
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            __weak typeof(self)weakSelf = self;
            
            self.model.offlineArray = _dataArray;
            self.model.houseInfo = elementView.houseInfo;
            self.model.isUpload = NO;
            self.model.farmerName = elementView.farmerNamer;
            self.model.farmerId = elementView.farmerId;
            //修改专用
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                OfflineModel *dataModel  = [OfflineModel MR_findFirstByAttribute:@"reserveOne" withValue:weakSelf.model.reserveOne inContext:localContext];
                
                dataModel.houseInfo = elementView.houseInfo;
//                 dataModel.userId = _userId;
                dataModel.isUpload = NO;
                dataModel.offlineArray = _dataArray;
                dataModel.reserveOne = self.model.reserveOne;
                dataModel.farmerId = elementView.farmerId;
                dataModel.farmerName = elementView.farmerNamer;
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                
            }];

        });
        }else{
        [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"房屋位置/案件图片信息不完整" buttonTitle:nil buttonStyle:UIAlertActionStyleDefault];
        return;
    }
}
//删除
- (void)deleteModelFromDataBase{
    [self.model MR_deleteEntity];
    __weak typeof(self)weakSelf = self;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (weakSelf.saveBlock) {
            weakSelf.saveBlock(nil);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
//    [_fileArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [SandBoxManager deleteCacheFileWithPath:[NSString stringWithFormat:@"/OfflineImg/%@", obj]];
//    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout

//控制item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return AutoCGSizeMake(140, 205);

}

//分区间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 0, 10);
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //1.save to cache file should not be writen here //9922017022214249523387.zip
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dateStr = [NSDate format:@"YYYY/MM/dd/ HH:mm:ss"];
        //    NSString *imgName = [NSDate imageNameWith:[UUID getDeviceNum]];
        
        NSString *imgName = [NSString stringWithFormat:@"%@_%@.jpg", _model.reserveOne, [NSDate format:@"YYYYMMddHHmmss"]];
        NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
        [array replaceObjectAtIndex:0 withObject:dateStr];
        [array replaceObjectAtIndex:1 withObject:StrFormat(@"RNO：%@", _model.reserveOne)];
        
        UIImage *waterImg = [[info valueForKey:UIImagePickerControllerOriginalImage] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
        
        //2.赋值model
        LCOfflineImgModel *imgModel = [[LCOfflineImgModel alloc] init];
        imgModel.filePath = imgName;
        imgModel.image = [UIImage imageWithData:[UIImage zipImageWithImage:waterImg]];
        imgModel.imgDescrip = nil;
        
        [self.dataArray addObject:imgModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //3.刷新表
            [self.collectionView reloadData];
        });
        
    });
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    
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
    LCOfflineImgModel *model = self.dataArray[indexPath.row];
    
    UIView *cusView = [self creatItemDetailView:model.image describe:model.imgDescrip];
    itemIndex = indexPath.row;
    alert = [[JCAlertView alloc] initWithCustomView:cusView dismissWhenTouchedBackground:YES];
    
    [alert show];
}

- (UIView *)creatItemDetailView:(UIImage *)image describe:(NSString *)description {
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
//    NSString *imgPath =  [[SandBoxManager creatPathUnderCaches:@"/OfflineImg/"] stringByAppendingString:imgName];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgPath]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [cusView addSubview:imageView];
    
    //deleteBtn
    UIButton *deleteBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"删 除" titleColor:[UIColor redColor] font:kFontSize17 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cusView addSubview:deleteBtn];
    
    //saveBtn
    UIButton *saveBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"保 存" titleColor:[UIColor blueColor] font:kFontSize17 bgColor:[UIColor whiteColor] cornerRadius:3.0f borderColor:[UIColor lightGrayColor] borderWidth:0.5f];
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
    NSLog(@"delete cell%@", desTextView.text);
    
    LCOfflineImgModel *model = self.dataArray[itemIndex];
    
    BOOL isDelete = [SandBoxManager deleteCacheFileWithPath:[NSString stringWithFormat:@"/OfflineImg/%@", model.filePath]];
    NSLog(@"-------==========%d", isDelete);
    
//    [self.fileArray removeObject:model.filePath];
    [self.dataArray removeObjectAtIndex:itemIndex];
    [self.collectionView reloadData];
    [alert dismissWithCompletion:nil];
}


- (void)saveBtnAction:(UIButton *)button {
    NSLog(@"save info %@", desTextView.text);
    //1. moddify model
    //2. updata UI
    LCOfflineImgModel *imageModel = self.dataArray[itemIndex];
    imageModel.imgDescrip = [desTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.collectionView reloadData];
    [alert dismissWithCompletion:nil];
}

/**
 测试点击数据内容
 */
- (void)loadDataArray{
    //获取所有的数据
    NSArray *offlinemodelArray = [OfflineModel MR_findAll];
    NSLog(@"%ld", offlinemodelArray.count);
    [offlinemodelArray enumerateObjectsUsingBlock:^(OfflineModel  *offlineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = (NSArray *)offlineModel.offlineArray;
        LCOfflineImgModel *model = array.lastObject;
        NSLog(@"%@, %@, %d, %@", offlineModel.houseInfo, offlineModel.userId, offlineModel.isUpload, model.description);
    }];
}


- (void)collectionTakePicture:(UICollectionView *)collectionView {

}


//判断是否可以上传或保存
- (BOOL)judgeCanUpOrSave{
    if (_dataArray.count != 0 && elementView.farmerId.length != 0){
        return YES;
    }
    [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"信息填写不完整" buttonTitle:nil buttonStyle:UIAlertActionStyleDefault];
    return NO;
}

//上传先创建zip, txt文本
- (void)createZipAndTxt{
    
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
    
    [self.dataArray enumerateObjectsUsingBlock:^(LCOfflineImgModel   *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [SandBoxManager writeToDirectory:[SandBoxManager creatPathUnderCaches:@"/OfflineImg"]
                               WithImage:model.image
                               imageName:[model.filePath componentsSeparatedByString:@"."].firstObject
                                 imgType:@"jpg"];
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *cachePath1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) firstObject];
        NSString *cachePath = [SandBoxManager creatPathUnderCaches:@"/OfflineImg"];
        //目标路径[
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
          //  NSLog(@"压缩成功%@", zipFilePath);
            [self uploadZipdata:[NSData dataWithContentsOfFile:zipFilePath] fileName:[NSString stringWithFormat:@"%@.zip", self.model.reserveOne]];
            
        }else {
            NSLog(@"压缩失败");
        }
    });
}


/**
 保存数据

 @param isSave 是否上传
 */
- (void)saveOfflineDataWithIsSave:(BOOL)isSave{
    __weak typeof(self)weakSelf = self;
    
    self.model.offlineArray = _dataArray;
    self.model.houseInfo = elementView.houseInfo;
  //  self.model.userId = _userId;
    self.model.isUpload = isSave;
    self.model.farmerId = elementView.farmerId;
    self.model.farmerName = elementView.farmerNamer;
    //修改专用
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
       OfflineModel *dataModel  = [OfflineModel MR_findFirstByAttribute:@"reserveOne" withValue:weakSelf.model.reserveOne inContext:localContext];
        dataModel.houseInfo = elementView.houseInfo;
        // dataModel.userId = _userId;
        dataModel.isUpload = isSave;
        dataModel.offlineArray = _dataArray;
        dataModel.reserveOne = self.model.reserveOne;
        dataModel.farmerId = elementView.farmerId;
        dataModel.farmerName = elementView.farmerNamer;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (weakSelf.saveBlock) {
            weakSelf.saveBlock(weakSelf.model);
        }
        if (isSave) {
            if (_uploadBlock) {
                _uploadBlock(weakSelf.model);
            }
        }
    }];

}

/** 上传zip */
- (void)uploadZipdata:(NSData *)data fileName:(NSString *)fileName{ //remark
    
    NSDictionary *sendDic = @{@"flag":@"app",
                           @"Farmerid":elementView.farmerId,
                           @"userid":_userId,
                           @"zip":fileName};
    
   
    
    __weak typeof(self)weakSelf = self;
    [LCAFNetWork uploadWithURL:@"remark" params:sendDic fileData:data name:@"upload" fileName:fileName mimeType:@"zip" progress:^(NSProgress *progress) {
        NSLog(@"%@", progress);
         [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //上传成功保存数据已上传, 清空zip文件夹
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        [weakSelf saveOfflineDataWithIsSave:YES];
        [weakSelf performSelectorInBackground:@selector(emiptyUploadFile) withObject:nil];
      //  [weakSelf emiptyUploadFile];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@", [error localizedDescription]);
        //上传失败保存数据未上传, 清空zip文件夹
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _hud.detailsLabelText = @"上传失败";
            [_hud hide:YES];
        });
        [weakSelf saveOfflineDataWithIsSave:NO];
        [weakSelf performSelectorInBackground:@selector(emiptyUploadFile) withObject:nil];

      //  [weakSelf emiptyUploadFile];
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSProgress *progress = nil;
    if ([object isKindOfClass:[NSProgress class]]) {
        progress = (NSProgress *)object;
    }
    if (progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _hud.progress = progress.fractionCompleted;
            _hud.labelText = [NSString stringWithFormat:@"%.f%%", progress.fractionCompleted * 100];
            if (progress.fractionCompleted == 1) {
                _hud.detailsLabelText = @"上传成功";
            } else {
                _hud.detailsLabelText = @"正在上传";
            }
        });
    }
}

/**
 删除存放zip和txt的文本
 */
- (void)emiptyUploadFile{
    [SandBoxManager deleteCacheFileWithPath:@"/OfflineImg"];
}


@end
