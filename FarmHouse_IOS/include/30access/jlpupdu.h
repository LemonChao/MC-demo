#ifndef _H_JL_PU_PDU_
#define _H_JL_PU_PDU_

/************************************************************************
 *        ����ǰ���豸ͨ��Э��ջ���������Ϣ�嶨�壩					*
 ************************************************************************/ 
#define CSTRUCT

#include "../00common/uvbasetype.h"
#include "../00common/vsscomm.h"
#ifndef TNETIP
typedef u32 TNETIP; //pdu���ɹ���ר��
typedef struct TVSSNetAddr
{
	TNETIP m_tIP;
	u16 m_wPort;
}TVSSNetAddr;
#endif


//�豸��Ϣ
typedef struct TJLPuDevInfo
{
	u32 m_dwSerialNumLen;	//���кų���
	u8	m_achSerialNumber[VSS_SERIAL_MAXLEN];	// ���кŻ��豸ID��
	u8	m_byAlarmInPortNum;		// �����������
	u8	m_byAlarmOutPortNum;		// �����������
	u8	m_byDiskNum;				// Ӳ�̸���
	u8	m_byDevType;				// �豸��������
	u8	m_byVideoChanNum;			// ��Ƶͨ������
	u8  m_byAudioChanNum;         // ����ͨ����
	u32 m_dwVideoCap;				//��Ƶ������
	u32 m_dwAudioCap;				//��Ƶ������
	u32 m_dwPicCap;				//ͼƬ������
	u8  m_byRes1[16];				// ����
}TJLPuDevInfo;

// ������Ϣ
typedef struct TJLChargeInfo
{
	u32 m_dwReportNoLen;
	u8	m_achReportNo[VSS_REPORTNO_LEN];	// ������
	u32 m_dwPlateNoLen;
	u8	m_achPlateNo[VSS_PLATENO_LEN];		// ���ƺ�
} TJLChargeInfo;

//ץ��ͼƬ����
typedef struct TJLJpegParam
{
	u16	m_wPicSize;	
	u16	m_wPicQuality;
}TJLJpegParam;

//��½��֤��Ϣ
typedef struct TJLPuLoginAuthInfo
{
	u32 m_dwNameLen;
	char m_szUserName[VSS_NAME_MAXLEN];
	u32 m_dwAuthPwdLen;
	char m_szAuthPwd[VSS_PSW_MAXLEN];
}TJLPuLoginAuthInfo;

//������������
typedef struct TJLParamCfgData
{
	u32 m_dwCfgType;	//���ò�������
	u32 m_dwCfgDatLen;  //�������ݳ���
	u8  m_chCfgData[256]; //�������ݣ�����������Ӧ�ò����
}TJLParamCfgData;

//////////////////////////////////////////////////////////////////////////
// ��Ϣ�嶨��

//��Ϣͷ����
typedef struct TJLPuMsgHead
{
	u32 m_dwVersion;      //Э��汾��
	u32 m_dwHeadLength;   //Э��ͷ����
	u32 m_dwTotalLength;  //�����ܳ���
	u32 m_dwSeqID;        //��Ϣ���к�
	u32 m_dwTransactionID;//����ID
	u32 m_dwEventID;      //��ϢID����
	u32 m_dwReserved;     //����
}TJLPuMsgHead;

//��½����
typedef struct TJLPuLoginReq
{
    CSTRUCT TJLPuLoginAuthInfo m_tLoginAuthInfo;
	CSTRUCT TJLPuDevInfo m_tDevInfo;
	u32 m_dwContext; 
}TJLPuLoginReq;

//��½�ظ�
typedef struct TJLPuLoginRsp
{
    CSTRUCT TJLPuLoginReq m_tLoginReq;
	u32 server_time;
	u32 m_dwResult;
}TJLPuLoginRsp;

//ע����½����
typedef struct TJLPuLogoutReq
{
	u32 m_LogoutReason; //ע��ԭ��or����������
	u32 m_dwContext; 
}TJLPuLogoutReq;

//�û�ע����½�ظ�
typedef struct TJLPuLogoutRsp
{
	CSTRUCT TJLPuLogoutReq m_tUserLogoutReq;
	u32 m_dwResult;
}TJLPuLogoutRsp;

//ʵʱý�彻������
typedef struct TJLPuRealMediaSwitchReq
{
	u32 m_dwVideoSwithMode;		//��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
	u32 m_dwVChn;				//��Ƶͨ����
	u32 m_dwVCodecType;			//��Ƶ���������
 	CSTRUCT TVSSNetAddr m_tCallerVRcvAddr;  //��Ƶ����������ַ

	u32 m_dwAudioSwitchMode;	//��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
	u32 m_dwAChn;				//��Ƶͨ����
	u32 m_dwACodecType;			//��Ƶ���������
	CSTRUCT TVSSNetAddr m_tCallerARcvAddr;  //��Ƶ����������ַ
	u32 m_dwContext; 
}TJLPuRealMediaSwitchReq;

