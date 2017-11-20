//
//  ActivityApp.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/5.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//
//  目前应用内用到的参数 openChanel是音视频端口 8138 8140
//  拍照时的坐席路径，由于底层GBK编码，需要
//

#import <Foundation/Foundation.h>



/** 连接定损服务器状态 */
typedef NS_ENUM(int, ChargeState) {
    STATE_OFFLINE       = 0,    /// 离线
    STATE_ONLINE        = 1,    /// 在线
    STATE_CHARGING      = 2,    /// 定损中
    STATE_PHOTOGRAPHING = 3,    /// 拍照中
    
    STATE_SIGNING       = 4,    ///
    STATE_CHARGING_WAIT = 5,    /// 定损等待
    
    STATE_OFFLINE_BK    = 6,    /// 程序进入后台，离线
    STATE_ONLINE_BK     = 7,    /// 程序进入后台，在线
    STATE_CHARGING_BK   = 8,    /// 程序进入后台，定损中，视频会断，音频要保持通畅
    STATE_PHOTOGRAPHING_BK = 9, /// 程序进入后台，拍照中
};

/**
 * 0 wifi disable, 3G disable
 * 1 wifi enable, but cannot connect to internet, 3G disable
 * 2 wifi enable, 3G disable
 * 3 wifi enable, 3G enable
 * 4 wifi enable, but cannot connect to internet, 3G enable
 * 5 wifi disable, 3G enable
 */

typedef NS_ENUM(int, NetState) {
    NET_DISENABLE = 0,
    NET_WIFILAN_3GUN = 1,
    NET_WIFIEN_3GUN = 2,
    NET_WIFIEN_3GEN = 3,
    NET_WIFILAN_3GEN = 4,
    NET_WIFIUN_3GEN = 5,
};

@protocol ActivityAppDelegate;
@interface ActivityApp : NSObject <NSCopying>

@property (nonatomic, weak) id<ActivityAppDelegate> delegate;

/** 处理底层消息的线程 */
@property(nonatomic, strong) NSThread *callBackThread;

/**
 * 0 offline 1 online 2 charging 3 being photographed 4 Signing in 5
 * charging wait 6 background offline 7 background online 8 background
 * charging 9 background being photographed
 */
@property (atomic, assign) int sCurrentState;

/** 
 定损时判断是否登陆过服务器 
 */
@property (atomic, assign) BOOL isLoginC;

@property (atomic, assign) int sNetState;

/**
 服务器地址 36.111.32.33
 */
@property (nonatomic, copy) NSString *serverIP;

/**
 服务器地址 @"http://36.111.32.33:10038/WebServer/"
 */
@property (nonatomic, copy) NSString *baseURL;

/** 
 报案号 
 */
@property (nonatomic, copy) NSString *reportNum;

/**
 图片水印信息
 */
@property(nonatomic, strong) NSMutableArray *waterTxtArr;


/** 单例模式获取对象 */
+ (instancetype)shareActivityApp;

/** 创建一个接收底层回调消息的线程 */
- (void)creatReceiveMessageLooper;

/* charge 库 初始化 & 配置 &连接 */
- (BOOL)lib_charge_initConfig;

/** 创建并初始化传输库 */
- (BOOL)lib_devavtp_initAndConfig;

- (void)startLocation;
- (void)stopLocation;

/** 重置底库的设备号 */
- (void)resetlibDeviceNum:(unsigned int )deviceNumber;

@end





/**
 * 底层消息接收类的代理方法
 */
@protocol ActivityAppDelegate <NSObject>

@optional

//VA_EVENT_CONNECT_SUCCESSED

//VA_EVENT_LOGIN_SUCCESSED

//VA_EVENT_CHARGE_NOFREE_WAIT_COUNT

//VA_EVENT_CHARGEREQ_SUCCESSED
//.
//. CHARGING
//.
//VA_EVENT_CHARGE_CHARGECOMPLETE

- (void)activityAppLoginSuccess:(ActivityApp *)activityApp;

/**
 * 返回坐席排队信息
 */
- (void)activityApp:(ActivityApp *)activityApp chargeNofreeWaitCountWithParam:(NSDictionary *)paramDic;


/**
 * 发起定损请求成功被坐席接受
 */
- (void)activityApp:(ActivityApp *)activityApp chargeReqSuccessedWithParam:(NSDictionary *)paramDic;


/**
 * 发起定损请求失败
 */
- (void)activityApp:(ActivityApp *)activityApp chargeReqFailedParam:(NSDictionary *)paramDic;


/**
 * 获取设备拍照授权 && 取消设备拍照授权
 */
- (void)activityApp:(ActivityApp *)avtivityApp devSnapAuth:(BOOL)isAuth WithParamDictionary:(NSDictionary *)paramDic;


/**
 * 图片传输进度
 */
- (void)activityApp:(ActivityApp *)activityApp sendPhotoProcess:(NSString *)process;


/**
 * 图片传输完成
 */
- (void)activityApp:(ActivityApp *)activityApp cancelFileComolete:(BOOL)isComplete;


/**
 * 图片传输失败
 */
- (void)activityAppSendPhotoFailed:(ActivityApp *)activityApp;


/**
 * 图片传输超时，坐席弹框取消，并回调
 */
- (void)activityAppCancelFileTransf:(ActivityApp *)activityApp;


/**
 * 坐席控制相机主动拍照
 */
- (void)activityApp:(ActivityApp *)activityApp SnapPicWithParam:(NSDictionary *)ParamDic;


/**
 * 定损完成，坐席,手机结束定损都会回调
 */
- (void)activityAppChargeComplete:(ActivityApp *)activityApp;


/**
 * 定损完成失败。有时一上来就收到，why ？ ？
 */
- (void)activityAppChargeCompleteFailed:(ActivityApp *)activityApp;

/**
 透明通道的相关回调
 
 @param activityApp 控制对象
 @param param 字典
 */
- (void)activityApp:(ActivityApp *)activityApp SeatsInstructParam:(NSDictionary *)paramDic;
@end






