#ifndef _H_VSS_TYPES_
#define _H_VSS_TYPES_

//////////////////////////////////////////////////////////////////////////
//                       ����IP��Ϊ�����򣡣���                         
//////////////////////////////////////////////////////////////////////////

#define CSTRUCT

typedef u32 TNETIP; //pdu���ɹ���ר��

typedef struct TVSSNetAddr
{
    TNETIP m_tIP;
	u16 m_wPort;

}TVSSNetAddr;

//ͳһ������
typedef struct TUOID
{
	u64 m_qwBaseID;         //������������ID
	u32 m_dwObjType;		//��������
	u64 m_qwObjID;			//����ID
	u32 m_dwExtType;
}TUOID;

//ͨ����Ϣͷ
typedef struct TVSSCommMsgHead
{
	u32 m_dwMagic;        //�����������������շ���Ϣ��У�飬���⼫С���ʵ�������Ϣ�����ظ�
	u64 m_qwVer;          //�汾��
	u32 m_dwMsgType;      //��Ϣ����
	u32 m_dwMsgSeqNum;    //��Ϣ���к�
	u32 m_dwTransID;      //����ID
	u32 m_dwErrCode;      //������
    CSTRUCT TUOID m_tDstID;       //��ϢĿ�ģ��ݲ�ʹ��
	u32 m_dwDstSapName;   //Ŀ��Sap����
    CSTRUCT TUOID m_tSrcID;       //��ϢԴ, �ݲ�ʹ��
	u32 m_dwSrcSapName;   //ԴSap����
	u32 m_dwMsgBodyLen;   //��Ϣ�峤��
	u32 m_dwReserve1;     //�����ֶ�
	u32 m_dwReserve2;
	u32 m_dwReserve3;
	u32 m_dwReserve4;
	u32 m_dwReserve5;
	u32 m_dwReserve6;
	u32 m_dwReserve7;
	u32 m_dwReserve8;
}TVSSCommMsgHead;

//�����������
typedef struct TVSSObjBasic
{
    CSTRUCT TUOID m_tObjUOID;    //����ͳһ���
    CSTRUCT TUOID m_tParentUOID; //���׶���ͳһ���
	u32 m_dwHasSon;      //�Ƿ����ӽڵ�
	u32 m_dwObjNameLen;
	char m_achObjName[VSS_NAME_MAXLEN];  //��������
	u32 m_dwDescLen;
	char m_achDesc[VSS_NAME_MAXLEN];     //����
}TVSSObjBasic;

//�豸��½��Ϣ
typedef struct TVSSLoginInfo
{
	u32 m_dwNameLen;
	char m_szUserName[VSS_NAME_MAXLEN];
	u32 m_dwPswLen;
	char m_abyPsw[VSS_PSW_MAXLEN];
}TVSSLoginInfo;

//�豸��½��Ϣ
typedef struct TVSSDevLoginInfo
{
	CSTRUCT TUOID m_tDevUOID;
	CSTRUCT TUOID m_tAccessID;     //����ID
	u32  m_dwLoginNameLen;
	char m_achLoginName[VSS_NAME_MAXLEN];
	u32  m_dwLoginPswLen;
	char m_achLoginPsw[VSS_PSW_MAXLEN];
	CSTRUCT TVSSNetAddr m_tNetAddr;
	u32 m_dwURLLen;   //URL����
	char m_achURL[VSS_URL_MAXLEN];

}TVSSDevLoginInfo;

// //�豸��չ��Ϣ
// typedef struct TVSSDevExtInfo
// {
// 	CSTRUCT TVSSDevLoginInfo m_tVSSDevLoginInfo;
// 	CSTRUCT TVSSDevPos m_tVSSDevPos;
// 	CSTRUCT TUOID m_tHostDevID;        //�����豸ID,�����豸Ϊ���ܷ����豸,����ʶ���豸��ʱ��Ч
// 	CSTRUCT TVSSDevCap m_tDevCap;
// }TVSSDevExtInfo;

//ͨ��¼��
typedef struct TChnRec
{
	CSTRUCT TUOID m_tRecSvrID;           //¼���ID
	CSTRUCT TUOID m_tScheTemplateID;     //����ģ��
	u32 m_dwRecSpaceMB;          //¼��ռ�
}TChnRec;

