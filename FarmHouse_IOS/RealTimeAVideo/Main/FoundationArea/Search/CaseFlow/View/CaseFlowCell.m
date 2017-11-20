//
//  CaseFlowCell.m
//  EWLMedicalSafety
//
//  Created by sunpeng on 2017/3/17.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import "CaseFlowCell.h"
#import "PhotoContainView.h"

@interface CaseFlowCell ()<UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet PhotoContainView *photoContainView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoContainerHeight;

@property (weak, nonatomic) IBOutlet UIButton *fullTextBtn;
//全文Btn高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
//内容高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@end

@implementation CaseFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVc:(LCCaseFlowViewController *)vc {
    _vc = vc;
    
    _photoContainView.vc = _vc;
}

- (void)setModel:(CaseFlowModel *)model{
    if (_model != model) {
        _model = model;
        
    }
    
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.userheadimage] placeholderImage:[UIImage imageNamed:@"default_image"]];
        _nameLab.text = _model.username;
        _timeLab.text = StrFormat(@"%@ %@", _model.title, _model.time);
        _fullTextBtn.hidden = _model.ishideFillBtn;
        if (_fullTextBtn.hidden) {
            [_btnHeight setConstant:0];
        } else {
            [_btnHeight setConstant:21];
        }
        
        if (_model.isFull) {
            [_height setConstant:_model.contentHeight + 1];
            _fullTextBtn.selected = YES;
        }else{
            _fullTextBtn.selected = NO;
            if (_model.contentHeight < 90 - 17) {
                [_height setConstant:_model.contentHeight + 1];
            } else {
                [_height setConstant:90];
            }
        }
        _contentLab.text = _model.content;
        _photoContainView.photoArray = [NSArray arrayWithArray:_model.imagepath];
        [_photoContainerHeight setConstant:_model.photoViewHeight];
}
//展开与收回
- (IBAction)fullText:(UIButton *)sender {
    _model.isFull = !_model.isFull;
    if (_block) {
        _block();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imgView.layer.cornerRadius = 25;
    _imgView.clipsToBounds = YES;
    _contentLab.preferredMaxLayoutWidth = SCREEN_WIDTH - 80;
    [_fullTextBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_fullTextBtn setTitle:@"收起" forState:UIControlStateSelected];
}

@end
