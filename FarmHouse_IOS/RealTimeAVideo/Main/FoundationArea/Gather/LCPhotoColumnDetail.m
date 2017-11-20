//
//  LCPhotoColumnDetail.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/12.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPhotoColumnDetail.h"
#import "LCPhotoDetailCell.h"
#import "IQKeyBoardManager.h"


@interface LCPhotoColumnDetail ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PhotoDetailCellDelegate>
{
    BOOL isDeleted;
}
@property(nonatomic, strong) UICollectionView *collectionView;


@end

static NSString *Cellid = @"detailCellid";
@implementation LCPhotoColumnDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    /** 全局的键盘管理 */
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor =NO; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar =NO; // 控制是否显示键盘上的工具条
    //    manager.toolbarManageBehaviour =IQAutoToolbarByTag;
}


- (void)viewWillDisappear:(BOOL)animated {
    /** 全局的键盘管理 */
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    //    manager.toolbarManageBehaviour =IQAutoToolbarByTag;
}

//- (NSMutableArray *)dataArray {
//    if (_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}

- (BOOL)navigationShouldPopOnBackButton{
    if (isDeleted && _deleteBlock) {
        _deleteBlock();
    }
    return YES;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    NSUInteger photoCount = self.dataArray.count;
    if (photoCount == 0) {
        currentIndex = 0;
    }else if (currentIndex >= photoCount) {
        currentIndex = photoCount - 1;
    }
    
    [self.collectionView setContentOffset:CGPointMake(SCREEN_WIDTH*currentIndex, 0) animated:NO];

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        //UICollectionViewLayout, 继承于NSObject, 控制集合视图的样式, 是一个抽象基类
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //cell 默认值(50,50)
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HIGHT-64);
        //滚动方向
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //最小行间距
        flowLayout.minimumLineSpacing = 0;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 0;
        //分区间距
        flowLayout.sectionInset = UIEdgeInsetsZero;
        //区头大小
        //        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, AutoWHGetHeight(120));
        //区尾大小
        //        flowLayout.footerReferenceSize =CGSizeMake(SCREEN_WIDTH, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) collectionViewLayout:flowLayout];
        
        //集合视图的创建
        _collectionView.backgroundColor = TabBGColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        
        //注册cell(好像必须要注册)
        [_collectionView registerClass:[LCPhotoDetailCell class] forCellWithReuseIdentifier:Cellid];
//        [_collectionView registerClass:[LCColumnAddCell class] forCellWithReuseIdentifier:addCellid];
        
        //        //注册区头
        //        [_collectionView registerClass:[LCHeadGather class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHe];
        //        //注册区尾
        //        [collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
        
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LCHouseHoldImage *imgModel = self.dataArray[indexPath.row];
    
    LCPhotoDetailCell *cell = [LCPhotoDetailCell createCellWithCollection:collectionView reuseIdentifier:Cellid atIndexPath:indexPath];
    cell.imgModle = imgModel;
    cell.delegate = self;
    return cell;
    
}

- (void)photoDetailCell:(LCPhotoDetailCell *)cell clickButtonIndex:(NSInteger)index {
    
    if (index == 0) { //delete
        [LCAlertTools showTipAlertViewWith:self title:@"提 示" message:@"确定删除此图片" cancelTitle:@"确定" cancelHandler:^{
            [self deletePhotoCell:cell];
        }];
        
    }
    else if (index == 1) { // save
        [self updatePhotoDescriptionCell:cell];
    }
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.title = [NSString stringWithFormat:@"%ld/%ld", indexPath.row+1, self.dataArray.count];
}

// 1.5删除图片

- (void)deletePhotoCell:(LCPhotoDetailCell *)cell {
    NSDictionary *senDic = @{@"flag":@"deletefarmerimage",
                             @"id":cell.imgModle.imageid};
    
    [LCAFNetWork POST:@"farmerBasicInfo" params:senDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.view makeToast:@"删除成功" duration:1.0 position:CSToastPositionBottom];
        
        //这里传的指针实际上 上个界面数组也被修改了，
        [self.dataArray removeObject:cell.imgModle];
        [self.collectionView reloadData];
        isDeleted = YES;
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:@"删除失败" duration:1.0 position:CSToastPositionBottom];
    }];
}


// 1.6修改图片备注：
- (void)updatePhotoDescriptionCell:(LCPhotoDetailCell *)cell {
    NSDictionary *senDic = @{@"flag":@"updatefarmerimage",
                             @"id":cell.imgModle.imageid,
                             @"imagecontent":cell.textView.text};
    
    [LCAFNetWork POST:@"farmerBasicInfo" params:senDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.view makeToast:@"保存成功" duration:1.0 position:CSToastPositionBottom];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeToast:@"保存失败" duration:1.0 position:CSToastPositionBottom];
    }];

}

/**
 
 *  键盘将要显示
 *  @param notification 通知
 
 */

-(void)keyboardWillShow:(NSNotification *)notification

{
    
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize size = frame.size;
    
    
//    CGFloat endHeight = self.showScrollView.contentSize.height + frame.size.height;
//    CGFloat endHeight = self.collectionView.contentSize.height + frame.size.height;
    
    
    
//    self.collectionView.contentSize = CGSizeMake(SCREEN_WIDTH, endHeight);
    
//    self.collectionView.contentOffset = CGPointMake(0, -size.height);
    
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = _collectionView.frame;
        rect.origin.y = -size.height;
        _collectionView.frame = rect;
       // self.collectionView.contentOffset = CGPointMake(0, -size.height);
    }];
  //  [self.collectionView setContentOffset:CGPointMake(0, -size.height) animated:YES];
    

    
}

/**
 
 *  键盘将要隐藏
 *  @param notification 通知
 
 */

-(void)keyboardWillHidden:(NSNotification *)notification

{
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = _collectionView.frame;
        rect.origin.y = 0;
        _collectionView.frame = rect;
    }];

//    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    
//    
//    CGFloat endHeight = self.showScrollView.contentSize.height - frame.size.height;
//    
//    self.showScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, endHeight);
    
}

@end
