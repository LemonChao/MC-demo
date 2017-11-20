//
//  UIColor+ColorUtil.h
//  AShop
//
//  Created by hong liu on 12-7-19.
//  Copyright (c) 2012年 easee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorUtil)
#define SUPPORTS_UNDOCUMENTED_API	YES
#define DEFAULT_VOID_COLOR	[UIColor blackColor] //默认颜色为黑色
+(UIColor *) colorwithHexString:(NSString*) stringToConvert;//通过16进制码获取颜色
+(UIColor *) colorwithHex:(NSString*) stringToConvert;
@end
