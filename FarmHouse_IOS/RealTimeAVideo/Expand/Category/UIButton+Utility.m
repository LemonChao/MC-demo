//
//  UIButton+Utility.m
//  OC-Project
//
//  Created by liuxhui on 15/7/3.
//  Copyright (c) 2015年 刘小辉. All rights reserved.
//

#import "UIButton+Utility.h"
#import <objc/runtime.h>
static const void *UIButtonBlockKey = &UIButtonBlockKey;

@interface UIButton ()

@property(nonatomic, strong) UIView *modalView;
@property(nonatomic, strong) UIActivityIndicatorView *spinnerView;
@property(nonatomic, strong) UILabel *spinnerTitleLabel;

@end


@implementation UIButton (Utility)
/**
 *  @author LXH, 15-07-29 16:07:03
 *
 *  改变颜色
 *
 *  @param color <#color description#>
 */
- (void)normalTitleColor:(UIColor*)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}
- (void)highltTitleColor:(UIColor*)color
{
    [self setTitleColor:color forState:UIControlStateHighlighted];
}
- (void)selectTitleColor:(UIColor*)color
{
    [self setTitleColor:color forState:UIControlStateSelected];
}
/**
 *  @author LXH, 15-07-29 16:07:14
 *
 *  标题
 *
 *  @param title <#title description#>
 */
- (void)normalTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)highltTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateHighlighted];
}
- (void)selectTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateSelected];
}
/**
 *  @author LXH, 15-07-29 16:07:27
 *
 *  设置图片
 *
 *  @param imgName <#imgName description#>
 */
- (void)normalImage:(NSString *)imgName
{
    [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];;
}
- (void)highltImage:(NSString *)imgName
{
    [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];;
}
- (void)selectImage:(NSString *)imgName
{
    [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateSelected];;
}

- (void)bgNormalImage:(NSString *)imgName
{
    [self setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (void)bgHighltImage:(NSString *)imgName
{
    [self setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
}

- (void)bgSelectImage:(NSString *)imgName
{
    [self setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateSelected];
}
//- (void)left  
//{
//    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0); //button文字偏移量 向右偏移10
//}
//- (void)right
//{
//    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10); //button文字偏移量 向左偏移10
//}

#pragma mark -- 按钮上图文混排
- (void)setImagePosition:(ZXImagePosition)postion spacing:(CGFloat)spacing {
    
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
    
    //image中心移动的x距离
    CGFloat imageOffsetX = labelWidth / 2 ;
    //image中心移动的y距离
    CGFloat imageOffsetY = labelHeight / 2 + spacing / 2;
    //label中心移动的x距离
    CGFloat labelOffsetX = imageWith/2;
    //label中心移动的y距离
    CGFloat labelOffsetY = imageHeight / 2 + spacing / 2;
    
    switch (postion) {
        case ZXImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case ZXImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case ZXImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case ZXImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
    
}

/**根据图文距边框的距离调整图文间距*/
- (void)setImagePosition:(ZXImagePosition)postion WithMargin:(CGFloat )margin{
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat labelWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
    CGFloat spacing = self.bounds.size.width - imageWith - labelWidth - 2*margin;
    
    [self setImagePosition:postion spacing:spacing];
}

#pragma mark -- 添加点击事件
//!< 添加点击事件
-(void)addActionHandler:(TouchedBlock)touchHandler{
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)actionTouched:(UIButton *)btn{
    TouchedBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(btn.tag);
    }
}

#pragma mark -- 提交按钮
- (void)beginSubmitting:(NSString *)title {
    [self endSubmitting];
    
    self.submitting = @YES;
    self.hidden = YES;
    
    self.modalView = [[UIView alloc] initWithFrame:self.frame];
    self.modalView.backgroundColor =
    [self.backgroundColor colorWithAlphaComponent:0.6];
    self.modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.modalView.layer.borderWidth = self.layer.borderWidth;
    self.modalView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.modalView.bounds;
    self.spinnerView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.spinnerView.bounds;
    self.spinnerView.frame = CGRectMake(
                                        15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                        spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.spinnerTitleLabel.text = title;
    self.spinnerTitleLabel.font = self.titleLabel.font;
    self.spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.modalView addSubview:self.spinnerView];
    [self.modalView addSubview:self.spinnerTitleLabel];
    [self.superview addSubview:self.modalView];
    [self.spinnerView startAnimating];
}

- (void)endSubmitting {
    if (!self.isSubmitting.boolValue) {
        return;
    }
    
    self.submitting = @NO;
    self.hidden = NO;
    
    [self.modalView removeFromSuperview];
    self.modalView = nil;
    self.spinnerView = nil;
    self.spinnerTitleLabel = nil;
}

- (NSNumber *)isSubmitting {
    return objc_getAssociatedObject(self, @selector(setSubmitting:));
}

- (void)setSubmitting:(NSNumber *)submitting {
    objc_setAssociatedObject(self, @selector(setSubmitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIActivityIndicatorView *)spinnerView {
    return objc_getAssociatedObject(self, @selector(setSpinnerView:));
}

- (void)setSpinnerView:(UIActivityIndicatorView *)spinnerView {
    objc_setAssociatedObject(self, @selector(setSpinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)modalView {
    return objc_getAssociatedObject(self, @selector(setModalView:));
    
}

- (void)setModalView:(UIView *)modalView {
    objc_setAssociatedObject(self, @selector(setModalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)spinnerTitleLabel {
    return objc_getAssociatedObject(self, @selector(setSpinnerTitleLabel:));
}

- (void)setSpinnerTitleLabel:(UILabel *)spinnerTitleLabel {
    objc_setAssociatedObject(self, @selector(setSpinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
