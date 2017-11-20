//
//  GatherPhoto+CoreDataProperties.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "GatherPhoto+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GatherPhoto (CoreDataProperties)

+ (NSFetchRequest<GatherPhoto *> *)fetchRequest;

/** 协保员id */
@property (nullable, nonatomic, copy) NSString *userid;

/** 装载图片模型数组 */
@property (nullable, nonatomic, retain) NSObject *photoArray;

/** 是否上传 */
@property (nonatomic) BOOL isUpload;

/** 户主姓名 */
@property (nullable, nonatomic, copy) NSString *houseName;

/** 房屋信息 */
@property (nullable, nonatomic, copy) NSString *houseInfo;

/** 农户id */
@property (nullable, nonatomic, copy) NSString *nhid;

/** 报案号（zip名,） */
@property (nullable, nonatomic, copy) NSString *reportNum;

/** 预留1 */
@property (nullable, nonatomic, copy) NSString *reserveOne;

/** 预留2 */
@property (nonatomic) int64_t reserveTwo;

/** imageContent */
@property (nullable, nonatomic, copy) NSString *imageContent;

@end

@interface PhotoArray : NSValueTransformer

@end


NS_ASSUME_NONNULL_END
