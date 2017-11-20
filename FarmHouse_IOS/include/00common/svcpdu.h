#ifndef _H_VSS_TYPES_
#define _H_VSS_TYPES_

//////////////////////////////////////////////////////////////////////////
//                       所有IP均为网络序！！！                         
//////////////////////////////////////////////////////////////////////////

#define CSTRUCT

typedef u32 TNETIP; //pdu生成工具专用

typedef struct TVSSNetAddr
{
    TNETIP m_tIP;
	u16 m_wPort;

}TVSSNetAddr;

//统一对象编号
typedef struct TUOID
{
	u64 m_qwBaseID;         //所属基础对象ID
	u32 m_dwObjType;		//对象类型
	u64 m_qwObjID;			//对象ID
	u32 m_dwExtType;
}TUOID;

//通用消息头
typedef struct TVSSCommMsgHead
{
	u32 m_dwMagic;        //幻数：用来做网络收发消息的校验，避免极小概率的网络消息包的重复
	u64 m_qwVer;          //版本号
	u32 m_dwMsgType;      //消息类型
	u32 m_dwMsgSeqNum;    //消息序列号
	u32 m_dwTransID;      //事务ID
	u32 m_dwErrCode;      //错误码
    CSTRUCT TUOID m_tDstID;       //消息目的，暂不使用
	u32 m_dwDstSapName;   //目的Sap名称
    CSTRUCT TUOID m_tSrcID;       //消息源, 暂不使用
	u32 m_dwSrcSapName;   //源Sap名称
	u32 m_dwMsgBodyLen;   //消息体长度
	u32 m_dwReserve1;     //保留字段
	u32 m_dwReserve2;
	u32 m_dwReserve3;
	u32 m_dwReserve4;
	u32 m_dwReserve5;
	u32 m_dwReserve6;
	u32 m_dwReserve7;
	u32 m_dwReserve8;
}TVSSCommMsgHead;

//对象基本属性
typedef struct TVSSObjBasic
{
    CSTRUCT TUOID m_tObjUOID;    //对象统一编号
    CSTRUCT TUOID m_tParentUOID; //父亲对象统一编号
	u32 m_dwHasSon;      //是否有子节点
	u32 m_dwObjNameLen;
	char m_achObjName[VSS_NAME_MAXLEN];  //对象名称
	u32 m_dwDescLen;
	char m_achDesc[VSS_NAME_MAXLEN];     //描述
}TVSSObjBasic;

//设备登陆信息
typedef struct TVSSLoginInfo
{
	u32 m_dwNameLen;
	char m_szUserName[VSS_NAME_MAXLEN];
	u32 m_dwPswLen;
	char m_abyPsw[VSS_PSW_MAXLEN];
}TVSSLoginInfo;

//设备登陆信息
typedef struct TVSSDevLoginInfo
{
	CSTRUCT TUOID m_tDevUOID;
	CSTRUCT TUOID m_tAccessID;     //接入ID
	u32  m_dwLoginNameLen;
	char m_achLoginName[VSS_NAME_MAXLEN];
	u32  m_dwLoginPswLen;
	char m_achLoginPsw[VSS_PSW_MAXLEN];
	CSTRUCT TVSSNetAddr m_tNetAddr;
	u32 m_dwURLLen;   //URL长度
	char m_achURL[VSS_URL_MAXLEN];

}TVSSDevLoginInfo;

// //设备扩展信息
// typedef struct TVSSDevExtInfo
// {
// 	CSTRUCT TVSSDevLoginInfo m_tVSSDevLoginInfo;
// 	CSTRUCT TVSSDevPos m_tVSSDevPos;
// 	CSTRUCT TUOID m_tHostDevID;        //宿主设备ID,当该设备为智能分析设备,车牌识别设备等时有效
// 	CSTRUCT TVSSDevCap m_tDevCap;
// }TVSSDevExtInfo;

//通道录像
typedef struct TChnRec
{
	CSTRUCT TUOID m_tRecSvrID;           //录像机ID
	CSTRUCT TUOID m_tScheTemplateID;     //调度模板
	u32 m_dwRecSpaceMB;          //录像空间
}TChnRec;

