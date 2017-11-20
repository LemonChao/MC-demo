//
//  LCAddressPickerView.h
//  LCAddressPickerView
//
//  Created by Lemon on 16/11/18.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAddressPickerView : UIView

-(instancetype)initWithTWFrame:(CGRect)rect TWselectCityTitle:(NSString*)title;

/**
 *  显示
 */
-(void)showCityView:(void(^)(NSString *proviceStr,NSString *cityStr,NSString *distr))selectStr;


@end
