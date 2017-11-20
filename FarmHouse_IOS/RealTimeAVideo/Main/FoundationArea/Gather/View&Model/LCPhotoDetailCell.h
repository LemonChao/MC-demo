//
//  LCPhotoDetailCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/12.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextViewPlaceholder.h"
#import "LCNonghuModel.h"

@class LCPhotoDetailCell;
@protocol PhotoDetailCellDelegate <NSObject>


/**
 button 点击代理

 @param cell  LCPhotoDetailCell
 @param index 0,deleteBtn  1,saveBtn
 */
- (void)photoDetailCell:(LCPhotoDetailCell *)cell clickButtonIndex:(NSInteger)index;

@end

@interface LCPhotoDetailCell : UICollectionViewCell

@property(nonatomic, strong) UITextViewPlaceholder *textView;

@property(nonatomic, weak) id<PhotoDetailCellDelegate> delegate;

@property(nonatomic, strong) NSString *imgDes;

@property(nonatomic, strong) LCHouseHoldImage *imgModle;

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;

@end
