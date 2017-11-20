//
//  LCUNuploadDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/21.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCOfflineChargeVC.h"
#import "LCOfflineImgCell.h"
#import "LCOfflineModel.h"
#import "UIImage+water.h" //水印图片
#import "UIImage+compress.h" //压缩图片
#import "JCAlertView.h" //cell大图显示，依赖 Accelerate.framework
#import "LCCollectionHeader.h"
#import "OfflineModel+CoreDataClass.h"
#import "UUID.h"
#import "UITextViewPlaceholder.h"
#import "LCDataOfflineVC.h"
#import "LCHouseholderVC.h"


@interface LCOfflineChargeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *_userId;
    LCCollectionHeader *elementView;
    NSString *titleStr; //报案号
    UITextViewPlaceholder *desTextView;
    JCAlertView *alert;
    NSIndexPath *selectIndex;
    NSString *houseAddress; //房屋地址
}

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *imageArray1;
//分区1 数据源数组
@property(nonatomic, strong) NSMutableArray *dataArray1;
/** 分区2 图片数组 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/** 分区2 cellModel 数组 */
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LCOfflineChargeVC
static NSString *imgCellid = @"offimgCell";
static NSString *addCellid = @"addCell";
static NSString *sectionHe = @"sectionHead";

#define isEndCell (indexPath.row == (self.dataArray.count))


- (void)viewDidLoad {
    [super viewDidLoad];
    titleStr = [NSDate uploadPicName:[UUID getDeviceNum]];
    _imageArray = @[].mutableCopy;
    [self setDataArray1Value];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.collectionView];
    
    _userId =[NSString stringWithFormat:@"%@", UDSobjectForKey(USERID)];
}

//返回
-(BOOL)navigationShouldPopOnBackButton {
    __weak typeof(self)weakSelf = self;
    if ([elementView.houseField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0 && _dataArray.count != 0) {
        [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"是否保存信息?" cancelTitle:@"不保存" defaultTitle:@"保存" cancelHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } defaultHandler:^{
            [weakSelf rightBarItemClick];
        }];
        
        return NO;
    } else {
        return YES;
    }

}
- (void)backIfNeedSave{
    __weak typeof(self)weakSelf = self;
    if ([elementView.houseField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0 && _dataArray.count != 0) {
        [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"是否保存信息?" cancelTitle:@"不保存" defaultTitle:@"保存" cancelHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } defaultHandler:^{
            [weakSelf rightBarItemClick];
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


// 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//先放12 个占位model
- (void)setDataArray1Value {
    _dataArray1 = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        NSString *imgfile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"photograph_guide%d@2x", i] ofType:@"png"];
        LCOfflineImgModel *model = [[LCOfflineImgModel alloc] init];
        model.placeHolder = YES;
        model.placeholderImg = [UIImage imageWithContentsOfFile:imgfile];
        [_dataArray1 addObject:model];
    }
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) collectionViewLayout:flowLayout];
        
        //集合视图的创建
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //注册cell(好像必须要注册)
        [_collectionView registerClass:[LCOfflineImgCell class] forCellWithReuseIdentifier:imgCellid];
        [_collectionView registerClass:[LCOfflineAddCell class] forCellWithReuseIdentifier:addCellid];
        
        //        //注册区头
        [_collectionView registerClass:[LCCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHe];
        //        //注册区尾
        //        [collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
        
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray1.count;
    }else {
        return self.dataArray.count+1;
    }
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        LCOfflineImgModel *imgModel = self.dataArray1[indexPath.row];
        LCOfflineImgCell *imgCell = [LCOfflineImgCell createCellWithCollection:collectionView reuseIdentifier:imgCellid atIndexPath:indexPath];
        [imgCell setValueWithModel:imgModel isPlaceHolder:imgModel.isPlaceHolder];
        return imgCell;
        
    }else {
        
        if (isEndCell) {
            LCOfflineAddCell *imgCell = [LCOfflineAddCell createCellWithCollection:collectionView reuseIdentifier:addCellid atIndexPath:indexPath];
            return imgCell;
            
        }else {
            LCOfflineImgModel *imgModel = self.dataArray[indexPath.row];
            
            LCOfflineImgCell *imgCell = [LCOfflineImgCell createCellWithCollection:collectionView reuseIdentifier:imgCellid atIndexPath:indexPath];
            [imgCell setValueWithModel:imgModel isEnd:isEndCell];
//            if (_imageArray) {
//                imgCell.imgView.image = _imageArray[indexPath.row];
//            }else{
//                imgCell.imgView.image = nil;
//            }
            
            return imgCell;
            
        }

    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, AutoWHGetHeight(140));
    }else {
        return CGSizeZero;
    }
}

