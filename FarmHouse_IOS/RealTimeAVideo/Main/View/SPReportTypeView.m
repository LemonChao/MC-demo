//
//  SPReportTypeView.m
//  ReactiveCocoa
//
//  Created by sunpeng on 2017/4/27.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import "SPReportTypeView.h"

@interface SPReportTypeView ()
@property (weak, nonatomic) IBOutlet UILabel *onlineLab;
@property (weak, nonatomic) IBOutlet UILabel *offlineLab;
@property (weak, nonatomic) IBOutlet UILabel *upSeverLab;

@property (copy, nonatomic) void(^selectBlock)(NSInteger);


@end

@implementation SPReportTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)initFromNibSelectBlock:(void (^)(NSInteger type))block{
    SPReportTypeView *reportView = [[[UINib nibWithNibName:@"SPReportTypeView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    reportView.selectBlock = block;
    return reportView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _onlineLab.attributedText  = [self changeLabelWithText:@"在线报案 \n在网络畅通的情况下直接报案"];
    _offlineLab.attributedText = [self changeLabelWithText:@"离线报案 \n1.在网络差或者没网的情况下拍照"];
    _upSeverLab.attributedText = [self changeLabelWithText:@"离线上传 \n2.拍照之后的案件信息上传"];
}

- (IBAction)onlineAction:(UITapGestureRecognizer *)sender {
    if (self.selectBlock) {
        self.selectBlock(EmptyTypeOnline);
    }
}
- (IBAction)offlineAction:(UITapGestureRecognizer *)sender {
    if (self.selectBlock) {
        self.selectBlock(EmptyTypeOffline);
    }
}
- (IBAction)upSeverAction:(UITapGestureRecognizer *)sender {
    if (self.selectBlock) {
        self.selectBlock(EmptyTypeUpline);
    }
}

-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText

{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,4)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,needText.length-4)];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(4,needText.length-4)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, needText.length)];
    return attrString;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UIView *touchView = touches.anyObject.view;
    if (touchView == _onlineLab || touchView == _offlineLab || touchView == _upSeverLab) {
        return;
    }else{
        if (self.selectBlock) {
            self.selectBlock(EmptyTypeRemove);
        }
    }
}


@end
