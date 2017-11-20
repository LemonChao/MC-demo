//
//  UILable+Attributed.h
//  ZXNews
//
//  Created by HHL on 16/4/15.
//  Copyright © 2016年 LXH. All rights reserved.
//


#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
@interface UILabel (Attributed)
/**
 设置某段字的颜色
 */
- (void)setColor:(UIColor *)color
       fromIndex:(NSInteger)location
          length:(NSInteger)length;


- (void)setColor:(UIColor *)color start:(NSInteger)start end:(NSInteger)end;
/**
 设置某段字的字体
 */
- (void)setFont:(UIFont *)font
      fromIndex:(NSInteger)location
         length:(NSInteger)length;
/**
 设置某段字的风格
 */
- (void)setStyle:(CTUnderlineStyle)style
       fromIndex:(NSInteger)location
          length:(NSInteger)length;
@end
