//
//  LCAlertTools.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/23.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCAlertTools.h"
#import "LCLonginVC.h"

/**
 *  弹框显示的时间，默认1秒
 */
#define AlertViewShowTime 1.0


@implementation LCAlertTools

#pragma mark - alert 简易提示窗 一个按钮或者无按钮
+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 buttonTitle:(NSString *)btnTitle
                 buttonStyle:(UIAlertActionStyle)btnStyle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //添加按钮
    if (btnTitle) {
        
        UIAlertAction *singleAction = nil;
        switch (btnStyle) {
            case UIAlertActionStyleDefault:
                singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                [alertController addAction:singleAction];
                break;
            case UIAlertActionStyleCancel:
                singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                [alertController addAction:singleAction];
                break;
            case UIAlertActionStyleDestructive:
                singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    
                }];
                [alertController addAction:singleAction];
                break;
                
            default://默认的
                singleAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                [alertController addAction:singleAction];
                break;
        }
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
    //如果没有按钮，自动延迟消失
    if (btnTitle == nil) {
        //此时self指本类
        [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
    }

}

+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 buttonTitle:(NSString *)btnTitle
                 buttonStyle:(UIAlertActionStyle)btnStyle
               cancelHandler:(CancelHandler)cancelHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:btnTitle style:btnStyle handler:^(UIAlertAction * _Nonnull action) {
        cancelHandler();
    }];
    
    [alertController addAction:cancelAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];

}


+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 cancelTitle:(NSString *)cancelTitle
               cancelHandler:(CancelHandler)cancelHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelHandler();
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:defaultAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}


+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 cancelTitle:(NSString *)cancelTitle
                 defaultTitle:(NSString *)dafaultTitle
               cancelHandler:(CancelHandler)cancelHandler
              defaultHandler:(DefaultHandler)defaultHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelHandler();
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:dafaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        defaultHandler();
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:defaultAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];

    
}

+ (void)showActionSheetWith:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelBtnTitle
                actionTitleArray:(NSArray *)actionTitleArray
                actionStyleArray:(NSArray *)actionStyleArray
                   cancelHandler:(CancelHandler)cancelHandler
                   callbackBlock:(CallBackBlock)block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加按钮
    if (cancelBtnTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (cancelHandler) cancelHandler();
        }];
        [alertController addAction:cancelAction];
    }
    if (actionTitleArray && actionTitleArray.count)
    {
        
        for (int i = 0; i < actionTitleArray.count; i ++) {
            
            NSNumber * styleNum = actionStyleArray[i];
            UIAlertActionStyle actionStyle =  styleNum.integerValue;
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:actionTitleArray[i] style:actionStyle handler:^(UIAlertAction *action) {
                block(i);
            }];
            [alertController addAction:otherAction];
            
        }
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
    //如果没有按钮，自动延迟消失
    if (cancelBtnTitle == nil && (actionStyleArray == nil || actionStyleArray.count == 0)) {
        //此时self指本类
        [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
    }

}


#pragma mark - 普通alert初始化 兼容适配
+ (void)showAlertWith:(UIViewController *)viewController
                title:(NSString *)title
              message:(NSString *)message
        callbackBlock:(CallBackBlock)block
    cancelButtonTitle:(NSString *)cancelBtnTitle
destructiveButtonTitle:(NSString *)destructiveBtnTitle
    otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //添加按钮
    if (cancelBtnTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            block(0);
        }];
        [alertController addAction:cancelAction];
    }
    if (destructiveBtnTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBtnTitle) {block(1);}
            else {block(0);}
        }];
        [alertController addAction:destructiveAction];
    }
    if (otherButtonTitles)
    {
        UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (!cancelBtnTitle && !destructiveBtnTitle) {block(0);}
            else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)) {block(1);}
            else if (cancelBtnTitle && destructiveBtnTitle) {block(2);}
        }];
        [alertController addAction:otherActions];
        
        va_list args;//定义一个指向个数可变的参数列表指针;
        va_start(args, otherButtonTitles);//va_start 得到第一个可变参数地址
        NSString *title = nil;
        
        int count = 2;
        if (!cancelBtnTitle && !destructiveBtnTitle) {count = 0;}
        else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle)) {count = 1;}
        else if (cancelBtnTitle && destructiveBtnTitle) {count = 2;}
        
        while ((title = va_arg(args, NSString *)))//指向下一个参数地址
        {
            count ++;
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                block(count);
            }];
            [alertController addAction:otherAction];
        }
        va_end(args);//置空指针
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
    //如果没有按钮，自动延迟消失
    if (cancelBtnTitle == nil && destructiveBtnTitle == nil && otherButtonTitles == nil) {
        //此时self指本类
        [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:AlertViewShowTime];
    }
    
}



#pragma mark - 无按钮弹窗自动消失 类方法 此时self指本类 下面为类方法 否则崩溃
+ (void)dismissAlertView:(UIAlertView*)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
+ (void)dismissActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
+ (void)dismissAlertController:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 检查并跳转登陆

//1.检查是否登陆

+ (void)checkLoginIfNecessary:(UIViewController *)viewController {
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN];
    
    if (result) return;
    [LCAlertTools showTipAlertViewWith:viewController title:@"提示" message:@"您还没有登录, 请先登录！" cancelTitle:@"确定" cancelHandler:^{
        LCLonginVC *loginVC = [[LCLonginVC alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [viewController.navigationController pushViewController:loginVC animated:YES];
    }];

}

@end