//通道信息
typedef struct TVSSChnInfo
{
	CSTRUCT TUOID m_tChnUOID;
	u32 m_dwLongPos;     //经度
	u32 m_dwLatPos;      //纬度
	u32 m_dwHeightPos;   //高度
	u32 m_dwCamTypeLen;
	char m_szCamType[VSS_NAME_MAXLEN];
	CSTRUCT TChnRec m_tChnRec;    //通道录像信息
	CSTRUCT TUOID m_tHostChnId;   //宿主通道ID
}TVSSChnInfo;

//Log元数据
typedef struct TVSSLogMetaData
{
	u32 m_dwLogTime;      //日志时间
	u32 m_dwLogLevel;	  //日志等级
	u32 m_dwLogType;      //具体的日志类型 如设备运行，用户登陆，设备接入等
	CSTRUCT TUOID m_tLogHostUOID;        //日志主格对象编号
	CSTRUCT TUOID m_tLogAccusatUOID;     //日志宾格对象编号(不支持索引)
	u32 m_deLogDescLen; //日志描述长度
	char m_szLogDesc[LOGMETADATA_USERDATA_MAXLEN+1]; //日志描述
}TVSSLogMetaData;


//////////////////////////////////////////////////////////////////////////
// 客户端与服务器间通信消息结构

//用户登陆请求，当前不允许用户重名
typedef struct TVSSUserLoginReq
{
    CSTRUCT TVSSNetAddr m_tCmsIP;
	CSTRUCT TVSSLoginInfo m_tLoginInfo;
 	u32 m_dwUserType; //用户类型(管理员，监控客户端用户，定损坐席等，见XXX)
	u32 m_dwContext; 
}TVSSUserLoginReq;

//用户登陆回复
typedef struct TVSSUserLoginRsp
{
    CSTRUCT TVSSUserLoginReq m_tUserLoginReq;
	u32 m_dwResult;
	CSTRUCT TUOID m_tServerUOID; //登陆服务器的UOID
	CSTRUCT TVSSObjBasic m_tUserBasic;  //请求登录用户的基本信息
	u32 m_dwSyncTimeS;        //同步时间
// 	char m_szCmsVer[VSS_NAME_MAXLEN]; //服务器版本号，暂时不需要
}TVSSUserLoginRsp;

//用户注销登陆请求
typedef struct TVSSUserLogoutReq
{
	u32 m_dwNameLen;
	char m_szUserName[VSS_NAME_MAXLEN];
	u32 m_dwContext; 
}TVSSUserLogoutReq;

//用户注销登陆回复
typedef struct TVSSUserLogoutRsp
{
	CSTRUCT TVSSUserLogoutReq m_tUserLogoutReq;
	u32 m_dwResult;
}TVSSUserLogoutRsp;

//用户修改密码请求
typedef struct TVSSUserPwdMdfReq
{
	u32 m_dwNameLen;
	char m_szUserName[VSS_NAME_MAXLEN];
	u32 m_dwPswLen;
	char m_abyPsw[VSS_PSW_MAXLEN];
	u32 m_dwContext; 
}TVSSUserPwdMdfReq;

//用户修改密码回复
typedef struct TVSSUserPwdMdfRsp
{
	CSTRUCT TVSSUserPwdMdfReq m_tUserPwdMdfReq;
	u32 m_dwResult;
}TVSSUserPwdMdfRsp;


//用户状态通知
typedef struct TVSSUserSsnStatusNtf
{
	CSTRUCT TUOID m_tUserUOID;
	u32 m_dwIsOnline; //是否在线: 1在线；0不在线
}TVSSUserSsnStatusNtf;

//中心管理服务单元状态通知（包括媒体转发服务器，录像服务器等中心单元）
typedef struct TVSSCmuSsnStatusNtf
{
	CSTRUCT TUOID m_tCmuUOID; //通过m_dwObjType区分中心单元类型，通过m_qwObjID区分具体哪个单元
	u32 m_dwIsOnline; //是否在线: 1在线；0不在线
}TVSSCmuSsnStatusNtf;

