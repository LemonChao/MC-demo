#ifndef _JL_NET_SDK_H_
#define _JL_NET_SDK_H_

#ifdef __cplusplus
extern "C" {
#endif

#ifdef WIN32

#ifdef JLNETSDK_EXPORTS
#define NET_SDK_API __declspec(dllexport) 
#else
#define NET_SDK_API __declspec(dllimport)
#endif

#ifndef STDCALL
#define STDCALL __stdcall
#endif

#endif

//////////////////////////////////////////////////////////////////////////
//宏定义
#define JL_MAX_IPADDR_LEN           32
#define JL_MAX_NAME_LEN				32
#define JL_MAX_CFGDATA_LEN          256
#define JL_MAX_FILEPATH_LEN          128

#define JL_MAX_SERIALNO_LEN 			32	// 设备序列号字符长度
#define JL_MAX_REPORTNO_LEN 			32	// 报案号长度
#define JL_MAX_PLATENO_LEN 				16	// 车牌号长度

//定损回复结果
typedef enum
{
	JL_ChargeRsp_Ok = 0,		//接收定损
	JL_ChargeRsp_NoFree,		//无空闲定损员
	JL_ChargeRsp_NotAnswer,		//无人接听
	JL_ChargeRsp_Refuse,		//定损员拒接
}JL_ChargeRspResult;

//定损完成结果
typedef enum
{
	JL_ChargeRet_Complete = 0,		//定损完成
	JL_ChargeRet_WaitAddition,		//待补充
	JL_ChargeRet_Break,				//定损中断
	JL_ChargeRet_Timeout,			//定损员操作超时
}JL_ChargeCompleteResult;

//////////////////////////////////////////////////////////////////////////
//结构

// 实时媒体交换类型
typedef enum
{
	JL_MSType_None = 0,			// 单向视频接收
	JL_MSType_Simplex_Rcv = 1,	//单向接收，用于主叫请求被叫的码流，如视频浏览，音频监听等
	JL_MSType_Simplex_Snd = 2 ,	//单向发送，用于主叫推送码流给被叫，如视频广播，喊话等
	JL_MSType_Duplex,			// 双向交换
} JL_MediaSwitchType;

// 设备信息
typedef struct
{
	char	achSerialNumber[JL_MAX_SERIALNO_LEN];	// 序列号或设备ID号
	BYTE	byAlarmInPortNum;		// 报警输入个数
	BYTE	byAlarmOutPortNum;		// 报警输出个数
	BYTE	byDiskNum;				// 硬盘个数
	BYTE	byDevType;				// 设备类型类型
	BYTE	byVideoChanNum;			// 视频通道个数
	BYTE    byAudioChanNum;         // 语音通道数
	DWORD   dwVideoCap;				//视频能力集
	DWORD   dwAudioCap;				//音频能力集
	DWORD   dwPicCap;				//图片能力集
	BYTE    byRes1[16];				// 保留
} JL_NET_DEVINFO, *LPJL_NET_DEVINFO;


// 定损信息
typedef struct
{
	char	achReportNo[JL_MAX_REPORTNO_LEN];	// 报案号
	char	achPlateNo[JL_MAX_PLATENO_LEN];	// 车牌号
} JL_NET_CHARGEINFO, *LPJL_NET_CHARGEINFO;

////软解码预览参数
// typedef struct
// {
// 	LONG lChannel;//通道号
// 	HWND hPlayWnd;//播放窗口的句柄,为NULL表示不播放图象
// }JL_NET_CLIENTINFO, *LPJL_NET_CLIENTINFO;


//定义媒体数据类型（对应码流载荷）
typedef enum
{
	JL_MediaType_SysCtx = 1,	//系统上下文，由系统自定义
	JL_MediaType_Video,			//视频流
	JL_MediaType_Audio,			//音频流
	JL_MediaType_Mix,			//混合流
}JL_MediaDataType;


//视频编解码率
typedef enum
{
	JL_VCodec_H264 = 0,	//H.264
	JL_VCodec_MPEG4,
}JL_VCodecType;

//音频编解码率
typedef enum
{
	JL_ACodec_SPEX = 0,	//Spex
	JL_ACodec_AMR,		//AMR
	JL_ACodec_MP3,		//mp3
}JL_ACodecType;

//抓拍图片分辨率
typedef enum
{
	//安防常用
	JL_PICRES_QCIF = 1,	//176*144
	JL_PICRES_CIF,		//352*288
	JL_PICRES_D1,		//704*576

	//4:3
	JL_PICRES_QVGA =10,	//320*240
	JL_PICRES_VGA,		//640*480
	JL_PICRES_SVGA,		//800*600
	JL_PICRES_XGA,		//1024*768
	JL_PICRES_UXGA,		//1600x1200

	//视频高清
	JL_PICRES_720p = 20,//1280×720
	JL_PICRES_1080p,	//1920×1080
	
	//图片高清
	JL_PICRES_1DOT3MP = 30,	//130万象素
	JL_PICRES_2MP,			//200万象素
	JL_PICRES_3MP,			//300万象素
	JL_PICRES_5MP,			//500万象素
	JL_PICRES_8MP,			//800万象素
	JL_PICRES_1GP,			//1千万象素
}JL_PIC_RESOLUTION;

//抓拍图片质量等级
typedef enum
{
	JL_PicQlt_Highest = 0,	//最好 
	JL_PicQlt_High,			//好
	JL_PicQlt_Normal,		//一般
	JL_PicQlt_low,			//差
	JL_PicQlt_Lowest,		//最差
}JL_PIC_QUALITY;

//图片质量
typedef struct 
{
	WORD	wPicSize;			//见JL_PIC_RESOLUTION
	WORD	wPicQuality;		//JL_PIC_QUALITY
}JL_NET_JPEGPARA, *LPJL_NET_JPEGPARA;

//抓拍图片视频控制
typedef enum
{
	JL_PicSnap_VideoNormal = 0,	//正常视频
	JL_PicSnap_VideoStop,		//停止视频
	JL_PicSnapt_Auto,			//设备自适应
}JL_PICSNAP_VIDEO_CTRL;

//参数配置
typedef struct
{
	DWORD dwCfgType;	//配置参数类型
	char  chCfgData[JL_MAX_CFGDATA_LEN]; //配置数据，具体内容由应用层解析
	DWORD dwCfgDatLen;  //配置数据长度
}JL_PARAMCFG_DATA;

//////////////////////////////////////////////////////////////////////////
//消息结构

//通用回复消息
typedef struct
{
	DWORD dwResult; //回复结果，0表示登陆成功，非0代表错误码
	DWORD dwContext; //上下文 
} JL_Common_Rsp;

//登陆请求
typedef struct
{
	char chDevIp[JL_MAX_IPADDR_LEN];	//设备IP地址（外网出口地址）
	char chUserName[JL_MAX_NAME_LEN];	//用户名称
	char chAuthPwd[JL_MAX_NAME_LEN];	//认证密码
	JL_NET_DEVINFO tDeviceInfo;       //设备信息
	DWORD dwContext; //上下文 
} JL_Login_Req;
//登陆回复
typedef JL_Common_Rsp JL_Login_Rsp;

//定损请求
typedef struct
{
	JL_NET_CHARGEINFO tChargeInfo;
	DWORD dwContext; //上下文 
} JL_Charge_Req;
//定损回复
typedef JL_Common_Rsp JL_Charge_Rsp;

//媒体交换请求
typedef struct
{
	LONG lVChannel;			//视频通道号
	DWORD dwVSwitchType;	//视频媒体交换类型，见JL_MediaSwitchType
	DWORD dwVCodecType;		//视频编解码类型,见JL_VCodecType

	LONG lAChannel;			//音频通道号
	DWORD dwASwitchType;	//音频媒体交换类型，见JL_MediaSwitchType
	DWORD dwACodecType;     //音频编解码类型，见JL_ACodecType
	DWORD dwContext;		//上下文 
} JL_RealMedia_Req;

//媒体交换回复
typedef JL_Common_Rsp JL_RealMedia_Rsp;

//抓拍图片请求
typedef struct
{
	LONG lChannel;//通道号
	JL_PICSNAP_VIDEO_CTRL eVideoCtrl; //视频控制
	JL_NET_JPEGPARA tJpegPara; //图片质量
	char chClientPicFullPath[JL_MAX_FILEPATH_LEN]; //客户端图片保存全路径
	DWORD dwContext; //上下文 
} JL_DevSnapPic_Req;

//抓拍图片回复
typedef JL_Common_Rsp JL_DevSnapPic_Rsp;

// typedef struct
// {
// 	DWORD dwResult;	//抓拍结果，0成功，非零失败
// 	LONG lChannel;	//通道号
// 	DWORD dwContext;//带回用户请求时的上下文
// } JL_DevSnapPic_Rsp;


//设备参数配置请求
typedef struct
{
	JL_PARAMCFG_DATA tDevCfgData; //设备配置数据
	DWORD dwContext; //上下文 
}JL_ParamCfg_Req;

//设备参数配置回复
typedef JL_Common_Rsp JL_ParamCfg_Rsp;

//////////////////////////////////////////////////////////////////////////
//SKD接口

//初始化
NET_SDK_API BOOL STDCALL NETSDK_Init( );
//退出
NET_SDK_API BOOL STDCALL NETSDK_Cleanup();

//获取SDK的版本信息
NET_SDK_API DWORD STDCALL NETSDK_GetVersion();
//获取错误码
NET_SDK_API DWORD STDCALL NETSDK_GetLastError();

//设置接收码流的IP地址（网络序，如果部署在内网，通过Dmz等映射到外网IP地址，这里需要设置码流的入口Ip地址 )
NET_SDK_API BOOL STDCALL NETSDK_MediaIpAddrSet( u32 dwIpNetAddr );
/*===========================================================
功能： 设备登陆请求回调
参数说明：	lNodeID - 连接节点ID，唯一标示与某一路设备的连接
			ptLoginReq - 登陆请求，具体见结构体定义
			dwUserData - 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TDevLoginReqCB)(LONG lNodeID, JL_Login_Req* ptLoginReq, DWORD dwUserData );
//注册设备登陆通知回调
NET_SDK_API void STDCALL NETSDK_DevLoginReqCBReg( TDevLoginReqCB lpDevLoginReqCB, DWORD dwUserData );

/*===========================================================
功能： 设备Ip地址变化通知（外网出口Ip地址）
参数说明：	lNodeID - 连接节点ID，唯一标示与某一路设备的连接
			pchDevIp - 设备IP地址
			dwUserData - 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TDevIpChangeNtfCB)(LONG lNodeID, char *pchDevIp, DWORD dwUserData );
//注册
NET_SDK_API void STDCALL NETSDK_DevIpChangeNtfCBReg( TDevIpChangeNtfCB lpDevIpChangeNtfCB, DWORD dwUserData );

/*===========================================================
功能： 设备登陆回复
参数说明：	lNodeID - 连接节点ID，唯一标示与某一路设备的连接
			ptLoginRsp - 登陆回复，具体见结构体定义
返回值说明：无
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_DevLoginRsp(LONG lNodeID, JL_Login_Rsp* ptLoginRsp );

/*===========================================================
功能： 断开连接设备
参数说明：	lNodeID - 连接节点ID，唯一标示与某一路设备的连接
返回值说明：TRUE：成功断开；False：断开连接失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_Disconnect(LONG lNodeID);
/*===========================================================
功能： 网络连接断开通知回调
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			pchDevIp -	断开设备IP地址
			wPort -		断开设备端口
			dwUserData- 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TDisconnectNtfCB)(LONG lNodeID, char *pchDevIp, WORD wPort, DWORD dwUserData);
//注册网络断链通知回调
NET_SDK_API void STDCALL NETSDK_DisconnectNtfCBReg( TDisconnectNtfCB lpDisconnectCB, DWORD dwUserData );

/*===========================================================
功能： 保险业定损请求回调
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			ptChargeReq -	定损请求信息，具体见结构体定义
			dwUserData- 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TInsureChargeReqCB)(LONG lNodeID, JL_Charge_Req* ptChargeReq, DWORD dwUserData);
//注册保险业定损请求回调函数
NET_SDK_API void STDCALL NETSDK_InsureChargeReqCBReg( TInsureChargeReqCB lpInsureChargeReqCB, DWORD dwUserData );

/*===========================================================
功能： 保险业定损请求回复
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			ptChargeRsp -	定损信息，具体见结构体定义，回复结果见JL_ChargeRspResult
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_InsureChargeRsp(LONG lNodeID, JL_Charge_Rsp* ptChargeRsp );
 
/*===========================================================
功能： 完成定损
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			lpChargeInfo -	定损信息，具体见结构体定义 
			dwResult- 定损回复结果，0表示成功，非0代表错误码 见JL_ChargeCompleteResult
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_InsureChargeComplete(LONG lNodeID, LPJL_NET_CHARGEINFO lpChargeInfo, u32 dwResult );

/*===========================================================
功能： 保险业定损中断通知
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			dwUserData- 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TInsureChargeBreakNtfCB)(LONG lNodeID, DWORD dwUserData);
//注册保险业定损中断通知
NET_SDK_API void STDCALL NETSDK_InsureChargeBreakNtfCBReg( TInsureChargeBreakNtfCB lpInsureChargeBreakNtfCB, DWORD dwUserData );


/*===========================================================
功能： 实时媒体数据回调
参数说明：	lMediaHandle -	媒体数据句柄，唯一标示指定的媒体交换
			dwDataType - 媒体数据类型, 视频，音频，音视频混合流，原始数据等，见JL_MediaDataType
			pBuffer - 媒体数据
			dwBufSize - 数据缓冲大小
			dwUserData - 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TRealMediaDataCB)(LONG lMediaHandle, DWORD dwDataType, char *pBuffer, DWORD dwBufSize, DWORD dwUserData);
//注册实时媒体数据回调
NET_SDK_API void STDCALL NETSDK_RealMediaDataCBReg( TRealMediaDataCB lpRealMediaDataCB, DWORD dwUserData );

/*===========================================================
功能： 发送实时媒体数据到设备
参数说明：	lMediaHandle -	媒体数据句柄，唯一标示指定的媒体交换
			dwDataType - 媒体数据类型, 视频，音频，音视频混合流，原始数据等，见JL_MediaDataType
			pSendBuf - 发送媒体数据
			dwBufSize - 数据缓冲大小
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_RealMediaDataSend(LONG lMediaHandle, DWORD dwDataType, char *pSendBuf, DWORD dwBufSize );

/*===========================================================
功能： 开始实时媒体交换回复
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			lMediaHandle - 带回媒体交换标示
			ptMediaRsp -媒体回复信息，具体见结构体定义
			dwUserData -用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TRealMediaStartRspCB)(LONG lNodeID, LONG lMediaHandle, JL_RealMedia_Rsp* ptMediaRsp, DWORD dwUserData );
//注册开始实时媒体交换回复
NET_SDK_API void STDCALL NETSDK_RealMediaStartRspCBReg( TRealMediaStartRspCB lpRealMediaStartRspCB, DWORD dwUserData );

/*===========================================================
功能： 开始实时媒体交换请求
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			ptMediaReq -媒体请求信息，具体见结构体定义
			dwUserData- 用户数据，媒体数据回调时带回的用户数据
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_RealMediaStartReq(LONG lNodeID, JL_RealMedia_Req* ptMediaReq );


/*===========================================================
功能：修改媒体交换回复
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			lNewMediaHandle - 修改后的媒体交换标示，替换原有媒体交换标示
			ptMediaRsp -媒体回复信息，具体见结构体定义
			dwUserData -用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TRealMediaMdfRspCB)(LONG lNodeID, LONG lNewMediaHandle, JL_RealMedia_Rsp* ptMediaRsp, DWORD dwUserData );
//注册修改媒体交换回复
NET_SDK_API void STDCALL NETSDK_RealMediaMdfRspCBReg( TRealMediaMdfRspCB lpRealMediaMdfRspCB, DWORD dwUserData );

/*===========================================================
功能： 修改媒体交换请求
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			lMediaHandle - 媒体交换标示
			ptMediaReq -媒体请求信息，具体见结构体定义
			dwUserData- 用户数据，媒体数据回调时带回的用户数据
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_RealMediaMdfReq(LONG lNodeID, LONG lMediaHandle, JL_RealMedia_Req* ptMediaReq );


/*===========================================================
功能： 停止媒体交换
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			lMediaHandle -	媒体交换标示，媒体请求函数返回的标示值
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_StopRealMedia(LONG lNodeID, LONG lMediaHandle);

// /*===========================================================
// 功能： 文件传输数据回调
// 参数说明：	lFileHandle -	文件传输句柄，唯一标示一路文件传输
// 			lTransType - 传输类型, 抓拍上传，文件下载传输等，见
// 			pBuffer - 文件数据
// 			dwBufSize - 数据缓冲大小
// 			lState - 当前状态，0标示正常传输，非0标示传输异常错误标示
// 			lSendSize - 已发送字节数
// 			lTotalSize - 文件总大小
// 			dwUserData - 用户数据，注册回调函数时提供
// 返回值说明：无
// ===========================================================*/
// typedef void (CALLBACK *TFileTransDataCB)(LONG lFileHandle, LONG lTransType, char *pBuffer, DWORD dwBufSize,
// 										  LONG lState, LONG lSendSize, LONG lTotalSize, DWORD dwUserData );
// //注册
// NET_SDK_API void STDCALL NETSDK_FileTransDataCBReg( TFileTransDataCB lpFileTransDataCB, DWORD dwUserData );


/*===========================================================
功能： 抓拍图片文件传输数据回调(含文件数据及传输控制信令) (用于文件传输转发，不能与抓拍图片文件传输进度回调同时注册!!!)
参数说明：	lFileHandle -	文件传输句柄，唯一标示一路文件传输
			pBuffer - 文件数据
			dwBufSize - 数据缓冲大小
			dwUserData - 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TPicFileTransDataCB)(LONG lFileHandle, char *pBuffer, DWORD dwBufSize, DWORD dwUserData );
//注册(用于文件传输转发，不能与抓拍图片文件传输进度回调同时注册!!!)
NET_SDK_API void STDCALL NETSDK_PicFileTransDataCBReg( TPicFileTransDataCB lpFileTransDataCB, DWORD dwUserData );

//抓拍图片文件传输进度回调(用于点到点文件传输，不能与抓拍图片文件传输数据回调同时注册!!!)
typedef void (CALLBACK *TPicFileTransProgressCB)(LONG lFileHandle, LONG lResult, LONG lProgress, LONG lContext);
//注册(用于文件传输转发，不能与抓拍图片文件传输数据回调同时注册!!!)
NET_SDK_API void STDCALL NETSDK_PicFileProgressCBReg( TPicFileTransProgressCB lpFileProgressCB, DWORD dwUserData );

/*===========================================================
功能： 发送图片文件传输数据到设备
参数说明：	lFileHandle -	文件传输句柄，唯一标示指定的媒体交换
			pSendBuf - 发送数据
			dwBufSize - 数据缓冲大小
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_PicFileTransDataSend(LONG lFileHandle, char *pSendBuf, DWORD dwBufSize );


/*===========================================================
功能： 设备抓拍图片回复回调函数
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			lFileHandle - 分配的文件传输句柄，唯一标示一路文件传输
			ptDevSnapPicRsp - 回复信息，具体见结构体定义
			dwUserData - 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TDevSnapPicRspCB)(LONG lNodeID, LONG lFileHandle, JL_DevSnapPic_Rsp* ptDevSnapPicRsp, DWORD dwUserData );
//注册
NET_SDK_API void STDCALL NETSDK_DevSnapPicRspCBReg( TDevSnapPicRspCB lpDevSnapPicRspCB, DWORD dwUserData );

/*===========================================================
功能： 设备图像抓拍请求
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			ptDevSnapPicReq - 请求信息，具体见结构体定义
返回值说明：TRUE：发送消息成功；False：发送消息失败
备注：建立文件传输通道请求，不需要暴露接口给上传，由底层信令通信模块自动进行握手
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_DevSnapPicReq(LONG lNodeID, JL_DevSnapPic_Req* ptDevSnapPicReq );

/*===========================================================
功能： 配置回复回调函数
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			ptParamCfgRsp - 配置回复信息，具体见结构体定义
			dwUserData - 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TParamCfgRspCB)(LONG lNodeID, JL_ParamCfg_Rsp* ptParamCfgRsp, DWORD dwUserData );
//注册
NET_SDK_API void STDCALL NETSDK_ParamCfgRspCBReg( TParamCfgRspCB lpParamCfgRspCB, DWORD dwUserData );

/*===========================================================
功能： 设备参数配置请求
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			ptParamCfgReq -  配置请求信息，具体见结构体定义
			dwUserData - 用户数据，回复回调和文件数据回调时带回的用户数据
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_ParamCfgReq(LONG lNodeID, JL_ParamCfg_Req* ptDevCfgReq );

/*===========================================================
功能： 配置参数修改通知回调函数
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			ptParamMdfNtf - 配置回复信息，具体见结构体定义
			dwUserData - 用户数据，注册回调函数时提供
返回值说明：无
===========================================================*/
typedef void (CALLBACK *TParamMdfNtfCB)(LONG lNodeID, JL_PARAMCFG_DATA* ptParamMdfNtf, DWORD dwUserData );
//注册
NET_SDK_API void STDCALL NETSDK_ParamMdfNtfCBReg( TParamMdfNtfCB lpParamMdfNtfCB, DWORD dwUserData );


/*===========================================================
功能： 发送透明数据命令
参数说明：	lNodeID -	连接节点ID，唯一标示与某一路设备的连接
			pDataBuf -  透明数据
			dwDataLen - 透明数据长度
返回值说明：TRUE：发送消息成功；False：发送消息失败
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_TransparentDataSend(LONG lNodeID, char *pDataBuf, DWORD dwDataLen );



//PTZ
//设备维护


#ifdef __cplusplus
}
#endif

#endif //_JL_NET_SDK_H_
