/*****************************************************************************
ģ����      : OTL(operation system tool layer)
�ļ���      : otl.h
����ļ�    : otl.c
�ļ�ʵ�ֹ���: ����ϵͳ���߷�װ����װ��ʱ�����ڴ����UDP���͵ȳ��ò�����
			  ��ģ������Լ����߼�����ͬ��OAL��ֱ�ӵ��ò���ϵͳ�ӿڡ�
����        : gerrard
�汾        : V3R0  Copyright(C) 2006-2008 FOCUS, All rights reserved.
-----------------------------------------------------------------------------
�޸ļ�¼:
��  ��      �汾        �޸���      �޸�����
2006/12/30  V3R0        gerrard      Create����װ��ʱ��
2007/04/07	V3R0		gerrard		 
2007/04/10	V3R0		robinson	 ����ڴ�����������ݽṹ		 
2007/04/19	V3R0		robinson	 ����ʱ���Ƶ�OTL��ʵ��		
2007/07/14	V3R0		gerrard		 ��ʱ������ OalGetU64Ms ��ʱ
2007/07/24  V3R0		gerrard		 ��ʱ���� OalTaskDelay ����

2007/08/08  V3R0		gerrard		 ����OtlVerGet();
									 ȥ���ڴ�ģ��

2007/09/18  V3R0		gerrard		 ����OtlHealthCheck();
									 ʹ��vc8

2007/11/02  V3R0		gerrard	     ����otldl
2007/11/09  V3R0		gerrard	     oal����
									 071210: ��ʱ�����ӽ�׳��	
									 080117: ����SQueGetNextN
2008/02/15  V3R0		gerrard	     oal����
2008/05/23  V3R1		gerrard	     �޸�64λ�ؼ��ֵ�bug
2008/05/23  V3R1		gerrard	     ���� timerlibshow ���Խӿ�
2009/05/19  V3R1		gerrard	     OtlTimerLibCreate ��Ϊ��
2009/06/23  V3R1		gerrard	     ���� OtlTimerCBCalSet, OtlTimerWarnThreadSet
										  OtlTimerWarnCountGet	
2009/07/17  V3R1		gerrard	     ���� dnslib
******************************************************************************/

#ifndef _OTL_H
#define _OTL_H


