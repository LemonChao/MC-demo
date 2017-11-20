//
//  LCColumnCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCycleImgModel.h"


typedef void(^buttonTypeBlock)(NSInteger tag);


@interface LCColumnCell : UITableViewCell

@property (nonatomic, copy) buttonTypeBlock buttonTypeBlock;



- (void)setValueWithModle:(ColumnModel *)model;

- (void)setValueWithArray:(NSMutableArray *)array;


@end