//ͨ����Ϣ
typedef struct TVSSChnInfo
{
	CSTRUCT TUOID m_tChnUOID;
	u32 m_dwLongPos;     //����
	u32 m_dwLatPos;      //γ��
	u32 m_dwHeightPos;   //�߶�
	u32 m_dwCamTypeLen;
	char m_szCamType[VSS_NAME_MAXLEN];
	CSTRUCT TChnRec m_tChnRec;    //ͨ��¼����Ϣ
	CSTRUCT TUOID m_tHostChnId;   //����ͨ��ID
}TVSSChnInfo;

//LogԪ����
typedef struct TVSSLogMetaData
{
	u32 m_dwLogTime;      //��־ʱ��
	u32 m_dwLogLevel;	  //��־�ȼ�
	u32 m_dwLogType;      //�������־���� ���豸���У��û���½���豸�����
	CSTRUCT TUOID m_tLogHostUOID;        //��־���������
	CSTRUCT TUOID m_tLogAccusatUOID;     //��־���������(��֧������)
	u32 m_deLogDescLen; //��־��������
	char m_szLogDesc[LOGMETADATA_USERDATA_MAXLEN+1]; //��־����
}TVSSLogMetaData;


//////////////////////////////////////////////////////////////////////////
// �ͻ������������ͨ����Ϣ�ṹ

//�û���½���󣬵�ǰ�������û�����
typedef struct TVSSUserLoginReq
{
    CSTRUCT TVSSNetAddr m_tCmsIP;
	CSTRUCT TVSSLoginInfo m_tLoginInfo;
 	u32 m_dwUserType; //�û�����(����Ա����ؿͻ����û���������ϯ�ȣ���XXX)
	u32 m_dwContext; 
}TVSSUserLoginReq;

//�û���½�ظ�
typedef struct TVSSUserLoginRsp
{
    CSTRUCT TVSSUserLoginReq m_tUserLoginReq;
	u32 m_dwResult;
	CSTRUCT TUOID m_tServerUOID; //��½��������UOID
	CSTRUCT TVSSObjBasic m_tUserBasic;  //�����¼�û��Ļ�����Ϣ
	u32 m_dwSyncTimeS;        //ͬ��ʱ��
// 	char m_szCmsVer[VSS_NAME_MAXLEN]; //�������汾�ţ���ʱ����Ҫ
}TVSSUserLoginRsp;

//�û�ע����½����
typedef struct TVSSUserLogoutReq
{
	u32 m_dwNameLen;
	char m_szUserName[VSS_NAME_MAXLEN];
	u32 m_dwContext; 
}TVSSUserLogoutReq;

//�û�ע����½�ظ�
typedef struct TVSSUserLogoutRsp
{
	CSTRUCT TVSSUserLogoutReq m_tUserLogoutReq;
	u32 m_dwResult;
}TVSSUserLogoutRsp;

//�û��޸���������
typedef struct TVSSUserPwdMdfReq
{
	u32 m_dwNameLen;
	char m_szUserName[VSS_NAME_MAXLEN];
	u32 m_dwPswLen;
	char m_abyPsw[VSS_PSW_MAXLEN];
	u32 m_dwContext; 
}TVSSUserPwdMdfReq;

//�û��޸�����ظ�
typedef struct TVSSUserPwdMdfRsp
{
	CSTRUCT TVSSUserPwdMdfReq m_tUserPwdMdfReq;
	u32 m_dwResult;
}TVSSUserPwdMdfRsp;


//�û�״̬֪ͨ
typedef struct TVSSUserSsnStatusNtf
{
	CSTRUCT TUOID m_tUserUOID;
	u32 m_dwIsOnline; //�Ƿ�����: 1���ߣ�0������
}TVSSUserSsnStatusNtf;

//���Ĺ������Ԫ״̬֪ͨ������ý��ת����������¼������������ĵ�Ԫ��
typedef struct TVSSCmuSsnStatusNtf
{
	CSTRUCT TUOID m_tCmuUOID; //ͨ��m_dwObjType�������ĵ�Ԫ���ͣ�ͨ��m_qwObjID���־����ĸ���Ԫ
	u32 m_dwIsOnline; //�Ƿ�����: 1���ߣ�0������
}TVSSCmuSsnStatusNtf;