//创建附加视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //附加视图: 区头, 区尾
    //kind: 用于区分区头, 区尾
    //区头:UICollectionElementKindSectionHeader
    //区尾:UICollectionElementKindSectionFooter
    
    if (indexPath.section == 0) {
        
        if (kind == UICollectionElementKindSectionHeader) {
            elementView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHe forIndexPath:indexPath];
            
            __weak typeof (self)weakSelf = self;
            __weak typeof(LCCollectionHeader *) weakView = elementView;
            elementView.btnBlock = ^(){
                LCHouseholderVC *houseHolderVC = [[LCHouseholderVC alloc] init];
                houseHolderVC.chooseBlcok = ^(LCHouseholderModel *chooseModel){
                    
                    weakView.houseField.text = chooseModel.name;
                    weakView.farmerName = chooseModel.name;
                    weakView.farmerId = chooseModel.masterid;//[NSString stringWithFormat:@"%@", chooseModel.masterid];
                    houseAddress = chooseModel.address;

                };
                houseHolderVC.isChoose = YES;
                [weakSelf.navigationController pushViewController:houseHolderVC animated:YES];
            };

        }
    }
    
    return elementView;
}



//选中哪一个item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    selectIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    selectIndex = indexPath;
    NSLog(@"%ld, %ld--%p  %p", indexPath.section, indexPath.item, indexPath, selectIndex);

    
    if (indexPath.section == 0) {
        
        LCOfflineImgModel *model = self.dataArray1[indexPath.row];
        if (model.isPlaceHolder) {
            [self collectionView:collectionView addNewCellIndex:indexPath];
        }else {
            [self collectionView:collectionView showDetailIndex:indexPath];
        }
        
    }else {
        
        if (isEndCell) {
            [self collectionView:collectionView addNewCellIndex:indexPath];
        }else {
            [self collectionView:collectionView showDetailIndex:indexPath];
        }
    }
    
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
    
    DLog(@"indexPoint %p --%ld %ld", selectIndex, selectIndex.section, selectIndex.row);
    
    if (selectIndex.section == 0) {
        NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:selectIndex.row inSection:selectIndex.section];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *dateStr = [NSDate format:@"YYYY/MM/dd/ HH:mm:ss"];
            NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
            [array replaceObjectAtIndex:0 withObject:dateStr];
            [array replaceObjectAtIndex:1 withObject:StrFormat(@"RNO：%@", titleStr)];
            
            UIImage *waterImg = [[info valueForKey:UIImagePickerControllerOriginalImage] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
            NSData *imgData = [UIImage zipImageWithImage:waterImg];
            [_imageArray1 addObject:[UIImage imageWithData:imgData]];
            
            NSString *imgName = [NSString stringWithFormat:@"%@_%@.jpg", titleStr, [NSDate format:@"YYYYMMddHHmmss"]];
            LCOfflineImgModel *imgModel1 = self.dataArray1[currentIndex.row];
            imgModel1.filePath = imgName;
            imgModel1.image = [UIImage imageWithData:imgData];
            imgModel1.placeHolder = NO;
            imgModel1.imgDescrip = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //3.刷新表
                [self.collectionView reloadData];
            });

        });
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;

    }else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *dateStr = [NSDate format:@"YYYY/MM/dd/ HH:mm:ss"];
            NSMutableArray *array = [ActivityApp shareActivityApp].waterTxtArr;
            [array replaceObjectAtIndex:0 withObject:dateStr];
            [array replaceObjectAtIndex:1 withObject:StrFormat(@"RNO：%@", titleStr)];
            
            UIImage *waterImg = [[info valueForKey:UIImagePickerControllerOriginalImage] imageWater:[UIImage imageNamed:@"watermark_picc"] txtArray:array];
            NSData *imgData = [UIImage zipImageWithImage:waterImg];
            [_imageArray addObject:[UIImage imageWithData:imgData]];
            
            NSString *imgName = [NSString stringWithFormat:@"%@_%@.jpg", titleStr, [NSDate format:@"YYYYMMddHHmmss"]];
            LCOfflineImgModel *imgModelA = [[LCOfflineImgModel alloc] initWithImageContentsOfFile:imgName description:nil];
            imgModelA.image = [UIImage imageWithData:imgData];
            [self.dataArray addObject:imgModelA];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //3.刷新表
                [self.collectionView reloadData];
            });
            
        });

        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
        
    }
    
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
    if (indexPath.section == 0) {
        LCOfflineImgModel *model = self.dataArray1[indexPath.row];
        
        UIView *cusView = [self creatItemDetailView:model.image describe:model.imgDescrip Index:indexPath.row];
        
        alert = [[JCAlertView alloc] initWithCustomView:cusView dismissWhenTouchedBackground:YES];
        
        [alert show];

    }else {
        LCOfflineImgModel *model = self.dataArray[indexPath.row];
        
        UIView *cusView = [self creatItemDetailView:_imageArray[indexPath.row] describe:model.imgDescrip Index:indexPath.row];
        
        alert = [[JCAlertView alloc] initWithCustomView:cusView dismissWhenTouchedBackground:YES];
        
        [alert show];

    }
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
  //  NSString *imgPath =  [[SandBoxManager creatPathUnderCaches:@"/OfflineImg/"] stringByAppendingString:imgName];

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
    if (selectIndex.section == 0) {
        
        LCOfflineImgModel *model = self.dataArray1[selectIndex.row];
        model.image = nil;
        model.imgDescrip = nil;
        model.filePath = nil;
        model.placeHolder = YES;
        [alert dismissWithCompletion:^{
            [_collectionView reloadData];
        }];
        
    }else {
        
        [_dataArray removeObjectAtIndex:button.tag - 1000];
        [_imageArray removeObjectAtIndex:button.tag - 1000];
        [alert dismissWithCompletion:^{
            [_collectionView reloadData];
        }];

    }
}


