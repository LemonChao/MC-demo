//
//  LCPhotoColumnCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/11.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPhotoColumnCell.h"


@interface LCColumnAddCell ()

@property(nonatomic, strong) UIImageView *addView;

@end

@implementation LCColumnAddCell


+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath {
    LCColumnAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCColumnAddCell alloc] initWithFrame:CGRectZero];
    }
    
    return cell;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor whiteColor];
        
        self.addView = [[UIImageView alloc] init];
        _addView.image = [UIImage imageNamed:@"addCell"];
        _addView.contentMode = UIViewContentModeScaleAspectFit;
//        _addView.backgroundColor = [UIColor greenColor];
        [self addSubview:_addView];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_addView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}




@end


@interface LCPhotoColumnCell ()

@property(nonatomic, strong) UIImageView *imgView;

@end
@implementation LCPhotoColumnCell


+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath {
    LCPhotoColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCPhotoColumnCell alloc] initWithFrame:CGRectZero];
    }
    
    return cell;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleToFill;
//        _imgView.backgroundColor = [UIColor greenColor];
        [self addSubview:_imgView];

    }
    return self;
}

- (void)setModel:(LCHouseHoldImage *)model {
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:[UIImage imageNamed:@"default_image"]];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

@end


//采集cell img+des
@interface LCGatherCell ()

@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UILabel *desLab;

@end

@implementation LCGatherCell


+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath {
    LCGatherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCGatherCell alloc] initWithFrame:CGRectZero];
    }
    return cell;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *contentView = [[UIView alloc] init];
//        contentView.backgroundColor = [UIColor redColor];
        [self addSubview:contentView];
        
        self.imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
//        _imgView.backgroundColor = [UIColor greenColor];
        [contentView addSubview:_imgView];
        
        self.desLab = [LCTools createLable:nil withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        _desLab.numberOfLines = 1;
        [contentView addSubview:_desLab];
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(self.height).multipliedBy(0.7);
            make.width.equalTo(self.width).multipliedBy(0.7);
        }];
        
        [_imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(0);
            make.left.equalTo(contentView).offset(0);
            make.right.equalTo(contentView).offset(0);
            make.bottom.equalTo(_desLab.top).offset(-8);
        }];
        
        [_desLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(0);
            make.right.equalTo(contentView).offset(0);
            make.bottom.equalTo(contentView.bottom);
            make.height.equalTo(AutoWHGetHeight(20));
        }];

    }
    return self;
}


- (void)setValueWith:(NSDictionary *)infoDic {
    self.imgView.image = [UIImage imageNamed:infoDic[@"imageName"]];
    
    self.desLab.text = infoDic[@"title"];

}

@end


//管理cell img+des
@interface LCManagerCell ()

@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UILabel *desLab;

/** 右上小红点 */
@property(nonatomic, strong) UIButton *redPoint;

@end

@implementation LCManagerCell


+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath {
    LCManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCManagerCell alloc] initWithFrame:CGRectZero];
    }
    return cell;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *contentView = [[UIView alloc] init];
        //        contentView.backgroundColor = [UIColor redColor];
        [self addSubview:contentView];
        
        self.imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        //        _imgView.backgroundColor = [UIColor greenColor];
        [contentView addSubview:_imgView];
        
        self.desLab = [LCTools createLable:nil withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        _desLab.numberOfLines = 1;
        [contentView addSubview:_desLab];
        
        self.redPoint = [LCTools createWordButton:UIButtonTypeCustom title:@"144" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] bgColor:[UIColor redColor] cornerRadius:9 borderColor:nil borderWidth:0];
        _redPoint.hidden = YES;
        [_redPoint addTarget:self action:@selector(randromValueChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_redPoint];
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(self.height).multipliedBy(0.9);
            make.width.equalTo(self.width).multipliedBy(0.9);
        }];
        
        [_imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(0);
            make.left.equalTo(contentView).offset(0);
            make.right.equalTo(contentView).offset(0);
            make.bottom.equalTo(_desLab.top).offset(-8);
        }];
        
        [_desLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(0);
            make.right.equalTo(contentView).offset(0);
            make.bottom.equalTo(contentView.bottom);
            make.height.equalTo(AutoWHGetHeight(20));
        }];
        
        [_redPoint makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(18);
        }];
        
    }
    return self;
}


- (void)setValueWith:(NSDictionary *)infoDic {
    self.imgView.image = [UIImage imageNamed:infoDic[@"imageName"]];
    
    self.desLab.text = infoDic[@"title"];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    if ([badgeValue intValue] <= 0 || badgeValue == nil) {
        _redPoint.hidden = YES;
        return;
    };
    
    _redPoint.hidden = NO;
    [_redPoint setTitle:badgeValue forState:UIControlStateNormal];

    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:_redPoint.titleLabel.font, NSKernAttributeName:@(2)}];
    
    CGFloat width = size.width >= 18 ? size.width : 18;
    
    [_redPoint updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(18);
        make.width.equalTo(width);
    }];
    
}


- (void)randromValueChange:(UIButton *)button {
    
    // [0,100)
    NSString *randStr = [NSString stringWithFormat:@"%d", arc4random() % 100];
    
    [self setBadgeValue:randStr];
}

@end

