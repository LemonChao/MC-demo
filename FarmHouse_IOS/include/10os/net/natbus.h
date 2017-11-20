#ifndef _NAT_BUS_H 
#define _NAT_BUS_H

#define NatBusVersion     "NATBUS V3R1 I080620R080620"

typedef void* NATBUSMOD;

typedef enum
{
	NatBus_OK = 0,
	NatBus_InvalidMod = NATBUS_ERRBASE + 1, //无效mod
	NatBus_System,             //系统错误
	NatBus_InvalidParam,       //参数非法
	NatBus_DaemonNode_Exist,   //守护节点已存在
	NatBus_Node_NotExist,       //节点不存在
	NatBus_DstExist,           //目的已存在
	NatBus_DstNotExist,        //目的不存在
	NatBus_Detect_NotFinish,   //探测未完成
	NatBus_DstUnReachable,     //目的不可达

}ENatBusErrCode;

//NatBus节点类型
#define NATBUS_NodeType_Service        (u32)1     //服务端节点
#define NATBUS_NodeType_Client         (u32)2     //客户端节点

//Nat地址映射通知回调
//若映射发生变化，也通过该回调告知重新映射后的地址
typedef void (*NatBusAddrMapingNtfCB)(NATBUSMOD NatBusMod, u16 wLocalPort, TNetAddr tDstAddr, TNetAddr tLocalNatAddr, u32 dwContext);

//无法和对端建立通信通知回调（在指定超时时间内无响应）
//超时后，NatBus将该目的设置为空闲状态不再进行检测，若需要再检测，调用NatBusDetectStart
typedef void (*NatBusComInvalidNtfCB)(NATBUSMOD NatBusMod, u16 wLocalPort, TNetAddr tDstAddr, u32 dwContext);

//Tag源地址通知回调
typedef void (*NatBusTagSrcAddrNtfCB)(NATBUSMOD NatBusMod, u16 wLocalPort, u64 qwTag, u32 dwSrcIP, u16 wSrcPort);

//网络发送原型
typedef u32 (*NatBusNetSend)(IN u16 wLocalPort, IN u8 *pBuf, IN u32 dwBufLeng, IN u32 dwDstIP, IN u16 wDstPort);

//注册NatBus回调
typedef struct _tagNatBusCBS
{
	NatBusAddrMapingNtfCB m_pNatBusAddrMapingNtfCB;
	NatBusComInvalidNtfCB m_pNatBusComInvalidNtfCB;
	NatBusTagSrcAddrNtfCB m_pNatBusTagSrcAddrNtfCB;
	NatBusNetSend m_pNatBusNetSend;
}TNatBusCBS;

BOOL RegNatBusCBS(IN NATBUSMOD NatBusMod, IN TNatBusCBS* ptNatBusCBS);

//获取模块版本号
char* NatBusVerGet(IN OUT char *pchVerBuf, IN u32 dwBufLen);

/*   注：当多个线程操作同一个Mod时，必须上锁！！！  */

u32 NatBusInit(IN TCommInitParam tCommInitParam, OUT NATBUSMOD *pNatBusMod);

//创建守卫节点（探测Nat收缩时间，一个进程中只允许存在一个DaemonNode，重复创建将返回失败）
//DaemonNode无需设置节点类型，都是NATBUS_NodeType_Client
u32 NatBusDaemonNodeCreate(IN NATBUSMOD NatBusMod, IN u16 wLocalPort);

//创建节点，节点类型NATBUS_NodeType_Client or NATBUS_NodeType_Service
u32 NatBusNodeCreate(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN u32 dwNodeType);

u32 NatBusNodeDel(IN NATBUSMOD NatBusMod, IN u16 wLocalPort);

u32 NatBusDstAdd(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr, 
				 IN u64 qwMasterTag, IN u64 qwSlaveTag, IN u32 dwTimeOutS, IN u32 dwContext);

u32 NatBusDstDel(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr);

u32 NatBusDetectStart(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr);

u32 NatBusDetectStop(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr);

//NatBus数据发送入口
void NatBusSendEntry(IN NATBUSMOD NatBusMod);

//数据接收入口
//返回值：TRUE表示数据为NatBus所有，FALSE表示不为其所有
BOOL NatBusRcvEntry(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN u32 dwSrcIP, IN u16 wSrcPort, IN u8 *pBuf, IN u32 dwBufLeng);

//获取本地Nat映射地址
u32 NatBusPortMappingGet(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr, OUT TNetAddr *ptLocalNatAddr);

//获取远端Nat映射地址(P2P握手时得到的对方Nat实际出口地址)
//注：tDstAddr是探测的原始对端地址，而对端实际的有效通信地址可能不同
u32 NatBusRemoteNatAddrGet(IN NATBUSMOD NatBusMod, IN u16 wLocalPort, IN TNetAddr tDstAddr, OUT TNetAddr *ptRemoteNatAddr);

u32 NatBusHealthCheck(IN NATBUSMOD NatBusMod);

u32 NatBusExit(IN NATBUSMOD NatBusMod);

/*   调试接口  */

//显示模块节点列表
void natbusnodeshow(IN void* dwTelHdl, IN NATBUSMOD NatBusMod);

//显示指定节点上的通信信息
void natbuscomshow(IN void* dwTelHdl, IN NATBUSMOD NatBusMod, IN u16 wLocalPort);

#endif
