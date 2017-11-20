/*****************************************************************************
模块名      : FSMP
文件名      : fsmp.h
相关文件    : 
文件实现功能: 有限状态机平台
作者        : gerrard
版本        : V3R0  Copyright(C) 2006-2008 FOCUS, All rights reserved.
-----------------------------------------------------------------------------
修改记录:
日  期      版本        修改人      修改内容
2006/12/27  V3R0        gerrard      Create

2007/06/29	V3R0		gerrard		 网络收发使用 signet;
									 sap名称用 FCC

2007/07/18	V3R0		gerrard		 增加定时器功能
									 增加节点建链消息
									 建链、断链消息发往所有sap
									 对收发的消息低级别打印

2007/08/21	V3R0		gerrard		 FsmpInit使用TCommInitParam参数
									 使用内存管理
									 提供FsmpVerGet, FsmpErrInfoGet

2007/09/18	V3R0		gerrard		 使用vc8;
									 增加 FsmpHealthCheck
									 结构 TNodeParam  增加成员

2007/10/16	V3R0		gerrard		 使用 071015 版本的 signet	

2007/11/02	V3R0		gerrard		 增加fsmpdl
2007/11/09	V3R0		gerrard		 更新oal
2007/11/30	V3R0		gerrard		 更新signet
									 071207: 断链回调加保护，如果已处理过，直接退出	
									 071210: sap，节点统计接口，加信号量保护
									 071212: 增加模拟丢包接口 FsmpSndLoseSet, FsmpRcvLoseSet, fsmpsndmsgloseset, fsmprcvmsgloseset
									 071215: sig回调上下文用fsmp句柄  
									 071217：fsmp不做额外的节点管理，直接用hSig	
2008/02/15	V3R0		gerrard	    更新oal （080208）
2008/05/16	V3R1		gerrard	    sap改名为sap(service access point), 支持不同的sap使用不同的轮询任务
2008/07/19	V3R1		gerrard	    增加分布测试接口 FsmpHdlGetOnSTP, FsmpSapStatisGetOnSTP
******************************************************************************/

#ifndef _FSMP_H
#define _FSMP_H
  

