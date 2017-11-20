#ifndef _JL_PROVIDER_IOS_H_302FB4ED_2B75_470A_9CA0_4EA91CF8ED41
#define _JL_PROVIDER_IOS_H_302FB4ED_2B75_470A_9CA0_4EA91CF8ED41

#include "jlinc.h"

typedef enum {
	//init
	VA_EVENT_INIT_FAILED = 501,
	VA_EVENT_INIT_SUCCESSED,
	//connect
	VA_EVENT_CONNECT_FAILED,
	VA_EVENT_CONNECT_SUCCESSED,
	//disconnect
	VA_EVENT_DISCONNECT_FAILED,
	VA_EVENT_DISCONNECT_SUCCESSED,

	//login
	VA_EVENT_LOGIN_FAILED,
	VA_EVENT_LOGIN_SUCCESSED,

	//logout
	VA_EVENT_LOGOUT_FAILED,
	VA_EVENT_LOGOUT_SUCCESSED,

	//charge req
	VA_EVENT_CHARGEREQ_FAILED,
	VA_EVENT_CHARGEREQ_SUCCESSED,

	VA_EVENT_CHARGE_NOFREE,
	VA_EVENT_CHARGE_NOANSWER,
	VA_EVENT_CHARGE_REFUSE,
	VA_EVENT_CHARGE_NOFREE_BUSY,
	VA_EVENT_CHARGE_ERRREPORTNO,
	VA_EVENT_CHARGE_AGENTBUSY,
	
	//charge complete
	VA_EVENT_CHARGE_COMPLETE_FAILED,
	VA_EVENT_CHARGE_COMPLETE_SUCCESSED,

	VA_EVENT_CHARGE_CHARGECOMPLETE,
	VA_EVENT_CHARGE_BREAK,
	VA_EVENT_CHARGE_TIMEOUT,
	VA_EVENT_CHARGE_WANTADDITION,

	
	VA_EVENT_ALREADY_CONNECT,
	VA_EVENT_ALREADY_ONLINE,
	VA_EVENT_ALREADY_DIALING,
	VA_EVENT_ALREADY_CHARGEING,
	VA_EVENT_ALREADY_STREAMING,
	VA_EVENT_ALREADY_WAITEAGENT,

	//登录时检查连接事件,未连接
	VA_EVENT_NOT_CONNECT,
	//获取报案号
	VA_EVENT_GET_REPORT_FAILED,
	VA_EVENT_GET_REPORT_SUCCESSED,
	//媒体交换
	VA_EVENT_MEDIA_SWITCH_FAILED,
	VA_EVENT_MEDIA_SWITCH_SUCCESSED,
	//媒体停止
	VA_EVENT_MEDIA_STOP_FAILED,
	VA_EVENT_MEDIA_STOP_SUCCESSED,

	//设备拍照
	VA_EVENT_SNAP_PIC,

	//参数配置
	VA_EVENT_PARAM_CFG_FAILED,
	VA_EVENT_PARAM_CFG_SUCCESSED,
	//图片传输进度
	VA_EVENT_PHOTO_SEND_FAILED,
	VA_EVENT_PHOTO_SEND_PROCESS,
	VA_EVENT_PHOTO_SEND_SUCCESSED,
	//视频发送报告
	VA_EVENT_VIDEO_TRANSPORT_REPORT,
	//授权设备端主动拍照
	VA_EVENT_AUTH_DEV_SNAP,
	//收回设备端主动拍照授权
	VA_EVENT_CANCEL_AUTH_DEV_SNAP,
	//客户端取消图片传输
	VA_EVENT_CLIENT_CANCEL_FILE_TRANSF,
	//客户端图片传输完成
	VA_EVENT_CLIENT_CANCEL_FILE_COMPLETE,
	//摄像头镜头控制
	VA_EVENT_LENS_CTRL_REQ,
	//定损转接
	VA_EVENT_CHARGE_CHANGE_EVNET,
	//定损服务器忙
	VA_EVENT_CHARGE_SYSBUSY,
	// queue's count
	VA_EVENT_CHARGE_NOFREE_WAIT_COUNT,
	//
	VA_EVENT_BACK_CALL_REQUEST,
	//
	VA_EVENT_BACK_CALL_CANCEL,
	// server is busy, redial it later.
	VA_EVENT_REDIAL_LATER,
	// no online agent.
	VA_EVENT_NO_ONLINE_AGENT,
	VA_EVENT_TRANSPARENT_CHANNEL = 557,	//transparent channel test.
} VA_EVENT_e;

typedef struct {
	char* jfileReportNo;			//
	int jfileReportLen;		//
	int jfileIEventId;				//事件ID
	int jfileIsSendImg;		//发送图片状态
} JL_CBOBJ_t;

typedef struct {
	JL_CBOBJ_t cbObj;
	int	state;				//标志是否可以release、deinit
} JL_PROVIDER_CB_t;

//typedef	struct
//{
//	unsigned int	lost_video_frame;
//	unsigned int	recv_video_byte;
//	unsigned int	report_interval;
//	unsigned int	resend_video_packet;
//	unsigned int	send_video_byte;
//	unsigned int	play_video_frame;
//	unsigned int	play_audio_frame;
//	unsigned int 	send_audio_frame;
//}avtp_vreport_t;

