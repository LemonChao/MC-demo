//
//  LCNonghuInfoVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/5.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCNonghuInfoVC.h"
#import "LCNonghuCell.h"
#import "LCNonghuModel.h"
#import "LCNonghuWebVC.h"
#import "LCPhotoColumnVC.h"
#import "LCGatherListView.h"
#import "LCGatherVC.h"

#define isEndCell (indexPath.row == [self.dataArray[indexPath.section] count])
//@class LCGatherVC;

@interface LCNonghuInfoVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *sectionTitles;

@property(nonatomic, strong) NSMutableArray *houseHoldArray;

@property(nonatomic, strong) NSMutableArray *familyArray;

@property(nonatomic, strong) NSMutableArray *houseArray;

@property(nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *cellid = @"nonghuCell";
static NSString *systemCell = @"systemCell";
static NSString *addCell = @"addCell";


@implementation LCNonghuInfoVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    self.navigationController.delegate = self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatDataSource];
    [self getNetworkingData];
    self.title = self.houseHold.name;
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)creatDataSource {
    self.sectionTitles = @[@"家庭成员",@"房屋信息"];
    self.familyArray = [NSMutableArray array];
    self.houseArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    [self.dataArray addObject:@[self.houseHold]];
    [self.dataArray addObject:self.familyArray];
    [self.dataArray addObject:self.houseArray];
    [self.dataArray addObjectsFromArray:@[@[@"种植信息"],
                                          @[@"养殖信息"],
                                          @[@"我的设备"],
                                          @[@"特产资源"],
                                          @[@"照片"]]];
    
}

- (void)rightBarItemAction {
    
    NSString *message = [NSString stringWithFormat:@"确定删除 %@ 的全部信息", self.houseHold.name];
    
    [LCAlertTools showTipAlertViewWith:self title:nil message:message cancelTitle:@"删除" cancelHandler:^{
        [self deleteHouseHoldNetwork];
    }];
    
}

-(BOOL)navigationShouldPopOnBackButton {
    if (self.superBack) {
        for (UIViewController *subVC in self.navigationController.viewControllers) {
            if ([subVC isKindOfClass:[LCGatherVC class]]) {
                
                [self.navigationController popToViewController:subVC animated:YES];
                break;
            }
        }
        return NO;

    }else {
        return YES;
    }
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = TabBGColor;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoWHGetHeight(80))];;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return [self.dataArray[section] count] + 1;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    }else {
        return 55.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001f;
    }else if(section == 1 || section == 2){
        return 40;
    }else if(section == 3){
        return 20;
    }else {
        return 10;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header;

    if (section == 1) {
        header = [self createSectionHead:@"家庭成员"];
    }else if (section == 2) {
        header = [self createSectionHead:@"房屋信息"];
    }
    
    return header;
}

