//
//  WCLRecordVideoVC.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/9/3.
//  Copyright © 2016年 zp. All rights reserved.
// 博客地址：http://blog.csdn.net/wang631106979/article/details/51498009

#import "WCLRecordVideoVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

#import "RTAVSession.h"
#import "RTAVVideoConfiguration.h"

//Audio
#import "MCAudioInputQueue.h"

#import <AVFoundation/AVAudioSession.h>
#import "MCSimpleAudioPlayer.h"
#import "MessageView.h"
//static const NSTimeInterval bufferDuration = 0.02;

typedef NS_ENUM(NSUInteger, UploadVieoStyle) {
    VideoRecord = 0,
    VideoLocation,
};

typedef NS_ENUM(NSInteger, DEV_SNAP_STATUS) {
    DEV_SNAP_STATUS_UNABLE = 0,         //不可用，未被授权， 隐藏不可见
    DEV_SNAP_STATUS_ENABLE = 1,         //可用，得到授权， 点击拍照
    DEV_SNAP_STATUS_SNAPING = 2,        //相机正在拍照， 隐藏不可见。防止用户连续点击
    DEV_SNAP_STATUS_TRANSPORT = 3,      //图片正在传输， 拍照成功，正在传输
};


@interface WCLRecordVideoVC ()<ActivityAppDelegate>
{
    RTAVSession  * session;
    
    short send_audio_seq;       // 标记音频帧序
    BOOL is_streaming;          // 标记音频流状态
    
    Byte sendBuf[160];
    int sendBufOffset;
    
@private
    AudioStreamBasicDescription _format;
    BOOL _inited;
    
    BOOL _started;
    
    NSMutableData *_data;
    
    //
    MCSimpleAudioPlayer *_player;
    
    
    //take picture
    BOOL mIsSnaping;    //标记拍照状态从点击拍照按钮-照片保存完成
    BOOL mIsTransfAble;  //发送图片前判断是否可以传输
    BOOL mIsDevSnap;    //和授权相关，YES取得授权，
    NSString *mAuthPath;
    NSInteger mAuthPhotoLevel;
    NSDictionary *mAuthTaking;
    
    ActivityApp *activApp;
    
    
}

@property (assign, nonatomic) BOOL                    allowRecord;//允许录制
@property (assign, nonatomic) UploadVieoStyle         videoStyle;//视频的类型

@property (assign, nonatomic) DEV_SNAP_STATUS mDevSnapStatus; //拍照按钮的四种状态

@property (nonatomic, strong) UIButton *snapButton;

@property (nonatomic, strong) UILabel *procressLab;

//弹出消息视图
@property (nonatomic, strong) MessageView *msgView;
//坐席名称
@property (strong, nonatomic) UILabel *clientNameLab;

@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIButton *modeButton;


@end



@implementation WCLRecordVideoVC

static char mPicName[1024] = {0};


- (void)dealloc {
    
    //音频的dealloc
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self removeObserver:self forKeyPath:@"mDevSnapStatus"];
    DLog(@"%@ dealloc", [self class]);
    Speex_close();

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self _startRecord];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    activApp.sCurrentState = STATE_ONLINE;
    [self _stopRecord];
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor yellowColor];
    // 博客地址：http://blog.csdn.net/wang631106979/article/details/51498009
    
    [self configurationOfInit];
    
    [self openChannelWithCallBackInfo];
    
    Speex_open(3);
    
    
    Speex_setMicWaveScale(100);
    Speex_setSpeakerWaveScale(100);
    
    self.allowRecord = YES;
    

    [self initMainView];

    //KVO
    [self addObserver:self forKeyPath:@"mDevSnapStatus" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
}


- (void)initMainView {
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeFouces:)]];
    self.view.userInteractionEnabled = YES;
    
    UIButton *snapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    snapBtn.frame = CGRectMake(10, 100, 68, 68);
    [snapBtn setImage:[UIImage imageNamed:@"publishPlayVideoBig"] forState:UIControlStateNormal];
