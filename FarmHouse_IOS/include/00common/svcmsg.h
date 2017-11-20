#ifndef _H_VSS_MSG_
#define _H_VSS_MSG_

//ÿ����Ϣ���й�������ϢͷTVSSCommMsgHead, ������Ե���Ϣ��

/************************************************************************
 *                               UISvc                            *
 ************************************************************************/ 
typedef enum EVssUISvcMsg
{
	//CU����
	UI_SVC_USER_LOGIN_REQ = VSS_UI_SVC_MSG_BASE ,   //�û���½����UISvc-->CuAccessSvc TVSSUserLoginReq
	UI_SVC_USER_LOGIN_RSP,							//�û���½�ظ�CuAccessSvc-->UISvc TVSSUserLoginRsp

	UI_SVC_USER_LOGIN_COMPLETE_NTF,		//�û���¼���֪ͨ CuAccessSvc-->UISvc u32��dwResult ����ͬ�������

	UI_SVC_USER_LOGOUT_REQ,				//�û�ע����½����UISvc-->CuAccessSvc TVSSUserLogoutReq
	UI_SVC_USER_LOGOUT_RSP,				//�û�ע����½�ظ�CuAccessSvc-->UISvc TVSSUserLogoutRsp

	UI_SVC_DISCONNECT_NTF,				//����֪ͨ CuAccessSvc-->UISvc u32���ޣ�

	UI_SVC_USER_PWDMDF_REQ,				//�û��޸���������UISvc-->CuAccessSvc TVSSUserPwdMdfReq
	UI_SVC_USER_PWDMDF_RSP,				//�û��޸�����ظ�CuAccessSvc-->UISvc TVSSUserPwdMdfRsp

	UI_SVC_REALMEDIA_SWITCH_REQ,		//ʵʱý�彻������UISvc-->MediaSvc TVSSRealMediaSwitchReq
	UI_SVC_REALMEDIA_SWITCH_RSP,		//ʵʱý�彻���ظ�MediaSvc-->UISvc TVSSRealMediaSwitchRsp

	UI_SVC_MEDIASWITCH_CHANGE_REQ,		//ʵʱý�彻��ת������UISvc-->MediaSvc TVSSRealMediaSwitchReq��ͬý�彻��������Ϣ�壩
	UI_SVC_MEDIASWITCH_CHANGE_RSP,		//ʵʱý�彻��ת�ƻظ�MediaSvc-->UISvc TVSSRealMediaSwitchRsp��ͬý�彻���ظ���Ϣ�壩

	UI_SVC_MEDIASWITCH_STOP_CMD,		//ʵʱý�彻��ֹͣ���� UISvc-->MediaSvc TVSSMediaSwitchStopCmd

	UI_SVC_PICFILE_TRANS_CHN_CREATE_REQ, //ͼƬ�ļ�����ͨ����������UISvc-->MediaSvc TVSSPicFileTransChnCreateReq
	UI_SVC_PICFILE_TRANS_CHN_CREATE_RSP, //ͼƬ�ļ�����ͨ�������ظ�MediaSvc-->UISvc TVSSPicFileTransChnCreateRsp

	UI_SVC_PICFILE_TRANS_CHN_DEL_CMD,		//ͼƬ�ļ�����ͨ����������UISvc-->MediaSvc TVSSPicFileTransChnDelCmd	
	UI_SVC_PICFILE_TRANS_CHN_DISCONNECT_NTF,//ͼƬ�ļ�����ͨ���Ͽ�֪ͨ MediaSvc-->UISvc u32���ޣ�

	UI_SVC_PU_SNAPPIC_REQ,				//�豸ץͼ���� UISvc-->MediaDispSvc TVSSPuSnapPicReq
	UI_SVC_PU_SNAPPIC_RSP,				//�豸ץͼ�ظ� MediaDispSvc-->UISvc TVSSPuSnapPicRsp

	UI_SVC_PIC_DOWNLOAD_PROGRESS_NTF,	//�ͻ���ͼƬ���ؽ���֪ͨ MediaDispSvc-->UISvc			 //TVSSPicDLProgressNtf

	//���ն����ض���Ϣ
	UI_SVC_PU_CHARGE_CALL_REQ = VSS_UI_SVC_MSG_BASE+300,	//����������� AgentSvc-->UISvc TVSSChargeCallReq
	UI_SVC_PU_CHARGE_CALL_RSP,								//������лظ� UISvc-->AgentSvc TVSSChargeCallRsp
	UI_SVC_PU_CHARGE_BREAK_NTF,						 //�����ж�֪ͨ AgentSvc-->UISvc (u32 �ж�ԭ�� ��ChargeComm.h��EChargeBreakType��

	UI_SVC_CHARGE_SUBMIT_REQ,						 //��������ύ���� AgentSvc-->UISvc TVSSChargeSubmitReq
	UI_SVC_CHARGE_SUBMIT_RSP,						 //��������ύ�ظ� UISvc-->AgentSvc TVSSChargeSubmitRsp

// 	UI_SVC_FREE_CULIST_GET_REQ,						 //������ϯ�б��ȡ���� AgentSvc-->UISvc TVSSFreeAgentListGetReq
// 	UI_SVC_FREE_CULIST_GET_RSP,						 //������ϯ�б��ȡ�ظ� UISvc-->AgentSvc TVSSFreeAgentListGetRsp

	UI_SVC_CHARGE_TRANSFER_REQ,						 //����ת������ AgentSvc-->UISvc TVSSChargeTransferReq
	UI_SVC_CHARGE_TRANSFER_RSP,						 //����ת���ظ� UISvc-->AgentSvc TVSSChargeTransferRsp

	UI_SVC_WORKSTATUS_SET_REQ,						 //��ϯ����״̬�������� AgentSvc-->UISvc TVSSWorkStatusSetReq
	UI_SVC_WORKSTATUS_SET_RSP,						 //��ϯ����״̬���ûظ� UISvc-->AgentSvc TVSSWorkStatusSetRsp

	UI_SVC_WORKSTATUS_NTF,							//��ϯ����״̬֪ͨ UISvc-->AgentSvc TVSSWorkStatusNtf
// 	UI_SVC_PU_OFFLINE_NTF,							//���ڶ�����豸����֪ͨ UISvc-->AgentSvc TVSSChargePuOfflineNtf

	//��������
}EVssUISvcMsg;


