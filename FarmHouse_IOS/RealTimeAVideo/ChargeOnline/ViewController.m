//
//  ViewController.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/2.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "ViewController.h"
#import "RTAVVideoConfiguration.h"
#import "WCLRecordVideoVC.h"
#import "LCLonginVC.h"

#import "UUID.h"
#import "LCNullView.h"


@interface ViewController ()<ActivityAppDelegate>
{
    unsigned int deviceNum;
    ActivityApp *actApp;
    NSTimer *timer;
    NSInteger counter;
    
    LCNullView *nullView;
}

@end



@implementation ViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    if ([timer isValid]) {
        [timer invalidate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    deviceNum = [[UUID getDeviceNum] intValue];
    
    actApp = [ActivityApp shareActivityApp];
    actApp.delegate = self;
    
    if (actApp.sCurrentState) {
        nullView = [[LCNullView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) imgString:@"ording_bee" labTitle:@"连接中...30分00秒" buttonTitle:@"取消等待定损"];
        
        __weak typeof(NSTimer*) weakTimer = timer;
        __weak typeof(self) weakSelf = self;
        __block unsigned  int deviceId = deviceNum;
        __weak typeof(ActivityApp*) weakApp = actApp;
        nullView.block = ^(){
            
            [weakTimer invalidate];
            jinglian_charge_quit_call_wait(deviceId, 1);
            weakApp.sCurrentState = STATE_ONLINE;
            //            devavtp_release();
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        };
        
        
        [weakSelf.view addSubview:nullView];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        counter = 120;
        
    }else {
        nullView = [[LCNullView alloc] initWithFrame:self.view.bounds imgString:@"no_network" labTitleString:@"与定损服务器断开连接"];
        [self.view addSubview:nullView];
    }

    
    [self jinglian_charge_charge_call_req2_Check:self.reportNum];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    
}

- (void)timerAction {
    counter--;
    counter = (counter < 0) ? 0 : counter;
    
    nullView.titleLab.text = [NSString stringWithFormat:@"连接中...%ld分%ld秒", counter/60, counter%60];
    
    if (counter == 0) {
        [timer invalidate];
        jinglian_charge_quit_call_wait(deviceNum, 1);
        actApp.sCurrentState = STATE_ONLINE;
//        devavtp_release();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 return NO： Ignore 'Back' button this time
 popView occured inside AlertController
 */
-(BOOL) navigationShouldPopOnBackButton {
    if (!([ActivityApp shareActivityApp].sCurrentState == STATE_ONLINE ||
        [ActivityApp shareActivityApp].sCurrentState == STATE_OFFLINE)) {
        [self alertWithResponse:^(BOOL didCancel) {
        }];
        return NO;
    }else {
        return YES;
    }
    
}


- (void)alertWithResponse:(void (^)(BOOL didCancel))response {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示！", "提示！") message:NSLocalizedString(@"正在定损等待中\n确定要退出吗", "") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelar = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", "确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        int result = jinglian_charge_quit_call_wait(deviceNum, 1);
        actApp.sCurrentState = STATE_ONLINE;
//        devavtp_release();

        NSLog(@"result %d", result);

        [alertController dismissViewControllerAnimated:YES completion:nil];
        response(NO);
        [self.navigationController popViewControllerAnimated:YES];

    }];
    [alertController addAction:cancelar];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", "取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#define mark - ActivityAppDelegate

/** 返回定损排队信息 */
-(void)activityApp:(ActivityApp *)activityApp chargeNofreeWaitCountWithParam:(NSDictionary *)paramDic {
    
    NSInteger queueCount = [paramDic[@"m_queue_count"] integerValue];
    DLog(@"----------%ld", queueCount);

    //更改UI
    dispatch_async(dispatch_get_main_queue(), ^{
        nullView.desLab.text = [NSString stringWithFormat:@"当前排队人数为%ld，请耐心等待",(long)queueCount];
    });

    

}


- (void)activityApp:(ActivityApp *)activityApp chargeReqSuccessedWithParam:(NSDictionary *)paramDic {
    
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [selfWeak interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        WCLRecordVideoVC *recoedVC = [[WCLRecordVideoVC alloc] init];
        recoedVC.ChargeReqDic = paramDic;
        recoedVC.completeBlock = ^(){
            //1.charge 释放
//            jinglian_charge_disconnect();
//            jinglian_charge_deinit();
            //2.devavtp 释放
          //  devavtp_release();
            //3.消息线程runloop释放
//            [activityApp.callBackThread cancel];
//            activityApp.callBackThread = nil;
            
//            devavtp_release();
//            jinglian_charge_logout();
//            jinglian_charge_deinit();
            
            [selfWeak.navigationController popViewControllerAnimated:YES];
        };
        
        [selfWeak.navigationController pushViewController:recoedVC animated:YES];
        
    });

}

- (void)activityApp:(ActivityApp *)activityApp chargeReqFailedParam:(NSDictionary *)paramDic {
    DLog(@"faild");
}


- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)dealloc {
    
    DLog(@"%@ dealloc", [self class]);
}


#pragma mark - Network


//- (void)requestForReportNumber {
//    NSDictionary *sendDic = @{@"flag":@"GetCaseNum",
//                              @"nhId":self.hhModel.masterid,
//                              USERID:UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@" ",
//                              SESSID:UDSobjectForKey(SESSID)?UDSobjectForKey(SESSID):@" "};
//    DLog(@"send%@", sendDic);
//    [LCAFNetWork POST:ewlWebServerReport params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
//        // 状态值 0失败，1成功 2失败 如果状态值为2的话就跳到登录页面重新登录
//        if ([responseObject[@"state"] intValue] == 0) {
//            [self.view makeToast:[responseObject objectForKey:@"message"] duration:1 position:CSToastPositionCenter];
//            return;
//        }
//        if ([responseObject[@"state"] intValue] == 1) {
//            
//            NSString *reportNum = responseObject[@"message"];
//            if (!reportNum) return;
//            [ActivityApp shareActivityApp].reportNum = reportNum;
//            [self jinglian_charge_charge_call_req2_Check:reportNum];
//            actApp.sCurrentState = STATE_CHARGING_WAIT;
//
//        }
//        
//        if ([responseObject[@"state"] intValue] == 2) {
//            LCLonginVC *loginVC = [[LCLonginVC alloc] init];
//            loginVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:loginVC animated:YES];
//        }
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        //
//        [self.view makeToast:[error localizedDescription] duration:1 position:CSToastPositionCenter];
//    }];
//
//}

/** 发起定损请求 */
- (void)jinglian_charge_charge_call_req2_Check:(NSString *)reportNum
{
    char *reportNumChar = (char *)[reportNum cStringUsingEncoding:NSUTF8StringEncoding];
//    char *reportNumChar = (char *)[@"0111100000098248176012" cStringUsingEncoding:NSUTF8StringEncoding];

    static NSLock *lock = nil;
    if (!lock) {
        lock = [[NSLock alloc] init];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];
        
        int callResult = jinglian_charge_charge_call_req2(reportNumChar, 0);
        
        DLog(@"callResult = %d", callResult);

        [lock unlock];
        
    });
    
}

@end
