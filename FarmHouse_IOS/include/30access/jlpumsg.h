#ifndef _H_JL_PU_MSG_
#define _H_JL_PU_MSG_

#define JL_PU_MSG_BASE  1000
/************************************************************************
 *        京联前端设备通信协议栈（信令部分消息定义）					*
 ************************************************************************/ 
typedef enum EJLPuMsg
{
	//CU部分
	JL_PU_MSG_LOGIN_REQ = JL_PU_MSG_BASE ,   //登陆CMS请求Pu-->Sdk TJLPuLoginReq
	JL_PU_MSG_LOGIN_RSP,					 //登陆CMS回复Sdk-->Pu TJLPuLoginRsp

	JL_PU_MSG_GET_REPORT_RULE_REQ,
	JL_PU_MSG_GET_REPORT_RULE_RSP,
	JL_PU_MSG_LOGOUT_REQ,				//注销登陆CMS请求Pu-->Sdk TJLPuLogoutReq
	JL_PU_MSG_LOGOUT_RSP,				//注销登陆CMS回复Sdk-->Pu TJLPuLogoutRsp

	JL_PU_MSG_REALMEDIA_SWITCH_REQ,		//实时媒体交换请求Sdk-->Pu TJLPuRealMediaSwitchReq
	JL_PU_MSG_REALMEDIA_SWITCH_RSP,		//实时媒体交换回复Pu-->Sdk TJLPuRealMediaSwitchRsp

	JL_PU_MSG_MEDIASWITCH_MDF_REQ,		//实时媒体交换请求Sdk-->Pu TJLPuRealMediaSwitchReq
	JL_PU_MSG_MEDIASWITCH_MDF_RSP,		//实时媒体交换回复Pu-->Sdk TJLPuRealMediaSwitchRsp

	JL_PU_MSG_MEDIASWITCH_STOP_CMD,		//实时媒体交换停止命令Sdk-->Pu TJLPuRealMediaStopCmd

	JL_PU_MSG_SNAPPIC_REQ,				//设备抓图请求 Sdk-->Pu TJLPuSnapPicReq
	JL_PU_MSG_SNAPPIC_RSP,				//设备抓图回复 Pu-->Sdk TJLPuSnapPicRsp

	JL_PU_MSG_PARAMCFG_REQ,				//参数配置请求 Sdk-->Pu TJLParamCfgReq
	JL_PU_MSG_PARAMCFG_RSP,				//参数配置回复 Pu-->Sdk TJLParamCfgRsp
	JL_PU_MSG_PARAMMDF_NTF,				//参数修改通知 Pu-->Sdk TJLParamMdfNtf

	JL_PU_MSG_TRANSDATA_SND_CMD,		//透明数据发送命令Sdk-->Pu TJLTransparentDataSndCmd

	JL_PU_MSG_PICFILEDATA_SND_CMD,		//图片文件数据发送命令Sdk-->Pu TJLTransparentDataSndCmd
	
	JL_PU_MSG_PU2CU_TRANSDATA_SND_REQ,
	JL_PU_MSG_PU2CU_TRANSDATA_SND_RSP,
	JL_PU_MSG_CU2PU_TRANSDATA_SND_REQ,
	JL_PU_MSG_CU2PU_TRANSDATA_SND_RSP,
// 	JL_PU_MSG_FILETRANS_CONNECT_REQ,	//文件传输连接请求 Sdk-->Pu TJLPuFTConReq
// 	JL_PU_MSG_FILETRANS_CONNECT_RSP,	//文件传输连接回复 Pu-->Sdk TJLPuFTConRsp

	//保险定损特定消息
	JL_PU_MSG_CHARGE_CALL_REQ = JL_PU_MSG_BASE+300,	//定损呼叫请求 Pu-->Sdk TJLPuChargeCallReq
	JL_PU_MSG_CHARGE_CALL_RSP,						//定损呼叫回复 Sdk-->Pu TJLPuChargeCallRsp

	JL_PU_MSG_CHARGE_BREAK_NTF,						//定损中断通知 Pu-->Sdk TJLPuChargeBreakNtf
	JL_PU_MSG_CHARGE_COMPLETE_NTF,					//定损完成通知 Sdk-->Pu TJLPuChargeCompleteNtf
	
	JL_PU_MSG_CHARGE_CALL_REQ_2,		//新设备(相机)发送定损请求的指令，复用 JL_PU_MSG_CHARGE_CALL_REQ
	//使用的结构体 Pu-->Sdk TJLPuChargeCallReq
	JL_PU_MSG_CHARGE_CALL_RSP_2,		//定损呼叫回复2，对应新的定损请求指令，
	//使用的结构体也不一样： Sdk-->Pu TJLPuChargeCallRsp2

	JL_PU_MSG_AUTH_DEVICE_SNAP_NTF = JL_PU_MSG_CHARGE_COMPLETE_NTF +500, //授权前端设备拍照 sdk->pu
	JL_PU_MSG_AUTH_DEVICE_SNAP_RSP, 									//授权前端设备拍照响应 pu->sdk
	JL_PU_MSG_AUTH_DEVICE_SNAP_CANCEL,									//取消前端设备拍照 sdk->pu
	JL_PU_MSG_AUTH_DEVICE_SNAP_CANCEL_RSP,								//取消前端设备拍照 pu->sdk

	JL_PU_MSG_AUTHED_DEVICE_SEND_PICTURE_NTF,							//设备传照片通知   pu->sdk
	JL_PU_MSG_DEVICE_INFO_NTF,											//设备信息通知     pu->sdk
	JL_PU_MSG_CTRL_LENS_REQ,											//调整设备摄像头参数请求 sdk->pu
	JL_PU_MSG_CTRL_LENS_RSP,											//调整设备摄像头参数回复 pu->sdk
   // add by zlz 
	JL_PU_MSG_DEV_GPS_INFO_NTF,                                // gps information notify. pu->sdk
	JL_PU_MSG_DEV_NET_SIGNAL_NTF,                              // wireless signal notify. pu->sdk
	
	JL_PU_MSG_DEV_DATA_TRANSF_EVENT,                           // cancel data transport . pu->sdk
	JL_PU_MSG_CLIENT_DATA_TRANSF_EVENT,                        // cancel data transport . sdk->pu
	JL_PU_MSG_DEV_ONLINE_ACTION,                               // device exit.            pu->sdk
	JL_PU_MSG_CHARGE_CHANGE_RSP,										// 定损转接通知 sdk->pu
	// added by fzp
	JL_PU_MSG_CALL_QUEUE_CNT_NTF,					//队列信息通知 Sdk-->Pu TJLCallQueueCntNtf 
	JL_PU_MSG_CHARGE_CALL_CANCEL_NTF,							// quit the ording, don't wait pu->sdk
	// end
	// Back call added by fzp	
	JL_PU_MSG_BACK_CALL_REQ,								// Backcall request  Sdk --> Pu 
	JL_PU_MSG_BACK_CALL_CONFIRM_RSP, 						// Backcall confirm response  Pu--> Sdk
	JL_PU_MSG_TRANSPARENT_CHANNEL_NTF,						//shm add for transparent channel test.
	JL_TO_CU_MSG_TRANSPARENT_CHANNEL_NTF,						//shm add for transparent channel test.
	//下面三条消息服务器暂时不支持
	JL_PU_MSG_BACK_CALL_FAIL_RSP,							// Backcall FAIL(outOftime, refuse) Pu--> Sdk
	JL_PU_MSG_BACK_CALL_CONCELL_REQ,						// Backcall concell request (Sdk --> Pu)
	JL_PU_MSG_BACK_CALL_CONCELL_RSP,						// Backcall concell response (Pu --> Sdk)
	
	// end
	
}EJLPuMsg;


#endif
