/*****************************************************************************
ģ����  �� avnet
�ļ���  �� avnet.h
����ļ���avnet.c
�ļ�ʵ�ֹ��ܣ�AVNETͷ�ļ�
����    ��EastWood
�汾    ��RC00
��Ȩ    ��FOCUS��˾
------------------------------------------------------------------------------
�޸ļ�¼:
��  ��      	�汾        �޸���      �޸�����
26/12/2006 	    1.0         EastWood    ����  
*****************************************************************************/

#ifndef __AVNET_H
#define __AVNET_H
#ifdef __cplusplus
extern "C" {
#endif

#define AVNET_VER "AVNET V3R1 I090804R090804"
#define AVOK  0   //�ɹ�
#define AVMODNOTEXISTERR (AVNET_ERRBASE+1)//�����ڸ�ģ��
#define AVTRANSNOTEXISTERR (AVNET_ERRBASE+2)//�����ڸ�TRANS
#define	AVPOINTERNULLERR  (AVNET_ERRBASE+3) //ָ��Ϊ��
#define AVMEMERR   (AVNET_ERRBASE+4)   //�ڴ治��
#define	AVBINDERR  (AVNET_ERRBASE+5)   //��ʧ��
#define	AVSEMERR   (AVNET_ERRBASE+6)   //�ź�������
#define	AVTIMEERR  (AVNET_ERRBASE+7)   //������ʱ������
#define AVBUFFULLERR (AVNET_ERRBASE+8)  //������
#define	AVSIZELONGERR (AVNET_ERRBASE+9)  //̫��
#define	AVPARAMERR    (AVNET_ERRBASE+10)  //��������
#define	AVPORTCONFLICTERR (AVNET_ERRBASE+11) //�˿ڳ�ͻ
#define	AVTHREADERR    (AVNET_ERRBASE+12) //�����̳߳���
#define	AVTRANSEXITERR    (AVNET_ERRBASE+13) //TRANS�˳�����
#define	AVSNDERR    (AVNET_ERRBASE+14) //���ͳ���
#define	AVTRANSTYPEERR    (AVNET_ERRBASE+15) //���ͳ���

#define	AVUNKNOWN   (AVNET_ERRBASE+255) //δ֪����
#define TAG_ALL    0xffff    //����TAG
typedef u32		HAVMOD;
typedef u32		HAVTrans;   
typedef u32     AVRET;

//NatBus�ڵ�����
#define AVNATBUS_NODETYPE_SERVICE      (u32)1
#define AVNATBUS_NODETYPE_CLIENT    (u32)2

//����ͳ��
typedef struct tagAVSndStatis
{
	u32 m_dwSndFrmNum;     //����֡��
	u32 m_dwSndPackNum;	   //���Ͱ���
	u32 m_dwSndBytes;      //�����ֽ���
	u32 m_dwMemDropFrmNum; //��������֡��
	u32 m_dwMemDropPackNum;    //������������
	u32 m_dwMemDropBytes;      //���������ֽ���
	u32 m_dwNetDropFrmNum;     //���綪֡��
	u32 m_dwNetDropPackNum;    //���綪����
	u32 m_dwNetDropBytes;      //���綪�ֽ���
	u32 m_dwNDropPRate5S;			//���5���еĶ�����
    u32 m_dwNDropPRate30S;			//���30���еĶ�����
	u32 m_dwNDropPRate5M;			//���5���ӵĶ�����
	u32 m_dwNBitRate5S;				//���5���е�����
	u32 m_dwNBitRate30S;			//���30���е�����
	u32 m_dwNBitRate5M;				//���5���е�����
	u32 m_dwSndFrmRate;             //����֡��
}TAVSndStatis;

//����ͳ��
typedef struct tagAVTransStatis
{
	u32 m_dwRcvFrmNum;
	u32 m_dwRcvPackNum;	
	u32 m_dwRcvBytes;
	u32 m_dwLostFrmNum;
	u32 m_dwLostPackNum;
	u32 m_dwLostBytes;
	u32 m_dwNDropPRate5S;			//���5���еĶ�����
    u32 m_dwNDropPRate30S;			//���30���еĶ�����
	u32 m_dwNDropPRate5M;			//���5���ӵĶ�����
	u32 m_dwNBitRate5S;				//���5���е�����
	u32 m_dwNBitRate30S;			//���30���е�����
	u32 m_dwNBitRate5M;				//���5���е�����
	u32 m_dwRcvFrmRate;
}TAVRcvStatis;


//���ջص�
typedef void (*FrameCallBack)(HAVTrans hAVTrans,TAVRawFrame *ptAVRawFrame, u16 wTag, u32 awPackLen[],u16 wPackTotal,u32 dwContext);
typedef void (*RtpPackCallBack)(HAVTrans hAVTrans,TAVPack *ptAVRtpPack, u16 wTag,u32 dwContext);
typedef void (*PackLostAlarmCallBack)(HAVTrans hAVTrans,u8 byLostRate,u32 dwContext);
typedef void (*NetBandCallBack)(HAVTrans hAVTrans,u32 dwNetBand,u32 dwContext);


//AVTrans��ʼ���ṹ
typedef struct tagAVTransParam
{
	u16					m_wBindPort;		//�󶨵Ķ˿�
	u16                 m_wTag;             //��ʶ
	u32					m_dwMaxFrmSize;     //���֡��
	u32					m_dwMaxPackSize;		// ������
	u32					m_dwSndNetBand;        //���ʹ���
	u32					m_dwMaxSndAddr;		//��෢�͵�Ŀ����, ���Ͷ�ʹ��
	u32					m_dwSndBufSize;		//���ͻ����С, ���Ͷ�ʹ��
	u32					m_dwReSndBufSize;	//�ش������С, ���Ͷ�ʹ��
	u32					m_dwRcvBufSize;     //���ջ����С, ���ն�ʹ��
	FrameCallBack		m_pFrmPrc;			//֡�ص�, ���ն�ʹ��
	RtpPackCallBack		m_pPackPrc;			//���ص�, ���ն�ʹ��
	NetBandCallBack     m_pNetBandPrc;      //����ص�,���Ͷ�ʹ��
	u32                 m_dwContext;       //�ص�������
}TAVTransParam;

//AVMemPortTrans��ʼ���ṹ
typedef struct tagAVMemPortTransParam
{
	HANDLE m_hMemPortMdl;   //�ڴ�˿�ģ����
	u32					m_dwMemPort;		//�ڴ�˿�
	u32					m_dwRcvBufSize;     //���ջ����С, ���ն�ʹ��
	FrameCallBack		m_pFrmPrc;			//֡�ص�, ���ն�ʹ��
	RtpPackCallBack		m_pPackPrc;			//���ص�, ���ն�ʹ��
	u32                 m_dwContext;       //�ص�������
}TAVMemPortTransParam;

//AVNETģ���ʼ��
AVRET AVModInit(TCommInitParam tCommInitParam,HAVMOD *phAVMod);
//AVNETģ���˳�
AVRET AVModExit(HAVMOD hAVMod);
//����AVTrans
AVRET AVTransCreate(HAVMOD hAVMod, TAVTransParam tAVTransParam, HAVTrans *phAVTrans);
//�����ڴ�˿�Trans
AVRET AVMemPortTransCreate(HAVMOD hAVMod, TAVMemPortTransParam tAVMemPortTransParam,HAVTrans *phAVTrans);
//ɾ��AVTrans
AVRET AVTransDelete(HAVMOD hAVMod, HAVTrans hAVTrans);
//��ȡAVTrans��ʼ����Ϣ
AVRET AVTransInitInfoGet(HAVTrans hAVTrans, TAVTransParam *ptAVTransParam);
//��ȡ�ڴ�˿�Trans��ʼ����Ϣ
AVRET AVMemPortTransInitInfoGet(HAVTrans hAVTrans, TAVMemPortTransParam *ptAVMemPortTransParam);
//����ĳ������Ŀ��
AVRET AVSndDstAddrSet(HAVTrans hAVTrans, u32 dwIdx, TNetAddr tDstNetParam,u16 wTag); 
//��ȡĳ������Ŀ��
AVRET AVSndDstAddrGet(HAVTrans hAVTrans, u32 dwIdx, TNetAddr *ptDstNetParam,u16 *pwTag); 
//���ĳ������Ŀ��
AVRET AVSndDstAddrClear(HAVTrans hAVTrans,u32 dwIdx);

//���Ͱ�
AVRET AVFramePacksSnd(HAVTrans hAVTrans, TAVPack atAVPack[],u16 wPackNum);

//����֡
AVRET AVRawFrameSnd(HAVTrans hAVTrans, TAVRawFrame *ptAVRawFrame);

//���÷��ͼ���(δʵ��)
AVRET AVSndEncryptSet(HAVTrans hAVTrans, u8 *pbyKeyBuf, u32 dwKeyLen, u8 byEncType);
//��ȡ����ͳ��
AVRET AVSndGetStatis(HAVTrans hAVTrans, u32 dwIdx, TAVSndStatis *ptAVSndStatis);
//���÷����ش�
AVRET AVSndRepeatSet(HAVTrans hAVTrans,BOOL bOpen);
//���÷��Ͷ�����
AVRET AVSndLoseRateSet(HAVTrans hAVTrans,u8 byRate);
//��ʼ����
AVRET AVRcvStart(HAVTrans hAVTrans);
//ֹͣ����
AVRET AVRcvStop(HAVTrans hAVTrans);
//��ȡ����ͳ��
AVRET AVRcvGetStatis(HAVTrans hAVTrans,TAVRcvStatis *ptAVRcvStatis);
//���ý����ش�
AVRET AVRcvRepeatSet(HAVTrans hAVTrans,BOOL bOpen);
//���ý���ת��Ŀ��
AVRET AVRcvRelaySet(HAVTrans hAVTrans, TNetAddr tTransSndAddr);
//��ȡ����ת��Ŀ��
AVRET AVRcvRelayGet(HAVTrans hAVTrans, TNetAddr *ptTransSndAddr);
//��ʼ����ת��
AVRET AVRcvRelayStart(HAVTrans hAVTrans);
//ֹͣ����ת��
AVRET AVRcvRelayStop(HAVTrans hAVTrans);
//���ö����澯
AVRET AVRcvPackLostAlarmSet(HAVTrans hAVTrans,u32 dwCheckItvlS,u8 byThreshold,PackLostAlarmCallBack pPackLostAlarmPrc,u32 dwContext);
//���÷��Ͷ�����
AVRET AVRcvLoseRateSet(HAVTrans hAVTrans,u8 byRate);
//���ý���(δʵ��)
AVRET AVTransDecryptSet(HAVTrans hAVTrans, u8 *pbyKeyBuf, u32 dwKeyLen, u8 byEncType);

//Nat��ַӳ��֪ͨ�ص�
//��ӳ�䷢���仯��Ҳͨ���ûص���֪����ӳ���ĵ�ַ
typedef void (*AVNatBusAddrMapingNtfCB)(HAVTrans hAVTrans, TNetAddr tDstAddr, TNetAddr tLocalNatAddr, u32 dwContext);

//�޷��ͶԶ˽���ͨ��֪ͨ�ص�����ָ����ʱʱ��������Ӧ��
//��ʱ��NatBus����Ŀ������Ϊ����״̬���ٽ��м�⣬����Ҫ�ټ�⣬����NatBusDetectStart
typedef void (*AVNatBusComInvalidNtfCB)(HAVTrans hAVTrans,TNetAddr tDstAddr, u32 dwContext);

//TagԴ��ַ֪ͨ�ص�
typedef void (*AVNatBusTagSrcAddrNtfCB)(HAVTrans hAVTrans,u64 qwTag, u32 dwSrcIP, u16 wSrcPort);

//ע��NatBus�ص�
typedef struct tagAVNatBusCBS
{
	AVNatBusAddrMapingNtfCB m_pAVNatBusAddrMapingNtfCB;
	AVNatBusComInvalidNtfCB m_pAVNatBusComInvalidNtfCB;
	AVNatBusTagSrcAddrNtfCB m_pAVNatBusTagSrcAddrNtfCB;
}TAVNatBusCBS;

//���ûص�
AVRET AVNatBusCBSReg(HAVMOD hAVMod,TAVNatBusCBS* ptAVNatBusCBS);

//����̽��ڵ㣬�ڵ�����
AVRET AVNatBusNodeCreate(HAVTrans hAVTrans,u32 dwNodeType);
//ɾ��̽��ڵ�
AVRET AVNatBusNodeDel(HAVTrans hAVTrans);
//����̽��Ŀ��
AVRET AVNatBusDstAdd(HAVTrans hAVTrans,TNetAddr tDstAddr, u64 qwPrimaryTag,u64 qwSlaveTag, u32 dwTimeOutS, u32 dwContext);
//ɾ��̽��Ŀ��
AVRET AVNatBusDstDel(HAVTrans hAVTrans,TNetAddr tDstAddr);
//��ʼĳ��Ŀ��̽��
AVRET AVNatBusDetectStart(HAVTrans hAVTrans,TNetAddr tDstAddr);
//ֹͣĳ��Ŀ��̽��
AVRET AVNatBusDetectStop(HAVTrans hAVTrans, TNetAddr tDstAddr);
//��ȡĳ��Ŀ��NAT��ַ
AVRET AVNatBusPortMappingGet(HAVTrans hAVTrans,TNetAddr tDstAddr,TNetAddr *ptLocalNatAddr);



//��ȡ�汾
s8* AVVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

//�õ�AVNET������Ľ���
s8* AVErrInfoGet(u32 dwErrno, s8 *pbyBuf, u32 dwInLen);

//AVNET����״�����
u32 AVHealthCheck(HAVMOD hAVMod);

//���Խӿ�
//��ӡ���������б�
void avnethelp(void* dwTelHdl);
//��ӡ���԰���
void avnetdebughelp(void* dwTelHdl);
//��ӡ�汾
void avnetver(void* dwTelHdl);
//���ô�ӡ����
void avnetdl(void* dwTelHdl,u8 byLvl);
//���ô�ӡ����
void avnetnodebug(void* dwTelHdl);
//���ô�ӡ����
void avnetdebugset(void* dwTelHdl,u8 byMinPrtLvl,u8 byMaxPrtLvl);
//��ӡģ��״̬
void avnetmdlstatus(void* dwTelHdl,u32 dwIdx);
//��ӡ�շ��б�
void avnettranslist(void* dwTelHdl);
//��ӡ����״̬
void avnetsndstatus(void* dwTelHdl,u32 dwIdx);
//��ӡ����ͳ��
void avnetsndstatis(void* dwTelHdl,u32 dwIdx);
//��ӡ����״̬
void avnetrcvstatus(void* dwTelHdl,u32 dwIdx);
//��ӡ����ͳ��
void avnetrcvstatis(void* dwTelHdl,u32 dwIdx);
//ת������
void avnetrelay(void* dwTelHdl,u32 dwIdx, u32 dwAddrNetEndian, u16 wPort);
//���÷��Ͷ�����
void avsndpacketloseset(void* dwTelHdl,u32 dwIdx,u8 byRate);
//���ý��ܶ�����
void avrcvpacketloseset(void* dwTelHdl,u32 dwIdx,u8 byRate);
//��ʼ���ƴ���
void avrcvrestrictbandstart(void* dwTelHdl,u32 dwIdx,u32 dwBand);
//ֹͣ���ƴ���
void avrcvrestrictbandstop(void* dwTelHdl,u32 dwIdx);
//���ñ��ٷ�
void avsndbandmultiple(void* dwTelHdl,u32 dwIdx,u32 dwBandMultiple);

//����Ŀ����Ϣ
typedef struct tagSndDstInfo
{
	u32 m_dwUsed;   //�Ƿ���ʹ��
	u32 m_dwIP;     //����Ŀ��IP
	u16 m_wPort;    //����Ŀ�Ķ˿�
	TAVSndStatis m_tAVSndStatis;   //����ͳ��
	u32 m_dwRcvBand;  //��ǰ���ܴ���
	u32 m_dwCurSndBand;  //��ǰ���ʹ���
	u32 m_dwMaxNetBand;  //����������
	u32 m_dwAvgNetBand;  //ƽ���������
	u32 m_dwMinNetBand;  //��С�������
	u32 m_qwLResndStatMs;  //��һ���ش�ͳ�Ƶ�ʱ��
	u32 m_dwLResndStatSndPackNum;  //��һ���ش�ͳ�Ƶİ���
	u32 m_dwLResndStatResndPackNum;  //��һ���ش�ͳ�Ƶ��ش�����

}TSndDstInfo;

//����Trans��Ϣ
typedef struct tagSndTransInfo
{
	u16 m_wBindPort; //���Ͷ˿�
	u32 m_dwSndBufSize;  //���ͻ���
	u32 m_dwTotalSndCnt;   //���Ͷ����ܸ���
	u32 m_dwUsedSndCnt;    //���Ͷ���ʹ�ø���
	u32 m_dwReSndBufSize;  //�ش����ͻ���
	u32 m_dwTotalReSndCnt;  //�ش������ܸ���
	u32 m_dwUsedReSndCnt;   //�ش�����ʹ�ø���
	u32 m_dwSndNetBand;     //���ʹ���
	u32 m_dwMaxFrmSize;     //���֡��
	u32 m_dwMaxPackSize;    //������
	u32 m_bReSnd;           //�����ش�
	u8 m_bySndSimLoseRate;     //����ģ�ⶪ����
	u32 m_dwSndBandMultiple;   //���ñ��ٷ�
	u32 m_dwBig200SndItvlCnt;  //���ͼ������200
	u32 m_dwBig100SndItvlCnt;  //���ͼ������100
	u32 m_dwLess100SndItvlCnt;  //���ͼ��С��100;
	u8 m_bySndTimeSeq;       //����ʱ�����
	u8 m_byLastSndTimeSeq;   //��һ������ʱ�����
	u64 m_qwLNBStatMs;       //��һ�δ���ͳ�Ƶ�ʱ��
	u32 m_dwLNBStatSndBytes;  //��һ�δ���ͳ���ֽ���
	u32 m_dwSndBytes;         //�����ֽ���
	u32 m_dwLastSndBand;      //��һ�����ʹ���
	u32 m_dwMaxSndAddr;     //���Ŀ����
	TSndDstInfo m_atSndDstInfo[64];   //����Ŀ����Ϣ

}TSndTransInfo;

//����Trans��Ϣ
typedef struct tagRcvTransInfo
{
	u16 m_wBindPort;  //���ܶ˿�
	u32 m_dwMaxFrmSize;   //���֡��
	u32 m_dwMaxPackSize;   //������
	u32 m_dwRcvBufSize;    //���ܻ���
	u32 m_dwTotalRcvCnt;   //���ܶ����ܸ���
	u32 m_dwUsedRcvCnt;    //���ܶ���ʹ�ø���
	BOOL m_bRcvStart;      //�����Ƿ�ʼ
	BOOL m_bRcvRepeatStart;   //�����ش��Ƿ�ʼ
	BOOL m_bRcvRelayStart;    //ת���Ƿ�ʼ
	u32 m_dwRelayIP;          //ת��IP
	u16 m_wRelayPort;         //ת���˿�
	u8 m_byRcvSimLoseRate;    //����ģ�ⶪ����
	u32 m_dwLastRcvFrameId;   //��һ֡
	u32 m_dwRcvFrmRate;       //����֡��
	u32 m_dwRcvFrmNum;        //����֡��
	u32 m_dwRcvPackNum;       //���ܰ���
	u32 m_dwRcvBytes;         //�����ֽ���
	u32 m_dwLostFrmNum;       //��֡��
	u32 m_dwLostPackNum;      //������
	u32 m_dwLostBytes;        //���ֽ���
	u32 m_dwNDropPRate5S;     //���5���еĶ�����
	u32 m_dwNDropPRate30S;    //���30���еĶ�����
	u32 m_dwNDropPRate5M;     //���5���ӵĶ�����
	u32 m_dwRcvBand;          //��ǰ���ܴ���
	u32 m_dwNBitRate5S;       //���5���е�����
	u32 m_dwNBitRate30S;      //���30���е����� 
	u32 m_dwNBitRate5M;       //���5���е����� 
	u32 m_dwCheckItvlS;       //�����澯����� 
	u8 m_byThreshold;         //�����澯��ֵ 
	u8 m_byLostRate;          //��ǰ������
	u32 m_dwFrameJumpCnt;     //֡������
	u8 m_byLastSndTimeSeq;    //��һ������ʱ�����
	u32 m_dwMaxNetBand;       //����������
	u32 m_dwCurNetBand;       //��ǰ�������
	u32 m_dwMinNetBand;       //��С�������
	u64 m_qwLastPackRcvTimeUs; //��һ�����Ľ���ʱ��
	u32 m_dwPackRcvTimeDiff;    //������ʱ���
	u32 m_dwRcvTimeDiffCnt;     //����ʱ������ 
	u32 m_dwRcvTimeBytes;       //����ʱ�����ֽ��� 
	u64 m_qwLastBandFeedBackMs;  //��һ�λ�����ʱ��

}TRcvTransInfo;

//��ȡ����Trans��Ϣ
u32 AVSndTransInfoGet(IN HAVTrans hAVSndTrans, OUT TSndTransInfo *ptSndTransInfo);

//��ȡ����Trans��Ϣ
u32 AVRcvTransInfoGet(IN HAVTrans hAVRcvTrans, OUT TRcvTransInfo *ptRcvTransInfo);

#ifdef __cplusplus
}
#endif
#endif

