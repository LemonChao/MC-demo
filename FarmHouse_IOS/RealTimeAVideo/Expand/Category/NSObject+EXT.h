//
//  NSObject+EXT.h
//  ZXNews
//
//  Created by HHL on 16/4/15.
//  Copyright © 2016年 LXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EXT)
/**
 苹果版本
 */
-(NSString *)ai_version;
/**
 build版本
 */
-(NSInteger)ai_build;

-(NSString *)ai_identifier;

/**
 当前语言
 */
-(NSString *)ai_currentLanguage;

-(NSString *)ai_deviceModel;
#pragma mark 创建时间

/**
 当前时间字符串
 @param format @"yyyy-MM-dd-HH-mm-ss" @"yyyyMMddHHmmss"
 */
-(NSString*)dataWithFormat:(NSString*)format;



/**
 双定向数组拷贝
 */
void arrayCopy(const void *src, int srcPos, void *dst, int destPos, size_t length);


@end
