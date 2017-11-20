/*****************************************************************************
模块名      : OTL(operation system tool layer)
文件名      : otl.h
相关文件    : otl.c
文件实现功能: 操作系统工具封装，封装定时器、内存管理、UDP发送等常用操作。
			  该模块具有自己的逻辑，不同于OAL的直接调用操作系统接口。
作者        : gerrard
版本        : V3R0  Copyright(C) 2006-2008 FOCUS, All rights reserved.
-----------------------------------------------------------------------------
修改记录:
日  期      版本        修改人      修改内容
2006/12/30  V3R0        gerrard      Create，封装定时器
2007/04/07	V3R0		gerrard		 
2007/04/10	V3R0		robinson	 添加内存管理、基础数据结构		 
2007/04/19	V3R0		robinson	 将定时器移到OTL中实现		
2007/07/14	V3R0		gerrard		 定时器采用 OalGetU64Ms 计时
2007/07/24  V3R0		gerrard		 定时器用 OalTaskDelay 阻塞

2007/08/08  V3R0		gerrard		 增加OtlVerGet();
									 去掉内存模块

2007/09/18  V3R0		gerrard		 增加OtlHealthCheck();
									 使用vc8

2007/11/02  V3R0		gerrard	     增加otldl
2007/11/09  V3R0		gerrard	     oal更新
									 071210: 定时器增加健壮性	
									 080117: 增加SQueGetNextN
2008/02/15  V3R0		gerrard	     oal更新
2008/05/23  V3R1		gerrard	     修改64位关键字的bug
2008/05/23  V3R1		gerrard	     增加 timerlibshow 调试接口
2009/05/19  V3R1		gerrard	     OtlTimerLibCreate 改为宏
2009/06/23  V3R1		gerrard	     增加 OtlTimerCBCalSet, OtlTimerWarnThreadSet
										  OtlTimerWarnCountGet	
2009/07/17  V3R1		gerrard	     增加 dnslib
******************************************************************************/

#ifndef _OTL_H
#define _OTL_H


