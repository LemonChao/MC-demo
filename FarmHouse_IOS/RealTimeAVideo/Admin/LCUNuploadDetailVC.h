//
//  LCUNuploadDetailVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/21.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OfflineModel;

typedef void(^SaveRefreshBlock)(OfflineModel *model);

typedef void(^UploadDoneBlock)(OfflineModel *model);

@interface LCUNuploadDetailVC : LCBaseVC

@property(nonatomic, strong) OfflineModel *model;

@property(nonatomic, assign) NSInteger index;

@property(nonatomic, copy) SaveRefreshBlock saveBlock;

//上传完成
@property(nonatomic, copy) UploadDoneBlock uploadBlock;

@end
