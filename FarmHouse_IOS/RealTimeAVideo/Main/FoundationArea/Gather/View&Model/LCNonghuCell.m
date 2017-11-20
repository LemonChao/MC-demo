//
//  LCNonghuCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/5.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCNonghuCell.h"


@interface LCNonghuCell ()

@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UILabel *houseHoldLab;

@property(nonatomic, strong) UIImageView *arrowImg;

@end

@implementation LCNonghuCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView reuseid:(NSString *)reuseid {
    LCNonghuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[LCNonghuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.imgView = [LCTools createImageView:[UIImage imageNamed:@"gather_nhPortrait"] cornerRadius:30];
//        _imgView.backgroundColor = [UIColor cyanColor];
        [self addSubview:_imgView];

        self.houseHoldLab = [LCTools createLable:nil withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
//        _houseHoldLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:_houseHoldLab];
        
        self.arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greyarrow"]];
//        _arrowImg.backgroundColor = [UIColor redColor];
        [self addSubview:_arrowImg];
    }
    return self;
}


- (void)setValueWithModel:(LCHouseHoldModel *)model {
    NSString *string = [NSString stringWithFormat:@"户主：%@\n家庭基本信息", model.name];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    _houseHoldLab.attributedText = attStr;
//    [_houseHoldLab sizeToFit];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10.0;
    [_imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(padding);
        make.centerY.equalTo(self.centerY);
        //        make.size.equalTo(AutoCGSizeMake(50, 50));
        make.size.equalTo(CGSizeMake(60, 60));
    }];
    
    [_arrowImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-(16));
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(8.4, 13.2));
    }];
    
    [_houseHoldLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.right).offset(padding);
        make.centerY.equalTo(self);
        make.right.equalTo(_arrowImg.left).offset(-padding);
    }];
    
}


@end



/// 表头显示户主
@interface LCNonghuHead ()
@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UILabel *houseHoldLab;

@property(nonatomic, strong) UIImageView *arrowImg;

@end
@implementation LCNonghuHead

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [LCTools createImageView:[UIImage imageNamed:@"head"] cornerRadius:30];
        _imgView.backgroundColor = [UIColor cyanColor];
        [self addSubview:_imgView];
        
//        NSAttributedString *attStr = [NSAttributedString alloc] initWithString:<#(nonnull NSString *)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#>
        
        self.houseHoldLab = [LCTools createLable:@"户主：刘先生\n\n家庭基本信息" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        _houseHoldLab.backgroundColor = [UIColor yellowColor];
        [_houseHoldLab sizeToFit];
        [self addSubview:_houseHoldLab];
        
        self.arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greyarrow"]];
        _arrowImg.backgroundColor = [UIColor redColor];
        [self addSubview:_arrowImg];
    }
    
    return self;
}
-(void)setHeadView {
    NSString *string = [NSString stringWithFormat:@"户主：%@家庭基本信息", @"郑显示"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLab.text length])];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];

    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    _houseHoldLab.attributedText = attStr;
    [_houseHoldLab sizeToFit];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10.0;
    [_imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(padding);
        make.centerY.equalTo(self.centerY);
//        make.size.equalTo(AutoCGSizeMake(50, 50));
        make.size.equalTo(CGSizeMake(60, 60));
    }];
    
    [_arrowImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-padding);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(7, 12));
    }];
    
    [_houseHoldLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.right).offset(padding);
        make.centerY.equalTo(self);
        make.right.equalTo(_arrowImg.left).offset(-padding);
    }];
    
    
}

@end