/************************************************************************
 *                               DirSvc                            *
 ************************************************************************/ 
typedef enum EVssDirSvcMsg
{
	DIR_SVC_USER_PWDMDF_REQ = VSS_DIR_SVC_MSG_BASE ,   //�û��޸���������CuAccSvc(CMS)-->DirSvc(CMS) TVSSUserPwdMdfReq
	DIR_SVC_USER_PWDMDF_RSP,						   //�û��޸�����ظ�DirSvc(CMS)-->CuAccSvc(CMS) TVSSUserPwdMdfRsp

	DIR_SVC_SYSLOG2DB_NTF,							   //�����ݿ��м�¼��־֪ͨ AllSvc(������Ҫ��¼��־�����ݿ�ķ���)-->DirSvc(CMS) TVSSLogMetaData

}EVssDirSvcMsg;


/************************************************************************
 *                               CuAccessSvc                            *
 ************************************************************************/ 
typedef enum EVssCuAccessSvcMsg
{
	CUACCESS_SVC_USER_LOGIN_REQ = VSS_CUACCESS_SVC_MSG_BASE ,   //�û���½����CU-->CMS TVSSUserLoginReq
	CUACCESS_SVC_USER_LOGIN_RSP,								//�û���½�ظ�CMS-->CU TVSSUserLoginRsp

	CUACCESS_SVC_USER_LOGOUT_REQ,								//�û�ע����½����CU-->CMS TVSSUserLogoutReq
	CUACCESS_SVC_USER_LOGOUT_RSP,								//�û�ע����½�ظ�CMS-->CU TVSSUserLogoutRsp

// 	CUACCESS_SVC_USER_PWDMDF_REQ,								//�û��޸���������CU-->CMS TVSSUserPwdMdfReq
// 	CUACCESS_SVC_USER_PWDMDF_RSP,								//�û��޸�����ظ�CMS-->CU TVSSUserPwdMdfRsp

	CUACCESS_SVC_USER_SSN_STATUS_NTF,							//�û��Ự״̬֪ͨSuAccSvc-->AgentSvc/MediaSvc(CMS) TVSSUserSsnStatusNtf
	//�����Ǹ���ҵ�ͻ�����Ϣ
	//���ն���
// 	CUACCESS_SVC_AGENTINFO_GET_REQ = VSS_CUACCESS_SVC_MSG_BASE + 500 ,	//������ϯ��Ϣ��ȡ����CU-->CMS TVSSAgentInfoReq
// 	CUACCESS_SVC_AGENTINFO_GET_RSP,										//������ϯ��Ϣ��ȡ�ظ�CMS-->CU TVSSAgentInfoRsp

}EVssCuAccessSvcMsg;

