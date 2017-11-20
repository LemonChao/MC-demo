//
//  ActivityApp.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/5.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "ActivityApp.h"
#import "UUID.h"
#import "LCLocation.h"



@interface ActivityApp ()<LCLocationDelegate>{
    unsigned int deviceNum;
}

@property(nonatomic, strong) LCLocation *location;

@end



@implementation ActivityApp

+ (instancetype)shareActivityApp {
    
    static ActivityApp *activityApp = nil;
    static dispatch_once_t predicate;
    
    _dispatch_once(&predicate, ^{
        activityApp = [super allocWithZone:NULL];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstInstall"]) {
            activityApp.serverIP = SERVER_IP;
        }else {
            activityApp.serverIP = UDSobjectForKey(@"SERVER_IP");
        }
        DLog(@"-------activityApp.baseURL:%@", activityApp.baseURL);
    });
    
    return activityApp;
}
/** 防止通过 alloc 方法得到不同对象 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareActivityApp];
}
/** 防止拷贝时，得到不同对象 */
- (instancetype)copyWithZone:(nullable NSZone *)zone {
    return [ActivityApp shareActivityApp];
}

#define setter & getter

- (void)setServerIP:(NSString *)serverIP {
    // 保存服务器IP
    if (![_serverIP isEqualToString:serverIP]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:serverIP forKey:@"SERVER_IP"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _serverIP = serverIP;
        // 读取
        NSString *ip = UDSobjectForKey(@"SERVER_IP");
        _baseURL = [NSString stringWithFormat:@"http://%@:10038/WebServer/", ip];
        
    }

}

- (void)resetlibDeviceNum:(unsigned int)deviceNumber {
    
    deviceNum = deviceNumber;
    
    [self jinglian_charge_init_Check];
    
    [self jl_devavtp_init_Check];
    
}

//- (NSThread *)callBackThread {
//    if (!_callBackThread) {
//        _callBackThread = [[NSThread alloc] initWithTarget:self selector:@selector(recvCallBack) object:nil];
//        [_callBackThread setName:@"receiveCallBack"];
//        
//    }
//    return _callBackThread;
//}

- (void)creatReceiveMessageLooper {
    
    deviceNum = [[UUID getDeviceNum] intValue];
    _callBackThread = [[NSThread alloc] initWithTarget:self selector:@selector(recvCallBack) object:nil];
    [_callBackThread setName:@"receiveCallBack"];
  //  if (self.callBackThread) {
         [self.callBackThread start];
  //  }
    
   
    [self startLocation];
    [self lib_charge_initConfig];
}