//ʵʱý�彻���ظ�
typedef struct TJLPuRealMediaSwitchRsp
{
	CSTRUCT TJLPuRealMediaSwitchReq m_tRealMediaSwitchReq;
	u32 m_dwResult;
//  CSTRUCT TVSSNetAddr m_tPuVRcvAddr;  //ǰ�˽�����Ƶ��Ŀ�ĵ�ַ��������Ƶ
// 	CSTRUCT TVSSNetAddr m_tPuARcvAddr;  //ǰ�˽�����Ƶ��Ŀ�ĵ�ַ�����������Խ�
}TJLPuRealMediaSwitchRsp;

//ʵʱý�彻��ֹͣ����
typedef struct TJLPuRealMediaStopCmd
{
	u32 m_dwVideoSwithMode;		//��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
	u32 m_dwVChn;				//��Ƶͨ����
	u32 m_dwAudioSwitchMode;	//��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
	u32 m_dwAChn;				//��Ƶͨ����
	u32 m_dwContext; 
}TJLPuRealMediaStopCmd;

//�豸ץͼ����
typedef struct TJLPuSnapPicReq
{
	u32 m_dwVChn;				//��Ƶͨ����
	u32 m_dwVideoCtrl;			//ץͼ��ͼ����ʱ��Ƶ���Ʋ���
	TJLJpegParam m_tJpegParam;  //ͼƬ��������
	u32 m_dwClientPicFullPathLen;
	char m_szClientPicFullPath[VSS_FILENAME_MAXLEN];
	u32 m_dwContext; 
}TJLPuSnapPicReq;

//�豸ץͼ�ظ�
typedef struct TJLPuSnapPicRsp
{
	CSTRUCT TJLPuSnapPicReq m_tPuSnapPicReq;
	u32 m_dwResult;
}TJLPuSnapPicRsp;

//������������
typedef struct TJLParamCfgReq
{
	CSTRUCT TJLParamCfgData m_tCfgData;
	u32 m_dwContext; 
}TJLParamCfgReq;

//�������ûظ�
typedef struct TJLParamCfgRsp
{
	CSTRUCT TJLParamCfgReq m_tParamCfgReq;
	u32 m_dwResult;
}TJLParamCfgRsp;

//��������֪ͨ
typedef struct TJLParamMdfNtf
{
	CSTRUCT TJLParamCfgData m_tCfgData;
	u32 m_dwResult;
}TJLParamMdfNtf;

//�����Ź����ȡ����
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
//�����������
typedef struct TJLPuChargeCallReq
{
	CSTRUCT TJLChargeInfo m_tChargeInfo; //������Ϣ
	u32 m_dwIsNewAgentDeal;  //�Ƿ����µĿ�����ϯ����ǰ����(����ָ�������Ŷ�����ϯ��æʱ��
	u32 m_dwContext; 
}TJLPuChargeCallReq;


//������лظ�
typedef struct TJLPuChargeCallRsp
{
	CSTRUCT TJLPuChargeCallReq m_tChargeCallReq;
	u32 AgentNoLen;
	char AgentNo[VSS_NAME_MAXLEN];
	//������ǻ�������ͨ������ץͼ��ͼƬ����Ҫ���ط����������ļ�����ͨ���ĵ�ַ�Ͷ˿�
	u32 m_dwResult;
}TJLPuChargeCallRsp;

//������лظ�2
typedef struct TJLPuChargeCallRsp2
{
	CSTRUCT TJLPuChargeCallReq m_tChargeCallReq;
	// CSTRUCT TJLCallQueueCntNtf m_tCallQueueCnt;// the count of people in busy
	u32 AgentNoLen;
	char AgentNo[VSS_NAME_MAXLEN];
	//�����ֶ� m_tCallerVRcvAddr��m_tCallerARcvAddr
	CSTRUCT TVSSNetAddr m_tCallerVRcvAddr; //��Ƶ����������ַ�Ͷ˿�
	CSTRUCT TVSSNetAddr m_tCallerARcvAddr; //��Ƶ����������ַ�Ͷ˿�
	u32 m_dwResult;
}TJLPuChargeCallRsp2;

//�����ж�֪ͨ
typedef struct TJLPuChargeBreakNtf
{
	u32 m_dwReserve; //����
}TJLPuChargeBreakNtf;


//�������֪ͨ
typedef struct TJLPuChargeCompleteNtf
{
	CSTRUCT TJLChargeInfo m_tChargeInfo; //������Ϣ
	u32 m_dwResult; //��ʱ��ɽ��
}TJLPuChargeCompleteNtf;

/*new struct define ,add by bradlee 2012-7-15*/

