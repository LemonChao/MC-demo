#ifndef _H_VSS_MSG_
#define _H_VSS_MSG_

//每条消息都有公共的消息头TVSSCommMsgHead, 后跟各自的消息体

/************************************************************************
 *                               UISvc                            *
 ************************************************************************/ 
typedef enum EVssUISvcMsg
{
	//CU部分
	UI_SVC_USER_LOGIN_REQ = VSS_UI_SVC_MSG_BASE ,   //用户登陆请求UISvc-->CuAccessSvc TVSSUserLoginReq
	UI_SVC_USER_LOGIN_RSP,							//用户登陆回复CuAccessSvc-->UISvc TVSSUserLoginRsp

	UI_SVC_USER_LOGIN_COMPLETE_NTF,		//用户登录完成通知 CuAccessSvc-->UISvc u32（dwResult 数据同步结果）

	UI_SVC_USER_LOGOUT_REQ,				//用户注销登陆请求UISvc-->CuAccessSvc TVSSUserLogoutReq
	UI_SVC_USER_LOGOUT_RSP,				//用户注销登陆回复CuAccessSvc-->UISvc TVSSUserLogoutRsp

	UI_SVC_DISCONNECT_NTF,				//断链通知 CuAccessSvc-->UISvc u32（无）

	UI_SVC_USER_PWDMDF_REQ,				//用户修改密码请求UISvc-->CuAccessSvc TVSSUserPwdMdfReq
	UI_SVC_USER_PWDMDF_RSP,				//用户修改密码回复CuAccessSvc-->UISvc TVSSUserPwdMdfRsp

	UI_SVC_REALMEDIA_SWITCH_REQ,		//实时媒体交换请求UISvc-->MediaSvc TVSSRealMediaSwitchReq
	UI_SVC_REALMEDIA_SWITCH_RSP,		//实时媒体交换回复MediaSvc-->UISvc TVSSRealMediaSwitchRsp

	UI_SVC_MEDIASWITCH_CHANGE_REQ,		//实时媒体交换转移请求UISvc-->MediaSvc TVSSRealMediaSwitchReq（同媒体交换请求消息体）
	UI_SVC_MEDIASWITCH_CHANGE_RSP,		//实时媒体交换转移回复MediaSvc-->UISvc TVSSRealMediaSwitchRsp（同媒体交换回复消息体）

	UI_SVC_MEDIASWITCH_STOP_CMD,		//实时媒体交换停止命令 UISvc-->MediaSvc TVSSMediaSwitchStopCmd

	UI_SVC_PICFILE_TRANS_CHN_CREATE_REQ, //图片文件传输通道创建请求UISvc-->MediaSvc TVSSPicFileTransChnCreateReq
	UI_SVC_PICFILE_TRANS_CHN_CREATE_RSP, //图片文件传输通道创建回复MediaSvc-->UISvc TVSSPicFileTransChnCreateRsp

	UI_SVC_PICFILE_TRANS_CHN_DEL_CMD,		//图片文件传输通道销毁命令UISvc-->MediaSvc TVSSPicFileTransChnDelCmd	
	UI_SVC_PICFILE_TRANS_CHN_DISCONNECT_NTF,//图片文件传输通道断开通知 MediaSvc-->UISvc u32（无）

	UI_SVC_PU_SNAPPIC_REQ,				//设备抓图请求 UISvc-->MediaDispSvc TVSSPuSnapPicReq
	UI_SVC_PU_SNAPPIC_RSP,				//设备抓图回复 MediaDispSvc-->UISvc TVSSPuSnapPicRsp

	UI_SVC_PIC_DOWNLOAD_PROGRESS_NTF,	//客户端图片下载进度通知 MediaDispSvc-->UISvc			 //TVSSPicDLProgressNtf

	//保险定损特定消息
	UI_SVC_PU_CHARGE_CALL_REQ = VSS_UI_SVC_MSG_BASE+300,	//定损呼叫请求 AgentSvc-->UISvc TVSSChargeCallReq
	UI_SVC_PU_CHARGE_CALL_RSP,								//定损呼叫回复 UISvc-->AgentSvc TVSSChargeCallRsp
	UI_SVC_PU_CHARGE_BREAK_NTF,						 //定损中断通知 AgentSvc-->UISvc (u32 中断原因 见ChargeComm.h中EChargeBreakType）

	UI_SVC_CHARGE_SUBMIT_REQ,						 //定损完成提交请求 AgentSvc-->UISvc TVSSChargeSubmitReq
	UI_SVC_CHARGE_SUBMIT_RSP,						 //定损完成提交回复 UISvc-->AgentSvc TVSSChargeSubmitRsp

// 	UI_SVC_FREE_CULIST_GET_REQ,						 //空闲坐席列表获取请求 AgentSvc-->UISvc TVSSFreeAgentListGetReq
// 	UI_SVC_FREE_CULIST_GET_RSP,						 //空闲坐席列表获取回复 UISvc-->AgentSvc TVSSFreeAgentListGetRsp

	UI_SVC_CHARGE_TRANSFER_REQ,						 //定损转交请求 AgentSvc-->UISvc TVSSChargeTransferReq
	UI_SVC_CHARGE_TRANSFER_RSP,						 //定损转交回复 UISvc-->AgentSvc TVSSChargeTransferRsp

	UI_SVC_WORKSTATUS_SET_REQ,						 //坐席工作状态设置请求 AgentSvc-->UISvc TVSSWorkStatusSetReq
	UI_SVC_WORKSTATUS_SET_RSP,						 //坐席工作状态设置回复 UISvc-->AgentSvc TVSSWorkStatusSetRsp

	UI_SVC_WORKSTATUS_NTF,							//坐席工作状态通知 UISvc-->AgentSvc TVSSWorkStatusNtf
// 	UI_SVC_PU_OFFLINE_NTF,							//正在定损的设备掉线通知 UISvc-->AgentSvc TVSSChargePuOfflineNtf

	//其他界面
}EVssUISvcMsg;


