//
//  StepProgressView.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "StepProgressView.h"

static const float imgBtnWidth=18;

@interface StepProgressView ()
{
    CGFloat topSpac;
    CGFloat middleSpac;
    CGFloat bottomSpac;
}

@property (nonatomic,strong) UIProgressView *progressView;

//用UIButton防止以后有点击事件
@property (nonatomic,strong) NSMutableArray *imgBtnArray;

@end


@implementation StepProgressView

+(instancetype)progressView:(CGRect)frame titleArray:(NSArray *)titleArray style:(StepProgressStyle)style
{
    StepProgressView *stepProgressView=[[StepProgressView alloc]initWithFrame:frame titleArray:titleArray style:style];
    return stepProgressView;
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray style:(StepProgressStyle)style
{
    CGSize size = [@"" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    if (style == StepProgressAverage) {
        topSpac = middleSpac = bottomSpac = (frame.size.height - size.height - imgBtnWidth)/3;
    }else if (style == StepProgressExtreme) {
        topSpac = bottomSpac = 0;
        middleSpac = frame.size.height - size.height;
    }

    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        //进度条
        self.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-imgBtnWidth, 10)];
        self.progressView.center = CGPointMake(frame.size.width/2, frame.size.height-imgBtnWidth/2-bottomSpac);
        self.progressView.progressViewStyle=UIProgressViewStyleBar;
        self.progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);
        self.progressView.progressTintColor=MainColor;
        self.progressView.trackTintColor=[UIColor lightGrayColor];
        self.progressView.progress=0;
        [self addSubview:self.progressView];

        self.imgBtnArray=[[NSMutableArray alloc]init];
        
        CGFloat spacing=self.progressView.frame.size.width/(titleArray.count-1);
        CGFloat centerY = self.progressView.center.y;
        for (int i=0; i<titleArray.count; i++) {
            
            //图片按钮
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"gray_round"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"green_round"] forState:UIControlStateSelected];
//            btn.backgroundColor = [UIColor redColor];
            btn.selected=NO;
            btn.frame=CGRectMake(0, 0, imgBtnWidth, imgBtnWidth);
            btn.center = CGPointMake(imgBtnWidth/2+spacing*i, centerY);
            [self addSubview:btn];
            
            [self.imgBtnArray addObject:btn];
            
            //文字
            UILabel *titleLabel=[[UILabel alloc]init];
//            titleLabel.backgroundColor = [UIColor redColor];
            titleLabel.text=[titleArray objectAtIndex:i];
            [titleLabel setTextColor:[UIColor blackColor]];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.font=[UIFont systemFontOfSize:14];
            [titleLabel sizeToFit];
            if (i == 0) {
                titleLabel.center = CGPointMake(titleLabel.frame.size.width/2, titleLabel.frame.size.height/2+topSpac);
            }else if (i == titleArray.count-1) {
                titleLabel.center = CGPointMake(frame.size.width-titleLabel.frame.size.width/2, titleLabel.frame.size.height/2+topSpac);
            }else {
                titleLabel.center = CGPointMake(imgBtnWidth/2+spacing*i, titleLabel.frame.size.height/2+topSpac);
            }
            [self addSubview:titleLabel];
        }

    }
    return self;
}

-(void)setStepIndex:(NSInteger)stepIndex
{
    for (int i=0; i<_imgBtnArray.count; i++) {
        UIButton *btn=[_imgBtnArray objectAtIndex:i];
        if (i<=stepIndex) {
            btn.selected=YES;
        }
        else{
            btn.selected=NO;
        }
    }
    
    CGFloat progress = stepIndex/(_imgBtnArray.count-1.0f);
    self.progressView.progress = progress;
}


@end
