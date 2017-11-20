/*****************************************************************************
模块名      : oal(operation system abstract layer)
文件名      : oal.h
相关文件    : 
文件实现功能: 操作系统抽象层， 操作系统基本调用封装
作者        : yangxin
版本        : V3R0  Copyright(C) 2006-2008 uv, All rights reserved.
-----------------------------------------------------------------------------
修改记录:
日  期      版本        修改人      修改内容
2006/12/27  V3R0        yangxin      Create
2007/04/18  V3R0        robinson     添加OalTaskWait
2007/06/05  V3R0        robinson     添加对信号量的监视（OalSemWatch）
2007/06/09  V3R0		yangxin		 增加时间模块
2007/06/14  V3R0		yangxin		 修改64位毫秒的表示方式
2007/06/27  V3R0		yangxin		 错误码用统一的分配；
									 增加任务优先级的宏定义
									 增加目录操作接口
									 增加telnet服务器

2007/06/28  V3R0		yangxin		 增加宏HOST_ENTRY
									 改宏 ASSERT_RETURN 为 OAL_ASSERT_RETURN, 防止和hisi冲突

2007/07/13  V3R0		yangxin		 OalGetMs 改为 OalGetU64Ms

2007/07/17  V3R0		yangxin		 OalTickGet 改为 OalU64TickGet;
									 增加 OalInit(), OalExit();
									 OalTaskCreate, 堆栈大小如果为0，用默认的10K

2007/07/24  V3R0		yangxin		 增加 OalVerGet();

									 直接返回u64的函数，u64值不保证能正确返回。 修改接口，u64值通过参数指针得到，内部实现用memcpy
									 u64 OalU64TickGet() 改为 OalU64TickGet(u64 *pqwTick);
									 u64 OalGetU64Ms() 改为 void OalGetU64Ms(u64 *pqwMs);
									 MSTIME MSTimeGet() 改为 void MSTimeGet(IN OUT MSTIME *ptMsTime);
									 MSTIME STime2MSTime(IN STIME tSTime) 改为 void STime2MSTime(IN STIME tSTime, IN OUT MSTIME *ptMsTime);
				
									 使用winsock2库 

2007/08/08  V3R0		yangxin		 增加内存库;
									 内存库位于oal最底层，oal其他模块用内存库的内存分配	
									 增加OalErrInfoGet的实现

2007/08/20  V3R0		yangxin		 增加有名信号量，用于进程间的互斥;
									 定制内存的个数不限制，可定制任意大小的内存
									 OalPoolMalloc，如果没有定制内存，按最接近的2的整数幂分配内存，范围为 32, 64, ..., 8M
									 
									 07/08/28	
									 增加 msgfifo
									 增加 MEMTAG_RPLOGIC, MEMTAG_6101SECURITY
									 增加 OalMemChk，供调试用
									 oal 内部创建一个telnet服务器，端口号为 5678，目前用于 OalMemChk 的打印
								
2007/09/18  V3R0		yangxin		使用vc8开发；
									增加 OalHealthCheck;

									07/09/20
									增加性能统计接口 CpuUsgGet, MemUsgGet, DiskUsgGet

									修改信号量监控策略,只针对二进制信号监控,且监控始终使能。
									OalSemBeginWatch, OalSemEndWatch 只是空实现。
									OalSemDump() 改为 OalSemDump(u32 dwTelHdl)
									增加 semdump 调试接口。
									
									07/09/25
									telnet 增加密码验证

									07/10/10
									telnet 退出，等待线程结束
									信号量监控，如已加入链表，不再加入

									07/10/15
									增加日志功能

									07/10/20
									记录日志的上下文

									07/10/25
									OalHealthCheck 改为 u32 的返回值
									增加 MEMTAG_6104ENC 的定义

2007/11/02  V3R0		yangxin		提供 oaldl

2007/11/09  V3R0		yangxin		修改LvlPrt可能无限循环发送的bug
									增加 MsgFifoReadByTime
									071216 增加 MEMTAG_ESFONT
									071219 去掉信号量监控	

2007/11/09  V3R0		yangxin		增加IsPortFree接口，仅适用于windows平台

2008/02/08  V3R0		yangxin	    增加精确打印，（分级打印保留，但不建议使用）
									增加信号量监控(测试性能)
									6201上的系统时间使用RTC
									rsrctag（资源标签）动态分配
									增加 OalIsPathExist
									增加 MsgFifoSizeCal
									增加 IpListGet(仅适用于windows平台)
									增加 OalTeltHdlGet()接口，由最上层的exe程序调用。上层程序不再自己创建telnet服务器。

2008/03/14	V3R0		yangxin		增加 CpuNumGet(); CpuFrqGet(); 仅适用于windows平台
									增加 NtfsJdg(); 仅适用于windows平台
									修改 IsPortFree() 的实现，对windows,linux平台都适用。

2008/03/14	V3R0		yangxin		增加 emalloc, ecalloc, erealloc, efree, 用于替换第三方代码中的内存分配

2008/04/22	V3R1		yangxin		增加 IpNum2Str();
2008/06/04	V3R1		yangxin		增加 AccuPrtIsNameAdded()
2008/06/12	V3R0		yangxin		增加 MacListGet(仅适用于windows平台)
2008/06/13	V3R0		yangxin		增加 PortStatusGet
2008/06/26	V3R1		yangxin		增加 IsIpAddrValid, IsNetMaskValid, IsIpMaskAddrValid
2008/07/12	V3R1		yangxin		将内部使用的 LightLockCreate, LightLockDelete, LightLockLock, LightLockUnLock
									放到接口中

2008/07/31	V3R1		yangxin     oal初始化增加参数；
									增加任务监控

2008/08/19	V3R1		yangxin		增加 轻量级锁 LightLock 相关接口
									增加 ShMemInit，ShMemGet，ShMemClean

2008/08/22	V3R1		yangxin		接口中去掉ememinit, ememexit, 有oal内部调用
									增加 OalCreateProcess，OalCloseProcess

2008/08/22	V3R1		yangxin		精确打印增加时间; 增加 aprtms，控制打印时间是否显示到毫秒。

2008/10/29	V3R1		yangxin		linux下增加崩溃转储 ExcpCatchSet
2008/10/31	V3R1		yangxin		MacListGet, IpListGet 增加在linux上的实现
2008/11/04	V3R1		yangxin		oal初始化时，加载前端（arm）的模块（为了得版号，设置实时时间）
									对于有实时时钟的系统，设置系统时间的同时设置实时时钟
									对于PPC, 每一分钟检查实时时钟和系统时间，大于10秒，用实时时钟同步系统时间

2008/11/05	V3R1		yangxin		增加 GateWayGet
2008/11/12	V3R1		yangxin		监控轻量级锁
2008/11/19	V3R1		yangxin		增加 OalMLibGet 供 berkeleydb 使用
									信号量（锁）监控增加序号
									健康检查每一分钟检查内存是否太低(分配不到100K)
									增加 OalPoolRealloc 供 berkeleydb 使用
2008/11/20	V3R1		yangxin	    OalPoolMalloc, OalPoolRealloc时，大于8M的内存直接从操作系统要
2008/11/22	V3R1		yangxin	    任务创建用 do_task 封装用户的人口函数，记录任务的进程号
									增加stackdump
2008/11/26	V3R1		yangxin	    板号由oal初始化时传入，oal不再加载前端的模块
2008/11/27	V3R1		yangxin	    增加TimeSync, 供6304, 6201调用
2008/12/01	V3R1		yangxin	    增加 OalMemAlign
2008/12/13	V3R1		yangxin	    增加 IpAddrGetByDomainName
2008/12/16	V3R1		yangxin	    增加 OalDiskInfoGet
2008/12/17	V3R1		yangxin	    OalIsPathExist的实现用stat64
2009/01/17	V3R1		yangxin	    oal linux 初始化时打开 /proc/stat
2009/01/21	V3R1		yangxin	    修改OalGetU64Ms的实现,oal内部用一个任务定时通过系统调用得到ms,
									外部接口直接从内部变量得到ms
2009/02/11	V3R1		yangxin	    oal退出打印没退出的任务
2009/02/18	V3R1		yangxin	    6808使用hisi自带时钟
2009/02/21	V3R1		yangxin	    增加 OalDelFilesInDir
2009/02/22	V3R1		yangxin	    对于带时钟的嵌入式设备，如果时间小于2009/1/1，设置到2009/1/1
2009/02/25	V3R1		yangxin	    增加 IpMaskListGet
2009/02/26	V3R1		yangxin	    hisi自带时钟耗电, 6808还是使用PCF8563
2009/03/09	V3R1		yangxin	    增加 MacAddrSet
									IpAddrSet, GatewaySet 用c接口，不用system
2009/03/10	V3R1		yangxin	    IpAddrSet 实现中激活网口
									增加 OalFileReadableJdg
2009/03/17	V3R1		yangxin	    增加 OalGetFilesInDir
2009/03/19	V3R1		yangxin	    增加 OalSetBrdId
2009/03/20	V3R1		yangxin	    MsgFifoSizeCal 比实际多算一个buf的大小
2009/03/21	V3R1		yangxin	    增加 IsIpAddrStrValid
2009/03/21	V3R1		yangxin	    增加 OalFileReadableFastJdg;
									OalFileReadableJdg不用direct方式
2009/04/27	V3R1		yangxin		增加SlowBadSem接口，原有的Sem接口一周后删除 
2009/04/30	V3R1		yangxin		增加 OalTaskHeartBeat OalTaskHBChkItvlSet, 监控任务
2009/05/05	V3R1		yangxin		Sem相关接口删除; msgfifo不用sem同步读写
2009/05/07	V3R1		yangxin		增加SuperIpListGet
2009/05/16	V3R1		yangxin		OalTaskHBChkItvlSet, 默认最小值为10分钟
2009/05/19	V3R1		yangxin		增加强制杀进程接口 OalKillProcess
2009/06/03	V3R1		yangxin		OalMemAlign直接从操作系统要,不放在缓冲池
2009/06/04	V3R1		yangxin		linux上创建的进程，设置主线程优先级为 PRI_NORMAL
2009/06/08	V3R1		yangxin		实现 IsNetMaskStrValid
2009/06/18	V3R1		yangxin		增加 OalIsProcessExist
2009/07/15	V3R1		yangxin		增加 estyiled
2009/07/28	V3R1		yangxin		RsrcTagAlloc,如果标签名相同，返回相同的标签
2009/09/02	V3R1		yangxin		实现IsMacAddrStrValid
2009/09/22	V3R1		yangxin		内存接口针对内存库加锁，提高效率
2009/10/21	V3R1		yangxin		CalDayOfMonth

注：设置时区时，请用 TZ_LOCAL，其他暂时不支持
******************************************************************************/
#ifndef _OAL_H
#define _OAL_H

