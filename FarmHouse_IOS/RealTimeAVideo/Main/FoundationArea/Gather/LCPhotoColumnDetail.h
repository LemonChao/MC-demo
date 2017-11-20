//
//  LCPhotoColumnDetail.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/12.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cellDeleteBlock)();

@interface LCPhotoColumnDetail : UIViewController

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, assign) NSInteger currentIndex;

@property(nonatomic, copy) cellDeleteBlock deleteBlock;


@end
