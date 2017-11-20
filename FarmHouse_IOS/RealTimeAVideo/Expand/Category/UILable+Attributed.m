//
//  UILable+Attributed.m
//  ZXNews
//
//  Created by HHL on 16/4/15.
//  Copyright © 2016年 LXH. All rights reserved.
//

#import "UILable+Attributed.h"

@implementation UILabel (Attributed)
/**
 设置某段字的颜色
 */
- (void)setColor:(UIColor *)color
       fromIndex:(NSInteger)location
          length:(NSInteger)length {
    
    NSMutableAttributedString *_attString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];
    self.attributedText = _attString;
    
}

- (void)setColor:(UIColor *)color start:(NSInteger)start end:(NSInteger)end
{
    NSMutableAttributedString *muStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [muStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(start, end)];
    
    self.attributedText = muStr;
}
/**
 设置某段字的字体
 */
- (void)setFont:(UIFont *)font
      fromIndex:(NSInteger)location
         length:(NSInteger)length {
    NSMutableAttributedString *_attString = [[NSMutableAttributedString alloc] initWithString:self.text];
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                                        font.pointSize,
                                                                        NULL))
                       range:NSMakeRange(location, length)];
    

}
/**
 设置某段字的风格
 */
- (void)setStyle:(CTUnderlineStyle)style
       fromIndex:(NSInteger)location
          length:(NSInteger)length {
    NSMutableAttributedString *_attString = [[NSMutableAttributedString alloc] initWithString:self.text];
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)[NSNumber numberWithInt:style]
                       range:NSMakeRange(location, length)];
}
@end