//    snapBtn.backgroundColor = [UIColor greenColor];
    [snapBtn addTarget:self action:@selector(snapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    snapBtn.hidden = YES;
    [self.view addSubview:snapBtn];
    self.snapButton = snapBtn;
    [snapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(68, 68));
        make.centerY.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];

    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:leftView];
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(40);
    }];
    
    UILabel *titleLab = [LCTools createLable:self.ChargeReqDic[@"AgentNo"] withFont:kFontSize17 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:titleLab];
    self.clientNameLab = titleLab;
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(leftView.right).offset(10);
    }];
    
    UIButton *modeBtn = [LCTools createWordButton:UIButtonTypeCustom title:@"自动模式" titleColor:[UIColor whiteColor] font:kFontSize17 bgColor:nil cornerRadius:3.0f borderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] borderWidth:0.7f];
    [modeBtn addTarget:self action:@selector(modeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _modeButton = modeBtn;
    [self.view addSubview:modeBtn];
    [modeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"charge_set"] forState:UIControlStateNormal];
    [self.view addSubview:setBtn];
    [setBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView);
        make.right.equalTo(leftView);
        make.top.equalTo(10);
        make.height.equalTo(40);
    }];
    
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceBtn setImage:[UIImage imageNamed:@"charge_volume"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(voiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _voiceButton = voiceBtn;
    [self.view addSubview:voiceBtn];
    [voiceBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView);
        make.right.equalTo(leftView);
        make.top.equalTo(setBtn.bottom).offset(15);
        make.height.equalTo(40);
    }];

    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashBtn setImage:[UIImage imageNamed:@"charge_flash"] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(flashButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _flashButton = flashBtn;
    [self.view addSubview:flashBtn];
    [flashBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView);
        make.right.equalTo(leftView);
        make.top.equalTo(voiceBtn.bottom).offset(15);
        make.height.equalTo(40);
    }];

    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"charge_exit"] forState:UIControlStateNormal];
    [exitBtn addTarget:session action:@selector(exitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _exitButton = exitBtn;
    [self.view addSubview:exitBtn];
    [exitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView);
        make.right.equalTo(leftView);
        make.top.equalTo(flashBtn.bottom).offset(15);
        make.height.equalTo(40);
    }];

    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setImage:[UIImage imageNamed:@"charge_up"] forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(upButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _upButton = upBtn;
    [self.view addSubview:upBtn];
    [upBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView);
        make.right.equalTo(leftView);
        make.top.equalTo(exitBtn.bottom).offset(15);
        make.height.equalTo(40);
    }];

    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setImage:[UIImage imageNamed:@"charge_down"] forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    downBtn.hidden = YES;
    _downButton = downBtn;
    [self.view addSubview:downBtn];
    [downBtn makeConstraints:^(MASConstraintMaker *make) { //the same as voiceBtn
        make.left.equalTo(leftView);
        make.right.equalTo(leftView);
        make.top.equalTo(setBtn.bottom).offset(15);
        make.height.equalTo(40);
    }];

}


- (void)dismissViewControllerByRelease:(UIButton *)backBtn {
    [self alertWithResponse:^(BOOL didCancel) {
    }];
    
}


- (void)alertWithResponse:(void (^)(BOOL didCancel))response {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示！", "提示！") message:NSLocalizedString(@"正在定损等待中\n确定要退出吗", "") preferredStyle:UIAlertControllerStyleAlert];
    @WeakObj(self);
    UIAlertAction *cancelar = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", "确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        devOnlineAction(1, 1, "定损结束");
//        activApp.sCurrentState = STATE_ONLINE;
//        Speex_close();
        [alertController dismissViewControllerAnimated:YES completion:^{
        }];
        
        [selfWeak.navigationController popViewControllerAnimated:YES];
        
        if (_completeBlock) {
            _completeBlock();
        }
        

    }];
    [alertController addAction:cancelar];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", "取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