//实时媒体交换请求
typedef struct TVSSRealMediaSwitchReq
{
	CSTRUCT TUOID m_tCalledUOID;		//被叫（前端）UOID
	CSTRUCT TUOID m_tCallerUOID;		//主叫（客户端）UOID
	u32 m_dwVideoSwitchMode;				//视频交换模式，见vsscomm.h中EVSSMediaSwitchMode
	u32 m_dwCalledVEncChn;			//被叫（前端）视频编码通道
	u32 m_dwCallerVChn;				//主叫（客户端）视频消费通道（可能是客户端解码通道，也可能录像机的录像通道等）
	u32 m_dwCallerVEncChn;			//主叫（客户端）视频编码通道，用于双向交换

	u32 m_dwAudioSwitchMode;			//音频交换模式，见vsscomm.h中EVSSMediaSwitchMode
	u32 m_dwCalledAEncChn;     //被叫（前端）音频编码通道
	u32 m_dwCallerAChn;		//主叫（客户端）音频消费者编号,客户端解码通道，录像机的录像通道等
	u32 m_dwCallerAEncChn;     //主叫（客户端）音频编码通道

	u32 m_dwContext; 
}TVSSRealMediaSwitchReq;


//实时媒体交换回复
typedef struct TVSSRealMediaSwitchRsp
{
	CSTRUCT TVSSRealMediaSwitchReq m_tRealMediaSwitchReq;
	u32 m_dwResult;
 	u32 m_dwCalledVDecChn;			//被叫（前端）设备视频解码通道，用于双向交换
 	CSTRUCT TVSSNetAddr m_tCalledOrMdsVRcvAddr;  //被叫（前端）或者媒体转发服务器接收码流的目的地址，用于双向交换
//  	CSTRUCT TUOID m_tPuADecChn;					//媒体源，前端设备音频解码通道
	CSTRUCT TVSSNetAddr m_tCalledOrMdsARcvAddr;  //前端或者媒体转发服务器接收码流的目的地址
}TVSSRealMediaSwitchRsp;

//实时媒体交换停止命令
typedef struct TVSSMediaSwitchStopCmd
{
	CSTRUCT TUOID m_tCalledUOID;		//被叫（前端）UOID
	CSTRUCT TUOID m_tCallerUOID;		//主叫（客户端）UOID

	u32 m_dwVideoSwitchMode;				//视频交换模式，见vsscomm.h中EVSSMediaSwitchMode
	u32 m_dwCalledVEncChn;			//被叫（前端）视频编码通道
	u32 m_dwCallerVChn;				//主叫（客户端）视频消费通道（可能客户端解码通道，录像机的录像通道等）
	u32 m_dwCallerVEncChn;			//主叫（客户端）视频编码通道，用于双向交换

	u32 m_dwAudioSwitchMode;			//音频交换模式，见vsscomm.h中EVSSMediaSwitchMode
	u32 m_dwCalledAEncChn;     //被叫（前端）音频编码通道
	u32 m_dwCallerAChn;		//主叫（客户端）音频消费者编号,客户端解码通道，录像机的录像通道等
	u32 m_dwCallerAEncChn;     //主叫（客户端）音频编码通道
//	u32 m_dwContext; 
}TVSSMediaSwitchStopCmd;


//图片文件传输通道创建请求
typedef struct TVSSPicFileTransChnCreateReq
{
	CSTRUCT TVSSNetAddr m_tMdsNetAddr; //转分发服务器地址
	CSTRUCT TUOID m_tPuUOID;					//前端UOID
	CSTRUCT TUOID m_tCuUOID;					//客户端UOID
	u32 m_dwContext; 
}TVSSPicFileTransChnCreateReq;

//图片文件传输通道创建回复
typedef struct TVSSPicFileTransChnCreateRsp
{
	CSTRUCT TVSSPicFileTransChnCreateReq m_tTransChnCreateReq;
	u32 m_dwResult;
}TVSSPicFileTransChnCreateRsp;

//图片文件传输通道销毁命令
typedef struct TVSSPicFileTransChnDelCmd
{
	CSTRUCT TUOID m_tPuUOID;					//前端UOID
	CSTRUCT TUOID m_tCuUOID;					//客户端UOID
}TVSSPicFileTransChnDelCmd;

