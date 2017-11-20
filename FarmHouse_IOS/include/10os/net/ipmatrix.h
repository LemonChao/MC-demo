#ifndef __IPMATRIX_H
#define __IPMATRIX_H
#ifdef __cplusplus
extern "C" {
#endif

typedef void* HIMMdl;

#define IM_VER "IPMATRIX V3R1 I080911R080911"
#define IMOK 					0   					//�ɹ�
#define IMUNKNOWERR 			(IPMATRIX_ERRBASE+1)   	//δ֪����
#define IMMEMERR   				(IPMATRIX_ERRBASE+2)   	//�ڴ治��
#define IMPARAMERR   			(IPMATRIX_ERRBASE+3)   	//��������
#define	IMCTHREADERR  			(IPMATRIX_ERRBASE+4)  	//�����̳߳���
#define	IMCSEMERR     			(IPMATRIX_ERRBASE+5)  	//�����ź�������
#define IMCSOCKETERR  			(IPMATRIX_ERRBASE+6)  	//�����׽��ִ���
#define	IMNORULEERR   			(IPMATRIX_ERRBASE+7) 	//RULE������
#define	IMINBUFLACKERR    		(IPMATRIX_ERRBASE+8) 	//����BUF�ĳ��Ȳ���
#define	IMHAVEINITERR    		(IPMATRIX_ERRBASE+9)	//�ѳ�ʼ��
#define IMNOTINITERR     		(IPMATRIX_ERRBASE+10)	//δ��ʼ��
#define IMSOCKETSTARTUPERR     	(IPMATRIX_ERRBASE+11)	//�����׽���ʧ��
#define IMRULEFULLERR       	(IPMATRIX_ERRBASE+12)	//������
#define IMPOINTERNULLERR    	(IPMATRIX_ERRBASE+13)  	//ָ��Ϊ��
#define IMCTIMERERR    			(IPMATRIX_ERRBASE+14)  	//������ʱ������
#define IMRULEEXISTERR    		(IPMATRIX_ERRBASE+15)  	//RULE�Ѵ���
#define IMSNDERR    			(IPMATRIX_ERRBASE+16)  	//���ͳ���
#define IMCEPOLLEERR 			(IPMATRIX_ERRBASE+17) 	//����epollʧ��
#define IMSETEPOLLEERR 			(IPMATRIX_ERRBASE+18) 	//����epollʧ��
#define	IMPORTCONFLICTERR       (IPMATRIX_ERRBASE+19)   //�˿ڳ�ͻ

static const s8* g_achIMErrInfo[] = {
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
 "������ʱ������",
 "RULE�Ѵ���",
 "���ͳ���",
 "����epollʧ��",
 "����epollʧ��",
 "�˿ڳ�ͻ",
};
	
//IPMATRIX��ʼ��
u32  IMInit(TCommInitParam tCommInitParam,TIMInitParam *ptIMInitParam,HIMMdl *phIMMdl);

//����������������
u32 IMRuleAdd(HIMMdl hIMMdl,u32 dwRuleId,TRuleInfo *ptRuleInfo);

//ɾ������
u32 IMRuleDel(HIMMdl hIMMdl,u32 dwRuleId);

//ɾ������
u32 IMRuleRDel(HIMMdl hIMMdl,TRuleInfo *ptRuleInfo);

//��ȡ���н�������ID
u32 IMRuleIdAllGet(HIMMdl hIMMdl,u32 *pdwArray, u32 dwArrayLen, u32 *pdwRuleNumer);

//��ȡ��һ������
u32 IMRuleInfoNextNGet(HIMMdl hIMMdl,u32 dwRuleId,u32 dwMaxRuleNum,TRuleInfo atRuleInfo[],u32 adwRuleId[],u32 *pdwRealRuleNum);

//��ȡ������Ϣ
u32 IMRuleInfoGet(HIMMdl hIMMdl,u32 dwRuleId,TRuleInfo *ptRuleInfo);

//��ȡ����״̬
u32 IMRuleStatisGet(HIMMdl hIMMdl,u32 dwRuleId,  TRuleStatis *ptStatis);

//��ȡ����״̬
u32 IMRuleStatisRGet(HIMMdl hIMMdl,TRuleInfo *ptRuleInfo,TRuleStatis *ptStatis);

//�ر�IPMATRIX
u32 IMClose(HIMMdl hIMMdl);	

//��ȡ�汾
s8* IMVerGet(s8 *pchVerBuf, u32 dwLen);

//�õ�IM������Ľ���
s8* IMErrInfoGet(u32 dwErrno, s8 *pbyBuf, u32 dwInLen);

//IM����״�����
u32 IMHealthCheck(void);

//��ӡ���������б�
void imhelp(void* dwTelHdl);

//��ӡ���԰���
void imdebughelp(void* dwTelHdl);

//���ô�ӡ����
void imdl(void* dwTelHdl,u8 byLvl);

//�����޵��Դ�ӡ
void imnodebug(void* dwTelHdl);

//���õ��Դ�ӡ����
void imdebugset(void* dwTelHdl,u8 byPrtType,u8 byMinPrtLvl,u8 byMaxPrtLvl);

//��ӡģ���б�
void immdllist(void* dwTelHdl);

//��ӡ���н�������
void imruledump(void* dwTelHdl,u32 dwMdlIdx);

//��ӡָ��id�Ľ�������
void imprintrule(void* dwTelHdl,u32 dwMdlIdx, u32 dwRuleId);

BOOL IMPrintRulebyMdl(void* dwTelHdl,  void *handle, u32 dwRuleId);

//��ӡʹ�õ��׽���
void imsockdump(void* dwTelHdl,u32 dwMdlIdx);

//��ӡ�汾
void imver(void* dwTelHdl);

//��ӡ��ǩӳ���ַ�б�
void imtagmapaddrlist(void* dwTelHdl,u32 dwMdlIdx);

//��ӡ̽��ڵ�
void imnatbusnodeshow(void* dwTelHdl,u32 dwMdlIdx);

//��ӡ�ڵ��ϵ�ͨ����Ϣ
void imnatbuscomshow(void* dwTelHdl,u32 dwMdlIdx);

//���ָ��socket�İ�ͳ��
void imclearsockpackstat(u32 dwMdlIdx);

void imruledump_port(u32 dwMdlIdx);

#ifdef __cplusplus
}
#endif
#endif

