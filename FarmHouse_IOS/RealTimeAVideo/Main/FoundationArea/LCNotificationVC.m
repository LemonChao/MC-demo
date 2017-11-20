//
//  LCNotificationVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/24.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCNotificationVC.h"
#import "LCNotifCell.h"
#import "LCNullView.h"
#import "NotificationNews+CoreDataProperties.h"
#import "LCNotifDetailVC.h"



@interface LCNotificationVC ()<UITableViewDelegate,UITableViewDataSource>
{
    RACSubject *subject;
    UIBarButtonItem *deleteButton;
}
@property (nonatomic,strong) UITableView *ntfTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation LCNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"消息通知";
    [self creatNavItem];
    
    [self.view addSubview:self.ntfTableView];
    subject = [RACSubject subject];
    
    @weakify(self);
    [subject subscribeNext:^(NSMutableArray *array) {
        @strongify(self);

        [self.ntfTableView reloadData];
        
        [self.ntfTableView configBlankPage:EaseBlankPageTypeNoButton hasData:array.count hasError:NO reloadButtonBlock:nil];
        
        if (array.count == 0) {
            self.navigationItem.rightBarButtonItem = nil;
        }else {
            self.navigationItem.rightBarButtonItem = deleteButton;
        }
        
    }];
    

    [subject sendNext:_dataArray];

}

- (void)creatNavItem{
    deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"清除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAllNews)];
    self.navigationItem.rightBarButtonItem = deleteButton;
}


- (void)deleteAllNews {
    //ios9创建alertview
    NSString *title = @"重要提示";
    //改变 UIAlertController 标题颜色
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorwithHexString:@"#00A0E9"] range:NSMakeRange(0, title.length)];
    NSString *message = [NSString stringWithFormat:@"删除之后不可恢复\n哈哈哈"];
    NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"取消", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //改变 UIAlertController 按钮颜色
//    [UIView appearance].tintColor = [UIColor colorwithHexString:@"#00A0E9"];
    //点击事件
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        for (NotificationNews *notifNews in [NotificationNews MR_findAll]) {
            [notifNews MR_deleteEntity];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [_dataArray removeAllObjects];
            [subject sendNext:_dataArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedFreshNotificationNews" object:nil];

        }];
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [alertController setValue:str forKey:@"attributedTitle"];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

/** 单条 delete 
    只需要实现这个方法就能出现侧滑删除效果
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //从数据库删除
        NotificationNews *notifNews = self.dataArray[indexPath.row];
        NotificationNews *news = [NotificationNews MR_findFirstByAttribute:@"newsid" withValue:notifNews.newsid];
        [news MR_deleteEntity];
        @weakify(self);
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            @strongify(self);
            //从数据源中删除数据
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [subject sendNext:_dataArray];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedFreshNotificationNews" object:nil];

        }];
        
        

    }
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NotificationNews MR_findAll] mutableCopy];
    }
    return _dataArray;
}

- (UITableView *)ntfTableView {
    if (!_ntfTableView) {
        self.ntfTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStylePlain];
        _ntfTableView.dataSource = self;
        _ntfTableView.delegate = self;
        _ntfTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ntfTableView.showsVerticalScrollIndicator = NO;
        _ntfTableView.backgroundColor = TabBGColor;
        _ntfTableView.tableFooterView = [UIView new];
    }
    return _ntfTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NtfCellH;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCNotifCell *cell = [LCNotifCell creatCellWithTableView:tableView];
    
    
    NotificationNews *newsModel = self.dataArray[indexPath.row];
    [cell setValueWithDataDictionary:newsModel];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NotificationNews *news = self.dataArray[indexPath.row];
    
    LCNotifDetailVC *notifDetail = [[LCNotifDetailVC alloc] init];
    notifDetail.notifNews = news;
    [self.navigationController pushViewController:notifDetail animated:YES];
    
    
    [self hasReadNotificationNews:news];
    
    
}

- (void)hasReadNotificationNews:(NotificationNews *)notifNews {
    
    notifNews.isRead = YES; //修改数据源
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        NotificationNews *news = [NotificationNews MR_findFirstByAttribute:@"newsid" withValue:notifNews.newsid inContext:localContext];
        
        news.isRead = YES; //修改coreData数据
        
        DLog(@"---------thread %@", [NSThread currentThread]);

    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        DLog(@"Save data into DB succeeded! %@", [NSThread currentThread]);
        
        [self.ntfTableView reloadData];
        
        //post notification to MainVC
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedFreshNotificationNews" object:nil];

        
    }];
    
}

@end
