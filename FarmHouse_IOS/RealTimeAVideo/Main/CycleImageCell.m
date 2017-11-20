//
//  CycleImageCell.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//
#import "CycleImageCell.h"
#import "SDCycleScrollView.h"

@interface CycleImageCell ()<SDCycleScrollViewDelegate>
@property (strong, nonatomic)  SDCycleScrollView *cycleView;


@end

@implementation CycleImageCell

+ (instancetype)creatCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellID imagesArr:(NSArray *)imagesArr{
    CycleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CycleImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID imagesArr:imagesArr];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imagesArr:(NSArray *)imagesArr{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageNamesGroup:imagesArr];
        [self addSubview:self.cycleView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.cycleView.frame = self.frame;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---%ld", (long)index);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
