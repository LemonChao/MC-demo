//
//  YQInputPayKeyWordView.m
//  Youqun
//
//  Created by 王崇磊 on 16/6/1.
//  Copyright © 2016年 W_C__L. All rights reserved.
//

#import "YQInputPayKeyWordView.h"
#import "JCAlertView.h"

@interface YQInputPayKeyWordView ()
{
    JCAlertView *alertView;
}
@property (copy, nonatomic) void(^selectBlock)(void);

@end

@implementation YQInputPayKeyWordView


+ (instancetype)initFromNibSelectBlock:(void(^)(void))block {
    YQInputPayKeyWordView *input = [[[UINib nibWithNibName:@"YQInputPayKeyWordView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    return input;
}

+ (instancetype)initFromNib {
    
    YQInputPayKeyWordView *input = [[[UINib nibWithNibName:@"YQInputPayKeyWordView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    input.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.918, 197);
    [input setup];
    return input;

}
- (IBAction)closeButtonAction:(UIButton *)sender {
    
    [alertView dismissWithCompletion:nil];
    alertView = nil;
}


- (void)showkeyBoard {
    
    [alertView show];

}

- (void)dissmissCompletion:(void(^)()) complete {
    [alertView dismissWithCompletion:complete];
    alertView = nil;
}

- (void)setup {
    alertView = [[JCAlertView alloc] initWithCustomView:self dismissWhenTouchedBackground:NO];

}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    if (point.y > 93 && point.y < 144) {
//        if (self.selectBlock) {
//            self.selectBlock();
//        }
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
