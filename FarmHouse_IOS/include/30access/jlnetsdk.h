#ifndef _JL_NET_SDK_H_
#define _JL_NET_SDK_H_

#ifdef __cplusplus
extern "C" {
#endif

#ifdef WIN32

#ifdef JLNETSDK_EXPORTS
#define NET_SDK_API __declspec(dllexport) 
#else
#define NET_SDK_API __declspec(dllimport)
#endif

#ifndef STDCALL
#define STDCALL __stdcall
#endif

#endif

//////////////////////////////////////////////////////////////////////////
//�궨��
#define JL_MAX_IPADDR_LEN           32
#define JL_MAX_NAME_LEN				32
#define JL_MAX_CFGDATA_LEN          256
#define JL_MAX_FILEPATH_LEN          128

#define JL_MAX_SERIALNO_LEN 			32	// �豸���к��ַ�����
#define JL_MAX_REPORTNO_LEN 			32	// �����ų���
#define JL_MAX_PLATENO_LEN 				16	// ���ƺų���

//����ظ����
typedef enum
{
	JL_ChargeRsp_Ok = 0,		//���ն���
	JL_ChargeRsp_NoFree,		//�޿��ж���Ա
	JL_ChargeRsp_NotAnswer,		//���˽���
	JL_ChargeRsp_Refuse,		//����Ա�ܽ�
}JL_ChargeRspResult;

//������ɽ��
typedef enum
{
	JL_ChargeRet_Complete = 0,		//�������
	JL_ChargeRet_WaitAddition,		//������
	JL_ChargeRet_Break,				//�����ж�
	JL_ChargeRet_Timeout,			//����Ա������ʱ
}JL_ChargeCompleteResult;

//////////////////////////////////////////////////////////////////////////
//�ṹ

// ʵʱý�彻������
typedef enum
{
	JL_MSType_None = 0,			// ������Ƶ����
	JL_MSType_Simplex_Rcv = 1,	//������գ������������󱻽е�����������Ƶ�������Ƶ������
	JL_MSType_Simplex_Snd = 2 ,	//�����ͣ����������������������У�����Ƶ�㲥��������
	JL_MSType_Duplex,			// ˫�򽻻�
} JL_MediaSwitchType;

// �豸��Ϣ
typedef struct
{
	char	achSerialNumber[JL_MAX_SERIALNO_LEN];	// ���кŻ��豸ID��
	BYTE	byAlarmInPortNum;		// �����������
	BYTE	byAlarmOutPortNum;		// �����������
	BYTE	byDiskNum;				// Ӳ�̸���
	BYTE	byDevType;				// �豸��������
	BYTE	byVideoChanNum;			// ��Ƶͨ������
	BYTE    byAudioChanNum;         // ����ͨ����
	DWORD   dwVideoCap;				//��Ƶ������
	DWORD   dwAudioCap;				//��Ƶ������
	DWORD   dwPicCap;				//ͼƬ������
	BYTE    byRes1[16];				// ����
} JL_NET_DEVINFO, *LPJL_NET_DEVINFO;


// ������Ϣ
typedef struct
{
	char	achReportNo[JL_MAX_REPORTNO_LEN];	// ������
	char	achPlateNo[JL_MAX_PLATENO_LEN];	// ���ƺ�
} JL_NET_CHARGEINFO, *LPJL_NET_CHARGEINFO;

////�����Ԥ������
// typedef struct
// {
// 	LONG lChannel;//ͨ����
// 	HWND hPlayWnd;//���Ŵ��ڵľ��,ΪNULL��ʾ������ͼ��
// }JL_NET_CLIENTINFO, *LPJL_NET_CLIENTINFO;


//����ý���������ͣ���Ӧ�����غɣ�
typedef enum
{
	JL_MediaType_SysCtx = 1,	//ϵͳ�����ģ���ϵͳ�Զ���
	JL_MediaType_Video,			//��Ƶ��
	JL_MediaType_Audio,			//��Ƶ��
	JL_MediaType_Mix,			//�����
}JL_MediaDataType;


//��Ƶ�������
typedef enum
{
	JL_VCodec_H264 = 0,	//H.264
	JL_VCodec_MPEG4,
}JL_VCodecType;

//��Ƶ�������
typedef enum
{
	JL_ACodec_SPEX = 0,	//Spex
	JL_ACodec_AMR,		//AMR
	JL_ACodec_MP3,		//mp3
}JL_ACodecType;

//ץ��ͼƬ�ֱ���
typedef enum
{
	//��������
	JL_PICRES_QCIF = 1,	//176*144
	JL_PICRES_CIF,		//352*288
	JL_PICRES_D1,		//704*576

	//4:3
	JL_PICRES_QVGA =10,	//320*240
	JL_PICRES_VGA,		//640*480
	JL_PICRES_SVGA,		//800*600
	JL_PICRES_XGA,		//1024*768
	JL_PICRES_UXGA,		//1600x1200

	//��Ƶ����
	JL_PICRES_720p = 20,//1280��720
	JL_PICRES_1080p,	//1920��1080
	
	//ͼƬ����
	JL_PICRES_1DOT3MP = 30,	//130������
	JL_PICRES_2MP,			//200������
	JL_PICRES_3MP,			//300������
	JL_PICRES_5MP,			//500������
	JL_PICRES_8MP,			//800������
	JL_PICRES_1GP,			//1ǧ������
}JL_PIC_RESOLUTION;

//ץ��ͼƬ�����ȼ�
typedef enum
{
	JL_PicQlt_Highest = 0,	//��� 
	JL_PicQlt_High,			//��
	JL_PicQlt_Normal,		//һ��
	JL_PicQlt_low,			//��
	JL_PicQlt_Lowest,		//���
}JL_PIC_QUALITY;

//ͼƬ����
typedef struct 
{
	WORD	wPicSize;			//��JL_PIC_RESOLUTION
	WORD	wPicQuality;		//JL_PIC_QUALITY
}JL_NET_JPEGPARA, *LPJL_NET_JPEGPARA;

//ץ��ͼƬ��Ƶ����
typedef enum
{
	JL_PicSnap_VideoNormal = 0,	//������Ƶ
	JL_PicSnap_VideoStop,		//ֹͣ��Ƶ
	JL_PicSnapt_Auto,			//�豸����Ӧ
}JL_PICSNAP_VIDEO_CTRL;

//��������
typedef struct
{
	DWORD dwCfgType;	//���ò�������
	char  chCfgData[JL_MAX_CFGDATA_LEN]; //�������ݣ�����������Ӧ�ò����
	DWORD dwCfgDatLen;  //�������ݳ���
}JL_PARAMCFG_DATA;

//////////////////////////////////////////////////////////////////////////
//��Ϣ�ṹ

//ͨ�ûظ���Ϣ
typedef struct
{
	DWORD dwResult; //�ظ������0��ʾ��½�ɹ�����0���������
	DWORD dwContext; //������ 
} JL_Common_Rsp;

//��½����
typedef struct
{
	char chDevIp[JL_MAX_IPADDR_LEN];	//�豸IP��ַ���������ڵ�ַ��
	char chUserName[JL_MAX_NAME_LEN];	//�û�����
	char chAuthPwd[JL_MAX_NAME_LEN];	//��֤����
	JL_NET_DEVINFO tDeviceInfo;       //�豸��Ϣ
	DWORD dwContext; //������ 
} JL_Login_Req;
//��½�ظ�
typedef JL_Common_Rsp JL_Login_Rsp;

//��������
typedef struct
{
	JL_NET_CHARGEINFO tChargeInfo;
	DWORD dwContext; //������ 
} JL_Charge_Req;
//����ظ�
typedef JL_Common_Rsp JL_Charge_Rsp;

//ý�彻������
typedef struct
{
	LONG lVChannel;			//��Ƶͨ����
	DWORD dwVSwitchType;	//��Ƶý�彻�����ͣ���JL_MediaSwitchType
	DWORD dwVCodecType;		//��Ƶ���������,��JL_VCodecType

	LONG lAChannel;			//��Ƶͨ����
	DWORD dwASwitchType;	//��Ƶý�彻�����ͣ���JL_MediaSwitchType
	DWORD dwACodecType;     //��Ƶ��������ͣ���JL_ACodecType
	DWORD dwContext;		//������ 
} JL_RealMedia_Req;

//ý�彻���ظ�
typedef JL_Common_Rsp JL_RealMedia_Rsp;

//ץ��ͼƬ����
typedef struct
{
	LONG lChannel;//ͨ����
	JL_PICSNAP_VIDEO_CTRL eVideoCtrl; //��Ƶ����
	JL_NET_JPEGPARA tJpegPara; //ͼƬ����
	char chClientPicFullPath[JL_MAX_FILEPATH_LEN]; //�ͻ���ͼƬ����ȫ·��
	DWORD dwContext; //������ 
} JL_DevSnapPic_Req;

//ץ��ͼƬ�ظ�
typedef JL_Common_Rsp JL_DevSnapPic_Rsp;

// typedef struct
// {
// 	DWORD dwResult;	//ץ�Ľ����0�ɹ�������ʧ��
// 	LONG lChannel;	//ͨ����
// 	DWORD dwContext;//�����û�����ʱ��������
// } JL_DevSnapPic_Rsp;


//�豸������������
typedef struct
{
	JL_PARAMCFG_DATA tDevCfgData; //�豸��������
	DWORD dwContext; //������ 
}JL_ParamCfg_Req;

//�豸�������ûظ�
typedef JL_Common_Rsp JL_ParamCfg_Rsp;

//////////////////////////////////////////////////////////////////////////
//SKD�ӿ�

//��ʼ��
NET_SDK_API BOOL STDCALL NETSDK_Init( );
//�˳�
NET_SDK_API BOOL STDCALL NETSDK_Cleanup();

//��ȡSDK�İ汾��Ϣ
NET_SDK_API DWORD STDCALL NETSDK_GetVersion();
//��ȡ������
NET_SDK_API DWORD STDCALL NETSDK_GetLastError();

//���ý���������IP��ַ�����������������������ͨ��Dmz��ӳ�䵽����IP��ַ��������Ҫ�������������Ip��ַ )
NET_SDK_API BOOL STDCALL NETSDK_MediaIpAddrSet( u32 dwIpNetAddr );
/*===========================================================
���ܣ� �豸��½����ص�
����˵����	lNodeID - ���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptLoginReq - ��½���󣬾�����ṹ�嶨��
			dwUserData - �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TDevLoginReqCB)(LONG lNodeID, JL_Login_Req* ptLoginReq, DWORD dwUserData );
//ע���豸��½֪ͨ�ص�
NET_SDK_API void STDCALL NETSDK_DevLoginReqCBReg( TDevLoginReqCB lpDevLoginReqCB, DWORD dwUserData );

/*===========================================================
���ܣ� �豸Ip��ַ�仯֪ͨ����������Ip��ַ��
����˵����	lNodeID - ���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			pchDevIp - �豸IP��ַ
			dwUserData - �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TDevIpChangeNtfCB)(LONG lNodeID, char *pchDevIp, DWORD dwUserData );
//ע��
NET_SDK_API void STDCALL NETSDK_DevIpChangeNtfCBReg( TDevIpChangeNtfCB lpDevIpChangeNtfCB, DWORD dwUserData );

/*===========================================================
���ܣ� �豸��½�ظ�
����˵����	lNodeID - ���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptLoginRsp - ��½�ظ���������ṹ�嶨��
����ֵ˵������
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_DevLoginRsp(LONG lNodeID, JL_Login_Rsp* ptLoginRsp );

/*===========================================================
���ܣ� �Ͽ������豸
����˵����	lNodeID - ���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
����ֵ˵����TRUE���ɹ��Ͽ���False���Ͽ�����ʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_Disconnect(LONG lNodeID);
/*===========================================================
���ܣ� �������ӶϿ�֪ͨ�ص�
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			pchDevIp -	�Ͽ��豸IP��ַ
			wPort -		�Ͽ��豸�˿�
			dwUserData- �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TDisconnectNtfCB)(LONG lNodeID, char *pchDevIp, WORD wPort, DWORD dwUserData);
//ע���������֪ͨ�ص�
NET_SDK_API void STDCALL NETSDK_DisconnectNtfCBReg( TDisconnectNtfCB lpDisconnectCB, DWORD dwUserData );

/*===========================================================
���ܣ� ����ҵ��������ص�
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptChargeReq -	����������Ϣ��������ṹ�嶨��
			dwUserData- �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TInsureChargeReqCB)(LONG lNodeID, JL_Charge_Req* ptChargeReq, DWORD dwUserData);
//ע�ᱣ��ҵ��������ص�����
NET_SDK_API void STDCALL NETSDK_InsureChargeReqCBReg( TInsureChargeReqCB lpInsureChargeReqCB, DWORD dwUserData );

/*===========================================================
���ܣ� ����ҵ��������ظ�
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptChargeRsp -	������Ϣ��������ṹ�嶨�壬�ظ������JL_ChargeRspResult
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_InsureChargeRsp(LONG lNodeID, JL_Charge_Rsp* ptChargeRsp );
 
/*===========================================================
���ܣ� ��ɶ���
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			lpChargeInfo -	������Ϣ��������ṹ�嶨�� 
			dwResult- ����ظ������0��ʾ�ɹ�����0��������� ��JL_ChargeCompleteResult
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_InsureChargeComplete(LONG lNodeID, LPJL_NET_CHARGEINFO lpChargeInfo, u32 dwResult );

/*===========================================================
���ܣ� ����ҵ�����ж�֪ͨ
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			dwUserData- �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TInsureChargeBreakNtfCB)(LONG lNodeID, DWORD dwUserData);
//ע�ᱣ��ҵ�����ж�֪ͨ
NET_SDK_API void STDCALL NETSDK_InsureChargeBreakNtfCBReg( TInsureChargeBreakNtfCB lpInsureChargeBreakNtfCB, DWORD dwUserData );


/*===========================================================
���ܣ� ʵʱý�����ݻص�
����˵����	lMediaHandle -	ý�����ݾ����Ψһ��ʾָ����ý�彻��
			dwDataType - ý����������, ��Ƶ����Ƶ������Ƶ�������ԭʼ���ݵȣ���JL_MediaDataType
			pBuffer - ý������
			dwBufSize - ���ݻ����С
			dwUserData - �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TRealMediaDataCB)(LONG lMediaHandle, DWORD dwDataType, char *pBuffer, DWORD dwBufSize, DWORD dwUserData);
//ע��ʵʱý�����ݻص�
NET_SDK_API void STDCALL NETSDK_RealMediaDataCBReg( TRealMediaDataCB lpRealMediaDataCB, DWORD dwUserData );

/*===========================================================
���ܣ� ����ʵʱý�����ݵ��豸
����˵����	lMediaHandle -	ý�����ݾ����Ψһ��ʾָ����ý�彻��
			dwDataType - ý����������, ��Ƶ����Ƶ������Ƶ�������ԭʼ���ݵȣ���JL_MediaDataType
			pSendBuf - ����ý������
			dwBufSize - ���ݻ����С
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_RealMediaDataSend(LONG lMediaHandle, DWORD dwDataType, char *pSendBuf, DWORD dwBufSize );

/*===========================================================
���ܣ� ��ʼʵʱý�彻���ظ�
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			lMediaHandle - ����ý�彻����ʾ
			ptMediaRsp -ý��ظ���Ϣ��������ṹ�嶨��
			dwUserData -�û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TRealMediaStartRspCB)(LONG lNodeID, LONG lMediaHandle, JL_RealMedia_Rsp* ptMediaRsp, DWORD dwUserData );
//ע�Ὺʼʵʱý�彻���ظ�
NET_SDK_API void STDCALL NETSDK_RealMediaStartRspCBReg( TRealMediaStartRspCB lpRealMediaStartRspCB, DWORD dwUserData );

/*===========================================================
���ܣ� ��ʼʵʱý�彻������
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptMediaReq -ý��������Ϣ��������ṹ�嶨��
			dwUserData- �û����ݣ�ý�����ݻص�ʱ���ص��û�����
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_RealMediaStartReq(LONG lNodeID, JL_RealMedia_Req* ptMediaReq );


/*===========================================================
���ܣ��޸�ý�彻���ظ�
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			lNewMediaHandle - �޸ĺ��ý�彻����ʾ���滻ԭ��ý�彻����ʾ
			ptMediaRsp -ý��ظ���Ϣ��������ṹ�嶨��
			dwUserData -�û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TRealMediaMdfRspCB)(LONG lNodeID, LONG lNewMediaHandle, JL_RealMedia_Rsp* ptMediaRsp, DWORD dwUserData );
//ע���޸�ý�彻���ظ�
NET_SDK_API void STDCALL NETSDK_RealMediaMdfRspCBReg( TRealMediaMdfRspCB lpRealMediaMdfRspCB, DWORD dwUserData );

/*===========================================================
���ܣ� �޸�ý�彻������
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			lMediaHandle - ý�彻����ʾ
			ptMediaReq -ý��������Ϣ��������ṹ�嶨��
			dwUserData- �û����ݣ�ý�����ݻص�ʱ���ص��û�����
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_RealMediaMdfReq(LONG lNodeID, LONG lMediaHandle, JL_RealMedia_Req* ptMediaReq );


/*===========================================================
���ܣ� ֹͣý�彻��
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			lMediaHandle -	ý�彻����ʾ��ý�����������صı�ʾֵ
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_StopRealMedia(LONG lNodeID, LONG lMediaHandle);

// /*===========================================================
// ���ܣ� �ļ��������ݻص�
// ����˵����	lFileHandle -	�ļ���������Ψһ��ʾһ·�ļ�����
// 			lTransType - ��������, ץ���ϴ����ļ����ش���ȣ���
// 			pBuffer - �ļ�����
// 			dwBufSize - ���ݻ����С
// 			lState - ��ǰ״̬��0��ʾ�������䣬��0��ʾ�����쳣�����ʾ
// 			lSendSize - �ѷ����ֽ���
// 			lTotalSize - �ļ��ܴ�С
// 			dwUserData - �û����ݣ�ע��ص�����ʱ�ṩ
// ����ֵ˵������
// ===========================================================*/
// typedef void (CALLBACK *TFileTransDataCB)(LONG lFileHandle, LONG lTransType, char *pBuffer, DWORD dwBufSize,
// 										  LONG lState, LONG lSendSize, LONG lTotalSize, DWORD dwUserData );
// //ע��
// NET_SDK_API void STDCALL NETSDK_FileTransDataCBReg( TFileTransDataCB lpFileTransDataCB, DWORD dwUserData );


/*===========================================================
���ܣ� ץ��ͼƬ�ļ��������ݻص�(���ļ����ݼ������������) (�����ļ�����ת����������ץ��ͼƬ�ļ�������Ȼص�ͬʱע��!!!)
����˵����	lFileHandle -	�ļ���������Ψһ��ʾһ·�ļ�����
			pBuffer - �ļ�����
			dwBufSize - ���ݻ����С
			dwUserData - �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TPicFileTransDataCB)(LONG lFileHandle, char *pBuffer, DWORD dwBufSize, DWORD dwUserData );
//ע��(�����ļ�����ת����������ץ��ͼƬ�ļ�������Ȼص�ͬʱע��!!!)
NET_SDK_API void STDCALL NETSDK_PicFileTransDataCBReg( TPicFileTransDataCB lpFileTransDataCB, DWORD dwUserData );

//ץ��ͼƬ�ļ�������Ȼص�(���ڵ㵽���ļ����䣬������ץ��ͼƬ�ļ��������ݻص�ͬʱע��!!!)
typedef void (CALLBACK *TPicFileTransProgressCB)(LONG lFileHandle, LONG lResult, LONG lProgress, LONG lContext);
//ע��(�����ļ�����ת����������ץ��ͼƬ�ļ��������ݻص�ͬʱע��!!!)
NET_SDK_API void STDCALL NETSDK_PicFileProgressCBReg( TPicFileTransProgressCB lpFileProgressCB, DWORD dwUserData );

/*===========================================================
���ܣ� ����ͼƬ�ļ��������ݵ��豸
����˵����	lFileHandle -	�ļ���������Ψһ��ʾָ����ý�彻��
			pSendBuf - ��������
			dwBufSize - ���ݻ����С
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_PicFileTransDataSend(LONG lFileHandle, char *pSendBuf, DWORD dwBufSize );


/*===========================================================
���ܣ� �豸ץ��ͼƬ�ظ��ص�����
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			lFileHandle - ������ļ���������Ψһ��ʾһ·�ļ�����
			ptDevSnapPicRsp - �ظ���Ϣ��������ṹ�嶨��
			dwUserData - �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TDevSnapPicRspCB)(LONG lNodeID, LONG lFileHandle, JL_DevSnapPic_Rsp* ptDevSnapPicRsp, DWORD dwUserData );
//ע��
NET_SDK_API void STDCALL NETSDK_DevSnapPicRspCBReg( TDevSnapPicRspCB lpDevSnapPicRspCB, DWORD dwUserData );

/*===========================================================
���ܣ� �豸ͼ��ץ������
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptDevSnapPicReq - ������Ϣ��������ṹ�嶨��
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
��ע�������ļ�����ͨ�����󣬲���Ҫ��¶�ӿڸ��ϴ����ɵײ�����ͨ��ģ���Զ���������
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_DevSnapPicReq(LONG lNodeID, JL_DevSnapPic_Req* ptDevSnapPicReq );

/*===========================================================
���ܣ� ���ûظ��ص�����
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptParamCfgRsp - ���ûظ���Ϣ��������ṹ�嶨��
			dwUserData - �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TParamCfgRspCB)(LONG lNodeID, JL_ParamCfg_Rsp* ptParamCfgRsp, DWORD dwUserData );
//ע��
NET_SDK_API void STDCALL NETSDK_ParamCfgRspCBReg( TParamCfgRspCB lpParamCfgRspCB, DWORD dwUserData );

/*===========================================================
���ܣ� �豸������������
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptParamCfgReq -  ����������Ϣ��������ṹ�嶨��
			dwUserData - �û����ݣ��ظ��ص����ļ����ݻص�ʱ���ص��û�����
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_ParamCfgReq(LONG lNodeID, JL_ParamCfg_Req* ptDevCfgReq );

/*===========================================================
���ܣ� ���ò����޸�֪ͨ�ص�����
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			ptParamMdfNtf - ���ûظ���Ϣ��������ṹ�嶨��
			dwUserData - �û����ݣ�ע��ص�����ʱ�ṩ
����ֵ˵������
===========================================================*/
typedef void (CALLBACK *TParamMdfNtfCB)(LONG lNodeID, JL_PARAMCFG_DATA* ptParamMdfNtf, DWORD dwUserData );
//ע��
NET_SDK_API void STDCALL NETSDK_ParamMdfNtfCBReg( TParamMdfNtfCB lpParamMdfNtfCB, DWORD dwUserData );


/*===========================================================
���ܣ� ����͸����������
����˵����	lNodeID -	���ӽڵ�ID��Ψһ��ʾ��ĳһ·�豸������
			pDataBuf -  ͸������
			dwDataLen - ͸�����ݳ���
����ֵ˵����TRUE��������Ϣ�ɹ���False��������Ϣʧ��
===========================================================*/
NET_SDK_API BOOL STDCALL NETSDK_TransparentDataSend(LONG lNodeID, char *pDataBuf, DWORD dwDataLen );



//PTZ
//�豸ά��


#ifdef __cplusplus
}
#endif

#endif //_JL_NET_SDK_H_
