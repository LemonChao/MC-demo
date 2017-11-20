//
//  LCPhotoDetailCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/12.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPhotoDetailCell.h"

@interface LCPhotoDetailCell ()

@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UIButton *deleteBtn;

@property(nonatomic, strong) UIButton *saveBtn;

@end
@implementation LCPhotoDetailCell


+ (instancetype)createCellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)cellId atIndexPath:(NSIndexPath *)indexPath {
    LCPhotoDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[LCPhotoDetailCell alloc] initWithFrame:CGRectZero];
    }
    
    return cell;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
//        _imgView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_imgView];
        
        //textView
        _textView = [[UITextViewPlaceholder alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeholder = @"请输入图片描述";
        _textView.textColor = [UIColor blackColor];
        _textView.font = kFontSize16;
        [self addSubview:_textView];
        
        //toolBar
        UIView *toolBar = [[UIView alloc] init];
        toolBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:toolBar];
        
        //button
        _deleteBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"删 除" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] bgColor:MainColor cornerRadius:5.0 borderColor:nil borderWidth:0.0];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:_deleteBtn];
        
        //saveBtn
        _saveBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"保 存" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] bgColor:MainColor cornerRadius:5.0 borderColor:nil borderWidth:0.0];
        [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:_saveBtn];
        
        CGFloat padding = 10;
        
        [toolBar makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(49);
        }];
        
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.bottom.equalTo(toolBar.top);
            make.height.equalTo(AutoWHGetHeight(80));
        }];
        
        
        [_imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(_textView.top).offset(0);
        }];
        
        [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(toolBar).offset(20);
            make.centerY.equalTo(toolBar);
            make.height.equalTo(40);
            make.width.equalTo(AutoWHGetHeight(120));
        }];
        
        [_saveBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(toolBar).offset(-20);
            make.centerY.equalTo(toolBar);
            make.height.equalTo(38);
            make.width.equalTo(AutoWHGetHeight(120));
        }];

    }
    return self;
}


//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        //scrollView
//        UIScrollView *bgScrollView = [[UIScrollView alloc] init];
//        [self addSubview:bgScrollView];
//        
//        UIView *contentView = [[UIView alloc] init];
//        contentView.backgroundColor = [UIColor redColor];
//        [bgScrollView addSubview:contentView];
//        
//        self.imgView = [[UIImageView alloc] init];
//        _imgView.contentMode = UIViewContentModeScaleAspectFit;
//        //        _imgView.backgroundColor = [UIColor yellowColor];
//        [contentView addSubview:_imgView];
//        
//        //textView
//        _textView = [[UITextViewPlaceholder alloc] init];
//        _textView.backgroundColor = [UIColor clearColor];
//        _textView.placeholder = @"请输入图片描述";
//        _textView.textColor = [UIColor blackColor];
//        _textView.font = kFontSize16;
//        [contentView addSubview:_textView];
//        
//        //toolBar
//        UIView *toolBar = [[UIView alloc] init];
//        toolBar.backgroundColor = [UIColor whiteColor];
//        [contentView addSubview:toolBar];
//        
//        //button
//        _deleteBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"删 除" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] bgColor:MainColor cornerRadius:5.0 borderColor:nil borderWidth:0.0];
//        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [toolBar addSubview:_deleteBtn];
//        
//        //saveBtn
//        _saveBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"保 存" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] bgColor:MainColor cornerRadius:5.0 borderColor:nil borderWidth:0.0];
//        [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [toolBar addSubview:_saveBtn];
//        
//        CGFloat padding = 10;
//        
//        [bgScrollView makeConstraints:^(MASConstraintMaker *make) {
////            make.edges.equalTo(UIEdgeInsetsZero);
//            make.left.right.top.bottom.equalTo(self);
//        }];
//        
//        [contentView makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(bgScrollView);
//            make.width.equalTo(bgScrollView);
//        }];
//        
//        
//        [toolBar makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self);
//            make.right.equalTo(self);
//            make.bottom.equalTo(self);
//            make.height.equalTo(49);
//        }];
//        
//        [_textView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(padding);
//            make.right.equalTo(self).offset(-padding);
//            make.bottom.equalTo(toolBar.top);
//            make.height.equalTo(AutoWHGetHeight(80));
//        }];
//        
//        
//        [_imgView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.left.equalTo(self);
//            make.right.equalTo(self);
//            make.bottom.equalTo(_textView.top).offset(0);
//        }];
//        
//        [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(toolBar).offset(20);
//            make.centerY.equalTo(toolBar);
//            make.height.equalTo(40);
//            make.width.equalTo(AutoWHGetHeight(120));
//        }];
//        
//        [_saveBtn makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(toolBar).offset(-20);
//            make.centerY.equalTo(toolBar);
//            make.height.equalTo(38);
//            make.width.equalTo(AutoWHGetHeight(120));
//        }];
//        
//        //重新设置contentView的bottom
//        [contentView makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.bottom.equalTo(toolBar.bottom);
//            
//        }];
//        
//    }
//    return self;
//}


- (void)deleteBtnAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(photoDetailCell:clickButtonIndex:)]) {
        [_delegate photoDetailCell:self clickButtonIndex:0];
    }
}

- (void)saveBtnAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(photoDetailCell:clickButtonIndex:)]) {
        [_delegate photoDetailCell:self clickButtonIndex:1];
    }
}

- (void)setImgModle:(LCHouseHoldImage *)imgModle {
    _imgModle = imgModle;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgModle.imageurl]];
    
    _textView.text = imgModle.imagecontent;
    
}

//- (void)setModel:(LCHouseHoldImage *)model {
//    
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:[UIImage imageNamed:@"default_image"]];
//}
@end