/************************************************************************
 *                               DirSvc                            *
 ************************************************************************/ 
typedef enum EVssDirSvcMsg
{
	DIR_SVC_USER_PWDMDF_REQ = VSS_DIR_SVC_MSG_BASE ,   //用户修改密码请求CuAccSvc(CMS)-->DirSvc(CMS) TVSSUserPwdMdfReq
	DIR_SVC_USER_PWDMDF_RSP,						   //用户修改密码回复DirSvc(CMS)-->CuAccSvc(CMS) TVSSUserPwdMdfRsp

	DIR_SVC_SYSLOG2DB_NTF,							   //往数据库中记录日志通知 AllSvc(所有需要记录日志到数据库的服务)-->DirSvc(CMS) TVSSLogMetaData

}EVssDirSvcMsg;


/************************************************************************
 *                               CuAccessSvc                            *
 ************************************************************************/ 
typedef enum EVssCuAccessSvcMsg
{
	CUACCESS_SVC_USER_LOGIN_REQ = VSS_CUACCESS_SVC_MSG_BASE ,   //用户登陆请求CU-->CMS TVSSUserLoginReq
	CUACCESS_SVC_USER_LOGIN_RSP,								//用户登陆回复CMS-->CU TVSSUserLoginRsp

	CUACCESS_SVC_USER_LOGOUT_REQ,								//用户注销登陆请求CU-->CMS TVSSUserLogoutReq
	CUACCESS_SVC_USER_LOGOUT_RSP,								//用户注销登陆回复CMS-->CU TVSSUserLogoutRsp

// 	CUACCESS_SVC_USER_PWDMDF_REQ,								//用户修改密码请求CU-->CMS TVSSUserPwdMdfReq
// 	CUACCESS_SVC_USER_PWDMDF_RSP,								//用户修改密码回复CMS-->CU TVSSUserPwdMdfRsp

	CUACCESS_SVC_USER_SSN_STATUS_NTF,							//用户会话状态通知SuAccSvc-->AgentSvc/MediaSvc(CMS) TVSSUserSsnStatusNtf
	//以下是各行业客户端消息
	//保险定损：
// 	CUACCESS_SVC_AGENTINFO_GET_REQ = VSS_CUACCESS_SVC_MSG_BASE + 500 ,	//定损坐席信息获取请求CU-->CMS TVSSAgentInfoReq
// 	CUACCESS_SVC_AGENTINFO_GET_RSP,										//定损坐席信息获取回复CMS-->CU TVSSAgentInfoRsp

}EVssCuAccessSvcMsg;

