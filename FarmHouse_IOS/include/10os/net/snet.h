/*****************************************************************************
ģ����  �� signet
�ļ���  �� signet.h
����ļ���signet.c
�ļ�ʵ�ֹ��ܣ�SIGNETͷ�ļ�
����    ��EastWood
�汾    ��RC00
��Ȩ    ��FOCUS��˾
------------------------------------------------------------------------------
�޸ļ�¼:
��  ��      	�汾        �޸���      �޸�����
15/03/2006 	    1.0         EastWood    ����  
*****************************************************************************/

#ifndef __SNET_H
#define __SNET_H
#ifdef __cplusplus
extern "C" {
#endif

typedef void* HSNetMod;
typedef void* HSig;  
typedef u32     SIGRET;
#define SIGNET_VER "SIGNET V3R1 I090630R090630"
#define SIGOK  0   //�ɹ�
#define	SIGPOINTERNULLERR  (SIGNET_ERRBASE+1) //ָ��Ϊ��
#define SIGMEMERR   (SIGNET_ERRBASE+2)   //�ڴ治��
#define	SIGBINDERR  (SIGNET_ERRBASE+3)   //��ʧ��
#define	SIGSEMERR   (SIGNET_ERRBASE+4)   //�ź�������
#define SIGBUFFULLERR (SIGNET_ERRBASE+5)  //������
#define	SIGSIZELONGERR (SIGNET_ERRBASE+6)  //̫��
#define	SIGPARAMERR    (SIGNET_ERRBASE+7)  //��������
#define	SIGPORTCONFLICTERR (SIGNET_ERRBASE+8) //�˿ڳ�ͻ
#define	SIGTHREADERR    (SIGNET_ERRBASE+9) //�����̳߳���
#define SIGMODNOTEXISTERR (SIGNET_ERRBASE+10)  //ģ�鲻����
#define	SIGTIMEERR  (SIGNET_ERRBASE+11)   //������ʱ������
#define SIGTIMEOUTERR  (SIGNET_ERRBASE+12)   //��ʱ
#define SIGHASCONNECTERR (SIGNET_ERRBASE+13)  //��������
#define SIGISCONNECTTINGERR (SIGNET_ERRBASE+14)  //��������
#define SIGSENDINGFILEERR (SIGNET_ERRBASE+15)   //���ڷ����ļ�
#define SIGFILEOPENERR    (SIGNET_ERRBASE+16)   //���ļ�����
#define SIGFILECREATEERR    (SIGNET_ERRBASE+17)   //�����ļ�����
#define SIGFILEREADERR    (SIGNET_ERRBASE+18)   //���ļ�����
#define SIGFILEWRITEERR    (SIGNET_ERRBASE+19)   //д�ļ�����
#define SIGFILENULLERR      (SIGNET_ERRBASE+20)   //�ļ�Ϊ��
#define SIGHANDLENOTEXSITERR (SIGNET_ERRBASE+21)  //handle������
#define SIGSERVERONLYONEERR  (SIGNET_ERRBASE+22)   //ֻ�ܴ���һ��Server
#define SIGNOTCONNECTERR     (SIGNET_ERRBASE+23)    //δ������
#define SIGDISCONNECTERR     (SIGNET_ERRBASE+24)    //����
#define SIGMSGFIFOCERR     (SIGNET_ERRBASE+25)    //������ϢFIFOʧ��
#define SIGCLIENTFULLERR     (SIGNET_ERRBASE+26)    //�ͻ�������
#define SIGSNDERR     (SIGNET_ERRBASE+27)    //���ͳ���
#define SIGRCVERR     (SIGNET_ERRBASE+28)    //���ܳ���
#define SIGMSGREADERR     (SIGNET_ERRBASE+29)    //��Ϣ������
#define SIGUNKNOWNERR  (SIGNET_ERRBASE+100)   //δ֪����

#define MAX_WORKPATH_LEN   1024   //�����·������
#define MAX_FILESEND_SPEED   16     //�ļ�������ٶ�

//NatBus�ڵ�����
#define SIGNATBUS_NODETYPE_SERVICE      (u32)1
#define SIGNATBUS_NODETYPE_CLIENT    (u32)2


//�첽���ӻص�
typedef void (*ConnectCallBack)(HSig hSig,u32 dwResult,u32 dwContext);

//���ӽ��ܻص�
typedef void (*ConnectAcceptCallBack)(HSig hSig,TNetAddr *ptRealNetAddr,TNetAddr *ptMapNetAddr,u32 dwContext);

//������ܻص�
typedef void (*SigRcvCallBack)(HSig hSig,TNetAddr *ptMapNetAddr,u8 *pBuf,u32 dwBufLen,u32 dwContext );

//�����ص�
typedef void (*DisConnectCallBack)(HSig hSig,u32 dwContext);

//�ļ����ͽ��Ȼص�
typedef void (*FileSendCallBack)(HSig hSig,u32 dwErrorId,u8 byCurRate,u32 dwContext);

//�ļ����ܽ��Ȼص�
typedef void (*FileRcvCallBack)(HSig hSig,char *pchLFileName,u32 dwErrorId,u8 byCurRate,u32 dwContext);

//�ļ�����ת���ص�
typedef void (*FileSigTransCallBack)(HSig hSig, u8* pSigBuf, u16 wSigLen, u32 dwContext);

/* AVTrans��ʼ���ṹ */
typedef struct tagSigParam
{
	BOOL m_bServer;  //�Ƿ�Ϊ�����
	u16 m_wSndQueueSize;  //���Ͷ��д�С
	u16 m_wRcvQueueSize;  //���ܶ��д�С
	u16 m_wCheckTimeValS; //��·�����
	u16 m_wCheckNum;    //��·������
	ConnectAcceptCallBack  m_pConnectAcceptPrc;//���ӻص�����,���Է�������Ч
	u32 m_dwConnectAcceptContext;  //���ӻص�����
	SigRcvCallBack      m_pSigRcvPrc; //SIG���ܻص�����
	u32 m_dwSigRcvContext; //SIG���ܻص�����
	DisConnectCallBack m_pDisConnectPrc; //�����ص�����
	u32 m_dwDisConnectContext; //�����ص�����
}TSigParam;



//��ʼ��SNET
//u16 m_wHighRTSigQueueSize;   //��ʵʱ������ܶ��еĴ�С(��Ϣ�ĸ���),��Ϊ��
//u16 m_wNormalRTSigQueueSize;   //��ͨʵʱ������ܶ��еĴ�С(��Ϣ�ĸ���),����Ϊ��
//u16 m_wLowRTSigQueueSize;   //��ͨʵʱ������ܶ��еĴ�С(��Ϣ�ĸ���),��Ϊ��
SIGRET SNetModInit(TCommInitParam tCommInitParam,u32 dwMaxClientNum,u32 dwMaxAcceptNum,u16 wLocalPort,u16 wHighRTSigQueueSize,u16 wNormalRTSigQueueSize,u16 m_wLowRTSigQueueSize,HSNetMod *phSNetMod);

//���ù���·��(�ļ�ȫ·��Ϊ����·��+SigSendFile�е��ļ�����)
SIGRET SNetSetWorkPath(HSNetMod hSNetMod,char *pWorkPath);


//����SIG
SIGRET SigCreate(HSNetMod hSNetMod,TSigParam tSigParam,HSig *phSig);


//��ȡSIG����
SIGRET SigParamGet(HSig hSig,TSigParam *ptSigParam);

//SIG����
SIGRET SigConnect(HSig hSig,u32 dwServerIp,u16 wServerPort,u32 dwTimeOutMs);

//�첽SIG����
SIGRET AsySigConnect(HSig hSig,u32 dwServerIp,u16 wServerPort,u32 dwTimeOutMs, ConnectCallBack pConnectPrc,u32 dwContext);

//��ȡ�Զ˵�ַ
SIGRET SigOppAddrGet(HSig hSig,TNetAddr *ptMapNetAddr);

//������·���ʱ��
SIGRET SetHeartBeatParam(HSig hSig,u16 wTimeValS,u16 wNum);

//���÷����ļ��ص�����
SIGRET SetSendFileCallBack(HSig hSig,FileSendCallBack pFileSendPrc,u32 dwContext);

//���ý����ļ��ص�����
SIGRET SetRcvFileCallBack(HSig hSig,FileRcvCallBack pFileRcvPrc,u32 dwContext);

//�����ļ���������ת���ص�����
SIGRET SetFileSigTransCallBack( HSig hSig, FileSigTransCallBack pFileSigTransPrc,u32 dwContext);
//ת���ļ�����������Բ���SigSend �� SigLowSend��
// SIGRET FileSigTransSend( HSig hSig, u8* pSigBuf,u16 wSigLen );
//�����ļ���������
SIGRET FileSigProc( HSig hSig, u8* pSigBuf,u16 wSigLen );


//����SIG,����SIG�ܳ������,���Էֳɺܶ�С������ȥ,���ܶ���ƴװ
SIGRET SigSend(HSig hSig,u8 *pBuf,u32 dwBufLen);

//��ʵʱ����SIG,����SIG�ܳ������,���Էֳɺܶ�С������ȥ,���ܶ���ƴװ
SIGRET SigHighSend(HSig hSig,u8 *pBuf,u32 dwBufLen);

//��ͨ����SIG,����SIG�ܳ������,���Էֳɺܶ�С������ȥ,���ܶ���ƴװ,��ͬSigSend
SIGRET SigNormalSend(HSig hSig,u8 *pBuf,u32 dwBufLen);

//��ʵʱ����SIG,����SIG�ܳ������,���Էֳɺܶ�С������ȥ,���ܶ���ƴװ
SIGRET SigLowSend(HSig hSig,u8 *pBuf,u32 dwBufLen);

//�����ļ�,�ļ�������·��,����·��Ϊ��ʱ�ļ�ȫ·��ΪpchLFileName;����·����Ϊ��ʱȫ·��ΪpWorkPath+pchLFileName
SIGRET SigSendFile(HSig hSig,char *pchLFileName,char *pchRFileName);

//�����ļ������ٶ�
SIGRET SigSetFileSendSpeed(HSig hSig,u8 bySpeed);

//����SIG��ʶ
SIGRET SigSetTag(HSig hSig,u32 dwTag);

//��ȡSIG��ʶ
SIGRET SigGetTag(HSig hSig,u32 *pdwTag);

//SIG����
SIGRET SigDisConnect(HSig hSig);

//ɾ��Sig
SIGRET SigDelete(HSig hSig);

//���Ͷ��������еİ�(�ڳ�ʱֵ��)
SIGRET SNetSendFlush(HSNetMod hSNetMod,u32 dwTimeOutMs);

//�˳�SNET
SIGRET SNetExit(HSNetMod hSNetMod);

//Nat��ַӳ��֪ͨ�ص�
//��ӳ�䷢���仯��Ҳͨ���ûص���֪����ӳ���ĵ�ַ
typedef void (*SigNatBusAddrMapingNtfCB)(HSNetMod hSNetMod,TNetAddr tDstAddr, TNetAddr tLocalNatAddr, u32 dwContext);

//�޷��ͶԶ˽���ͨ��֪ͨ�ص�����ָ����ʱʱ��������Ӧ��
//��ʱ��NatBus����Ŀ������Ϊ����״̬���ٽ��м�⣬����Ҫ�ټ�⣬����NatBusDetectStart
typedef void (*SigNatBusComInvalidNtfCB)(HSNetMod hSNetMod,TNetAddr tDstAddr, u32 dwContext);

//TagԴ��ַ֪ͨ�ص�
typedef void (*SigNatBusTagSrcAddrNtfCB)(HSNetMod hSNetMod,u64 qwTag, u32 dwSrcIP, u16 wSrcPort);

//ע��NatBus�ص�
typedef struct tagSigNatBusCBS
{
	SigNatBusAddrMapingNtfCB m_pSigNatBusAddrMapingNtfCB;
	SigNatBusComInvalidNtfCB m_pSigNatBusComInvalidNtfCB;
	SigNatBusTagSrcAddrNtfCB m_pSigNatBusTagSrcAddrNtfCB;
}TSigNatBusCBS;

//���ûص�
SIGRET SigNatBusCBSReg(HSNetMod hSNetMod,TSigNatBusCBS* ptSigNatBusCBS);

//����̽��ڵ㣬�ڵ�����
SIGRET SigNatBusNodeCreate(HSNetMod hSNetMod,u32 dwNodeType);
//ɾ��̽��ڵ�
SIGRET SigNatBusNodeDel(HSNetMod hSNetMod);
//����̽��Ŀ��
SIGRET SigNatBusDstAdd(HSNetMod hSNetMod,TNetAddr tDstAddr,u64 qwPrimaryTag,u64 qwSlaveTag,u32 dwTimeOutS,u32 dwContext);
//ɾ��̽��Ŀ��
SIGRET SigNatBusDstDel(HSNetMod hSNetMod,TNetAddr tDstAddr);
//��ʼĳ��Ŀ��̽��
SIGRET SigNatBusDetectStart(HSNetMod hSNetMod,TNetAddr tDstAddr);
//ֹͣĳ��Ŀ��̽��
SIGRET SigNatBusDetectStop(HSNetMod hSNetMod, TNetAddr tDstAddr);
//��ȡĳ��Ŀ��NAT��ַ
SIGRET SigNatBusPortMappingGet(HSNetMod hSNetMod,TNetAddr tDstAddr,TNetAddr *ptLocalNatAddr);

//��ȡ�汾
s8 *SNetVerGet(s8 *pchVerBuf, u32 dwLen);

//�õ�SIGNET������Ľ���
s8* SNetErrInfoGet(u32 dwErrno, s8 *pbyBuf, u32 dwInLen);

//SNET����״�����
u32 SNetHealthCheck(HSNetMod hSNetMod);

//���Խӿ�
//��ӡ���������б�
void signethelp(void* dwTelHdl);

//��ӡ�汾
void signetver(void* dwTelHdl);

//���ô�ӡ����
void signetdl(void* dwTelHdl,u8 byLvl);

//���ô�ӡ����
void signetnodebug(void* dwTelHdl);

//��ӡ���԰��������б�
void signetdebughelp(void* dwTelHdl);

//���ô�ӡ����
void signetdebugset(void* dwTelHdl,u8 byMinPrtLvl,u8 byMaxPrtLvl);
//��ӡģ��״̬
void signetmdlstatus(void* dwTelHdl,u32 dwIdx);

//���÷������ʧ��
void signetsndsigloseset(void* dwTelHdl,u32 dwIdx,u32 dwRate);
void signetsndmsgloseset(HSNetMod hSNetMod,u32 dwRate);
//���ý������ʧ��
void signetrcvsigloseset(void* dwTelHdl,u32 dwIdx,u32 dwRate);
void signetrcvmsgloseset(HSNetMod hSNetMod,u32 dwRate);
//���÷��Ͷ�����
void signetsndpacketloseset(void* dwTelHdl,HSig hSig,u32 byRate);

//��ӡ�ͻ��б�
void signetclientlist(void* dwTelHdl,u16 wModIdx);

//��ӡ�ͻ���Ϣ
void signetclientinfo(void* dwTelHdl,u16 wModIdx,u32 dwIdx);

//��ӡ������Ϣ
void signetserverinfo(void* dwTelHdl,u16 wModIdx);

//��ӡ�����б�
void signetacceptlist(void* dwTelHdl,u16 wModIdx);

//��ӡ������Ϣ
void signetacceptinfo(void* dwTelHdl,u16 wModIdx,u32 dwIdx);



//add by lee 2012-6-25
void sigcleantransfile(HSig hSig);
#ifdef __cplusplus
}
#endif
#endif

