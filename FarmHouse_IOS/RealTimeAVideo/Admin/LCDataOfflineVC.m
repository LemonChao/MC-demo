//
//  LCDataOfflineVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/20.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCDataOfflineVC.h"
#import "LCTabbarView.h"
#import "LCBaseNavController.h"
#import "LCUNuploadDetailVC.h"
#import "LCUploadDetailVC.h"
#import "OfflineModel+CoreDataClass.h"
#import "LCNullView.h"
#import "MainViewController.h"
#import "LCOfflineModel.h"

@interface LCDataOfflineVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *userid; //自动上传协保员id
}
@property(nonatomic, strong) LCTabbarView *tabBarView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableView *uploadTabView;
//@property(nonatomic, strong) LCNullView *nullViewL;
//@property(nonatomic, strong) LCNullView *nullViewR;

@property(nonatomic, strong) NSMutableArray *UNuploadArr;
@property(nonatomic, strong) NSMutableArray *UploadArr;

@property(nonatomic, assign) NSInteger unloadCout;
@property(nonatomic, assign) NSInteger uploadCout;

@end

@implementation LCDataOfflineVC
static NSString *cellID = @"UploadedCellID";
static NSString *cellIDUN = @"UNuloadedCellID";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"uploadCout" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"unloadCout" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self setDataArray];

    [self.view addSubview:self.tabBarView];
    
    
    [self autoUploadCases];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSInteger result = [[change objectForKey:@"new"] intValue];

    if ([keyPath isEqualToString:@"uploadCout"]) {//已上传
        NSLog(@"%ld-------%@", self.uploadCout, change);
        self.uploadTabView.hidden = result ? NO : YES;
    }
    
    if ([keyPath isEqualToString:@"unloadCout"]) {//未上传
        NSLog(@"%ld-------%@", self.unloadCout, change);
        self.tableView.hidden = result ? NO : YES;
    }
    
}

-(BOOL)navigationShouldPopOnBackButton {
    if (self.isFromeOffline) { //从离线定损进入
//        [self superBack];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }else {
        return YES;
    }
    
}

