//
//  UserModel.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/1.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


+ (instancetype)userDefaults {
    
    static UserModel *user = nil;
    static dispatch_once_t predicate;
    
    _dispatch_once(&predicate, ^{
        user = [super allocWithZone:NULL];
    });
    
    return user;
}

/** 防止通过 alloc 方法得到不同对象 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self userDefaults];
}
/** 防止拷贝时，得到不同对象 */
- (instancetype)copyWithZone:(nullable NSZone *)zone {
    return [UserModel userDefaults];
}



@end
