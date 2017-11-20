//
//  LCTools.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/15.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCTools : NSObject

/** check dictionary */
+ (BOOL)checkData:(id)obj;


/**
 手机中间4位加密
 */
+ (NSString *)encodeMobile:(NSString *)mobilePhone;

/**
 生成纯色图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**
 *
 *  提示一个警告，填写警告的字符
 *
 *  @param message
 */
+ (void)showAlert:(NSString *)message;

/**
 *  提示一个警告，参数timer为NSTimer
 *
 *  @param timer
 */
+ (void)removeAlert:(NSTimer *)timer;


/**
 *  提示网络错误
 */
+ (void)showNetFail;

//创建UILabel

/**
 *  工厂方法，创建一个Label
 *
 */
+ (UILabel*)createLable:(CGRect)frame
               withName:(NSString *)name
               withFont:(CGFloat)font;

+(UILabel*)createLable:(NSString *)name
              withFont:(UIFont*)font
             textColor:(UIColor*)textColor
         textAlignment:(NSTextAlignment)textAlignment;

/*
 * 创建圆角文字button nolmal
 */
+(UIButton*)createWordButton:(UIButtonType)type
                       title:(NSString*)title
                  titleColor:(UIColor*)titleColor
                        font:(UIFont*)font
                     bgColor:(UIColor*)bgColor
                cornerRadius:(CGFloat)cornerRadius
                 borderColor:(UIColor*)borderColor
                 borderWidth:(CGFloat)borderWidth;

/*
 * 创建直角文字button nolmal
 */
+(UIButton*)createWordButton:(UIButtonType)type
                       title:(NSString*)title
                  titleColor:(UIColor*)titleColor
                        font:(UIFont*)font
                     bgColor:(UIColor*)bgColor;

//创建UIButton
+(UIButton*)createButton:(CGRect)frame
               withName:(NSString*)name
              normalImg:(UIImage*)normalImg
           highlightImg:(UIImage*)highlightImg
              selectImg:(UIImage*)selectImg;
//创建UITextField
+ (UITextField *)createTextField:(CGRect)frame
                 withPlaceholder:(NSString *)placeholder;
/**
 *  工厂方法，创建一个textField,适用于masonry布局
 */
+ (UITextField *)createTextField:(UIFont*)font
                     borderStyle:(UITextBorderStyle)borderStyle
                 withPlaceholder:(NSString *)placeholder;

//创建UITableView
+ (UITableView *)createTableView:(CGRect)frame
                    withDelegate:(id)delegate;
//创建圆角UIImageView
+ (UIImageView *)createImageView:(UIImage *)image
                    cornerRadius:(CGFloat)cornerRadius;
+ (UIImageView *)createImageView:(NSURL*)url
                     placeHolder:(UIImage *)image
                    cornerRadius:(CGFloat)cornerRadius;
/**
 *  创建0.5像素横线
 */
+ (UIImageView *)createImgLine:(CGRect)frame;


/**
 创建横线
 */
+ (UIView *)createLineView:(UIColor *)color;

//创建UIScrollView

/**
 *  创建ScrollView
 *
 *  @param frame
 *  @param delegate
 *  @param contentSize
 *
 */
+ (UIScrollView *)createScrollView:(CGRect)frame
                      withDelegate:(id)delegate
                   withContentSize:(CGSize)contentSize;

/**
 *  根据指定Label的宽度以及字符串长度，返回适应的Label的高度
 *
 *  @param string
 *  @param font
 *  @param width
 *
 *  @return
 */
+ (CGFloat)heightWithString:(NSString *)string
                       font:(UIFont *)font
         constrainedToWidth:(CGFloat)width;

+ (CGFloat)widthWithString:(NSString *)string
                      font:(UIFont *)font;


+ (UIView *)headerView;

#pragma mark -- image的翻转
+ (UIImage *)rotateImage:(UIImage *)aImage;

/**压缩图片*/
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//判断手机号码
/**
 *  判断字符串是否未手机号码，返回YES是手机号码
 *
 *  @param mobileNum
 *
 *  @return YES 是手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)isMobile:(NSString *)mobileNum;


+ (BOOL)isEmail:(NSString *)email;

/**
 *  检查输入输入身份证号是否正确
 */

+ (BOOL)isIdCardValidation:(NSString *)identityCard;
/**
 *  检查输入是否为空格或没内容
 */
+ (BOOL)isInputCorrect:(NSString *)input;

/**
 *  检查ios审核屏蔽开启
 */
+ (BOOL)checkIOSSettingReview;

/**
 *  改变状态栏颜色
 */
+ (void)statusWithStyle:(UIStatusBarStyle)style;


+ (void)getLayoutHeight:(UIView *)view;



/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;


/**
 * 创建一个可以随时开始，随时停止的timer, 暂时未用
 */
- (instancetype)initTimerInterval:(NSTimeInterval)ts WithTarget:(id)target selector:(nonnull SEL)sel repeats:(BOOL)repeats;
- (void)freeNSTimer;
- (void)pauseTimer;
- (void)startTimer;


@end