- (void)saveBtnAction:(UIButton *)button {
    
    if (selectIndex.section == 0) {
        
        LCOfflineImgModel *imageModel = self.dataArray1[selectIndex.row];
        imageModel.imgDescrip = [desTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [alert dismissWithCompletion:^{
            [_collectionView reloadData];
        }];

    }else {
        
        LCOfflineImgModel *imageModel = _dataArray[button.tag - 10000];
        imageModel.imgDescrip = [desTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [alert dismissWithCompletion:^{
            [_collectionView reloadData];
        }];

    }
    
}

- (void)textExampleWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    // Move to bottm center.
//    hud.xOffset = 0.f;
//    hud.yOffset = ;
    
    [hud hide:YES afterDelay:3.f];
}

- (void)rightBarItemClick {
    
    // 取出分区0 有效数据
    NSMutableArray *validArray = [NSMutableArray array];
    [self.dataArray1 enumerateObjectsUsingBlock:^(LCOfflineImgModel   *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!model.isPlaceHolder) {
            LCOfflineImgModel *newModel = [[LCOfflineImgModel alloc] init];
            newModel.imgDescrip = model.imgDescrip;
            newModel.filePath = model.filePath;
            newModel.image = model.image;
            [validArray addObject:newModel];
        }
    }];
    [validArray addObjectsFromArray:_dataArray];

    
    NSString *str = [elementView.houseField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length == 0 || str == nil) {
        [self textExampleWithTitle:@"户主姓名不能为空"];
        return;
    } else if(validArray.count == 0){
        [self textExampleWithTitle:@"案件图片不能为空"];
        return;
    }else{
        
    }
    
//    [self performSelectorInBackground:@selector(saveToSandbox) withObject:nil];
    [self.view makeToastActivity];
    __weak typeof(self)weakSelf = self;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        OfflineModel *dataModel = [OfflineModel MR_createEntityInContext:localContext];
        dataModel.houseInfo = houseAddress;
        dataModel.userId = _userId;
        dataModel.isUpload = NO;
        dataModel.offlineArray = validArray;
        dataModel.reserveOne = titleStr;
        dataModel.autoUpdate = elementView.autoUpdate;
        dataModel.farmerName = elementView.farmerName;
        dataModel.farmerId = elementView.farmerId;

    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (!error) {
            [weakSelf.view hideToastActivity];
            LCDataOfflineVC *offlineVC = [[LCDataOfflineVC alloc] init];
            offlineVC.hidesBottomBarWhenPushed = YES;
            offlineVC.fromeOffline = YES;
            [weakSelf.navigationController pushViewController:offlineVC animated:YES];
            
            //刷新tabBarItem
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableBarValueNotification" object:nil];

        }else{
            [weakSelf.view makeToast:[error localizedDescription]];
        }
        
    }];
    
    
}


/**
 测试点击数据内容
 */
- (void)findData{
    NSArray *offlinemodelArray = [OfflineModel MR_findAll];
    NSLog(@"%ld", offlinemodelArray.count);
    [offlinemodelArray enumerateObjectsUsingBlock:^(OfflineModel  *offlineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = (NSArray *)offlineModel.offlineArray;
        LCOfflineImgModel *model = array.lastObject;
        NSLog(@"%@, %@, %d, %@", offlineModel.houseInfo, offlineModel.userId, offlineModel.isUpload, model.description);
    }];
}



- (void)saveToSandbox {
    // 保存分区0
    [self.dataArray1 enumerateObjectsUsingBlock:^(LCOfflineImgModel   *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!model.isPlaceHolder) {
            
            [SandBoxManager writeToDirectory:[SandBoxManager creatPathUnderCaches:@"/OfflineImg"]
                                   WithImage:model.image
                                   imageName:[model.filePath componentsSeparatedByString:@"."].firstObject
                                     imgType:@"jpg"];
        }
    }];
    
    // 保存分区1
    [_imageArray enumerateObjectsUsingBlock:^(UIImage  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LCOfflineImgModel *model = _dataArray[idx];
        
        NSString *imgPath = [SandBoxManager writeToDirectory:[SandBoxManager creatPathUnderCaches:@"/OfflineImg"]
                                                   WithImage:obj
                                                   imageName:[model.filePath componentsSeparatedByString:@"."].firstObject
                                                     imgType:@"jpg"];
        
        if (imgPath == nil) {
            return;
        }
        
    }];

}



@end