/************************************************************************
 *                               CmuAccessSvc                           *
 ************************************************************************/ 
typedef enum EVssCmuAccessSvcMsg
{
	CMUACCESS_SVC_LOGIN_CMS_REQ = VSS_CMUACCESS_SVC_MSG_BASE ,   //CMS登陆请求MDS，RECS，TVWS等-->CMS TVSSLoginCmsReq
	CMUACCESS_SVC_LOGIN_CMS_RSP,								 //CMS登陆回复CMS-->MDS，RECS，TVWS等 TVSSLoginCmsRsp

	CMUACCESS_SVC_PU_LIST_GET_REQ,								//获取本服务器相关的前端设备列表请求MDS，RECS，TVWS等-->CMS TVSSPuListGetReq
	CMUACCESS_SVC_PU_LIST_GET_RSP,								//获取本服务器相关的前端设备列表回复CMS-->MDS，RECS，TVWS等 TVSSPuListGetRsp

	CMUACCESS_SVC_PUCHN_LIST_GET_REQ,							//获取设备通道列表请求 MDS，RECS，TVWS等-->CMS TVSSPuChnListGetReq
	CMUACCESS_SVC_PUCHN_LIST_GET_RSP,							//获取设备通道列表回复 CMS-->MDS，RECS，TVWS等 TVSSPuChnListGetRsp

	CMUACCESS_SVC_CMU_SSN_STATUS_NTF,							//中心服务器单元会话状态通知 CmuAccSvc-->PuAccSvc/MediaSvc/AgentSvc TVSSCmuSsnStatusNtf

	//配置对象变化报告CMS-->MDS，RECS，TVWS等，如设备，通道的增，删改等等 
	//业务SVC处理消息使用VssObjChangeBodyPack和VssObjChangeBodyParse
// 	CMUACCESS_SVC_OBJCFG_CHANGE_RPT= VSS_CMUACCESS_SVC_MSG_BASE + 500,
}EVssCmuAccessSvcMsg;


/************************************************************************
 *                               PuAccessSvc                                 *
 ************************************************************************/ 
typedef enum EVssPuAccessSvcMsg
{
	PUACCESS_SVC_PU_STATUS_CHNAGE_NTF = VSS_PUACCESS_SVC_MSG_BASE ,    //前端设备状态变化通知MDS-->CMS等 TVSSPuStatusNtf

// 	PUACCESS_SVC_PU_STATUS_SUBSCRIBE_CMD,  //对象状态订阅CU-->CMS TVSSPuStatusSubscCmd

// 	PUACCESS_SVC_PTZCTRL_REQ,                 //云台控制请求 TVSSPTZCtrlReq
// 	PUACCESS_SVC_PTZCTRL_RSP,                 //云台控制回复 TVSSPTZCtrlRsp
// 
// 	PUACCESS_SVC_SERIALSND_REQ,               //透明通道传输请求 TVSSSerialSndReq
// 	PUACCESS_SVC_SERIALSND_RSP,               //透明通道传输回复 TVSSSerialSndRsp

//以下接口针对DVR前端放像
// 	PUACCESS_SVC_RECQUERY_REQ,                //录像查询请求 TVSSRecQueryReq
// 	PUACCESS_SVC_RECQUERY_FILE_RSP,           //录像查询文件方式回复 TVSSRecQueryFileRsp
// 	PUACCESS_SVC_RECQUERY_TIMESECT_RSP,       //录像查询时间段回复 TVSSRecQueryTimeSectRsp
}EVssPuAccessSvcMsg;



