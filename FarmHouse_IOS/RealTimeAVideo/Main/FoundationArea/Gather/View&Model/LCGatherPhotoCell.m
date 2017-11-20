//
//  LCGatherPhotoCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/11.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCGatherPhotoCell.h"

@interface LCGatherPhotoCell ()

@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UILabel *desLab;

@end

@implementation LCGatherPhotoCell

static NSInteger padding = 3;


+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath{
    LCGatherPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCGatherPhotoCell alloc] initWithFrame:CGRectZero];
    }
    
    return cell;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // self.backgroundColor = [UIColor yellowColor];
        //bgVIew
        self.bgView = [UIView new];
        _bgView.layer.cornerRadius = 3;
        _bgView.layer.borderColor = BGColor.CGColor;
        _bgView.layer.borderWidth = 1;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        
        //imgView
        self.imgView = [[UIImageView alloc] init];
        //  _imgView.contentMode = UIViewContentModeScaleAspectFill;
        //   _imgView.backgroundColor = [UIColor greenColor];
        [_bgView addSubview:_imgView];
        
        //desLab
        self.desLab = [LCTools createLable:@"描述:这是一张来之未来的定损招聘，不可思议吧神奇的易万联，哈哈哈哈！！" withFont:kFontSize14 textColor:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
        [_desLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.desLab.preferredMaxLayoutWidth = frame.size.width - 2 * padding;
        //        _desLab.backgroundColor = [UIColor redColor];
        [_bgView addSubview:_desLab];
    }
    return self;
}

- (void)setValueWithModel:(LCPhotoModel *)model isEnd:(BOOL)isEnd {
    NSString *text = model.imgDescrip ? [NSString stringWithFormat:@"描述:%@", model.imgDescrip]:@"描述:";
    _desLab.text = text;
    _imgView.image = model.image;
    
    
}

- (void)setValueWithModel:(LCPhotoModel *)model indexPath:(NSIndexPath *)indexPath {
    if (model != nil) {
        NSString *text = model.imgDescrip ? [NSString stringWithFormat:@"描述:%@", model.imgDescrip]:@"描述:";
        _desLab.text = text;
        _placeHolder = NO;
    }else {
        _desLab.text = @"描述：";
        NSString *imgfile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"photograph_guide%ld@2x", indexPath.row] ofType:@"png"];
        
        //        NSString *imgfile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"photograph_guide6.png"];
        _imgView.image = [UIImage imageWithContentsOfFile:imgfile];
        _placeHolder = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(3, 3, 3, 3));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(padding);
        make.height.mas_equalTo(AutoWHGetHeight(155) - 15);
        make.right.mas_equalTo(-padding);
    }];
    [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(_imgView.bottom).offset(padding);
    }];
    
}

@end

