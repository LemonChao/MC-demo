#ifndef _MEM_PORT_H_
#define  _MEM_PORT_H_

#ifdef __cplusplus
extern "C" {
#endif 


//#define MEMPORT_ERRBASE				MEMPORT_ERRBASE
#define MEMPORT_SUCCESS  			0						// 操作成功
#define MEMPORT_PARAMERR  			(MEMPORT_ERRBASE+1)		// 参数错误
#define MEMPORT_MDLERROR  			(MEMPORT_ERRBASE+2)		// 模块信息错误,模块未找到
#define MEMPORT_OALERROR			(MEMPORT_ERRBASE+3)		// 调用底层OAL模块返回错误
#define MEMPORT_OTLERROR			(MEMPORT_ERRBASE+4)		// 调用底层OTL模块返回错误
#define MEMPORT_MSGALLOCFAIL		(MEMPORT_ERRBASE+5)		// 分配消息空间错误
#define MEMPORT_PORTBLOCK		    (MEMPORT_ERRBASE+6)		// 端口阻塞
#define MEMPORT_ERREND			    (MEMPORT_ERRBASE+7)		//

#ifndef _MSC_VER
//typedef void *  HANDLE;
#endif

//端口的分配
// 内存端口0xFFFF0000 ~0xFFFFFFFF
//UDP 端口0x00000000 ~ 0x0000FFFF
//MallocFilePort 函数修改

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
	u32		dwMaxDataLen;		/* 一条消息的最大长度 */
	u32		dwMaxMsgNum;		/* 模块最多同时处理的消息数目 */
	u32		m_dwStartPort;		/* 起始内存端口*/
	u32		m_dwEndPort;		/* 终止内存端口*/
}TMemPortInitParam;

typedef void (*MPReadMemPortCallBack) (HANDLE hMp, u32 dwMemPort, u8 *pData, u32 dwDataLen,IN u32 dwContext);

u32 RegisterCallBackFunc(IN HANDLE hMp, IN u32 dwMemPort, IN EPortType ePortType, IN MPReadMemPortCallBack pReadCallBack, IN s8 *pFuncName, IN u32 dwContext);
u32 UpdateRegisterCBFunc(IN HANDLE hMp, IN u32 dwMemPort, IN EPortType ePortType, IN MPReadMemPortCallBack pReadCallBack, IN s8 *pFuncName, IN u32 dwContext);
u32 SendMsgMemPort(IN HANDLE hMp, IN u32 dwMemPort, IN EPortType ePortType, IN u8 *pData,  IN u32 dwDataLen, IN ECallBacktype eType);

/*===========================================================
函数名：MemPortVerGet
功能：获取内存端口模块版本
算法实现：无
引用全局变量：无
输入参数说明： 
返回值说明：
============================================================*/  
s8 *MemPortVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

/*===========================================================
函数名：memportver
功能：打印版本
算法实现：无
引用全局变量：无
输入参数说明：无
返回值说明：无
============================================================*/
void memportver(void* dwTelHdl);

/*===========================================================
函数名：MemPortInit
功能：初始化内存端口模块
算法实现：无
引用全局变量：无
输入参数说明： 
返回值说明：操作结果 
============================================================*/  
u32 MemPortInit(TCommInitParam tCommInitParam, TMemPortInitParam tMemPortInitParam, HANDLE *phMp);

/*===========================================================
函数名：MemPortExit
功能：退出内存端口模块
算法实现：无
引用全局变量：无
输入参数说明：
返回值说明：操作结果 
============================================================*/  
u32 MemPortExit (HANDLE hMp);

/*===========================================================
函数名：MPSendMsgToMemPort
功能：发送消息到内存端口
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
              				      wMemPort,	内存端口
              				      pData		媒体数据地址
              				      dwDataLen	媒体数据大小
              				      wtype:处理模式Queue:使用消息队列处理消息
      				      					    Direct :直接调用回调函数
返回值说明：操作结果 
============================================================*/  
//u32 MPSendMsgToMemPort(IN HANDLE hMP, IN u32 wDstPort, IN u8 *pData, IN u32 dwDataLen, IN ECallBacktype etype);
#define MPSendMsgToMemPort(hMP,wDstPort,pData,dwDataLen,etype) SendMsgMemPort(hMP,wDstPort, DST_PORT,pData,dwDataLen,etype)

