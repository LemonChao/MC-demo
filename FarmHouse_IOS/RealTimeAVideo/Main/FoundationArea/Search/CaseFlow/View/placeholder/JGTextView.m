//
//  JGTextView.m
//  EFFICIENCYLOG
//
//  Created by stkcctv on 16/12/14.
//  Copyright © 2016年 JG. All rights reserved.
//

#import "JGTextView.h"

@implementation JGTextView

// 时刻监听文字键盘文字的变化，文字一旦改变便调用setNeedsDisplay方法
- (void)textDidChange
{
    // 该方法会调用drawRect:方法，立即重新绘制占位文字
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.hasText) return;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    // 在textView的矩形框中绘制文字
    [self.placeholder drawInRect:CGRectMake(5, 8, self.frame.size.width, self.frame.size.height) withAttributes:attrs];
    
}


// 占位文字的setter方法
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    // 文字一旦改变，立马重写绘制（内部会调drawRect:方法）
    [self setNeedsDisplay];
    
}
// 字体属性setter方法
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)awakeFromNib{
    [super awakeFromNib];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