//设备抓图请求
typedef struct TVSSPuSnapPicReq
{
//  	CSTRUCT TUOID m_tCuUOID; //客户端UOID
	CSTRUCT TUOID m_tPuVEncChn;					//媒体提供源，前端设备编码通道
	u32 m_dwPicFullNameLen;						//图片保存路径名长度
	char m_szPicFullName[VSS_FILENAME_MAXLEN];//图片客户端保存全路径名
	u32 m_dwContext; 
}TVSSPuSnapPicReq;

//设备抓图回复
typedef struct TVSSPuSnapPicRsp
{
	CSTRUCT TVSSPuSnapPicReq m_tPuSnapPicReq;
	u32 m_dwResult;
}TVSSPuSnapPicRsp;


//客户端图片下载进度通知
typedef struct TVSSPicDLProgressNtf
{
	u32 m_dwPicFullNameLen;						//图片保存路径名长度
	char m_szPicFullName[VSS_FILENAME_MAXLEN];	//图片客户端保存全路径名

	u32 m_dwResult;
	u32 m_dwProgress;					//下载进度
}TVSSPicDLProgressNtf;

//////////////////////////////////////////////////////////////////////////
// 中心管理服务与各类其他服务通信消息结构

typedef struct TVSSPuInfoItem
{
	CSTRUCT TVSSObjBasic m_tPuBasic;         //前端设备对象
	CSTRUCT TVSSDevLoginInfo m_tPuLoginInfo; //前端设备登录信息
}TVSSPuInfoItem;

typedef struct TVSSChnInfoItem
{
	CSTRUCT TVSSObjBasic m_tPuChnBasic;    //前端通道对象
	CSTRUCT TVSSChnInfo m_tPuChnInfo;      //前端通道信息
}TVSSChnInfoItem;


//CMS登陆请求
typedef struct TVSSLoginCmsReq
{
// 	CSTRUCT TVSSNetAddr m_tCmsIP;
	CSTRUCT TVSSLoginInfo m_tLoginInfo;
	u32 m_dwContext; 
}TVSSLoginCmsReq;

//用户登陆回复
typedef struct TVSSLoginCmsRsp
{
	CSTRUCT TVSSLoginCmsReq m_tCmsLoginReq;
	CSTRUCT TUOID m_tServerUOID; //登陆服务器的UOID
	TVSSObjBasic m_tSvrBasic;  //请求登录的服务器的基本信息（如转发服务器，录像服务器等）
	u32 m_dwSyncTimeS;        //同步时间
	u32 m_dwResult;
}TVSSLoginCmsRsp;

//获取本服务器相关的前端设备列表请求
typedef struct TVSSPuListGetReq
{
	CSTRUCT TUOID m_tHostUOID;   //宿主UOID，如果媒体服务器获取设备，即媒体服务器的ID
	CSTRUCT TUOID m_tRefPuUOID;  //参考PuUOID，用户获取大批量的设备
	u32 m_dwMaxCntGet;			 //本次获取的最大数
	u32 m_dwContext;
}TVSSPuListGetReq;

//获取本服务器相关的前端设备列表回复
typedef struct TVSSPuListGetRsp
{
	CSTRUCT TVSSPuListGetReq m_tPuListGetReq;
	u32 m_dwResult;
	u32 m_dwPuListCnt;              //前端设备数量
	CSTRUCT TVSSPuInfoItem m_atPuInfoItem[VSS_LIST_MAXNUM]; //前端设备信息列表
}TVSSPuListGetRsp;

//获取设备通道列表请求
typedef struct TVSSPuChnListGetReq
{
	CSTRUCT TUOID m_tHostUOID;		//宿主UOID，如果媒体服务器获取设备，即媒体服务器的ID
	CSTRUCT TUOID m_tRefPuChn;		//参考PuUOID，用户获取大批量的设备
	u32 m_dwMaxCntGet;				//本次获取的最大数
	u32 m_dwContext;
}TVSSPuChnListGetReq;

