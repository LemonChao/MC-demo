//
//  LCPhotoListVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPhotoListVC.h"
#import "GatherPhoto+CoreDataClass.h"
#import "LCPhotoDetailVC.h"
#import "LCNullView.h"


@interface LCPhotoListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, assign) NSInteger dataCount;

@property(nonatomic, strong) LCNullView *nullView;

@end

static NSString *cellid = @"photoListCell";
@implementation LCPhotoListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //本界面不响应这个边缘手势
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //本界面响应这个边缘手势
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"dataCount" options:NSKeyValueObservingOptionNew context:nil];
    
    self.nullView = [[LCNullView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) imgString:@"offline_nodata" labTitleString:@"没有数据哦！"];
    [self.view addSubview:self.nullView];
    [self.view addSubview:self.tableView];
    self.dataCount = self.dataArray.count;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:[GatherPhoto MR_findAll]];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = TabBGColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(BOOL)navigationShouldPopOnBackButton {
    if (self.isFromeGather == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AutoWHGetHeight(60);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    GatherPhoto *gatherPhoto = self.dataArray[indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = gatherPhoto.houseName;
    cell.detailTextLabel.text =gatherPhoto.houseInfo;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCPhotoDetailVC *detailVC = [[LCPhotoDetailVC alloc] init];
    GatherPhoto *gatPhoto = self.dataArray[indexPath.row];
    detailVC.gatherPhoto = gatPhoto;
    detailVC.hidesBottomBarWhenPushed = YES;
    
    @WeakObj(self)
    detailVC.saveBlock = ^(GatherPhoto *gatherPhoto){
        if (gatherPhoto) { //save
            
        }else {//delete
            [selfWeak.dataArray removeObject:gatPhoto];
        }
        
        [selfWeak.tableView reloadData];
        selfWeak.dataCount = selfWeak.dataArray.count;
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"dataCount"]) {
        
        NSInteger result = [[change objectForKey:@"new"] intValue];
        
        self.tableView.hidden = result ? NO : YES;
        
    }
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"dataCount" context:nil];
}

@end