//ʵʱý�彻������
typedef struct TVSSRealMediaSwitchReq
{
	CSTRUCT TUOID m_tCalledUOID;		//���У�ǰ�ˣ�UOID
	CSTRUCT TUOID m_tCallerUOID;		//���У��ͻ��ˣ�UOID
	u32 m_dwVideoSwitchMode;				//��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
	u32 m_dwCalledVEncChn;			//���У�ǰ�ˣ���Ƶ����ͨ��
	u32 m_dwCallerVChn;				//���У��ͻ��ˣ���Ƶ����ͨ���������ǿͻ��˽���ͨ����Ҳ����¼�����¼��ͨ���ȣ�
	u32 m_dwCallerVEncChn;			//���У��ͻ��ˣ���Ƶ����ͨ��������˫�򽻻�

	u32 m_dwAudioSwitchMode;			//��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
	u32 m_dwCalledAEncChn;     //���У�ǰ�ˣ���Ƶ����ͨ��
	u32 m_dwCallerAChn;		//���У��ͻ��ˣ���Ƶ�����߱��,�ͻ��˽���ͨ����¼�����¼��ͨ����
	u32 m_dwCallerAEncChn;     //���У��ͻ��ˣ���Ƶ����ͨ��

	u32 m_dwContext; 
}TVSSRealMediaSwitchReq;


//ʵʱý�彻���ظ�
typedef struct TVSSRealMediaSwitchRsp
{
	CSTRUCT TVSSRealMediaSwitchReq m_tRealMediaSwitchReq;
	u32 m_dwResult;
 	u32 m_dwCalledVDecChn;			//���У�ǰ�ˣ��豸��Ƶ����ͨ��������˫�򽻻�
 	CSTRUCT TVSSNetAddr m_tCalledOrMdsVRcvAddr;  //���У�ǰ�ˣ�����ý��ת������������������Ŀ�ĵ�ַ������˫�򽻻�
//  	CSTRUCT TUOID m_tPuADecChn;					//ý��Դ��ǰ���豸��Ƶ����ͨ��
	CSTRUCT TVSSNetAddr m_tCalledOrMdsARcvAddr;  //ǰ�˻���ý��ת������������������Ŀ�ĵ�ַ
}TVSSRealMediaSwitchRsp;

//ʵʱý�彻��ֹͣ����
typedef struct TVSSMediaSwitchStopCmd
{
	CSTRUCT TUOID m_tCalledUOID;		//���У�ǰ�ˣ�UOID
	CSTRUCT TUOID m_tCallerUOID;		//���У��ͻ��ˣ�UOID

	u32 m_dwVideoSwitchMode;				//��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
	u32 m_dwCalledVEncChn;			//���У�ǰ�ˣ���Ƶ����ͨ��
	u32 m_dwCallerVChn;				//���У��ͻ��ˣ���Ƶ����ͨ�������ܿͻ��˽���ͨ����¼�����¼��ͨ���ȣ�
	u32 m_dwCallerVEncChn;			//���У��ͻ��ˣ���Ƶ����ͨ��������˫�򽻻�

	u32 m_dwAudioSwitchMode;			//��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
	u32 m_dwCalledAEncChn;     //���У�ǰ�ˣ���Ƶ����ͨ��
	u32 m_dwCallerAChn;		//���У��ͻ��ˣ���Ƶ�����߱��,�ͻ��˽���ͨ����¼�����¼��ͨ����
	u32 m_dwCallerAEncChn;     //���У��ͻ��ˣ���Ƶ����ͨ��
//	u32 m_dwContext; 
}TVSSMediaSwitchStopCmd;


//ͼƬ�ļ�����ͨ����������
typedef struct TVSSPicFileTransChnCreateReq
{
	CSTRUCT TVSSNetAddr m_tMdsNetAddr; //ת�ַ���������ַ
	CSTRUCT TUOID m_tPuUOID;					//ǰ��UOID
	CSTRUCT TUOID m_tCuUOID;					//�ͻ���UOID
	u32 m_dwContext; 
}TVSSPicFileTransChnCreateReq;

//ͼƬ�ļ�����ͨ�������ظ�
typedef struct TVSSPicFileTransChnCreateRsp
{
	CSTRUCT TVSSPicFileTransChnCreateReq m_tTransChnCreateReq;
	u32 m_dwResult;
}TVSSPicFileTransChnCreateRsp;

//ͼƬ�ļ�����ͨ����������
typedef struct TVSSPicFileTransChnDelCmd
{
	CSTRUCT TUOID m_tPuUOID;					//ǰ��UOID
	CSTRUCT TUOID m_tCuUOID;					//�ͻ���UOID
}TVSSPicFileTransChnDelCmd;

