//
//  LCAddressCodePick.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/11/19.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//
//  地址选择器，返回有地址编码

#import <UIKit/UIKit.h>

@interface LCAddressCodePick : UIView

-(instancetype)initWithTWFrame:(CGRect)rect TWselectCityTitle:(NSString*)title;

/**
 *  显示
 */
-(void)showCityView:(void(^)(NSString *proviceStr,NSString *cityStr,NSDictionary *distDic))selectStr;



@end
