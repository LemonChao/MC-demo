//
//  MessageView.m
//  EwlMassAssessment
//
//  Created by sunpeng on 2017/7/27.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import "MessageView.h"
#define  MSGCOLOR [UIColor colorWithRed:175 green:229 blue:76 alpha:1]

@interface MessageView ()

@property (nonatomic, strong)UILabel *contentLab;

@end

@implementation MessageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setNeedsDisplay];
        [self createContent];
    }
    return self;
}

- (void)createContent{
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 6;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = MainColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(60);
    }];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.numberOfLines = 0;
    _contentLab.font = [UIFont systemFontOfSize:kSize15];
    [bgView addSubview:_contentLab];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setMsgText:(NSString *)msgText{
    _msgText = msgText;
    _contentLab.text = _msgText;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //设置背景颜色
    //拿到当前视图准备好的画板
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context,30, 0);//设置起点
    CGContextAddLineToPoint(context, 20, 10);
    CGContextAddLineToPoint(context, 45, 10);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [MainColor setFill];
    //设置填充色
    [[UIColor clearColor] setStroke];
    //设置边框颜色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
}


@end