typedef struct _provider_ios_msg
{
  int m_eventID;
  char* m_eventInfo;
}Provider_IOS_Msg;

typedef struct _provider_ios_msgqueue
{
  struct _provider_ios_msgqueue* next;
  Provider_IOS_Msg* m_msg;
}Provider_IOS_MsgQueue;

int InitProvider(JL_PROVIDER_CB_t *obj);
void DeinitProvider(JL_PROVIDER_CB_t *obj);
int InitCallBackObj(JL_CBOBJ_t *obj);
void DeinitCallBackObj(JL_CBOBJ_t *obj);

void postEvent(int eventID,char* eventInfo);
Provider_IOS_Msg* getEvent();
void destoryEvent(Provider_IOS_Msg* msg);


void On_DisconnectNtfCB(u32 dwInstID, u32 dwNodeId, u32 dwContext);

typedef	void (* JLNOTIFYCB)(int param1,int param2);

/************************************************************************
 *							Pu设备端接口								*
 ************************************************************************/ 

//连接回复
void On_AsyConnectRspCB(u32 dwInstID, u32 dwNodeId, u32 dwResult, u32 dwContext );

//登陆回复回调
void On_LoginRspCB(u32 dwInstID, u32 dwNodeId, TJLPuLoginRsp* ptMsg, u32 dwContext);

void On_ReportRuleRspCB(u32 dwInstID, u32 dwNodeId, TJPuReportRuleRsp* ptMsg, u32 dwContext);

//注销登陆回复回调
void On_LogoutRspCB(u32 dwInstID, u32 dwNodeId, TJLPuLogoutRsp* ptMsg, u32 dwContext);

//实时媒体交换请求回调
void On_MediaSwitchReqCB(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchReq* ptMsg, u32 dwContext);

//实时媒体交换修改请求回调
void On_MediaSwitchMdfReqCB(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchReq* ptMsg, u32 dwContext);

//实时媒体交换停止命令回调
void On_MediaStopCmdCB(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaStopCmd* ptMsg, u32 dwContext);

//参数配置请求回调
void On_ParamCfgReqCB(u32 dwInstID, u32 dwNodeId, TJLParamCfgReq* ptMsg, u32 dwContext);

//设备抓图请求回调
void On_PuSnapPicReqCB(u32 dwInstID, u32 dwNodeId, TJLPuSnapPicReq* ptMsg, u32 dwContext);

void On_TransparentDataSendNtfCB(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen, u32 dwContext);

void On_PicFileDataSendNtfCB(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen, u32 dwContext);

//定损呼叫回复回调
void On_PuChargeCallRspCB(u32 dwInstID, u32 dwNodeId, TJLPuChargeCallRsp* ptMsg, u32 dwContext);

//定损呼叫回复回调2 (相机专用函数)
void On_PuChargeCallRspCB2(u32 dwInstID, u32 dwNodeId, TJLPuChargeCallRsp2* ptMsg, u32 dwContext);

//定损完成通知回调
void On_ChargeCompleteNtfCB(u32 dwInstID, u32 dwNodeId, TJLPuChargeCompleteNtf* ptMsg, u32 dwContext);

//定损完成通知回调2 (相机专用函数)
void On_ChargeCompleteNtfCB2(u32 dwInstID, u32 dwNodeId, TJLPuChargeCompleteNtf* ptMsg, u32 dwContext);

//added by fzp
void On_CallQueueCntNtfCB(u32 dwInstID, u32 dwNodeId, TJLCallQueueCntNtf* ptMsg, u32 dwContext);
//end

// Back call added by fzp
void On_BackCallReq(u32 dwInstID, u32 dwNodeId, TJLBackCallreq* ptMsg, u32 dwContext);
void On_BackCallCancelReq(u32 dwInstID, u32 dwNodeId, TJLBackCallCancelReq* ptMsg, u32 dwContext);
// end

//透明数据发送请求回复回调
void On_Pu2CuTransparentDataSendRspCB(u32 dwInstID, u32 dwNodeId, char *pDataBuf,DWORD dwDataLen, u32 dwContext);

//透明数据发送请求回调
void On_Cu2PuTransparentDataSendReqCB(u32 dwInstID, u32 dwNodeId, char *pDataBuf,DWORD dwDataLen, u32 dwContext);

//拍照授权
void on_auth_snap(u32 inst, u32 nodeid, TJPuAuthSnap* message, u32 context);

//收回拍照授权
void on_auth_snap_cancel(u32 inst, u32 nodeid, TJPuAuthSnapCancel* message, u32 context);

//客户端取消图片传输
//void on_stack_client_cancel_picdata_transf(u32 inst, u32 nodeid, TJPuSendPictureNtf *message, u32 context);
void on_client_picdata_transf_event_cb(u32 inst, u32 nodeid, TJPuSendPictureNtf *message, u32 context);
//镜头控制
void on_lens_ctrl_req(u32 inst, u32 nodeid, TJPuLensCtrlReq *message, u32 context);
//定损转接
void on_charge_change(u32 inst, u32 nodeid, TJLPuChargeChangeRsp *message, u32 context);

void on_transparent_channel(u32 inst, u32 nodeid, TJPuTransparentChnl* message, u32 context);//shm added for transparent channel test.
#endif
