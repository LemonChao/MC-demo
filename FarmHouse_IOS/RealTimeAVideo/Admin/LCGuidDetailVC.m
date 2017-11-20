//
//  LCGuidDetailVC.m
//  RealTimeAVideo
//
//  Created by sunpeng on 2017/2/28.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCGuidDetailVC.h"

@interface LCGuidDetailVC ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation LCGuidDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.indexPath.section == 0) {
        
        switch (self.indexPath.row) {
            case 0:
            {
                [self creatFundationintroduceView];
            }
                break;
                
            case 1:
            {
                [self gatherInformationView];
            }
                break;
                
            case 2:
            {
                [self createChargeOnlineView];
            }
                break;
                
            case 3:
            {
                [self createOfflineChargeView];
            }
                break;
            default:
                break;
        }

    }else if (self.indexPath.section == 1) {
        
        switch (self.indexPath.row
                ) {
            case 0:
            {
                [self createAboutInviteView];
            }
                break;
                
            case 1:
            {
                [self createLoginRegistView];
            }
                break;
                
            case 2:
            {
                [self createOthersView];
            }
                break;
                
            default:
                break;
        }

    }else if (self.indexPath.section == 2){
        
        if (self.indexPath.row == 0) {
            
            [self createErCodeView];
        }
        else if (self.indexPath.row == 1) {
            
            [self createWebHelp];
            
        }
        
    }
    
    
    
    
}

static NSInteger margin = 10.0f;

// 功能介绍
- (void)creatFundationintroduceView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:containerView];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(scrollView);
    }];
    
    UILabel *titleLab1 = [LCTools createLable:@"1 首页" withFont:kFontSizeBold15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    titleLab1.numberOfLines = 1;
    [containerView addSubview:titleLab1];
    [titleLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(margin);
        make.left.equalTo(containerView).offset(5);
    }];
    
    UILabel *desLab1 = [LCTools createLable:@"易村长首页包括如下： 政策宣传区功能区和热点农讯区；使用功能区时，用户必须先进行注册才能使用呦！" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab1];
    [desLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_1" ofType:@"jpg"]];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView1];
    [imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView1.width).multipliedBy(0.89);// 高/宽 == 0.6
    }];
    
    
    UILabel *titleLab2 = [LCTools createLable:@"2 我的界面" withFont:kFontSizeBold15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    titleLab2.numberOfLines = 1;
    [containerView addSubview:titleLab2];
    [titleLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView1.bottom).offset(margin*2);
        make.left.equalTo(containerView).offset(5);
    }];
    
    UILabel *desLab2 = [LCTools createLable:@"使用该软件前，请先登录\n点击“个人信息”可补充完善账户信息。\n点击“户主管理”可进行户主添加等。\n点击“离线数据”可以获取之前存储的或者已经上传的，在没有网络的情况下自己拍摄的图片和户主信息等。\n点击“我的消息”可以获取由农政部门等发送的政策等内容。" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab2];
    [desLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView2 = [[UIImageView alloc] init];
    imgView2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_8" ofType:@"png"]];
    imgView2.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView2];
    [imgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView2.width).multipliedBy(0.89);// 高/宽 == 0.6
        make.bottom.equalTo(containerView.bottom).offset(-margin);
    }];

    
}

// 采集信息
- (void)gatherInformationView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:containerView];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(scrollView);
    }];

    UILabel *desLab1 = [LCTools createLable:@"点击“采集”开始采集农户基本信息" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab1];
    [desLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_6" ofType:@"png"]];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView1];
    [imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView1.width).multipliedBy(0.89);// 高/宽 == 0.6
    }];

    
    UILabel *desLab2 = [LCTools createLable:@"也可以在“我的”界面点击“户主管理”，然后点击添加，进行户主信息的添加。" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab2];
    [desLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView2 = [[UIImageView alloc] init];
    imgView2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_11" ofType:@"png"]];
    imgView2.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView2];
    [imgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView2.width).multipliedBy(0.89);// 高/宽 == 0.6
        make.bottom.equalTo(containerView.bottom).offset(-margin);
    }];

    
    
}


