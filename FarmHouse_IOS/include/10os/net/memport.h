#ifndef _MEM_PORT_H_
#define  _MEM_PORT_H_

#ifdef __cplusplus
extern "C" {
#endif 


//#define MEMPORT_ERRBASE				MEMPORT_ERRBASE
#define MEMPORT_SUCCESS  			0						// �����ɹ�
#define MEMPORT_PARAMERR  			(MEMPORT_ERRBASE+1)		// ��������
#define MEMPORT_MDLERROR  			(MEMPORT_ERRBASE+2)		// ģ����Ϣ����,ģ��δ�ҵ�
#define MEMPORT_OALERROR			(MEMPORT_ERRBASE+3)		// ���õײ�OALģ�鷵�ش���
#define MEMPORT_OTLERROR			(MEMPORT_ERRBASE+4)		// ���õײ�OTLģ�鷵�ش���
#define MEMPORT_MSGALLOCFAIL		(MEMPORT_ERRBASE+5)		// ������Ϣ�ռ����
#define MEMPORT_PORTBLOCK		    (MEMPORT_ERRBASE+6)		// �˿�����
#define MEMPORT_ERREND			    (MEMPORT_ERRBASE+7)		//

#ifndef _MSC_VER
//typedef void *  HANDLE;
#endif

//�˿ڵķ���
// �ڴ�˿�0xFFFF0000 ~0xFFFFFFFF
//UDP �˿�0x00000000 ~ 0x0000FFFF
//MallocFilePort �����޸�

#define MEMPORT_START 0xFFFF0000
#define MEMPORT_END 0xFFFFFFFF

typedef enum
{
	SRC_PORT = 0,
	DST_PORT,
}EPortType;

typedef enum
{
	Direct = 0,
	Queue = 1,
}ECallBacktype;

typedef enum
{
    Port_idle = 0,
    Port_block = 1,
}EStateType;

typedef struct{
	u32		dwMaxDataLen;		/* һ����Ϣ����󳤶� */
	u32		dwMaxMsgNum;		/* ģ�����ͬʱ�������Ϣ��Ŀ */
	u32		m_dwStartPort;		/* ��ʼ�ڴ�˿�*/
	u32		m_dwEndPort;		/* ��ֹ�ڴ�˿�*/
}TMemPortInitParam;

typedef void (*MPReadMemPortCallBack) (HANDLE hMp, u32 dwMemPort, u8 *pData, u32 dwDataLen,IN u32 dwContext);

u32 RegisterCallBackFunc(IN HANDLE hMp, IN u32 dwMemPort, IN EPortType ePortType, IN MPReadMemPortCallBack pReadCallBack, IN s8 *pFuncName, IN u32 dwContext);
u32 UpdateRegisterCBFunc(IN HANDLE hMp, IN u32 dwMemPort, IN EPortType ePortType, IN MPReadMemPortCallBack pReadCallBack, IN s8 *pFuncName, IN u32 dwContext);
u32 SendMsgMemPort(IN HANDLE hMp, IN u32 dwMemPort, IN EPortType ePortType, IN u8 *pData,  IN u32 dwDataLen, IN ECallBacktype eType);

/*===========================================================
��������MemPortVerGet
���ܣ���ȡ�ڴ�˿�ģ��汾
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� 
����ֵ˵����
============================================================*/  
s8 *MemPortVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

/*===========================================================
��������memportver
���ܣ���ӡ�汾
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵������
����ֵ˵������
============================================================*/
void memportver(void* dwTelHdl);

/*===========================================================
��������MemPortInit
���ܣ���ʼ���ڴ�˿�ģ��
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� 
����ֵ˵����������� 
============================================================*/  
u32 MemPortInit(TCommInitParam tCommInitParam, TMemPortInitParam tMemPortInitParam, HANDLE *phMp);

/*===========================================================
��������MemPortExit
���ܣ��˳��ڴ�˿�ģ��
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵����
����ֵ˵����������� 
============================================================*/  
u32 MemPortExit (HANDLE hMp);

/*===========================================================
��������MPSendMsgToMemPort
���ܣ�������Ϣ���ڴ�˿�
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
              				      wMemPort,	�ڴ�˿�
              				      pData		ý�����ݵ�ַ
              				      dwDataLen	ý�����ݴ�С
              				      wtype:����ģʽQueue:ʹ����Ϣ���д�����Ϣ
      				      					    Direct :ֱ�ӵ��ûص�����
����ֵ˵����������� 
============================================================*/  
//u32 MPSendMsgToMemPort(IN HANDLE hMP, IN u32 wDstPort, IN u8 *pData, IN u32 dwDataLen, IN ECallBacktype etype);
#define MPSendMsgToMemPort(hMP,wDstPort,pData,dwDataLen,etype) SendMsgMemPort(hMP,wDstPort, DST_PORT,pData,dwDataLen,etype)

/*===========================================================
��������MPSendMsgOnMemPort
���ܣ���ĳ���ڴ�˿ڷ�����Ϣ���ڴ�
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
              				      wMemPort,	�ڴ�˿�
              				      pData		ý�����ݵ�ַ
              				      dwDataLen	ý�����ݴ�С
              				      wtype:����ģʽQueue:ʹ����Ϣ���д�����Ϣ
      				      					    Direct :ֱ�ӵ��ûص�����
����ֵ˵����������� 
============================================================*/  
//u32 MPSendMsgOnMemPort(IN HANDLE hMP, IN u32 dwSrcPort, IN u8 *pData, IN u32 dwDataLen, IN ECallBacktype etype);
#define MPSendMsgOnMemPort(hMP,dwSrcPort,pData,dwDataLen,etype) SendMsgMemPort(hMP,dwSrcPort,SRC_PORT,pData,dwDataLen,etype)

/*===========================================================
��������MPSetMemPortState
���ܣ������ڴ�˿�״̬
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
		      wMemPort,	�ڴ�˿�

����ֵ˵����������� 
============================================================*/  
u32 MPSetMemPortState(IN HANDLE hMp, IN u32 dwMemPort, IN EStateType etype);
/*===========================================================
��������MPGetMemPortState
���ܣ���ȡ�ڴ�˿�״̬
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
		      wMemPort,	�ڴ�˿�

����ֵ˵����������� 
============================================================*/  
u32 MPGetMemPortState(IN HANDLE hMp, IN u32 dwMemPort, IN EStateType *petype);

/*===========================================================
��������MPRegisterSrcMemPortCB
���ܣ����ڴ�˿�ע��ص��������ڸ��ڴ�˿��յ����ݺ󣬵��øú�������
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
              				      wMemPort,	�ڴ�˿�
              				      pReadCallBack ע��Ļص�����
����ֵ˵����������� 
��ע:		AVnet���ͻ�·��Ϣʹ��MemPortʱӦ�ú�ԭMemPort��ͬ
============================================================*/  
//u32 MPRegisterSrcMemPortCB(IN HANDLE hMP, IN u32 wSrcMemPort, IN MPReadMemPortCallBack pReadCallBack);
#define MPRegisterSrcMemPortCB(hMP,wSrcMemPort,pReadCallBack,dwContext) RegisterCallBackFunc(hMP,wSrcMemPort,SRC_PORT,pReadCallBack,#pReadCallBack,dwContext)

/*===========================================================
��������MPDeleteSrcMemPortCB
���ܣ�ע���ص�����
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
              				      wMemPort,	�ڴ�˿�
              				      pReadCallBack ע��Ļص�����
����ֵ˵����������� 
��ע:		AVnet���ͻ�·��Ϣʹ��MemPortʱӦ�ú�ԭMemPort��ͬ
============================================================*/  
//u32 MPDeleteSrcMemPortCB(IN HANDLE hMP, IN u32 wSrcMemPort, IN MPReadMemPortCallBack pReadCallBack);
#define MPDeleteSrcMemPortCB(hMP,wSrcMemPort) UpdateRegisterCBFunc(hMP,wSrcMemPort,SRC_PORT,NULL,NULL,0)

/*===========================================================
��������MPDeleteDstMemPortCB
���ܣ�ע���ص�����
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
              				      wMemPort,	�ڴ�˿�
              				      pReadCallBack ע��Ļص�����
����ֵ˵����������� 
��ע:		AVnet���ͻ�·��Ϣʹ��MemPortʱӦ�ú�ԭMemPort��ͬ
============================================================*/  
//u32 MPDeleteDstMemPortCB(IN HANDLE hMP, IN u32 wDstMemPort, IN MPReadMemPortCallBack pReadCallBack);
#define MPDeleteDstMemPortCB(hMP,wDstMemPort) UpdateRegisterCBFunc(hMP,wDstMemPort,DST_PORT,NULL,NULL,0)

/*===========================================================
��������MPRegisterDstMemPortCB
���ܣ����ڴ�˿�ע��ص��������и��ڴ�˿ڷ��������ݺ󣬵��øú�������
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
              				      wMemPort,	�ڴ�˿�
              				      pReadCallBack ע��Ļص�����
����ֵ˵����������� 
��ע:		AVnet���ͻ�·��Ϣʹ��MemPortʱӦ�ú�ԭMemPort��ͬ
============================================================*/  
//u32 MPRegisterDstMemPortCB(IN HANDLE hMP, IN u32 wDstMemPort, IN MPReadMemPortCallBack pReadCallBack);
#define MPRegisterDstMemPortCB(hMP,wDstMemPort,pReadCallBack,dwContext) RegisterCallBackFunc(hMP,wDstMemPort,DST_PORT,pReadCallBack,#pReadCallBack,dwContext)

/*===========================================================
��������MemPortPrintRegFun
���ܣ���ӡ����ע��Ļص�������Ϣ
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵���� hMP,		ģ����
����ֵ˵����������� 
============================================================*/  
u32 MemPortPrintRegFun(void* dwTelHdl,u32 dwMdlIdx);

/*===========================================================
��������MemPortGetErrInfo
���ܣ���ȡ������Ϣ
�㷨ʵ�֣���
����ȫ�ֱ�������
�������˵����
����ֵ˵����������� 
============================================================*/  
s8 *MemPortGetErrInfo(u32 dwErrCode);

#ifdef __cplusplus
}
#endif  // __cplusplus

#endif
