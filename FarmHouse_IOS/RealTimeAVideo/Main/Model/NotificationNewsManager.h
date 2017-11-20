//
//  NotificationNewsManager.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/18.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationNews+CoreDataProperties.h"

@interface NotificationNewsManager : NSObject

- (void)requestForNotificationNews;

- (void)readAllNotificationNews;
- (void)createForNotificationNewsTimer;

- (void)deleteNotificationNews:(NotificationNews *)notifNews;


- (void)deleteAll;

@end