/** 音频传输初始化配置 */
- (void)configurationOfInit
{
    activApp = [ActivityApp shareActivityApp];
    activApp.delegate = self;
    self.mDevSnapStatus = DEV_SNAP_STATUS_UNABLE;
    
    is_streaming = false;
    send_audio_seq = 0;
    
    sendBufOffset = 0;
}

/**
 设置音视频传输通道
 */
- (void)openChannelWithCallBackInfo{
    short audioPort = 0;
    short videoPort = 0;
    
    NSDictionary *tCallerVRcvAddr = [self.ChargeReqDic objectForKey:@"m_tCallerVRcvAddr"];
    NSDictionary *tCallerARcvAddr = [self.ChargeReqDic objectForKey:@"m_tCallerARcvAddr"];
    audioPort = (short)[[tCallerARcvAddr objectForKey:@"m_wPort"] intValue];
    videoPort = (short)[[tCallerVRcvAddr objectForKey:@"m_wPort"] intValue];
    
    DLog(@"audioPort = %d, videoPort = %d", audioPort, videoPort);
    devavtp_open_channel(audioPort, videoPort);
    
    
}


- (void)sendGPSInfo{
    
    
    DLog(@"gpsInfo");
}

- (void)onDestory{
    // is_streaming = NO 传输通道建立，数据传输开始的标记
    
    // stopPreView
    
    Speex_close();
    
    // close h.264 code
    
    // stop GPS listener
    
    
}




/** 录像功能参数设置 */
- (void)start_preView {
    
    // camera.open
    // faild if (mIsSnaping)
    jinglian_charge_pic_filedata_send(0, 0, "defaultPath", 1);
    
}

// KVO 监测
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    printf("%s",[[NSString stringWithFormat:@"---receive by %@ --\n"@"object = %@, path = %@\n"@"change = %@\n", self, object, keyPath, change] UTF8String]);
    NSInteger new = [change[@"new"] integerValue];
    
    [self snapButtonRefreshUIWith:new];
    
}




/**
 拍照完成
 */
- (void)mPictureCallBack {
    //1. saveFile
    //2.
    NSNumber *mIsSnaoing;
    @synchronized (mIsSnaoing) {
        mIsSnaoing = @0;
    };
}

- (void)takePicture {

}

//- (void)cancelFileTransf {
//    
//    if (mIsDevSnap) {
//        if (_mDevSnapStatus == DEV_SNAP_STATUS_TRANSPORT) {
//            devCancelFileTransf();
//        }else if (_mDevSnapStatus == DEV_SNAP_STATUS_SNAPING) {
//            mIsTransfAble = NO;
//        }
//        self.mDevSnapStatus = //DEV_SNAP_STATUS_ENABLE;
//        
//    }else {
//        if (mIsSnaping) {
//            mIsTransfAble = NO;
//        }
//        
//    }
//}


#pragma mark - 各种点击事件

- (void)downButtonAction:(UIButton *)button {
    _downButton.hidden = YES;
    _voiceButton.hidden = NO;
    _flashButton.hidden = NO;
    _exitButton.hidden = NO;
    _upButton.hidden = NO;
    
}

- (void)voiceButtonAction:(UIButton *)button {
    
}

- (void)flashButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    [session.videoCapture openFlashWith:button];
}

- (void)exitButtonAction:(UIButton *)button {
    [self alertWithResponse:^(BOOL didCancel) {
    }];

}

- (void)upButtonAction:(UIButton *)button {
    _downButton.hidden = NO;
    _voiceButton.hidden = YES;
    _flashButton.hidden = YES;
    _exitButton.hidden = YES;
    _upButton.hidden = YES;
    
}

- (void)modeButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [button setTitle:@"微距模式" forState:(UIControlStateNormal)];
    }else{
        [session.videoCapture setFocusWithNeed:button.selected];
        [button setTitle:@"自动模式" forState:(UIControlStateNormal)];
    }

}



