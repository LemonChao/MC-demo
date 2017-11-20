#ifndef _H_JL_PU_MSG_
#define _H_JL_PU_MSG_

#define JL_PU_MSG_BASE  1000
/************************************************************************
 *        ����ǰ���豸ͨ��Э��ջ���������Ϣ���壩					*
 ************************************************************************/ 
typedef enum EJLPuMsg
{
	//CU����
	JL_PU_MSG_LOGIN_REQ = JL_PU_MSG_BASE ,   //��½CMS����Pu-->Sdk TJLPuLoginReq
	JL_PU_MSG_LOGIN_RSP,					 //��½CMS�ظ�Sdk-->Pu TJLPuLoginRsp

	JL_PU_MSG_GET_REPORT_RULE_REQ,
	JL_PU_MSG_GET_REPORT_RULE_RSP,
	JL_PU_MSG_LOGOUT_REQ,				//ע����½CMS����Pu-->Sdk TJLPuLogoutReq
	JL_PU_MSG_LOGOUT_RSP,				//ע����½CMS�ظ�Sdk-->Pu TJLPuLogoutRsp

	JL_PU_MSG_REALMEDIA_SWITCH_REQ,		//ʵʱý�彻������Sdk-->Pu TJLPuRealMediaSwitchReq
	JL_PU_MSG_REALMEDIA_SWITCH_RSP,		//ʵʱý�彻���ظ�Pu-->Sdk TJLPuRealMediaSwitchRsp

	JL_PU_MSG_MEDIASWITCH_MDF_REQ,		//ʵʱý�彻������Sdk-->Pu TJLPuRealMediaSwitchReq
	JL_PU_MSG_MEDIASWITCH_MDF_RSP,		//ʵʱý�彻���ظ�Pu-->Sdk TJLPuRealMediaSwitchRsp

	JL_PU_MSG_MEDIASWITCH_STOP_CMD,		//ʵʱý�彻��ֹͣ����Sdk-->Pu TJLPuRealMediaStopCmd

	JL_PU_MSG_SNAPPIC_REQ,				//�豸ץͼ���� Sdk-->Pu TJLPuSnapPicReq
	JL_PU_MSG_SNAPPIC_RSP,				//�豸ץͼ�ظ� Pu-->Sdk TJLPuSnapPicRsp

	JL_PU_MSG_PARAMCFG_REQ,				//������������ Sdk-->Pu TJLParamCfgReq
	JL_PU_MSG_PARAMCFG_RSP,				//�������ûظ� Pu-->Sdk TJLParamCfgRsp
	JL_PU_MSG_PARAMMDF_NTF,				//�����޸�֪ͨ Pu-->Sdk TJLParamMdfNtf

	JL_PU_MSG_TRANSDATA_SND_CMD,		//͸�����ݷ�������Sdk-->Pu TJLTransparentDataSndCmd

	JL_PU_MSG_PICFILEDATA_SND_CMD,		//ͼƬ�ļ����ݷ�������Sdk-->Pu TJLTransparentDataSndCmd
	
	JL_PU_MSG_PU2CU_TRANSDATA_SND_REQ,
	JL_PU_MSG_PU2CU_TRANSDATA_SND_RSP,
	JL_PU_MSG_CU2PU_TRANSDATA_SND_REQ,
	JL_PU_MSG_CU2PU_TRANSDATA_SND_RSP,
// 	JL_PU_MSG_FILETRANS_CONNECT_REQ,	//�ļ������������� Sdk-->Pu TJLPuFTConReq
// 	JL_PU_MSG_FILETRANS_CONNECT_RSP,	//�ļ��������ӻظ� Pu-->Sdk TJLPuFTConRsp

	//���ն����ض���Ϣ
	JL_PU_MSG_CHARGE_CALL_REQ = JL_PU_MSG_BASE+300,	//����������� Pu-->Sdk TJLPuChargeCallReq
	JL_PU_MSG_CHARGE_CALL_RSP,						//������лظ� Sdk-->Pu TJLPuChargeCallRsp

	JL_PU_MSG_CHARGE_BREAK_NTF,						//�����ж�֪ͨ Pu-->Sdk TJLPuChargeBreakNtf
	JL_PU_MSG_CHARGE_COMPLETE_NTF,					//�������֪ͨ Sdk-->Pu TJLPuChargeCompleteNtf
	
	JL_PU_MSG_CHARGE_CALL_REQ_2,		//���豸(���)���Ͷ��������ָ����� JL_PU_MSG_CHARGE_CALL_REQ
	//ʹ�õĽṹ�� Pu-->Sdk TJLPuChargeCallReq
	JL_PU_MSG_CHARGE_CALL_RSP_2,		//������лظ�2����Ӧ�µĶ�������ָ�
	//ʹ�õĽṹ��Ҳ��һ���� Sdk-->Pu TJLPuChargeCallRsp2

	JL_PU_MSG_AUTH_DEVICE_SNAP_NTF = JL_PU_MSG_CHARGE_COMPLETE_NTF +500, //��Ȩǰ���豸���� sdk->pu
	JL_PU_MSG_AUTH_DEVICE_SNAP_RSP, 									//��Ȩǰ���豸������Ӧ pu->sdk
	JL_PU_MSG_AUTH_DEVICE_SNAP_CANCEL,									//ȡ��ǰ���豸���� sdk->pu
	JL_PU_MSG_AUTH_DEVICE_SNAP_CANCEL_RSP,								//ȡ��ǰ���豸���� pu->sdk

	JL_PU_MSG_AUTHED_DEVICE_SEND_PICTURE_NTF,							//�豸����Ƭ֪ͨ   pu->sdk
	JL_PU_MSG_DEVICE_INFO_NTF,											//�豸��Ϣ֪ͨ     pu->sdk
	JL_PU_MSG_CTRL_LENS_REQ,											//�����豸����ͷ�������� sdk->pu
	JL_PU_MSG_CTRL_LENS_RSP,											//�����豸����ͷ�����ظ� pu->sdk
   // add by zlz 
	JL_PU_MSG_DEV_GPS_INFO_NTF,                                // gps information notify. pu->sdk
	JL_PU_MSG_DEV_NET_SIGNAL_NTF,                              // wireless signal notify. pu->sdk
	
	JL_PU_MSG_DEV_DATA_TRANSF_EVENT,                           // cancel data transport . pu->sdk
	JL_PU_MSG_CLIENT_DATA_TRANSF_EVENT,                        // cancel data transport . sdk->pu
	JL_PU_MSG_DEV_ONLINE_ACTION,                               // device exit.            pu->sdk
	JL_PU_MSG_CHARGE_CHANGE_RSP,										// ����ת��֪ͨ sdk->pu
	// added by fzp
	JL_PU_MSG_CALL_QUEUE_CNT_NTF,					//������Ϣ֪ͨ Sdk-->Pu TJLCallQueueCntNtf 
	JL_PU_MSG_CHARGE_CALL_CANCEL_NTF,							// quit the ording, don't wait pu->sdk
	// end
	// Back call added by fzp	
	JL_PU_MSG_BACK_CALL_REQ,								// Backcall request  Sdk --> Pu 
	JL_PU_MSG_BACK_CALL_CONFIRM_RSP, 						// Backcall confirm response  Pu--> Sdk
	JL_PU_MSG_TRANSPARENT_CHANNEL_NTF,						//shm add for transparent channel test.
	JL_TO_CU_MSG_TRANSPARENT_CHANNEL_NTF,						//shm add for transparent channel test.
	//����������Ϣ��������ʱ��֧��
	JL_PU_MSG_BACK_CALL_FAIL_RSP,							// Backcall FAIL(outOftime, refuse) Pu--> Sdk
	JL_PU_MSG_BACK_CALL_CONCELL_REQ,						// Backcall concell request (Sdk --> Pu)
	JL_PU_MSG_BACK_CALL_CONCELL_RSP,						// Backcall concell response (Pu --> Sdk)
	
	// end
	
}EJLPuMsg;


#endif
