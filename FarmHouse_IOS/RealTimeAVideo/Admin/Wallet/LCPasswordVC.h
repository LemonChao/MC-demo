//
//  LCPasswordVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PasswordType) {
    PasswordVerification = 0, //输入密码，以验证身份
    PasswordNew,              //请输入新密码
    PasswordAgain,            //请再次输入密码
    PasswordRemoveBinding,    //解除绑定
    PasswordAddNewCard,       //添加新卡
    PasswordReset,            //修改提现密码
};

@interface LCPasswordVC : UIViewController

@property(nonatomic, assign) PasswordType type;

/** 附带消息 
    解除绑定为bank card id
    找回密码为上次输入密码
 */
@property(nonatomic, copy) NSString *infoString;

@end
