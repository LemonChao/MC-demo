//
//  LCGatherPhotoCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/11.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPhotoModel.h"

@interface LCGatherPhotoCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imgView;
/** 是否有背景，用于分区1 */
@property(nonatomic, assign) BOOL placeHolder;

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;


- (void)setValueWithModel:(LCPhotoModel *)model isEnd:(BOOL)isEnd;



@end
