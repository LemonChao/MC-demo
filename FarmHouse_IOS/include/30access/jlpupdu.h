#ifndef _H_JL_PU_PDU_
#define _H_JL_PU_PDU_

/************************************************************************
 *        京联前端设备通信协议栈（信令部分消息体定义）					*
 ************************************************************************/ 
#define CSTRUCT

#include "../00common/uvbasetype.h"
#include "../00common/vsscomm.h"
#ifndef TNETIP
typedef u32 TNETIP; //pdu生成工具专用
typedef struct TVSSNetAddr
{
	TNETIP m_tIP;
	u16 m_wPort;
}TVSSNetAddr;
#endif


//设备信息
typedef struct TJLPuDevInfo
{
	u32 m_dwSerialNumLen;	//序列号长度
	u8	m_achSerialNumber[VSS_SERIAL_MAXLEN];	// 序列号或设备ID号
	u8	m_byAlarmInPortNum;		// 报警输入个数
	u8	m_byAlarmOutPortNum;		// 报警输出个数
	u8	m_byDiskNum;				// 硬盘个数
	u8	m_byDevType;				// 设备类型类型
	u8	m_byVideoChanNum;			// 视频通道个数
	u8  m_byAudioChanNum;         // 语音通道数
	u32 m_dwVideoCap;				//视频能力集
	u32 m_dwAudioCap;				//音频能力集
	u32 m_dwPicCap;				//图片能力集
	u8  m_byRes1[16];				// 保留
}TJLPuDevInfo;

// 定损信息
typedef struct TJLChargeInfo
{
	u32 m_dwReportNoLen;
	u8	m_achReportNo[VSS_REPORTNO_LEN];	// 报案号
	u32 m_dwPlateNoLen;
	u8	m_achPlateNo[VSS_PLATENO_LEN];		// 车牌号
} TJLChargeInfo;

//抓拍图片参数
typedef struct TJLJpegParam
{
	u16	m_wPicSize;	
	u16	m_wPicQuality;
}TJLJpegParam;

//登陆认证信息
typedef struct TJLPuLoginAuthInfo
{
	u32 m_dwNameLen;
	char m_szUserName[VSS_NAME_MAXLEN];
	u32 m_dwAuthPwdLen;
	char m_szAuthPwd[VSS_PSW_MAXLEN];
}TJLPuLoginAuthInfo;

//参数配置数据
typedef struct TJLParamCfgData
{
	u32 m_dwCfgType;	//配置参数类型
	u32 m_dwCfgDatLen;  //配置数据长度
	u8  m_chCfgData[256]; //配置数据，具体内容由应用层解析
}TJLParamCfgData;

//////////////////////////////////////////////////////////////////////////
// 消息体定义

//消息头定义
typedef struct TJLPuMsgHead
{
	u32 m_dwVersion;      //协议版本号
	u32 m_dwHeadLength;   //协议头长度
	u32 m_dwTotalLength;  //数据总长度
	u32 m_dwSeqID;        //消息序列号
	u32 m_dwTransactionID;//事务ID
	u32 m_dwEventID;      //消息ID类型
	u32 m_dwReserved;     //保留
}TJLPuMsgHead;

//登陆请求
typedef struct TJLPuLoginReq
{
    CSTRUCT TJLPuLoginAuthInfo m_tLoginAuthInfo;
	CSTRUCT TJLPuDevInfo m_tDevInfo;
	u32 m_dwContext; 
}TJLPuLoginReq;

//登陆回复
typedef struct TJLPuLoginRsp
{
    CSTRUCT TJLPuLoginReq m_tLoginReq;
	u32 server_time;
	u32 m_dwResult;
}TJLPuLoginRsp;

//注销登陆请求
typedef struct TJLPuLogoutReq
{
	u32 m_LogoutReason; //注销原因or保留？？？
	u32 m_dwContext; 
}TJLPuLogoutReq;

//用户注销登陆回复
typedef struct TJLPuLogoutRsp
{
	CSTRUCT TJLPuLogoutReq m_tUserLogoutReq;
	u32 m_dwResult;
}TJLPuLogoutRsp;

