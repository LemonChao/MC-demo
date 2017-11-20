//
//  UUID.h
//  KeyUUID
//
//  Created by Lemon on 16/9/5.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUID : NSObject
/**
 *  获取设备的 UUID 430F7ABD-DB61-4247-B716-FCE34C0F56C6
 *
 *  @return 设备32位唯一标示 :6098 5DA2 59A5 4AB3 89BD ACD9 C044 DB98  (啊营的5C)
 */
+(NSString *)getUUID;


/**
 *  生成6位设备号
 *
 *  @return 6位纯数字设备号
 */
+(NSString *)getDeviceNum;

@end