//�豸ץͼ����
typedef struct TVSSPuSnapPicReq
{
//  	CSTRUCT TUOID m_tCuUOID; //�ͻ���UOID
	CSTRUCT TUOID m_tPuVEncChn;					//ý���ṩԴ��ǰ���豸����ͨ��
	u32 m_dwPicFullNameLen;						//ͼƬ����·��������
	char m_szPicFullName[VSS_FILENAME_MAXLEN];//ͼƬ�ͻ��˱���ȫ·����
	u32 m_dwContext; 
}TVSSPuSnapPicReq;

//�豸ץͼ�ظ�
typedef struct TVSSPuSnapPicRsp
{
	CSTRUCT TVSSPuSnapPicReq m_tPuSnapPicReq;
	u32 m_dwResult;
}TVSSPuSnapPicRsp;


//�ͻ���ͼƬ���ؽ���֪ͨ
typedef struct TVSSPicDLProgressNtf
{
	u32 m_dwPicFullNameLen;						//ͼƬ����·��������
	char m_szPicFullName[VSS_FILENAME_MAXLEN];	//ͼƬ�ͻ��˱���ȫ·����

	u32 m_dwResult;
	u32 m_dwProgress;					//���ؽ���
}TVSSPicDLProgressNtf;

//////////////////////////////////////////////////////////////////////////
// ���Ĺ�������������������ͨ����Ϣ�ṹ

typedef struct TVSSPuInfoItem
{
	CSTRUCT TVSSObjBasic m_tPuBasic;         //ǰ���豸����
	CSTRUCT TVSSDevLoginInfo m_tPuLoginInfo; //ǰ���豸��¼��Ϣ
}TVSSPuInfoItem;

typedef struct TVSSChnInfoItem
{
	CSTRUCT TVSSObjBasic m_tPuChnBasic;    //ǰ��ͨ������
	CSTRUCT TVSSChnInfo m_tPuChnInfo;      //ǰ��ͨ����Ϣ
}TVSSChnInfoItem;


//CMS��½����
typedef struct TVSSLoginCmsReq
{
// 	CSTRUCT TVSSNetAddr m_tCmsIP;
	CSTRUCT TVSSLoginInfo m_tLoginInfo;
	u32 m_dwContext; 
}TVSSLoginCmsReq;

//�û���½�ظ�
typedef struct TVSSLoginCmsRsp
{
	CSTRUCT TVSSLoginCmsReq m_tCmsLoginReq;
	CSTRUCT TUOID m_tServerUOID; //��½��������UOID
	TVSSObjBasic m_tSvrBasic;  //�����¼�ķ������Ļ�����Ϣ����ת����������¼��������ȣ�
	u32 m_dwSyncTimeS;        //ͬ��ʱ��
	u32 m_dwResult;
}TVSSLoginCmsRsp;

//��ȡ����������ص�ǰ���豸�б�����
typedef struct TVSSPuListGetReq
{
	CSTRUCT TUOID m_tHostUOID;   //����UOID�����ý���������ȡ�豸����ý���������ID
	CSTRUCT TUOID m_tRefPuUOID;  //�ο�PuUOID���û���ȡ���������豸
	u32 m_dwMaxCntGet;			 //���λ�ȡ�������
	u32 m_dwContext;
}TVSSPuListGetReq;

//��ȡ����������ص�ǰ���豸�б�ظ�
typedef struct TVSSPuListGetRsp
{
	CSTRUCT TVSSPuListGetReq m_tPuListGetReq;
	u32 m_dwResult;
	u32 m_dwPuListCnt;              //ǰ���豸����
	CSTRUCT TVSSPuInfoItem m_atPuInfoItem[VSS_LIST_MAXNUM]; //ǰ���豸��Ϣ�б�
}TVSSPuListGetRsp;

//��ȡ�豸ͨ���б�����
typedef struct TVSSPuChnListGetReq
{
	CSTRUCT TUOID m_tHostUOID;		//����UOID�����ý���������ȡ�豸����ý���������ID
	CSTRUCT TUOID m_tRefPuChn;		//�ο�PuUOID���û���ȡ���������豸
	u32 m_dwMaxCntGet;				//���λ�ȡ�������
	u32 m_dwContext;
}TVSSPuChnListGetReq;

