//
//  LCNewsCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCNewsCell.h"

@interface LCNewsCell ()
@property (nonatomic,strong) UIImageView *photoView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *abstractLab;
@property (nonatomic,strong) UILabel *timeLab;

@end

@implementation LCNewsCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellID {
    LCNewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!newsCell) {
        newsCell = [[LCNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        if ([newsCell respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }

    }
    return newsCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //photo
//        self.photoView = [[UIImageView alloc] initWithFrame:AutoWHCGRectMake(10, 10, 90, 90, YES, YES)];
        self.photoView = [[UIImageView alloc] init];
        [self addSubview:_photoView];
        
        //titleLab
        self.titleLab = [[UILabel alloc] init];
        _titleLab.font = kFontSize17;
//        _titleLab.backgroundColor = [UIColor cyanColor];
        _titleLab.textColor = [UIColor blackColor];
        [self addSubview:_titleLab];
        
        //abstractLab
        self.abstractLab = [[UILabel alloc] init];
        _abstractLab.font = kFontSize15;
        _abstractLab.numberOfLines = 2;
//        _abstractLab.backgroundColor = [UIColor yellowColor];
        _abstractLab.textColor = [UIColor lightGrayColor];
        [self addSubview:_abstractLab];
        
        //titleLab
        self.timeLab = [[UILabel alloc] init];
        _timeLab.font = kFontSize14;
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.textColor = [UIColor lightGrayColor];
        [self addSubview:_timeLab];

        
    }
    return self;
}

- (void)setValueWithModel:(LCFarmNewsModel *)model {
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:@"default_image"]];
    
    self.titleLab.text = model.title;
    
    self.abstractLab.text = model.synopsis;
    
    self.timeLab.text = model.datetime;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10.0f;
    
    
    [_photoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.centerY.equalTo(self);
        make.top.equalTo(self).offset(margin);
        make.bottom.equalTo(self).offset(-margin);
        make.width.equalTo(_photoView.height).multipliedBy(1.5);
    }];
    
    [_titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoView.right).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.top.equalTo(self).offset(margin);
        make.height.equalTo(23);
    }];
    
    [_timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoView.right).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.bottom.equalTo(self).offset(-margin);
        make.height.equalTo(20);
    }];
    
    
    [_abstractLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoView.right).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.top.equalTo(_titleLab.bottom);
        make.bottom.equalTo(_timeLab.top);
    }];
    
}

@end
