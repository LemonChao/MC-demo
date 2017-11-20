#ifndef _NAT_BUS_H 
#define _NAT_BUS_H

#define NatBusVersion     "NATBUS V3R1 I080620R080620"

typedef void* NATBUSMOD;

typedef enum
{
	NatBus_OK = 0,
	NatBus_InvalidMod = NATBUS_ERRBASE + 1, //��Чmod
	NatBus_System,             //ϵͳ����
	NatBus_InvalidParam,       //�����Ƿ�
	NatBus_DaemonNode_Exist,   //�ػ��ڵ��Ѵ���
	NatBus_Node_NotExist,       //�ڵ㲻����
	NatBus_DstExist,           //Ŀ���Ѵ���
	NatBus_DstNotExist,        //Ŀ�Ĳ�����
	NatBus_Detect_NotFinish,   //̽��δ���
	NatBus_DstUnReachable,     //Ŀ�Ĳ��ɴ�

}ENatBusErrCode;

//NatBus�ڵ�����
#define NATBUS_NodeType_Service        (u32)1     //����˽ڵ�
#define NATBUS_NodeType_Client         (u32)2     //�ͻ��˽ڵ�

//Nat��ַӳ��֪ͨ�ص�
//��ӳ�䷢���仯��Ҳͨ���ûص���֪����ӳ���ĵ�ַ
typedef void (*NatBusAddrMapingNtfCB)(NATBUSMOD NatBusMod, u16 wLocalPort, TNetAddr tDstAddr, TNetAddr tLocalNatAddr, u32 dwContext);

//�޷��ͶԶ˽���ͨ��֪ͨ�ص�����ָ����ʱʱ��������Ӧ��
//��ʱ��NatBus����Ŀ������Ϊ����״̬���ٽ��м�⣬����Ҫ�ټ�⣬����NatBusDetectStart
typedef void (*NatBusComInvalidNtfCB)(NATBUSMOD NatBusMod, u16 wLocalPort, TNetAddr tDstAddr, u32 dwContext);

//TagԴ��ַ֪ͨ�ص�
typedef void (*NatBusTagSrcAddrNtfCB)(NATBUSMOD NatBusMod, u16 wLocalPort, u64 qwTag, u32 dwSrcIP, u16 wSrcPort);

//���緢��ԭ��
typedef u32 (*NatBusNetSend)(IN u16 wLocalPort, IN u8 *pBuf, IN u32 dwBufLeng, IN u32 dwDstIP, IN u16 wDstPort);

//ע��NatBus�ص�
typedef struct _tagNatBusCBS
{
	NatBusAddrMapingNtfCB m_pNatBusAddrMapingNtfCB;
	NatBusComInvalidNtfCB m_pNatBusComInvalidNtfCB;
	NatBusTagSrcAddrNtfCB m_pNatBusTagSrcAddrNtfCB;
	NatBusNetSend m_pNatBusNetSend;
}TNatBusCBS;

BOOL RegNatBusCBS(IN NATBUSMOD NatBusMod, IN TNatBusCBS* ptNatBusCBS);

//��ȡģ��汾��
char* NatBusVerGet(IN OUT char *pchVerBuf, IN u32 dwBufLen);

/*   ע��������̲߳���ͬһ��Modʱ����������������  */

u32 NatBusInit(IN TCommInitParam tCommInitParam, OUT NATBUSMOD *pNatBusMod);

//���������ڵ㣨̽��Nat����ʱ�䣬һ��������ֻ�������һ��DaemonNode���ظ�����������ʧ�ܣ�
//DaemonNode�������ýڵ����ͣ�����NATBUS_NodeType_Client
u32 NatBusDaemonNodeCreate(IN NATBUSMOD NatBusMod, IN u16 wLocalPort);

//�����ڵ㣬�ڵ�����NATBUS_NodeType_Client or NATBUS_NodeType_Service
u32 NatBusNodeCreate(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN u32 dwNodeType);

u32 NatBusNodeDel(IN NATBUSMOD NatBusMod, IN u16 wLocalPort);

u32 NatBusDstAdd(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr, 
				 IN u64 qwMasterTag, IN u64 qwSlaveTag, IN u32 dwTimeOutS, IN u32 dwContext);

u32 NatBusDstDel(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr);

u32 NatBusDetectStart(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr);

u32 NatBusDetectStop(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr);

//NatBus���ݷ������
void NatBusSendEntry(IN NATBUSMOD NatBusMod);

//���ݽ������
//����ֵ��TRUE��ʾ����ΪNatBus���У�FALSE��ʾ��Ϊ������
BOOL NatBusRcvEntry(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN u32 dwSrcIP, IN u16 wSrcPort, IN u8 *pBuf, IN u32 dwBufLeng);

//��ȡ����Natӳ���ַ
u32 NatBusPortMappingGet(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr, OUT TNetAddr *ptLocalNatAddr);

//��ȡԶ��Natӳ���ַ(P2P����ʱ�õ��ĶԷ�Natʵ�ʳ��ڵ�ַ)
//ע��tDstAddr��̽���ԭʼ�Զ˵�ַ�����Զ�ʵ�ʵ���Чͨ�ŵ�ַ���ܲ�ͬ
u32 NatBusRemoteNatAddrGet(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr, OUT TNetAddr *ptRemoteNatAddr);

u32 NatBusHealthCheck(IN NATBUSMOD NatBusMod);

u32 NatBusExit(IN NATBUSMOD NatBusMod);

/*   ���Խӿ�  */

//��ʾģ��ڵ��б�
void natbusnodeshow(IN void* dwTelHdl, IN NATBUSMOD NatBusMod);

//��ʾָ���ڵ��ϵ�ͨ����Ϣ
void natbuscomshow(IN void* dwTelHdl, IN NATBUSMOD NatBusMod, IN u16 wLocalPort);

#endif