#ifdef __cplusplus
extern "C" {
#endif

//#ifndef _LINUX_
//#define _LINUX_
//#endif

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <errno.h>

#include <string.h>
#ifdef _WIN32
#include <sys/types.h>
#include <sys/stat.h>
#include <winsock2.h>

#else 
#include <sys/socket.h>
#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <pthread.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/timeb.h>
#include <sys/ipc.h>
#include <sched.h>
#include <semaphore.h>
#include <netinet/tcp.h>


#endif //_LINUX_


#ifdef _WIN32

typedef SOCKET SOCKHANDLE;						
typedef HANDLE SEMHANDLE;	
typedef HANDLE TASKHANDLE;	
#define API __declspec(dllexport)
#define HTASK_NULL	NULL

#else//_WIN32



typedef int			SOCKHANDLE;						
typedef void *		SEMHANDLE;
typedef pthread_t	TASKHANDLE;	
typedef void *		HMODULE;

#define API  //(extern "C")	//???yangxin
#define INVALID_SOCKET	-1 
#define SOCKET_ERROR	-1

#define HTASK_NULL	0

#endif //_LINUX_


//#include "uvbaseyype.h"
//#include "uvErr.h"
//#include "uvVMDef.h"

#define	OALVER						"OAL V3R1 I090922R090922"	//OAL版本号
#define CREATETASK_SUSPEND			1 //创建任务时，将任务先挂起

#define OAL_OK			(u32)0

#define OALSEM_SIGNALED		OAL_OK
#define BDSLIB_SUCCESS		OAL_OK
#define MSGFIFO_OK			OAL_OK

//错误码

#define OALSEM_TIMEOUT			(u32)(OAL_ERRBASE + 1)
#define OALSEM_FAILED			(u32)(OAL_ERRBASE + 2)
#define OALERR_UNINIT			(u32)(OAL_ERRBASE + 3)

#define BDSLIB_INVALID_PARAM	 (u32)(OAL_ERRBASE + 4)	/*参数无效*/
#define BDSLIB_SHOULD_BE_INIT	 (u32)(OAL_ERRBASE + 5)	/*没有被初始化或者初始化失败*/
#define BDSLIB_NODE_INUSE		 (u32)(OAL_ERRBASE + 6)	/*节点已是链表（栈、队列）中的节点*/
#define BDSLIB_NODE_NOT_INUSE	 (u32)(OAL_ERRBASE + 7)	/*节点不是链表中的节点*/
#define BDSLIB_ALREADY_EMPTY	 (u32)(OAL_ERRBASE + 8)	/*链表（栈、队列）已空*/

#define OALERR_NULLPOINT		(u32)(OAL_ERRBASE + 9)	/*指针为空*/
#define MSGFIFOERR_MAGIC		(u32)(OAL_ERRBASE + 10)	/*msgfifo幻数错*/
#define MSGFIFOERR_STATUS		(u32)(OAL_ERRBASE + 11)	/*msgfifo状态错*/
#define MSGFIFOERR_NOSPACE		(u32)(OAL_ERRBASE + 12)	/*msgfifo没有足够的空间*/
#define MSGFIFOERR_HOLLOW		(u32)(OAL_ERRBASE + 13)	/*msgfifo没有数据*/
#define MSGFIFOERR_DATAMAGIC	(u32)(OAL_ERRBASE + 14)	/*msgfifo 数据幻数错*/
#define MSGFIFOERR_READBUFLEN	(u32)(OAL_ERRBASE + 15)	/*msgfifo 读缓冲长度不够*/
#define MSGFIFOERR_TOKENLEN		(u32)(OAL_ERRBASE + 16)	/*msgfifo token 长度错*/
#define MSGFIFOERR_TOKENUNMATCH	(u32)(OAL_ERRBASE + 17)	/*msgfifo token 不匹配*/
#define MSGFIFOERR_DATAINVALID	(u32)(OAL_ERRBASE + 18)	/*msgfifo 数据无效，已被删除*/

#define OALERR_PARAM			(u32)(OAL_ERRBASE + 19)	/*参数错*/
#define OALERR_CYCLE			(u32)(OAL_ERRBASE + 20)	/*循环次数错*/
#define OALERR_SYSCALL			(u32)(OAL_ERRBASE + 21)	/*系统调用错*/
#define OALERR_MEMERR			(u32)(OAL_ERRBASE + 22)	/*内存错*/
#define OALERR_MEMLOW			(u32)(OAL_ERRBASE + 23)	/*内存不足*/
#define OALERR_TASKERR			(u32)(OAL_ERRBASE + 24)	/*任务出错*/
#define OALERR_STACKERR			(u32)(OAL_ERRBASE + 25)	/*堆栈出错*/

#define OALERR_MAXERRNO			OALERR_STACKERR


#define DEFAULT_PRTGATE			(u8)100	//默认打印门限，可以修改

//telnet 打印级别
#define PRT_LVL_HIGHEST				(u8)255
#define PRT_LVL_HIGHER				(u8)200
#define PRT_LVL_NORMAL				(u8)120
#define PRT_LVL_LOWER				(u8)80
#define PRT_LVL_LOWEST				(u8)20

//任务优先级
#define PRI_CRITICAL		(u8)10
#define PRI_HIGHEST			(u8)4
#define PRI_ABOVE_NORMAL	(u8)3
#define PRI_NORMAL			(u8)2
#define PRI_BELOW_NORMAL	(u8)1
#define PRI_LOWEST			(u8)0

//资源标签
//#define MAX_TAG_NO						 (u32)512
#define RSRCTAGNAME_MAXLEN				 (u32)8 //资源标签最大长度

//端口状态
#define TCP_STATE_CLOSED		1
#define TCP_STATE_LISTEN		2
#define TCP_STATE_SYN_SENT		3
#define TCP_STATE_SYN_RCVD		4
#define TCP_STATE_ESTAB			5
#define TCP_STATE_FIN_WAIT1		6
#define TCP_STATE_FIN_WAIT2		7
#define TCP_STATE_CLOSE_WAIT	8	
#define TCP_STATE_CLOSING		9
#define TCP_STATE_LAST_ACK		10
#define TCP_STATE_TIME_WAIT		11
#define TCP_STATE_DELETE_TCB	12

//oal初始化参数
typedef struct tagOalInitParam 
{
	u32 m_dwTagNum;			//资源标签数目, 填0用512
	u16 m_wTelnetPort;		//telnet端口号，填0用5678
	u32 m_dwBrdId;			//板号。目前用于6304sd上实时时钟的处理
	u32 m_dwReserved2;
	u32 m_dwReserved3;
	u32 m_dwReserved4;
	u32 m_dwReserved5;
	u32 m_dwReserved6;
}TOalInitParam;

/*====================================================================
函数名：OalInit
功能：oal初始化
算法实现：（可选项）
引用全局变量：
输入参数说明：tOalInit -- oal初始化参数(只有第一次初始化oal时才有效)

返回值说明：成功返回TRUE，失败返回FALSE
====================================================================*/
API BOOL OalInit(TOalInitParam tOalInit);

/*====================================================================
函数名：OalExit
功能：oal退出
算法实现：（可选项）
引用全局变量：
输入参数说明：

返回值说明：成功返回TRUE，失败返回FALSE
====================================================================*/
API BOOL OalExit(void);

/*====================================================================
函数名：OalSetBrdId
功能：oal设置板号，(供前端app调用，用于6201,6304的时钟同步)
算法实现：（可选项）
引用全局变量：
输入参数说明：

返回值说明：成功返回TRUE，失败返回FALSE
====================================================================*/
#ifdef _ARM_
API BOOL OalSetBrdId(u32 dwBrdId);
#endif

/*====================================================================
函数名：TimeSync
功能：同步时间，读取实时时钟的时间，设置系统时间。供6304, 6201调用
算法实现：（可选项）
引用全局变量：
输入参数说明：

返回值说明：成功返回TRUE，失败返回FALSE
====================================================================*/
#ifdef _ARM_
API void TimeSync();
#endif

/*=================================================================
函 数 名: OalTeltHdlGet
功    能: 得到oal模块创建的telnet服务器
输入参数: 
返回值:	  

说明:     
=================================================================*/
API void* OalTeltHdlGet(void);

/*===========================================================
函数名： OalMLibGet
功能： 得到oal内部的内存分配器
算法实现：
引用全局变量：
输入参数说明： 
返回值说明： 返回内存分配器的句柄，失败返回NULL
===========================================================*/
API HANDLE OalMLibGet();

/*===========================================================
函数名： RsrcTagAlloc
功能： 分配资源标签，目前用于内存接口中，今后可用于信号量，线程等资源
算法实现：
引用全局变量： 未引用
输入参数说明：  s8 *pchName - 标签名
u32 dwNameLen - 标签名长度，不包括结尾符'\0', 最多为8
u32 *pdwRsrctag - 返回标签

返回值说明： 成功返回OAL_OK，失败返回错误码
===========================================================*/
API u32 RsrcTagAlloc(IN s8 *pchName, IN u32 dwNameLen, IN OUT u32 *pdwRsrctag);

/*===========================================================
函数名： rsrctag
功能： 显示分配资源标签，调试用
算法实现：
引用全局变量： 
输入参数说明：  u32 dwTelHd - telnet句柄
返回值说明：
===========================================================*/
API void rsrctag(IN void* dwTelHdl);

/*=================================================================
函 数 名: OalVerGet
功    能: 得到oal版本号
输入参数: pchVerBuf -- 输入缓冲，带回版本号
		  dwLen -- 输入缓冲长度
返回值:	  返回  pbyBuf	

说明:     
=================================================================*/
s8 *OalVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

/*=================================================================
函 数 名: CrcCal
功    能: 计算crc校验码
输入参数: crc -- 上次的校验码
		  buf -- 缓冲指针
		  len -- 缓冲长度
返回值:	  返回  pbyBuf	

说明:     
=================================================================*/
u32 CrcCal(IN u32 crc, IN const u8 *buf, IN u32 len);

/*=================================================================
函 数 名: OalHealthCheck
功    能: 检查oal是否健康
输入参数: 
dwLen -- 输入缓冲长度
返回值:	  返回  pbyBuf	

说明:  健康, OAL_OK; 健康, 错误码
=================================================================*/
u32 OalHealthCheck(void);

/*====================================================================
函数名：OalTaskCreate
功能：创建并激活一个任务
算法实现：（可选项）
引用全局变量：
输入参数说明：pfTaskEntry: 任务入口，
szName: 任务名，以NULL结束的字符串，
uPriority: 任务优先级别，
uStacksize: 任务堆栈大小，
uParam: 任务参数。
wFlag: 创建标志， 若要创建任务时，将任务先挂起，用 CREATETASK_SUSPEND。否则填0。
puTaskID: 返回参数，任务ID.

  返回值说明：成功返回任务的句柄，失败返回NULL.
====================================================================*/
API TASKHANDLE OalTaskCreate(void *pfTaskEntry, char *szName, u8 byPriority, u32 dwStacksize, 
							 void* dwParam,  u16 wFlag,  u32 *pdwTaskID);

/*====================================================================
 函数名：OalTaskExit
 功能：退出调用任务，任务退出之前用户要注意释放本任务申请的内存、信号量等资源。
 封装Windows的ExitThread(0)
 算法实现：（可选项）
 引用全局变量：
 输入参数说明：
 
返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API BOOL OalTaskExit(void);

/*====================================================================
函数名：OalTaskHBChkItvlSet
功能：任务心跳检测间隔设置(在OalTaskCreate后调用)
算法实现：（可选项）
引用全局变量：
输入参数说明：	dwTaskId - 任务编号, 由OalTaskCreate返回
				dwItvlMs - 检测心跳的间隔(ms)
				pdwTaskHBHdl -- 返回心跳句柄
返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API BOOL OalTaskHBChkItvlSet(u32 dwTaskId, u32 dwItvlMs);

/*====================================================================
函数名：OalTaskHBHdlGet
功能：任务心跳
算法实现：（可选项）
引用全局变量：
输入参数说明：pdwTaskHBHdl - 返回心跳句柄
返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API BOOL OalTaskHBHdlGet(void** pdwTaskHBHdl);

/*====================================================================
函数名：OalTaskHeartBeat
功能：任务心跳
算法实现：（可选项）
引用全局变量：
输入参数说明：dwTaskHBHdl - 心跳句柄
返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API BOOL OalTaskHeartBeat(void* dwTaskHBHdl);

/*====================================================================
 函数名：OalTaskSuspend
 功能：任务挂起
 算法实现：
 引用全局变量：
 输入参数说明：hTask: 任务句柄
 
返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API BOOL OalTaskSuspend(TASKHANDLE hTask);

/*====================================================================
 函数名：OalTaskResume
 功能：任务继续
  算法实现：
 引用全局变量：
 输入参数说明：hTask: 任务句柄
 
返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API BOOL OalTaskResume(TASKHANDLE hTask);


/*====================================================================
函数名：OalTaskSetPriority
功能：改变任务的优先级。

  算法实现：（可选项）
  引用全局变量：
  输入参数说明：hTask: 目标任务的句柄,
  uPriority: 要设置的优先级.
  
返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API BOOL OalTaskSetPriority(TASKHANDLE hTask, u8 byPriority);

/*====================================================================
函数名：OalTaskGetPriority
功能：获得任务的优先级。

  算法实现：（可选项）
  引用全局变量：
  输入参数说明：hTask: 目标任务的句柄,
  puPri: 返回参数, 成功返回任务的优先级.
  返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API BOOL OalTaskGetPriority(TASKHANDLE hTask, u8* pbyPri);


/*====================================================================
函数名：OalTaskDelay
功能：任务延时
算法实现：
引用全局变量：
输入参数说明：dwDelayMs: 延时时间（ms）
返回值说明：成功返回TRUE, 失败返回FALSE.
====================================================================*/
API void OalTaskDelay(u32 dwDelayMs);

/*====================================================================
函数名：OalTaskSelfHandle
功能：获得调用任务的句柄
算法实现：（可选项）
引用全局变量：
输入参数说明：不建议使用
返回值说明：
====================================================================*/
//API TASKHANDLE OalTaskSelfHandle(void);

/*====================================================================
函数名：OalTaskSelfID
功能：获得调用任务的ID
算法实现：（可选项）
引用全局变量：
输入参数说明：

  返回值说明：调用任务的ID.
====================================================================*/
API u32 OalTaskSelfID(void);

/*====================================================================
函数名：OalTaskHandleClose
功能：释放句柄
算法实现：（可选项）
引用全局变量：
输入参数说明：TASKHANDLE hTask 任务句柄
  返回值说明：成功返回真,否则假.
====================================================================*/
API BOOL OalTaskHandleClose(TASKHANDLE hTask);

/*====================================================================
函数名：OalTaskWait
功能：等待任务完成
算法实现：（可选项）
引用全局变量：
输入参数说明：TASKHANDLE hTask 任务句柄
  返回值说明：等待成功返回真,否则假.
====================================================================*/
API BOOL OalTaskWait(TASKHANDLE hTask);


/*====================================================================
函数名：taskdump
功能：打印现有的任务信息
算法实现：（可选项）
引用全局变量：
输入参数说明：dwTelHdl -- telnet句柄
返回值说明：
====================================================================*/
API void taskdump(IN void* dwTelHdl);

/*====================================================================
函数名：stackdump
功能：得到指定进程号(由taskdump得到)的堆栈信息
算法实现：发送 SIGSEGV 给指定进程，得到堆栈信息文件。
引用全局变量：
输入参数说明：dwTelHdl -- telnet句柄
返回值说明：可能会导致当前进程挂掉，慎用该接口 !!!
====================================================================*/
API void stackdump(IN void* dwTelHdl, IN u32 dwPID);

/*====================================================================
函数名：OalSemDump
功能：将所有没有give的信号量的信息输出
算法实现：（可选项）
引用全局变量：
输入参数说明：u32 dwTelHdl - telnet服务器句柄
  返回值说明：无.
====================================================================*/
API void OalSemDump(void* dwTelHdl);

/*====================================================================
函数名：InnerOalSemTake
功能：信号量p操作(外界不调用此函数，调用OalSemTake)
算法实现：（可选项）
引用全局变量：
输入参数说明：hSem: 信号量句柄
s8 strSemName[]:信号量名
s8 strFileName[]:调用所在的文件名
u32 dwLine:调用所在的行
返回值说明：成功返回OALSEM_SIGNALED，否则返回OALSEM_TIMEOUT或者OALSEM_FAILED
====================================================================*/
API u32  InnerOalSemTake(SEMHANDLE hSem,s8 strSemName[],s8 strFileName[],u32 dwLine);


/*====================================================================
函数名：InnerOalSemTakeByTime
功能：带超时的信号量p操作(外界不调用此函数，调用OalSemTakeByTime)
算法实现：（可选项）
引用全局变量：
输入参数说明：hSem: 信号量句柄
dwTimeout: 超时时间（ms）,精度为10ms
s8 strSemName[]:信号量名
s8 strFileName[]:调用所在的文件名
u32 dwLine:调用所在的行
返回值说明：成功返回OALSEM_SIGNALED，否则返回OALSEM_TIMEOUT或者OALSEM_FAILED
====================================================================*/
API u32  InnerOalSemTakeByTime(SEMHANDLE hSem, u32 dwTimeout,s8 strSemName[],s8 strFileName[],u32 dwLine);

/*================================================================ 
Sem相关接口删除，改为SlowBadSem
=================================================================*/
#if 0
/*====================================================================
函数名：OalSemBCreate
功能：创建一个二元信号量
算法实现：
引用全局变量：
输入参数说明：phSem: 返回的信号量句柄
返回值说明：成功返回TRUE，失败返回FALSE
====================================================================*/
API BOOL OalSemBCreate(SEMHANDLE *phSem);

/*====================================================================
函数名：OalSemCCreate
功能：创建计数信号量
算法实现：
引用全局变量：
输入参数说明：phSem: 信号量句柄返回参数， 
			  dwInitCount: 初始计数，
			  dwMaxCount: 最大计数
返回值说明：成功返回TRUE，失败返回FALSE.
====================================================================*/
API BOOL OalSemCCreate(SEMHANDLE *phSem, u32 dwInitCount, u32 dwMaxCount);


/*====================================================================
函数名：OalSemDelete
功能：删除信号量
算法实现：（可选项）
引用全局变量：
输入参数说明：hSem: 待删除信号量的句柄
返回值说明：成功返回TRUE，失败返回FALSE.
====================================================================*/
API BOOL OalSemDelete(SEMHANDLE hSem);

#define OalSemTake(hSem) InnerOalSemTake(hSem,#hSem,__FILE__,__LINE__)

#define OalSemTakeByTime(hSem,dwTimeout) InnerOalSemTakeByTime(hSem,dwTimeout,#hSem,__FILE__,__LINE__)


/*====================================================================
函数名：OalSemGive
功能：信号量v操作
算法实现：（可选项）
引用全局变量：
输入参数说明：hSem: 信号量句柄
返回值说明：成功返回TRUE，失败返回FALSE.
====================================================================*/
API BOOL OalSemGive(SEMHANDLE hSem);

#endif


/*================================================================ 
慢速的信号量，如果仅是互斥，采用LightLock。同步时可使用sem 
=================================================================*/

/*====================================================================
函数名：OalSlowBadSemBCreate
功能：创建一个二元信号量
算法实现：
引用全局变量：
输入参数说明：phSem: 返回的信号量句柄
返回值说明：成功返回TRUE，失败返回FALSE
====================================================================*/
API BOOL OalSlowBadSemBCreate(SEMHANDLE *phSem);

/*====================================================================
函数名：OalSlowBadSemCCreate
功能：创建计数信号量
算法实现：
引用全局变量：
输入参数说明：phSem: 信号量句柄返回参数， 
dwInitCount: 初始计数，
dwMaxCount: 最大计数
返回值说明：成功返回TRUE，失败返回FALSE.
====================================================================*/
API BOOL OalSlowBadSemCCreate(SEMHANDLE *phSem, u32 dwInitCount, u32 dwMaxCount);


/*====================================================================
函数名：OalSlowBadSemDelete
功能：删除信号量
算法实现：（可选项）
引用全局变量：
输入参数说明：phSem: 待删除信号量的句柄
返回值说明：成功返回TRUE，失败返回FALSE.
====================================================================*/
API BOOL OalSlowBadSemDelete(SEMHANDLE phSem);

#define OalSlowBadSemTake(phSem) InnerOalSemTake(phSem,#phSem,__FILE__,__LINE__)

#define OalSlowBadSemTakeByTime(phSem,dwTimeout) InnerOalSemTakeByTime(phSem,dwTimeout,#phSem,__FILE__,__LINE__)


/*====================================================================
函数名：OalSlowBadSemGive
功能：信号量v操作
算法实现：（可选项）
引用全局变量：
输入参数说明：hSlowBadSem: 信号量句柄
返回值说明：成功返回TRUE，失败返回FALSE.
====================================================================*/
API BOOL OalSlowBadSemGive(SEMHANDLE hSlowBadSem);







/*====================================================================
函数名：OalTakedSemNumGet
功能：得到被take的信号量总数，测试用，用户不要调用 !!!!!!
算法实现：（可选项）
引用全局变量：
输入参数说明：
返回值说明：被take的信号量总数
注： 该接口是为了测试信号量监控是否有效，用户不要调用 !!!!!!
====================================================================*/
API u32 OalTakedSemNumGet(void);


/*====================================================================
函数名：semdump
功能：将所有没有give的二进制信号量的信息输出
算法实现：
引用全局变量：
输入参数说明：u32 dwTelHdl - telnet服务器句柄
返回值说明：无.
注：信号量调试接口,用户不要调用
====================================================================*/
API void semdump(void* dwTelHdl);

/*====================================================================
函数名：semdumpall
功能：将所有信号量的信息输出
算法实现：
引用全局变量：
输入参数说明：u32 dwTelHdl - telnet服务器句柄
返回值说明：无.
注：信号量调试接口,用户不要调用
====================================================================*/
API void semdumpall(void* dwTelHdl);

/*====================================================================
函数名：semmsreg
功能：信号量监控是否记录时间
算法实现：
引用全局变量：
输入参数说明：u32 dwTelHdl - telnet服务器句柄
			  BOOL bReg	- 是否记录
返回值说明：无.
注：信号量调试接口,用户不要调用
====================================================================*/
API void semmsreg(void*  dwTelHdl, BOOL bReg);


/*====================== 轻量级锁 ======================*/

typedef void* TLightLock;

/*===========================================================
函数名： LightLockCreate
功能：创建轻量级锁
算法实现：
引用全局变量： 未引用
输入参数说明： TLightLock *ptLightLock － 锁指针                   
返回值说明： 
===========================================================*/
BOOL LightLockCreate(TLightLock *ptLightLock);

/*===========================================================
函数名： LightLockDelete
功能：删除轻量级锁
算法实现：		
引用全局变量： 未引用
输入参数说明： TLightLock *ptLightLock － 锁指针                   
返回值说明： 
===========================================================*/
BOOL LightLockDelete(TLightLock *ptLightLock);


/*===========================================================
函数名： InnerLightLockLock
功能：锁轻量级锁
算法实现：
引用全局变量： 未引用
输入参数说明：	TLightLock *ptLightLock － 锁指针
				s8 strLockName[]:锁名
				s8 strFileName[]:调用所在的文件名
				u32 dwLine:调用所在的行
返回值说明： 
===========================================================*/
BOOL InnerLightLockLock(TLightLock *ptLightLock, s8 strLockName[], s8 strFileName[], u32 dwLine);

#define LightLockLock(ptLightLock) InnerLightLockLock(ptLightLock, #ptLightLock, __FILE__, __LINE__)

/*===========================================================
函数名： LightLockUnLock
功能：解锁轻量级锁
算法实现：		
引用全局变量： 未引用
输入参数说明： TLightLock *ptLightLock － 锁指针                   
返回值说明： 
===========================================================*/
BOOL LightLockUnLock(TLightLock *ptLightLock);

/*=================================================================
函 数 名: ShMemInit
功    能: 共享内存初始化
输入参数:	pchName - 名字(对于linux, 实际是一个u32的key，这样传参数 (s8 *)key )
			dwBytes - 大小
			bFailOnExist - 当共享内存存在时，是否返回NULL
			pdwShareAreaId - 返回共享区句柄, 用于ShMemClean时传入参数
			pbExist - 返回共享内存是否已存在

返回值说明：成功，返回指针；失败返回NULL
=================================================================*/
void *ShMemInit(IN s8 *pchName, IN u32 dwBytes, IN BOOL bFailOnExist, OUT u32 *pdwShareAreaId, OUT BOOL *pbExist);


/*=================================================================
函 数 名: ShMemGet
功    能: 得到共享内存
输入参数:	pchName - 名字(对于linux, 需指定一个存在的路径，如 "/")
			dwBytes - 大小(注意不能大于ShMemInit中的尺寸 !!! 最好保持一致)
			pdwShareAreaId - 返回共享区句柄, 用于ShMemClean时传入参数
返回值说明：成功，返回指针；失败返回NULL
=================================================================*/
void *ShMemGet(IN s8 *pchName, IN u32 dwBytes, OUT u32 *pdwShareAreaId);


/*=================================================================
函 数 名: ShMemClean
功    能: 共享内存清除
输入参数:	pShmem - 共享内存指针(由ShMemInit或ShMemGet返回)
			dwShareAreaId - 共享区句柄
返回值说明：
=================================================================*/
BOOL ShMemClean(IN void *pShmem, IN u32 dwShareAreaId);


/*======================== 进程创建，退出 =========================*/
/*=============================================================================
函数名:  OalCreateProcess
功能  : 起动一个进程
参数  : char *pchCmdline:命令行, 可带参数，参数间用一个空格分隔
char *pchWorkdir:工作目录(仅对windows有用，对需要指定初始磁盘及工作路径的程序有用。一般填NULL即可)
u32 *pdwProccessId:返回的进程ID
返回值: 成功, 返回TRUE；失败，返回FALSE 
=============================================================================*/
BOOL  OalCreateProcess(IN char *pchCmdline, IN char *pchWorkdir, IN u32 *pdwProccessId);

/*=============================================================================
函数名: OalCloseProcess
功能  : 由进程ID关闭进程
参数  : u32 dwProcessId
返回值: BOOL  
=============================================================================*/
BOOL  OalCloseProcess(u32 dwProcessId);


/*=============================================================================
函数名: OalKillProcess
功能  : 强制杀进程（kill -9)
参数  : u32 dwProcessId
返回值: BOOL  

=============================================================================*/
BOOL  OalKillProcess(u32 dwProcessId);

/*=============================================================================
函数名: OalIsProcessExist
功能  : 判断进程是否存在
参数  : u32 dwProcessId
返回值: 存在, TRUE; 不存在, FALSE  
注：win32上空实现，返回TRUE
=============================================================================*/
BOOL  OalIsProcessExist(u32 dwProcessId);

/*====================================================================
函数名：OalSockInit
功能：套接口库初始化。封装windows的WSAStartup
算法实现：
引用全局变量：
输入参数说明：
返回值说明：成功返回TRUE，失败返回FALSE
 ====================================================================*/
 API BOOL OalSockInit(void);


 /*====================================================================
 函数名：OalSockCleanup
 功能：套接口库退出，封装windows的WSACleanup
 算法实现：
 引用全局变量：
 输入参数说明：
 返回值说明：成功返回TRUE，失败返回FALSE
 ====================================================================*/
 API BOOL OalSockExit(void);

 /*====================================================================
 函数名：OalSockClose
 功能：关闭套接字
 算法实现：
 引用全局变量：
 输入参数说明：
 返回值说明：成功返回TRUE，失败返回FALSE
 ====================================================================*/
 API BOOL OalSockClose(SOCKHANDLE hSock);

 /*====================================================================
 函数名：OalSockSend
 功能：向socket发送消息
 算法实现：（可选项）
 引用全局变量：
 输入参数说明：tSock -- 套接字
			   pchBuf -- 要发送的缓冲
			   dwLen -- 缓冲大小
			   nFlag -- 发送标志	
			   返回值说明：成功返回FSMP_OK, 失败返回错误码
 ====================================================================*/
API s32 OalSockSend(SOCKHANDLE tSock, s8 *pchBuf, u32 dwLen, s32 nFlag);


 /*====================================================================
 函数名：OalSockRecv
 功能：从socket接收消息
 算法实现：（可选项）
 引用全局变量：
 输入参数说明：tSock-- 套接字
			   pchBuf -- 接受数据的缓冲
			   dwLen -- 缓冲大小
			   pdwErrNo -- 错误码 
 返回值说明：返回接受到的字节数
 ====================================================================*/
API s32 OalSockRecv(SOCKHANDLE tSock,  s8 *pchBuf, u32 dwLen, u32 *pdwErrNo);


/*====================================================================
函数名：OalU64TickGet
功能：取得当前的系统tick数
算法实现
引用全局变量：
输入参数说明：pqwTick － tick指针
返回值说明：
====================================================================*/
API void OalU64TickGet(u64 *pqwTick);

/*====================================================================
函数名：OalClkRateGet
功能：得到tick精度
算法实现：（可选项）
引用全局变量：
输入参数说明：
返回值说明：tick精度
====================================================================*/
API u32 OalTickRateGet(void);

/*====================================================================
函数名：OalGetU64Ms
功能：得到自系统运行后经过的毫秒数
算法实现：（可选项）
引用全局变量：
输入参数说明：pqwMs - ms 指针
返回值说明：
====================================================================*/
API void OalGetU64Ms(u64 *pqwMs);


/*====================================================================
函数名：oalver
功能：得到oal版本信息
算法实现：（可选项）
引用全局变量：
输入参数说明：
返回值说明：
====================================================================*/
API void oalver(void*  dwTelHdl);




/*=============================================== 双向链表 ================================================*/



typedef struct tagENode
{
	u32 dwUseMagic;//判断节点是否已存在于某个数据结构中，防止节点被多次使用
	struct tagENode *pPre;//前驱指针
	struct tagENode *pSuc;//后继指针
}ENode;



//根据成员得到宿主结构的宏
/*============================================================================
ptr - 成员指针
type - 宿主结构类型
member - 宿主结构中 ptr 成员的名称

用法参考下面：

typedef struct tagMyInfo
{
	ENode m_tENode;
	u32 m_dwMyData;
}TMyInfo;

TMyInfo *ptMyInfo = NULL;
ENode *ptNode = EListGetFirst(ptList);

ptMyInfo = HOST_ENTRY(ptNode, TMyInfo, m_tENode);

============================================================================*/
#define HOST_ENTRY(ptr, type, member) ((type *)((u8 *)(ptr) - (u32)(&((type *)0)->member)))


/*===========================================================
函数名： BDSGetLastError
功能： 得到错误码。
算法实现：
引用全局变量： 未引用
输入参数说明： 
            
返回值说明： 无
===========================================================*/
API u32 BDSGetLastError(void);

/*===========================================================
函数名： BDSSetLastError
功能： 设置错误码。
算法实现：
引用全局变量： 未引用
输入参数说明： 
            
返回值说明： 无
===========================================================*/
API void BDSSetLastError(u32 dwErrCode);


/*双向链表*/
typedef struct tagEList
{
	
	u32  dwLength;//sizeof(tagEList)
	ENode tFirst;//表头节点（不存数据）
	ENode tLast;//表尾节点（不存数据）
	u32 dwSize;//当前节点个数
	
}EList;



/*===========================================================
函数名： EListInit
功能： 初始化链表
算法实现： 1、全部置零
		2、将表头，表尾链起来
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
            
返回值说明： 无
===========================================================*/
API void EListInit(IN EList *pList);



/*===========================================================
函数名： EListInsert
功能： 在参考节点之后插入节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
			   ENode *pRefNode 参考节点的指针
			   ENode *pNode 待插入节点的指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EListInsert(IN EList *pList,IN OUT ENode *pRefNode,
					   IN OUT ENode *pNode);




/*===========================================================
函数名： EListInsertFirst
功能： 在链表起始处插入节点,使之成为第一个节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
			   ENode *pNode 待插入节点的指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EListInsertFirst(IN EList *pList,IN OUT ENode *pNode);

/*===========================================================
函数名： EListRemoveFirst
功能： 删除链表的第一个数据节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EListRemoveFirst(IN EList *pList);

/*===========================================================
函数名： EListGetFirst
功能： 得到链表的第一个数据节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
            
返回值说明： 成功则返回第一个数据节点的指针，否则NULL
===========================================================*/
API ENode* EListGetFirst(IN EList *pList);


/*===========================================================
函数名： EListInsertLast
功能： 在链表结束前插入节点,使之成为最后一个数据节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
			   ENode *pNode 待插入节点的指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EListInsertLast(IN EList *pList,IN OUT ENode *pNode);

/*===========================================================
函数名： EListRemoveLast
功能： 删除链表的最后一个数据节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EListRemoveLast(IN EList *pList);

/*===========================================================
函数名： EListGetLast
功能： 得到链表的最后一个数据节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
            
返回值说明： 成功则返回最后一个数据节点的指针，否则NULL
===========================================================*/
API ENode* EListGetLast(IN EList *pList);


/*===========================================================
函数名： EListRemove
功能： 使链表某个节点脱链
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
			   ENode *pNode 待脱链节点的指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EListRemove(IN EList *pList,IN OUT ENode *pNode);



/*===========================================================
函数名： EListClear
功能： 删除链表起始处至结束处的节点（全部断链，并将链表恢复到初始化后的状态）
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
           
返回值说明： 无
===========================================================*/
API void EListClear(IN EList *pList);


/*===========================================================
函数名： EListNext
功能： 得到下一个节点的指针
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
			   ENode *pRefNode 参考节点
返回值说明： 返回下一节点的指针，若失败返回NULL
===========================================================*/
API ENode* EListNext(IN EList *pList,IN ENode *pRefNode);


/*===========================================================
函数名： EListPre
功能： 得到前一个节点的指针
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
			   ENode *pRefNode 参考节点
返回值说明： 返回前一节点的指针，若失败返回NULL
===========================================================*/
API ENode* EListPre(IN EList *pList,IN ENode *pRefNode);




/*===========================================================
函数名： EListIsEmpty
功能： 判断链表是否为空
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
            
返回值说明： 链表为空返回真,否则返回假
===========================================================*/
API BOOL EListIsEmpty(IN EList *pList);

/*===========================================================
函数名： EListSize
功能： 得链表节点个数
算法实现： 
引用全局变量： 未引用
输入参数说明： EList *pList 链表指针
            
返回值说明： 返回节点个数
===========================================================*/
API u32 EListSize(IN EList *pList);


/*=============================================== 栈 ================================================*/

/*栈*/
typedef struct tagEStack
{

	u32  dwLength;//sizeof(tagEStack)
	ENode tTop;//栈顶节点(不存数据)
	u32 dwSize;//当前节点个数

}EStack;


/*===========================================================
函数名： EStackInit
功能： 初始化栈。
算法实现：
引用全局变量： 未引用
输入参数说明： EStack *pStack 栈指针
            
返回值说明： 无
===========================================================*/
API void EStackInit(IN EStack *pStack);

/*===========================================================
函数名： EStackTop
功能： 得到栈顶节点
算法实现：
引用全局变量： 未引用
输入参数说明： EStack *pStack 栈指针
返回值说明： 成功则返回栈顶节点的指针，否则NULL
===========================================================*/
API ENode* EStackTop(IN EStack *pStack);


/*===========================================================
函数名： EStackPush
功能： 栈顶加入节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EStack *pStack 栈指针
			   ENode *pNode 待插入的数据
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EStackPush(IN EStack *pStack,IN OUT ENode *pNode);

/*===========================================================
函数名： EStackPop
功能： 删除栈顶元素
算法实现： 
引用全局变量： 未引用
输入参数说明： EStack *pStack 栈指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EStackPop(IN EStack *pStack);

/*===========================================================
函数名： EStackSize
功能： 得栈节点个数
算法实现： 
引用全局变量： 未引用
输入参数说明： EStack *pStack 栈指针
            
返回值说明： 返回节点个数
===========================================================*/
API u32 EStackSize(IN EStack *pStack);

/*===========================================================
函数名： EStackIsEmpty
功能： 判断栈是否为空
算法实现： 
引用全局变量： 未引用
输入参数说明： EStack *pStack 栈指针
            
返回值说明： 为空返回真，否则假
===========================================================*/
API BOOL EStackIsEmpty(IN EStack *pStack);


/*=============================================== 队列 ================================================*/

/*队列*/
typedef struct tagEQueue
{

	u32  dwLength;//sizeof(tagEQueue)
	ENode tTop;//队列顶节点（不存数据）
	ENode tBottom;//队列尾节点（不存数据）
	u32 dwSize;//当前节点个数

}EQueue;


/*===========================================================
函数名： EQueueInit
功能： 初始化队列
算法实现：
引用全局变量： 未引用
输入参数说明： EQueue *pQueue 队列指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API void EQueueInit(IN EQueue *pQueue);


/*===========================================================
函数名： EQueueTop
功能： 得到队列顶节点的指针
算法实现：
引用全局变量： 未引用
输入参数说明： EQueue *pQueue 队列指针
返回值说明： 成功则返回队列顶节点的指针，否则NULL
===========================================================*/
API ENode* EQueueTop(IN EQueue *pQueue);

/*===========================================================
函数名： EQueuePush
功能： 队列尾加入节点
算法实现： 
引用全局变量： 未引用
输入参数说明： EQueue *pQueue 队列指针
			   ENode *pNode 待插入的数据
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EQueuePush(IN EQueue *pQueue,IN OUT ENode *pNode);

/*===========================================================
函数名： EQueuePop
功能： 弹出队列顶元素
算法实现： 
引用全局变量： 未引用
输入参数说明： EQueue *pQueue 队列指针
            
返回值说明： 成功则返回真，否则假
===========================================================*/
API BOOL EQueuePop(IN EQueue *pQueue);

/*===========================================================
函数名： EQueueSize
功能： 得队列节点个数
算法实现： 
引用全局变量： 未引用
输入参数说明： EQueue *pQueue 队列指针
            
返回值说明： 返回节点个数
===========================================================*/
API u32 EQueueSize(IN EQueue *pQueue);

/*===========================================================
函数名： EQueueIsEmpty
功能： 判断队列是否为空
算法实现： 
引用全局变量： 未引用
输入参数说明： EQueue *pQueue 队列指针
            
返回值说明： 为空返回真，否则假
===========================================================*/
API BOOL EQueueIsEmpty(IN EQueue *pQueue);

/************************************************************************/
/*                            zr newadd 2012-01-18                      */
/************************************************************************/

//实现固定元素大小内存池

//创建内存池
API HANDLE BufPollCreate(IN HANDLE hMem, IN u32 dwMemTag, IN u32 dwEleCnt, IN u32 dwEleSize, IN TLightLock *ptLock);

//销毁内存池
API void BufPollDestroy(IN HANDLE hBufPool);

//内存申请,失败返回NULL
API void* BufPollMalloc(IN HANDLE hBufPool);

//内存释放
API void BufPollMFree(IN HANDLE hBufPool, IN void *pMem);

//环形Buf

//创建环形Buf
API HANDLE RingBufCreate(IN HANDLE hOalMem, IN u32 dwMemTag, IN u32 dwBufSize);

//删除环形Buf
API void RingBufDelete(IN HANDLE hRingBuf);

//重置环形Buf
API void RingBufReset(IN HANDLE hRingBuf);

//获取Buf使用大小
API u32 RingBufUsedSizeGet(IN HANDLE hRingBuf);

//获取Buf空闲大小
API u32 RingBufFreeSizeGet(IN HANDLE hRingBuf);

//放入数据,返回实际放入大小
API u32 RingBufDataPut(IN HANDLE hRingBuf, IN u8 *pData, IN u32 dwDataLen);

//取数据,dwReadLen欲读取长度,返回实际读取大小
API u32 RingBufDataGet(IN HANDLE hRingBuf, IN u8 *pBuf, IN u32 dwReadLen);

/*=============================================== 时间函数 ================================================*/

#define TIMESTR_BUFLEN		30 //存放时间字符串的缓冲大小

#define SECONDS_PERMIN		60
#define SECONDS_PERHOUR		(SECONDS_PERMIN*60)
#define SECONDS_PERDAY		(SECONDS_PERHOUR*24)
#define SECONDS_PERWEEK		(SECONDS_PERDAY*7)

#define TZ_LOCAL	100   //本地时区
#define TZ_GMT		0	  //格林威治时区，暂不支持
	

//日历时间
typedef struct tagCalTime {
	u32 m_dwSec;     /* 秒 – 取值区间为[0,59] */
	u32 m_dwMin;     /* 分 - 取值区间为[0,59] */
	u32 m_dwHour;    /* 时 - 取值区间为[0,23] */
	u32 m_dwMday;    /* 一个月中的日期 - 取值区间为[1,31] */
	u32 m_dwMon;     /* 月份（从一月开始，1代表一月） - 取值区间为[1,12] */
	u32 m_dwYear;    /* 实际年份 */
	u32 m_dwWday;    /* 星期 – 取值区间为[0,6]，其中0代表星期天，1代表星期一，以此类推 */
	u32 m_dwYday;    /* 从每年的1月1日开始的天数 – 取值区间为[0,365]，其中0代表1月1日，1代表1月2日，以此类推 */
	u32 m_dwIsdst;   /* 暂时无用，夏令时标识符，实行夏令时的时候，tm_isdst为正。不实行夏令时的进候，tm_isdst为0；不了解情况时，tm_isdst()为负。*/
}TCalTime;			//成员顺序和tm结构保持一致

//循环时间，主要供录像业务用
typedef struct tagCycTime
{
	u32 m_dwSec;     /* 秒 – 取值区间为[0,59] */
	u32 m_dwMin;     /* 分 - 取值区间为[0,59] */
	u32 m_dwHour;    /* 时 - 取值区间为[0,23] */
	u32 m_dwWday;    /* 星期 – 取值区间为[0,6]，其中0代表星期天，1代表星期一，以此类推 */
}TCycTime;


typedef u32 STIME;  //从1970年1月1日0时0分0秒 开始的毫秒数
typedef u64 MSTIME;  //从1970年1月1日0时0分0秒 开始的毫秒数


/*===========================================================
函数名： TimeZoneSet
功能： 设置时区
算法实现： 
引用全局变量： 
输入参数说明： 
返回值说明： byTimeZone -- 时区        (目前填 TZ_LOCAL 即可)
             bUseDst -- 是否实行夏令时 (目前填 FALSE)
注: 该函数会影响接口 CalTimeGet, CycTimeGet, STime2Str, STime2Day, STime2CalTime, STime2CycTime, 
	即对于日历中的 年月日时分秒 有影响。
    对于绝对秒数, 绝对毫秒数, 不影响
===========================================================*/
void TimeZoneSet(IN u8 byTimeZone, BOOL bUseDst);


/*===========================================================
函数名： STimeGet
功能： 得到绝对秒时间, 相对格林威治时间1970年1月1日0时0分0秒
算法实现： 
引用全局变量： 
输入参数说明： 
返回值说明： 秒时间
===========================================================*/
STIME STimeGet(void);


/*===========================================================
函数名： MSTimeGet
功能：得到绝对毫秒时间, 相对格林威治时间1970年1月1日0时0分0秒
算法实现： 
引用全局变量： 
输入参数说明： ptMsTime - ms 指针
返回值说明： 
===========================================================*/
void MSTimeGet(IN OUT MSTIME *ptMsTime);

/*===========================================================
函数名： CalTimeGet
功能： 得到日历时间
算法实现： 
引用全局变量： 
输入参数说明： ptCalTime -- 日历时间指针

返回值说明：失败，返回NULL；成功，指向日历时间，即传入的参数			
===========================================================*/
TCalTime * CalTimeGet(IN OUT TCalTime *ptCalTime);


/*===========================================================
函数名： CycTimeGet
功能： 得到循环时间
算法实现： 
引用全局变量： 
输入参数说明： ptCycTime -- 循环时间指针

返回值说明：失败，返回NULL。成功，指向循环时间，即传入的参数			
===========================================================*/
TCycTime * CycTimeGet(IN OUT TCycTime *ptCycTime);

/*===========================================================
函数名： CalTime2Str
功能： 日历时间转到字符串，例如："Sun Sep 16 01:03:52 1973\n\0"
算法实现： 
引用全局变量： 
输入参数说明： ptCalTime -- 日历时间指针
			   pTimeStr -- 字符串指针
			   dwBufLen -- 输入缓冲长度，用户给的缓冲大小为 TIMESTR_BUFLEN 即可

返回值说明：失败，返回NULL。成功，指向字符串，即传入的字符串指针			
===========================================================*/
s8* CalTime2Str(IN TCalTime *ptCalTime, OUT s8 *pTimeStr, IN u32 dwBufLen);

/*===========================================================
函数名： STime2Str
功能： 秒时间转到字符串，例如："Sun Sep 16 01:03:52 1973\n\0"
算法实现： 
引用全局变量： 
输入参数说明： tSTime -- 秒时间
			   pTimeStr -- 字符串指针
			   dwBufLen -- 输入缓冲长度，用户给的缓冲大小为 TIMESTR_BUFLEN 即可

返回值说明：失败，返回NULL。成功，指向字符串，即传入的字符串指针			
===========================================================*/
s8* STime2Str(STIME tSTime, OUT s8 *pTimeStr, IN u32 dwBufLen);

/*===========================================================
函数名： MSTime2STime
功能： 毫秒时间转到秒时间
算法实现： 
引用全局变量： 
输入参数说明： tMsTime -- 毫秒时间
			   
返回值说明：秒时间		
===========================================================*/
STIME MSTime2STime(IN MSTIME tMsTime);

/*===========================================================
函数名： STime2MSTime
功能： 秒时间转到毫秒时间
算法实现： 
引用全局变量： 
输入参数说明： tSTime -- 秒时间
				ptMsTime -- 毫秒时间指针
			   
返回值说明：		
===========================================================*/
void STime2MSTime(IN STIME tSTime, IN OUT MSTIME *ptMsTime);

/*===========================================================
函数名： STime2Day
功能： 秒时间转到天，1970年1月1日0时0分0秒 开始的绝对天数
算法实现： 
引用全局变量： 
输入参数说明： tSTime -- 秒时间

返回值说明：天		
===========================================================*/
u32 STime2Day(IN STIME tSTime);

/*===========================================================
函数名： Day2STime
功能：天转到秒时间
算法实现： 
引用全局变量： 
输入参数说明： dwDay -- 天

返回值说明：秒时间		
===========================================================*/
STIME Day2STime(IN u32 dwDay);

/*===========================================================
函数名：CalTime2STime
功能：日历时间转到秒时间
算法实现： 
引用全局变量： 
输入参数说明： ptCalTime -- 日历时间指针

返回值说明：秒时间		
===========================================================*/
STIME CalTime2STime(IN TCalTime *ptCalTime);

/*===========================================================
函数名：STime2CalTime
功能：秒时间转到日历时间
算法实现： 
引用全局变量： 
输入参数说明： tSTime -- 秒时间
			   ptCalTime -- 日历时间指针	

返回值说明：失败，返回NULL。成功，指向日历时间，即传入的指针		
===========================================================*/
TCalTime* STime2CalTime(IN STIME tSTime, OUT TCalTime *ptCalTime);

/*===========================================================
函数名：CycTime2STime
功能：循环时间转到秒时间
算法实现： 
引用全局变量： 
输入参数说明： ptCycTime --  循环时间指针

返回值说明：秒时间		
===========================================================*/
STIME CycTime2STime(IN TCycTime *ptCycTime);

/*===========================================================
函数名：STime2CycTime
功能：秒时间转到日历时间
算法实现： 
引用全局变量： 
输入参数说明： tSTime -- 秒时间
			   ptCycTime -- 循环时间指针	

返回值说明：失败，返回NULL。成功，指向循环时间，即传入的指针		
===========================================================*/
TCycTime* STime2CycTime(IN STIME tSTime, OUT TCycTime *ptCycTime);

/*===========================================================
函数名：STimeIsCycle
功能：秒时间是否在循环时间内
算法实现： 
引用全局变量： 
输入参数说明： tSTime -- 秒时间
			

返回值说明：在循环时间内，TRUE；否则，FALSE		
===========================================================*/
BOOL STimeIsCycle(IN STIME tSTime);

/*===========================================================
函数名：SysTimeSetS
功能：设置系统时间，精度秒
算法实现： 
引用全局变量： 
输入参数说明： tSTime -- 秒时间
			

返回值说明：成功，TRUE；失败，FALSE	
===========================================================*/
BOOL SysTimeSetS(IN STIME tSTime);

/*===========================================================
函数名：SysTimeSetMS
功能：设置系统时间，精度毫秒
算法实现： 
引用全局变量： 
输入参数说明： tMSTime -- 毫秒时间
			

返回值说明：成功，TRUE；失败，FALSE		
===========================================================*/
BOOL SysTimeSetMS(IN MSTIME tMSTime);


/*===========================================================
函数名：CalDayOfMonth
功能：计算某个月的天数
算法实现： 
引用全局变量： 
输入参数说明：
返回值说明：成功，TRUE；失败，FALSE		
===========================================================*/
u32 CalDayOfMonth( u32 nYear, u32 nMonth );


/*====================================== telnet 服务器 =========================================*/
/*===========================================================
函数名：TelnetSvrInit
功能：初始化telnet服务器
算法实现： 
引用全局变量： 
输入参数说明： 	wStartPort -- telnet服务端口，如果该端口被占用，再递增尝试1000个端口
				pdwTelHdl -- telnet服务器句柄		

返回值说明：成功，TRUE; 失败，FALSE		
说明：实际使用时，只创建一个实例，由oal创建，上层通过OalTeltHdlGet得到句柄。
	  上层不需在调用TelnetSvrInit(), 减少进程数
===========================================================*/
BOOL TelnetSvrInit(IN u16 wStartPort, OUT void** pdwTelHdl); 

/*===========================================================
函数名：TelnetSvrExit
功能：退出telnet服务器
算法实现： 
引用全局变量： 
输入参数说明： 	dwTelHdl -- telnet服务器句柄		

返回值说明：成功，TRUE; 失败，FALSE		
===========================================================*/
BOOL TelnetSvrExit(IN void* dwTelHdl); 

/*===========================================================
函数名：CmdReg
功能：向telnet服务器注册调试接口
算法实现：      一个telnet服务器最多可注册100个命令
引用全局变量： 
输入参数说明：	dwTelHdl -- telnet服务器句柄	
				strName -- 接口名称，可以为 NULL, 最大长度为20
				pFunc -- 接口指针
				strUsage -- 接口用途，可以为 NULL，最大长度为80

返回值说明：成功，TRUE; 失败，FALSE		
===========================================================*/
BOOL CmdReg(IN void* dwTelHdl, IN const s8* strName, IN void* pFunc, IN const s8* strUsage);


//telnet服务器统计信息
void telnetstatis(IN void* dwTelHdl);

#define PRTGNL_NAME	"pgnl" //通用的打印名字
#define PRTGNL_OCC	STR2OCC(PRTGNL_NAME) //通用的的打印名字OCC值，可用于xxxprtname的打印

#define ACUPRT_NAME_MAXNUM		512			//一个telnet服务器最多的打印名称
/*====================================================================
函数名：AccuPrt
功能：精确打印, 开头加打印名称
算法实现：		如果有telnet客户端，打印到客户端; 否则打印到本地
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄
				tOccName － 名称
				format - 可变参数
			
返回值说明
====================================================================*/
void AccuPrt(IN void* dwTelHdl, IN OCC tOccName, IN const s8 *format, ...);


/*====================================================================
函数名：AccuPrtTableClear
功能：清除精确打印的名字
算法实现：	
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄
返回值说明
====================================================================*/
BOOL AccuPrtTableClear(IN void* dwTelHdl); 

/*====================================================================
函数名：AccuPrtNameAdd
功能：增加精确打印名字
算法实现：	
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄
				tOccName － 名称
返回值说明
====================================================================*/
BOOL AccuPrtNameAdd(IN void* dwTelHdl, IN OCC tOccName);

/*====================================================================
函数名：AccuPrtNameDel
功能：删除精确打印名字
算法实现：	
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄
				tOccName － 名称
返回值说明
====================================================================*/
BOOL AccuPrtNameDel(IN void* dwTelHdl, IN OCC tOccName);

/*====================================================================
函数名：AccuPrtIsNameAdded
功能：判断打印名字是否已加入打印表
算法实现：	
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄
				tOccName － 名称
返回值说明: TRUE, 已加入；FALSE，没加入
====================================================================*/
BOOL AccuPrtIsNameAdded(IN void* dwTelHdl, IN OCC tOccName);

/*==================== 精确打印调试命令 ====================*/
//#define aprtclear	AccuPrtTableClear  //清除所有的打印名
//#define aprtadd(dwTelHdl, pchName) AccuPrtNameAdd(dwTelHdl, STR2OCC(pchName))	//增加打印名
//#define aprtdel(dwTelHdl, pchName) AccuPrtNameAdd(dwTelHdl, STR2OCC(pchName))	//删除打印名

void aprtclear(IN void* dwTelHdl); //清除所有的打印名
void aprtadd(IN void* dwTelHdl, IN s8 *pchName); //增加打印名
void aprtdel(IN void* dwTelHdl, IN s8 *pchName); //删除打印名
void aprtname(IN void* dwTelHdl); //显示注册的打印名
void aprtms(IN void* dwTelHdl, IN BOOL bShowMs); //打印时间是否显示毫秒

/*====================================================================
函数名：LVL_PRT
功能：分级打印（不建议使用）
算法实现：		如果有telnet客户端，打印到客户端; 否则打印到本地
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄
byPrtLvl － 打印级别, 如果大于打印门限，就打印。默认门限为 100
format - 可变参数
返回值说明
====================================================================*/
void LvlPrt(IN void* dwTelHdl, IN u8 byPrtLvl, IN const s8 *format, ...);

/*====================================================================
函数名：PrtGateSet
功能：打印门限设置
算法实现：		
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄
byGate － 打印门限

返回值说明
====================================================================*/
void PrtGateSet(IN void* dwTelHdl, IN u8 byGate);

#define prtgate	PrtGateSet	//便于调试

/*====================================================================
函数名：cmdshow
功能：显示各模块的帮助命令
算法实现：		
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄
				
返回值说明
====================================================================*/
void cmdshow(void* dwTelHdl);

/*====================================================================
函数名：cmdshowall
功能：显示所有已注册的命令
算法实现：		
引用全局变量：
输入参数说明：	dwTelHdl - telnet服务器句柄

返回值说明
====================================================================*/
void cmdshowall(void* dwTelHdl);

/*====================================== 目录操作  =========================================*/
#define MAX_DIRPATH_LEN		200		//目录操作中路径的最大长度
									//由于 OalIsDirExist 中要把结尾的 '/' 去掉才能正确判断，需拷贝输入的路径再处理，
									//为操作方便，定义此宏 

//定义文件系统类型
typedef enum EFSType
{
	FSTYPE_FAT32 = 1,     //FAT32
	FSTYPE_NTFS,          //NTFS
	FSTYPE_RAW,           //裸设备,无文件系统

}EFSType;

//获取磁盘分区信息
typedef struct tagDiskPartiton
{
	char m_achName[32+1];  //分区名
	u32 m_dwDriveType;     //驱动器类型 DRIVE_FIXED,DRIVE_CDROM等,DRIVE_FIXED表示本地磁盘
	u32 m_dwTotalSizeMB;   //大小
	u32 m_dwFSType;        //文件系统类型

}TDiskPartiton;

//获取磁盘分区信息
BOOL OalDiskPartitonGet(IN u32 dwListMaxCnt, OUT TDiskPartiton *ptDiskPartitonList, OUT u32 *pdwListRealCnt);

/*====================================================================
函数名: OalDirCreate
功能:	创建目录
算法实现:		
引用全局变量:
输入参数说明:	strDirPath - 目录路径
返回值说明： 成功，TRUE；失败，FALSE
====================================================================*/
BOOL OalDirCreate(IN const s8 *strDirPath);

 
/*====================================================================
函数名:	OalDirDelete
功能:	删除目录
算法实现:		
引用全局变量:
输入参数说明:	strDirPath - 目录路径
				
返回值说明：成功，TRUE；失败，FALSE
====================================================================*/
BOOL OalDirDelete(IN const s8 *strDirPath);

 
/*====================================================================
函数名:	PrtGateSet
功能:	目录是否存在
算法实现:		
引用全局变量:
输入参数说明:	strDirPath - 目录路径
返回值说明：存在，TRUE；不存在，FALSE
====================================================================*/
BOOL OalIsDirExist(IN const s8 *strDirPath);

//判断路径是否存在,支持根目录的判断
//add by zr
BOOL OalIsDirExistEx(IN const s8 *strDirPath);

/*====================================================================
函数名:	OalIsPathExist
功能:	路径是否存在，可以是目录，也可以是文件
算法实现:		
引用全局变量:
输入参数说明:	strDirPath - 目录路径
返回值说明：存在，TRUE；不存在，FALSE
====================================================================*/
BOOL OalIsPathExist(IN const s8 *strDirPath);


/*====================================================================
函数名:	OalFileDelete
功能:	删除文件
算法实现:		
引用全局变量:
输入参数说明:	strFilePath - 文件路径

返回值说明：成功，TRUE；失败，FALSE
====================================================================*/
BOOL OalFileDelete(IN const s8 *strFilePath);

/*====================================================================
函数名:	OalDelFilesInDir
功能:	删除目录下的所有文件(不递归删除)
算法实现:		
引用全局变量:
输入参数说明:	pchDir - 目录(绝对，相对路径都可以, 不要以 "/", "\\" 结尾)

返回值说明：成功，TRUE；失败，FALSE
====================================================================*/
BOOL OalDelFilesInDir(IN const s8 *pchDir);

/*====================================================================
函数名:	OalGetFilesInDir
功能:	得到目录下的所有文件(不递归)
算法实现:		
引用全局变量:
输入参数说明:	pchDir - 目录(绝对，相对路径都可以, 不要以 "/", "\\" 结尾)

返回值说明：成功，OAL_OK；失败，错误码
注意: 如果文件总数大于MAXFILE_PERDIR，返回错误码
	  如果文件总数为0, 返回OAL_OK	
====================================================================*/
#define MAXFILE_PERDIR	64
u32 OalGetFilesInDir(IN const s8 *pchDir, IN s8 astrFile[MAXFILE_PERDIR][MAX_FILENAME_LEN+1],
					OUT u32 *pdwGetFileNum);

/*====================================================================
函数名:	OalFileReadableJdg
功能:	判断文件是否可读
算法实现:		
引用全局变量:
输入参数说明:	strFilePath - 文件路径
返回值说明：成功，返回OAL_OK；失败，返回错误码
注意：linux上采用O_DIRECT, 只能对硬盘上的文件作判断。7M文件读完需2秒左右
====================================================================*/
u32 OalFileReadableJdg(IN const s8 *strFilePath);

/*====================================================================
函数名:	OalFileReadableFastJdg
功能:	快速判断文件是否可读
算法实现: 
引用全局变量:
输入参数说明:	strFilePath - 文件路径
返回值说明：成功，返回OAL_OK；失败，返回错误码
====================================================================*/
u32 OalFileReadableFastJdg(IN const s8 *strFilePath);

/*=============================================== 内存管理 ================================================*/

#define MAX_MEMLIB_NUM					 (u32)16 //内存库实例的最大个数, 定义该宏是为了调试的方便，可以通过内存库索引来输入调试命令

//内存块的类型
#define BLOCKTYPE_CUSTOM		(u32)1 //定制内存块
#define BLOCKTYPE_EXPONENT		(u32)2 //2的n次方内存块
#define BLOCKTYPE_DIRECT		(u32)3 //直通内存块
#define BLOCKTYPE_ALIGN			(u32)4 //align内存块
#define BLOCKTYPE_POOLALIGN		(u32)5 //pool align内存块
#define BLOCKTYPE_NONE			(u32)0		 
	


/*===========================================================
函数名： OalMAllocCreate
功能： 生成内存分配器
算法实现：
引用全局变量： 未引用
输入参数说明：  u32 *pdwCustomMem - 传入定制内存信息, 内存大小不限，数组中的内存大小不能相同。单位为 byte

				u32 dwArrayNum － 数组元素个数，即定制内存有dwArrayNum个不同尺寸
										
            
返回值说明： 内存分配器的句柄，失败返回NULL
===========================================================*/
API HANDLE OalMAllocCreate(IN u32 *pdwCustomMem, IN u32 dwArrayNum);


/*===========================================================
函数名： OalMAllocDestroy
功能： 释放内存分配器
算法实现：
引用全局变量： 未引用
输入参数说明：  HANDLE hAlloc 内存分配器的句柄
            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMAllocDestroy(IN HANDLE hAlloc);


/*===========================================================
函数名： OalInnerMAlloc
功能： 分配内存，并将分配信息存入链表中(内部函数，外部调用OalMAlloc)
算法实现：
引用全局变量： 未引用
输入参数说明：  HANDLE hAlloc 内存分配器的句柄
                u32 dwBytes 待分配的大小
				u32 dwTag 标签，由oal动态分配 

				BOOL bPool - 是否经过内存池
						FALSE: 直通操作系统的内存分配，即释放，分配都经由操作系统。该选项适合大容量内存的分配，且该内存分配后就不释放。
						TRUE:  分配释放都通过内存池，减少系统调用的次，该选项适合小容量内存（或定制内存）的反复分配，释放。

				const s8 *sFileName 函数调用所在的文件名
				s32 sdwLine 函数调用所在的行
            
返回值说明： 分配的内存的指针
说明：   用户不要直接调该函数 ！！！！！！！！！
===========================================================*/
API void* OalInnerMAlloc( HANDLE hAlloc, u32 dwBytes, u32 dwTag, BOOL bPool, s8 *sFileName, s32 sdwLine);

/*===========================================================
函数名： OalInnerOsMemAlign
功能： 
算法实现：
引用全局变量： 

返回值说明： 分配给用户的内存指针
说明：   用户不要直接调该函数 ！！！！！！！！！
===========================================================*/
API void* OalInnerOsMemAlign( HANDLE hAlloc, u32 dwAlign, u32 dwBytes, u32 dwTag, s8 *sFileName, s32 sdwLine);


/*===========================================================
函数名： OalMemAlignMalloc
功能： 分配dwAlign字节对齐的内存
算法实现：
引用全局变量： 未引用
输入参数说明：
返回值说明： 分配的内存的指针
说明：   用户不要直接调该函数 ！！！！！！！！
大于8M, 返回失败
===========================================================*/
API void* OalMemAlignMalloc( HANDLE hAlloc, u32 dwAlign, u32 dwBytes, u32 dwTag, s8 *sFileName, s32 sdwLine);

/*=================================================================================================

注： 使用 OalPoolMalloc分配内存时, 先会查看是否有定制内存，如有则返回定制内存。否则按2的整数幂分配内存，最大分配1M。
	 所以使用 OalPoolMalloc 分配大于8M的内存时，如果没有定制内存，直接从操作系统要，即等同于OalMalloc！

	OalMalloc分配内存，直接调用操作系统的malloc, free
	  	
=================================================================================================*/

#define OalMalloc(hAlloc, dwBytes, dwTag)		OalInnerMAlloc(hAlloc, dwBytes, dwTag, FALSE, __FILE__, __LINE__)
#define OalPoolMalloc(hAlloc, dwBytes, dwTag)	OalInnerMAlloc(hAlloc, dwBytes, dwTag, TRUE, __FILE__, __LINE__)
#define OalMemAlign(hAlloc, dwAlign, dwBytes, dwTag)	OalInnerOsMemAlign(hAlloc, dwAlign, dwBytes, dwTag, __FILE__, __LINE__)

//#define OalPoolMemAlign(hAlloc, dwAlign, dwBytes, dwTag)	OalMemAlignMalloc(hAlloc, dwAlign, dwBytes, dwTag, __FILE__, __LINE__)

/*===========================================================
函数名： OalInnerPoolRealloc
功能： 
算法实现：
引用全局变量： 未引用
输入参数说明：  
返回值说明： 分配的内存的指针
说明：   用户不要直接调该函数 ！！！！！！！！！
===========================================================*/
API void* OalInnerPoolRealloc(HANDLE hAlloc, void *p, u32 dwBytes, u32 dwTag, s8 *sFileName, s32 sdwLine);

//该接口仅供berkeleydb替换realloc用，其他模块不许使用 !!!!!!
//使用过OalPoolRealloc的内存不能再用OalMDup !!!!!!
#define OalPoolRealloc(hAlloc, p, dwBytes, dwTag) OalInnerPoolRealloc(hAlloc, p, dwBytes, dwTag, __FILE__, __LINE__)

/*===========================================================
函数名： OalMFree
功能： 释放内存，将被释放的内存从链表中删除
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hAlloc 内存分配器的句柄 
               void *pMem 待释放的内存块的指针
            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMFree(IN HANDLE hAlloc, IN void *pMem);


/*===========================================================
函数名： OalMSizeGet
功能： 得到指针指向内存区的大小
算法实现：
引用全局变量： 未引用
输入参数说明： 
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMSizeGet(IN void *pMem, OUT u32 *pdwSize);

/*===========================================================
函数名： OalMDup
功能： 内存拷贝，只增加引用，并不真正拷贝
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hAlloc 内存分配器的句柄  
               void *pMem 内存块的指针
            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMDup(IN HANDLE hAlloc, IN void *pMem);


/*===========================================================
函数名： OalMUserMemGet
功能： 得到指定标签的用户内存总量
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hAlloc － 内存分配器的句柄  
               u32 dwTag 标签 －如果为0，得到所有标签的用户内存总量
			   u32 *pdwSize － 用户内存总量
            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMUserMemGet(IN HANDLE hAlloc, IN u32 dwTag, OUT u32 *pdwSize);

/*===========================================================
函数名： OalMSysMemGet
功能： 得到oal内存库向操作系统申请的内存总量
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hAlloc 内存分配器的句柄  
               u32 *pdwSize － 系统内存总量
            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMSysMemGet(IN HANDLE hAlloc, OUT u32 *pdwSize);

/*===========================================================
函数名： OalMRefGet
功能： 得到内存引用计数
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hAlloc 内存分配器的句柄  
               void *pMem 内存块的指针
			   u32 *pdwRef - 引用计数
            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMRefGet(IN HANDLE hAlloc, IN void *pMem, OUT u32 *pdwRef);


/*===========================================================
函数名： OalMTypeGet
功能： 得到内存块类型
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hAlloc 内存分配器的句柄  
               void *pMem 内存块的指针
			   u32 *pdwType - 内存块类型
            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMTypeGet(IN HANDLE hAlloc, IN void *pMem, OUT u32 *pdwType);

/*===========================================================
函数名： OalMBlockNumGet
功能： 得到指定类型，指定大小的内存块的个数
算法实现：	
引用全局变量： 未引用
输入参数说明： HANDLE hAlloc － 内存分配器的句柄  
               u32 dwBlockType － 内存块类型
			   u32 dwBlockSize - 内存块大小。
								 对于直通内存块，该参数不起作用，返回所有的直通内存块个数
			   u32 *pdwBlockNum － 返回内存块个数
            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMBlockNumGet(IN HANDLE hAlloc, IN u32 dwBlockType, IN u32 dwBlockSize, OUT u32 *pdwBlockNum);


/*===========================================================
函数名： OalMemChk
功能： 检查所有内存库中所有内存是否被破坏，有就打印告警信息
	   该接口仅供调试用，正式版本不要使用 ！！！！！！
算法实现：
引用全局变量： 
输入参数说明： 
                          
返回值说明： 
===========================================================*/
API BOOL OalMemChk(void);

/*===========================================================
函数名： OalMemCmdReg
功能： 注册内存调试接口，包括 oalmemlib, oalmemtotal, oalmemdetail
		调用了该函数，上层用户不用再对这些调试接口一一注册了。
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl - telnet句柄
                          
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalMemCmdReg(IN void* dwTelHdl);


/*=========================== 调试接口， 用 OalMemCmdReg 即可统一注册 ============================*/

/*===========================================================
函数名： oalmemall
功能： 显示本进程通过oal分配的内存总数
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl - telnet句柄

返回值说明： 成功返回真，否则假
===========================================================*/
API void oalmemall(IN void* dwTelHdl);

/*===========================================================
函数名： oalmemlib
功能： 显示内存库总数
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl - telnet句柄
                          
返回值说明： 成功返回真，否则假
===========================================================*/
API void oalmemlib(IN void* dwTelHdl);


/*===========================================================
函数名： oalmemtotal
功能： 显示内存分配的总数，包括用户分配的内存，实际从系统分配的内存，内存池的信息（不区分tag）等
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl - telnet句柄
			   u32 dwMemLibIdx － 内存库索引
			   u32 dwTag － tag值，如果非0，除了显示所有tag的内存总数，还会单独显示标签为tag的内存
                          
返回值说明： 成功返回真，否则假
===========================================================*/
API void oalmemtotal(IN void* dwTelHdl, IN u32 dwMemLibIdx, IN u32 dwTag);

/*===========================================================
函数名： oalmemblock
功能： 显示内存块的分配情况
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl - telnet句柄
u32 dwMemLibIdx － 内存库索引

返回值说明： 成功返回真，否则假
===========================================================*/
API void oalmemblock(IN void* dwTelHdl, IN u32 dwMemLibIdx);

/*===========================================================
函数名： oalmemdetail
功能： 显示内存分配的细节，即在哪个文件，哪一行分配了内存
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl - telnet句柄
			   u32 dwMemLibIdx － 内存库索引, 从0开始
			   u32 dwTag － tag值，如果为0，显示所有
                          
返回值说明： 成功返回真，否则假
===========================================================*/
API void oalmemdetail(IN void* dwTelHdl, IN u32 dwMemLibIdx, IN u32 dwTag);


/*===========================================================
函数名： memchk
功能： 内存检测
算法实现：
引用全局变量： 
返回值说明： 成功返回真，否则假
===========================================================*/
API void memchk(void* dwTelHdl);


/*======================== 有名信号量，用户进程间互斥 ========================*/

/*===========================================================
函数名： OalNamedSemBCreate
功能： 创建有名信号量
算法实现：
引用全局变量： 未引用
输入参数说明： s8 *pchPath - 对于linux, 必须是已存在的路径或文件。对于windows，只是一个名字，与路径无关
			   u8 byPrjId － 项目编号，仅对linux有用，linux下的有名信号量由 pchPath, byPrjId 综合得到
			   u32 *pdwSem － 返回有名信号量
			                            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalNamedSemBCreate(s8 *pchPath, u8 byPrjId, u32 *pdwSem);

/*===========================================================
函数名： OalNamedSemDelete
功能： 删除有名信号量
算法实现：
引用全局变量： 未引用
输入参数说明： 
			   u32 dwSem － 有名信号量
			                            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalNamedSemDelete(u32 dwSem);


/*===========================================================
函数名： OalNamedSemTake
功能： 获得有名信号量
算法实现：
引用全局变量： 未引用
输入参数说明： 
			   u32 dwSem － 有名信号量
			                            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalNamedSemTake(u32 dwSem);
 

/*===========================================================
函数名： OalNamedSemDelete
功能：释放除有名信号量
算法实现：
引用全局变量： 未引用
输入参数说明： 
			   u32 dwSem － 有名信号量
			                            
返回值说明： 成功返回真，否则假
===========================================================*/
API BOOL OalNamedSemGive(u32 dwSem);


/*======================== msg fifo ========================*/

//msgfifo 统计
typedef struct tagMsgFifoStatis 
{
	u32			m_dwCurMsgNum;		//当前的消息个数
	u32			m_dwRcvMsgNum;		//接收到的消息总数
	u32			m_dwLostMsgNum;		//丢失的消息总数	
	u32			m_dwProcMsgNum;		//处理过的消息总数
	u32			m_dwDelMsgNum;		//删除的消息总数
	u32			m_dwHisMaxMsgNum;	//曾经存储的消息个数的最大值	
	u32			m_dwHisMaxMsgSize;  //曾经存储的消息最大长度
	u32			m_dwLoopBackNum;	//fifo环回次数, 供参考
}TMsgFifoStatis;

/*===========================================================
函数名： MsgFifoSizeCal
功能：估算fifo尺寸（由于fifo的数据块有额外数据头，所需大小会大于用户实际需要的大小）
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwBufNum － fifo中的buf个数
			   u32 dwAvgBufSize	- buf平均大小
			   u32 *pdwFifoSize - 返回fifo大小 (bytes)

返回值说明： 成功返回fifo句柄，失败返回NULL
===========================================================*/
API u32 MsgFifoSizeCal(IN u32 dwBufNum, IN u32 dwAvgBufSize, IN OUT u32 *pdwFifoSize);

/*===========================================================
函数名： MsgFifoCreate
功能：创建 msgfifo
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwFifoSize － fifo大小，byte. (fifo可以存变长数据, 所以 dwFifoSize是内存尺寸, 而不是缓冲个数)
			                            
返回值说明： 成功返回fifo句柄，失败返回NULL
===========================================================*/
API HANDLE MsgFifoCreate(IN u32 dwFifoSize);


/*===========================================================
函数名： MsgFifoDelete
功能：删除 msgfifo
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hMsgFifo － fifo句柄
			                            
返回值说明： 成功返回MSGFIFO_OK，失败返回错误码
===========================================================*/
API u32 MsgFifoDelete(IN HANDLE hMsgFifo);

/*===========================================================
函数名： MsgFifoWrite
功能：写msgfifo
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hMsgFifo － fifo句柄
			   u8 *pbyBuf - 缓冲指针
			   u32 dwBufLen - 缓冲长度
			                            
返回值说明： 成功返回MSGFIFO_OK，失败返回错误码
注:	 该接口为非阻塞的, 如果fifo满, 直接返回失败
===========================================================*/
API u32 MsgFifoWrite(IN HANDLE hMsgFifo, IN u8 *pbyBuf, IN u32 dwBufLen); 

/*===========================================================
函数名： MsgFifoRead
功能：读msgfifo
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hMsgFifo － fifo句柄
			   u8 *pbyBuf - 缓冲指针
			   u32 dwBufLen - 缓冲长度
			   u32 *pdwRealLen - 实际长度	
			                            
返回值说明： 成功返回MSGFIFO_OK，失败返回错误码
注:	 该接口为阻塞的, 如果fifo空, 将阻塞到有数据为止
===========================================================*/
API u32 MsgFifoRead(IN HANDLE hMsgFifo, IN OUT u8 *pbyBuf, IN u32 dwBufLen, OUT u32 *pdwRealLen);


/*===========================================================
函数名： MsgFifoReadByTime
功能：读msgfifo，带超时
算法实现：
引用全局变量： 未引用
输入参数说明：  HANDLE hMsgFifo － fifo句柄
				u8 *pbyBuf - 缓冲指针
				u32 dwBufLen - 缓冲长度
				u32 *pdwRealLen - 实际长度	
				u32 dwTimeout - 超时时间
返回值说明： 成功返回MSGFIFO_OK，失败返回错误码
===========================================================*/
API u32 MsgFifoReadByTime(IN HANDLE hMsgFifo, IN OUT u8 *pbyBuf, IN u32 dwBufLen, IN u32 dwTimeout, OUT u32 *pdwRealLen);


/*===========================================================
函数名： MsgFifoClear
功能：清空msgfifo
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hMsgFifo － fifo句柄
返回值说明： 成功返回MSGFIFO_OK，失败返回错误码
===========================================================*/
API u32 MsgFifoClear(IN HANDLE hMsgFifo); 

/*===========================================================
函数名： MsgDelete
功能：删除指定特征的 msg
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hMsgFifo － fifo句柄
			   u8 *pbyToken - 特征指针
			   u32 dwTokenLen - 特征长度
			   u32 dwTokenOffSet - 特征偏移
			                            
返回值说明： 成功返回MSGFIFO_OK，失败返回错误码
===========================================================*/
API u32 MsgDelete(IN HANDLE hMsgFifo, u8 *pbyToken, u32 dwTokenLen, u32 dwTokenOffSet);


/*===========================================================
函数名： MsgFifoStatisGet
功能：得到fifo统计
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hMsgFifo － fifo句柄
			   TMsgFifoStatis *ptStatis - fifo统计指针
			                            
返回值说明： 成功返回MSGFIFO_OK，失败返回错误码
===========================================================*/
API u32 MsgFifoStatisGet(IN HANDLE hMsgFifo, OUT TMsgFifoStatis *ptStatis);


/*===========================================================
函数名： MsgFifoStatisDump
功能：dump fifo统计
算法实现：
引用全局变量： 未引用
输入参数说明： HANDLE hMsgFifo － fifo句柄

返回值说明： 成功返回MSGFIFO_OK，失败返回错误码
===========================================================*/
API u32 MsgFifoStatisDump(IN void* dwTelHdl, IN HANDLE hMsgFifo);


/*=========================== msgfifo 调试接口 ===========================*/

/*===========================================================
函数名： mfshow
功能：显示msgfifo实例的个数及索引
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl－ telnet 句柄
			   
			                            
返回值说明： 
===========================================================*/
API void mfshow(IN void* dwTelHdl);

/*===========================================================
函数名： mfstatis
功能：得到msgfifo统计
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl－ telnet 句柄
			   u32 dwIdx - msgfifo 句柄索引
			                            
返回值说明： 
===========================================================*/
API void mfstatis(IN void* dwTelHdl, IN u32 dwIdx);


/*======================== 性能统计 ========================*/
#define CPU_STATTIME_SHORT	1		//CPU统计间隔，短时间 （s）
#define CPU_STATTIME_MID	10		//CPU统计间隔，中等时间 （s）
#define CPU_STATTIME_LONG	60		//CPU统计间隔，长时间 （s）

/*===========================================================
函数名： CpuUsgGet
功能：得到cpu使用率
算法实现：
引用全局变量： 未引用
输入参数说明： u32 *pdwShortTimeUsg － 短时间的使用率
			   u32 *pdwMidTimeUsg － 中等时间的使用率
			   u32 *pdwLongTimeUsg － 长时间的使用率
			                            
返回值说明： 成功返回 OAL_OK， 失败返回错误码
===========================================================*/
API u32 CpuUsgGet(IN u32 *pdwShortTimeUsg, IN u32 *pdwMidTimeUsg, IN u32 *pdwLongTimeUsg);


/*===========================================================
函数名： MemUsgGet
功能：得到内存使用率
算法实现：
引用全局变量： 未引用
输入参数说明： u32 *pdwTotalMem － 内存总量(Mega Bytes)
			   u32 *pdwFreeMem － 空闲内存总量(Mega Bytes)
			   u32 *pdwUsg － 内存使用率
			                            
返回值说明： 成功返回 OAL_OK， 失败返回错误码
===========================================================*/
API u32 MemUsgGet(IN u32 *pdwTotalMem, IN u32 *pdwFreeMem, IN u32 *pdwUsg);


/*===========================================================
函数名： DiskUsgGet
功能：得到硬盘使用率
算法实现：
引用全局变量： 未引用
输入参数说明： s8 *pchDir - 目录, 可以以 "/"结尾，也可以不用。
								windows上如 "c:/", "c:", "d:/ccroot", "d:/", 同一盘符下的目录得到的值是一样的
								linux上如 "/", "/mnt/", "/dev", 相同设备（文件系统）下的目录得到的值是一样的

			   u32 *pdwTotalDiskSpace － 硬盘空间(Mega Bytes)
			   u32 *pdwFreeDiskSpace － 空闲硬盘空间(Mega Bytes)
			   u32 *pdwUsg － 硬盘使用率
			                            
返回值说明： 成功返回 OAL_OK， 失败返回错误码
===========================================================*/
API u32 DiskUsgGet(IN s8 *pchDir, IN u32 *pdwTotalDiskSpace, IN u32 *pdwFreeDiskSpace, IN u32 *pdwUsg);




#define PARTION_MAXNUM			32
#define PARTIONNAME_MAXLEN		128

typedef struct tagPartionInfo 
{
	s8 m_achPartionName[PARTIONNAME_MAXLEN];
	u32 m_dwTotalSpaceMB;
	u32	m_dwFreeSpaceMB;
	u32 m_dwFSType; //文件系统类型
}TPartionInfo;

typedef struct tagDiskInfo 
{
	u32 m_dwPartionNum;				
	TPartionInfo m_atPartionInfo[PARTION_MAXNUM];
}TDiskInfo;

/************************************************************************
名称：OalDiskInfoGet
参数： 
功能：得到磁盘信息
返回：成功,返回OAL_OK;失败,返回错误码
注意：linux上固定查询 /mnt/sda1 -- /mnt/sdd4 共16个目录
*************************************************************************/
u32 OalDiskInfoGet(IN OUT TDiskInfo *ptDiskInfo);

/*========================== 性能统计调试接口 ==========================*/
/*===========================================================
函数名： cpuusage
功能：得到cpu统计
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl－ telnet 句柄
			                            
返回值说明： 
===========================================================*/
API void cpuusage(IN void* dwTelHdl);


/*===========================================================
函数名： memusage
功能：得到内存统计
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl－ telnet 句柄
			                            
返回值说明： 
===========================================================*/
API void memusage(IN void* dwTelHdl);


/*===========================================================
函数名： diskusage
功能：得到硬盘统计
算法实现：
引用全局变量： 未引用
输入参数说明： u32 dwTelHdl－ telnet 句柄
			   s8 *pchDir - 目录                         
返回值说明： 
===========================================================*/
API void diskusage(IN void* dwTelHdl, IN s8 *pchDir);


/*========================== 日志接口 ==========================*/
#define MAX_LOGLEN		512

//日志信息
typedef struct tagLogInfo 
{
	u32 m_dwMdlId;			//模块号
	u32 m_dwLogLvl;			//日志级别
	u32 m_adwReserved[6];	//保留字段
}TLogInfo;

//日志回调, pbyLogBuf 不一定以'\0'结尾
typedef void (*LogCallBack)(IN u8 *pbyLogBuf, IN u32 dwBufLen, IN TLogInfo tLogInfo, IN STIME tSecond, IN u32 dwContext);

/*===========================================================
函数名： OalLogCBReg
功能：日志回调注册
算法实现：
引用全局变量： 未引用
输入参数说明： LogCallBack pfLogCB － 回调函数
			   u32 dwContext - 上下文
s8 *pchDir - 目录                         
返回值说明： 成功,返回TRUE;失败,返回FALSE
注: 该接口仅供 RM 模块调用,其他模块不要调用 !!!
===========================================================*/
API BOOL OalLogCBReg(IN LogCallBack pfLogCB, IN u32 dwContext);

/*===========================================================
函数名： OalLogWrite
功能：写日志
算法实现：
引用全局变量： 未引用
输入参数说明： TLogInfo tLogInfo － 回调函数
				s8 *format - 可变参数
s8 *pchDir - 目录                         
返回值说明： 成功,返回TRUE;失败,返回FALSE

===========================================================*/
API void OalLogWrite(IN TLogInfo tLogInfo, IN const s8 *format, ...);


/*======================== 崩溃转储 ========================*/
#ifdef _LINUX_

/*===========================================================
函数名： ExcpCatchSet
功能：设置崩溃转储
算法实现：
引用全局变量： 未引用
输入参数说明： pStrExeFileName － 可执行文件的名字
			   pStrCoreDumpName - core dump 文件名，最长不超过128个字符
返回值说明： 成功,返回TRUE;失败,返回FALSE
===========================================================*/
API BOOL ExcpCatchSet(IN s8 *pStrExeFileName, IN s8 *pStrCoreDumpName);

#endif


/*============= oal打印级别 =============*/

void oaldl(IN void* dwTelHdl, IN u8 byLvl);

void oalhelp(IN void* dwTelHdl);
void oalprtname(IN void* dwTelHdl);

void md(void* dwTelHdl, u32 dwAddr, u32 dwLen, BOOL bByte);

/*===========================================================
函数名：IsMacAddrStrValid 
功能：mac地址字符串是否有效
算法实现：
引用全局变量： 未引用
输入参数说明： pchMacAddr － mac地址字符串
返回值说明：TRUE，有效；FALSE，无效
注：目前空实现，返回TRUE
===========================================================*/
API BOOL IsMacAddrStrValid(IN s8 *pchMacAddr);

/*===========================================================
函数名：IsMacAddrValid 
功能：mac地址是否有效
算法实现：
引用全局变量： 未引用
输入参数说明： qwMacAddr － mac地址，(由MAC2U64得到, 见uvBaseType.h)
返回值说明：TRUE，有效；FALSE，无效
注：目前空实现，返回TRUE
===========================================================*/
API BOOL IsMacAddrValid(u64 qwMacAddr);

/*===========================================================
函数名：IsIpAddrStrValid 
功能：ip地址字符串是否有效
算法实现：
引用全局变量： 未引用
输入参数说明： pchIpAddr － ip地址字符串
返回值说明：TRUE，有效；FALSE，无效
注意: 如果第一个字节为0,127,或大于233, 也认为非法 !!!
===========================================================*/
API BOOL IsIpAddrStrValid(IN s8 *pchIpAddr);

/*===========================================================
函数名：IsIpAddrValid 
功能：ip地址是否有效
算法实现：
引用全局变量： 未引用
输入参数说明： dwIpAddr － ip地址，网络序
返回值说明：TRUE，有效；FALSE，无效
===========================================================*/
API BOOL IsIpAddrValid(u32 dwIpAddr);

/*===========================================================
函数名：IsNetMaskStrValid 
功能：掩码地址是否有效
算法实现：
引用全局变量： 未引用
输入参数说明： pchMaskAddr － mask地址字符串
返回值说明：TRUE，有效；FALSE，无效
注：目前空实现，返回TRUE
===========================================================*/
API BOOL IsNetMaskStrValid(IN s8 *pchMaskAddr);

/*===========================================================
函数名：IsNetMaskValid 
功能：掩码地址是否有效
算法实现：
引用全局变量： 未引用
输入参数说明： dwNetMask － 掩码，网络序
返回值说明：TRUE，有效；FALSE，无效
===========================================================*/
API BOOL IsNetMaskValid(u32 dwNetMask);

/*===========================================================
函数名：IsIpMaskAddrValid 
功能：ip, mask地址对是否有效
算法实现：
引用全局变量： 未引用
输入参数说明： dwIpAddr － ip地址，网络序
返回值说明：TRUE，有效；FALSE，无效
===========================================================*/
API BOOL IsIpMaskAddrValid(u32 dwIpAddr, u32 dwNetMask);

/*===========================================================
函数名：IsPortFree 
功能：端口是否空闲
算法实现：
引用全局变量： 未引用
输入参数说明： wPort － 端口号
返回值说明： 是否空闲
注： 对于tcp的端口，如果只bind，没有listen或connect, IsPortFree 返回还是 TRUE ！！！
	 netstat也显示不出只bind的tcp端口。
===========================================================*/
API BOOL IsPortFree(IN u16 wPort);

/*===========================================================
函数名：PortStatusGet 
功能：得到端口的tcp连接状态
算法实现：
引用全局变量： 未引用
输入参数说明： wPort － 端口号
			   pbyStatus - 返回状态	
			   dwInNum - 状态数组的个数
			   pdwRealNum - 端口的实际状态数	
返回值说明：成功,TRUE；失败，FALSE
说明：如果该端口不在tcp表中，返回失败
===========================================================*/
API BOOL PortStatusGet(IN u16 wPort, IN OUT u8 *pbyStatus, IN u32 dwInNum, OUT u32 *pdwRealNum);
/*===========================================================
函数名：IpNum2Str 
功能：网络序的ip整数转换为字符串
算法实现：
引用全局变量： 未引用
输入参数说明： dwIp － 网络序的ip整数
pchBuf - 输入缓冲，带出ip字符串
dwBufLen - 缓冲长度，至少为 IPSTR_LEN + 1
返回值说明： 成功,返回ip字符串; 失败,返回NULL
===========================================================*/
#define IPSTR_LEN	15   //不包括"\0"

API s8 *IpNum2Str(IN u32 dwIp, IN OUT s8 *pchBuf, IN u32 dwBufLen);

/*===========================================================
函数名：CpuNumGet 
功能：得到cpu的个数
算法实现：
引用全局变量： 未引用
输入参数说明：	
返回值说明： 返回cpu个数
===========================================================*/
API u32 CpuNumGet(void); 

/*===========================================================
函数名：CpuFrqGet 
功能：得到cpu频率
算法实现：
引用全局变量： 未引用
输入参数说明：dwCpuId - cpu编号(从0开始)	
pdwFrq - 返回频率(MHz)
返回值说明： 成功返回OAL_OK，失败返回错误码
===========================================================*/
API u32 CpuFrqGet(IN u32 dwCpuId, IN OUT u32 *pdwFrq);



/*===========================================================
函数名：MacListGet 
功能：得到mac地址列表
算法实现：
引用全局变量： 未引用
输入参数说明：	pqwMacList － 指向mac地址的指针
dwListEleNum - 输入列表元素的个数，即可以存放几个ip地址	
pdwRealMacNum - 实际的mac地址个数
返回值说明： 成功,返回OAL_OK;失败,返回错误码
如果数组元素的个数小于实际mac地址的个数，仍然返回OAL_OK
===========================================================*/
API u32 MacListGet(IN OUT u64 *pqwMacList, IN u32 dwListEleNum, IN OUT u32 *pdwRealMacNum);

/*===========================================================
函数名：IpListGet 
功能：得到ip列表
算法实现：
引用全局变量： 未引用
输入参数说明：	pdwIpList － 指向ip地址（u32, 网络序）的指针
dwListEleNum - 输入列表元素的个数，即可以存放几个ip地址	
pdwRealIpNum - 实际的ip地址个数
返回值说明： 成功,返回OAL_OK;失败,返回错误码
===========================================================*/
API u32 IpListGet(IN OUT u32 *pdwIpList, IN u32 dwListEleNum, IN OUT u32 *pdwRealIpNum);


typedef enum tagNetCardType
{
	e_NetCardType_ETH0 = 0,
	e_NetCardType_ETH1,
	e_NetCardType_ETH2,
	e_NetCardType_ETH3,
	e_NetCardType_PPP0,
	e_NetCardType_NUM,
}ENetCardType;

typedef struct tagSuperIp
{
	ENetCardType m_eNetCardType;
	u32 m_dwIPAddr;		
}TSuperIp;

/*===========================================================
函数名：SuperIpListGet 
功能：得到ip列表
算法实现：
引用全局变量： 未引用
输入参数说明：	
返回值说明： 成功,返回OAL_OK;失败,返回错误码
===========================================================*/
API u32 SuperIpListGet(IN OUT TSuperIp *ptSuperIp, IN u32 dwListEleNum, IN OUT u32 *pdwRealIpNum);

/*===========================================================
函数名：IpMaskListGet 
功能：得到ip, mask列表
算法实现：
引用全局变量： 未引用
输入参数说明：	pdwIpList － 指向ip地址（u32, 网络序）的指针
pdwMaskList － 指向mask地址（u32, 网络序）的指针
dwListEleNum - 输入列表元素的个数，即可以存放几个ip地址	
pdwRealIpNum - 实际的ip地址个数
返回值说明： 成功,返回OAL_OK;失败,返回错误码
===========================================================*/
API u32 IpMaskListGet(IN OUT u32 *pdwIpList, IN OUT u32 *pdwMaskList, IN u32 dwListEleNum, IN OUT u32 *pdwRealIpNum);

/*===========================================================
函数名： GateWayGet
功能：获取本地机的网关
算法实现：
引用全局变量： 未引用
输入参数说明： pdwGatewayList － 指向gateway地址（u32, 网络序）的指针
			dwListEleNum - 输入列表元素的个数，即可以存放几个ip地址	
			pdwRealNum - 实际的ip地址个数
返回值说明： 成功,返回OAL_OK; 失败,返回错误码 
注： 目前win32上为空实现，返回OAL_OK， pdwRealNum赋0
===========================================================*/
API u32 GateWayGet(IN OUT u32 *pdwGatewayList, IN u32 dwListEleNum, IN OUT u32 *pdwRealNum);


/************************************************************************
名称：IpAddrSet
参数：	pchNetCardName, 网卡名字, 如 "eth0"
dwAddrNetEndian, ip地址, 网络序
dwMaskNetEndian, 掩码，网络序
功能：设置ip地址, 掩码
返回：成功，OAL_OK；失败，错误码
注：在windows上空实现，直接返回OAL_OK
*************************************************************************/
u32 IpAddrSet(IN s8 *pchNetCardName, IN u32 dwAddrNetEndian, IN u32 dwMaskNetEndian);


/************************************************************************
名称：GatewaySet
参数：dwGatewayNetEndian, ip地址, 网络序
功能：设置网关
返回：成功，OAL_OK；失败，错误码
注：在windows上空实现，直接返回OAL_OK
*************************************************************************/
u32 GatewaySet(IN u32 dwGatewayNetEndian);

/************************************************************************
名称：GatewayDetailSet
参数：	eNetCard, 网卡类型
		dwDstAddrNetEndian, 目标地址, 网络序（不需指定具体地址，填0）
		dwDstMaskNetEndian, 目标地址的子网掩码, 网络序（不需指定具体地址，填0）
		dwGatewayNetEndian, ip地址, 网络序
功能：设置网关, 详细的参数
返回：成功，OAL_OK；失败，错误码
注：在windows上空实现，直接返回OAL_OK
    GatewaySet(dwGatewayNetEndian) 相当于 GatewayDetailSet(0, 0, 0, dwGatewayNetEndian)
*************************************************************************/
u32 GatewayDetailSet(IN ENetCardType eNetCard, IN u32 dwDstAddrNetEndian,
					 IN u32 dwDstMaskNetEndian, IN u32 dwGatewayNetEndian);

/************************************************************************
名称：IpAddrGetByDomainName
参数： ip地址, 网络序
功能：设置网关
返回值说明： 成功,返回OAL_OK;失败,返回错误码
*************************************************************************/
u32 IpAddrGetByDomainName(IN s8 *pchDomain, OUT u32 *pdwIpAddr);

//网络传输统计
typedef struct tagNetTransStatis 
{	
	u64 m_qwTxPacks;	//发送包数
	u64 m_qwTxBytes;	//发送字节数
	u64 m_qwRxPacks;	//接收包数
	u64 m_qwRxBytes;	//接收字节数
}TNetTransStatis;

#ifdef _LINUX_

/************************************************************************
名称：NetTransStatisGet
参数： pchNetDev -- 网络设备名称, 如 eth0
	   ptNetTransStatis -- 返回网络	
功能：得到网络传输统计
返回值说明： 成功,返回OAL_OK;失败,返回错误码
*************************************************************************/
u32 NetTransStatisGet(IN s8 *pchNetDev, OUT TNetTransStatis *ptNetTransStatis);

#endif


//仅适用于windows的接口
#ifdef _MSC_VER

/*===========================================================
函数名：NtfsJdg 
功能：判断是否ntfs文件系统
算法实现：
引用全局变量： 未引用
输入参数说明：pchDisk - 磁盘名称，格式参考: "c:\\", "c:/"
			  pbNtfs - 返回是否ntfs文件系统
返回值说明： 成功返回OAL_OK，失败返回错误码
===========================================================*/
API u32 NtfsJdg(IN const s8 *pchDisk, IN OUT BOOL *pbNtfs);


/*===========================================================
函数名：estyiled 
功能：让出cpu
算法实现：
引用全局变量： 
返回值说明： 
说明：windows 空实现
===========================================================*/
API void estyiled(); 

#endif //_MSC_VER

//从百分比转到数值
s32 Percent2Value(IN u32 dwPercent, IN s32 nOutPutMinValue, IN s32 nOutPutMaxValue);

//从数值转到百分比
u32 Value2Percent(IN s32 nInPutValue, IN s32 nInPutMinValue, IN s32 nInPutMaxValue);

void per2val(IN void* dwTelHdl, IN u32 dwPercent, IN s32 nOutPutMinValue, IN s32 nOutPutMaxValue);
void val2per(IN void* dwTelHdl, IN s32 nInPutValue, IN s32 nInPutMinValue, IN s32 nInPutMaxValue);

/*=========================== 用于统计第三方代码的内存分配  ===========================*/
/*===========================================================
函数名：emalloc 
功能：分配指定大小的内存
算法实现：
引用全局变量： 未引用
输入参数说明：size - 内存大小（byte）
返回值说明： 成功返回指向size大小的内存，失败返回NULL
===========================================================*/
void *emalloc(u32 size);

/*===========================================================
函数名：ecalloc 
功能：分配指定大小的内存
算法实现：
引用全局变量： 未引用
输入参数说明：	nmemb - 内存块个数
				size - 单个块的大小（byte）
					
返回值说明： 成功返回指向 nmemb * size 大小的内存，失败返回NULL
===========================================================*/
void *ecalloc(u32 nmemb, u32 size);

/*===========================================================
函数名：erealloc 
功能：重新分配指定大小的内存
算法实现：
引用全局变量： 未引用
输入参数说明：	ptr - 指针
				size - 内存大小（byte）

返回值说明： 成功返回指向 nmemb * size 大小的内存，失败返回NULL
注：经测试，realloc(ptr, 0), ptr为一个有效指针。
	在win32,i386Linux上都返回 NULL，在armLinux上返回一个有效的地址
	erealloc 在不同平台上保持和 realloc 相同的行为。  
===========================================================*/
void *erealloc(void *ptr, u32 size);

/*===========================================================
函数名：efree 
功能：释放内存
算法实现：
引用全局变量： 未引用
输入参数说明：	ptr - 指针

返回值说明： 成功返回指向 nmemb * size 大小的内存，失败返回NULL
===========================================================*/
void efree(void *ptr);

/*===========================================================
函数名：ememTotalGet 
功能：得到内存总数，主要用于测试时的统计
算法实现：
引用全局变量： 未引用
输入参数说明：	

返回值说明： 成功返回指向 nmemb * size 大小的内存，失败返回NULL
===========================================================*/
u32 ememTotalGet(void);

//得到内存总数, 调试命令
void ememtotal(void* dwTelHdl);


//得到oal配置
void oalcfg(void* dwTelHdl);

//bash直通开启
void bashon(void* dwTelHdl);

//bash直通关闭
void bashoff(void* dwTelHdl);

//网络统计
void netstatis(void* dwTelHdl, s8 *pchNetDev);

#ifdef __cplusplus
}
#endif


#endif //_OAL_H





