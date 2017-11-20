//
//  NotificationNews+CoreDataProperties.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/18.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "NotificationNews+CoreDataProperties.h"

@implementation NotificationNews (CoreDataProperties)

+ (NSFetchRequest<NotificationNews *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NotificationNews"];
}

@dynamic newsid;
@dynamic title;
@dynamic sender;
@dynamic content;
@dynamic time;
@dynamic type;
@dynamic isRead;
@dynamic reserveOne;

@end