- (void)superBack {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        DLog(@"%@", [viewController class]);
        if ([viewController.class isSubclassOfClass:[MainViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
        
    }
}

#pragma mark - 懒加载
- (LCTabbarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = ({
            LCTabbarView *tabBarView = [[LCTabbarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
            
            [tabBarView addSubItemWithView:self.tableView title:@"未上传"];

            [tabBarView addSubItemWithView:self.uploadTabView title:@"已上传"];
            
            tabBarView;
        });
    }
    return _tabBarView;
}

- (NSMutableArray *)UNuploadArr {
    if (!_UNuploadArr) {
        _UNuploadArr = [NSMutableArray array];
    }
    return _UNuploadArr;
}

- (NSMutableArray *)UploadArr {
    if (!_UploadArr) {
        _UploadArr = [NSMutableArray array];
    }
    return _UploadArr;
}
/** 未上传 */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, SCREEN_HIGHT-64-40.5) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
/** 已上传 */
- (UITableView *)uploadTabView {
    if (!_uploadTabView) {
        _uploadTabView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0.5, SCREEN_WIDTH, SCREEN_HIGHT-64-40.5) style:UITableViewStylePlain];
        _uploadTabView.dataSource = self;
        _uploadTabView.delegate = self;
        _uploadTabView.tableFooterView = [UIView new];
    }
    return _uploadTabView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _uploadTabView) {
        return self.UploadArr.count;
    }else {
        return self.UNuploadArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _uploadTabView) {
        
        OfflineModel *model = self.UploadArr[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.textLabel.text = model.farmerName ? model.farmerName : @"户主姓名未知";
        cell.detailTextLabel.text = model.houseInfo;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }

        return cell;

    }else {
        OfflineModel *model = self.UNuploadArr[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDUN];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIDUN];
            
        }
        cell.textLabel.text = model.farmerName ? model.farmerName : @"户主姓名未知";
        cell.detailTextLabel.text = model.houseInfo;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }

        return cell;

    }
    
    
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AutoWHGetHeight(52);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self)weakSelf = self;
    if (tableView == _uploadTabView) {
        OfflineModel *model = self.UploadArr[indexPath.row];
        
        LCUploadDetailVC *uploadVC = [[LCUploadDetailVC alloc] init];
        uploadVC.model = model;
        uploadVC.upBlock = ^(OfflineModel *upModel){
            [weakSelf.UploadArr removeObject:model];
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        };
        
        [self.navigationController pushViewController:uploadVC animated:YES];
    }else {
        OfflineModel *model = self.UNuploadArr[indexPath.row];

        LCUNuploadDetailVC *detailVC = [[LCUNuploadDetailVC alloc] init];
        detailVC.model = model;
        detailVC.index = indexPath.row;
        
        detailVC.uploadBlock = ^(OfflineModel *upModel){
            upModel.isUpload = YES;
            [weakSelf.UNuploadArr removeObject:upModel];
            [weakSelf.UploadArr addObject:upModel];
            [weakSelf performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        };
        
        detailVC.saveBlock = ^(OfflineModel *editedModel) {
            if (editedModel) {
                [weakSelf.UNuploadArr replaceObjectAtIndex:indexPath.row withObject:editedModel];
            } else {
                [weakSelf.UNuploadArr removeObject:model];
            }
            [weakSelf performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

//- (void)reloadUpTableView{
//    self.unloadCout = self.UNuploadArr.count;
//    self.uploadCout =  self.UploadArr.count;
//
//    [self.uploadTabView reloadData];
//}

- (void)reloadTableView{
    self.unloadCout = self.UNuploadArr.count;
    self.uploadCout =  self.UploadArr.count;
    
    [self.tableView reloadData];
    [self.uploadTabView reloadData];
}


- (void)setDataArray {
    //获取未上传的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpload == 0"];
    NSArray *offlinemodelArray = [NSMutableArray arrayWithArray:[OfflineModel MR_findAllWithPredicate:predicate]];
    [offlinemodelArray enumerateObjectsUsingBlock:^(OfflineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"bbbbb  %d", model.autoUpdate);
    }];
    
    self.UNuploadArr = [offlinemodelArray mutableCopy];
    self.unloadCout = self.UNuploadArr.count;
    //获取已上传的数据
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"isUpload == 1"];
    NSArray *uploadmodelArray = [NSMutableArray arrayWithArray:[OfflineModel MR_findAllWithPredicate:predicate1]];
    NSLog(@"已上传 %ld", uploadmodelArray.count);
    self.UploadArr = [uploadmodelArray mutableCopy];
    self.uploadCout =  self.UploadArr.count;
}


- (void)asyncSerialQueue {
    NSLog(@"%s", __FUNCTION__);

    // 1.创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("cn.uploadOfflineModel.queue", NULL);
    
    // 2.将任务添加到串行队列中 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
}


/** 自动上传案件 */
- (void)autoUploadCases {
    
    NSLog(@"%s", __FUNCTION__);

    if (UDSobjectForKey(ISLOGIN) == NO) return;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isUpload == 0 && autoUpdate == 1"];
    NSArray *offlinemodelArray = [NSMutableArray arrayWithArray:[OfflineModel MR_findAllWithPredicate:predicate]];
    
    @WeakObj(self);
    [offlinemodelArray enumerateObjectsUsingBlock:^(OfflineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 1.创建一个串行队列
        dispatch_queue_t queue = dispatch_queue_create("cn.uploadOfflineModel.queue", NULL);

        // 2.将任务添加到串行队列中 异步 执行
        dispatch_async(queue, ^{
            [selfWeak CompressedToZipWithModel:model];
        });
        
    }];
    
}

- (void)CompressedToZipWithModel:(OfflineModel *)offlineModel {
//    NSString *cachePath1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) firstObject];
    NSString *cachePath = [SandBoxManager creatPathUnderCaches:@"/OfflineImg"];
    //目标路径[
    NSString *zipFilePath = [NSString stringWithFormat:@"%@/%@.zip",cachePath, offlineModel.reserveOne];
    
    
    //转化txt文本
    NSMutableArray *txtZipArray = @[].mutableCopy;
    for (LCOfflineImgModel *texImageModel in (NSArray*)offlineModel.offlineArray) {
        
        [SandBoxManager writeToDirectory:[SandBoxManager creatPathUnderCaches:@"/OfflineImg"]
                               WithImage:texImageModel.image
                               imageName:[texImageModel.filePath componentsSeparatedByString:@"."].firstObject
                                 imgType:@"jpg"];
        
        //文本存储
        NSString *titleStr = [[texImageModel.filePath componentsSeparatedByString:@"."] firstObject];
        NSString *txtPath = [NSString stringWithFormat:@"%@/%@.txt", cachePath, titleStr];//[cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@.txt", titleStr]];
        [texImageModel.imgDescrip writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [txtZipArray addObject:txtPath];
        //图片存储
        
        NSString *zipFilePath = [NSString stringWithFormat:@"%@/%@", cachePath, texImageModel.filePath];
        [txtZipArray addObject:zipFilePath];
    }
    if ([SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:txtZipArray]) {
        NSLog(@"压缩成功%@", zipFilePath);
        [self uploadZipdata:[NSData dataWithContentsOfFile:zipFilePath] With:offlineModel];
        
    }else {
        NSLog(@"压缩失败");
    }

}

/** 上传zip */
- (void)uploadZipdata:(NSData *)data With:(OfflineModel *)offlineModel { //remark
    
    NSDictionary *sendDic = @{@"flag":@"app",
                              @"Farmerid":offlineModel.farmerId,
                              @"userid":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"",
                              @"zip":[NSString stringWithFormat:@"%@.zip", offlineModel.reserveOne]};
    
    
    
    __weak typeof(self)weakSelf = self;
    [LCAFNetWork uploadWithURL:@"remark" params:sendDic fileData:data name:@"upload" fileName:[NSString stringWithFormat:@"%@.zip", offlineModel.reserveOne] mimeType:@"zip" progress:^(NSProgress *progress) {
        NSLog(@"%@", progress);
        [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //上传成功保存数据已上传, 清空zip文件夹
        
        [weakSelf saveOfflineDataWith:offlineModel];
        
        [SandBoxManager deleteCacheFileWithPath:@"/OfflineImg"];

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@", [error localizedDescription]);
        //上传失败保存数据未上传, 清空zip文件夹
        
        [SandBoxManager deleteCacheFileWithPath:@"/OfflineImg"];

    }];
}


/**
 修改已上传数据
 
 @param isSave 是否上传
 */
- (void)saveOfflineDataWith:(OfflineModel *)offlineModel{
    __weak typeof(self)weakSelf = self;
    
    //修改专用
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        OfflineModel *dataModel  = [OfflineModel MR_findFirstByAttribute:@"reserveOne" withValue:offlineModel.reserveOne inContext:localContext];
//        dataModel.houseInfo = elementView.houseInfo;
        // dataModel.userId = _userId;
        dataModel.isUpload = YES;
//        dataModel.offlineArray = _dataArray;
//        dataModel.reserveOne = self.model.reserveOne;
//        dataModel.farmerId = elementView.farmerId;
//        dataModel.farmerName = elementView.farmerNamer;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setDataArray];
            
            [weakSelf.tableView reloadData];
            [weakSelf.uploadTabView reloadData];

        });
    }];
    
}



- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"uploadCout" context:nil];
    
    [self removeObserver:self forKeyPath:@"unloadCout" context:nil];

}


@end
