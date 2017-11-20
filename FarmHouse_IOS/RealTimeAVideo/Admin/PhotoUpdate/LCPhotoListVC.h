//
//  LCPhotoListVC.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SaveCoreDataDone)();

@interface LCPhotoListVC : UIViewController

@property(nonatomic, getter=isFromeGather) BOOL fromeGather;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, copy) SaveCoreDataDone SaveCoreDataBlock;

@end
