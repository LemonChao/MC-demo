//
//  LCHistoryCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseHold;


#define HisCellH AutoWHGetHeight(35)
#define HisCellW AutoWHGetWidth(70)

@interface LCHistoryCell : UICollectionViewCell

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath;


- (void)setValueWithModel:(HouseHold *)houseModle;

@end