//��ȡ�豸ͨ���б�ظ�
typedef struct TVSSPuChnListGetRsp
{
	CSTRUCT TVSSPuChnListGetReq m_tPuChnListGetReq;
	u32 m_dwResult;
	u32 m_dwPuChnListCnt;              //ǰ���豸����
	CSTRUCT TVSSChnInfoItem m_atPuChnInfoItem[VSS_LIST_MAXNUM]; //ǰ���豸ͨ����Ϣ�б�
}TVSSPuChnListGetRsp;

//ǰ���豸״̬�仯֪ͨ
typedef struct TVSSPuStatusNtf
{
	CSTRUCT TUOID m_tPuUOID;  //PuUOID
	u32 m_dwStatusType;      //״̬����(�豸�����ߣ�¼��״̬���澯״̬��, ��svccommon.h EVssGlobalStatus)
	u32 m_dwStatusValue;     //״ֵ̬
}TVSSPuStatusNtf;

//////////////////////////////////////////////////////////////////////////
// ���ն�����ҵ�����Ϣ�ṹ

//������Ϣ
typedef struct TVSSChargeInfo
{
	u32 m_dwReportNoLen;
	char m_szReportNo[VSS_REPORTNO_LEN];	// ������
	u32 m_dwPlateNoLen;
	char m_szPlateNo[VSS_PLATENO_LEN];	// ���ƺ�
	//����
}TVSSChargeInfo;

//��ϯ��Ϣ��
typedef struct TVSSAgentInfoItem
{
	CSTRUCT TVSSObjBasic m_tCuBasic;         //��ϯ������Ϣ
	//��ϯ��չ��Ϣ
}TVSSAgentInfoItem;
// 
// //������ϯ��Ϣ��ȡ����
// typedef struct TVSSAgentInfoReq
// {
// 	CSTRUCT TUOID m_tCuUOID;   //�ṩ����������ϯID
// 	u32 m_dwContext; 
// }TVSSAgentInfoReq;
// 
// //������ϯ��Ϣ��ȡ�ظ�
// typedef struct TVSSAgentInfoRsp
// {
// 	CSTRUCT TVSSAgentInfoReq m_tAgentInfoReq;
// 	u32 m_dwResult;
// 	CSTRUCT TVSSAgentInfoItem m_tAgentInfoItem; //��ϯ��Ϣ
// }TVSSAgentInfoRsp;

//�����������
typedef struct TVSSChargeCallReq
{
	CSTRUCT TUOID m_tPuUOID;   //������е��豸ID
	CSTRUCT TVSSChargeInfo m_tChargeInfo; //������Ϣ
	CSTRUCT TVSSNetAddr m_tFileTransSvrAddr;    //ת���������ļ��������ӵ�ַ�����ڽ����ļ�����ͨ��
	u32 m_dwContext; 
}TVSSChargeCallReq;

//������лظ�
typedef struct TVSSChargeCallRsp
{
	CSTRUCT TVSSChargeCallReq m_tChargeCallReq;
	CSTRUCT TUOID m_tCuUOID;   //�ṩ����������ϯID
	u32 m_dwResult;
}TVSSChargeCallRsp;

//��������ύ����Ϣ
typedef struct TVSSChargeSubmitInfo
{
	CSTRUCT TVSSChargeInfo m_tChargeInfo; //������Ϣ
	//����������
}TVSSChargeSubmitInfo;


//��������ύ����
typedef struct TVSSChargeSubmitReq
{
	CSTRUCT TUOID m_tCuUOID;   //�ṩ����������ϯID
	//�����ύ������
	CSTRUCT TVSSChargeSubmitInfo m_tChargeSubmitInfo;
	u32 m_dwContext; 
}TVSSChargeSubmitReq;

//��������ύ�ظ�
typedef struct TVSSChargeSubmitRsp
{
	CSTRUCT TVSSChargeSubmitReq m_tChargeCallReq;
	u32 m_dwResult;
}TVSSChargeSubmitRsp;

//�������֪ͨ
typedef struct TVSSChargeCompleteNtf
{
	CSTRUCT TUOID m_tPuUOID;   //������е��豸ID
	CSTRUCT TVSSChargeInfo m_tChargeInfo; //������Ϣ;
	u32 m_dwResult;
}TVSSChargeCompleteNtf;