#ifdef __cplusplus
extern "C"{
#endif // begin Extern "C"


#define	FSMPVER							"FSMP V3R1 I090430R090430"	//FSMP版本号 

typedef u32								FSMPRET;			//fsmp返回值
typedef u32								HDoPoll;		//轮询任务

#define MAX_POLLTASK_NUM				32				//轮询任务的最大值
#define MAX_NODE_NUM					(u32)65535		//支持的最大节点数		
//#define MAX_SAP_NAME_LEN			(u32)20			//sap名称最大长度,不包括'\0'
	
// fsmp保留的事件号，用户自定义的事件号不要与之冲突 !!!
#define NODE_CONNECT_EVENT				(u32)1000		//建链事件 用户不能主动发送, 可以接收。
#define NODE_DISCCONNET_EVENT			(u32)1001		//断链事件 用户不能主动发送, 可以接收。
#define NAME_QUERY_EVENT				(u32)1002		//查找名字事件，用户不能发送，接收。 对于名字查询，调用 FsmpRmtNameQuery。
#define NAME_QUERY_REPLY_EVENT			(u32)1003		//查找名字应答事件, 用户不能主动发送, 可以接收。
#define TIMER_EVENT						(u32)1004		//定时器消息, 用户不能主动发送, 可以接收。

#define MAX_DISCINFO_SAP_NUM		(u32)32			//断链时通知的最多sap个数
#define MIN_STACK_SIZE					(u32)(20<<10)	//任务堆栈大小的最小值

//传输类型，现有版本填 TCP_TRANS
#define TCP_TRANS						(u8)0			//TCP的传输方式
#define UDP_TRANS						(u8)1			//UDP的传输方式


//错误码，基数由FocusErr.h指定
#define FSMP_OK							(FSMPRET)0						//操作成功
#define FSMP_ERR_BASE					(FSMPRET)FSMP_ERRBASE			 

#define FSMP_ERR_NULL_POINT				(FSMPRET)(FSMP_ERR_BASE + 1)	//指针为空
#define FSMP_ERR_ERR_PARAM				(FSMPRET)(FSMP_ERR_BASE + 2)	//参数错误
#define FSMP_ERR_MEMMAGIC_ERR			(FSMPRET)(FSMP_ERR_BASE + 3)	//幻数错误
#define FSMP_ERR_SOCK_ERR				(FSMPRET)(FSMP_ERR_BASE + 4)	//sock操作错误
#define FSMP_ERR_TIMER_UNINIT			(FSMPRET)(FSMP_ERR_BASE + 5)	//定时器模块未初始化
#define FSMP_ERR_QUE_DAMAGED			(FSMPRET)(FSMP_ERR_BASE + 6)	//消息队列破坏
#define FSMP_ERR_QUE_HOLLOW				(FSMPRET)(FSMP_ERR_BASE + 7)	//消息队列为空
#define FSMP_ERR_QUE_FULL				(FSMPRET)(FSMP_ERR_BASE + 8)	//消息队列满
#define FSMP_ERR_ID_ERR					(FSMPRET)(FSMP_ERR_BASE + 9)	//编号错误
#define FSMP_ERR_SAP_INVALID			(FSMPRET)(FSMP_ERR_BASE + 10)	//sap无效
#define FSMP_ERR_SAP_EXIST				(FSMPRET)(FSMP_ERR_BASE + 11)	//sap已存在
#define FSMP_ERR_TASK_ERR				(FSMPRET)(FSMP_ERR_BASE + 12)	//任务操作错误
#define FSMP_ERR_NODE_INVALID			(FSMPRET)(FSMP_ERR_BASE + 13)	//节点无效
#define FSMP_ERR_REINIT					(FSMPRET)(FSMP_ERR_BASE + 14)	//fsmp重复初始化
#define FSMP_ERR_NO_FREE_SAP			(FSMPRET)(FSMP_ERR_BASE + 15)	//没有空闲的sap
#define FSMP_ERR_NO_FREE_NODE			(FSMPRET)(FSMP_ERR_BASE + 16)	//没有空闲的节点
#define FSMP_ERR_SERVER_REINITED		(FSMPRET)(FSMP_ERR_BASE + 17)	//fsmp服务器重复初始化
#define FSMP_TIMER_EXIST				(FSMPRET)(FSMP_ERR_BASE + 18)	//定时器已存在
#define FSMP_ERR_UNINIT					(FSMPRET)(FSMP_ERR_BASE + 19)	//fsmp没有初始化
#define FSMP_ERR_SEM_ERR				(FSMPRET)(FSMP_ERR_BASE + 20)	//信号操作错误
#define FSMP_ERR_CYCLE_ERR				(FSMPRET)(FSMP_ERR_BASE + 21)	//循环次数过多
#define FSMP_ERR_NAME_EXIT				(FSMPRET)(FSMP_ERR_BASE + 22)	//名字已存在
#define FSMP_ERR_NAME_UNEXIT			(FSMPRET)(FSMP_ERR_BASE + 23)	//名字不存在
#define FSMP_ERR_DISCINFO_FULL			(FSMPRET)(FSMP_ERR_BASE + 24)	//断链通知信息已注册满
#define FSMP_ERR_MEM_ALLOC				(FSMPRET)(FSMP_ERR_BASE + 25)	//内存分配错误
#define FSMP_ERR_INST_NULL				(FSMPRET)(FSMP_ERR_BASE + 26)	//实例指针为空
#define FSMP_ERR_INST_MAGIC				(FSMPRET)(FSMP_ERR_BASE + 27)	//实例幻数错
#define FSMP_ERR_INST_UNINIT			(FSMPRET)(FSMP_ERR_BASE + 28)	//实例未初始化
#define FSMP_ERR_TELNET_UNINIT			(FSMPRET)(FSMP_ERR_BASE + 29)	//telnet服务器初始化失败
#define FSMP_ERR_SIG_ERR				(FSMPRET)(FSMP_ERR_BASE + 30)	//signet错误
#define FSMP_ERR_SVRLIST_EMPTY			(FSMPRET)(FSMP_ERR_BASE + 31)	//服务器队列空	
#define FSMP_ERR_TIMERLIB_ERR			(FSMPRET)(FSMP_ERR_BASE + 32)	//定时器库错误	
#define FSMP_ERR_LIST_EMPTY				(FSMPRET)(FSMP_ERR_BASE + 33)	//队列空

#define FSMP_ERR_MAXNO					FSMP_ERR_LIST_EMPTY
		
//轮询任务参数
typedef struct tagTPollTaskPara 
{
	u8	m_byPri;		//优先级
	u32 m_dwStackSize;  //堆栈大小，（填0则用默认的10K)
	s8  *m_pchName;		//任务名称，最长为 DoPollNAME_MAXLEN 个字节
}TPollTaskPara;

//模块初始化结构
typedef struct tagFsmpInitParam
{
	u16 m_wLocalPort;        //本地端口，对应SNetModInit的参数wLocalPort
	u32 m_dwMaxNodeNum;		 //最大节点数，包括主动发起连接的节点，以及由服务器accept生成的节点。
							//对应SNetModInit的参数dwMaxCltNum + dwMaxAcceptNum
	u32 m_dwMaxCltNodeNum;   //主动发起连接的节点的最大数目，对应SNetModInit的参数dwMaxCltNum
	u32 m_dwMaxSapNum; //最大sap数
	u32 m_dwAppHdl; //应用数据，由上层解释。事件回调时带出。
	u16 m_wHighRTSigQueueSize;   //高实时信令接受队列的大小,可为零，见signet.h
	u16 m_wNormalRTSigQueueSize;  //普通实时信令接受队列的大小,不可为零，见signet.h
	u16 m_wLowRTSigQueueSize;   //低实时信令接受队列的大小,可为零，见signet.h
	u32 m_dwPollTaskNum;		//轮询任务个数
	TPollTaskPara *m_ptPollTaskPara; //轮询任务参数指针
}TFsmpInitParam;


typedef struct tagNodeParam
{
	u16 m_wSndQueueSize;  //发送对列大小, 缓冲个数，见signet.h
	u16 m_wRcvQueueSize;  //接受对列大小，缓冲个数, 见signet.h
	u16 m_wCheckTimeValS; //链路检测间隔
	u16 m_wCheckNum;    //链路检测次数
}TNodeParam;    //参考 TSigParam


//Fsmp消息
typedef struct tagFsmpMsg
{
	u32			m_dwSrcNodeId;						//源节点号, 暂时没用
	u32			m_dwSrcSapId;					//源sap号
	u32			m_dwDstNodeId;						//在FsmpMsgSnd中表示目的节点号. 在FsmpEventProc中表示收到消息的节点号
													// !!! 注意，对于 NODE_CONNECT_EVENT，NODE_DISCCONNET_EVENT，对应的建链，断链节点号
													// 放在m_pEvent中，应这样取 *((u32 *)tMsg.m_pEvent) 
	u32			m_dwDstSapId;					//目的sap号, 为0表示通过sap名称发送消息
	u32			m_dwEvent;							//事件
	u32			m_dwEventLen;						//事件长度
	FCC			m_tFccSapName;				//目的sap名，当sap号为0时才有意义。				 		
	u32			m_dwTimerId;						//定时器号, 仅当m_dwEvent ＝ TIMER_EVENT才有意义
	u32			m_dwTimerContext;					//定时器上下文，仅当m_dwEvent ＝ TIMER_EVENT才有意义
	void		*m_pEvent;							//事件指针
}TFsmpMsg;


/* 名字查询应答结构，NAME_QUERY_REPLY_EVENT 事件的消息体  */
typedef struct tagFsmpNameReply
{
	u32 m_dwId;									//sap号
	u32 m_dwNodeId;								//节点号
	FCC	m_tFccName;								//sap名字
}TFsmpNameReply;


/* 队列统计结构 */
typedef struct tagQueStatis
{
	u32			m_dwCurMsgNum;		//当前的消息个数
	u32			m_dwRcvMsgs;		//接收到的消息个数
	u32			m_dwLostMsgs;		//丢失的消息数	
	u32			m_dwMsgProced;		//处理过的消息
	u32			m_dwHisMaxMsgNum;	//曾经存储的消息个数的最大值	
	u32			m_dwHisMaxMsgSize;  //曾经存储的消息最大长度	
}TQueStatis;

/* sap统计结构 */
typedef struct tagSapStatis
{
	TQueStatis m_tFsmMsgQueStatis;	//消息队列统计	
}TSapStatis;

//异步连接回调
typedef void (*AsyConnectCB)(u32 dwFsmpHdl, u32 dwNodeId, u32 dwResult, u32 dwContext, u32 dwAppHdl);

/*===========================================================
函数名：FsmpEventProc
功能：sap收到消息后的回调函数，由用户实现
算法实现：
引用全局变量：
输入参数说明：
				u32 dwFsmpHdl - fsmp句柄
				dwAppHdl - 应用数据
				TFsmpMsg tMsg - 消息
返回值说明：无
===========================================================*/
typedef void(*FsmpEventProc) (IN u32 dwFsmpHdl, IN u32 dwAppHdl, IN TFsmpMsg tMsg); 

#define DoPollNAME_MAXLEN		(u32)64


//sap参数
typedef struct tagSapParam
{
	FCC m_tFccSapName;		//sap名
	FsmpEventProc m_pfEventfunc;	//FSMP事件处理函数, 可以为NULL
	u32 m_dwFSMMsgQueBufs;			//FSM消息队列的缓冲个数, 传0用缺省值64	
	u32 m_dwTimeQueBufs;			//定时器队列的缓冲个数, 传0用缺省值32
	u32 m_dwPollTaskIdx;				//使用哪个轮询任务，编号从0开始
}TSapParam;


/*=================================================================
函 数 名: FsmpVerGet
功    能: 得到fsmp版本号
输入参数: pchVerBuf -- 输入缓冲，带回版本号
		  dwLen -- 输入缓冲长度
返回值:	  返回  pbyBuf	

说明:     
=================================================================*/
s8 *FsmpVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

/*===========================================================
函数名：FsmpInit
功能：生成Fsmp实例
算法实现：
引用全局变量：
输入参数说明：TCommInitParam tCommInit - 公共资源。如果m_hTimerLib，m_hMem， m_dwTelHdl必须有效 										
			  TFsmpInitParam tInit -初始化参数
			  u32 *pdwFSMPHdl - 返回fsmp句柄

返回值说明：成功返回FSMP_OK，失败返回错误码
注意：在使用其他接口前，必须先调用该接口
===========================================================*/
FSMPRET FsmpInit(IN TCommInitParam tCommInit, IN TFsmpInitParam tInit, OUT u32 *pdwFSMPHdl);


/*===========================================================
函数名：FsmpExit
功能：退出Fsmp，释放相关资源
算法实现：
引用全局变量：
输入参数说明：u32 dwFsmpHdl -fsmp的句柄
返回值说明：成功返回FSMP_OK，失败返回错误码
===========================================================*/
FSMPRET	 FsmpExit(IN u32 dwFsmpHdl);


/*===========================================================
函数名：FsmpHealthCheck
功能：FSMP健康检查
算法实现：
引用全局变量：
输入参数说明：u32 dwFsmpHdl -fsmp的句柄
返回值说明：健康，FSMP_OK；不健康，错误码
===========================================================*/
u32 FsmpHealthCheck(IN u32 dwFsmpHdl);

/*===========================================================
函数名：FsmpSvrCreate
功能：创建服务器
算法实现：
引用全局变量：
输入参数说明：	u32 dwFsmpHdl -fsmp的句柄
				TNodeParam tNodeParam -- 节点参数	
	
返回值说明: 
===========================================================*/
FSMPRET FsmpSvrCreate(IN u32 dwFsmpHdl, IN TNodeParam tNodeParam); 


/*===========================================================
函数名：FsmpSvrDelete
功能：删除fsmp服务器
算法实现：
引用全局变量：
输入参数说明：	u32 dwFsmpHdl -fsmp的句柄
	
返回值说明: 
===========================================================*/
FSMPRET FsmpSvrDelete(IN u32 dwFsmpHdl); 

/*===========================================================
函数名：FsmpNodeCreate
功能：创建节点
算法实现：
引用全局变量：
输入参数说明：	u32 dwFsmpHdl -- fsmp的句柄
				u32 tNodeParam -- 节点参数
				u32 *pdwNodeId -- 返回分配到的节点号
返回值说明：
===========================================================*/
FSMPRET FsmpNodeCreate(IN u32 dwFsmpHdl, IN TNodeParam tNodeParam, IN u32 *pdwNodeId);

/*===========================================================
函数名：FsmpNodeConnect
功能： 同步链接指定的服务器
算法实现：
引用全局变量：
输入参数说明：	u32 dwFsmpHdl - fsmp的句柄
				u32 dwNodeId -- 节点号
				u32 dwSvrIpNetEndian -- 服务器地址
				u16 wSvrPort -- 服务器端口
				u32 dwTimeoutMs -- 超时（MS）
返回值说明：成功， FSMP_OK; 失败, 错误码
===========================================================*/
FSMPRET FsmpNodeConnect(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u32 dwSvrIpNetEndian, IN u16 wSvrPort, IN u32 dwTimeoutMs);


/*===========================================================
函数名：FsmpAsyNodeConnect
功能： 异步链接指定的服务器
算法实现：
引用全局变量：
输入参数说明：	u32 dwFsmpHdl - fsmp的句柄
				u32 dwNodeId -- 节点号
				u32 dwSvrIpNetEndian -- 服务器地址
				u16 wSvrPort -- 服务器端口
				u32 dwTimeoutMs -- 超时（MS）
				AsyConnectCB pConnectPrc -- 异步链接回调
				u32 dwContext -- 异步链接回调上下文

返回值说明：成功， FSMP_OK; 失败, 错误码
===========================================================*/
FSMPRET FsmpAsyNodeConnect(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u32 dwSvrIpNetEndian, IN u16 wSvrPort, 
						   IN u32 dwTimeoutMs, IN AsyConnectCB pConnectPrc, IN u32 dwContext);

/*===========================================================
函数名：FsmpNodeDisConnect
功能：与指定的服务器断开连接
算法实现：
引用全局变量：
输入参数说明：	u32 dwFsmpHdl -fsmp的句柄
				u32 dwNodeId -- Fsmp节点号 
返回值说明：成功返回FSMP_OK，失败返回错误码
===========================================================*/
FSMPRET  FsmpNodeDisConnect(IN u32 dwFsmpHdl, IN u32 dwNodeId);


/*===========================================================
函数名：FsmpNodeDelete
功能：删除节点
算法实现：
引用全局变量：
输入参数说明：	u32 dwFsmpHdl -fsmp的句柄
				u32 dwNodeId -- Fsmp节点号 
返回值说明：成功返回FSMP_OK，失败返回错误码
===========================================================*/
FSMPRET  FsmpNodeDelete(IN u32 dwFsmpHdl, IN u32 dwNodeId);

/*===========================================================
函数名：FsmpSapCreate
功能：创建Fsmpsap
算法实现：
引用全局变量：
输入参数说明：	
				u32 dwFsmpHdl -fsmp的句柄
				TSapParam tCtrParam - sap参数
				pdwSapId- sap号，返回给用户

返回值说明：成功返回FSMP_OK，失败返回错误码
===========================================================*/
FSMPRET FsmpSapCreate(IN u32 dwFsmpHdl, IN TSapParam tSapParam, OUT u32 *pdwSapId); 





/*===========================================================
函数名：FsmpMsgSend
功能：发送消息
算法实现：
引用全局变量：
输入参数说明：	
				u32 dwFsmpHdl -fsmp的句柄
				TFsmpMsg tFsmpMsg - 消息
返回值说明：成功返回FSMP_OK，失败返回错误码
注意：发给本地的消息，dwDstNodeId设置为0
===========================================================*/
FSMPRET  FsmpMsgSnd(IN u32 dwFsmpHdl, IN TFsmpMsg tFsmpMsg);


/*===========================================================
函数名：FsmpRmtNameQuery
功能：
算法实现：
引用全局变量：
输入参数说明：	u32 dwFsmpHdl - fsmp的句柄
				dwSrcSapId - 源sap号，对端节点查询到sap号后，发送 NAME_QUERY_REPLY_EVENT事件到该sap
				dwDstNodeId - 节点号，非0
				tFccName - 远端sap的名字

返回值说明：成功返回FSMP_OK，失败返回错误码
===========================================================*/
FSMPRET FsmpRmtNameQuery(IN u32 dwFsmpHdl, IN u32 dwSrcSapId, IN u32 dwDstNodeId, IN FCC tFccName);



/*===========================================================
函数名：FsmpDiscInfoAdd
功能：增加断链时要通知的sap
算法实现：
引用全局变量：
输入参数说明：
			u32 dwFsmpHdl -fsmp的句柄
			  dwNodeId: 节点号
			  dwSapId: sap号
返回值说明：成功返回FSMP_OK，失败返回错误码.
注意：目前一个节点最多注册 MAX_DISCINFO_SAP_NUM（32）个sap
为了使用简单，该接口暂不提供
===========================================================*/
//FSMPRET  FsmpDiscInfoAdd(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u32 dwSapId);


/*===========================================================
函数名：FsmpDiscInfoDel
功能：删除断链时要通知的sap信息
算法实现：
引用全局变量：
输入参数说明：
				u32 dwFsmpHdl -fsmp的句柄
				dwNodeId: 节点号
				dwSapId: sap号

 返回值说明：成功返回FSMP_OK，失败返回错误码.
 为了使用简单，该接口暂不提供
==========================================================*/
//FSMPRET  FsmpDiscInfoDel(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u32 dwSapId);



/*===========================================================
函数名：FsmpTimerSet
功能：设置定时器
算法实现：
引用全局变量：
输入参数说明：
				u32 dwFsmpHdl - fsmp的句柄
				dwDstContaineId － 接收定时器消息的sap号
				dwDelayMs － 定时器间隔
				eType - 定时器类型 	TIMER_TYPE_ONCE(一次定时) TIMER_TYPE_CYCLE(周期定时)	
				dwContext － 上下文
				pdwTimerId － 返回定时器号指针


 返回值说明：成功返回FSMP_OK，失败返回错误码.
==========================================================*/
FSMPRET FsmpTimerSet(IN u32 dwFsmpHdl, IN u32 dwDstContaineId, IN u32 dwDelayMs, IN eTimerType eType, 
					 IN u32 dwContext, OUT u32 *pdwTimerId);


/*===========================================================
函数名：FsmpTimerKill
功能		：清除定时器
算法实现：
引用全局变量：
输入参数说明：
				dwFsmpHdl - fsmp的句柄
				dwSapId - sap号
				dwTimerId － 定时器号
		

 返回值说明：成功返回FSMP_OK，失败返回错误码.
==========================================================*/
FSMPRET FsmpTimerKill(IN u32 dwFsmpHdl, IN u32 dwSapId, IN u32 dwTimerId);


/*====================================================================
函数名：FsmpNodeStatisGet
功能：得到节点统计信息
算法实现：
引用全局变量：
输入参数说明：
			  u32 dwFsmpHdl -fsmp的句柄
			  dwNodeId － 节点编号
			  ptNodeStatis - 节点统计		
返回值说明：成功返回FSMP_OK，失败返回错误码
====================================================================*/
//FSMPRET FsmpNodeStatisGet(IN u32 dwFsmpHdl, IN u32 dwNodeId, OUT TNodeStatis *ptNodeStatis);


/*====================================================================
函数名：FsmpSapStatisGet
功能：得到sap统计信息
算法实现：
引用全局变量：
输入参数说明：dwSapId － sap编号
			  ptSapStatis - sap统计		
返回值说明
====================================================================*/
FSMPRET FsmpSapStatisGet(IN u32 dwFsmpHdl, u32 dwSapId, TSapStatis *ptSapStatis);

/*====================================================================
函数名：FsmpSigGet
功能：得到sig
算法实现：
引用全局变量：
输入参数说明：
			  u32 dwFsmpHdl - fsmp的句柄
			  dwNodeId － 节点编号
			  phSig - sig指针
返回值说明：成功返回FSMP_OK，失败返回错误码
注：该接口仅为了传输文件，得到sig
====================================================================*/
FSMPRET FsmpSigGet(IN u32 dwFsmpHdl, IN u32 dwNodeId, OUT HSig *phSig);

/*====================================================================
函数名：FsmpNodeSetHeartBeatParam
功能：设置节点心跳检测参数
算法实现：
引用全局变量：
输入参数说明：
返回值说明：成功返回FSMP_OK，失败返回错误码
====================================================================*/
FSMPRET FsmpNodeSetHeartBeatParam(IN u32 dwFsmpHdl, IN u32 dwNodeId, IN u16 wTimeValS, IN u16 wNum);

/*====================================================================
函数名：FsmpOppAddrGet
功能：得到对端地址
算法实现：
引用全局变量：
输入参数说明：
				u32 dwFsmpHdl - fsmp的句柄
				dwNodeId － 节点编号
				pdwAddr - ip地址指针
返回值说明：成功返回FSMP_OK，失败返回错误码
注：该接口仅为了传输文件，得到sig
====================================================================*/
FSMPRET FsmpOppAddrGet(IN u32 dwFsmpHdl, IN u32 dwNodeId, OUT u32 *pdwAddr);

/*====================================================================
函数名：FsmpSndLoseSet
功能：设置发送信令丢失率
算法实现：
引用全局变量：
输入参数说明：
dwFsmpHdl - fsmp实例	
byRate - 丢失率	
返回值说明
====================================================================*/
FSMPRET FsmpSndLoseSet(IN u32 dwFsmpHdl, u8 byRate);

/*====================================================================
函数名：FsmpRcvLoseSet
功能：设置接收信令丢失率
算法实现：
引用全局变量：
输入参数说明：	
dwFsmpHdl - fsmp实例	
byRate - 丢失率	
返回值说明
====================================================================*/
FSMPRET FsmpRcvLoseSet(IN u32 dwFsmpHdl, u8 byRate);


///////////////////////////////////////////  调试接口  ///////////////////////////////////////////

/*====================================================================
函数名：fsmphelp
功能：fsmp帮助信息
算法实现：
引用全局变量：
输入参数说明
返回值说明
====================================================================*/
void fsmphelp(void* dwTelHdl);

/*====================================================================
函数名：fsmpprtname
功能：fsmp打印名字
算法实现：
引用全局变量：
输入参数说明
返回值说明
====================================================================*/
void fsmpprtname(void* dwTelHdl);

/*====================================================================
函数名：fsmpver
功能：fsmp版本信息
算法实现：
引用全局变量：
输入参数说明
返回值说明
====================================================================*/
void fsmpver(void* dwTelHdl);

/*====================================================================
函数名：fsmpinstshow
功能：显示fsmp实例信息
算法实现：
引用全局变量：
输入参数说明：
返回值说明
====================================================================*/
void fsmpinstshow(void* dwTelHdl);

/*====================================================================
函数名：fsmpdl
功能：
算法实现：
引用全局变量：
输入参数说明
返回值说明
====================================================================*/
void fsmpdl(void* dwTelHdl, u8 byLvl);

/*====================================================================
函数名：fsmpconfig
功能：显示fsmp的配置
算法实现：
引用全局变量：
输入参数说明：
返回值说明
====================================================================*/
void fsmpconfig(void* dwTelHdl, u32 dwFsmpIdx);

/*====================================================================
函数名：fsmpnodeshow
功能：显示指定编号节点的信息。若为0，显示所有节点的信息。
算法实现：
引用全局变量：
输入参数说明：dwNodeId － 节点编号
			  dwIdx - fsmp实例索引
返回值说明
====================================================================*/
void fsmpnodeshow(void* dwTelHdl, u32 dwFsmpIdx, u32 dwNodeId);

/*====================================================================
函数名：fsmpsapshow
功能：显示指定编号sap的信息。若为0，显示所有sap的信息。
算法实现：
引用全局变量：
输入参数说明：dwSapId － sap编号
			  dwIdx - fsmp实例索引
返回值说明
====================================================================*/
void fsmpsapshow(void* dwTelHdl, u32 dwFsmpIdx, u32 dwSapId);

/*====================================================================
函数名：fsmpevtshow
功能：显示指定编号sap的消息记录。若为0，显示所有容器的消息记录。
算法实现：
引用全局变量：
输入参数说明：dwSapId － 容器编号
返回值说明
====================================================================*/
void fsmpevtshow(void* dwTelHdl, u32 dwFsmpIdx, u32 dwSapId);

/*====================================================================
函数名：fsmptimetrack
功能：是否记录消息处理的耗时
算法实现：
引用全局变量：
输入参数说明：dwTimeTrackFlag － 1，记录处理耗时；0，不记录。（默认为不记录）
返回值说明
====================================================================*/
void fsmptimetrack(void* dwTelHdl, u32 dwTimeTrackFlag);

/*====================================================================
函数名：fsmpsndmsgloseset
功能：设置发送信令丢失率
算法实现：
引用全局变量：
输入参数说明：dwTelHdl － telnet句柄
			  dwIdx - fsmp实例索引	
			  byRate - 丢失率	
返回值说明
====================================================================*/
void fsmpsndmsgloseset(void* dwTelHdl, u32 dwFsmpIdx, u8 byRate);

/*====================================================================
函数名：fsmprcvmsgloseset
功能：设置接收信令丢失率
算法实现：
引用全局变量：
输入参数说明：	dwTelHdl － telnet句柄
				dwIdx - fsmp实例索引	
				byRate - 丢失率	
返回值说明
====================================================================*/
void fsmprcvmsgloseset(void* dwTelHdl, u32 dwFsmpIdx, u8 byRate);


/*====================== 分布式测试接口 =========================*/
/*====================================================================
函数名：FsmpHdlGetOnSTP
功能：得到fsmp句柄
算法实现：
引用全局变量：
输入参数说明：adwInPara[0] -- dwAppHdl
			  pbyOutBuf -- 带回fsmp句柄
返回值说明
====================================================================*/
u32 FsmpHdlGetOnSTP(IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, \
					IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen);


/*====================================================================
函数名：FsmpHdlGetOnSTP
功能：得到Sap统计信息
算法实现：
引用全局变量：
输入参数说明：adwInPara[0] -- fsmp句柄
			  adwInPara[1] -- sap编号
			  pbyOutBuf -- 带回 TSapStatis 结构
pbyOutBuf -- 带回fsmp句柄
返回值说明
====================================================================*/
u32 FsmpSapStatisGetOnSTP(IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, \
				IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen);


/*====================================================================
函数名：FsmpConfigGetOnSTP
功能：得到fsmp配置
算法实现：
引用全局变量：
输入参数说明：adwInPara[0] -- dwAppHdl
adwOutRet -- 带回fsmp配置
返回值说明
====================================================================*/
u32 FsmpConfigGetOnSTP(IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, \
					IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen);

#ifdef __cplusplus
}
#endif // end Extern "C"


#endif //_FSMP_H











