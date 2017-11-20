//
//  LCHistoryCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCHistoryCell.h"
#import "HouseHold+CoreDataProperties.h"

@interface LCHistoryCell ()
@property(nonatomic, strong) UIButton *button;

@end

@implementation LCHistoryCell

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath {
    LCHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LCHistoryCell alloc] initWithFrame:CGRectZero];
    }
    return cell;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.button = [LCTools createWordButton:UIButtonTypeCustom title:@"" titleColor:MainColor font:kFontSize15 bgColor:[UIColor whiteColor] cornerRadius:HisCellH/2.0 borderColor:MainColor borderWidth:1.0f];
        _button.userInteractionEnabled = NO;
        [self addSubview:_button];
    }
    return self;
}


- (void)setValueWithModel:(HouseHold *)houseModle {
  //  self.button.titleLabel.text = houseModle.name;
    [self.button setTitle:houseModle.name forState:UIControlStateNormal];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_button makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

@end