//实时媒体交换请求
typedef struct TJLPuRealMediaSwitchReq
{
	u32 m_dwVideoSwithMode;		//视频交换模式，见vsscomm.h中EVSSMediaSwitchMode
	u32 m_dwVChn;				//视频通道号
	u32 m_dwVCodecType;			//视频编解码类型
 	CSTRUCT TVSSNetAddr m_tCallerVRcvAddr;  //视频接收码流地址

	u32 m_dwAudioSwitchMode;	//音频交换模式，见vsscomm.h中EVSSMediaSwitchMode
	u32 m_dwAChn;				//音频通道号
	u32 m_dwACodecType;			//音频编解码类型
	CSTRUCT TVSSNetAddr m_tCallerARcvAddr;  //音频接收码流地址
	u32 m_dwContext; 
}TJLPuRealMediaSwitchReq;

//实时媒体交换回复
typedef struct TJLPuRealMediaSwitchRsp
{
	CSTRUCT TJLPuRealMediaSwitchReq m_tRealMediaSwitchReq;
	u32 m_dwResult;
//  CSTRUCT TVSSNetAddr m_tPuVRcvAddr;  //前端接收视频的目的地址，用于视频
// 	CSTRUCT TVSSNetAddr m_tPuARcvAddr;  //前端接收音频的目的地址，用于语音对讲
}TJLPuRealMediaSwitchRsp;

//实时媒体交换停止命令
typedef struct TJLPuRealMediaStopCmd
{
	u32 m_dwVideoSwithMode;		//视频交换模式，见vsscomm.h中EVSSMediaSwitchMode
	u32 m_dwVChn;				//视频通道号
	u32 m_dwAudioSwitchMode;	//音频交换模式，见vsscomm.h中EVSSMediaSwitchMode
	u32 m_dwAChn;				//音频通道号
	u32 m_dwContext; 
}TJLPuRealMediaStopCmd;

//设备抓图请求
typedef struct TJLPuSnapPicReq
{
	u32 m_dwVChn;				//视频通道号
	u32 m_dwVideoCtrl;			//抓图后，图像传输时视频控制参数
	TJLJpegParam m_tJpegParam;  //图片质量参数
	u32 m_dwClientPicFullPathLen;
	char m_szClientPicFullPath[VSS_FILENAME_MAXLEN];
	u32 m_dwContext; 
}TJLPuSnapPicReq;

//设备抓图回复
typedef struct TJLPuSnapPicRsp
{
	CSTRUCT TJLPuSnapPicReq m_tPuSnapPicReq;
	u32 m_dwResult;
}TJLPuSnapPicRsp;

//参数配置请求
typedef struct TJLParamCfgReq
{
	CSTRUCT TJLParamCfgData m_tCfgData;
	u32 m_dwContext; 
}TJLParamCfgReq;

//参数配置回复
typedef struct TJLParamCfgRsp
{
	CSTRUCT TJLParamCfgReq m_tParamCfgReq;
	u32 m_dwResult;
}TJLParamCfgRsp;

//参数配置通知
typedef struct TJLParamMdfNtf
{
	CSTRUCT TJLParamCfgData m_tCfgData;
	u32 m_dwResult;
}TJLParamMdfNtf;

//报案号规则获取请求
typedef struct TJPuReportRuleReq
{
	u32 m_dwContext;

}TJPuReportRuleReq;

typedef struct TJPuReportRuleRsp 
{
	CSTRUCT TJPuReportRuleReq m_tReportRuleReq;

	u32 ReportNoLen;
	char ReportNo[VSS_REPORTNO_LEN];
	u32 dwResult; 
}TJPuReportRuleRsp;
//定损呼叫请求
typedef struct TJLPuChargeCallReq
{
	CSTRUCT TJLChargeInfo m_tChargeInfo; //定损信息
	u32 m_dwIsNewAgentDeal;  //是否找新的空闲坐席处理当前定损(用于指定报案号定损坐席繁忙时）
	u32 m_dwContext; 
}TJLPuChargeCallReq;


