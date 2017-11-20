//
//  LCPictureCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/27.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchModel.h"

@interface LCPictureCell : UICollectionViewCell

+ (instancetype)createCellWith:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellid forIndexPath:(NSIndexPath *)indexPath;

- (void)setValueWithModel:(LCReportImgModel *)seaModel;

@end
