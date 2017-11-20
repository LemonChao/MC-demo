//
//  LCAboutUSVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/22.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCAboutUSVC.h"
#import "LCChangeIPVC.h"

@interface LCAboutUSVC ()

@end

@implementation LCAboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initMainView];
    
    [self creatUI];
}


- (void)creatUI {
    CGFloat margin = 15.0f;
    
    NSString *imgpath = [[NSBundle mainBundle] pathForResource:@"ewllogo" ofType:@"png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgpath]];
    [self.view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AutoWHGetHeight(100));
        make.centerX.equalTo(self.view.centerX);
        make.size.equalTo(CGSizeMake(AutoWHGetWidth(180), AutoWHGetHeight(50)));
    }];
    NSString *versionStr = [NSString stringWithFormat:@"版本号 %@",AppVersion];
    UIButton *versionLab = [LCTools createWordButton:UIButtonTypeCustom title:versionStr titleColor:[UIColor blackColor] font:kFontSize14 bgColor:[UIColor whiteColor]];
    [versionLab addTarget:self action:@selector(changeServerIP:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.view addSubview:versionLab];
    [versionLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.bottom).offset(15);
        make.centerX.equalTo(imgView.centerX);
    }];
    
    UILabel *copyRi = [LCTools createLable:@"Copyright © 2016-2020 易万联版权所有" withFont:kFontSize13 textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:copyRi];
    [copyRi makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-margin);
        make.centerX.equalTo(self.view.centerX);
    }];
    
    
    
    UILabel *ewl = [LCTools createLable:@"北京易万联信息科技有限公司" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:ewl];
    [ewl makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(copyRi).offset(-28);
        make.centerX.equalTo(self.view.centerX);
    }];
    
    UILabel *zhongLab = [LCTools createLable:@"中汇国际保险经纪股份有限公司" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:zhongLab];
    [zhongLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ewl).offset(-25);
        make.centerX.equalTo(self.view.centerX);
    }];

    UILabel *gover = [LCTools createLable:@"贵州省民政厅" withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:gover];
    [gover makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(zhongLab).offset(-25);
        make.centerX.equalTo(self.view.centerX);
    }];
    
}


- (void)initMainView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoWHGetHeight(203))];
    topImgView.image = [UIImage imageNamed:@"ewanlan_us"];
    [scrollView addSubview:topImgView];
    
    UIButton *middleBtn = [LCTools createButton:CGRectMake(0, NH(topImgView)+10, SCREEN_WIDTH, AutoWHGetHeight(40)) withName:@"北京易万联信息技术有限公司" normalImg:nil highlightImg:nil selectImg:nil];
    middleBtn.titleLabel.font = kFontSize19;
//    middleBtn.backgroundColor = MainColor;
    [middleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(changeServerIP:) forControlEvents:UIControlEventTouchDownRepeat];
    [scrollView addSubview:middleBtn];

    UIButton *rightImgBtn = [LCTools createButton:CGRectMake(0, NH(middleBtn)+10, SCREEN_WIDTH, AutoWHGetHeight(60)) withName:@"合作企业" normalImg:nil highlightImg:nil selectImg:nil];
    [rightImgBtn setImage:[UIImage imageNamed:@"zhonghuiguoji"] forState:UIControlStateNormal];
    rightImgBtn.titleLabel.font = kFontSize16;
//    rightImgBtn.titleLabel.backgroundColor = [UIColor whiteColor];
//    rightImgBtn.imageView.backgroundColor = [UIColor redColor];
//    rightImgBtn.backgroundColor = [UIColor cyanColor];
    [rightImgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightImgBtn setImagePosition:ZXImagePositionLeft spacing:5];
    [scrollView addSubview:rightImgBtn];
    
    UIButton *bottomImgBtn = [LCTools createButton:CGRectMake(0, NH(rightImgBtn), SCREEN_WIDTH, AutoWHGetHeight(80)) withName:@"扫码下载APP" normalImg:nil highlightImg:nil selectImg:nil];
    [bottomImgBtn setImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
    bottomImgBtn.titleLabel.font = kFontSize12;
//    bottomImgBtn.backgroundColor = [UIColor yellowColor];
    [bottomImgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomImgBtn setImagePosition:ZXImagePositionTop spacing:5];
    [scrollView addSubview:bottomImgBtn];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, NH(bottomImgBtn));
    [self.view addSubview:scrollView];
    
}

- (void)changeServerIP:(UIButton *)button {
    LCChangeIPVC *changeVC = [[LCChangeIPVC alloc] init];
    changeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
