//
//  PhotoContainView.m
//  EWLMedicalSafety
//
//  Created by sunpeng on 2017/3/17.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import "PhotoContainView.h"
#import "PhotoCollectionViewCell.h"
#import "SDPhotoBrowser.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>


@interface PhotoContainView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

#define Margin  5

@implementation PhotoContainView



- (void)setPhotoArray:(NSArray *)photoArray{
    if (_photoArray != photoArray) {
        _photoArray = photoArray;
    }
    
    [_collectionView reloadData];

}


- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_collectionView) {
        return;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //cell大小, 默认(50, 50)
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 100)/3., (SCREEN_WIDTH - 100)/3.);
    //最小行间距
    flowLayout.minimumLineSpacing = 5;
    //最小列间距
    flowLayout.minimumInteritemSpacing = 5;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
}


#pragma mark - UICollectionViewDataSource
//分区的Item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //从复用池找cell
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:StrFormat(@"%@%@", BASEURL, _photoArray[indexPath.row])] placeholderImage:[UIImage imageNamed:@"default_image"]];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;{
    NSString *str = _photoArray[indexPath.row];
    NSLog(@"点击的图片:%@, 位置:%ld", str, (long)indexPath.row);
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    //导航右侧分享btn 默认YES
    browser.displayActionButton = NO;
    //底部是否分页切换导航，默认否
    browser.displayNavArrows = NO;
    //是否显示选择按钮在图片上,默认否
    browser.displaySelectionButtons = NO;
    //控制条控件是否显示(顶部1/3),默认否
    browser.alwaysShowControls = NO;
    //自动适用大小,默认是YES
    browser.zoomPhotosToFill = YES;
    //是否允许用网格查看所有图片,默认是 NO
    browser.enableGrid = YES;
    //是否第一张,默认否
    browser.startOnGrid = NO;
    //是否开始对缩略图网格代替第一张照片
    browser.enableSwipeToDismiss = NO;
    //是否自动播放视频
    browser.autoPlayOnAppear = NO;
    //播放页码
    [browser setCurrentPhotoIndex:indexPath.row];
    
    //show
    [self.vc.navigationController pushViewController:browser animated:YES];
    
    
    
}

//有多少个图片要显示
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photoArray.count;
    
}
//在具体的index中，显示网络加载或者本地的某一个图片
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photoArray.count)
        return [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASEURL, self.photoArray[index]]]];
    return nil;
    
}
@end
