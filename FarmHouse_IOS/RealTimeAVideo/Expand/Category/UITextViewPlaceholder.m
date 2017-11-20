//
//  UITextViewPlaceholder.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/21.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "UITextViewPlaceholder.h"

@interface UITextViewPlaceholder ()

@property (nonatomic, retain) UIColor* realTextColor;
@property (nonatomic, readonly) NSString* realText;

- (void) endEditing:(NSNotification*) notification;

@end

@implementation UITextViewPlaceholder


#pragma mark -
#pragma mark Initialisation

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
    {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    self.realTextColor = [UIColor colorwithHexString:@"#cccccc"];
    
    self.placeholder = @"placeholder";
}

#pragma mark -
#pragma mark Setter/Getters

- (void) setPlaceholder:(NSString *)aPlaceholder
{
    if ([self.realText isEqualToString:_placeholder])
    {
        self.text = aPlaceholder;
    }
    
    _placeholder = aPlaceholder;
    
    [self endEditing:nil];
}

- (NSString *) text
{
    NSString* text = [super text];
    if ([text isEqualToString:self.placeholder]) return @"";
    return text;
}

- (void) setText:(NSString *)text
{
    if ([text isEqualToString:@""] || text == nil)
    {
        super.text = self.placeholder;
    }
    else
    {
        super.text = text;
    }
    
    if ([text isEqualToString:self.placeholder])
    {
        self.textColor = [UIColor colorwithHexString:@"#cccccc"];
    }
    else
    {
        self.textColor = self.realTextColor;
    }
}

- (NSString *) realText
{
    return [super text];
}

- (void) beginEditing:(NSNotification*) notification
{
    if ([self.realText isEqualToString:self.placeholder])
    {
        super.text = nil;
        self.textColor = self.realTextColor;
    }
}

- (void) endEditing:(NSNotification*) notification
{
    if ([self.realText isEqualToString:@""] || self.realText == nil)
    {
        super.text = self.placeholder;
        self.textColor = [UIColor colorwithHexString:@"#cccccc"];
    }
}

- (void) setTextColor:(UIColor *)textColor
{
    if ([self.realText isEqualToString:self.placeholder])
    {
        if ([textColor isEqual:[UIColor colorwithHexString:@"#cccccc"]]) [super setTextColor:textColor];
        else self.realTextColor = textColor;
    }
    else
    {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
