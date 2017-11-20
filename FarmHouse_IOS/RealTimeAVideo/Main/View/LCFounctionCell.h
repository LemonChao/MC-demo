//
//  LCFounctionCell.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/19.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonTypeBlock)(NSInteger tag);

@interface LCFounctionCell : UITableViewCell

@property (nonatomic, copy) buttonTypeBlock buttonTypeBlock;

@end
