//
//  LCPictureCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/27.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPictureCell.h"

@interface LCPictureCell ()

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UILabel *label;

@end

@implementation LCPictureCell
+ (instancetype)createCellWith:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellid forIndexPath:(NSIndexPath *)indexPath {
    LCPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCPictureCell alloc] initWithFrame:CGRectZero];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor cyanColor];
        
        self.imageView = [[UIImageView alloc]init];
//        _imageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_imageView];
        
        self.label = [LCTools createLable:@"暂无图片描述" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        _label.numberOfLines = 1;
//        _label.backgroundColor = [UIColor redColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)setValueWithModel:(LCReportImgModel *)seaModel {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:seaModel.imagepath] placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.label.text = [seaModel.content isEqualToString:@""] ? @"暂无图片描述" : seaModel.content;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.equalTo(self.height).multipliedBy(0.76);
    }];
    
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.bottom);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self.bottom);
    }];
    
    
    
}

@end
