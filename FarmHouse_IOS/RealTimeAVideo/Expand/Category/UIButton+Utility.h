//
//  UIButton+Utility.h
//  OC-Project
//
//  Created by liuxhui on 15/7/3.
//  Copyright (c) 2015年 刘小辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZXImagePosition) {
    ZXImagePositionLeft     = 0,            //图片在左，文字在右，默认
    ZXImagePositionRight    = 1,            //图片在右，文字在左
    ZXImagePositionTop      = 2,            //图片在上，文字在下
    ZXImagePositionBottom   = 3,            //图片在下，文字在上
};
typedef void (^TouchedBlock)(NSInteger tag);

@interface UIButton (Utility)

-(void)addActionHandler:(TouchedBlock)touchHandler;
/**
 *  扩展UIButton的方法
 *
 *  @param title
 */
- (void)normalTitleColor:(UIColor*)color;

- (void)highltTitleColor:(UIColor*)color;

- (void)selectTitleColor:(UIColor*)color;

- (void)normalTitle:(NSString *)title;  //正常状态
- (void)highltTitle:(NSString *)title;  //高亮
- (void)selectTitle:(NSString *)title;  //选中


- (void)normalImage:(NSString *)imgName;// 正常
- (void)highltImage:(NSString *)imgName;//高亮
- (void)selectImage:(NSString *)imgName;//选中


- (void)bgNormalImage:(NSString *)imgName;// 正常
- (void)bgHighltImage:(NSString *)imgName;//高亮
- (void)bgSelectImage:(NSString *)imgName;//选中

//- (void)left;   //button文字靠左
//- (void)right;  //button文字靠右

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)setImagePosition:(ZXImagePosition)postion spacing:(CGFloat)spacing;

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param margin 图片、文字离button边框的距离
 */
- (void)setImagePosition:(ZXImagePosition)postion WithMargin:(CGFloat )margin;
/**
 *  @brief  按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title
 *
 *  @param title 按钮上显示的文字
 */
- (void)beginSubmitting:(NSString *)title;

/**
 *  @brief  按钮点击后，恢复按钮点击前的状态
 */
- (void)endSubmitting;

/**
 *  @brief  按钮是否正在提交中
 */
@property(nonatomic, readonly, getter=isSubmitting) NSNumber *submitting;
@end