//获取设备通道列表回复
typedef struct TVSSPuChnListGetRsp
{
	CSTRUCT TVSSPuChnListGetReq m_tPuChnListGetReq;
	u32 m_dwResult;
	u32 m_dwPuChnListCnt;              //前端设备数量
	CSTRUCT TVSSChnInfoItem m_atPuChnInfoItem[VSS_LIST_MAXNUM]; //前端设备通道信息列表
}TVSSPuChnListGetRsp;

//前端设备状态变化通知
typedef struct TVSSPuStatusNtf
{
	CSTRUCT TUOID m_tPuUOID;  //PuUOID
	u32 m_dwStatusType;      //状态类型(设备上下线，录像状态，告警状态等, 见svccommon.h EVssGlobalStatus)
	u32 m_dwStatusValue;     //状态值
}TVSSPuStatusNtf;

//////////////////////////////////////////////////////////////////////////
// 保险定损行业相关消息结构

//定损信息
typedef struct TVSSChargeInfo
{
	u32 m_dwReportNoLen;
	char m_szReportNo[VSS_REPORTNO_LEN];	// 报案号
	u32 m_dwPlateNoLen;
	char m_szPlateNo[VSS_PLATENO_LEN];	// 车牌号
	//暂略
}TVSSChargeInfo;

//坐席信息项
typedef struct TVSSAgentInfoItem
{
	CSTRUCT TVSSObjBasic m_tCuBasic;         //坐席基本信息
	//坐席扩展信息
}TVSSAgentInfoItem;
// 
// //定损坐席信息获取请求
// typedef struct TVSSAgentInfoReq
// {
// 	CSTRUCT TUOID m_tCuUOID;   //提供定损服务的坐席ID
// 	u32 m_dwContext; 
// }TVSSAgentInfoReq;
// 
// //定损坐席信息获取回复
// typedef struct TVSSAgentInfoRsp
// {
// 	CSTRUCT TVSSAgentInfoReq m_tAgentInfoReq;
// 	u32 m_dwResult;
// 	CSTRUCT TVSSAgentInfoItem m_tAgentInfoItem; //坐席信息
// }TVSSAgentInfoRsp;

//定损呼叫请求
typedef struct TVSSChargeCallReq
{
	CSTRUCT TUOID m_tPuUOID;   //发起呼叫的设备ID
	CSTRUCT TVSSChargeInfo m_tChargeInfo; //定损信息
	CSTRUCT TVSSNetAddr m_tFileTransSvrAddr;    //转发服务器文件传输连接地址，用于建立文件传输通道
	u32 m_dwContext; 
}TVSSChargeCallReq;

//定损呼叫回复
typedef struct TVSSChargeCallRsp
{
	CSTRUCT TVSSChargeCallReq m_tChargeCallReq;
	CSTRUCT TUOID m_tCuUOID;   //提供定损服务的坐席ID
	u32 m_dwResult;
}TVSSChargeCallRsp;

//定损完成提交的信息
typedef struct TVSSChargeSubmitInfo
{
	CSTRUCT TVSSChargeInfo m_tChargeInfo; //定损信息
	//其他，暂略
}TVSSChargeSubmitInfo;


//定损完成提交请求
typedef struct TVSSChargeSubmitReq
{
	CSTRUCT TUOID m_tCuUOID;   //提供定损服务的坐席ID
	//定损提交的内容
	CSTRUCT TVSSChargeSubmitInfo m_tChargeSubmitInfo;
	u32 m_dwContext; 
}TVSSChargeSubmitReq;

//定损完成提交回复
typedef struct TVSSChargeSubmitRsp
{
	CSTRUCT TVSSChargeSubmitReq m_tChargeCallReq;
	u32 m_dwResult;
}TVSSChargeSubmitRsp;

//定损完成通知
typedef struct TVSSChargeCompleteNtf
{
	CSTRUCT TUOID m_tPuUOID;   //发起呼叫的设备ID
	CSTRUCT TVSSChargeInfo m_tChargeInfo; //定损信息;
	u32 m_dwResult;
}TVSSChargeCompleteNtf;