// 在线定损
- (void)createChargeOnlineView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:containerView];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(scrollView);
    }];
    
    UILabel *desLab1 = [LCTools createLable:@"户主查勘分为在线定损和离线定损，在线定损首先需要用户登录自己的账户，并且用户必须是协保员" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab1];
    [desLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_2" ofType:@"png"]];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView1];
    [imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView1.width).multipliedBy(1.66);
    }];
    
    
    UILabel *desLab2 = [LCTools createLable:@"协保员登录后，点击右上角“点此登录”，登录成功后“定损”，首先进行定损且未采集保户信息需按以下图示采集保户信息" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab2];
    [desLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView2 = [[UIImageView alloc] init];
    imgView2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_3" ofType:@"png"]];
    imgView2.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView2];
    [imgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView2.width).multipliedBy(1.66);// 高/宽 == 0.6
    }];
    
    UILabel *desLab3 = [LCTools createLable:@"添加完保户后选择户主发起定损" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab3];
    [desLab3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView3 = [[UIImageView alloc] init];
    imgView3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_4" ofType:@"png"]];
    imgView3.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView3];
    [imgView3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab3.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView3.width).multipliedBy(0.89);// 高/宽 == 0.6
    }];

    UILabel *desLab4 = [LCTools createLable:@"视频连通后看到以下界面。包括音量调节按钮、定损结束按钮和拍照按钮（在后台授权拍照给用户后，手机上显示拍照按钮）" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab4];
    [desLab4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView3.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView4 = [[UIImageView alloc] init];
    imgView4.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_5" ofType:@"jpg"]];
    imgView4.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView4];
    [imgView4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab4.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView4.width).multipliedBy(0.89);// 高/宽 == 0.6
        make.bottom.equalTo(containerView).offset(-margin);
    }];

    

}

// 离线定损
- (void)createOfflineChargeView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:containerView];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(scrollView);
    }];
    
    UILabel *desLab1 = [LCTools createLable:@"离线定损中的房主，必须是正确的，便于在有网络的状态下匹配您的户主信息。拍照结束后保存您的离线信息" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab1];
    [desLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_12" ofType:@"png"]];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView1];
    [imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView1.width).multipliedBy(0.89);// 高/宽 == 0.6
    }];
    
    
    UILabel *desLab2 = [LCTools createLable:@"离线数据在有网络的情况下，通过点击“我的”界面中“离线数据”进入离线数据的上传和查看已上传的离线数据。在未上传列表中户主可以查看之前拍摄的图片或者继续拍摄进行数据的上传。在已上传列表中可以查看上传的图片数据" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab2];
    [desLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView2 = [[UIImageView alloc] init];
    imgView2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_13" ofType:@"png"]];
    imgView2.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView2];
    [imgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView2.width).multipliedBy(0.89);// 高/宽 == 0.6
        make.bottom.equalTo(containerView).offset(-margin);
    }];

}

// 邀请码
- (void)createAboutInviteView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:containerView];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(scrollView);
    }];
    
    UILabel *titleLab1 = [LCTools createLable:@"关于邀请码" withFont:kFontSizeBold15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    titleLab1.numberOfLines = 1;
    [containerView addSubview:titleLab1];
    [titleLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(margin);
        make.left.equalTo(containerView).offset(5);
    }];
    
    UILabel *desLab1 = [LCTools createLable:@"  1.六位数字或字母的组合，有管理员在后台生成，统一管理；\n\n  2.没有邀请码只能注册为一般用户，一般用户没有定损权限；\n\n  3.用户想成为协保员，需要加入微信易村长培训群，向群管理员索要邀请码；\n\n  4.正确的邀请码可以使得用户直接具有协保员身份；\n\n  5.一般用户也可以通过输入邀请码的方式升级为协保员；\n\n  6.邀请码与地区绑定，具有时间限制，输入过期的邀请码无效。" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab1];
    [desLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(desLab1.bottom).offset(-margin*2);
    }];

}


// 登录注册
- (void)createLoginRegistView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:containerView];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(scrollView);
    }];
    
    UILabel *desLab1 = [LCTools createLable:@"在“我”界面中点击“请点击登录”，可以进入用户登录界面" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab1];
    [desLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView1 = [[UIImageView alloc] init];
    imgView1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_15" ofType:@"png"]];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView1];
    [imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView1.width).multipliedBy(0.89);// 高/宽 == 0.6
    }];
    
    
    UILabel *desLab2 = [LCTools createLable:@"如果您暂时没有账号，可以点击登录界面“注册”按钮进行注册" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab2];
    [desLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView2 = [[UIImageView alloc] init];
    imgView2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_14" ofType:@"png"]];
    imgView2.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView2];
    [imgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView2.width).multipliedBy(0.89);// 高/宽 == 0.6
        make.bottom.equalTo(containerView).offset(-margin);
    }];

}

