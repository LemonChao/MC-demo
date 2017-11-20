/*****************************************************************************
ģ����      : STP(����ƽ̨)
�ļ���      : stp.h
����ļ�    : stp.c
�ļ�ʵ�ֹ���: ϵͳ��ͳһ����ƽ̨
����        : gerrard
�汾        : V3R1  Copyright(C) 2006-2008 FOCUS, All rights reserved.
-----------------------------------------------------------------------------
�޸ļ�¼:
��  ��      �汾        �޸���      �޸�����
2008/07/16  V3R1       gerrard      Create
******************************************************************************/
#ifndef _STP_H
#define _STP_H

#define STP_OK						(u32)0
#define STPERR_BASE					(u32)1200
#define STPERR_PARA					(u32)(STPERR_BASE+1)
#define STPERR_NULLPOINT			(u32)(STPERR_BASE+2)
#define STPERR_UNINIT				(u32)(STPERR_BASE+3)
#define STPERR_UNCONNECT			(u32)(STPERR_BASE+4)
#define STPERR_SIGNET				(u32)(STPERR_BASE+5)
#define STPERR_MAGIC				(u32)(STPERR_BASE+6)
#define STPERR_CMDFULL				(u32)(STPERR_BASE+7)
#define STPERR_OAL					(u32)(STPERR_BASE+8)
#define STPERR_OTL					(u32)(STPERR_BASE+9)
#define STPERR_TIMEOUT				(u32)(STPERR_BASE+10)
#define STPERR_LEN					(u32)(STPERR_BASE+11)
#define STPERR_NOCMD				(u32)(STPERR_BASE+12)


typedef u32 HSTPCONN;		//�ͻ������Ӿ��

#define MAXCMD_NUM			(u32)1024		//����������
#define CMDNAME_MAXLEN		(u32)30			//�������Ƴ��� 
#define CMDUSAGE_MAXLEN		(u32)80			//����˵������

#define CLTSIG_CONTEXT		999
#define SVRSIG_CONTEXT		888


//ͨ�õ������
typedef u32 (* CommFunc)(IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, \
						IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen);

/*====================================================================
��������STPInit
���ܣ�stp��ʼ��
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	tCommInit -- ������Դ
				bSvr -- �Ƿ�����	
				wPort -- �˿ں�
				dwConNum -- ���Ӹ���
����ֵ˵�����ɹ���STP_OK; ʧ�ܣ�������
====================================================================*/
u32 STPInit(IN TCommInitParam tCommInit, IN BOOL bSvr, IN u16 wPort, IN u32 dwConNum);

/*====================================================================
��������STPExit
���ܣ�stp�˳�
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	tCommInit -- ������Դ
bSvr -- �Ƿ�����	
wPort -- �˿ں�
����ֵ˵�����ɹ���STP_OK; ʧ�ܣ�������
====================================================================*/
u32 STPExit();

/*====================================================================
��������STPCmdReg
���ܣ�ע������
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	strCmdName -- ������
				pFunc -- ����ָ��
				strCmdUsage -- �����÷�
����ֵ˵�����ɹ���STP_OK; ʧ�ܣ�������
====================================================================*/
u32 STPCmdReg(IN s8 *strCmdName, IN CommFunc pFunc, IN s8 *strCmdUsage);


/*========================= �ͻ��� =========================*/

/*====================================================================
��������STPConnect
���ܣ�����
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����	dwAddr -- ����˵�ַ��������
				wPort -- �˿ں�
				phStpConn -- �������Ӿ��
����ֵ˵�����ɹ���STP_OK; ʧ�ܣ�������
====================================================================*/
u32 STPConnect(IN u32 dwAddr, IN u16 wPort, OUT HSTPCONN *phStpConn);

/*====================================================================
��������STPDisConnect
���ܣ�����
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
����ֵ˵�����ɹ���STP_OK; ʧ�ܣ�������
====================================================================*/
u32 STPDisConnect(HSTPCONN hStpConn);

/*====================================================================
��������STPCmdRunFullPara
���ܣ�ִ������
�㷨ʵ�֣�
����ȫ�ֱ�����
�������˵����
����ֵ˵��������δ��ִ�����(�緢��ʧ�ܣ��ȴ���ʱ)������STP������
			����ִ����ϣ����ظ�����ķ���ֵ
ע�⣺���ڴ���� adwInPara[10]��stp���Զ�ת���ֽ���
	  ����stp����� pbyInBuf��pbyOutBuf�еľ���ṹ��
	  �����������ҪpbyInBuf��pbyOutBuf�����е��ֽ���������߸���ʵ���������ת�� !!!
	  ���ڿͻ��ˣ����� STPCmdRun ǰתΪ������STPCmdRun��תΪ������
	  �ڷ���ˣ����ڽӿ� "strCmdName"������תΪ�������ٽ��д����ں�������ǰ��תΪ������

====================================================================*/
u32 STPCmdRunFullPara(HSTPCONN hStpConn, IN s8 *strCmdName, IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, 
			  IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen, IN u32 dwCmdRunTimeOutMs);

//ֻ�����Ͳ������������ʹ��
#define STPCmdRunIntegerPara(hStpConn, strCmdName, adwInPara, adwOutRet, dwTimeOut) \
	STPCmdRunFullPara(hStpConn, strCmdName, adwInPara, adwOutRet, NULL, 0, NULL, 0, dwTimeOut)

//ֻ���������������
#define STPCmdRunBufPara(hStpConn, strCmdName, pbyInBuf, dwInBufLen, pbyOutBuf, dwOutBufLen, dwTimeOut) \
	STPCmdRunFullPara(hStpConn, strCmdName, NULL, NULL, pbyInBuf, dwInBufLen, pbyOutBuf, dwOutBufLen, dwTimeOut)

#endif //_STP_H


