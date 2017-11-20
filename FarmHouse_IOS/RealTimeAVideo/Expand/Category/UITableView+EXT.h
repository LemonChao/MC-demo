//
//  UITableView+EXT.h
//  ZXNews
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EXT)
/**
 cell线长度是tableview长度
 */
- (void)cellInsetsZeroLine;

/**
 cell线长度定制
 */
- (void)cellEdgeInsets:(UIEdgeInsets)inset;
@end
