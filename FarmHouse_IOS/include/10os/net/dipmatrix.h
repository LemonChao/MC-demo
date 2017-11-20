/*****************************************************************************
ģ����  �� dipmatrix
�ļ���  �� dipmatrix.h
����ļ���
�ļ�ʵ�ֹ��ܣ�DIPMATRIXͷ�ļ�
����    ��EastWood
�汾    ��RC00
��Ȩ    ��FOCUS��˾
------------------------------------------------------------------------------
�޸ļ�¼:
��  ��      	�汾        �޸���      �޸�����
26/12/2006 	    1.0         EastWood    ����  
*****************************************************************************/
#ifndef __DIPMATRIX_H
#define __DIPMATRIX_H

#ifdef __cplusplus
extern "C" {
#endif

#define DIM_VER "DIPMATRIX V3R0 RC10 b20071130 I071130R071130"
	
#define DIMOK 0   //�ɹ�
#define DIMUNKNOWERR (DIPMATRIX_ERRBASE+1)   //δ֪����
#define DIMMEMERR   (DIPMATRIX_ERRBASE+2)   //�ڴ治��
#define DIMPARAMERR   (DIPMATRIX_ERRBASE+3)   //��������
#define	DIMCTHREADERR  (DIPMATRIX_ERRBASE+4)  //�����̳߳���
#define	DIMCSEMERR     (DIPMATRIX_ERRBASE+5)  //�����ź�������
#define DIMCSOCKETERR  (DIPMATRIX_ERRBASE+6)  //�����׽��ִ���
#define	DIMNORULEERR   (DIPMATRIX_ERRBASE+7)  //RULE������
#define	DIMINBUFLACKERR    (DIPMATRIX_ERRBASE+8) //����BUF�ĳ��Ȳ���
#define	DIMHAVEINITERR    (DIPMATRIX_ERRBASE+9) //�ѳ�ʼ��
#define DIMNOTINITERR     (DIPMATRIX_ERRBASE+10)  //δ��ʼ��
#define DIMSOCKETSTARTUP     (DIPMATRIX_ERRBASE+11) //�����׽���ʧ��
#define DIMRULEFULLERR       (DIPMATRIX_ERRBASE+12) //������
#define DIMPOINTERNULLERR    (IPMATRIX_ERRBASE+13)  //ָ��Ϊ��

static const s8* g_achDIMErrInfo[] = {
 "δ֪����",
 "�ڴ治��",
 "��������",
 "�����̳߳���",
 "�����ź�������",
 "�����׽��ִ���", 
 "RULE������",
 "����BUF�ĳ��Ȳ���",
 "�ѳ�ʼ��",
 "δ��ʼ��",
 "�����׽���ʧ��",
 "������",
 "ָ��Ϊ��",
};

//��·����ص�����
typedef void  (*ManageCallBack)( u32 dwNodeId,u16 wEvent,u32 dwRuleId,u32 dwErrorId);



//DIM��������ʼ���������ֻ�������һ���ӿ�
u32 DIMSvrCreate(u16 wPort, RcvDataCallBack pDataPrc);

//�ڵ�����ʼ�����ͻ��˵���
u32 DIMNodeNumInit(u32 dwNodeNum);

//����DIM������, �ɹ��Ļ���pdwNodeId����һ����0�Ľڵ��
u32 DIMConnect(u32 *pdwNodeId, u32 dwIp, u16 wPort, u32 dwTimeOut, ManageCallBack pManage);

//����DIM������
u32 DIMDisConnect(u32 dwNodeId);


//DIPMATRIX��ʼ��
u32  DIMInit(TCommInitParam tCommInitParam,u32 dwNodeId, TIMInitParam *ptIMInitParam);


//����������������, dwNodeIdΪ0��ʾ�ڱ��ؽ�������
u32 DIMRuleAdd(u32 dwNodeId, u32 *pdwRuleId, TRuleInfo *ptRuleInfo);

//ɾ������
u32  DIMRuleDel(u32 dwNodeId, u32 dwRuleId);

//��ȡָ���ڵ�����н�������ID
u32  DIMRuleIdAllGet(u32 dwNodeId, u32 *pdwArrary, u32 dwArrayLen, u32 *pdwRuleNumer);

//��ȡ�����ͳ��
u32  DIMRuleInfoGet(u32 dwNodeId, u32 dwRuleId,  TRuleInfo *ptRuleInfo);

//��ȡָ���ڵ�Ĺ���ͳ��
u32  DIMRuleStatisGet(u32 dwNodeId, u32 dwRuleId,  TRuleStatis *ptStatis);	

//�ر�IPMATRIX
BOOL  DIMClose(u32 dwNodeId);	

//��ȡ�汾
s8* DIMVerGet(s8 *pchVerBuf, u32 dwLen);

//�õ�IM������Ľ���
s8* DIMErrInfoGet(u32 dwErrno, s8 *pbyBuf, u32 dwInLen);	

//DIM����״�����
BOOL DIMHealthCheck(void);  

//��ӡ���н�������, ������ƽ̨
void dimruledump(void* dwTelHdl);

//��ӡʹ�õ��׽���, ������ƽ̨
void dimsockdump(void* dwTelHdl);

//��ӡ�汾
void dimver(void* dwTelHdl);

//��ӡ���������б�
void dimhelp(void* dwTelHdl);

//��ӡ���԰���
void dimdebughelp(void* dwTelHdl);

//���ô�ӡ����
void dimdl(void* dwTelHdl,u8 byLvl);

//�����޵��Դ�ӡ
void dimnodebug(void* dwTelHdl);

//���õ��Դ�ӡ����
void dimdebugset(void* dwTelHdl,u8 byPrtType,u8 byMinPrtLvl,u8 byMaxPrtLvl);



#ifdef __cplusplus
}
#endif
#endif