/************************************************************************
 *                               CmuAccessSvc                           *
 ************************************************************************/ 
typedef enum EVssCmuAccessSvcMsg
{
	CMUACCESS_SVC_LOGIN_CMS_REQ = VSS_CMUACCESS_SVC_MSG_BASE ,   //CMS��½����MDS��RECS��TVWS��-->CMS TVSSLoginCmsReq
	CMUACCESS_SVC_LOGIN_CMS_RSP,								 //CMS��½�ظ�CMS-->MDS��RECS��TVWS�� TVSSLoginCmsRsp

	CMUACCESS_SVC_PU_LIST_GET_REQ,								//��ȡ����������ص�ǰ���豸�б�����MDS��RECS��TVWS��-->CMS TVSSPuListGetReq
	CMUACCESS_SVC_PU_LIST_GET_RSP,								//��ȡ����������ص�ǰ���豸�б�ظ�CMS-->MDS��RECS��TVWS�� TVSSPuListGetRsp

	CMUACCESS_SVC_PUCHN_LIST_GET_REQ,							//��ȡ�豸ͨ���б����� MDS��RECS��TVWS��-->CMS TVSSPuChnListGetReq
	CMUACCESS_SVC_PUCHN_LIST_GET_RSP,							//��ȡ�豸ͨ���б�ظ� CMS-->MDS��RECS��TVWS�� TVSSPuChnListGetRsp

	CMUACCESS_SVC_CMU_SSN_STATUS_NTF,							//���ķ�������Ԫ�Ự״̬֪ͨ CmuAccSvc-->PuAccSvc/MediaSvc/AgentSvc TVSSCmuSsnStatusNtf

	//���ö���仯����CMS-->MDS��RECS��TVWS�ȣ����豸��ͨ��������ɾ�ĵȵ� 
	//ҵ��SVC������Ϣʹ��VssObjChangeBodyPack��VssObjChangeBodyParse
// 	CMUACCESS_SVC_OBJCFG_CHANGE_RPT= VSS_CMUACCESS_SVC_MSG_BASE + 500,
}EVssCmuAccessSvcMsg;


/************************************************************************
 *                               PuAccessSvc                                 *
 ************************************************************************/ 
typedef enum EVssPuAccessSvcMsg
{
	PUACCESS_SVC_PU_STATUS_CHNAGE_NTF = VSS_PUACCESS_SVC_MSG_BASE ,    //ǰ���豸״̬�仯֪ͨMDS-->CMS�� TVSSPuStatusNtf

// 	PUACCESS_SVC_PU_STATUS_SUBSCRIBE_CMD,  //����״̬����CU-->CMS TVSSPuStatusSubscCmd

// 	PUACCESS_SVC_PTZCTRL_REQ,                 //��̨�������� TVSSPTZCtrlReq
// 	PUACCESS_SVC_PTZCTRL_RSP,                 //��̨���ƻظ� TVSSPTZCtrlRsp
// 
// 	PUACCESS_SVC_SERIALSND_REQ,               //͸��ͨ���������� TVSSSerialSndReq
// 	PUACCESS_SVC_SERIALSND_RSP,               //͸��ͨ������ظ� TVSSSerialSndRsp

//���½ӿ����DVRǰ�˷���
// 	PUACCESS_SVC_RECQUERY_REQ,                //¼���ѯ���� TVSSRecQueryReq
// 	PUACCESS_SVC_RECQUERY_FILE_RSP,           //¼���ѯ�ļ���ʽ�ظ� TVSSRecQueryFileRsp
// 	PUACCESS_SVC_RECQUERY_TIMESECT_RSP,       //¼���ѯʱ��λظ� TVSSRecQueryTimeSectRsp
}EVssPuAccessSvcMsg;



