//
//  NSString+md5String.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/19.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (md5String)

/**
 normal encryption

 @param str string

 @return encrypted string
 */
+ ( NSString *)md5String:( NSString *)str;



/**
 NB encryption

 @param str string

 @return NB encryped string
 */
+ ( NSString *)md5StringNB:( NSString *)str;

@end