// //空闲坐席列表获取请求
// typedef struct TVSSFreeAgentListGetReq
// {
// 	CSTRUCT TUOID m_tCuUOID;   //提供定损服务的坐席ID
// 	u32 m_dwContext; 
// }TVSSFreeAgentListGetReq;
// 
// 
// //空闲坐席列表获取回复
// typedef struct TVSSFreeAgentListGetRsp
// {
// 	CSTRUCT TVSSFreeAgentListGetReq m_tFreeAgentListGetReq;
// 	u32 m_dwResult;
// 	u32 m_dwAgentListCnt;              //空闲坐席数量
// 	CSTRUCT TVSSAgentInfoItem m_atAgentInfoItem[VSS_LIST_MAXNUM]; //空闲坐席信息列表
// }TVSSFreeAgentListGetRsp;

//定损转交请求
typedef struct TVSSChargeTransferReq
{
	u32 m_dwTransferType; //定损转交方式，见chargecomm.h 中的EChargeTransferType定义
	//CSTRUCT TUOID m_tDstCuUOID;   //目的坐席ID,在指定转交给某个坐席时有效，下一版本实现
	CSTRUCT TUOID m_tReqCuUOID;   //请求转交的坐席ID

	CSTRUCT TUOID m_tPuUOID;   //发起呼叫的设备ID
	CSTRUCT TVSSChargeInfo m_tChargeInfo; //定损信息
	u32 m_dwContext; 
}TVSSChargeTransferReq;

//定损转交回复
typedef struct TVSSChargeTransferRsp
{
	CSTRUCT TVSSChargeTransferReq m_tChargeTransferReq;
	u32 m_dwResult;
}TVSSChargeTransferRsp;

//坐席工作状态设置请求
typedef struct TVSSWorkStatusSetReq
{
	CSTRUCT TUOID m_tCuUOID;   //坐席ID
	u32 m_dwWorkStatus;  //具体见chargecomm.h 中的EAgentWorkStatus定义
	u32 m_dwReportNoLen;
	char m_szReportNo[VSS_REPORTNO_LEN];	// 报案号
	u32 m_dwContext; 
}TVSSWorkStatusSetReq;

//坐席工作状态设置回复
typedef struct TVSSWorkStatusSetRsp
{
	CSTRUCT TVSSWorkStatusSetReq m_tWorkStatusSetReq;
	u32 m_dwResult;
}TVSSWorkStatusSetRsp;

//坐席工作状态通知
typedef struct TVSSWorkStatusNtf
{
	u32 m_dwWorkStatus;  //具体见chargecomm.h 中的EAgentWorkStatus定义
}TVSSWorkStatusNtf;

//正在定损的设备掉线通知
typedef struct TVSSChargePuOfflineNtf
{
	CSTRUCT TUOID m_tPuUOID;   //设备ID
}TVSSChargePuOfflineNtf;

//////////////////////////////////////////////////////////////////////////
// 客户端UISvc与其他各服务间的通信消息结构

//实时媒体交换请求
// typedef struct TUIRealMediaSwitchReq
// {
// 	CSTRUCT TUOID m_tPuUOID;		//被叫（前端）UOID
// 	CSTRUCT TUOID m_tCuUOID;		//主叫（客户端）UOID
// // 	u32 m_dwIsSwitchVideo; //是否交换视频
// 	u32 m_dwVideoSwitchMode; //视频交换模式，见vsscomm.h中EVSSMediaSwitchMode
// 	u32 m_dwWndHdl;			//视频窗口句柄
// 	u32 m_dwWndIdx;         //窗口索引
//  	u32 m_dwPuVEncChnIdx;		//前端设备视频编码通道
// 
// // 	u32 m_dwIsSwitchAudio; //是否交换音频
// 	u32 m_dwAudioSwitchMode; //视频交换模式，见vsscomm.h中EVSSMediaSwitchMode
// 	u32 m_dwContext; 
// }TUIRealMediaSwitchReq;
// 
// //实时媒体交换回复
// typedef struct TUIRealMediaSwitchRsp
// {
// 	CSTRUCT TUIRealMediaSwitchReq m_tWorkStatusSwitchReq;
// 	u32 m_dwResult;
// }TUIRealMediaSwitchRsp;


#endif
