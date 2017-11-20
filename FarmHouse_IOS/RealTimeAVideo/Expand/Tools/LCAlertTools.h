//
//  LCAlertTools.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/23.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//
// 普通版 http://www.jianshu.com/p/056809125cbe <当前在用>
// 升级版 http://www.jianshu.com/p/ae336594daf0


/*
***注意1***
destructiveButtonTitle
iOS8以前，设置有效，actionSheet，但是此时btnIndex不一样，取消的为1，destructive的为0
iOS8以后，设置无效，alertController，此时取消的btnIndex为0，该效果请设置样式数组值

***注意2***
message
iOS8以前，actionSheet设置无效，因为不支持
iOS8以后，actionSheet设置有效

***注意3***
UIAlertActionStyleCancel最多只能有一个，否则崩溃
Log:
'UIAlertController can only have one action with a style of UIAlertActionStyleCancel'
*/

#import <Foundation/Foundation.h>

@interface LCAlertTools : NSObject

/**
 *  CancelActionHander
 */
typedef void (^CancelHandler)();

/**
 *  DefaultActionHander
 */
typedef void (^DefaultHandler)();

/**
 *  CallBackBlock ActionSheet的下标
 */
typedef void (^CallBackBlock)(NSInteger actionIndex);

/**
 *  最多一个按钮,按钮无响应
 *
 *  @param viewController       当前视图，alertController模态弹出的指针
 *  @param title                标题
 *  @param message              信息
 *  @param btnTitle             按钮标题
 *  @param btnStyle             按钮样式
 */
+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 buttonTitle:(NSString *)btnTitle
                 buttonStyle:(UIAlertActionStyle)btnStyle;

/**
 *  一个按钮,按钮有响应
 *
 *  @param viewController       当前视图，alertController模态弹出的指针
 *  @param title                标题
 *  @param message              信息
 *  @param btnTitle             按钮标题
 *  @param btnStyle             按钮样式
 *  @param cancelHandler        按钮点击响应
 */
+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 buttonTitle:(NSString *)btnTitle
                 buttonStyle:(UIAlertActionStyle)btnStyle
               cancelHandler:(CancelHandler)cancelHandler;


/**
 *  两个按钮右：取消，点击消失
 *
 *  @param viewController       当前视图，alertController模态弹出的指针
 *  @param title                标题
 *  @param message              信息
 *  @param cancelTitle          左按钮标题
 *  @param cancelHandler        左按钮点击响应
 */
+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 cancelTitle:(NSString *)cancelTitle
               cancelHandler:(CancelHandler)cancelHandler;

/**
 *  两个按钮，标题，响应自定义
 *
 *  @param viewController       当前视图，alertController模态弹出的指针
 *  @param title                标题
 *  @param message              信息
 *  @param cancelTitle          左按钮标题
 *  @param dafaultTitle         右按钮标题
 *  @param cancelHandler        左按钮点击响应
 *  @param defaultHandler       右按钮点击响应
 */
+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 cancelTitle:(NSString *)cancelTitle
                defaultTitle:(NSString *)dafaultTitle
               cancelHandler:(CancelHandler)cancelHandler
              defaultHandler:(DefaultHandler)defaultHandler;

/**
 *  actionSheet数组初始化
 *
 *  @param viewController       当前视图，alertController模态弹出的指针
 *  @param title                标题
 *  @param message              详细信息
 *  @param cancelBtnTitle       取消按钮
 *  @param actionTitleArray     按钮title数组
 *  @param actionStyleArray     按钮style数组（普通/特殊)
 *  @param cancelHandler        cancel点击响应，nil：自动消失
 *  @param block                actionSheet点击响应
 */

+ (void)showActionSheetWith:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelBtnTitle
                actionTitleArray:(NSArray *)actionTitleArray
                actionStyleArray:(NSArray *)actionStyleArray
                   cancelHandler:(CancelHandler)cancelHandler
                   callbackBlock:(CallBackBlock)block;


/**
 *  普通alert定义 兼容适配alertView和alertController
 *
 *  @param viewController    当前视图，alertController模态弹出的指针
 *  @param title             标题
 *  @param message           详细信息
 *  @param block             用于执行方法的回调block
 *  @param cancelBtnTitle    取消按钮
 *  @param destructiveBtn    alertController的特殊按钮类型
 *  @param otherButtonTitles 其他按钮 变参量 但是按钮类型的相对位置是固定的
 
 *  NS_REQUIRES_NIL_TERMINATION 是一个宏，用于编译时非nil结尾的检查 自动添加结尾的nil
 
 ***注意1***
 //block方法序列号和按钮名称相同，按钮类型排列顺序固定
 //如果取消为nil，则index0为特殊，以此往后类推，以第一个有效按钮为0开始累加
 //取消有的话默认为0
 
 ***注意2***
 destructiveButtonTitle
 iOS8以前，alert设置无效，因为不支持
 iOS8以后，alert设置有效
 */
+ (void)showAlertWith:(UIViewController *)viewController
                title:(NSString *)title
              message:(NSString *)message
        callbackBlock:(CallBackBlock)block
    cancelButtonTitle:(NSString *)cancelBtnTitle
destructiveButtonTitle:(NSString *)destructiveBtn
    otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

+ (void)checkLoginIfNecessary:(UIViewController *)viewController;
@end
