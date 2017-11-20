//
//  LCCaptionCustomView.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/12.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCCaptionCustomView.h"

@interface LCCaptionCustomView (){
    id <MWPhoto> _photo;
}

@property(nonatomic, strong) UITextView *textView;

@end

@implementation LCCaptionCustomView

- (id)initWithPhoto:(id<MWPhoto>)photo {
    self = [super initWithPhoto:photo];
    if (self) {
        [self setupCaption];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
}


- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat maxHeight = 9999;
//    if (_label.numberOfLines > 0) maxHeight = _label.font.leading*_label.numberOfLines;
//    CGSize textSize = [_label.text boundingRectWithSize:CGSizeMake(size.width - labelPadding*2, maxHeight)
//                                                options:NSStringDrawingUsesLineFragmentOrigin
//                                             attributes:@{NSFontAttributeName:_label.font}
//                                                context:nil].size;
//    return CGSizeMake(size.width, textSize.height + labelPadding * 2);
    return CGSizeMake(size.width, 100);
}



- (void)setupCaption {
//    _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
//                                                                      self.bounds.size.width-labelPadding*2,
//                                                                      self.bounds.size.height))];
//    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    _label.opaque = NO;
//    _label.backgroundColor = [UIColor clearColor];
//    _label.textAlignment = NSTextAlignmentCenter;
//    _label.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    _label.numberOfLines = 0;
//    _label.textColor = [UIColor whiteColor];
//    _label.font = [UIFont systemFontOfSize:17];
//    if ([_photo respondsToSelector:@selector(caption)]) {
//        _label.text = [_photo caption] ? [_photo caption] : @" ";
//    }
//    [self addSubview:_label];
    
    
    _textView = [[UITextView alloc] init];
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor redColor];
    if ([_photo respondsToSelector:@selector(caption)]) {
        _textView.text = @"sdfdsgfgdgdsfasdf";//[_photo caption] ? [_photo caption] : @" ";
    }

    [self addSubview:_textView];
    
}



@end
