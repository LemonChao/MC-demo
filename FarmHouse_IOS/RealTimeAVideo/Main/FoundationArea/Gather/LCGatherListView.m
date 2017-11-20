//
//  LCGatherListView.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/17.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCGatherListView.h"
#import "LCCropModel.h"
#import "LCGatherWebVC.h"


@interface LCGatherListView ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LCGatherListView

static NSString *systemCell = @"systemCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestNetwork];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(rightAddItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = TabBGColor;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:systemCell];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCell];
    LCCropModel *model = self.dataArray[indexPath.row];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.varieties ? model.varieties: model.name;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    LCGatherWebVC *webVC = [[LCGatherWebVC alloc] init];
    webVC.webType = self.listType;
    webVC.operationType = GatherWebOperationUpdate;
    webVC.cropModel = self.dataArray[indexPath.row];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
    @WeakObj(self);
    webVC.backRefresh = ^(){
        [selfWeak requestNetwork];
    };

    
}

- (void)rightAddItemAction {
    LCCropModel *model = [[LCCropModel alloc] init];
    model.farmerid = _farmerid;
    
    LCGatherWebVC *webVC = [[LCGatherWebVC alloc] init];
    webVC.webType = self.listType;
    webVC.operationType = GatherWebOperationAdd;
    webVC.cropModel = model;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
    @WeakObj(self);
    webVC.backRefresh = ^(){
        [selfWeak requestNetwork];
    };
    
}


#pragma mark - NetWork

- (void)requestNetwork {
    NSDictionary *sendDic;
    
    switch (_listType) {
        case GatherWebTypePlant:
        {
            sendDic = @{@"flag":@"queryplant",
                        @"farmerid":_farmerid};
        }
            break;
            
        case GatherWebTypeFarming:
        {
            sendDic = @{@"flag":@"queryfarming",
                        @"farmerid":_farmerid};
        }
            break;
            
        case GatherWebTypeSpecial:
        {
            sendDic = @{@"flag":@"queryspecialty",
                        @"farmerid":_farmerid};
        }
            break;
            
        case GatherWebTypeEquipment:
        {
            sendDic = @{@"flag":@"queryequipment",
                        @"farmerid":_farmerid};
        }
            break;
            
        default://error
            break;
    }
    [self.view makeToastActivity];
    
    @WeakObj(self);
    [LCAFNetWork POST:@"collect" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [selfWeak.view hideToastActivity];
        
        if ([responseObject[STATE] intValue] == 1) {
            
            [selfWeak convertModelWithData:responseObject];
            
        }else {
            [selfWeak.view makeToast:responseObject[MESSAGE]];
        }
 
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [selfWeak.view hideToastActivity];
        [selfWeak.view makeToast:[error localizedDescription]];
    }];
    
}

- (void)convertModelWithData:(id) response {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *dic in response[DATA]) {
        LCCropModel *model = [LCCropModel yy_modelWithDictionary:dic];
        [tempArray addObject:model];
    }
    
    [self.dataArray setArray:tempArray];
    
    [self.view configBlankPage:EaseBlankPageTypeNoButton hasData:self.dataArray.count hasError:(self.dataArray.count>0) reloadButtonBlock:nil];
    
    [_tableView reloadData];
}

@end
