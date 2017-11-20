//
//  AppDelegate.m
//  RealTimeAVideo
//
//  Created by iLogiEMAC on 16/8/2.
//  Copyright © 2016年 zp. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
//#import "OfflineModel+CoreDataClass.h"
//adv & guild
#import "AdvertisingVC.h"
#import "WZXLaunchViewController.h"
#import "WelcomeViewController.h"
#import "IQKeyBoardManager.h"
#import "TabBarController.h"

@interface AppDelegate ()
{
    WelcomeViewController *welcome;
    RootViewController    *rootVC;
}

@end

@implementation AppDelegate

// 启动百度移动统计
- (void)startBaiduMobileStat{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableDebugOn = YES;
    
    [statTracker startWithAppId:@"854c2e8150"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey 854c2e8150
    NSLog(@"DeviceCuid = %@", [statTracker getDeviceCuid]);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s", __FUNCTION__);
    
    [self changeServersIP];
    [self startBaiduMobileStat];
//    [[ActivityApp shareActivityApp] creatReceiveMessageLooper];
    [[ActivityApp shareActivityApp] startLocation];
    /** 全局的键盘管理 */
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor =YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar =YES; // 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour =IQAutoToolbarByTag;
    /** 注册MagicRecord文件目录 */
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"offLine.sqlite"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    TabBarController *tabBar = [[TabBarController alloc]init];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];


    [self displayGuideVC];
    
    return YES;
}

- (void)WZXLaunchView{
    
    
    NSString *gifImageURL = @"http://img1.gamedog.cn/2013/06/03/43-130603140F30.gif";
    
    NSString *imageURL = @"http://img4.duitang.com/uploads/item/201410/24/20141024135636_t2854.thumb.700_0.jpeg";
    
    ///设置启动页
    [WZXLaunchViewController showWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-AutoWHGetHeight(90)) ImageURL:gifImageURL advertisingURL:nil timeSecond:10 hideSkip:YES imageLoadGood:^(UIImage *image, NSString *imageURL) {
        /// 广告加载结束
        NSLog(@"%@ %@",image,imageURL);
        
    } clickImage:^(UIViewController *WZXlaunchVC){
        
        /// 点击广告
        
        //2.在webview中打开
        AdvertisingVC *VC = [[AdvertisingVC alloc] init];
        VC.urlStr = @"http://36.111.32.33:10038/WebServer/farmer/houseInfo.jsp?userId=1";
        VC.title = @"广告";
        VC.AppDelegateSele= -1;
        
        VC.WebBack= ^(){
            //广告webVC 返回
            
            RootViewController *vc = [[RootViewController alloc]init];
            
            self.window.rootViewController = vc;
        };
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
        [WZXlaunchVC presentViewController:nav animated:YES completion:nil];
        
    } theAdEnds:^{
        //启动页计时结束
        
        RootViewController *vc = [[RootViewController alloc]init];
        
        self.window.rootViewController = vc;
    }];
    
    
}


- (void)displayGuideVC{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstInstall"]) {
        welcome = [[WelcomeViewController alloc] init];
        [self.window addSubview:welcome.view];
    } else {
        //display advertisement
//        [self WZXLaunchView];

    }
    
}

/** 更换服务器IP */
- (void)changeServersIP {
    NSDictionary *sendDic = @{@"province":@" ",
                              @"city":@" ",
                              @"county":@" "};
    
    [LCAFNetWork POST:@"http:www.ewanlan-nx.com:10038/regions/regions/selectip.do" baseURL:nil params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[STATE] intValue] == 1) {
            DLog(@"data:%@", responseObject[@"data"]);
            NSError *error;
            if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
                
                NSData *data = [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                if (!error) {
                    [ActivityApp shareActivityApp].serverIP = dic[@"ip1"];
                }else {
                    //IP请求出错，首次安装
                    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstInstall"]) {
                        [ActivityApp shareActivityApp].serverIP = @"36.111.32.33";
                    }else {
                        // 读取缓存
                        [ActivityApp shareActivityApp].serverIP = UDSobjectForKey(@"SERVER_IP");
                    }
                    
                }
            }
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.window makeToast:[error localizedDescription]];
        DLog(@"---error:%@", [error localizedDescription]);
        //首次安装，IP请求出错
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstInstall"]) {
            [ActivityApp shareActivityApp].serverIP = @"36.111.32.33";
        }else {
            // 读取缓存
            [ActivityApp shareActivityApp].serverIP = UDSobjectForKey(@"SERVER_IP");
        }

    }];
}

- (id)responseConfiguration:(id)responseObject error:(NSError **)error{
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:error];
    
    return dic;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    
    NSLog(@"%s", __FUNCTION__);
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //发送通知，通知encoder重新生成一个压缩器
    
//    [[ActivityApp shareActivityApp] creatReceiveMessageLooper];
//    [[ActivityApp shareActivityApp] lib_charge_initConfig];
    

    NSLog(@"%s", __FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // change appstate to offline(0)
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:APPCURRENTSTATE];
    [SandBoxManager deleteCacheFileWithPath:@"/IMG"];
    [MagicalRecord cleanUp];
    DLog(@"Terminate save");
    NSLog(@"%s", __FUNCTION__);
}



@end