typedef struct TJPuAuthSnap
{
	u32 authid;             //��ȨID
	u32 agentid;            //��Ӧ���ݿ������ֶ�
	u32 deviceid;           //��Ӧ���ݿ�device���deivcecode�ֶ�
	u32 pic_level;
	u32 client_path_len;	//ͼƬ����·��������
	char client_path[VSS_FILENAME_MAXLEN]; ////ͼƬ����·����
	u32 context;
} TJPuAuthSnap;


//shm add begin for transparent channel//͸��ͨ��
typedef struct TJPuTransparentChnl
{
	u32 agentid;            //��Ӧ���ݿ������ֶ�
	u32 deviceid;           //��Ӧ���ݿ�device���deivcecode�ֶ�
	u32  context;
	u32 datalen;
	u8 data[VSS_TRANSDATA_MAXLEN];
} TJPuTransparentChnl;
//shm add end for transparent channel

//shm add begin for transparent channel//͸��ͨ��
typedef struct TJToCuTransparentChnl
{
	u32 deviceid;           //��Ӧ���ݿ�device���deivcecode�ֶ�
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
	u32 authid;             //��ȨID
	u32 agentid;            //��Ӧ���ݿ������ֶ�
	u32 deviceid;           //��Ӧ���ݿ�device���deivcecode�ֶ�
	u32 context;
} TJPuAuthSnapCancel;

typedef struct TJPuAuthSnapCancelRsp
{
	TJPuAuthSnapCancel req;
	u32 result;
} TJPuAuthSnapCancelRsp;


typedef struct TJPuSendPictureNtf
{
	u32 authid;             //��ȨID
	u32 agentid;            //��Ӧ���ݿ�agent�����ֶ�
	u32 deviceid;           //��Ӧ���ݿ�device���deivcecode�ֶ�
	u32 total_len;          //ͼƬ�ܳ���
	u32 trsf_event;         //��16λ��������Ȱٷֱȡ� ��16λ��0��ʾ��δ���䣬1��ʾ��ʼ���䣬2��ʾ���ڴ��䣬3��ʾ����ȡ����4��ʾ�������
	u32 reserved_word;       //������
	u32 quality;            //��Ƭ�ȼ���1=�ͣ�2=�У�3=�ߣ�����ֵΪ���Ĭ��ֵ��
	u32 picture_info;       //ͼƬ����Ϣ����λ2���ֽڱ�ʾͼƬ��ʽ����λ��2���ֽڱ�ʾǰ���Ƿ���ˮӡ�������ʾǰ�� ��ˮӡ��
	u32 client_path_len;	   //ͼƬ����·��������
	char client_path[VSS_FILENAME_MAXLEN]; ////ͼƬ����·����

} TJPuSendPictureNtf;

typedef struct TJPuDeviceInfoNtf
{
	u32  deviceid;           //��Ӧ���ݿ�device���deivcecode�ֶ�
	u32  mode;				// 0����Ч��1��wifi 2:3G,
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
	u32  mode;				// 0����Ч��1��wifi 2:3G,
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
	char agentName[VSS_NAME_MAXLEN];//��ϯ���ƣ��� ���� 
	u32 contextID;//�ػ�ID 
}TJLBackCallreq; 

typedef struct TJLBackCallConfirmRsp
{
	u32 sigID;
	u32 agentID;
}TJLBackCallConfirmRsp;

typedef struct TJLBackCallrsp
{
	CSTRUCT TJLBackCallreq req;
	u32 result;//��ʱ���ܾ���
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
	u32 trsf_event; //0:�ͻ��˽���ͼƬ��ɣ�1���ͻ���ȡ������ͼƬ 2���豸��ͼƬ���ݷ������ 3���豸��ͼƬ����ȡ��
	u32 pic_info;   //��16λ����Ƭ�ȼ���1=�ͣ�2=�У�3=�ߡ� ��16λ��0��ʶǰ�����գ�1��ʶ�������
	u32 pic_data_pctg; //��16λ��ͼƬ�����ܳ��ȡ� ��16λ������֪ͨʱͼƬ�Ĵ���ٷֱ�
	u32 pic_name_len;
	char pic_name[VSS_FILENAME_MAXLEN];
}TJPuDevicePicTrsfNtf��
*/
typedef struct TJPuOnlineAction{
	u32 deviceid;
	u32 action; // 0.������� 1.�������  2.�л���̨ 3.�����˳� 4.����
	u32 status; // 0.���߿��� 1�������� 2.��̨�������� 3.�����к�̨���� 4.æ
	u32 reserve;//������
	u32 extea_info_len;
	char extra_info[VSS_ACTION_EXTRA_LEN];
}TJPuOnlineAction;

typedef struct TJPuLensCtrlReq
{
	u32  agentid;
	u32  deviceid;
	u32  lens_focus; //����̶ȣ���ͻ������豸��Ӧ�ã�ÿ�ζ��Ǿ���ֵ
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
