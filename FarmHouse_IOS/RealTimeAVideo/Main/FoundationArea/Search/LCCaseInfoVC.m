//
//  LCCaseInfoVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCCaseInfoVC.h"
#import "StepProgressView.h"
#import "LCSearchInfoCell.h"
#import "LCPictureInfoVC.h"
#import "LCDisasterVC.h"
#import "LCHouseholdInforVC.h"
#import "LCCaseFlowViewController.h"


@interface LCCaseInfoVC ()<UITableViewDelegate,UITableViewDataSource,InfoCellDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) LCDisasterModel *model;

@end
static NSString *normalCell = @"normalCell";
static NSString *seaCellID  = @"searchInfoCell";
@implementation LCCaseInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestNetWork];
    self.title = @"案件信息";
    [self.view addSubview:self.tableView];
}

//设置左边按键
- (UIButton*)set_leftButton {
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"back_64"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"back_64"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
- (void)left_button_event:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        LCSearchHeader *head = [[LCSearchHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _tableView.tableHeaderView = head;
        [head setValueWithModel:self.seaModel];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [tableView setSeparatorInset:UIEdgeInsetsZero];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = @"保护信息";
        }
        return cell;
    }
    else if (indexPath.row == 1) {
        LCSearchInfoCell *cell = [LCSearchInfoCell creatWithTableView:tableView reuseidentifier:seaCellID];
        cell.delegate = self;
        [cell setValueWithModel:self.model];
        
        @WeakObj(self);
        cell.picBtnBlock = ^(){
            LCPictureInfoVC *pictureVC = [[LCPictureInfoVC alloc]init];
            pictureVC.model = selfWeak.seaModel;
            pictureVC.hidesBottomBarWhenPushed = YES;
            [selfWeak.navigationController pushViewController:pictureVC  animated:YES];
        };
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [tableView setSeparatorInset:UIEdgeInsetsZero];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = @"案件跟进";
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 210;
    }
    else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LCHouseholdInforVC *houseInforVC = [LCHouseholdInforVC new];
        houseInforVC.seaModel = _seaModel;
        [self.navigationController pushViewController:houseInforVC animated:YES];
    }else if(indexPath.row == 2){
        LCCaseFlowViewController *caseflow = [LCCaseFlowViewController new];
        caseflow.model = _seaModel;
        [self.navigationController pushViewController:caseflow animated:YES];
    }else{
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)infoCell:(LCSearchInfoCell *)cell topEditButtonClick:(UIButton *)button {
    DLog(@"Top button");
    
    LCDisasterVC *disasterVC = [[LCDisasterVC alloc] init];
    disasterVC.model = self.seaModel;
    disasterVC.type = VCTypeDisaster;
    @WeakObj(self)
    disasterVC.popBlock = ^() {
        [selfWeak requestNetWork];
    };
    [self.navigationController pushViewController:disasterVC animated:YES];
    
}


- (void)infoCell:(LCSearchInfoCell *)cell bottomEditButtonClick:(UIButton *)button {
    DLog(@"Bottom Button");
    
    LCDisasterVC *disasterVC = [[LCDisasterVC alloc] init];
    disasterVC.model = self.seaModel;
    disasterVC.type = VCTypeRelief;
    @WeakObj(self)
    disasterVC.popBlock = ^() {
        [selfWeak requestNetWork];
    };
    [self.navigationController pushViewController:disasterVC animated:YES];

}

#pragma mark - Network 

- (void)requestNetWork {
    NSDictionary *sendDic = @{@"flag":@"GetDisasterRelief",
                              @"reportid":self.seaModel.caseid};
    
    [LCAFNetWork POST:@"report" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[STATE] integerValue] == 1) {
            [self convertIntoModelWithData:responseObject isload:NO];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)convertIntoModelWithData:(id)reponse isload:(BOOL)isload {
//    LCDisasterModel *disasterModel = [[LCDisasterModel alloc] init];
    LCDisasterModel *disasterModel = [LCDisasterModel yy_modelWithDictionary:reponse[DATA]];
    
    self.model = disasterModel;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}


@end
