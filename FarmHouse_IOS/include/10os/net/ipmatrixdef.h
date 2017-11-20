/*****************************************************************************
ģ����  �� ipmatrix
�ļ���  �� ipmatrix.h
����ļ���
�ļ�ʵ�ֹ��ܣ�IPMATRIXͷ�ļ�
����    ��EastWood
�汾    ��RC00
��Ȩ    ��FOCUS��˾
------------------------------------------------------------------------------
�޸ļ�¼:
��  ��      	�汾        �޸���      �޸�����
26/12/2006 	    1.0         EastWood    ����  
*****************************************************************************/
#ifndef __IPMATRIXDEF_H
#define __IPMATRIXDEF_H

#ifdef __cplusplus
extern "C" {
#endif
	

#define RULESRC_RCVPORT			1		//���ݽ��ն˿�ת��
#define RULESRC_SRCADDR			2		//����Դ��ַת��
#define RULESRC_TAG				3		//���ݱ�ǩת��

#define RULEDST_RMTADDR			1		//���͵�Զ�˵�ַ
#define RULEDST_LOCMEM			2		//���͵����أ���Ҫ���ûص�����
#define RULEDST_TAG             3       //���͵���ǩ��Ӧ�ĵ�ַ

typedef struct tagAddr
{
	u32 m_dwIp;
	u16 m_wPort;
}TAddr;

typedef union taguRuleSrc
{
	u16		m_wRcvPort;		   //���ն˿�
	u64		m_qwTagId;		   //��ǩ
	TAddr	m_tSrcAddr;		   //Դ��ַ
}URuleSrc;

typedef struct tagRuleSrcInfo
{
	u8			m_byRuleSrcType; //���������Ľ��չ�������
	URuleSrc	m_uRuleSrc;      //����Ľ��չ���
}TRuleSrcInfo;

typedef union taguRuleDst
{
	u16   m_wMemPort;   //�ڴ�˿ں�, RULEDST_LOCMEM (���͵�����)ʱʹ��, ���庬���ɵ����߽���
	TAddr m_tDstAddr;
	u64		m_qwTagId;		   //��ǩ
}URuleDst;


typedef struct tagRuleDstInfo
{
	u8			m_byRuleDstType; //���������ķ��͹�������
	URuleDst	m_uRuleDst;      //����ķ��͹���
}TRuleDstInfo;


typedef struct tagRuleInfo
{
	TRuleSrcInfo m_tRuleSrcInfo;  //Դ����
	TRuleDstInfo m_tRuleDstInfo;  //Ŀ�Ĺ���
	u32 m_dwRuleContext;  //����������
}TRuleInfo;

typedef struct tagRuleStatis
{
	u32 m_dwRcvPacketNum;   //���ܰ���
	u32 m_dwSndPacketNum;   //���Ͱ���
}TRuleStatis;

typedef void (*RcvDataCallBack)(u32 dwRuleId,TRuleSrcInfo *ptRuleSrcInfo,u8 *pData,u32 dwDataLen);

typedef struct tagIMInitParam
{
	u16 m_wRuleMaxNumber; //������������������������
    u16 m_wPortRuleSrcAndTag;   //��Դ�ͱ�ǩת���Ľ��ܶ˿�
    u16 m_wRuleSrcNumber; //����Դת���Ĺ���������
	u16 m_wRuleTagNumber; //������ǩת���Ĺ���������
    u16 m_wRulePortStart; //���˿�ת������ʼ�˿�
    u16 m_wRulePortEnd;  //���˿�ת������ֹ�˿�
    RcvDataCallBack m_pRcvDataPro;  //�ص�����
}TIMInitParam;

#ifdef __cplusplus
}
#endif
#endif