/*===========================================================
函数名：MPSendMsgOnMemPort
功能：在某个内存端口发送消息到内存
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
              				      wMemPort,	内存端口
              				      pData		媒体数据地址
              				      dwDataLen	媒体数据大小
              				      wtype:处理模式Queue:使用消息队列处理消息
      				      					    Direct :直接调用回调函数
返回值说明：操作结果 
============================================================*/  
//u32 MPSendMsgOnMemPort(IN HANDLE hMP, IN u32 dwSrcPort, IN u8 *pData, IN u32 dwDataLen, IN ECallBacktype etype);
#define MPSendMsgOnMemPort(hMP,dwSrcPort,pData,dwDataLen,etype) SendMsgMemPort(hMP,dwSrcPort,SRC_PORT,pData,dwDataLen,etype)

/*===========================================================
函数名：MPSetMemPortState
功能：设置内存端口状态
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
		      wMemPort,	内存端口

返回值说明：操作结果 
============================================================*/  
u32 MPSetMemPortState(IN HANDLE hMp, IN u32 dwMemPort, IN EStateType etype);
/*===========================================================
函数名：MPGetMemPortState
功能：获取内存端口状态
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
		      wMemPort,	内存端口

返回值说明：操作结果 
============================================================*/  
u32 MPGetMemPortState(IN HANDLE hMp, IN u32 dwMemPort, IN EStateType *petype);

/*===========================================================
函数名：MPRegisterSrcMemPortCB
功能：对内存端口注册回调函数，在该内存端口收到数据后，调用该函数处理
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
              				      wMemPort,	内存端口
              				      pReadCallBack 注册的回调函数
返回值说明：操作结果 
备注:		AVnet发送回路消息使用MemPort时应该和原MemPort不同
============================================================*/  
//u32 MPRegisterSrcMemPortCB(IN HANDLE hMP, IN u32 wSrcMemPort, IN MPReadMemPortCallBack pReadCallBack);
#define MPRegisterSrcMemPortCB(hMP,wSrcMemPort,pReadCallBack,dwContext) RegisterCallBackFunc(hMP,wSrcMemPort,SRC_PORT,pReadCallBack,#pReadCallBack,dwContext)

/*===========================================================
函数名：MPDeleteSrcMemPortCB
功能：注销回调函数
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
              				      wMemPort,	内存端口
              				      pReadCallBack 注册的回调函数
返回值说明：操作结果 
备注:		AVnet发送回路消息使用MemPort时应该和原MemPort不同
============================================================*/  
//u32 MPDeleteSrcMemPortCB(IN HANDLE hMP, IN u32 wSrcMemPort, IN MPReadMemPortCallBack pReadCallBack);
#define MPDeleteSrcMemPortCB(hMP,wSrcMemPort) UpdateRegisterCBFunc(hMP,wSrcMemPort,SRC_PORT,NULL,NULL,0)

/*===========================================================
函数名：MPDeleteDstMemPortCB
功能：注销回调函数
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
              				      wMemPort,	内存端口
              				      pReadCallBack 注册的回调函数
返回值说明：操作结果 
备注:		AVnet发送回路消息使用MemPort时应该和原MemPort不同
============================================================*/  
//u32 MPDeleteDstMemPortCB(IN HANDLE hMP, IN u32 wDstMemPort, IN MPReadMemPortCallBack pReadCallBack);
#define MPDeleteDstMemPortCB(hMP,wDstMemPort) UpdateRegisterCBFunc(hMP,wDstMemPort,DST_PORT,NULL,NULL,0)

/*===========================================================
函数名：MPRegisterDstMemPortCB
功能：对内存端口注册回调函数，有该内存端口发出的数据后，调用该函数处理
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
              				      wMemPort,	内存端口
              				      pReadCallBack 注册的回调函数
返回值说明：操作结果 
备注:		AVnet发送回路消息使用MemPort时应该和原MemPort不同
============================================================*/  
//u32 MPRegisterDstMemPortCB(IN HANDLE hMP, IN u32 wDstMemPort, IN MPReadMemPortCallBack pReadCallBack);
#define MPRegisterDstMemPortCB(hMP,wDstMemPort,pReadCallBack,dwContext) RegisterCallBackFunc(hMP,wDstMemPort,DST_PORT,pReadCallBack,#pReadCallBack,dwContext)

/*===========================================================
函数名：MemPortPrintRegFun
功能：打印所有注册的回调函数信息
算法实现：无
引用全局变量：无
输入参数说明： hMP,		模块句柄
返回值说明：操作结果 
============================================================*/  
u32 MemPortPrintRegFun(void* dwTelHdl,u32 dwMdlIdx);

/*===========================================================
函数名：MemPortGetErrInfo
功能：获取错误信息
算法实现：无
引用全局变量：无
输入参数说明：
返回值说明：操作结果 
============================================================*/  
s8 *MemPortGetErrInfo(u32 dwErrCode);

#ifdef __cplusplus
}
#endif  // __cplusplus

#endif