#ifdef __cplusplus
extern "C" {
#endif 

#define OTLVER "OTL V3R1 I090717R090717"

#define OTL_OK						(u32)0
#define DNS_OK						(u32)0

#define OTL_ERR_BASE				OTL_ERRBASE
#define OTL_ERR_PARAM_ERR			(u32)(OTL_ERR_BASE + 1)
#define OTL_ERR_NULL_POINT			(u32)(OTL_ERR_BASE + 2)
#define OTL_ERR_LIST_HOLLOW			(u32)(OTL_ERR_BASE + 3)
#define OTL_ERR_NO_TIMEOUT			(u32)(OTL_ERR_BASE + 4) //��ʱ��û����
#define OTL_ERR_TIMERLIB_UNINIT		(u32)(OTL_ERR_BASE + 5)

#define	DNS_SRCNAME_NOT_EXIST		(u32)(OTL_ERR_BASE + 6)
#define	DNS_DSTIP_NOT_FOUND			(u32)(OTL_ERR_BASE + 7)	
#define	DNS_DNSSERVER_NOT_CONFIGED	(u32)(OTL_ERR_BASE + 8)
#define	DNS_NAME_FULL				(u32)(OTL_ERR_BASE + 9)	
#define	DNS_PARAM_ERROR				(u32)(OTL_ERR_BASE + 10)		

#define OTLERR_MAXERRNO				DNS_PARAM_ERROR


#ifdef _LINUX_
#include <sys/time.h>
#include <signal.h>
#endif

typedef enum 
{
	TIMER_TYPE_ONCE=0,//��ʱ������, ֻ��ʱһ��
	TIMER_TYPE_CYCLE  //��ʱ������, ���ڶ�ʱ
}eTimerType;
	


typedef void (*OTLTIMERCB)(u32 dwTimerId, u32 dwContext); //��ʱ���ص�

/*=================================================================
�� �� ��: OtlInit
��    ��: otl��ʼ��
�������: 
����ֵ:	 �ɹ���TRUE; ʧ�ܣ�FALSE 
=================================================================*/
BOOL OtlInit();

/*=================================================================
�� �� ��: OtlExit
��    ��: otl�˳�
�������: 
����ֵ:	 �ɹ���TRUE; ʧ�ܣ�FALSE 
=================================================================*/
BOOL OtlExit();

/*=================================================================
�� �� ��: OtlHealthCheck
��    ��: otl�������
�������: 
����ֵ:	 ������OTL_OK; �������������� 
=================================================================*/
u32 OtlHealthCheck();


/*=================================================================
�� �� ��: OtlVerGet
��    ��: �õ�otl�汾��
�������: pchVerBuf -- ���뻺�壬���ذ汾��
		  dwLen -- ���뻺�峤��
����ֵ:	  ����  pbyBuf	

˵��:     
=================================================================*/
s8 *OtlVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

/*================================================ ��ʱ������ ================================================*/

/*====================================================================
������		��OtlTimerLibCreate
����		�����ɶ�ʱ����
�㷨ʵ��	��
����ȫ�ֱ�������
�������˵����
����ֵ˵��	���ɹ����ض�ʱ����ľ����ʧ�ܷ���NULL
====================================================================*/
API HANDLE InnerOtlTimerLibCreate(IN s8 *pchFile, IN u32 dwLine);

#define OtlTimerLibCreate() InnerOtlTimerLibCreate(__FILE__, __LINE__)


/*====================================================================
������		��OtlPriTimerLibCreate
����		������ָ�����ȼ��Ķ�ʱ����
�㷨ʵ��	��
����ȫ�ֱ�������
�������˵����
����ֵ˵��	���ɹ����ض�ʱ����ľ����ʧ�ܷ���NULL
ע��һ��ģ���ֹ���øýӿڣ������ϲ��Ӧ�ó�����ã���������ȼ����������(����Ƶ����)
	
====================================================================*/
API HANDLE InnerOtlPriTimerLibCreate(IN u8 byPri, IN s8 *pchFile, IN u32 dwLine);

#define OtlPriTimerLibCreate(byPri) InnerOtlPriTimerLibCreate(byPri, __FILE__, __LINE__)


/*====================================================================
������		��OtlTimerSet
����		�����ö�ʱ��(���10ms)
�㷨ʵ��	��
����ȫ�ֱ�������
�������˵����
			  hTimerLib -- ��ʱ�������Ķ�ʱ����
			  dwDelayMs -- ��ʱ(ms)
			  pTimeProc -- �ص�����
			  dwContext -- ������
			  type -- ��ʱ������	
����ֵ˵��	���ɹ����ض�ʱ��ID��ʧ�ܷ���0
====================================================================*/
API u32 OtlInnerTimerSet(IN HANDLE hTimerLib,IN u32 dwDelayMs, IN OTLTIMERCB pTimeProc, 
						 IN u32 dwContext, IN eTimerType type, IN s8 *pchFile, IN u32 dwLine);

#define OtlTimerSet(hTimerLib, dwDelayMs, pTimeProc, dwContext, type) \
	OtlInnerTimerSet(hTimerLib, dwDelayMs, pTimeProc, dwContext, type, __FILE__, __LINE__)


/*====================================================================
������		��OtlTimerKill
����		�������ʱ��
�㷨ʵ��	��
����ȫ�ֱ�������
�������˵����
			  hTimerLib -- ��ʱ�������Ķ�ʱ����
			  dwTimerId -- ��ʱ����
			  
����ֵ˵��	���ɹ�����TRUE��ʧ�ܷ���FALSE
====================================================================*/
API BOOL OtlTimerKill(IN HANDLE hTimerLib,IN u32 dwTimerId);

/*====================================================================
������		��OtlTimerLibRelease
����		���ͷŶ�ʱ����
�㷨ʵ��	��
����ȫ�ֱ�������
�������˵����hTimerLib -- ��ʱ�������Ķ�ʱ����
����ֵ˵��	���ɹ�����TRUE��ʧ�ܷ���FALSE
====================================================================*/
API BOOL OtlTimerLibRelease(IN HANDLE hTimerLib);


/*====================================================================
������		��OtlTimerCBCalSet
����		���Ƿ���㶨ʱ���ص�ʱ��
�㷨ʵ��	��
����ȫ�ֱ�������
�������˵����
����ֵ˵��	����
====================================================================*/
API void OtlTimerCBCalSet(IN BOOL bCal);

/*====================================================================
������		��OtlTimerWarnThreadSet
����		�����ö�ʱ����ص���ʱ�澯����
�㷨ʵ��	��
����ȫ�ֱ�������
�������˵����
����ֵ˵��	��
====================================================================*/
API BOOL OtlTimerWarnThreadSet(IN HANDLE hTimerLib, IN u32 dwThreshHoldMs);

/*====================================================================
������		��OtlTimerWarnCountGet
����		���õ���ʱ���ص���ʱ�澯����
�㷨ʵ��	��
����ȫ�ֱ�������
�������˵����
����ֵ˵��	��
====================================================================*/
API BOOL OtlTimerWarnCountGet(IN HANDLE hTimerLib, IN u32 dwTimerId, OUT u32 *pdwCount);

/*================================================ ���λ��� ================================================*/
/*API u32 OtlCycleBufCreate(IN u32 dwBufNum, IN u32 dwBufSize, OUT u32 *pdwBufHdl);
API u32 OtlCycleBufDelete(IN u32 dwBufHdl);
API u32 OTLCycleBufWrite(IN u32 dwBufHdl, IN void *pvFirstData, IN u32 dwFirstDataLen, IN void *pvSecondData, IN u32 dwSecondDataLen);
API u32 OTLCycleBufRead(IN u32 dwBufHdl, OUT void *pvReadBuf, IN u32 dwInLen, OUT u32 *pdwRealLen);
API u32 OtlCycleBufDataNumGet(IN u32 dwBufHdl, OUT u32 *pdwDataNum);
*/



/************************************************************************/
/* ���Խӿ�                                                            */
/**
**********************************************************************/

/*===========================================================
�������� otlver
���ܣ� 
�㷨ʵ�֣�
����ȫ�ֱ����� δ����
�������˵����   
               
            
����ֵ˵���� ��
===========================================================*/
API void otlver(IN void* dwTelHdl);

//��ʱ����Ϣ
API void timerlibshow(IN void* dwTelHdl);

/*=============================================== ������� ================================================*/

#define SORTQUEVER "SORTQUE V3R0 RC01 b20070302"

typedef enum tagSQKeyType
{
	SQKEY_S8,
	SQKEY_U8,
	SQKEY_S16,
	SQKEY_U16,
	SQKEY_S32,
	SQKEY_U32,
	SQKEY_S64,
	SQKEY_U64,
	SQKEY_STRING,
	SQKEY_USER_DEFINED/*��Ϊ�û������������ͣ����ж����ݴ�С�Ļص���������Ϊ��*/
}SQKeyType;



typedef struct tagSQNode
{
	void *pKey;//�ؼ���
	struct tagSQNode *pLeft;//����Ů
	struct tagSQNode *pRight;//����Ů
	struct tagSQNode *pParent;//���ڵ�
	s32 sdwBalance;//ƽ������
	u32 dwUseMagic;//�жϽڵ��Ƿ��Ѵ�����ĳ�����ݽṹ�У���ֹ�ڵ㱻���ʹ��
}SQNode;

/*===========================================================
�������� SQKeyCmpCallBack
���ܣ� �ȽϹؼ����С�Ļص�����
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� void *pKey1 ��һ���ؼ���
				void *pKey2 �ڶ����ؼ���
����ֵ˵���� ����0��ʾ���,<0��ʾpKey1<pKey2,>0��ʾpKey1>pKey2
===========================================================*/
typedef s32 (*SQKeyCmpCallBack)(IN void *pKey1, IN void *pKey2 );



/*===========================================================
�������� SQKeyCmpByContextCallBack
���ܣ� �ȽϹؼ����С�Ļص�����, ��������
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� void *pKey1 ��һ���ؼ���
void *pKey2 �ڶ����ؼ���
����ֵ˵���� ����0��ʾ���,<0��ʾpKey1<pKey2,>0��ʾpKey1>pKey2
===========================================================*/
typedef s32 (*SQKeyCmpByContextCallBack)(IN void *pKey1, IN void *pKey2, IN u32 dwContext);


typedef struct tagSortQue
{
	u32  dwLength;//sizeof(SortQue)
	SQNode *pRoot;//���ڵ�
	SQKeyType eKeyType;//�ڵ�ؼ�������
	SQKeyCmpCallBack pKeyCmpCallBack;//�ؼ���Ƚϴ�С�Ļص�����
	u32 dwSize;//��ǰ�ڵ����
	BOOL m_bCmpByContext; //�ȽϺ����Ƿ��������
	SQKeyCmpByContextCallBack pKeyCmpByContextCallBack;//�ؼ���Ƚϴ�С�Ļص�����, ��������
	u32 m_dwContext;
}SortQue;


/*===========================================================
�������� SQueInit
���ܣ� ��ʼ���������
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
			   SQKeyType eKeyType �ؼ������ͣ���ΪSQKEY_USER_DEFINED�������������pSqCmpCallBack����Ϊ�գ�
			   SQKeyCmpCallBack pSqCmpCallBack �ؼ���Ƚϻص�����
����ֵ˵���� �ɹ�����TRUE������ɹ�����FALSE
===========================================================*/
API BOOL SQueInit(IN SortQue *pSQ,IN SQKeyType eKeyType,IN SQKeyCmpCallBack pSqCmpCallBack);


/*===========================================================
�������� SQueInitByContext
���ܣ� ��ʼ���������
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
SQKeyType eKeyType �ؼ������ͣ���ΪSQKEY_USER_DEFINED�������������pSqCmpCallBack����Ϊ�գ�
SQKeyCmpCallBack pSqCmpCallBack �ؼ���Ƚϻص�����
����ֵ˵���� �ɹ�����TRUE������ɹ�����FALSE
===========================================================*/
API BOOL SQueInitByContext(IN SortQue *pSQ,IN SQKeyType eKeyType,
						   IN SQKeyCmpByContextCallBack pKeyCmpByContextCallBack, IN u32 dwContext);


/*===========================================================
�������� SQueInsert
���ܣ� ����ڵ㣨�ڲ���ǰ�����ú�pNode->pKey��
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
				SQNode *pNode �ڵ�ָ��(����Ϊ������õĽڵ㣬SortQue�ڲ������䣬ֻ����֯���ӹ�ϵ)
����ֵ˵���� �ɹ�����TRUE�����򷵻�FALSE
===========================================================*/
API BOOL SQueInsert(IN SortQue *pSQ,IN  SQNode *pNode);

/*===========================================================
�������� SQueRemove
���ܣ� ɾ������
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
				IN void *pKey ���ݵĹؼ���

����ֵ˵���� �ɹ�����TRUE�����򷵻�FALSE
===========================================================*/
API BOOL SQueRemove(IN SortQue *pSQ,IN void *pKey);

/*===========================================================
�������� SQueGet
���ܣ� �õ��ؼ���ΪpKey������
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
			void *pKey ���ݵĹؼ���
����ֵ˵���� �ɹ����ؽڵ�ָ�룬����NULL
===========================================================*/
API SQNode* SQueGet(IN  SortQue *pSQ,IN void *pKey);

/*===========================================================
�������� SQueNext
���ܣ� ��ñȵ�ǰ����ؼ�������һ�ڵ�
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
			void *pRefKey ������ȽϵĹؼ���
����ֵ˵���� �ɹ����ؽڵ�ָ�룬����NULL
===========================================================*/
API SQNode* SQueNext(IN  SortQue *pSQ,IN void *pRefKey);

/*===========================================================
�������� SQuePre
���ܣ� ��ñȵ�ǰ����ؼ���С����һ�ڵ�
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
				void *pRefKey ������ȽϵĹؼ���
����ֵ˵���� �ɹ����ؽڵ�ָ�룬����NULL
===========================================================*/
API SQNode* SQuePre(IN  SortQue *pSQ,IN void *pRefKey);

/*===========================================================
�������� SQueMin
���ܣ� ��ùؼ�����С�Ľڵ�
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
����ֵ˵���� �ɹ����ؽڵ�ָ�룬����NULL
===========================================================*/
API SQNode* SQueMin(IN  SortQue *pSQ);

/*===========================================================
�������� SQueMax
���ܣ� ��ùؼ������Ľڵ�
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
����ֵ˵���� �ɹ����ؽڵ�ָ�룬����NULL
===========================================================*/
API SQNode* SQueMax(IN  SortQue *pSQ);

/*===========================================================
�������� SQueSize
���ܣ� �ö��нڵ����
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
            
����ֵ˵���� ���ؽڵ����
===========================================================*/
API u32 SQueSize(IN  SortQue *pSQ);

/*===========================================================
�������� SQueIsEmpty
���ܣ� �ж���������Ƿ�Ϊ��
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
����ֵ˵���� Ϊ�շ���TRUE�����򷵻�FALSE
===========================================================*/
API BOOL SQueIsEmpty(IN SortQue *pSQ);

/************************************************************************/
/* ���Խӿ�                                                            */
/************************************************************************/
/*===========================================================
�������� squehelp
���ܣ� ����汾�ż������б�
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵����             
����ֵ˵���� 
===========================================================*/
API void squehelp();

/*===========================================================
�������� SQueBalanceValidate
���ܣ� ��֤SortQue���нڵ��ƽ�������Ƿ���ȷ
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵���� SortQue *pSQ SortQueָ��
����ֵ˵���� 
===========================================================*/
API BOOL SQueBalanceValidate(IN  SortQue *pSQ);


/*===========================================================
�������� SQueGetNextN
���ܣ� ������õ�����ڵ�
�㷨ʵ�֣� 
����ȫ�ֱ����� δ����
�������˵����	pSQ - �������
pKey - �ؼ���
dwMaxNodeNum - ���ڵ���
aptSQNode - �ڵ�ָ������
pdwNodeCount - ����ʵ�ʵõ��Ľڵ���
����ֵ˵����  
===========================================================*/
API BOOL SQueGetNextN(IN  SortQue *pSQ,IN void *pKey, u32 dwMaxNodeNum, SQNode * aptSQNode[], u32 * pdwNodeCount);

/*============= dns =============*/

u32 init_cbb_dns_module(TCommInitParam tCommonInit,u16 wLocalPort,u32 dwQueryInterval);
/*
User Set Which host want
*/
u32 set_cbbdns_resolve_name(s8* name);

u32 clear_cbbdns_resolve_name(s8* name);
/*
Get user host-want result
*/
u32 get_cbbhost_by_name(s8* name,u32* dwIpAddr);
/*
Quit this module
*/
u32 quit_cbb_dns_module();


/*============= otl��ӡ���� =============*/

API void otldl(IN void* dwTelHdl, IN u8 byLvl);

API void otlhelp(IN void* dwTelHdl);
API void otlprtname(IN void* dwTelHdl);
API void otltimercbcal(IN void* dwTelHdl, IN BOOL bCal);
API void timerlibwarnset(IN void* dwTelHdl, IN u32 dwLibIdx, IN u32 dwWarnMS); //���ø澯��ֵ

#ifdef __cplusplus
}
#endif  // __cplusplus

#endif //_OTL_H

