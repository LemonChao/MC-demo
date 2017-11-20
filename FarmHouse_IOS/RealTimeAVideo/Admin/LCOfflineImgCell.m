//
//  LCOfflineImgCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/21.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCOfflineImgCell.h"
#import "LCOfflineModel.h"


@interface LCOfflineAddCell ()

@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UIImageView *addView;



@end

@implementation LCOfflineAddCell

+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath {
    LCOfflineAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCOfflineAddCell alloc] initWithFrame:CGRectZero];
    }
    
    return cell;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // self.backgroundColor = [UIColor yellowColor];
        
        self.addView = [[UIImageView alloc] init];
        _addView.image = [UIImage imageNamed:@"addCell"];
        _addView.contentMode = UIViewContentModeScaleAspectFit;
      //  _addView.backgroundColor = [UIColor greenColor];
        [self addSubview:_addView];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_addView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(6);
        make.left.equalTo(self.left).offset(6);
        make.right.equalTo(self.right).offset(-6);
        make.height.equalTo(AutoWHGetHeight(143));
    }];
}

@end








@interface LCOfflineImgCell ()

@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) UILabel *desLab;

@end

@implementation LCOfflineImgCell

static NSInteger padding = 3;


+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath{
    LCOfflineImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCOfflineImgCell alloc] initWithFrame:CGRectZero];
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

- (void)setValueWithModel:(LCOfflineImgModel *)model isEnd:(BOOL)isEnd {
    NSString *text = model.imgDescrip ? [NSString stringWithFormat:@"描述:%@", model.imgDescrip]:@"描述:";
    _desLab.text = text;
    _imgView.image = model.image;
    
//    NSString *imgPath =  [[SandBoxManager creatPathUnderCaches:@"/OfflineImg/"] stringByAppendingString:model.filePath];
//    _imgView.image  = [UIImage imageWithContentsOfFile:imgPath];
    
}

- (void)setValueWithModel:(LCOfflineImgModel *)model indexPath:(NSIndexPath *)indexPath {
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
- (void)setValueWithModel:(LCOfflineImgModel *)model isPlaceHolder:(BOOL)placeHolder {
    
    NSString *text = model.imgDescrip ? [NSString stringWithFormat:@"描述:%@", model.imgDescrip]:@"描述:";
    _desLab.text = text;

    if (placeHolder) { //是占位
        _placeHolder = YES;
        _imgView.image = model.placeholderImg;
        
    }else {
        _placeHolder = NO;
        _imgView.image = model.image;

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
   
//    [_desLab makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_imgView.bottom).offset(padding);
//        make.left.equalTo(_bgView.left).offset(padding);
//        make.right.equalTo(_bgView.right).offset(-padding);
//      //  make.bottom.equalTo(_bgView.bottom).offset(-padding);
//        make.height.equalTo(AutoWHGetHeight(50));
//    }];
//    
//    [_imgView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bgView.top).offset(padding);
//        make.left.equalTo(_bgView.left).offset(padding);
//        make.right.equalTo(_bgView.right).offset(-padding);
//        make.bottom.equalTo(_desLab.top).offset(-padding);
//        //        make.height.equalTo(AutoWHGetHeight(143));
//        
//    }];

}

@end








