//
//  LCGuidHelpVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/22.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCGuidHelpVC.h"

#import "LCGuidDetailVC.h"

@interface LCGuidHelpVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LCGuidHelpVC

static NSString *guidCell = @"guidCellid";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
//    [self initMainView];
}


#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@[@"功能介绍",
                         @"户主信息采集",
                         @"在线定损",
                         @"离线定损"],
                       @[@"关于邀请码",
                         @"登录注册",
                         @"其他"],
                       @[@"二维码下载",
                         @"更多帮助"]].mutableCopy;
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = TabBGColor;
    }
    return _tableView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:guidCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:guidCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AutoWHGetHeight(44);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCGuidDetailVC *detailVC = [[LCGuidDetailVC alloc] init];
    detailVC.indexPath = indexPath;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//  //消除组头跟随
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (scrollView == _tableView) {
//        CGFloat sectionHeaderHeight = 10.0f;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//        
//    }
//    
//}

-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)initMainView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-49)];
    scrollView.showsVerticalScrollIndicator = NO;
    
    UILabel *label1 = [self creatLabelWithY:AutoWHGetHeight(15) title:@"1、打开益村长，可以看到以下功能：远程定损、信息查询、手机投保、热点资讯。点击按钮就能进入。"];
    UIImageView *imgView1 = [self creatImgViewWithName:@"help1.jpg" Y:NH(label1)+20];
    [scrollView addSubview:label1];
    [scrollView addSubview:imgView1];
    
    UILabel *label2 = [self creatLabelWithY:NH(imgView1)+AutoWHGetHeight(25) title:@"2、进行保险远程定损，需要进行账户注册及登陆。首先在首页点击右下角“我”进入“我的信息”界面，然后点击“请点击登录”进入登陆界面，  "];
    UIImageView *imgView2 = [self creatImgViewWithName:@"help2.jpg" Y:NH(label2)+20];
    [scrollView addSubview:label2];
    [scrollView addSubview:imgView2];
    
    UILabel *label21 = [self creatLabelWithY:NH(imgView2)+AutoWHGetHeight(25) title:@"点击进入“登陆”界面后，点击“注册”按照提示的信息开始注册，注册完账号后按返回键返回登陆界面就可以登陆账号，使用远程定损。"];
    UIImageView *imgView21 = [self creatImgViewWithName:@"help21.png" Y:NH(label21)+20];
    [scrollView addSubview:label21];
    [scrollView addSubview:imgView21];
    
    UILabel *label3 = [self creatLabelWithY:NH(imgView21)+AutoWHGetHeight(25) title:@"3、个人信息中手机姓名及详细住址直接就可以输入进去，地区滚动选取的输入。输入完成后点击保存，将个人信息保存下来。"];
    UIImageView *imgView3 = [self creatImgViewWithName:@"help3.png" Y:NH(label3)+20];
    [scrollView addSubview:label3];
    [scrollView addSubview:imgView3];
    
    UILabel *label4 = [self creatLabelWithY:NH(imgView3)+AutoWHGetHeight(25) title:@"4、需要远程定损时，点击首页中定损按钮，开始向后台发起定损请求"];
    UIImageView *imgView4 = [self creatImgViewWithName:@"help4.jpg" Y:NH(label4)+20];
    UIImageView *imgView41 = [self creatImgViewWithName:@"help41.png" Y:NH(imgView4)+20];
    [scrollView addSubview:label4];
    [scrollView addSubview:imgView4];
    [scrollView addSubview:imgView41];
    
    
    UILabel *label5 = [self creatLabelWithY:NH(imgView41)+AutoWHGetHeight(25) title:@"5、视频联通后将看到以下界面。这个界面中主要包括调节音量的大小、定损结束按钮和拍照按钮（再后台授权拍照给用户后，手机上显示拍照按钮）"];
    UIImageView *imgView5 = [self creatImgViewWithName:@"help5.jpg" Y:NH(label5)+20];
    [scrollView addSubview:label5];
    [scrollView addSubview:imgView5];
    
    UILabel *label6 = [self creatLabelWithY:NH(imgView5)+AutoWHGetHeight(25) title:@"6、可以通过“意见反馈”将使用过程中遇到的问题反馈给我们，我们将会定期把收集一起的问题集中改进，在下一版本解决发现的问题。"];
    UIImageView *imgView6 = [self creatImgViewWithName:@"help6.png" Y:NH(label6)+20];
    [scrollView addSubview:label6];
    [scrollView addSubview:imgView6];
    
    UILabel *label7 = [self creatLabelWithY:NH(imgView6)+AutoWHGetHeight(35) title:@"客服电话：123-123456\n公众号：edingsun\n帮助视频：http://ewanlan.com.ecunzhang\n微信群：34243223"];
    UIImageView *imgView7 = [[UIImageView alloc] initWithFrame:AutoWHCGRectMake(0, NH(label7)+20, 130, 130, YES, YES)];
    CGPoint center = imgView7.center;
    center.x = label7.center.x;
    imgView7.center = center;

    imgView7.image = [UIImage imageNamed:@"erweima"];
    [scrollView addSubview:label7];
    [scrollView addSubview:imgView7];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, NH(imgView7)+20);
    [self.view addSubview:scrollView];
    
    
}

- (UILabel *)creatLabelWithY:(float)y title:(NSString *)titleStr {
    CGFloat height = [LCTools heightWithString:titleStr font:kFontSize16 constrainedToWidth:SCREEN_WIDTH-20];
    UILabel *label = [LCTools createLable:CGRectMake(10, y, SCREEN_WIDTH-20, height) withName:titleStr withFont:kSize16];
    return label;
}

- (UIImageView *)creatImgViewWithName:(NSString *)name Y:(CGFloat)y {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, SCREEN_WIDTH-20, AutoWHGetHeight(246))];
    imgView.image = [UIImage imageNamed:name];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.backgroundColor = [UIColor yellowColor];
    return imgView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