/************************************************************************/
/*                               MediaDispSvc                               */
/************************************************************************/ 
typedef enum EVssMediaSvcMsg
{
	MEDIADISP_SVC_REALMEDIA_SWITCH_REQ = VSS_MEDIADISP_SVC_MSG_BASE,//实时媒体交换请求CU-->CMS-->MDS TVSSRealMedialSwitchReq
	MEDIADISP_SVC_REALMEDIA_SWITCH_RSP,                             //实时媒体交换回复MDS-->CMS-->CU TVSSRealMedialSwitchRsp

	MEDIADISP_SVC_MEDIASWITCH_CHANGE_REQ,		//媒体交换转移请求CU-->CMS-->MDS TVSSRealMedialSwitchReq(消息体同媒体交换请求）
	MEDIADISP_SVC_MEDIASWITCH_CHANGE_RSP,		//媒体交换转移回复MDS-->CMS-->CU TVSSRealMedialSwitchRsp

	MEDIADISP_SVC_MEDIASWITCH_STOP_CMD,			//媒体交换停止命令 CU-->CMS-->MDS TVSSMedialSwitchStopCmd

	MEDIADISP_SVC_PICFILE_TRANS_CHN_CREATE_REQ, //图片文件传输通道创建请求CU-->MDS TVSSPicFileTransChnCreateReq
	MEDIADISP_SVC_PICFILE_TRANS_CHN_CREATE_RSP, //图片文件传输通道创建回复MDS-->CU TVSSPicFileTransChnCreateRsp

	MEDIADISP_SVC_PICFILE_TRANS_CHN_DEL_CMD,	 //图片文件传输通道销毁命令CU-->MDS TVSSPicFileTransChnDelCmd	

	MEDIADISP_SVC_PU_SNAPPIC_REQ,			//设备抓图请求 CU-->MDS TVSSPuSnapPicReq
	MEDIADISP_SVC_PU_SNAPPIC_RSP,			//设备抓图回复 MDS-->CU TVSSPuSnapPicRsp

// 	MEDIADISP_SVC_PIC_DOWNLOAD_PROGRESS_NTF, //媒体服务器从前端下载图片进度通知 MediaDispSvc-->UISvc  //TVSSPuPicDLProgressNtf
// 	MEDIADISP_SVC_PIC_DOWNLOAD_COMPLETE_NTF, //媒体服务器从前端下载图片完成通知 MDS-->CMS-->CU TVSSPuPicDLCompleteNtf

}EVssMediaSvcMsg;

/************************************************************************/
/*                               AgentSvc 坐席（客服）调度服务         */
/************************************************************************/ 
typedef enum EVssAgentSvcMsg
{
	AGENT_SVC_PU_CHARGE_CALL_REQ = VSS_AGENT_SVC_MSG_BASE,//定损呼叫请求 MDS-->CMS-->CU TVSSChargeCallReq
	AGENT_SVC_PU_CHARGE_CALL_RSP,							 //定损呼叫回复 CU-->CMS-->MDS TVSSChargeCallRsp

	AGENT_SVC_CHARGE_SUBMIT_REQ,						 //定损完成提交请求 CU-->CMS TVSSChargeSubmitReq
	AGENT_SVC_CHARGE_SUBMIT_RSP,						 //定损完成提交回复 CMS-->CU TVSSChargeSubmitRsp
	AGENT_SVC_CHARGE_COMPLETE_NTF,						 //定损完成通知 CMS-->MDS TVSSChargeCompleteNtf

// 	AGENT_SVC_FREE_CULIST_GET_REQ,						 //空闲坐席列表获取请求 CU-->CMS TVSSFreeAgentListGetReq
// 	AGENT_SVC_FREE_CULIST_GET_RSP,						 //空闲坐席列表获取回复 CMS-->CU TVSSFreeAgentListGetRsp

	AGENT_SVC_CHARGE_TRANSFER_REQ,						 //定损转交请求 CU-->CMS TVSSChargeTransferReq
	AGENT_SVC_CHARGE_TRANSFER_RSP,						 //定损转交回复 CMS-->CU TVSSChargeTransferRsp

	AGENT_SVC_WORKSTATUS_SET_REQ,						 //坐席工作状态设置请求 CU-->CMS TVSSWorkStatusSetReq
	AGENT_SVC_WORKSTATUS_SET_RSP,						 //坐席工作状态设置回复 CMS-->CU TVSSWorkStatusSetRsp

	AGENT_SVC_WORKSTATUS_NTF = VSS_AGENT_SVC_MSG_BASE + 500,//坐席工作状态通知 CMS-->CU TVSSWorkStatusNtf
	AGENT_SVC_PU_OFFLINE_NTF,							//正在定损的设备掉线通知 CMS-->CU TVSSChargePuOfflineNtf
}EVssAgentSvcMsg;

#endif
