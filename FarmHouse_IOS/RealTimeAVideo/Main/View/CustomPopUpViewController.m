//
//  CustomPopUpViewController.m
//  ReactiveCocoa
//
//  Created by sunpeng on 2017/4/27.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import "CustomPopUpViewController.h"
#import "Masonry.h"
#import "SPReportTypeView.h"

@interface CustomPopUpViewController ()
//弹出视图的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
//弹出视图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (strong, nonatomic) SPReportTypeView *spReportView;
@property (copy, nonatomic) void(^selectBlcok)(NSInteger);
@end

@implementation CustomPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _backgroundView.alpha = 0;
    _customView.alpha = 0;
    _customView.layer.cornerRadius = 5;
    [self addSportView];
}

- (void)addSportView{
    
    [_customView addSubview:self.spReportView];
    [_spReportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(240);
    }];
    [_width setConstant:SCREEN_WIDTH - 30];
    [_height setConstant:240];
    [self.view setNeedsLayout];
}

- (SPReportTypeView *)spReportView{
    if (_spReportView == nil) {
        __weak typeof(self)weakSelf = self;
        _spReportView = [SPReportTypeView initFromNibSelectBlock:^(NSInteger type) {
            if (weakSelf.selectBlcok&&type!= 3) {
                weakSelf.selectBlcok(type);
                [weakSelf disMiss];
            }else{
                [weakSelf disMiss];
            }
        }];
    }
    return _spReportView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPopUpViewController:(UIViewController *)vc pickType:(void (^)(NSInteger))block{
    if (vc) {
        [vc addChildViewController:self];
        [vc.view addSubview:self.view];
         self.selectBlcok = block;
        [self show];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (void)addKeyAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.calculationMode = kCAAnimationCubic;
    animation.values = @[@1.07,@1.06,@1.05,@1.03,@1.02,@1.01,@1.0];
    animation.duration = 0.4;
    [self.customView.layer addAnimation:animation forKey:@"transform.scale"];
}

- (void)show {
    self.tabBarController.tabBar.hidden = YES;
    self.backgroundView.alpha = 0.7;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.customView.alpha = 1;
    } completion:nil];
    [self addKeyAnimation];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self disMiss];
}


- (void)disMiss {
    self.tabBarController.tabBar.hidden = NO;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