- (void)changeFouces:(UITapGestureRecognizer *)tap{
    if (_modeButton.selected) {//微距模式, 手动对焦
        CGPoint point = [tap locationInView:self.view];
        [session.videoCapture changeFocusWith:CGPointMake(point.x/SCREEN_WIDTH, point.y/SCREEN_HIGHT)];
    }else{//自动模式, 对焦在中心点
        return;
    }
}


//点击拍照按钮
- (void)snapButtonClick:(UIButton *)sender {
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    unsigned int tsInt = [[NSNumber numberWithDouble:nowtime] unsignedIntValue];
    
    DLog(@"拍摄照片%d", tsInt);
    /**
     snapButton 在四种状态下点击有不同的响应
     @param state
     */
    switch (_mDevSnapStatus) {
        case DEV_SNAP_STATUS_UNABLE:
        {
            DLog(@"unbelieveable");
        }
            break;
            
        case DEV_SNAP_STATUS_ENABLE:
        {
            DLog(@"session takePic");
            self.mDevSnapStatus = DEV_SNAP_STATUS_SNAPING;
            
            [session takePholtoWithParam:mAuthTaking imageUrl:^(char *path) {
                strcpy(mPicName, path);
                printf("picName====%s\n", mPicName);
                self.mDevSnapStatus = DEV_SNAP_STATUS_TRANSPORT;
            }];

        }
            break;
        case DEV_SNAP_STATUS_SNAPING:
        {
            DLog(@"unbelieveable - snaping");
        }
            break;
        case DEV_SNAP_STATUS_TRANSPORT:
        {
            DLog(@"cancel transport");
            NSLog(@"mPicName:%s", mPicName);
            devCancelFileTransf();

            devCancelTransfNtf(mPicName);
            //延时0.8s 再改变状态
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.mDevSnapStatus = mIsDevSnap ? DEV_SNAP_STATUS_ENABLE : DEV_SNAP_STATUS_UNABLE;
            });

        }
            break;
        default:
            break;
    }

    
}
- (void)erwerd:(int )index imageUrl:(void (^)(NSString *path))task {
    
}

/**
 * 拍照按钮刷新UI -不要主动调用，通过KVO触发
 */
- (void)snapButtonRefreshUIWith:(DEV_SNAP_STATUS)state {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch (state) {
            case DEV_SNAP_STATUS_UNABLE:
            {
                DLog(@"button hidden");
                [self.snapButton setImage:[UIImage imageNamed:@"publishPlayVideoBig"] forState:UIControlStateNormal];
                self.snapButton.hidden = YES;
            }
                break;
                
            case DEV_SNAP_STATUS_ENABLE:
            {
                DLog(@"button appera with taking IMG");
                [self.snapButton setImage:[UIImage imageNamed:@"publishPlayVideoBig"] forState:UIControlStateNormal];
                self.snapButton.hidden = NO;
                
            }
                break;
            case DEV_SNAP_STATUS_SNAPING:
            {
                DLog(@"hidden");
                [self.snapButton setImage:[UIImage imageNamed:@"videoPause"] forState:UIControlStateNormal];
                self.snapButton.hidden = YES;
            }
                break;
                
            case DEV_SNAP_STATUS_TRANSPORT:
            {
                DLog(@"button appera with cancel IMG");
                [self.snapButton setImage:[UIImage imageNamed:@"videoPause"] forState:UIControlStateNormal];
                self.snapButton.hidden = NO;
            }
                break;
                
            default:
                break;
        }

    });
    
    
}

#pragma mark - ActivityAppDelegate