/************************************************************************/
/*                               MediaDispSvc                               */
/************************************************************************/ 
typedef enum EVssMediaSvcMsg
{
	MEDIADISP_SVC_REALMEDIA_SWITCH_REQ = VSS_MEDIADISP_SVC_MSG_BASE,//ʵʱý�彻������CU-->CMS-->MDS TVSSRealMedialSwitchReq
	MEDIADISP_SVC_REALMEDIA_SWITCH_RSP,                             //ʵʱý�彻���ظ�MDS-->CMS-->CU TVSSRealMedialSwitchRsp

	MEDIADISP_SVC_MEDIASWITCH_CHANGE_REQ,		//ý�彻��ת������CU-->CMS-->MDS TVSSRealMedialSwitchReq(��Ϣ��ͬý�彻������
	MEDIADISP_SVC_MEDIASWITCH_CHANGE_RSP,		//ý�彻��ת�ƻظ�MDS-->CMS-->CU TVSSRealMedialSwitchRsp

	MEDIADISP_SVC_MEDIASWITCH_STOP_CMD,			//ý�彻��ֹͣ���� CU-->CMS-->MDS TVSSMedialSwitchStopCmd

	MEDIADISP_SVC_PICFILE_TRANS_CHN_CREATE_REQ, //ͼƬ�ļ�����ͨ����������CU-->MDS TVSSPicFileTransChnCreateReq
	MEDIADISP_SVC_PICFILE_TRANS_CHN_CREATE_RSP, //ͼƬ�ļ�����ͨ�������ظ�MDS-->CU TVSSPicFileTransChnCreateRsp

	MEDIADISP_SVC_PICFILE_TRANS_CHN_DEL_CMD,	 //ͼƬ�ļ�����ͨ����������CU-->MDS TVSSPicFileTransChnDelCmd	

	MEDIADISP_SVC_PU_SNAPPIC_REQ,			//�豸ץͼ���� CU-->MDS TVSSPuSnapPicReq
	MEDIADISP_SVC_PU_SNAPPIC_RSP,			//�豸ץͼ�ظ� MDS-->CU TVSSPuSnapPicRsp

// 	MEDIADISP_SVC_PIC_DOWNLOAD_PROGRESS_NTF, //ý���������ǰ������ͼƬ����֪ͨ MediaDispSvc-->UISvc  //TVSSPuPicDLProgressNtf
// 	MEDIADISP_SVC_PIC_DOWNLOAD_COMPLETE_NTF, //ý���������ǰ������ͼƬ���֪ͨ MDS-->CMS-->CU TVSSPuPicDLCompleteNtf

}EVssMediaSvcMsg;

/************************************************************************/
/*                               AgentSvc ��ϯ���ͷ������ȷ���         */
/************************************************************************/ 
typedef enum EVssAgentSvcMsg
{
	AGENT_SVC_PU_CHARGE_CALL_REQ = VSS_AGENT_SVC_MSG_BASE,//����������� MDS-->CMS-->CU TVSSChargeCallReq
	AGENT_SVC_PU_CHARGE_CALL_RSP,							 //������лظ� CU-->CMS-->MDS TVSSChargeCallRsp

	AGENT_SVC_CHARGE_SUBMIT_REQ,						 //��������ύ���� CU-->CMS TVSSChargeSubmitReq
	AGENT_SVC_CHARGE_SUBMIT_RSP,						 //��������ύ�ظ� CMS-->CU TVSSChargeSubmitRsp
	AGENT_SVC_CHARGE_COMPLETE_NTF,						 //�������֪ͨ CMS-->MDS TVSSChargeCompleteNtf

// 	AGENT_SVC_FREE_CULIST_GET_REQ,						 //������ϯ�б��ȡ���� CU-->CMS TVSSFreeAgentListGetReq
// 	AGENT_SVC_FREE_CULIST_GET_RSP,						 //������ϯ�б��ȡ�ظ� CMS-->CU TVSSFreeAgentListGetRsp

	AGENT_SVC_CHARGE_TRANSFER_REQ,						 //����ת������ CU-->CMS TVSSChargeTransferReq
	AGENT_SVC_CHARGE_TRANSFER_RSP,						 //����ת���ظ� CMS-->CU TVSSChargeTransferRsp

	AGENT_SVC_WORKSTATUS_SET_REQ,						 //��ϯ����״̬�������� CU-->CMS TVSSWorkStatusSetReq
	AGENT_SVC_WORKSTATUS_SET_RSP,						 //��ϯ����״̬���ûظ� CMS-->CU TVSSWorkStatusSetRsp

	AGENT_SVC_WORKSTATUS_NTF = VSS_AGENT_SVC_MSG_BASE + 500,//��ϯ����״̬֪ͨ CMS-->CU TVSSWorkStatusNtf
	AGENT_SVC_PU_OFFLINE_NTF,							//���ڶ�����豸����֪ͨ CMS-->CU TVSSChargePuOfflineNtf
}EVssAgentSvcMsg;

#endif