//定损呼叫回复
typedef struct TJLPuChargeCallRsp
{
	CSTRUCT TJLPuChargeCallReq m_tChargeCallReq;
	u32 AgentNoLen;
	char AgentNo[VSS_NAME_MAXLEN];
	//如果不是基于信令通道传输抓图的图片，需要带回服务器接收文件传输通道的地址和端口
	u32 m_dwResult;
}TJLPuChargeCallRsp;

//定损呼叫回复2
typedef struct TJLPuChargeCallRsp2
{
	CSTRUCT TJLPuChargeCallReq m_tChargeCallReq;
	// CSTRUCT TJLCallQueueCntNtf m_tCallQueueCnt;// the count of people in busy
	u32 AgentNoLen;
	char AgentNo[VSS_NAME_MAXLEN];
	//新增字段 m_tCallerVRcvAddr，m_tCallerARcvAddr
	CSTRUCT TVSSNetAddr m_tCallerVRcvAddr; //视频接收码流地址和端口
	CSTRUCT TVSSNetAddr m_tCallerARcvAddr; //音频接收码流地址和端口
	u32 m_dwResult;
}TJLPuChargeCallRsp2;

//定损中断通知
typedef struct TJLPuChargeBreakNtf
{
	u32 m_dwReserve; //保留
}TJLPuChargeBreakNtf;


//定损完成通知
typedef struct TJLPuChargeCompleteNtf
{
	CSTRUCT TJLChargeInfo m_tChargeInfo; //定损信息
	u32 m_dwResult; //定时完成结果
}TJLPuChargeCompleteNtf;

/*new struct define ,add by bradlee 2012-7-15*/

typedef struct TJPuAuthSnap
{
	u32 authid;             //授权ID
	u32 agentid;            //对应数据库自增字段
	u32 deviceid;           //对应数据库device表的deivcecode字段
	u32 pic_level;
	u32 client_path_len;	//图片保存路径名长度
	char client_path[VSS_FILENAME_MAXLEN]; ////图片保存路径名
	u32 context;
} TJPuAuthSnap;


//shm add begin for transparent channel//透明通道
typedef struct TJPuTransparentChnl
{
	u32 agentid;            //对应数据库自增字段
	u32 deviceid;           //对应数据库device表的deivcecode字段
	u32  context;
	u32 datalen;
	u8 data[VSS_TRANSDATA_MAXLEN];
} TJPuTransparentChnl;
//shm add end for transparent channel

//shm add begin for transparent channel//透明通道
typedef struct TJToCuTransparentChnl
{
	u32 deviceid;           //对应数据库device表的deivcecode字段
	u32 datalen;
	u8 data[VSS_TRANSDATA_MAXLEN];
} TJToCuTransparentChnl;
//shm add end for transparent channel

typedef struct TJPuAuthSnapRsp
{
	TJPuAuthSnap req;
	u32  result;
} TJPuAuthSnapRsp;


typedef struct TJPuAuthSnapCancel
{
	u32 authid;             //授权ID
	u32 agentid;            //对应数据库自增字段
	u32 deviceid;           //对应数据库device表的deivcecode字段
	u32 context;
} TJPuAuthSnapCancel;

typedef struct TJPuAuthSnapCancelRsp
{
	TJPuAuthSnapCancel req;
	u32 result;
} TJPuAuthSnapCancelRsp;


typedef struct TJPuSendPictureNtf
{
	u32 authid;             //授权ID
	u32 agentid;            //对应数据库agent自增字段
	u32 deviceid;           //对应数据库device表的deivcecode字段
	u32 total_len;          //图片总长度
	u32 trsf_event;         //高16位：传输进度百分比。 低16位：0标示尚未传输，1标示开始传输，2标示正在传输，3标示传输取消，4标示传输完成
	u32 reserved_word;       //保留字
	u32 quality;            //照片等级，1=低，2=中，3=高，其他值为相机默认值。
	u32 picture_info;       //图片的信息，高位2个字节表示图片格式，低位的2个字节表示前端是否有水印，非零表示前端 有水印。
	u32 client_path_len;	   //图片保存路径名长度
	char client_path[VSS_FILENAME_MAXLEN]; ////图片保存路径名

} TJPuSendPictureNtf;

