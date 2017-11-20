//
//  OfflineModel+CoreDataProperties.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/18.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "OfflineModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OfflineModel (CoreDataProperties)

+ (NSFetchRequest<OfflineModel *> *)fetchRequest;

/** 房屋信息 */
@property (nullable, nonatomic, copy) NSString *houseInfo;
/** 协保员id */
@property (nullable, nonatomic, copy) NSString *userId;
/** 是否上传 */
@property (nonatomic) BOOL isUpload;
/** 农户姓名 */
@property (nullable, nonatomic, copy) NSString *farmerName;
/** 农户id */
@property (nullable, nonatomic, copy) NSString *farmerId;
/** 图片数组 */
@property (nullable, nonatomic, retain) NSObject *offlineArray;
/** 预留，现用于离线定损报案号 */
@property (nullable, nonatomic, copy) NSString *reserveOne;
/** 是否自动上传 */
@property (nonatomic) BOOL autoUpdate;

@end

@interface OfflineArray : NSValueTransformer

@end

NS_ASSUME_NONNULL_END