- (UIView *)createSectionHead:(NSString *)title {
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    
    UILabel *titleLab = [LCTools createLable:title withFont:kFontSize14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [bgview addSubview:titleLab];
    
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgview).offset(10);
        make.centerY.equalTo(bgview);
    }];
    return bgview;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LCNonghuCell *cell = [LCNonghuCell createCellWithTableView:tableView reuseid:cellid];
        [cell setValueWithModel:self.houseHold];
        return cell;
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == [self.dataArray[indexPath.section] count]) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCell];
            }

            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.imageView.image = [UIImage imageNamed:@"gather_addcell"];
            return cell;

        }else {
            
            LCHouseMemberModel *model = self.dataArray[indexPath.section][indexPath.row];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCell];
            }
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.text = model.name;
            
            return cell;

        }
    
    }else if (indexPath.section == 2) {
        
        if (indexPath.row == [self.dataArray[indexPath.section] count]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCell];
            }
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.imageView.image = [UIImage imageNamed:@"gather_addcell"];
            return cell;

        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCell];
            }

            LCHouseInfoModel *model = self.dataArray[indexPath.section][indexPath.row];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.text = model.address;
            CGRect frame = cell.accessoryView.frame;
            NSLog(@"frame%@", NSStringFromCGRect(frame));

            return cell;

        }

    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCell];
        }
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = [_dataArray[indexPath.section] firstObject];
        return cell;

    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        LCNonghuWebVC *webVC = [[LCNonghuWebVC alloc] init];
        webVC.webType = NonghuUpdateHouseHold;
        webVC.houseHoldModel = self.houseHold;
        [self.navigationController pushViewController:webVC animated:YES];

    }else if (indexPath.section == 1) {
        LCNonghuWebVC *webVC = [[LCNonghuWebVC alloc] init];
        if (isEndCell) {
            webVC.webType = NonghuAddHouseMember;
            webVC.houseHoldModel = self.houseHold;
        }else {
            webVC.webType = NonghuUpdateHouseMember;
            webVC.houseMemModel = self.dataArray[indexPath.section][indexPath.row];

        }
        [self.navigationController pushViewController:webVC animated:YES];

    }else if (indexPath.section == 2) {
        LCNonghuWebVC *webVC = [[LCNonghuWebVC alloc] init];
        
        if (isEndCell) {
            webVC.webType = NonghuAddHouseInfo;
            webVC.houseHoldModel = self.houseHold;
        }else {
            webVC.webType = NonghuUpdateHouseInfo;
            webVC.houseInfoModel = self.dataArray[indexPath.section][indexPath.row];
        }
        [self.navigationController pushViewController:webVC animated:YES];

    }else if (indexPath.section == 7) {
        LCPhotoColumnVC *columnVC = [[LCPhotoColumnVC alloc] init];
        LCHouseHoldModel *model = [[LCHouseHoldModel alloc] init];
        model.nhid = self.houseHold.nhid;
        model.name = self.houseHold.name;
        model.address = self.houseHold.address;
        columnVC.houseHold = model;
        [self.navigationController pushViewController:columnVC animated:YES];

    }else {
        LCGatherListView *listVC = [[LCGatherListView alloc] init];
        listVC.title = [_dataArray[indexPath.section] firstObject];
        listVC.listType = indexPath.section - 3;
        listVC.farmerid = [NSString stringWithString:_houseHold.nhid];
        [self.navigationController pushViewController:listVC animated:YES];

    }
    
}
#pragma mark - 刷新

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    //pop返回到此界面
    if (operation == UINavigationControllerOperationPop && [fromVC isKindOfClass:[LCNonghuWebVC class]]) {
        [self getNetworkingData];
    }
    
    //pop离开此界面
    if (operation == UINavigationControllerOperationPop && [fromVC isKindOfClass:[self class]]) {
        self.navigationController.delegate = nil;
    }

    return nil;
}


#pragma mark - NetWork

/** 删除户主信息 */
- (void)deleteHouseHoldNetwork {
    
    NSDictionary *sendDic = @{@"flag" : @"deleteFarmerBasicInfo",
                              @"id" : self.houseHold.nhid};
    @WeakObj(self);
    [LCAFNetWork POST:@"farmerBasicInfo" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if (_refreshBlock) {
            _refreshBlock();
        }
        [selfWeak.navigationController popViewControllerAnimated:YES];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak.view makeToast:[error localizedDescription]];
    }];
}


- (void)getNetworkingData{
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    
    // 将第一个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *sendDic1 = @{@"flag" : @"querycondition",
                                   @"nhId" : self.houseHold.nhid};
        
        [LCAFNetWork POST:@"farmerBasicInfo" params:sendDic1 success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                LCHouseMemberModel *model = [LCHouseMemberModel yy_modelWithDictionary:dic];
                [tempArray addObject:model];
            }
            [self.familyArray setArray:tempArray];
            
            NSLog(@"线程%@",[NSThread currentThread]);
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            DLog(@"%@", error);
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
            
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        
    });
    
    // 将第二个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *sendDic1 = @{@"flag" : @"queryhouse",
                                   @"nhId" : self.houseHold.nhid};
        
        [LCAFNetWork POST:@"farmerBasicInfo" params:sendDic1 success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                LCHouseInfoModel *model = [LCHouseInfoModel yy_modelWithDictionary:dic];
                [tempArray addObject:model];
            }
            [self.houseArray setArray:tempArray];
            
            NSLog(@"线程%@",[NSThread currentThread]);
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            DLog(@"%@", error);
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
            
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"完成了网络请求，不管网络请求失败了还是成功了。");
        NSLog(@"线程%@",[NSThread currentThread]);
        
        [self.tableView reloadData];
    });
}


@end