#ifdef __cplusplus
extern "C" {
#endif 

#define OTLVER "OTL V3R1 I090717R090717"

#define OTL_OK						(u32)0
#define DNS_OK						(u32)0

#define OTL_ERR_BASE				OTL_ERRBASE
#define OTL_ERR_PARAM_ERR			(u32)(OTL_ERR_BASE + 1)
#define OTL_ERR_NULL_POINT			(u32)(OTL_ERR_BASE + 2)
#define OTL_ERR_LIST_HOLLOW			(u32)(OTL_ERR_BASE + 3)
#define OTL_ERR_NO_TIMEOUT			(u32)(OTL_ERR_BASE + 4) //定时器没到点
#define OTL_ERR_TIMERLIB_UNINIT		(u32)(OTL_ERR_BASE + 5)

#define	DNS_SRCNAME_NOT_EXIST		(u32)(OTL_ERR_BASE + 6)
#define	DNS_DSTIP_NOT_FOUND			(u32)(OTL_ERR_BASE + 7)	
#define	DNS_DNSSERVER_NOT_CONFIGED	(u32)(OTL_ERR_BASE + 8)
#define	DNS_NAME_FULL				(u32)(OTL_ERR_BASE + 9)	
#define	DNS_PARAM_ERROR				(u32)(OTL_ERR_BASE + 10)		

#define OTLERR_MAXERRNO				DNS_PARAM_ERROR


#ifdef _LINUX_
#include <sys/time.h>
#include <signal.h>
#endif

typedef enum 
{
	TIMER_TYPE_ONCE=0,//定时器类型, 只定时一次
	TIMER_TYPE_CYCLE  //定时器类型, 周期定时
}eTimerType;
	


typedef void (*OTLTIMERCB)(u32 dwTimerId, u32 dwContext); //定时器回调

/*=================================================================
函 数 名: OtlInit
功    能: otl初始化
输入参数: 
返回值:	 成功，TRUE; 失败，FALSE 
=================================================================*/
BOOL OtlInit();

/*=================================================================
函 数 名: OtlExit
功    能: otl退出
输入参数: 
返回值:	 成功，TRUE; 失败，FALSE 
=================================================================*/
BOOL OtlExit();

/*=================================================================
函 数 名: OtlHealthCheck
功    能: otl健康检查
输入参数: 
返回值:	 健康，OTL_OK; 不健康，错误码 
=================================================================*/
u32 OtlHealthCheck();


/*=================================================================
函 数 名: OtlVerGet
功    能: 得到otl版本号
输入参数: pchVerBuf -- 输入缓冲，带回版本号
		  dwLen -- 输入缓冲长度
返回值:	  返回  pbyBuf	

说明:     
=================================================================*/
s8 *OtlVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

/*================================================ 定时器操作 ================================================*/

/*====================================================================
函数名		：OtlTimerLibCreate
功能		：生成定时器库
算法实现	：
引用全局变量：无
输入参数说明：
返回值说明	：成功返回定时器库的句柄，失败返回NULL
====================================================================*/
API HANDLE InnerOtlTimerLibCreate(IN s8 *pchFile, IN u32 dwLine);

#define OtlTimerLibCreate() InnerOtlTimerLibCreate(__FILE__, __LINE__)


/*====================================================================
函数名		：OtlPriTimerLibCreate
功能		：生成指定优先级的定时器库
算法实现	：
引用全局变量：无
输入参数说明：
返回值说明	：成功返回定时器库的句柄，失败返回NULL
注：一般模块禁止调用该接口，由最上层的应用程序调用，供需高优先级的任务调用(如视频编码)
	
====================================================================*/
API HANDLE InnerOtlPriTimerLibCreate(IN u8 byPri, IN s8 *pchFile, IN u32 dwLine);

#define OtlPriTimerLibCreate(byPri) InnerOtlPriTimerLibCreate(byPri, __FILE__, __LINE__)


/*====================================================================
函数名		：OtlTimerSet
功能		：设置定时器(误差10ms)
算法实现	：
引用全局变量：无
输入参数说明：
			  hTimerLib -- 定时器所属的定时器库
			  dwDelayMs -- 延时(ms)
			  pTimeProc -- 回调函数
			  dwContext -- 上下文
			  type -- 定时器类型	
返回值说明	：成功返回定时器ID，失败返回0
====================================================================*/
API u32 OtlInnerTimerSet(IN HANDLE hTimerLib,IN u32 dwDelayMs, IN OTLTIMERCB pTimeProc, 
						 IN u32 dwContext, IN eTimerType type, IN s8 *pchFile, IN u32 dwLine);

#define OtlTimerSet(hTimerLib, dwDelayMs, pTimeProc, dwContext, type) \
	OtlInnerTimerSet(hTimerLib, dwDelayMs, pTimeProc, dwContext, type, __FILE__, __LINE__)


/*====================================================================
函数名		：OtlTimerKill
功能		：清除定时器
算法实现	：
引用全局变量：无
输入参数说明：
			  hTimerLib -- 定时器所属的定时器库
			  dwTimerId -- 定时器号
			  
返回值说明	：成功返回TRUE，失败返回FALSE
====================================================================*/
API BOOL OtlTimerKill(IN HANDLE hTimerLib,IN u32 dwTimerId);

/*====================================================================
函数名		：OtlTimerLibRelease
功能		：释放定时器库
算法实现	：
引用全局变量：无
输入参数说明：hTimerLib -- 定时器所属的定时器库
返回值说明	：成功返回TRUE，失败返回FALSE
====================================================================*/
API BOOL OtlTimerLibRelease(IN HANDLE hTimerLib);


/*====================================================================
函数名		：OtlTimerCBCalSet
功能		：是否计算定时器回调时间
算法实现	：
引用全局变量：无
输入参数说明：
返回值说明	：无
====================================================================*/
API void OtlTimerCBCalSet(IN BOOL bCal);

/*====================================================================
函数名		：OtlTimerWarnThreadSet
功能		：设置定时器库回调耗时告警门限
算法实现	：
引用全局变量：无
输入参数说明：
返回值说明	：
====================================================================*/
API BOOL OtlTimerWarnThreadSet(IN HANDLE hTimerLib, IN u32 dwThreshHoldMs);

/*====================================================================
函数名		：OtlTimerWarnCountGet
功能		：得到定时器回调耗时告警门限
算法实现	：
引用全局变量：无
输入参数说明：
返回值说明	：
====================================================================*/
API BOOL OtlTimerWarnCountGet(IN HANDLE hTimerLib, IN u32 dwTimerId, OUT u32 *pdwCount);

/*================================================ 环形缓冲 ================================================*/
/*API u32 OtlCycleBufCreate(IN u32 dwBufNum, IN u32 dwBufSize, OUT u32 *pdwBufHdl);
API u32 OtlCycleBufDelete(IN u32 dwBufHdl);
API u32 OTLCycleBufWrite(IN u32 dwBufHdl, IN void *pvFirstData, IN u32 dwFirstDataLen, IN void *pvSecondData, IN u32 dwSecondDataLen);
API u32 OTLCycleBufRead(IN u32 dwBufHdl, OUT void *pvReadBuf, IN u32 dwInLen, OUT u32 *pdwRealLen);
API u32 OtlCycleBufDataNumGet(IN u32 dwBufHdl, OUT u32 *pdwDataNum);
*/



/************************************************************************/
/* 调试接口                                                            */
/**
**********************************************************************/

/*===========================================================
函数名： otlver
功能： 
算法实现：
引用全局变量： 未引用
输入参数说明：   
               
            
返回值说明： 无
===========================================================*/
API void otlver(IN void* dwTelHdl);

//定时器信息
API void timerlibshow(IN void* dwTelHdl);

/*=============================================== 排序队列 ================================================*/

#define SORTQUEVER "SORTQUE V3R0 RC01 b20070302"

typedef enum tagSQKeyType
{
	SQKEY_S8,
	SQKEY_U8,
	SQKEY_S16,
	SQKEY_U16,
	SQKEY_S32,
	SQKEY_U32,
	SQKEY_S64,
	SQKEY_U64,
	SQKEY_STRING,
	SQKEY_USER_DEFINED/*若为用户定义数据类型，则判断数据大小的回调函数不能为空*/
}SQKeyType;



typedef struct tagSQNode
{
	void *pKey;//关键码
	struct tagSQNode *pLeft;//左子女
	struct tagSQNode *pRight;//右子女
	struct tagSQNode *pParent;//父节点
	s32 sdwBalance;//平衡因子
	u32 dwUseMagic;//判断节点是否已存在于某个数据结构中，防止节点被多次使用
}SQNode;

/*===========================================================
函数名： SQKeyCmpCallBack
功能： 比较关键码大小的回调函数
算法实现： 
引用全局变量： 未引用
输入参数说明： void *pKey1 第一个关键码
				void *pKey2 第二个关键码
返回值说明： 返回0表示相等,<0表示pKey1<pKey2,>0表示pKey1>pKey2
===========================================================*/
typedef s32 (*SQKeyCmpCallBack)(IN void *pKey1, IN void *pKey2 );



/*===========================================================
函数名： SQKeyCmpByContextCallBack
功能： 比较关键码大小的回调函数, 代上下文
算法实现： 
引用全局变量： 未引用
输入参数说明： void *pKey1 第一个关键码
void *pKey2 第二个关键码
返回值说明： 返回0表示相等,<0表示pKey1<pKey2,>0表示pKey1>pKey2
===========================================================*/
typedef s32 (*SQKeyCmpByContextCallBack)(IN void *pKey1, IN void *pKey2, IN u32 dwContext);


typedef struct tagSortQue
{
	u32  dwLength;//sizeof(SortQue)
	SQNode *pRoot;//根节点
	SQKeyType eKeyType;//节点关键码类型
	SQKeyCmpCallBack pKeyCmpCallBack;//关键码比较大小的回调函数
	u32 dwSize;//当前节点个数
	BOOL m_bCmpByContext; //比较函数是否带上下文
	SQKeyCmpByContextCallBack pKeyCmpByContextCallBack;//关键码比较大小的回调函数, 带上下文
	u32 m_dwContext;
}SortQue;


/*===========================================================
函数名： SQueInit
功能： 初始化排序队列
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
			   SQKeyType eKeyType 关键码类型（若为SQKEY_USER_DEFINED，则第三个参数pSqCmpCallBack不能为空）
			   SQKeyCmpCallBack pSqCmpCallBack 关键码比较回调函数
返回值说明： 成功返回TRUE，否则成功返回FALSE
===========================================================*/
API BOOL SQueInit(IN SortQue *pSQ,IN SQKeyType eKeyType,IN SQKeyCmpCallBack pSqCmpCallBack);


/*===========================================================
函数名： SQueInitByContext
功能： 初始化排序队列
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
SQKeyType eKeyType 关键码类型（若为SQKEY_USER_DEFINED，则第三个参数pSqCmpCallBack不能为空）
SQKeyCmpCallBack pSqCmpCallBack 关键码比较回调函数
返回值说明： 成功返回TRUE，否则成功返回FALSE
===========================================================*/
API BOOL SQueInitByContext(IN SortQue *pSQ,IN SQKeyType eKeyType,
						   IN SQKeyCmpByContextCallBack pKeyCmpByContextCallBack, IN u32 dwContext);


/*===========================================================
函数名： SQueInsert
功能： 插入节点（在插入前需设置好pNode->pKey）
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
				SQNode *pNode 节点指针(必须为外界分配好的节点，SortQue内部不分配，只是组织链接关系)
返回值说明： 成功返回TRUE，否则返回FALSE
===========================================================*/
API BOOL SQueInsert(IN SortQue *pSQ,IN  SQNode *pNode);

/*===========================================================
函数名： SQueRemove
功能： 删除数据
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
				IN void *pKey 数据的关键码

返回值说明： 成功返回TRUE，否则返回FALSE
===========================================================*/
API BOOL SQueRemove(IN SortQue *pSQ,IN void *pKey);

/*===========================================================
函数名： SQueGet
功能： 得到关键码为pKey的数据
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
			void *pKey 数据的关键码
返回值说明： 成功返回节点指针，否则NULL
===========================================================*/
API SQNode* SQueGet(IN  SortQue *pSQ,IN void *pKey);

/*===========================================================
函数名： SQueNext
功能： 获得比当前传入关键码大的下一节点
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
			void *pRefKey 传入待比较的关键码
返回值说明： 成功返回节点指针，否则NULL
===========================================================*/
API SQNode* SQueNext(IN  SortQue *pSQ,IN void *pRefKey);

/*===========================================================
函数名： SQuePre
功能： 获得比当前传入关键码小的上一节点
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
				void *pRefKey 传入待比较的关键码
返回值说明： 成功返回节点指针，否则NULL
===========================================================*/
API SQNode* SQuePre(IN  SortQue *pSQ,IN void *pRefKey);

/*===========================================================
函数名： SQueMin
功能： 获得关键码最小的节点
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
返回值说明： 成功返回节点指针，否则NULL
===========================================================*/
API SQNode* SQueMin(IN  SortQue *pSQ);

/*===========================================================
函数名： SQueMax
功能： 获得关键码最大的节点
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
返回值说明： 成功返回节点指针，否则NULL
===========================================================*/
API SQNode* SQueMax(IN  SortQue *pSQ);

/*===========================================================
函数名： SQueSize
功能： 得队列节点个数
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
            
返回值说明： 返回节点个数
===========================================================*/
API u32 SQueSize(IN  SortQue *pSQ);

/*===========================================================
函数名： SQueIsEmpty
功能： 判断排序对列是否为空
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
返回值说明： 为空返回TRUE，否则返回FALSE
===========================================================*/
API BOOL SQueIsEmpty(IN SortQue *pSQ);

/************************************************************************/
/* 调试接口                                                            */
/************************************************************************/
/*===========================================================
函数名： squehelp
功能： 输出版本号及命令列表
算法实现： 
引用全局变量： 未引用
输入参数说明：             
返回值说明： 
===========================================================*/
API void squehelp();

/*===========================================================
函数名： SQueBalanceValidate
功能： 验证SortQue所有节点的平衡因子是否正确
算法实现： 
引用全局变量： 未引用
输入参数说明： SortQue *pSQ SortQue指针
返回值说明： 
===========================================================*/
API BOOL SQueBalanceValidate(IN  SortQue *pSQ);


/*===========================================================
函数名： SQueGetNextN
功能： 按排序得到多个节点
算法实现： 
引用全局变量： 未引用
输入参数说明：	pSQ - 排序队列
pKey - 关键字
dwMaxNodeNum - 最大节点数
aptSQNode - 节点指针数组
pdwNodeCount - 返回实际得到的节点数
返回值说明：  
===========================================================*/
API BOOL SQueGetNextN(IN  SortQue *pSQ,IN void *pKey, u32 dwMaxNodeNum, SQNode * aptSQNode[], u32 * pdwNodeCount);

/*============= dns =============*/

u32 init_cbb_dns_module(TCommInitParam tCommonInit,u16 wLocalPort,u32 dwQueryInterval);
/*
User Set Which host want
*/
u32 set_cbbdns_resolve_name(s8* name);

u32 clear_cbbdns_resolve_name(s8* name);
/*
Get user host-want result
*/
u32 get_cbbhost_by_name(s8* name,u32* dwIpAddr);
/*
Quit this module
*/
u32 quit_cbb_dns_module();


/*============= otl打印级别 =============*/

API void otldl(IN void* dwTelHdl, IN u8 byLvl);

API void otlhelp(IN void* dwTelHdl);
API void otlprtname(IN void* dwTelHdl);
API void otltimercbcal(IN void* dwTelHdl, IN BOOL bCal);
API void timerlibwarnset(IN void* dwTelHdl, IN u32 dwLibIdx, IN u32 dwWarnMS); //设置告警阀值

#ifdef __cplusplus
}
#endif  // __cplusplus

#endif //_OTL_H