- (void)recvCallBack {
    @autoreleasepool {
        
        Provider_IOS_Msg* providerEvent;
        
        //不断查询回调事件
        while (YES) {
            
            providerEvent = getEvent();
            
            
            if (providerEvent) {
                
                
                //GBK编码转成NSString
                NSString *jsonString = [NSString stringWithCString:providerEvent->m_eventInfo encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
                DLog(@"callBackThread%lu eventID:%d eventInfo:%s\nGBKencode%@",strlen(providerEvent->m_eventInfo)+1, providerEvent->m_eventID, providerEvent->m_eventInfo, jsonString);
                
                switch (providerEvent->m_eventID) {
                    case VA_EVENT_INIT_FAILED:
                    {
                        DLog(@"--------VA_EVENT_INIT_FAILED ");
                    }
                        break;
                        
                    case VA_EVENT_INIT_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_INIT_SUCCESSED ");
                    }
                        break;
                        
                    case VA_EVENT_CONNECT_FAILED:
                    {
                        DLog(@"--------VA_EVENT_CONNECT_FAILED ");
                        self.sCurrentState = STATE_OFFLINE;
                    }
                        break;
                        
                    case VA_EVENT_CONNECT_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_CONNECT_SUCCESSED ");
                        self.sCurrentState = STATE_ONLINE;
                        
                        [self lib_devavtp_initAndConfig];


                    }
                        break;
                        
                    case VA_EVENT_DISCONNECT_FAILED: // break connect
                    {
                        DLog(@"--------VA_EVENT_DISCONNECT_FAILED ");
                        self.sCurrentState = STATE_OFFLINE;
                    }
                        break;
                        
                    case VA_EVENT_DISCONNECT_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_DISCONNECT_SUCCESSED ");
                        self.sCurrentState = STATE_OFFLINE;
                    }
                        break;
                        
                    case VA_EVENT_LOGIN_FAILED:
                    {
                        DLog(@"--------VA_EVENT_LOGIN_FAILED ");
                        self.sCurrentState = STATE_OFFLINE;
                    }
                        break;
                        
                    case VA_EVENT_LOGIN_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_LOGIN_SUCCESSED ");
                        self.sCurrentState = STATE_ONLINE;
                        
                    }
                        break;
                        
                    case VA_EVENT_LOGOUT_FAILED:
                    {
                        DLog(@"--------VA_EVENT_LOGOUT_FAILED ");
                    }
                        break;
                        
                    case VA_EVENT_LOGOUT_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_LOGOUT_SUCCESSED ");
                        self.sCurrentState = STATE_OFFLINE;
                    }
                        break;
                        
                    case VA_EVENT_CHARGEREQ_FAILED:
                    {
                        DLog(@"--------VA_EVENT_CHARGEREQ_FAILED ");
//                        NSDictionary *dic = [ActivityApp responseJBKConfiguration:providerEvent->m_eventInfo];
//                        if (dic) {
//                            if ([_delegate respondsToSelector:@selector(activityApp:chargeNofreeWaitCountWithParam:)]) {
//                                [_delegate activityApp:self chargeNofreeWaitCountWithParam:dic[@"TJLCallQueueCntNtf"]];
//                            }
//                            NSLog(@"dic%@   VA_EVENT_CHARGE_NOFREE_WAIT_COUNT", dic);
//                        }
                        
                        if ([_delegate respondsToSelector:@selector(activityApp:chargeReqFailedParam:)]) {
                            [_delegate activityApp:self chargeReqFailedParam:nil];
                        }


                    }
                        break;
                        
                    case VA_EVENT_CHARGE_NOFREE_WAIT_COUNT:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_NOFREE_WAIT_COUNT ");
                        //当前仅有自己在等待
                        //不是 STATE_ONLINE 状态继续轮循
                        if (_sCurrentState != STATE_ONLINE) continue;
                        
                        self.sCurrentState = STATE_CHARGING_WAIT;
                        
                        NSDictionary *dic = [ActivityApp responseJBKConfiguration:providerEvent->m_eventInfo];
                        if (dic) {
                            if ([_delegate respondsToSelector:@selector(activityApp:chargeNofreeWaitCountWithParam:)]) {
                                [_delegate activityApp:self chargeNofreeWaitCountWithParam:dic[@"TJLCallQueueCntNtf"]];
                            }
                            NSLog(@"dic%@   VA_EVENT_CHARGE_NOFREE_WAIT_COUNT", dic);
                        }
                        
                    }
                        break;
                        
                    case VA_EVENT_CHARGEREQ_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_CHARGEREQ_SUCCESSED ");
                        //不是 CHARGING_WAIT 状态继续轮循
                        if (_sCurrentState != STATE_CHARGING_WAIT) continue;
                        
                        self.sCurrentState = STATE_CHARGING;
                        
                        NSDictionary *dic = [ActivityApp responseJBKConfiguration:providerEvent->m_eventInfo];

                        if (dic) {
                            
                            if ([_delegate respondsToSelector:@selector(activityApp:chargeReqSuccessedWithParam:)]) {
                                [_delegate activityApp:self chargeReqSuccessedWithParam:dic[@"TJLPuChargeCallRsp"]];
                            }
                            
                        }

                    }
                        break;
                    case VA_EVENT_CHARGE_NOFREE:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_NOFREE ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_NOANSWER:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_NOANSWER ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_REFUSE:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_REFUSE ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_NOFREE_BUSY:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_NOFREE_BUSY ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_ERRREPORTNO:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_ERRREPORTNO ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_AGENTBUSY:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_AGENTBUSY ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_COMPLETE_FAILED:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_COMPLETE_FAILED ");
                        //有时候上来会受到这个消息，why ？？
                        if (_sCurrentState != STATE_CHARGING) continue;

                        if (_sCurrentState == STATE_CHARGING) {
                            //正在定损中收到
                        }else {
                            
                        }
                        
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_COMPLETE_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_COMPLETE_SUCCESSED ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_CHARGECOMPLETE:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_CHARGECOMPLETE ");
//                        devavtp_release();
                        
                        //不是 charge 状态继续轮循
                        if (_sCurrentState != STATE_CHARGING) continue;
                        
                        if ([_delegate respondsToSelector:@selector(activityAppChargeComplete:)]) {
                            [_delegate activityAppChargeComplete:self];
                        }
                        
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_BREAK:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_BREAK ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_TIMEOUT:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_TIMEOUT ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_WANTADDITION:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_WANTADDITION ");
                    }
                        break;
                        
                    case VA_EVENT_ALREADY_CONNECT:
                    {
                        DLog(@"--------VA_EVENT_ALREADY_CONNECT ");
                    }
                        break;
                        
                    case VA_EVENT_ALREADY_ONLINE:
                    {
                        DLog(@"--------VA_EVENT_ALREADY_ONLINE ");
                    }
                        break;
                        
                    case VA_EVENT_ALREADY_DIALING:
                    {
                        DLog(@"--------VA_EVENT_ALREADY_DIALING ");
                    }
                        break;
                        
                    case VA_EVENT_ALREADY_CHARGEING:
                    {
                        DLog(@"--------VA_EVENT_ALREADY_CHARGEING ");
                    }
                        break;
                        
                    case VA_EVENT_ALREADY_STREAMING:
                    {
                        DLog(@"--------VA_EVENT_ALREADY_STREAMING ");
                    }
                        break;
                        
                    case VA_EVENT_ALREADY_WAITEAGENT:
                    {
                        DLog(@"--------VA_EVENT_ALREADY_WAITEAGENT ");
                    }
                        break;
                        
                    case VA_EVENT_NOT_CONNECT:
                    {
                        DLog(@"--------VA_EVENT_NOT_CONNECT ");
                    }
                        break;
                        
                    case VA_EVENT_GET_REPORT_FAILED:
                    {
                        DLog(@"--------VA_EVENT_GET_REPORT_FAILED ");
                    }
                        break;
                        
                    case VA_EVENT_GET_REPORT_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_GET_REPORT_SUCCESSED ");
                    }
                        break;
                        
                    case VA_EVENT_MEDIA_SWITCH_FAILED:
                    {
                        DLog(@"--------VA_EVENT_MEDIA_SWITCH_FAILED ");
                    }
                        break;
                        
                    case VA_EVENT_MEDIA_SWITCH_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_MEDIA_SWITCH_SUCCESSED ");
                    }
                        break;
                        
                    case VA_EVENT_MEDIA_STOP_FAILED:
                    {
                        DLog(@"--------VA_EVENT_MEDIA_STOP_FAILED ");
                    }
                        break;
                        
                    case VA_EVENT_MEDIA_STOP_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_MEDIA_STOP_SUCCESSED ");
                    }
                        break;
                        
                    case VA_EVENT_SNAP_PIC:
                    {
                        DLog(@"--------VA_EVENT_SNAP_PIC ");
                        NSDictionary *dic = [ActivityApp responseJBKConfiguration:providerEvent->m_eventInfo];
                        
                        if (dic) {
                            
                            if ([_delegate respondsToSelector:@selector(activityApp:SnapPicWithParam:)]) {
                                [_delegate activityApp:self SnapPicWithParam:dic[@"TJLPuSnapPicReq"]];
                            }
                        }
                        
                        
                    }
                        break;
                        
                    case VA_EVENT_PARAM_CFG_FAILED:
                    {
                        DLog(@"--------VA_EVENT_PARAM_CFG_FAILED ");
                    }
                        break;
                        
                    case VA_EVENT_PARAM_CFG_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_PARAM_CFG_SUCCESSED ");
                    }
                        break;
                        
                    case VA_EVENT_PHOTO_SEND_FAILED:
                    {
                        DLog(@"--------VA_EVENT_PHOTO_SEND_FAILED ");
                        if ([_delegate respondsToSelector:@selector(activityAppSendPhotoFailed:)]) {
                            [_delegate activityAppSendPhotoFailed:self];
                        }
                    }
                        break;
                        
                    case VA_EVENT_PHOTO_SEND_PROCESS:
                    {
                        //send pic by slipe,and currate 0,20,35,49,64,95,100
                        DLog(@"--------VA_EVENT_PHOTO_SEND_PROCESS ");
                        NSDictionary *dic = [ActivityApp responseJBKConfiguration:providerEvent->m_eventInfo];
                        DLog(@"progress = %@", dic);
                        if (dic) {
                            if ([_delegate respondsToSelector:@selector(activityApp:sendPhotoProcess:)]) {
                                [_delegate activityApp:self sendPhotoProcess:dic[@"byCurRate"]];
                            }

                        }
                    }
                        break;
                        
                    case VA_EVENT_PHOTO_SEND_SUCCESSED:
                    {
                        DLog(@"--------VA_EVENT_PHOTO_SEND_SUCCESSED ");
                        NSDictionary *dic = [ActivityApp responseJBKConfiguration:providerEvent->m_eventInfo];
                        if (dic) {
                            if ([_delegate respondsToSelector:@selector(activityApp:sendPhotoProcess:)]) {
                                [_delegate activityApp:self sendPhotoProcess:dic[@"byCurRate"]];
                            }
                            
                        }
                        
                    }
                        break;
                        
                    case VA_EVENT_VIDEO_TRANSPORT_REPORT:
                    {
                        DLog(@"--------VA_EVENT_VIDEO_TRANSPORT_REPORT ");
                    }
                        break;
                        
                    case VA_EVENT_AUTH_DEV_SNAP:
                    {
                        DLog(@"--------VA_EVENT_AUTH_DEV_SNAP ");
                        // 在定损界面
                        if (self.sCurrentState != STATE_CHARGING) break;
                        NSDictionary *dic = [ActivityApp responseJBKConfiguration:providerEvent->m_eventInfo];
                        if (dic) {
                            
                            if ([_delegate respondsToSelector:@selector(activityApp:devSnapAuth:WithParamDictionary:)]) {
                                [_delegate activityApp:self devSnapAuth:YES WithParamDictionary:dic[@"TJPuAuthSnap"]];
                            }

                        }
                        // 不在
                        //jinglian_auth_snap_rsp(1);
                        
                    }
                        break;
                        
                    case VA_EVENT_CANCEL_AUTH_DEV_SNAP:
                    {
                        // 坐席点击取消授权
                        DLog(@"--------VA_EVENT_CANCEL_AUTH_DEV_SNAP ");
                        if (self.sCurrentState != STATE_CHARGING) break;
                        if ([_delegate respondsToSelector:@selector(activityApp:devSnapAuth:WithParamDictionary:)]) {
                            [_delegate activityApp:self devSnapAuth:NO WithParamDictionary:nil];
                        }else {
                            jinglian_cancel_auth_snap_rsp(0);
                        }

                    }
                        break;
                        
                    case VA_EVENT_CLIENT_CANCEL_FILE_TRANSF:
                    {
                        //图片传输超时，坐席弹框取消，并回调
                        DLog(@"--------VA_EVENT_CLIENT_CANCEL_FILE_TRANSF ");
                        if (self.sCurrentState != STATE_CHARGING) break;
                        if ([_delegate respondsToSelector:@selector(activityAppCancelFileTransf:)]) {
                            [_delegate activityAppCancelFileTransf:self];
                        }
                    }
                        break;
                        
                    case VA_EVENT_CLIENT_CANCEL_FILE_COMPLETE:
                    {
                        //图片传输完成
                        DLog(@"--------VA_EVENT_CLIENT_CANCEL_FILE_COMPLETE ");
                        if (self.sCurrentState != STATE_CHARGING) break;
                        if ([_delegate respondsToSelector:@selector(activityApp:cancelFileComolete:)]) {
                            [_delegate activityApp:self cancelFileComolete:YES];
                        }
                    }
                        
                        break;
                    case VA_EVENT_LENS_CTRL_REQ:
                    {
                        DLog(@"--------VA_EVENT_LENS_CTRL_REQ ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_CHANGE_EVNET:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_CHANGE_EVNET ");
                    }
                        break;
                        
                    case VA_EVENT_CHARGE_SYSBUSY:
                    {
                        DLog(@"--------VA_EVENT_CHARGE_SYSBUSY ");
                    }
                        break;
                        
                    case VA_EVENT_BACK_CALL_REQUEST:
                    {
                        DLog(@"--------VA_EVENT_BACK_CALL_REQUEST ");
                    }
                        break;
                        
                    case VA_EVENT_BACK_CALL_CANCEL:
                    {
                        DLog(@"--------VA_EVENT_BACK_CALL_CANCEL ");
                    }
                        break;
                        
                    case VA_EVENT_REDIAL_LATER:
                    {
                        DLog(@"--------VA_EVENT_REDIAL_LATER ");
                    }
                        break;
                        
                    case VA_EVENT_NO_ONLINE_AGENT:
                    {
                        DLog(@"--------VA_EVENT_NO_ONLINE_AGENT ");
                    }
                        break;
                        
                    case VA_EVENT_TRANSPARENT_CHANNEL:
                    {
                        //透明通道
                        DLog(@"--------VA_EVENT_TRANSPARENT_CHANNEL ");
                        NSDictionary *dicA = [ActivityApp responseJBKConfiguration:providerEvent->m_eventInfo];
                        if ([_delegate respondsToSelector:@selector(activityApp:SeatsInstructParam:)]) {
                            NSDictionary *dicB = [ActivityApp responseConfiguration:dicA[@"TJPuTransparentChannel"][@"data"]];
                            [_delegate activityApp:self SeatsInstructParam:dicB[@"cmd"]];
                        }
                    }
                        break;
    
                        
                    default:
                        break;
                }
            }
            
            if ([self.callBackThread isCancelled]) {
                DLog(@"exit");
                [NSThread exit];
                self.callBackThread = nil;
            }
            
            
            usleep(3500);
            
        }
        
    }
    
    
}



