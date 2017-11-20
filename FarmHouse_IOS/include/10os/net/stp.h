/*****************************************************************************
模块名      : STP(测试平台)
文件名      : stp.h
相关文件    : stp.c
文件实现功能: 系统的统一测试平台
作者        : gerrard
版本        : V3R1  Copyright(C) 2006-2008 FOCUS, All rights reserved.
-----------------------------------------------------------------------------
修改记录:
日  期      版本        修改人      修改内容
2008/07/16  V3R1       gerrard      Create
******************************************************************************/
#ifndef _STP_H
#define _STP_H

#define STP_OK						(u32)0
#define STPERR_BASE					(u32)1200
#define STPERR_PARA					(u32)(STPERR_BASE+1)
#define STPERR_NULLPOINT			(u32)(STPERR_BASE+2)
#define STPERR_UNINIT				(u32)(STPERR_BASE+3)
#define STPERR_UNCONNECT			(u32)(STPERR_BASE+4)
#define STPERR_SIGNET				(u32)(STPERR_BASE+5)
#define STPERR_MAGIC				(u32)(STPERR_BASE+6)
#define STPERR_CMDFULL				(u32)(STPERR_BASE+7)
#define STPERR_OAL					(u32)(STPERR_BASE+8)
#define STPERR_OTL					(u32)(STPERR_BASE+9)
#define STPERR_TIMEOUT				(u32)(STPERR_BASE+10)
#define STPERR_LEN					(u32)(STPERR_BASE+11)
#define STPERR_NOCMD				(u32)(STPERR_BASE+12)


typedef u32 HSTPCONN;		//客户端链接句柄

#define MAXCMD_NUM			(u32)1024		//命令最大个数
#define CMDNAME_MAXLEN		(u32)30			//命令名称长度 
#define CMDUSAGE_MAXLEN		(u32)80			//命令说明长度

#define CLTSIG_CONTEXT		999
#define SVRSIG_CONTEXT		888


//通用的命令函数
typedef u32 (* CommFunc)(IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, \
						IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen);

/*====================================================================
函数名：STPInit
功能：stp初始化
算法实现：
引用全局变量：
输入参数说明：	tCommInit -- 公共资源
				bSvr -- 是否服务端	
				wPort -- 端口号
				dwConNum -- 链接个数
返回值说明：成功，STP_OK; 失败，错误码
====================================================================*/
u32 STPInit(IN TCommInitParam tCommInit, IN BOOL bSvr, IN u16 wPort, IN u32 dwConNum);

/*====================================================================
函数名：STPExit
功能：stp退出
算法实现：
引用全局变量：
输入参数说明：	tCommInit -- 公共资源
bSvr -- 是否服务端	
wPort -- 端口号
返回值说明：成功，STP_OK; 失败，错误码
====================================================================*/
u32 STPExit();

/*====================================================================
函数名：STPCmdReg
功能：注册命令
算法实现：
引用全局变量：
输入参数说明：	strCmdName -- 函数名
				pFunc -- 函数指针
				strCmdUsage -- 函数用法
返回值说明：成功，STP_OK; 失败，错误码
====================================================================*/
u32 STPCmdReg(IN s8 *strCmdName, IN CommFunc pFunc, IN s8 *strCmdUsage);


/*========================= 客户端 =========================*/

/*====================================================================
函数名：STPConnect
功能：建链
算法实现：
引用全局变量：
输入参数说明：	dwAddr -- 服务端地址，网络序
				wPort -- 端口号
				phStpConn -- 返回链接句柄
返回值说明：成功，STP_OK; 失败，错误码
====================================================================*/
u32 STPConnect(IN u32 dwAddr, IN u16 wPort, OUT HSTPCONN *phStpConn);

/*====================================================================
函数名：STPDisConnect
功能：断链
算法实现：
引用全局变量：
输入参数说明：
返回值说明：成功，STP_OK; 失败，错误码
====================================================================*/
u32 STPDisConnect(HSTPCONN hStpConn);

/*====================================================================
函数名：STPCmdRunFullPara
功能：执行命令
算法实现：
引用全局变量：
输入参数说明：
返回值说明：命令未能执行完毕(如发送失败，等待超时)，返回STP错误码
			命令执行完毕，返回该命令的返回值
注意：对于传入的 adwInPara[10]，stp会自动转换字节序。
	  由于stp不清除 pbyInBuf，pbyOutBuf中的具体结构，
	  如果参数中需要pbyInBuf，pbyOutBuf，其中的字节序需调用者根据实际情况自行转换 !!!
	  即在客户端，调用 STPCmdRun 前转为网络序，STPCmdRun后转为主机序
	  在服务端，需在接口 "strCmdName"　中先转为主机序再进行处理，在函数返回前再转为网络序

====================================================================*/
u32 STPCmdRunFullPara(HSTPCONN hStpConn, IN s8 *strCmdName, IN u32 adwInPara[10], OUT u32 adwOutRet[10], IN u8 *pbyInBuf, 
			  IN u32 dwInBufLen, OUT u8 *pbyOutBuf, IN u32 dwOutBufLen, IN u32 dwCmdRunTimeOutMs);

//只带整型参数的命令，建议使用
#define STPCmdRunIntegerPara(hStpConn, strCmdName, adwInPara, adwOutRet, dwTimeOut) \
	STPCmdRunFullPara(hStpConn, strCmdName, adwInPara, adwOutRet, NULL, 0, NULL, 0, dwTimeOut)

//只带缓冲参数的命令
#define STPCmdRunBufPara(hStpConn, strCmdName, pbyInBuf, dwInBufLen, pbyOutBuf, dwOutBufLen, dwTimeOut) \
	STPCmdRunFullPara(hStpConn, strCmdName, NULL, NULL, pbyInBuf, dwInBufLen, pbyOutBuf, dwOutBufLen, dwTimeOut)

#endif //_STP_H


