//
//  NSString+Extension.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)


/**
 离线定损图片，txt名字, 由YYYYMMddHHmmss格式时间调用
 循环耗时
 
 @param deviceNum 设备号
*/
- (NSString *)uploadPicName:(NSString *)deviceNum;



/**
 去掉全部空格检查非空
 */
- (BOOL)realStr;

/**
 去掉左右两端空格检查非空
 */
- (BOOL)trueStr;
@end