typedef struct TJPuDeviceInfoNtf
{
	u32  deviceid;           //对应数据库device表的deivcecode字段
	u32  mode;				// 0：无效，1：wifi 2:3G,
	u32  signal;        
	u32  gps_info_len;    
	char gps_info[VSS_GPSINFO_MAXLEN];
} TJPuDeviceInfoNtf;

//add by zlz -->>
typedef struct TJPuDeviceGpsNtf{
	u32  deviceid;
	u32  gps_info_len;
	char gps_info[VSS_GPSINFO_MAXLEN];
}TJPuDeviceGpsNtf;

typedef struct TJPuDeviceNetNtf{
	u32  deviceid;
	u32  mode;				// 0：无效，1：wifi 2:3G,
	u32  signal;
}TJPuDeviceNetNtf;

//added by fzp <!-- the count of peaple in busy
typedef struct TJLCallQueueCntNtf{
	u32 count;
	u32 result;
}TJLCallQueueCntNtf;

typedef struct TJLChargeCallCancelNtf{
	u32 deviceid;
	u32 result;
}TJLChargeCallCancelNtf;
//end to add

//Back call added by fzp
typedef struct TJLBackCallreq 
{ 
	u32 agentID; 
    u32 timeout;
	u32 reportNumLen; 
	char reportNum[VSS_NAME_MAXLEN]; 
	u32 agentNameLen; 
	char agentName[VSS_NAME_MAXLEN];//坐席名称，如 阿三 
	u32 contextID;//回话ID 
}TJLBackCallreq; 

typedef struct TJLBackCallConfirmRsp
{
	u32 sigID;
	u32 agentID;
}TJLBackCallConfirmRsp;

typedef struct TJLBackCallrsp
{
	CSTRUCT TJLBackCallreq req;
	u32 result;//超时，拒绝等
}TJLBackCallrsp;

typedef struct TJLBackCallCancelReq
{
	u32 agentID;
	u32 contextID;
}TJLBackCallCancelReq;

typedef struct TJLBackCallCancelRsp
{
	u32 result;// ok
	CSTRUCT TJLBackCallCancelReq req;
}TJLBackCallCancelRsp;
//end 
// add by zlz <<--
/*
typedef struct TJPuDevicePicTrsfNtf{
	u32 deviceid;
	u32 trsf_event; //0:客户端接受图片完成，1：客户端取消传输图片 2：设备端图片数据发送完成 3：设备端图片发送取消
	u32 pic_info;   //高16位：照片等级，1=低，2=中，3=高。 低16位：0标识前端拍照，1标识后端拍照
	u32 pic_data_pctg; //高16位：图片数据总长度。 低16位：发起通知时图片的传输百分比
	u32 pic_name_len;
	char pic_name[VSS_FILENAME_MAXLEN];
}TJPuDevicePicTrsfNtf；
*/
typedef struct TJPuOnlineAction{
	u32 deviceid;
	u32 action; // 0.定损就绪 1.定损结束  2.切换后台 3.程序退出 4.其他
	u32 status; // 0.在线空闲 1：定损中 2.后台在线运行 3.定损中后台运行 4.忙
	u32 reserve;//保留字
	u32 extea_info_len;
	char extra_info[VSS_ACTION_EXTRA_LEN];
}TJPuOnlineAction;

typedef struct TJPuLensCtrlReq
{
	u32  agentid;
	u32  deviceid;
	u32  lens_focus; //焦距刻度，须客户端与设备对应好，每次都是绝对值
	u32  reserve1;
	u32  reserve2;
	u32  reserve3;
	u32  context;
} TJPuLensCtrlReq;

typedef struct TJPuLensCtrlRsp
{
	TJPuLensCtrlReq req;
	u32  result;

} TJPuLensCtrlRsp;

typedef struct TJLPuChargeChangeRsp{
	u32  deviceid;
	u32  AgentNoLen;
	char AgentNo[VSS_NAME_MAXLEN];
}TJLPuChargeChangeRsp;

#endif
