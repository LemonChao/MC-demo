/*****************************************************************************
ģ����      : FSMP
�ļ���      : fsmp.h
����ļ�    : 
�ļ�ʵ�ֹ���: ����״̬��ƽ̨
����        : gerrard
�汾        : V3R0  Copyright(C) 2006-2008 FOCUS, All rights reserved.
-----------------------------------------------------------------------------
�޸ļ�¼:
��  ��      �汾        �޸���      �޸�����
2006/12/27  V3R0        gerrard      Create

2007/06/29	V3R0		gerrard		 �����շ�ʹ�� signet;
									 sap������ FCC

2007/07/18	V3R0		gerrard		 ���Ӷ�ʱ������
									 ���ӽڵ㽨����Ϣ
									 ������������Ϣ��������sap
									 ���շ�����Ϣ�ͼ����ӡ

2007/08/21	V3R0		gerrard		 FsmpInitʹ��TCommInitParam����
									 ʹ���ڴ����
									 �ṩFsmpVerGet, FsmpErrInfoGet

2007/09/18	V3R0		gerrard		 ʹ��vc8;
									 ���� FsmpHealthCheck
									 �ṹ TNodeParam  ���ӳ�Ա

2007/10/16	V3R0		gerrard		 ʹ�� 071015 �汾�� signet	

2007/11/02	V3R0		gerrard		 ����fsmpdl
2007/11/09	V3R0		gerrard		 ����oal
2007/11/30	V3R0		gerrard		 ����signet
									 071207: �����ص��ӱ���������Ѵ������ֱ���˳�	
									 071210: sap���ڵ�ͳ�ƽӿڣ����ź�������
									 071212: ����ģ�ⶪ���ӿ� FsmpSndLoseSet, FsmpRcvLoseSet, fsmpsndmsgloseset, fsmprcvmsgloseset
									 071215: sig�ص���������fsmp���  
									 071217��fsmp��������Ľڵ����ֱ����hSig	
2008/02/15	V3R0		gerrard	    ����oal ��080208��
2008/05/16	V3R1		gerrard	    sap����Ϊsap(service access point), ֧�ֲ�ͬ��sapʹ�ò�ͬ����ѯ����
2008/07/19	V3R1		gerrard	    ���ӷֲ����Խӿ� FsmpHdlGetOnSTP, FsmpSapStatisGetOnSTP
******************************************************************************/

#ifndef _FSMP_H
#define _FSMP_H
  