/** 得到授权/被取消授权 */
- (void)activityApp:(ActivityApp *)avtivityApp devSnapAuth:(BOOL)isAuth WithParamDictionary:(NSDictionary *)paramDic {
    if (mIsSnaping) { //正在拍照中，直接回应
        if (isAuth) {
            jinglian_auth_snap_rsp(1);
        }else {
            jinglian_cancel_auth_snap_rsp(1);
        }
        return;
    }
    
    if (isAuth) {
        mAuthTaking = paramDic;
        mIsDevSnap = YES;
        jinglian_auth_snap_rsp(0);
        self.mDevSnapStatus = DEV_SNAP_STATUS_ENABLE;
    }else { //取消授权
        mIsDevSnap = NO;
        mIsTransfAble = NO;
        if (_mDevSnapStatus == DEV_SNAP_STATUS_TRANSPORT) { //如果正在传输，则取消
            devCancelFileTransf();
        }
        jinglian_cancel_auth_snap_rsp(0);
        self.mDevSnapStatus = DEV_SNAP_STATUS_UNABLE;
    }

    
    
}

/** 发送图片的进度 */
- (void)activityApp:(ActivityApp *)activityApp sendPhotoProcess:(NSString *)process {
    DLog(@"process%@",process);
    self.mDevSnapStatus = DEV_SNAP_STATUS_TRANSPORT;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:StrFormat(@"当前传输%@%%", process) duration:0.5 position:CSToastPositionTop];
    });
    
}


/** 单张图片传输完成 */
- (void)activityApp:(ActivityApp *)activityApp cancelFileComolete:(BOOL)isComplete {
    self.mDevSnapStatus = mIsDevSnap ? DEV_SNAP_STATUS_ENABLE : DEV_SNAP_STATUS_UNABLE;
}


/** 单张图片传输失败 */
- (void)activityAppSendPhotoFailed:(ActivityApp *)activityApp {
    self.mDevSnapStatus = mIsDevSnap ? DEV_SNAP_STATUS_ENABLE : DEV_SNAP_STATUS_UNABLE;
}

/** 取消传输 */
- (void)activityAppCancelFileTransf:(ActivityApp *)activityApp {
    
    if (mIsDevSnap) { //获得授权中
        if (_mDevSnapStatus == DEV_SNAP_STATUS_TRANSPORT) {
            devCancelFileTransf();
            devCancelTransfNtf(mPicName);
        }else if (_mDevSnapStatus == DEV_SNAP_STATUS_SNAPING) {
            mIsTransfAble = false;
        }
        self.mDevSnapStatus = DEV_SNAP_STATUS_ENABLE;
    }else {
        if (mIsSnaping) { //摄像头正在拍照中
            mIsTransfAble = false;
        }else {
            devCancelFileTransf();
        }
        self.mDevSnapStatus = DEV_SNAP_STATUS_UNABLE;
    }
    
    // 取消传输百分比
    
}

/** 坐席主动拍照 */
- (void)activityApp:(ActivityApp *)activityApp SnapPicWithParam:(NSDictionary *)ParamDic {
    NSLog(@"SnapPicParam=%@", ParamDic);
    
    [session takePholtoWithParam:ParamDic clientblock:^(char *path) {
        strcpy(mPicName, path);
        printf("picName====%s\n", mPicName);

        self.mDevSnapStatus = DEV_SNAP_STATUS_TRANSPORT;
    }];
    
}

/** 定损结束 */
- (void)activityAppChargeComplete:(ActivityApp *)activityApp {
    
    DLog(@"==============================================");
    dispatch_async(dispatch_get_main_queue(), ^{
        //devOnlineAction(1, 1, "定损结束");
        activityApp.sCurrentState = STATE_ONLINE;
        [self.navigationController popViewControllerAnimated:YES];
        if (_completeBlock) {
            _completeBlock();
        }
        
    });

    
}