/**
 解析数据
 */
+(NSDictionary *)responseConfiguration:(NSString *)responseStr{
    NSError *error;
    
    NSString *string = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        DLog(@"%@ error:%@",dic, error);
        return nil;
    }
    return dic;
}


/**
 解析JBK数据
 */
+(NSDictionary *)responseJBKConfiguration:(const char*)responseStr{
    NSError *error;
    NSString *jsonString = [NSString stringWithCString:responseStr encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSString *string = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic;
    if (data) {
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    }
    if (error) DLog(@"JBK%@ error:%@",dic, error);
    return dic;
}




/** 创建并初始化定损，连接定损服务器*/
- (void)charge_InitAndConfigToConnectServer{
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //任务添加到队列中异步执行
//        
//        [self getPermit];
//        
////        [self jinglian_charge_init_Check];
////        
////        [self jinglian_charge_config_Check];
//        
//        BOOL result = [self lib_charge_initConfig];
//        
//        if (result) {
//            jinglian_charge_connect();
//        }else {
//            //charge 初始化配置失败
//        }
//        
//
//    });
    
    [self getPermit];
    
    
    BOOL result = [self lib_charge_initConfig];
    
    if (result) {
        jinglian_charge_connect();
    }else {
        //charge 初始化配置失败
    }

    
}


/* charge 库 初始化 & 配置 &连接 */
- (BOOL)lib_charge_initConfig {
    
    [self getPermit];
    
    if (![self jinglian_charge_init_Check]) return NO;
    if (![self jinglian_charge_config_Check]) return NO;
    
    int result = jinglian_charge_connect();
    return result ? NO : YES;
}


/**
 YES 取消成功
 */
- (BOOL)lib_charge_deinit {
    if (!jinglian_charge_deinit()) return NO;
    
    int result = jinglian_charge_disconnect();
    return result ? NO : YES;
}


/** devavtp 库 创建并初始化 */
- (BOOL)lib_devavtp_initAndConfig {
    
    if (![self jl_devavtp_init_Check]) return NO;
    return [self jl_devavtp_config_Check];
}


- (void)startLocation {
    [self.location startUpdatingLocation];
}

- (void)stopLocation {
    [self.location stopUpdatingLocation];
}

- (LCLocation *)location {
    if (!_location) {
        _location = [[LCLocation alloc] init];
        _location.delegate = self;
    }
    return _location;
}


- (void)getPermit {
    
    char *dev_id = (char *)[[UUID getDeviceNum] cStringUsingEncoding:NSUTF8StringEncoding];
    generate();
    getPermit("", "", dev_id);
}

/** Charge 初始化 */
- (BOOL)jinglian_charge_init_Check
{
    
    system_config_t system_config;
    system_config.deviceId = deviceNum;
    system_config.signal_port = SIGNAL_PORT;
    strcpy(system_config.server_ip, self.serverIP.UTF8String);
    
    DLog(@"DevicedId=%d Port=%d Serverip=%s", system_config.deviceId,system_config.signal_port, system_config.server_ip);
    
    //0:success
    int result = jinglian_charge_init(&system_config);
    NSLog(@"%d", result);
    return result ? NO : YES;
}



/** 配置信息 */
- (BOOL)jinglian_charge_config_Check
{
    system_config_t system_config;
    system_config.deviceId = deviceNum;
    system_config.signal_port = SIGNAL_PORT;
    strcpy(system_config.server_ip, self.serverIP.UTF8String);
    
    DLog(@"DevicedId=%d Port=%d Serverip=%s", system_config.deviceId,system_config.signal_port, system_config.server_ip);
    
    int configResult = jinglian_charge_config(&system_config);
    
//    jinglian_charge_connect();
    DLog(@"configResult = %d connectResult =",configResult);
    return configResult ? NO : YES;
};

/** 音视频传输初始化 */
- (BOOL)jl_devavtp_init_Check
{
    devavtp_config_t dev_config;
    dev_config.deviceId = deviceNum;
    dev_config.audio_listen_port = AUDIO_PORT;
    dev_config.video_listen_port = VIDEO_PORt;
    dev_config.syslog_level = SYSLOG_LEVEL;
    strcpy(dev_config.server_ip, self.serverIP.UTF8String);
    
    // 0:success
    int result = devavtp_init(&dev_config);
    NSLog(@"DevicedId=%d Port=%d Serverip=%s result=%d", dev_config.deviceId, dev_config.audio_listen_port, dev_config.server_ip, result);

    return result ? NO : YES;
    
}


/** 音视频传输配置 */
- (BOOL)jl_devavtp_config_Check
{
    devavtp_config_t dev_config;
    dev_config.deviceId = deviceNum;
    dev_config.audio_listen_port = AUDIO_PORT;
    dev_config.video_listen_port = VIDEO_PORt;
    dev_config.syslog_level = SYSLOG_LEVEL;
    strcpy(dev_config.server_ip, self.serverIP.UTF8String);
    printf("----%s", self.serverIP.UTF8String);
    
    // 0:success
    int result = devavtp_config(&dev_config);
    DLog(@"result=%d",result);

    return result ? NO : YES;
}


#pragma mark - LCLocationDelegate

- (void)didUpdateLocation:(CLLocation *)location address:(NSString *)address {
    
    self.waterTxtArr = [@[@"time",
                         [NSString stringWithFormat:@"RNO：%@", _reportNum],
                         [NSString stringWithFormat:@"GPS：%f,%f", location.coordinate.latitude, location.coordinate.longitude],
                         [NSString stringWithFormat:@"地址：%@", address]] mutableCopy];
    NSString *GPS = [NSString stringWithFormat:@"%.8f'%.8f'", location.coordinate.latitude, location.coordinate.longitude];
    jinglian_gps_info_notify((char*)GPS.UTF8String);

}




- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}


@end
