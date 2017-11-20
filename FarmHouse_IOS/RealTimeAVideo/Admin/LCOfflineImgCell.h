//
//  LCOfflineImgCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/21.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCOfflineImgModel;

@interface LCOfflineAddCell : UICollectionViewCell

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;



@end


@interface LCOfflineImgCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imgView;
/** 是否有背景，用于分区1 */
@property(nonatomic, assign) BOOL placeHolder;

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;


- (void)setValueWithModel:(LCOfflineImgModel *)model isEnd:(BOOL)isEnd;

//- (void)setValueWithModel:(LCOfflineImgModel *)model indexPath:(NSIndexPath *)indexPath;

/** 拍照引导 带背景图cell */
- (void)setValueWithModel:(LCOfflineImgModel *)model isPlaceHolder:(BOOL)placeHolder;

@end



