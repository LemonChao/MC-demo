//
//  MyViewController.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/11.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "MyViewController.h"
#import "UITableView+EXT.h"
#import "LCLonginVC.h"
#import "LCUserInfoVC.h"
#import "LCFeedBackVC.h" 
#import "LCAboutUSVC.h"
#import "LCGuidHelpVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "LCUNuploadDetailVC.h"
#import "LCMyNewsVC.h" //my news
#import "LCNotificationVC.h" //通知消息
//#import "MyAccessoryView.h" cell 小红点 AccessoryView
#import "OfflineModel+CoreDataProperties.h" //查询数据库，未上传个数
#import "LCWalletVC.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSDictionary *infoDic;
//    NSString * accessoryTitle;
}
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *UserBgView;
@property (strong, nonatomic) UIButton *LoginBtn;
@property (strong, nonatomic) UILabel *userNameLab;
@property (strong, nonatomic) UIImageView *userPhotoImg;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imgArray;

@end

static NSString *myCellID = @"myCell";

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isLogin = NO;
    self.navigationItem.title = @"我";

    self.dataArray = @[@[@"我的钱包",
                         @"我的消息",],
                       @[@"使用帮助",
                         @"意见反馈",
                         @"关于我们"]
                       ];
    self.imgArray = @[@[@"icon_wallet",
                        @"icon_message"],
                      @[@"icon_answer",
                        @"icon_opinion",
                        @"icon_excla"]];
    [self.view addSubview:self.myTableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLoginToRefreshUI) name:@"checkLoginToRefreshUI" object:nil];
}

#pragma mark -- user authentication
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self checkLoginToRefreshUI];
//    [self setAccessoryTitle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoWHGetHeight(128))];
        _headerView.backgroundColor = MainColor;
        NSString *imgUrl;
        if (infoDic != nil) {
            imgUrl = StrFormat(@"%@%@", [ActivityApp shareActivityApp].baseURL, infoDic[@"headurl"]);
        }
        self.userPhotoImg = [LCTools createImageView:[NSURL URLWithString:imgUrl] placeHolder:[UIImage imageNamed:@"head"] cornerRadius:AutoWHGetWidth(64)/2];
        [_headerView addSubview:_userPhotoImg];
        [self.userPhotoImg makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView).offset(25);
            make.size.equalTo(AutoWHGetWidth(64));
        }];
        
        //loginbtn
        self.LoginBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"请先登录" titleColor:[UIColor whiteColor] font:kFontSize20 bgColor:MainColor];
        _LoginBtn.hidden = YES;
        [_LoginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_LoginBtn];
        [_LoginBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_userPhotoImg);
            make.left.equalTo(_userPhotoImg.right).offset(13);
        }];
        
        //bgview
        self.UserBgView = [[UIView alloc] init];
        _UserBgView.backgroundColor = MainColor;
        [_headerView addSubview:_UserBgView];
        [_UserBgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_userPhotoImg);
            make.left.equalTo(_userPhotoImg.right).offset(13);
            make.size.equalTo(CGSizeMake(165, 100));
        }];
        
        //namelab
        self.userNameLab = [[UILabel alloc] init];
        _userNameLab.font = kFontSize17;
        _userNameLab.textColor = [UIColor whiteColor];
        [_UserBgView addSubview:_userNameLab];
        [_userNameLab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_UserBgView).offset(-8);
            make.left.equalTo(_UserBgView);
        }];
        
        //button
        UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [infoBtn setTitle:@"个人信息 >" forState:UIControlStateNormal];
        [infoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        infoBtn.titleLabel.font = kFontSize12;
        infoBtn.backgroundColor = MainColor;
        [infoBtn addTarget:self action:@selector(userInfoClick:) forControlEvents:UIControlEventTouchUpInside];
        [_UserBgView addSubview:infoBtn];
        [infoBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_UserBgView);
            make.top.equalTo(_userNameLab.bottom);
        }];

        
    }
    return _headerView;
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-49) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.4);
        _myTableView.tableHeaderView = self.headerView;
        _myTableView.tableFooterView = [UIView new];
        [_myTableView cellEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    }
    return _myTableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    if (!myCell) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellID];
    }
    
