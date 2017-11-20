//
//  CommentVC.h
//  RealTimeAVideo
//
//  Created by sunpeng on 2017/3/28.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWPublishBaseController.h"
#import "JGTextView.h"
#import "LCSearchModel.h"

typedef void(^RefreshPageBlcok)();

@interface CommentVC : XWPublishBaseController

//背景
@property(nonatomic,strong) UIView *noteTextBackgroudView, *lineView;

//备注
@property(nonatomic,strong) JGTextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;

//文字说明
@property(nonatomic,strong) UILabel *explainLabel;

//发布按钮
@property(nonatomic,strong) UIButton *submitBtn;

//模型
@property(nonatomic, strong)LCSearchModel *model;

//刷新
@property(nonatomic, strong)RefreshPageBlcok blcok;


@end