// //������ϯ�б��ȡ����
// typedef struct TVSSFreeAgentListGetReq
// {
// 	CSTRUCT TUOID m_tCuUOID;   //�ṩ����������ϯID
// 	u32 m_dwContext; 
// }TVSSFreeAgentListGetReq;
// 
// 
// //������ϯ�б��ȡ�ظ�
// typedef struct TVSSFreeAgentListGetRsp
// {
// 	CSTRUCT TVSSFreeAgentListGetReq m_tFreeAgentListGetReq;
// 	u32 m_dwResult;
// 	u32 m_dwAgentListCnt;              //������ϯ����
// 	CSTRUCT TVSSAgentInfoItem m_atAgentInfoItem[VSS_LIST_MAXNUM]; //������ϯ��Ϣ�б�
// }TVSSFreeAgentListGetRsp;

//����ת������
typedef struct TVSSChargeTransferReq
{
	u32 m_dwTransferType; //����ת����ʽ����chargecomm.h �е�EChargeTransferType����
	//CSTRUCT TUOID m_tDstCuUOID;   //Ŀ����ϯID,��ָ��ת����ĳ����ϯʱ��Ч����һ�汾ʵ��
	CSTRUCT TUOID m_tReqCuUOID;   //����ת������ϯID

	CSTRUCT TUOID m_tPuUOID;   //������е��豸ID
	CSTRUCT TVSSChargeInfo m_tChargeInfo; //������Ϣ
	u32 m_dwContext; 
}TVSSChargeTransferReq;

//����ת���ظ�
typedef struct TVSSChargeTransferRsp
{
	CSTRUCT TVSSChargeTransferReq m_tChargeTransferReq;
	u32 m_dwResult;
}TVSSChargeTransferRsp;

//��ϯ����״̬��������
typedef struct TVSSWorkStatusSetReq
{
	CSTRUCT TUOID m_tCuUOID;   //��ϯID
	u32 m_dwWorkStatus;  //�����chargecomm.h �е�EAgentWorkStatus����
	u32 m_dwReportNoLen;
	char m_szReportNo[VSS_REPORTNO_LEN];	// ������
	u32 m_dwContext; 
}TVSSWorkStatusSetReq;

//��ϯ����״̬���ûظ�
typedef struct TVSSWorkStatusSetRsp
{
	CSTRUCT TVSSWorkStatusSetReq m_tWorkStatusSetReq;
	u32 m_dwResult;
}TVSSWorkStatusSetRsp;

//��ϯ����״̬֪ͨ
typedef struct TVSSWorkStatusNtf
{
	u32 m_dwWorkStatus;  //�����chargecomm.h �е�EAgentWorkStatus����
}TVSSWorkStatusNtf;

//���ڶ�����豸����֪ͨ
typedef struct TVSSChargePuOfflineNtf
{
	CSTRUCT TUOID m_tPuUOID;   //�豸ID
}TVSSChargePuOfflineNtf;

//////////////////////////////////////////////////////////////////////////
// �ͻ���UISvc��������������ͨ����Ϣ�ṹ

//ʵʱý�彻������
// typedef struct TUIRealMediaSwitchReq
// {
// 	CSTRUCT TUOID m_tPuUOID;		//���У�ǰ�ˣ�UOID
// 	CSTRUCT TUOID m_tCuUOID;		//���У��ͻ��ˣ�UOID
// // 	u32 m_dwIsSwitchVideo; //�Ƿ񽻻���Ƶ
// 	u32 m_dwVideoSwitchMode; //��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
// 	u32 m_dwWndHdl;			//��Ƶ���ھ��
// 	u32 m_dwWndIdx;         //��������
//  	u32 m_dwPuVEncChnIdx;		//ǰ���豸��Ƶ����ͨ��
// 
// // 	u32 m_dwIsSwitchAudio; //�Ƿ񽻻���Ƶ
// 	u32 m_dwAudioSwitchMode; //��Ƶ����ģʽ����vsscomm.h��EVSSMediaSwitchMode
// 	u32 m_dwContext; 
// }TUIRealMediaSwitchReq;
// 
// //ʵʱý�彻���ظ�
// typedef struct TUIRealMediaSwitchRsp
// {
// 	CSTRUCT TUIRealMediaSwitchReq m_tWorkStatusSwitchReq;
// 	u32 m_dwResult;
// }TUIRealMediaSwitchRsp;


#endif
