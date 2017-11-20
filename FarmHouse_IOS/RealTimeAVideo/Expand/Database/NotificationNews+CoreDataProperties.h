//
//  NotificationNews+CoreDataProperties.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/18.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "NotificationNews+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NotificationNews (CoreDataProperties)

+ (NSFetchRequest<NotificationNews *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *newsid;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *sender;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *type;
@property (nonatomic) BOOL isRead;
@property (nullable, nonatomic, copy) NSString *reserveOne;

@end

NS_ASSUME_NONNULL_END
