//
//  LCNotifDetailVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/22.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCNotifDetailVC.h"

@interface LCNotifDetailVC ()

@end

@implementation LCNotifDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    self.view.backgroundColor = TabBGColor;
    
    [self createMainView];
}

- (void)createMainView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = 0.5;
    contentView.clipsToBounds = YES;
    [self.view addSubview:scrollView];
    [scrollView addSubview:contentView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(20, 20, 0, 20));
        make.width.equalTo(SCREEN_WIDTH-40);
    }];
    
    UILabel *titleLab = [LCTools createLable:self.notifNews.title withFont:kFontSizeBold16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [contentView addSubview:titleLab];
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(20);
        make.left.equalTo(contentView).offset(20);
        make.right.equalTo(contentView).offset(-20);
        make.height.equalTo(AutoWHGetHeight(18));
    }];
    
    UILabel *companyLab = [LCTools createLable:self.notifNews.sender withFont:kFontSize15 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft];
//    companyLab.backgroundColor = [UIColor yellowColor];
    [contentView addSubview:companyLab];
    [companyLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.bottom).offset(10);
        make.left.equalTo(titleLab);
        make.height.equalTo(AutoWHGetHeight(16));
    }];
    
    UILabel *timeLab = [LCTools createLable:self.notifNews.time withFont:kFontSize15 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight];
//    timeLab.backgroundColor = [UIColor yellowColor];
    [contentView addSubview:timeLab];
    [timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.bottom).offset(10);
        make.right.equalTo(titleLab);
        make.height.equalTo(AutoWHGetHeight(16));
    }];
    
    UIView *lineView = [LCTools createLineView:[UIColor lightGrayColor]];
    [contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyLab.bottom).offset(20);
        make.left.equalTo(contentView).offset(20);
        make.right.equalTo(contentView).offset(-20);
        make.height.equalTo(0.75);
    }];
    
    UILabel *contentLab = [LCTools createLable:self.notifNews.content withFont:kFontSize16 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [contentView addSubview:contentLab];
    [contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView).offset(20);
        make.left.right.equalTo(contentView).offset(20);
        
        make.bottom.equalTo(contentView).offset(-20);
    }];


}



@end
