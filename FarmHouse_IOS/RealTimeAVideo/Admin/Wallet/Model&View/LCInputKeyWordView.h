//
//  LCInputKeyWordView.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCLPassWordView.h"
@interface LCInputKeyWordView : UIView

//@property (strong, nonatomic) UILabel *titleLab;
//@property (strong, nonatomic) WCLPassWordView *passWordView;


@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet WCLPassWordView *passWordView;

+ (instancetype)initFromeNibWithFrame:(CGRect)frame;


@end
