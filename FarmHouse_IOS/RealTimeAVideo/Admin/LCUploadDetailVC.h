//
//  LCUploadDetailVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCBaseVC.h"
@class OfflineModel;

typedef void(^UpRefreshBlock)(OfflineModel *model);

@interface LCUploadDetailVC : LCBaseVC

@property(nonatomic, strong) OfflineModel *model;

@property(nonatomic, copy) UpRefreshBlock upBlock;

@end
