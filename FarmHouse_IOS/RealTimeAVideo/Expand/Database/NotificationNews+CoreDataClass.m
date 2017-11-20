//
//  NotificationNews+CoreDataClass.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/18.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "NotificationNews+CoreDataClass.h"

@implementation NotificationNews

// 自定义的“主键”，为了插入的时候不造成数据“冗余”，因为每次插入数据是CoreData自己生成真正的主键的
//+ (NSArray *)primaryKeys {
//    return @[@"newsid"];
//}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"newsid":@"id"};
}


@end
