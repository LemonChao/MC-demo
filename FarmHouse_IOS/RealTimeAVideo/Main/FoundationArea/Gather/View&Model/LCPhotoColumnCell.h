//
//  LCPhotoColumnCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/11.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCNonghuModel.h"

@interface LCColumnAddCell : UICollectionViewCell

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;

@end




@interface LCPhotoColumnCell : UICollectionViewCell

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;

- (void)setModel:(LCHouseHoldImage *)model;

@end



//采集cell img+des
@interface LCGatherCell  : UICollectionViewCell

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;

- (void)setValueWith:(NSDictionary *)infoDic;

@end



//管理cell img+des+小红点
@interface LCManagerCell : UICollectionViewCell;

@property(nonatomic, copy) NSString *badgeValue;    // default is nil


+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;

- (void)setValueWith:(NSDictionary *)infoDic;

@end