//    if (indexPath.section == 0 && indexPath.row == 1) {
//        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        MyAccessoryView *acceView = [[MyAccessoryView alloc] init];//WithFrame:CGRectMake(0, 0, 50, 30)
//        acceView.title = accessoryTitle;
//        myCell.accessoryView = acceView;
//    }
    myCell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    myCell.textLabel.font = [UIFont systemFontOfSize:15];
    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myCell.imageView.image = [UIImage imageNamed:self.imgArray[indexPath.section][indexPath.row]];
    
    return myCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController;
    if (indexPath.section ==0) {
        
        //1.检查是否登陆
        BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN];
        
        if (!result) {
            
            [LCAlertTools showTipAlertViewWith:self title:@"提示" message:@"您还没有登录, 请先登录！" cancelTitle:@"确定" cancelHandler:^{
                LCLonginVC *loginVC = [[LCLonginVC alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }];
            return;
        }

        switch (indexPath.row) {
            case 0: //wallet
            {
                LCWalletVC *myNews = [[LCWalletVC alloc] init];
                viewController = myNews;
            }
                break;
            case 1: //my news
            {
//                LCMyNewsVC *myNews = [[LCMyNewsVC alloc] init];
//                viewController = myNews;
                LCNotificationVC *notificateNews = [[LCNotificationVC alloc] init];
                viewController = notificateNews;
            }
                break;
                
            default:
                break;
        }
        
    }else {
        switch (indexPath.row) {
            case 0: //guild
            {
                LCGuidHelpVC *helpVC = [[LCGuidHelpVC alloc] init];
                viewController = helpVC;
            }
                break;
                
            case 1: //feedback
            {
                LCFeedBackVC *feedBackVC = [[LCFeedBackVC alloc] init];
                viewController = feedBackVC;
            }
                break;
            case 2: //about us
            {
//                [self checkVersion];
                LCAboutUSVC *aboutVC = [[LCAboutUSVC alloc] init];
                viewController = aboutVC;
            }
                break;
            default:
                break;
        }
        
    }
    if (!viewController) return;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = self.navigationItem.title;
    self.navigationItem.backBarButtonItem = backItem;
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.navigationItem.title = self.dataArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
        
}



- (void)loginBtnClick:(id)sender {
    
    LCLonginVC *loginVC = [[LCLonginVC alloc] init];
//    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
//    back.title = @"";
//    self.navigationItem.backBarButtonItem = back;
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (void)userInfoClick:(id)sender {
//    self.isLogin = NO;
    LCUserInfoVC *userInfo = [[LCUserInfoVC alloc] init];
    userInfo.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    [self.navigationController pushViewController:userInfo animated:YES];
}

// tabBar 小红点
//- (void)setAccessoryTitle {
//    //获取未上传的数据
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpload == 0"];
//    NSArray *offlinemodelArray = [NSMutableArray arrayWithArray:[OfflineModel MR_findAllWithPredicate:predicate]];
//    accessoryTitle = offlinemodelArray.count ? [NSString stringWithFormat:@"%ld", offlinemodelArray.count] : nil;
//    [self.navigationController.tabBarItem setBadgeValue:accessoryTitle];
//
//    [self.myTableView reloadData];
//}

#pragma mark - netWork

- (void)checkVersion {
    NSDictionary *sendDic = @{@"flag":@"CheckVersion",
                              @"version":AppBuildVersion};
    
    DLog(@"sendDic%@",sendDic);
    [LCAFNetWork POST:@"update" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if ([[responseObject objectForKey:@"state"] intValue]) {
//            [LCTools showAlert:[responseObject objectForKey:@"message"]];
        }else {
//            [LCTools showAlert:[responseObject objectForKey:@"message"]];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
    }];
}

/** receive notification to called */
- (void)checkLoginToRefreshUI {
    if ([UDSobjectForKey(ISLOGIN) intValue]) { //login [UDSobjectForKey(ISLOGIN) intValue]
        infoDic = UDSobjectForKey(USERINFO);
        self.LoginBtn.hidden = YES;
        self.UserBgView.hidden = NO;
        self.userNameLab.text = infoDic[@"name"];//infoDic[@"name"];
        NSString *imgurl = StrFormat(@"%@%@", [ActivityApp shareActivityApp].baseURL, infoDic[@"headurl"]);
        [self.userPhotoImg sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"head"]];
    }else {
        self.LoginBtn.hidden = NO;
        self.UserBgView.hidden = YES;
        [self.userPhotoImg setImage:[UIImage imageNamed:@"head"]];
    }
    [self headerViewRefreshUI];
    DLog(@"%@", UDSobjectForKey(ISLOGIN));
}

- (void)headerViewRefreshUI {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    printf("%s",[[NSString stringWithFormat:@"---receive by %@ --\n"@"object = %@, path = %@\n"@"change = %@\n", self, object, keyPath, change] UTF8String]);
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"checkLoginToRefreshUI" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