#ifdef __cplusplus
extern "C"{
#endif // begin Extern "C"


#define	FSMPVER							"FSMP V3R1 I090430R090430"	//FSMP�汾�� 

typedef u32								FSMPRET;			//fsmp����ֵ
typedef u32								HDoPoll;		//��ѯ����

#define MAX_POLLTASK_NUM				32				//��ѯ��������ֵ
#define MAX_NODE_NUM					(u32)65535		//֧�ֵ����ڵ���		
//#define MAX_SAP_NAME_LEN			(u32)20			//sap������󳤶�,������'\0'
	
// fsmp�������¼��ţ��û��Զ�����¼��Ų�Ҫ��֮��ͻ !!!
#define NODE_CONNECT_EVENT				(u32)1000		//�����¼� �û�������������, ���Խ��ա�
#define NODE_DISCCONNET_EVENT			(u32)1001		//�����¼� �û�������������, ���Խ��ա�
#define NAME_QUERY_EVENT				(u32)1002		//���������¼����û����ܷ��ͣ����ա� �������ֲ�ѯ������ FsmpRmtNameQuery��
#define NAME_QUERY_REPLY_EVENT			(u32)1003		//��������Ӧ���¼�, �û�������������, ���Խ��ա�
#define TIMER_EVENT						(u32)1004		//��ʱ����Ϣ, �û�������������, ���Խ��ա�

#define MAX_DISCINFO_SAP_NUM		(u32)32			//����ʱ֪ͨ�����sap����
#define MIN_STACK_SIZE					(u32)(20<<10)	//�����ջ��С����Сֵ

//�������ͣ����а汾�� TCP_TRANS
#define TCP_TRANS						(u8)0			//TCP�Ĵ��䷽ʽ
#define UDP_TRANS						(u8)1			//UDP�Ĵ��䷽ʽ


//�����룬������FocusErr.hָ��
#define FSMP_OK							(FSMPRET)0						//�����ɹ�
#define FSMP_ERR_BASE					(FSMPRET)FSMP_ERRBASE			 

#define FSMP_ERR_NULL_POINT				(FSMPRET)(FSMP_ERR_BASE + 1)	//ָ��Ϊ��
#define FSMP_ERR_ERR_PARAM				(FSMPRET)(FSMP_ERR_BASE + 2)	//��������
#define FSMP_ERR_MEMMAGIC_ERR			(FSMPRET)(FSMP_ERR_BASE + 3)	//��������
#define FSMP_ERR_SOCK_ERR				(FSMPRET)(FSMP_ERR_BASE + 4)	//sock��������
#define FSMP_ERR_TIMER_UNINIT			(FSMPRET)(FSMP_ERR_BASE + 5)	//��ʱ��ģ��δ��ʼ��
#define FSMP_ERR_QUE_DAMAGED			(FSMPRET)(FSMP_ERR_BASE + 6)	//��Ϣ�����ƻ�
#define FSMP_ERR_QUE_HOLLOW				(FSMPRET)(FSMP_ERR_BASE + 7)	//��Ϣ����Ϊ��
#define FSMP_ERR_QUE_FULL				(FSMPRET)(FSMP_ERR_BASE + 8)	//��Ϣ������
#define FSMP_ERR_ID_ERR					(FSMPRET)(FSMP_ERR_BASE + 9)	//��Ŵ���
#define FSMP_ERR_SAP_INVALID			(FSMPRET)(FSMP_ERR_BASE + 10)	//sap��Ч
#define FSMP_ERR_SAP_EXIST				(FSMPRET)(FSMP_ERR_BASE + 11)	//sap�Ѵ���
#define FSMP_ERR_TASK_ERR				(FSMPRET)(FSMP_ERR_BASE + 12)	//�����������
#define FSMP_ERR_NODE_INVALID			(FSMPRET)(FSMP_ERR_BASE + 13)	//�ڵ���Ч
#define FSMP_ERR_REINIT					(FSMPRET)(FSMP_ERR_BASE + 14)	//fsmp�ظ���ʼ��
#define FSMP_ERR_NO_FREE_SAP			(FSMPRET)(FSMP_ERR_BASE + 15)	//û�п��е�sap
#define FSMP_ERR_NO_FREE_NODE			(FSMPRET)(FSMP_ERR_BASE + 16)	//û�п��еĽڵ�
#define FSMP_ERR_SERVER_REINITED		(FSMPRET)(FSMP_ERR_BASE + 17)	//fsmp�������ظ���ʼ��
#define FSMP_TIMER_EXIST				(FSMPRET)(FSMP_ERR_BASE + 18)	//��ʱ���Ѵ���
#define FSMP_ERR_UNINIT					(FSMPRET)(FSMP_ERR_BASE + 19)	//fsmpû�г�ʼ��
#define FSMP_ERR_SEM_ERR				(FSMPRET)(FSMP_ERR_BASE + 20)	//�źŲ�������
#define FSMP_ERR_CYCLE_ERR				(FSMPRET)(FSMP_ERR_BASE + 21)	//ѭ����������
#define FSMP_ERR_NAME_EXIT				(FSMPRET)(FSMP_ERR_BASE + 22)	//�����Ѵ���
#define FSMP_ERR_NAME_UNEXIT			(FSMPRET)(FSMP_ERR_BASE + 23)	//���ֲ�����
#define FSMP_ERR_DISCINFO_FULL			(FSMPRET)(FSMP_ERR_BASE + 24)	//����֪ͨ��Ϣ��ע����
#define FSMP_ERR_MEM_ALLOC				(FSMPRET)(FSMP_ERR_BASE + 25)	//�ڴ�������
#define FSMP_ERR_INST_NULL				(FSMPRET)(FSMP_ERR_BASE + 26)	//ʵ��ָ��Ϊ��
#define FSMP_ERR_INST_MAGIC				(FSMPRET)(FSMP_ERR_BASE + 27)	//ʵ��������
#define FSMP_ERR_INST_UNINIT			(FSMPRET)(FSMP_ERR_BASE + 28)	//ʵ��δ��ʼ��
#define FSMP_ERR_TELNET_UNINIT			(FSMPRET)(FSMP_ERR_BASE + 29)	//telnet��������ʼ��ʧ��
#define FSMP_ERR_SIG_ERR				(FSMPRET)(FSMP_ERR_BASE + 30)	//signet����
#define FSMP_ERR_SVRLIST_EMPTY			(FSMPRET)(FSMP_ERR_BASE + 31)	//���������п�	
#define FSMP_ERR_TIMERLIB_ERR			(FSMPRET)(FSMP_ERR_BASE + 32)	//��ʱ�������	
#define FSMP_ERR_LIST_EMPTY				(FSMPRET)(FSMP_ERR_BASE + 33)	//���п�

#define FSMP_ERR_MAXNO					FSMP_ERR_LIST_EMPTY
		
//��ѯ�������
typedef struct tagTPollTaskPara 
{
	u8	m_byPri;		//���ȼ�
	u32 m_dwStackSize;  //��ջ��С������0����Ĭ�ϵ�10K)
	s8  *m_pchName;		//�������ƣ��Ϊ DoPollNAME_MAXLEN ���ֽ�
}TPollTaskPara;

//ģ���ʼ���ṹ
typedef struct tagFsmpInitParam
{
	u16 m_wLocalPort;        //���ض˿ڣ���ӦSNetModInit�Ĳ���wLocalPort
	u32 m_dwMaxNodeNum;		 //���ڵ��������������������ӵĽڵ㣬�Լ��ɷ�����accept���ɵĽڵ㡣
							//��ӦSNetModInit�Ĳ���dwMaxCltNum + dwMaxAcceptNum
	u32 m_dwMaxCltNodeNum;   //�����������ӵĽڵ�������Ŀ����ӦSNetModInit�Ĳ���dwMaxCltNum
	u32 m_dwMaxSapNum; //���sap��
	u32 m_dwAppHdl; //Ӧ�����ݣ����ϲ���͡��¼��ص�ʱ������
	u16 m_wHighRTSigQueueSize;   //��ʵʱ������ܶ��еĴ�С,��Ϊ�㣬��signet.h
	u16 m_wNormalRTSigQueueSize;  //��ͨʵʱ������ܶ��еĴ�С,����Ϊ�㣬��signet.h
	u16 m_wLowRTSigQueueSize;   //��ʵʱ������ܶ��еĴ�С,��Ϊ�㣬��signet.h
	u32 m_dwPollTaskNum;		//��ѯ�������
	TPollTaskPara *m_ptPollTaskPara; //��ѯ�������ָ��
}TFsmpInitParam;


typedef struct tagNodeParam
{
	u16 m_wSndQueueSize;  //���Ͷ��д�С, �����������signet.h
	u16 m_wRcvQueueSize;  //���ܶ��д�С���������, ��signet.h
	u16 m_wCheckTimeValS; //��·�����
	u16 m_wCheckNum;    //��·������
}TNodeParam;    //�ο� TSigParam


//Fsmp��Ϣ
typedef struct tagFsmpMsg
{
	u32			m_dwSrcNodeId;						//Դ�ڵ��, ��ʱû��
	u32			m_dwSrcSapId;					//Դsap��
	u32			m_dwDstNodeId;						//��FsmpMsgSnd�б�ʾĿ�Ľڵ��. ��FsmpEventProc�б�ʾ�յ���Ϣ�Ľڵ��
													// !!! ע�⣬���� NODE_CONNECT_EVENT��NODE_DISCCONNET_EVENT����Ӧ�Ľ����������ڵ��
													// ����m_pEvent�У�Ӧ����ȡ *((u32 *)tMsg.m_pEvent) 
	u32			m_dwDstSapId;					//Ŀ��sap��, Ϊ0��ʾͨ��sap���Ʒ�����Ϣ
	u32			m_dwEvent;							//�¼�
	u32			m_dwEventLen;						//�¼�����
	FCC			m_tFccSapName;				//Ŀ��sap������sap��Ϊ0ʱ�������塣				 		
	u32			m_dwTimerId;						//��ʱ����, ����m_dwEvent �� TIMER_EVENT��������
	u32			m_dwTimerContext;					//��ʱ�������ģ�����m_dwEvent �� TIMER_EVENT��������
	void		*m_pEvent;							//�¼�ָ��
}TFsmpMsg;


/* ���ֲ�ѯӦ��ṹ��NAME_QUERY_REPLY_EVENT �¼�����Ϣ��  */
typedef struct tagFsmpNameReply
{
	u32 m_dwId;									//sap��
	u32 m_dwNodeId;								//�ڵ��
	FCC	m_tFccName;								//sap����
}TFsmpNameReply;


/* ����ͳ�ƽṹ */
typedef struct tagQueStatis
{
	u32			m_dwCurMsgNum;		//��ǰ����Ϣ����
	u32			m_dwRcvMsgs;		//���յ�����Ϣ����
	u32			m_dwLostMsgs;		//��ʧ����Ϣ��	
	u32			m_dwMsgProced;		//���������Ϣ
	u32			m_dwHisMaxMsgNum;	//�����洢����Ϣ���������ֵ	
	u32			m_dwHisMaxMsgSize;  //�����洢����Ϣ��󳤶�	
}TQueStatis;

/* sapͳ�ƽṹ */
typedef struct tagSapStatis
{
	TQueStatis m_tFsmMsgQueStatis;	//��Ϣ����ͳ��	
}TSapStatis;

//�첽���ӻص�
typedef void (*AsyConnectCB)(u32 dwFsmpHdl, u32 dwNodeId, u32 dwResult, u32 dwContext, u32 dwAppHdl);

/*===========================================================
��������FsmpEventProc
���ܣ�sap�յ���Ϣ��Ļص����������û�ʵ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
				u32 dwFsmpHdl - fsmp���
				dwAppHdl - Ӧ������
				TFsmpMsg tMsg - ��Ϣ
����ֵ˵������
===========================================================*/
typedef void(*FsmpEventProc) (IN u32 dwFsmpHdl, IN u32 dwAppHdl, IN TFsmpMsg tMsg); 

#define DoPollNAME_MAXLEN		(u32)64


//sap����
typedef struct tagSapParam
{
	FCC m_tFccSapName;		//sap��
	FsmpEventProc m_pfEventfunc;	//FSMP�¼�������, ����ΪNULL
	u32 m_dwFSMMsgQueBufs;			//FSM��Ϣ���еĻ������, ��0��ȱʡֵ64	
	u32 m_dwTimeQueBufs;			//��ʱ�����еĻ������, ��0��ȱʡֵ32
	u32 m_dwPollTaskIdx;				//ʹ���ĸ���ѯ���񣬱�Ŵ�0��ʼ
}TSapParam;


/*=================================================================
�� �� ��: FsmpVerGet
��    ��: �õ�fsmp�汾��
�������: pchVerBuf -- ���뻺�壬���ذ汾��
		  dwLen -- ���뻺�峤��
����ֵ:	  ����  pbyBuf	

˵��:     
=================================================================*/
s8 *FsmpVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

/*===========================================================
��������FsmpInit
���ܣ�����Fsmpʵ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����TCommInitParam tCommInit - ������Դ�����m_hTimerLib��m_hMem�� m_dwTelHdl������Ч 										
			  TFsmpInitParam tInit -��ʼ������
			  u32 *pdwFSMPHdl - ����fsmp���

����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
ע�⣺��ʹ�������ӿ�ǰ�������ȵ��øýӿ�
===========================================================*/
FSMPRET FsmpInit(IN TCommInitParam tCommInit, IN TFsmpInitParam tInit, OUT u32 *pdwFSMPHdl);


/*===========================================================
��������FsmpExit
���ܣ��˳�Fsmp���ͷ������Դ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����u32 dwFsmpHdl -fsmp�ľ��
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
===========================================================*/
FSMPRET	 FsmpExit(IN u32 dwFsmpHdl);


/*===========================================================
��������FsmpHealthCheck
���ܣ�FSMP�������
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����u32 dwFsmpHdl -fsmp�ľ��
����ֵ˵����������FSMP_OK����������������
===========================================================*/
u32 FsmpHealthCheck(IN u32 dwFsmpHdl);

/*===========================================================
��������FsmpSvrCreate
���ܣ�����������
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	u32 dwFsmpHdl -fsmp�ľ��
				TNodeParam tNodeParam -- �ڵ����	
	
����ֵ˵��: 
===========================================================*/
FSMPRET FsmpSvrCreate(IN u32 dwFsmpHdl, IN TNodeParam tNodeParam); 


/*===========================================================
��������FsmpSvrDelete
���ܣ�ɾ��fsmp������
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	u32 dwFsmpHdl -fsmp�ľ��
	
����ֵ˵��: 
===========================================================*/
FSMPRET FsmpSvrDelete(IN u32 dwFsmpHdl); 

/*===========================================================
��������FsmpNodeCreate
���ܣ������ڵ�
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	u32 dwFsmpHdl -- fsmp�ľ��
				u32 tNodeParam -- �ڵ����
				u32 *pdwNodeId -- ���ط��䵽�Ľڵ��
����ֵ˵����
===========================================================*/
FSMPRET FsmpNodeCreate(IN u32 dwFsmpHdl, IN TNodeParam tNodeParam, IN u32 *pdwNodeId);

/*===========================================================
��������FsmpNodeConnect
���ܣ� ͬ������ָ���ķ�����
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	u32 dwFsmpHdl - fsmp�ľ��
				u32 dwNodeId -- �ڵ��
				u32 dwSvrIpNetEndian -- ��������ַ
				u16 wSvrPort -- �������˿�
				u32 dwTimeoutMs -- ��ʱ��MS��
����ֵ˵�����ɹ��� FSMP_OK; ʧ��, ������
===========================================================*/
FSMPRET FsmpNodeConnect(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u32 dwSvrIpNetEndian, IN u16 wSvrPort, IN u32 dwTimeoutMs);


/*===========================================================
��������FsmpAsyNodeConnect
���ܣ� �첽����ָ���ķ�����
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	u32 dwFsmpHdl - fsmp�ľ��
				u32 dwNodeId -- �ڵ��
				u32 dwSvrIpNetEndian -- ��������ַ
				u16 wSvrPort -- �������˿�
				u32 dwTimeoutMs -- ��ʱ��MS��
				AsyConnectCB pConnectPrc -- �첽���ӻص�
				u32 dwContext -- �첽���ӻص�������

����ֵ˵�����ɹ��� FSMP_OK; ʧ��, ������
===========================================================*/
FSMPRET FsmpAsyNodeConnect(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u32 dwSvrIpNetEndian, IN u16 wSvrPort, 
						   IN u32 dwTimeoutMs, IN AsyConnectCB pConnectPrc, IN u32 dwContext);

/*===========================================================
��������FsmpNodeDisConnect
���ܣ���ָ���ķ������Ͽ�����
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	u32 dwFsmpHdl -fsmp�ľ��
				u32 dwNodeId -- Fsmp�ڵ�� 
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
===========================================================*/
FSMPRET  FsmpNodeDisConnect(IN u32 dwFsmpHdl, IN u32 dwNodeId);


/*===========================================================
��������FsmpNodeDelete
���ܣ�ɾ���ڵ�
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	u32 dwFsmpHdl -fsmp�ľ��
				u32 dwNodeId -- Fsmp�ڵ�� 
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
===========================================================*/
FSMPRET  FsmpNodeDelete(IN u32 dwFsmpHdl, IN u32 dwNodeId);

/*===========================================================
��������FsmpSapCreate
���ܣ�����Fsmpsap
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	
				u32 dwFsmpHdl -fsmp�ľ��
				TSapParam tCtrParam - sap����
				pdwSapId- sap�ţ����ظ��û�

����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
===========================================================*/
FSMPRET FsmpSapCreate(IN u32 dwFsmpHdl, IN TSapParam tSapParam, OUT u32 *pdwSapId); 





/*===========================================================
��������FsmpMsgSend
���ܣ�������Ϣ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	
				u32 dwFsmpHdl -fsmp�ľ��
				TFsmpMsg tFsmpMsg - ��Ϣ
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
ע�⣺�������ص���Ϣ��dwDstNodeId����Ϊ0
===========================================================*/
FSMPRET  FsmpMsgSnd(IN u32 dwFsmpHdl, IN TFsmpMsg tFsmpMsg);


/*===========================================================
��������FsmpRmtNameQuery
���ܣ�
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	u32 dwFsmpHdl - fsmp�ľ��
				dwSrcSapId - Դsap�ţ��Զ˽ڵ��ѯ��sap�ź󣬷��� NAME_QUERY_REPLY_EVENT�¼�����sap
				dwDstNodeId - �ڵ�ţ���0
				tFccName - Զ��sap������

����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
===========================================================*/
FSMPRET FsmpRmtNameQuery(IN u32 dwFsmpHdl, IN u32 dwSrcSapId, IN u32 dwDstNodeId, IN FCC tFccName);



/*===========================================================
��������FsmpDiscInfoAdd
���ܣ����Ӷ���ʱҪ֪ͨ��sap
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
			u32 dwFsmpHdl -fsmp�ľ��
			  dwNodeId: �ڵ��
			  dwSapId: sap��
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����.
ע�⣺Ŀǰһ���ڵ����ע�� MAX_DISCINFO_SAP_NUM��32����sap
Ϊ��ʹ�ü򵥣��ýӿ��ݲ��ṩ
===========================================================*/
//FSMPRET  FsmpDiscInfoAdd(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u32 dwSapId);


/*===========================================================
��������FsmpDiscInfoDel
���ܣ�ɾ������ʱҪ֪ͨ��sap��Ϣ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
				u32 dwFsmpHdl -fsmp�ľ��
				dwNodeId: �ڵ��
				dwSapId: sap��

 ����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����.
 Ϊ��ʹ�ü򵥣��ýӿ��ݲ��ṩ
==========================================================*/
//FSMPRET  FsmpDiscInfoDel(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u32 dwSapId);



/*===========================================================
��������FsmpTimerSet
���ܣ����ö�ʱ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
				u32 dwFsmpHdl - fsmp�ľ��
				dwDstContaineId �� ���ն�ʱ����Ϣ��sap��
				dwDelayMs �� ��ʱ�����
				eType - ��ʱ������ 	TIMER_TYPE_ONCE(һ�ζ�ʱ) TIMER_TYPE_CYCLE(���ڶ�ʱ)	
				dwContext �� ������
				pdwTimerId �� ���ض�ʱ����ָ��


 ����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����.
==========================================================*/
FSMPRET FsmpTimerSet(IN u32 dwFsmpHdl, IN u32 dwDstContaineId, IN u32 dwDelayMs, IN eTimerType eType, 
					 IN u32 dwContext, OUT u32 *pdwTimerId);


/*===========================================================
��������FsmpTimerKill
����		�������ʱ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
				dwFsmpHdl - fsmp�ľ��
				dwSapId - sap��
				dwTimerId �� ��ʱ����
		

 ����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����.
==========================================================*/
FSMPRET FsmpTimerKill(IN u32 dwFsmpHdl, IN u32 dwSapId, IN u32 dwTimerId);


/*====================================================================
��������FsmpNodeStatisGet
���ܣ��õ��ڵ�ͳ����Ϣ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
			  u32 dwFsmpHdl -fsmp�ľ��
			  dwNodeId �� �ڵ���
			  ptNodeStatis - �ڵ�ͳ��		
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
====================================================================*/
//FSMPRET FsmpNodeStatisGet(IN u32 dwFsmpHdl, IN u32 dwNodeId, OUT TNodeStatis *ptNodeStatis);


/*====================================================================
��������FsmpSapStatisGet
���ܣ��õ�sapͳ����Ϣ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����dwSapId �� sap���
			  ptSapStatis - sapͳ��		
����ֵ˵��
====================================================================*/
FSMPRET FsmpSapStatisGet(IN u32 dwFsmpHdl, u32 dwSapId, TSapStatis *ptSapStatis);

/*====================================================================
��������FsmpSigGet
���ܣ��õ�sig
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
			  u32 dwFsmpHdl - fsmp�ľ��
			  dwNodeId �� �ڵ���
			  phSig - sigָ��
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
ע���ýӿڽ�Ϊ�˴����ļ����õ�sig
====================================================================*/
FSMPRET FsmpSigGet(IN u32 dwFsmpHdl, IN u32 dwNodeId, OUT HSig *phSig);

/*====================================================================
��������FsmpNodeSetHeartBeatParam
���ܣ����ýڵ�����������
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
====================================================================*/
FSMPRET FsmpNodeSetHeartBeatParam(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u16 wTimeValS, IN u16 wNum);

/*====================================================================
��������FsmpOppAddrGet
���ܣ��õ��Զ˵�ַ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
				u32 dwFsmpHdl - fsmp�ľ��
				dwNodeId �� �ڵ���
				pdwAddr - ip��ַָ��
����ֵ˵�����ɹ�����FSMP_OK��ʧ�ܷ��ش�����
ע���ýӿڽ�Ϊ�˴����ļ����õ�sig
====================================================================*/
FSMPRET FsmpOppAddrGet(IN u32 dwFsmpHdl, IN u32 dwNodeId, OUT u32 *pdwAddr);

/*====================================================================
��������FsmpSndLoseSet
���ܣ����÷������ʧ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
dwFsmpHdl - fsmpʵ��	
byRate - ��ʧ��	
����ֵ˵��
====================================================================*/
FSMPRET FsmpSndLoseSet(IN u32 dwFsmpHdl, u8 byRate);

/*====================================================================
��������FsmpRcvLoseSet
���ܣ����ý������ʧ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	
dwFsmpHdl - fsmpʵ��	
byRate - ��ʧ��	
����ֵ˵��
====================================================================*/
FSMPRET FsmpRcvLoseSet(IN u32 dwFsmpHdl, u8 byRate);


///////////////////////////////////////////  ���Խӿ�  ///////////////////////////////////////////

/*====================================================================
��������fsmphelp
���ܣ�fsmp������Ϣ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵��
����ֵ˵��
====================================================================*/
void fsmphelp(void* dwTelHdl);

/*====================================================================
��������fsmpprtname
���ܣ�fsmp��ӡ����
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵��
����ֵ˵��
====================================================================*/
void fsmpprtname(void* dwTelHdl);

/*====================================================================
��������fsmpver
���ܣ�fsmp�汾��Ϣ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵��
����ֵ˵��
====================================================================*/
void fsmpver(void* dwTelHdl);

/*====================================================================
��������fsmpinstshow
���ܣ���ʾfsmpʵ����Ϣ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
����ֵ˵��
====================================================================*/
void fsmpinstshow(void* dwTelHdl);

/*====================================================================
��������fsmpdl
���ܣ�
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵��
����ֵ˵��
====================================================================*/
void fsmpdl(void* dwTelHdl, u8 byLvl);

/*====================================================================
��������fsmpconfig
���ܣ���ʾfsmp������
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
����ֵ˵��
====================================================================*/
void fsmpconfig(void* dwTelHdl, u32 dwFsmpIdx);

/*====================================================================
��������fsmpnodeshow
���ܣ���ʾָ����Žڵ����Ϣ����Ϊ0����ʾ���нڵ����Ϣ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����dwNodeId �� �ڵ���
			  dwIdx - fsmpʵ������
����ֵ˵��
====================================================================*/
void fsmpnodeshow(void* dwTelHdl, u32 dwFsmpIdx, u32 dwNodeId);

/*====================================================================
��������fsmpsapshow
���ܣ���ʾָ�����sap����Ϣ����Ϊ0����ʾ����sap����Ϣ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����dwSapId �� sap���
			  dwIdx - fsmpʵ������
����ֵ˵��
====================================================================*/
void fsmpsapshow(void* dwTelHdl, u32 dwFsmpIdx, u32 dwSapId);

/*====================================================================
��������fsmpevtshow
���ܣ���ʾָ�����sap����Ϣ��¼����Ϊ0����ʾ������������Ϣ��¼��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����dwSapId �� �������
����ֵ˵��
====================================================================*/
void fsmpevtshow(void* dwTelHdl, u32 dwFsmpIdx, u32 dwSapId);

/*====================================================================
��������fsmptimetrack
���ܣ��Ƿ��¼��Ϣ����ĺ�ʱ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����dwTimeTrackFlag �� 1����¼�����ʱ��0������¼����Ĭ��Ϊ����¼��
����ֵ˵��
====================================================================*/
void fsmptimetrack(void* dwTelHdl, u32 dwTimeTrackFlag);

/*====================================================================
��������fsmpsndmsgloseset
���ܣ����÷������ʧ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����dwTelHdl �� telnet���
			  dwIdx - fsmpʵ������	
			  byRate - ��ʧ��	
����ֵ˵��
====================================================================*/
void fsmpsndmsgloseset(void* dwTelHdl, u32 dwFsmpIdx, u8 byRate);

/*====================================================================
��������fsmprcvmsgloseset
���ܣ����ý������ʧ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	dwTelHdl �� telnet���
				dwIdx - fsmpʵ������	
				byRate - ��ʧ��	
����ֵ˵��
====================================================================*/
void fsmprcvmsgloseset(void* dwTelHdl, u32 dwFsmpIdx, u8 byRate);


/*====================== �ֲ�ʽ���Խӿ� =========================*/
/*====================================================================
��������FsmpHdlGetOnSTP
���ܣ��õ�fsmp���
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����adwInPara[0] -- dwAppHdl
			  pbyOutBuf -- ����fsmp���
����ֵ˵��
====================================================================*/
u32 FsmpHdlGetOnSTP(IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, \
					IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen);


/*====================================================================
��������FsmpHdlGetOnSTP
���ܣ��õ�Sapͳ����Ϣ
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����adwInPara[0] -- fsmp���
			  adwInPara[1] -- sap���
			  pbyOutBuf -- ���� TSapStatis �ṹ
pbyOutBuf -- ����fsmp���
����ֵ˵��
====================================================================*/
u32 FsmpSapStatisGetOnSTP(IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, \
				IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen);


/*====================================================================
��������FsmpConfigGetOnSTP
���ܣ��õ�fsmp����
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����adwInPara[0] -- dwAppHdl
adwOutRet -- ����fsmp����
����ֵ˵��
====================================================================*/
u32 FsmpConfigGetOnSTP(IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, \
					IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen);

#ifdef __cplusplus
}
#endif // end Extern "C"


#endif //_FSMP_H