/** 透明通道 */
- (void)activityApp:(ActivityApp *)activityApp SeatsInstructParam:(NSDictionary *)param{
    NSInteger hg =  [@[@"zoom", @"videoswitch", @"textdirective", @"zone", @"chargetrans"]indexOfObject:param[@"utility"]];
    switch (hg) {
        case 0://缩放视频
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stretchTheLensWithZoom:[param[@"param"] intValue]];
            });
        }
            break;
        case 1://打开关闭视频
        {
            
        }
            break;
        case 2://文字指令
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *text = param[@"param"];
                if (text.length == 0||[text isEqualToString:@""]||[text isKindOfClass:[NSNull class]]) {
                    return;
                }
                [self createMsgViewWith:text];
            });
        }
            break;
        case 3://框定范围
        {
            NSDictionary *dic = param[@"param"];
            CGFloat x1 = [dic[@"xlt"] doubleValue];
            CGFloat y1 = [dic[@"ylt"] doubleValue];
            CGFloat x2 = [dic[@"xbr"] doubleValue];
            CGFloat y2 = [dic[@"ybr"] doubleValue];
            if ((x1 >= 0 && x1 <= 1) && (y1 >= 0 && y1 <= 1)
                && (x2 >= 0 && x2 <= 1) && (y2 >= 0 && y2 <= 1)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self limitCircleWithxlt:x1 ylt:y1 xbr:x2 ybr:y2];
                });
            } else {
                return;
            }
        }
            break;
        case 4://转接
        {
            
        }
        default:
            break;
    }
}


/**
 显示文字指令

 @param text 文字指令
 */
- (void)createMsgViewWith:(NSString *)text{
    if (_msgView) {
        [_msgView  removeFromSuperview];
        _msgView = nil;
    }
    _msgView = [[MessageView alloc] init];
    [self.view addSubview:_msgView];
    _msgView.msgText = text;
    [_msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_clientNameLab).offset(15);
        make.top.mas_equalTo(_clientNameLab.bottom).offset(-8);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(70);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_msgView  removeFromSuperview];
        _msgView = nil;
    });
}


#pragma mark - 圈定范围
- (void)limitCircleWithxlt:(CGFloat)xlt ylt:(CGFloat)ylt xbr:(CGFloat)xbr ybr:(CGFloat)ybr{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xlt * SCREEN_WIDTH, ylt * SCREEN_HIGHT, (xbr - xlt) * SCREEN_WIDTH, (ybr - ylt) * SCREEN_HIGHT)];
    [self.view addSubview:view];
    [LCTools drawDashLine:view lineLength:1 lineSpacing:2 lineColor:[UIColor whiteColor]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
    });
}


#pragma mark - 拉伸镜头
- (void)stretchTheLensWithZoom:(int)zoom{
    if (zoom >= 0 && zoom <= 100) {//(0 - 100拉伸镜头)
        [session.videoCapture tensileLes:0.01 * zoom];
    }
}
/*******************************音频录制**********************************/
/** 音频录制发包，收包播放 && 视频录制*/
- (void)_startRecord
{
    if (!_player)
    {
        _player = [[MCSimpleAudioPlayer alloc] initWithFilePath:@"Useless" fileType:kAudioFileMP3Type];
        
    }
    [_player play];

    // 视频录制发送
    session = [[RTAVSession alloc]initWithRTAVVideoConfiguration:[RTAVVideoConfiguration defaultConfigurationForQuality:kRTVideoQuality_Common_Medium]]; //640x480
    
    session.preView = self.view;
    
    session.running = YES;

    //加上后扬声器声音明显大了些
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

/** 音频录制发包，收包播放*/
- (void)_stopRecord {
    [_player cleanup];
    [_player stop];
    _player = nil;
    session.running = NO;
    session = nil;
    
}

/** 停止录制 关闭文件夹*/
#pragma mark - interrupt
- (void)_interrupted:(NSNotification *)notification
{
//    [self _stopRecord];
    
    NSLog(@"音频打断");
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


// 是否支持屏幕自动旋转
- (BOOL)shouldAutorotate {
    
    return NO;
}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeRight;
//}
@end
