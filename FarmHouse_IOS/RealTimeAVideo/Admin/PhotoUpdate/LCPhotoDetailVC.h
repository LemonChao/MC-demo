//
//  LCPhotoDetailVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GatherPhoto+CoreDataClass.h"


typedef void(^SaveRefreshBlock)(GatherPhoto *model);

typedef void(^UploadDoneBlock)(GatherPhoto *model);


@interface LCPhotoDetailVC : UIViewController

@property(nonatomic, strong) GatherPhoto *gatherPhoto;


@property(nonatomic, copy) SaveRefreshBlock saveBlock;

//上传完成
@property(nonatomic, copy) UploadDoneBlock uploadBlock;

@end
