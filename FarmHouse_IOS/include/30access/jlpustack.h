#ifndef _JL_PU_STACK_H_
#define _JL_PU_STACK_H_

#ifdef __cplusplus
extern "C" {
#endif
typedef u32 DWORD;
typedef struct tagJLPuStackInitParam
{
	void* m_hSigNet;          //SigNet句柄//???
	BOOL m_bServer;			//是否服务器端
// 	u32 m_dwMaxClientNum;	//最大客户端连接数（目前Pu端使用）
// 	u32 m_dwMaxAcceptNum;	//最大服务端接收的连接数（目前Sdk端使用）
	u16 m_wRcvQueueSize;    //接收队列大小(K)
	u16 m_wSndQueueSize;    //发送队列的大小(K)
	u16 m_wCheckTimeValS;   //断链检测间隔
	u16 m_wCheckNum;        //断链检测次数
}TJLPuStackInitParam;

//初始化
u32 JLPuStack_Init( TCommInitParam *ptCommInitParam );
u32 JLPuStack_UnInit();

//创建通信协议栈实例
u32 JLPuStack_InstCreate(TJLPuStackInitParam *ptInitParam, OUT u32 *dwInstID,u32 is_server );
u32 JLPuStack_InstDestroy(u32 dwInstID);

//主动断开连接
u32 JLPuStack_Disconnect(u32 dwInstID, u32 dwNodeId);
//断开连接通知消息
typedef void (*JLPuStack_DisconnectNtfCB)(u32 dwInstID, u32 dwNodeId, u32 dwContext);

/************************************************************************
 *							SDK端接口									*
 ************************************************************************/ 
//接收连接通知回调
typedef void (*JLPuStack_ConnectAcceptNtfCB)(u32 dwInstID, u32 dwNodeId, TNetAddr *ptRealNetAddr, TNetAddr *ptMapNetAddr,u32 dwContext);

//登陆请求回调
typedef void (*TJLPuStack_LoginReqCB)(u32 dwInstID, u32 dwNodeId, TJLPuLoginReq* ptMsg, u32 dwContext);
//登陆回复
u32 JLPuStack_LoginRsp(u32 dwInstID, u32 dwNodeId, TJLPuLoginRsp* ptMsg );

//获取报案号请求回调
typedef void (*TJLPuStack_GetReportRuleReqCB)(u32 dwInstID, u32 dwNodeId,TJPuReportRuleReq * ptMsg, u32 dwContext);
//获取报案号回复
u32 JLPuStack_GetReportRuleRsp(u32 dwInstID, u32 dwNodeId, TJPuReportRuleRsp* ptMsg );

//注销登陆请求回调
typedef void (*TJLPuStack_LogoutReqCB)(u32 dwInstID, u32 dwNodeId, TJLPuLogoutReq* ptMsg, u32 dwContext);
//注销登陆回复
u32 JLPuStack_LogoutRsp(u32 dwInstID, u32 dwNodeId, TJLPuLogoutRsp* ptMsg );

//实时媒体交换请求
u32 JLPuStack_MediaSwitchReq(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchReq* ptMsg );
//实时媒体交换回复
typedef void (*TJLPuStack_MediaSwitchRspCB)(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchRsp* ptMsg, u32 dwContext);

//实时媒体交换修改请求
u32 JLPuStack_MediaSwitchMdfReq(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchReq* ptMsg );
//实时媒体交换修改回复
typedef void (*TJLPuStack_MediaSwitchMdfRspCB)(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchRsp* ptMsg, u32 dwContext);

//实时媒体交换停止命令
u32 JLPuStack_MediaStopCmd(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaStopCmd* ptMsg );

//设备抓图请求
u32 JLPuStack_PuSnapPicReq(u32 dwInstID, u32 dwNodeId, TJLPuSnapPicReq* ptMsg );
//设备抓图回复回调
typedef void (*TJLPuStack_PuSnapPicRspCB)(u32 dwInstID, u32 dwNodeId, TJLPuSnapPicRsp* ptMsg, u32 dwContext);

//参数配置请求
u32 JLPuStack_ParamCfgReq(u32 dwInstID, u32 dwNodeId, TJLParamCfgReq* ptMsg );
//参数配置回复回调
typedef void (*TJLPuStack_ParamCfgRspCB)(u32 dwInstID, u32 dwNodeId, TJLParamCfgRsp* ptMsg, u32 dwContext);
//参数配置修改通知
typedef void (*TJLPuStack_ParamMdfNtfCB)(u32 dwInstID, u32 dwNodeId, TJLParamMdfNtf* ptMsg, u32 dwContext );

//定损呼叫请求回调
typedef void (*TJLPuStack_PuChargeCallReqCB)(u32 dwInstID, u32 dwNodeId, TJLPuChargeCallReq* ptMsg, u32 dwContext);
//定损呼叫回复
u32 JLPuStack_PuChargeCallRsp(u32 dwInstID, u32 dwNodeId, TJLPuChargeCallRsp* ptMsg );

//定损中断通知回调
typedef void (*TJLPuStack_PuChargeBreakNtfCB)(u32 dwInstID, u32 dwNodeId, TJLPuChargeBreakNtf* ptMsg, u32 dwContext);

//定损完成通知
u32 JLPuStack_ChargeCompleteNtf(u32 dwInstID, u32 dwNodeId, TJLPuChargeCompleteNtf* ptMsg );

//透明数据发送命令
u32 JLPuStack_TransparentDataSend(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen );
//图片文件数据发送命令
u32 JLPuStack_PicFileDataSend(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen );

//透明数据发送请求
u32 JLPuStack_Cu2PuTransparentDataSendReq(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen );
//透明数据发送请求回复
typedef void (*JLPuStack_Cu2PuTransparentDataSendRspCB)(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen,u32 dwContext);
//透明数据发送请求
typedef void (*JLPuStack_Pu2CuTransparentDataSendReqCB)(u32 dwInstID, u32 dwNodeId, char *pDataBuf,DWORD dwDataLen, u32 dwContext);
u32 JLPuStack_Pu2CuTransparentDataSendRsp(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen );

/************************************************************************
 *							Pu设备端接口								*
 ************************************************************************/ 
u32 JLPuStack_AsyConnect( u32 dwInstID, u32 dwIpAddr, IN u16 wPort,
						 IN u32 dwTimeoutMs, u32 dwContext );
//连接请求回调
//u32 JLPuStack_AsyConnect( u32 dwInstID, u32 dwIpAddr, IN u16 wPort, IN u32 dwTimeoutMs, u32 dwContext, OUT u32 *pdwNodeId );
//连接回复
typedef void (*TJLPuStack_AsyConnectRspCB)(u32 dwInstID, u32 dwNodeId, u32 dwResult, u32 dwContext );

//登陆请求
u32 JLPuStack_LoginReq(u32 dwInstID, u32 dwNodeId, TJLPuLoginReq* ptMsg );

//登陆回复回调
typedef void (*TJLPuStack_LoginRspCB)(u32 dwInstID, u32 dwNodeId, TJLPuLoginRsp* ptMsg, u32 dwContext);
u32 JLPuStack_GetReportRuleReq(u32 dwInstID, u32 dwNodeId, TJPuReportRuleReq* ptMsg );
typedef void (*TJLPuStack_GetReportRuleRspCB)(u32 dwInstID, u32 dwNodeId, TJPuReportRuleRsp* ptMsg, u32 dwContext);

//注销登陆请求
u32 JLPuStack_LogoutReq(u32 dwInstID, u32 dwNodeId, TJLPuLogoutReq* ptMsg );
//注销登陆回复回调
typedef void (*TJLPuStack_LogoutRspCB)(u32 dwInstID, u32 dwNodeId, TJLPuLogoutRsp* ptMsg, u32 dwContext);

//实时媒体交换请求回调
typedef void (*TJLPuStack_MediaSwitchReqCB)(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchReq* ptMsg, u32 dwContext);
//实时媒体交换回复
u32 JLPuStack_MediaSwitchRsp(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchRsp* ptMsg );

//实时媒体交换修改请求回调
typedef void (*TJLPuStack_MediaSwitchMdfReqCB)(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchReq* ptMsg, u32 dwContext);
//实时媒体交换修改回复
u32 JLPuStack_MediaSwitchMdfRsp(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaSwitchRsp* ptMsg );

//实时媒体交换停止命令回调
typedef void (*TJLPuStack_MediaStopCmdCB)(u32 dwInstID, u32 dwNodeId, TJLPuRealMediaStopCmd* ptMsg, u32 dwContext);


//参数配置请求回调
typedef void (*TJLPuStack_ParamCfgReqCB)(u32 dwInstID, u32 dwNodeId, TJLParamCfgReq* ptMsg, u32 dwContext);
//参数配置回复
u32 JLPuStack_ParamCfgRsp(u32 dwInstID, u32 dwNodeId, TJLParamCfgRsp* ptMsg );
//参数配置修改通知
u32 JLPuStack_ParamMdfNtf(u32 dwInstID, u32 dwNodeId, TJLParamMdfNtf* ptMsg );


//设备抓图请求回调
typedef void (*TJLPuStack_PuSnapPicReqCB)(u32 dwInstID, u32 dwNodeId, TJLPuSnapPicReq* ptMsg, u32 dwContext);
//设备抓图回复
u32 JLPuStack_PuSnapPicRsp(u32 dwInstID, u32 dwNodeId, TJLPuSnapPicRsp* ptMsg );

//定损呼叫请求
u32 JLPuStack_PuChargeCallReq(u32 dwInstID, u32 dwNodeId, TJLPuChargeCallReq* ptMsg );
//定损呼叫请求相机专用函数
u32 JLPuStack_PuChargeCallReq2(u32 dwInstID, u32 dwNodeId, TJLPuChargeCallReq* ptMsg );
//定损呼叫回复回调
typedef void (*TJLPuStack_PuChargeCallRspCB)(u32 dwInstID, u32 dwNodeId, TJLPuChargeCallRsp* ptMsg, u32 dwContext);
//定损呼叫回复回调2 相机专用
typedef void (*TJLPuStack_PuChargeCallRspCB2)(u32 dwInstID, u32 dwNodeId, TJLPuChargeCallRsp2* ptMsg, u32 dwContext);
//定损中断通知
u32 JLPuStack_PuChargeBreakNtf(u32 dwInstID, u32 dwNodeId, TJLPuChargeBreakNtf* ptMsg );

//定损完成通知回调
typedef void (*TJLPuStack_ChargeCompleteNtfCB)(u32 dwInstID, u32 dwNodeId, TJLPuChargeCompleteNtf* ptMsg, u32 dwContext);
//added by fzp
typedef void (*TJLPuStack_CallQueueCntNtfCB)(u32 dwInstId, u32 dwNodeId, TJLCallQueueCntNtf* ptMsg, u32 dwContext);

//Back call added by fzp
typedef void (*TJLPuStack_BackCallReq)(u32 dwInstId, u32 dwNodeId, TJLBackCallreq* ptMsg, u32 dwContext);
typedef void (*TJLPuStack_BackCallCancelReq)(u32 dwInstId, u32 dwNodeId, TJLBackCallCancelReq* ptMsg, u32 dwContext);
//end
//透明数据发送通知
typedef void (*TJLPuStack_TransparentDataSendNtfCB)(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen, u32 dwContext);
//图片文件数据发送通知
typedef void (*TJLPuStack_PicFileDataSendNtfCB)(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen, u32 dwContext);
//透明数据发送请求
u32 JLPuStack_Pu2CuTransparentDataSendReq(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen );
//透明数据发送请求回复回调
typedef void (*JLPuStack_Pu2CuTransparentDataSendRspCB)(u32 dwInstID, u32 dwNodeId, char *pDataBuf,DWORD dwDataLen, u32 dwContext);

typedef void (*JLPuStack_Cu2PuTransparentDataSendReqCB)(u32 dwInstID, u32 dwNodeId, char *pDataBuf,DWORD dwDataLen, u32 dwContext);
//透明数据发送请求回调
u32 JLPuStack_Cu2PuTransparentDataSendRsp(u32 dwInstID, u32 dwNodeId, char *pDataBuf, DWORD dwDataLen );



/*new message,add by bradlee 2013-7-16*/
//sdk 
u32 stack_auth_snap(u32 inst, u32 nodeid,TJPuAuthSnap* message );
typedef void (*stack_auth_snap_rsp_func)(u32 inst, u32 nodeid, TJPuAuthSnapRsp* message, u32 context);
u32 stack_auth_cancel_snap(u32 inst, u32 nodeid,TJPuAuthSnapCancel* message );
typedef void (*stack_auth_snap_cancel_rsp_func)(u32 inst, u32 nodeid, TJPuAuthSnapCancelRsp* message, u32 context);

typedef void (*stack_authed_send_picture_func)(u32 inst, u32 nodeid, TJPuSendPictureNtf* message, u32 context);

//device
typedef void (*stack_auth_snap_func)(u32 inst, u32 nodeid, TJPuAuthSnap* message, u32 context);
u32 stack_auth_snap_rsp(u32 inst, u32 nodeid,TJPuAuthSnapRsp* message );
typedef void (*stack_auth_snap_cancel_func)(u32 inst, u32 nodeid, TJPuAuthSnapCancel* message, u32 context);
u32 stack_auth_snap_cancel_rsp(u32 inst, u32 nodeid,TJPuAuthSnapCancelRsp* message );
u32 stack_authed_send_picture(u32 inst, u32 nodeid,TJPuSendPictureNtf* message );

typedef void (*stack_transparent_channel_func)(u32 inst, u32 nodeid, TJPuTransparentChnl* message, u32 context);//shm add for transparent channel test.

//<<---add by zlz
//sdk
typedef void (*sdk_stack_gps_information_notify_func)(u32 inst, u32 nodeid, TJPuDeviceGpsNtf *message, u32 context);
typedef void (*sdk_stack_wireless_signal_notify_func)(u32 inst, u32 nodeid, TJPuDeviceNetNtf *message, u32 context);
//added by fzp 
typedef void (*sdk_stack_charge_quit_call_wait)(u32 inst, u32 nodeid, TJLChargeCallCancelNtf *message, u32 context);
//end
//Back call added by fzp
typedef void (*sdk_stack_back_call_confirm_rsp)(u32 inst, u32 nodeid, TJLBackCallConfirmRsp *message, u32 context);
typedef void (*sdk_stack_back_call_success_rsp)(u32 inst, u32 nodeid, TJLBackCallrsp *message, u32 context);
typedef void (*sdk_stack_back_call_cancel_rsp)(u32 inst, u32 nodeid, TJLBackCallCancelRsp *message, u32 context);
//end
typedef void (*sdk_stack_picdata_transf_devevent_cb_func)(u32 inst, u32 nodeid, TJPuSendPictureNtf *message, u32 context);
u32 sdk_stack_picdata_transf_event_notify(u32 inst, u32 nodeid, TJPuSendPictureNtf *message);
typedef void(*sdk_stack_dev_online_action_cb_func)(u32 inst, u32 nodeid, TJPuOnlineAction* message);
u32 sdk_stack_lens_ctrl_req(u32 inst, u32 nodeid, TJPuLensCtrlReq *message);
typedef void(*sdk_stack_lens_ctrl_rsp_func)(u32 inst, u32 nodeid, TJPuLensCtrlRsp *message, u32 context);
//dev
u32 dev_stack_gps_information_notify(u32 inst, u32 nodeid, TJPuDeviceGpsNtf *message);
u32 dev_stack_wireless_singal_notify(u32 inst, u32 nodeid, TJPuDeviceNetNtf *message);
u32 dev_stack_picdata_transf_event_notify(u32 inst, u32 nodeid, TJPuSendPictureNtf* message);
typedef void (*dev_stack_picdata_transf_sdkevent_cb_func)(u32 inst, u32 nodeid, TJPuSendPictureNtf *message, u32 context);
u32 dev_stack_online_action(u32 inst, u32 nodeid, TJPuOnlineAction* message);
typedef void (*dev_stack_lens_ctrl_req_func)(u32 inst, u32 nodeid,TJPuLensCtrlReq *message, u32 context);
u32 dev_stack_lens_ctrl_rsp(u32 inst, u32 nodeid, TJPuLensCtrlRsp *message);

typedef void (*dev_stack_charge_change_func)(u32 dwInstID, u32 dwNodeId, TJLPuChargeChangeRsp* ptMsg, u32 dwContext);
//--->>

typedef u32 (*dev_stack_charge_quit_call_wait_func)(u32 inst, u32 nodeid, TJLChargeCallCancelNtf *message);
u32 dev_stack_charge_quit_call_wait(u32 inst, u32 nodeid, TJLChargeCallCancelNtf *message);

//shm added for transparent channel test.
u32 dev_stack_transparent_channel_notify(u32 inst, u32 nodeid, TJToCuTransparentChnl* message);

typedef struct tagJLPuStack_AllCB
{
	//公共
	JLPuStack_DisconnectNtfCB m_pfunDisconnectNtf;
	
	//Sdk端
	JLPuStack_ConnectAcceptNtfCB m_pfunConnectAcceptNtf;
	TJLPuStack_LoginReqCB	m_pfunLoginReq;
	
	TJLPuStack_LogoutReqCB	m_pfunLogoutReq;
	TJLPuStack_MediaSwitchRspCB	m_pfunMediaSwitchRsp;
	TJLPuStack_PuSnapPicRspCB	m_pfunPuSnapPicRsp;
	TJLPuStack_PuChargeCallReqCB	m_pfunuChargeCallReq;
	TJLPuStack_PuChargeBreakNtfCB	m_pfunPuChargeBreakNtf;

	TJLPuStack_MediaSwitchMdfRspCB m_pfunMediaSwitchMdfRsp;
	TJLPuStack_ParamCfgRspCB m_pfunParamCfgRsp;
	TJLPuStack_ParamMdfNtfCB m_pfunParamMdfNtf;
	TJLPuStack_GetReportRuleReqCB m_pfunReportRuleReq;
	JLPuStack_Cu2PuTransparentDataSendRspCB  m_pfunCu2PuDataSendRsp;
	JLPuStack_Pu2CuTransparentDataSendReqCB  m_pfunPu2CuDataSendReq; 

	//Pu设备端
	TJLPuStack_AsyConnectRspCB m_pfunAsyConnectRsp;
	TJLPuStack_LoginRspCB	m_pfunLoginRsp;
	TJLPuStack_LogoutRspCB	m_pfunLogoutRsp;
	TJLPuStack_MediaSwitchReqCB	m_pfunMediaSwitchReq;
	TJLPuStack_MediaStopCmdCB	m_pfunMediaStopCmd;
	TJLPuStack_PuSnapPicReqCB	m_pfunPuSnapPicReq;
	TJLPuStack_PuChargeCallRspCB	m_pfunPuChargeCallRsp;
	TJLPuStack_PuChargeCallRspCB2	m_pfunPuChargeCallRsp2;
	TJLPuStack_ChargeCompleteNtfCB	m_pfunChargeCompleteNtf;
		
	TJLPuStack_MediaSwitchMdfReqCB	m_pfunMediaSwitchMdfReq;
	TJLPuStack_ParamCfgReqCB		m_pfunParamCfgReq;
	TJLPuStack_TransparentDataSendNtfCB m_pfunTransparentDataSendNtf;

	TJLPuStack_PicFileDataSendNtfCB m_pfunPicFileDataSendNtf;
	TJLPuStack_GetReportRuleRspCB  m_pfunReportRuleRsp;


	JLPuStack_Pu2CuTransparentDataSendRspCB  m_pfunPu2CuDataSendRsp;
	JLPuStack_Cu2PuTransparentDataSendReqCB  m_pfunCu2PuDataSendReq;

	/*new function callbacks,add by bradlee 2013-7-16*/
	//sdk
	stack_auth_snap_rsp_func			auth_snap_rsp_func;
	stack_auth_snap_cancel_rsp_func		auth_snap_cancel_rsp_func;
	stack_authed_send_picture_func      authed_send_picture_func;
	//add by zlz -->>
	sdk_stack_gps_information_notify_func sdk_gps_information_notify;
	sdk_stack_wireless_signal_notify_func sdk_wireless_signal_notify;
	
//	sdk_stack_cancel_picdata_transf_func  sdk_stack_cancel_picdata_transf;
	sdk_stack_picdata_transf_devevent_cb_func sdk_stack_picdata_transf_devevent_cb;
	sdk_stack_dev_online_action_cb_func sdk_stack_dev_online_action_cb;
	sdk_stack_lens_ctrl_rsp_func  sdk_stack_lens_ctrl_rsp;
	//device
//	dev_stack_cancel_picdata_transf_func  dev_stack_cancel_picdata_transf;
	dev_stack_picdata_transf_sdkevent_cb_func dev_stack_picdata_transf_sdkevent_cb;
	dev_stack_lens_ctrl_req_func dev_stack_lens_ctrl_req;
	dev_stack_charge_change_func dev_stack_charge_change;
	// <<--add by zlz
	stack_auth_snap_func                auth_snap_func;
	stack_auth_snap_cancel_func			auth_snap_cancel_func;
	// added by fzp
	TJLPuStack_CallQueueCntNtfCB m_pfunCallQueueNtfRsp;
	sdk_stack_charge_quit_call_wait  sdk_call_quit_call_wait;
	// end
	// Back call added by fzp
	TJLPuStack_BackCallReq m_pfunBackCallReq;
	sdk_stack_back_call_confirm_rsp sdk_back_call_confirm_rsp;
	sdk_stack_back_call_success_rsp sdk_back_call_success_rsp;
	TJLPuStack_BackCallCancelReq m_pfunBackCallCancelReq;
	sdk_stack_back_call_cancel_rsp sdk_back_call_cancel_rsp;
	// end
	
	stack_transparent_channel_func 		transparent_channel_func;//shm add for transparent channel test.
	

}TJLPuStack_AllCB;

//注册回调函数
u32 JLPuStack_CBReg( u32 dwInstID, TJLPuStack_AllCB *ptAllCB, u32 dwContext );

#ifdef __cplusplus
}
#endif

#endif //_JL_PU_STACK_H_
