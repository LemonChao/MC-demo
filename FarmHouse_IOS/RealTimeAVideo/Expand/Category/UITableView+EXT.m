//
//  UITableView+EXT.m
//  ZXNews
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "UITableView+EXT.h"

@implementation UITableView (EXT)


- (void)cellInsetsZeroLine {
    [self viewDidLayoutSubviewsWithRect:UIEdgeInsetsZero];
}


- (void)cellEdgeInsets:(UIEdgeInsets)inset{
    [self viewDidLayoutSubviewsWithRect:inset];
}

-(void)viewDidLayoutSubviewsWithRect:(UIEdgeInsets)inset {
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:inset];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)])  {
        [self setLayoutMargins:inset];
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


//-(void)viewDidLayoutSubviews {
//    
//    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self setSeparatorInset:UIEdgeInsetsZero];
//        
//    }
//    if ([self respondsToSelector:@selector(setLayoutMargins:)])  {
//        [self setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}



@end