// 其他
- (void)createOthersView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    [scrollView addSubview:containerView];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(scrollView);
    }];
    
    UILabel *titleLab1 = [LCTools createLable:@"1 查询" withFont:kFontSizeBold15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    titleLab1.numberOfLines = 1;
    [containerView addSubview:titleLab1];
    [titleLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(margin);
        make.left.equalTo(containerView).offset(5);
    }];
    
    UILabel *desLab1 = [LCTools createLable:@"查询赔付情况及进度（功能开发中）" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab1];
    [desLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UILabel *titleLab2 = [LCTools createLable:@"2 通知" withFont:kFontSizeBold15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    titleLab2.numberOfLines = 1;
    [containerView addSubview:titleLab2];
    [titleLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab1.bottom).offset(margin);
        make.left.equalTo(containerView).offset(5);
    }];
    
    UILabel *desLab2 = [LCTools createLable:@"查看发布的消息和通知" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab2];
    [desLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UILabel *titleLab3 = [LCTools createLable:@"3 我的信息" withFont:kFontSizeBold15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    titleLab3.numberOfLines = 1;
    [containerView addSubview:titleLab3];
    [titleLab3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab2.bottom).offset(margin);
        make.left.equalTo(containerView).offset(5);
    }];
    
    
    UIImageView *imgView3 = [[UIImageView alloc] init];
    imgView3.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_7" ofType:@"png"]];
    imgView3.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView3];
    [imgView3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab3.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView3.width).multipliedBy(0.89);// 高/宽 == 0.6
    }];


    UILabel *titleLab4 = [LCTools createLable:@"4 户主管理" withFont:kFontSizeBold15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    titleLab4.numberOfLines = 1;
    [containerView addSubview:titleLab4];
    [titleLab4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView3.bottom).offset(margin);
        make.left.equalTo(containerView).offset(5);
    }];
    
    UILabel *desLab4 = [LCTools createLable:@"查看发布的消息和通知" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab4];
    [desLab4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab4.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView4 = [[UIImageView alloc] init];
    imgView4.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_9" ofType:@"png"]];
    imgView4.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView4];
    [imgView4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab4.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView4.width).multipliedBy(0.89);// 高/宽 == 0.6
    }];
    


    UILabel *titleLab5 = [LCTools createLable:@"5 意见反馈" withFont:kFontSizeBold15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    titleLab5.numberOfLines = 1;
    [containerView addSubview:titleLab5];
    [titleLab5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView4.bottom).offset(margin);
        make.left.equalTo(containerView).offset(5);
    }];
    
    UILabel *desLab5 = [LCTools createLable:@"可将使用过程中遇到的问题反馈给我们" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab5];
    [desLab5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab5.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];
    
    UIImageView *imgView5 = [[UIImageView alloc] init];
    imgView5.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_10" ofType:@"png"]];
    imgView5.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView5];
    [imgView5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab5.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
        make.height.equalTo(imgView5.width).multipliedBy(0.89);// 高/宽 == 0.6
    }];

    UILabel *desLab6 = [LCTools createLable:@"客服电话：010-62119330\n公 众 号 ：" withFont:kFontSize15 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [containerView addSubview:desLab6];
    [desLab6 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView5.bottom).offset(margin);
        make.left.equalTo(containerView).offset(margin);
        make.right.equalTo(containerView).offset(-margin);
    }];

    UIImageView *imgView6 = [[UIImageView alloc] init];
    imgView6.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"erweima@2x" ofType:@"png"]];
    imgView6.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:imgView6];
    [imgView6 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLab6.bottom).offset(margin);
        make.left.equalTo(containerView).offset(AutoWHGetWidth(100));
        make.right.equalTo(containerView).offset(-AutoWHGetWidth(100));
        make.height.equalTo(imgView6.width).multipliedBy(1);// 高/宽 == 0.6
        make.bottom.equalTo(containerView).offset(-margin);
        
    }];


}

// 二维码
- (void)createErCodeView {
    
    UIButton *button = [LCTools createWordButton:UIButtonTypeCustom title:@"双击下载本应用" titleColor:MainColor font:kFontSize15 bgColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(jumpToAppStore:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.view addSubview:button];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY);
        make.size.equalTo(CGSizeMake(SCREEN_WIDTH, AutoWHGetHeight(40)));
    }];
    
    
}

- (void)jumpToAppStore:(UIButton *)button {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%98%93%E6%9D%91%E9%95%BF/id1190181466?mt=8"]];
}


// webView
- (void)createWebHelp {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    webView.delegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@help/index.jsp", [ActivityApp shareActivityApp].baseURL];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
}

-(BOOL)navigationShouldPopOnBackButton {
    
    if (_webView != nil && [_webView canGoBack]) {
        [_webView goBack];
        return NO;
    }
    
    return YES;
}



- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view makeToastActivity];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view hideToastActivity];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view hideToastActivity];
    
    [self.view makeToast:[error localizedDescription]];
}


@end
