/*****************************************************************************
模块名  ： signet
文件名  ： signet.h
相关文件：signet.c
文件实现功能：SIGNET头文件
作者    ：EastWood
版本    ：RC00
版权    ：FOCUS公司
------------------------------------------------------------------------------
修改记录:
日  期      	版本        修改人      修改内容
15/03/2006 	    1.0         EastWood    创建  
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
#define SIGOK  0   //成功
#define	SIGPOINTERNULLERR  (SIGNET_ERRBASE+1) //指针为空
#define SIGMEMERR   (SIGNET_ERRBASE+2)   //内存不足
#define	SIGBINDERR  (SIGNET_ERRBASE+3)   //绑定失败
#define	SIGSEMERR   (SIGNET_ERRBASE+4)   //信号量出错
#define SIGBUFFULLERR (SIGNET_ERRBASE+5)  //缓存满
#define	SIGSIZELONGERR (SIGNET_ERRBASE+6)  //太长
#define	SIGPARAMERR    (SIGNET_ERRBASE+7)  //参数出错
#define	SIGPORTCONFLICTERR (SIGNET_ERRBASE+8) //端口冲突
#define	SIGTHREADERR    (SIGNET_ERRBASE+9) //创建线程出错
#define SIGMODNOTEXISTERR (SIGNET_ERRBASE+10)  //模块不存在
#define	SIGTIMEERR  (SIGNET_ERRBASE+11)   //创建定时器出错
#define SIGTIMEOUTERR  (SIGNET_ERRBASE+12)   //超时
#define SIGHASCONNECTERR (SIGNET_ERRBASE+13)  //已连接上
#define SIGISCONNECTTINGERR (SIGNET_ERRBASE+14)  //正在连接
#define SIGSENDINGFILEERR (SIGNET_ERRBASE+15)   //正在发送文件
#define SIGFILEOPENERR    (SIGNET_ERRBASE+16)   //打开文件出错
#define SIGFILECREATEERR    (SIGNET_ERRBASE+17)   //创建文件出错
#define SIGFILEREADERR    (SIGNET_ERRBASE+18)   //读文件出错
#define SIGFILEWRITEERR    (SIGNET_ERRBASE+19)   //写文件出错
#define SIGFILENULLERR      (SIGNET_ERRBASE+20)   //文件为空
#define SIGHANDLENOTEXSITERR (SIGNET_ERRBASE+21)  //handle不存在
#define SIGSERVERONLYONEERR  (SIGNET_ERRBASE+22)   //只能创建一个Server
#define SIGNOTCONNECTERR     (SIGNET_ERRBASE+23)    //未连接上
#define SIGDISCONNECTERR     (SIGNET_ERRBASE+24)    //断链
#define SIGMSGFIFOCERR     (SIGNET_ERRBASE+25)    //创建消息FIFO失败
#define SIGCLIENTFULLERR     (SIGNET_ERRBASE+26)    //客户满出错
#define SIGSNDERR     (SIGNET_ERRBASE+27)    //发送出错
#define SIGRCVERR     (SIGNET_ERRBASE+28)    //接受出错
#define SIGMSGREADERR     (SIGNET_ERRBASE+29)    //消息读出错
#define SIGUNKNOWNERR  (SIGNET_ERRBASE+100)   //未知错误

#define MAX_WORKPATH_LEN   1024   //最大工作路径长度
#define MAX_FILESEND_SPEED   16     //文件最大发送速度

//NatBus节点类型
#define SIGNATBUS_NODETYPE_SERVICE      (u32)1
#define SIGNATBUS_NODETYPE_CLIENT    (u32)2


//异步连接回调
typedef void (*ConnectCallBack)(HSig hSig,u32 dwResult,u32 dwContext);

//连接接受回调
typedef void (*ConnectAcceptCallBack)(HSig hSig,TNetAddr *ptRealNetAddr,TNetAddr *ptMapNetAddr,u32 dwContext);

//信令接受回调
typedef void (*SigRcvCallBack)(HSig hSig,TNetAddr *ptMapNetAddr,u8 *pBuf,u32 dwBufLen,u32 dwContext );

//断链回调
typedef void (*DisConnectCallBack)(HSig hSig,u32 dwContext);

//文件发送进度回调
typedef void (*FileSendCallBack)(HSig hSig,u32 dwErrorId,u8 byCurRate,u32 dwContext);

//文件接受进度回调
typedef void (*FileRcvCallBack)(HSig hSig,char *pchLFileName,u32 dwErrorId,u8 byCurRate,u32 dwContext);

//文件信令转发回调
typedef void (*FileSigTransCallBack)(HSig hSig, u8* pSigBuf, u16 wSigLen, u32 dwContext);

/* AVTrans初始化结构 */
typedef struct tagSigParam
{
	BOOL m_bServer;  //是否为服务端
	u16 m_wSndQueueSize;  //发送对列大小
	u16 m_wRcvQueueSize;  //接受对列大小
	u16 m_wCheckTimeValS; //链路检测间隔
	u16 m_wCheckNum;    //链路检测次数
	ConnectAcceptCallBack  m_pConnectAcceptPrc;//链接回调函数,仅对服务器有效
	u32 m_dwConnectAcceptContext;  //链接回调参数
	SigRcvCallBack      m_pSigRcvPrc; //SIG接受回调函数
	u32 m_dwSigRcvContext; //SIG接受回调参数
	DisConnectCallBack m_pDisConnectPrc; //断链回调函数
	u32 m_dwDisConnectContext; //断链回调参数
}TSigParam;



//初始化SNET
//u16 m_wHighRTSigQueueSize;   //高实时信令接受队列的大小(消息的个数),可为零
//u16 m_wNormalRTSigQueueSize;   //普通实时信令接受队列的大小(消息的个数),不可为零
//u16 m_wLowRTSigQueueSize;   //普通实时信令接受队列的大小(消息的个数),可为零
SIGRET SNetModInit(TCommInitParam tCommInitParam,u32 dwMaxClientNum,u32 dwMaxAcceptNum,u16 wLocalPort,u16 wHighRTSigQueueSize,u16 wNormalRTSigQueueSize,u16 m_wLowRTSigQueueSize,HSNetMod *phSNetMod);

//设置工作路径(文件全路径为工作路径+SigSendFile中的文件参数)
SIGRET SNetSetWorkPath(HSNetMod hSNetMod,char *pWorkPath);


//创建SIG
SIGRET SigCreate(HSNetMod hSNetMod,TSigParam tSigParam,HSig *phSig);


//获取SIG参数
SIGRET SigParamGet(HSig hSig,TSigParam *ptSigParam);

//SIG链接
SIGRET SigConnect(HSig hSig,u32 dwServerIp,u16 wServerPort,u32 dwTimeOutMs);

//异步SIG链接
SIGRET AsySigConnect(HSig hSig,u32 dwServerIp,u16 wServerPort,u32 dwTimeOutMs, ConnectCallBack pConnectPrc,u32 dwContext);

//获取对端地址
SIGRET SigOppAddrGet(HSig hSig,TNetAddr *ptMapNetAddr);

//设置链路检测时间
SIGRET SetHeartBeatParam(HSig hSig,u16 wTimeValS,u16 wNum);

//设置发送文件回调函数
SIGRET SetSendFileCallBack(HSig hSig,FileSendCallBack pFileSendPrc,u32 dwContext);

//设置接受文件回调函数
SIGRET SetRcvFileCallBack(HSig hSig,FileRcvCallBack pFileRcvPrc,u32 dwContext);

//设置文件传输信令转发回调函数
SIGRET SetFileSigTransCallBack( HSig hSig, FileSigTransCallBack pFileSigTransPrc,u32 dwContext);
//转发文件传输信令（可以采用SigSend 或 SigLowSend）
// SIGRET FileSigTransSend( HSig hSig, u8* pSigBuf,u16 wSigLen );
//处理文件传输信令
SIGRET FileSigProc( HSig hSig, u8* pSigBuf,u16 wSigLen );


//发送SIG,对于SIG很长的情况,可以分成很多小包发出去,接受端再拼装
SIGRET SigSend(HSig hSig,u8 *pBuf,u32 dwBufLen);

//高实时发送SIG,对于SIG很长的情况,可以分成很多小包发出去,接受端再拼装
SIGRET SigHighSend(HSig hSig,u8 *pBuf,u32 dwBufLen);

//普通发送SIG,对于SIG很长的情况,可以分成很多小包发出去,接受端再拼装,等同SigSend
SIGRET SigNormalSend(HSig hSig,u8 *pBuf,u32 dwBufLen);

//低实时发送SIG,对于SIG很长的情况,可以分成很多小包发出去,接受端再拼装
SIGRET SigLowSend(HSig hSig,u8 *pBuf,u32 dwBufLen);

//发送文件,文件名包函路径,工作路径为空时文件全路径为pchLFileName;工作路径不为空时全路径为pWorkPath+pchLFileName
SIGRET SigSendFile(HSig hSig,char *pchLFileName,char *pchRFileName);

//设置文件发送速度
SIGRET SigSetFileSendSpeed(HSig hSig,u8 bySpeed);

//设置SIG标识
SIGRET SigSetTag(HSig hSig,u32 dwTag);

//获取SIG标识
SIGRET SigGetTag(HSig hSig,u32 *pdwTag);

//SIG断链
SIGRET SigDisConnect(HSig hSig);

//删除Sig
SIGRET SigDelete(HSig hSig);

//发送队列中所有的包(在超时值内)
SIGRET SNetSendFlush(HSNetMod hSNetMod,u32 dwTimeOutMs);

//退出SNET
SIGRET SNetExit(HSNetMod hSNetMod);

//Nat地址映射通知回调
//若映射发生变化，也通过该回调告知重新映射后的地址
typedef void (*SigNatBusAddrMapingNtfCB)(HSNetMod hSNetMod,TNetAddr tDstAddr, TNetAddr tLocalNatAddr, u32 dwContext);

//无法和对端建立通信通知回调（在指定超时时间内无响应）
//超时后，NatBus将该目的设置为空闲状态不再进行检测，若需要再检测，调用NatBusDetectStart
typedef void (*SigNatBusComInvalidNtfCB)(HSNetMod hSNetMod,TNetAddr tDstAddr, u32 dwContext);

//Tag源地址通知回调
typedef void (*SigNatBusTagSrcAddrNtfCB)(HSNetMod hSNetMod,u64 qwTag, u32 dwSrcIP, u16 wSrcPort);

//注册NatBus回调
typedef struct tagSigNatBusCBS
{
	SigNatBusAddrMapingNtfCB m_pSigNatBusAddrMapingNtfCB;
	SigNatBusComInvalidNtfCB m_pSigNatBusComInvalidNtfCB;
	SigNatBusTagSrcAddrNtfCB m_pSigNatBusTagSrcAddrNtfCB;
}TSigNatBusCBS;

//设置回调
SIGRET SigNatBusCBSReg(HSNetMod hSNetMod,TSigNatBusCBS* ptSigNatBusCBS);

//创建探测节点，节点类型
SIGRET SigNatBusNodeCreate(HSNetMod hSNetMod,u32 dwNodeType);
//删除探测节点
SIGRET SigNatBusNodeDel(HSNetMod hSNetMod);
//增加探测目的
SIGRET SigNatBusDstAdd(HSNetMod hSNetMod,TNetAddr tDstAddr,u64 qwPrimaryTag,u64 qwSlaveTag,u32 dwTimeOutS,u32 dwContext);
//删除探测目的
SIGRET SigNatBusDstDel(HSNetMod hSNetMod,TNetAddr tDstAddr);
//开始某个目的探测
SIGRET SigNatBusDetectStart(HSNetMod hSNetMod,TNetAddr tDstAddr);
//停止某个目的探测
SIGRET SigNatBusDetectStop(HSNetMod hSNetMod, TNetAddr tDstAddr);
//获取某个目的NAT地址
SIGRET SigNatBusPortMappingGet(HSNetMod hSNetMod,TNetAddr tDstAddr,TNetAddr *ptLocalNatAddr);

//获取版本
s8 *SNetVerGet(s8 *pchVerBuf, u32 dwLen);

//得到SIGNET错误码的解释
s8* SNetErrInfoGet(u32 dwErrno, s8 *pbyBuf, u32 dwInLen);

//SNET运行状况检查
u32 SNetHealthCheck(HSNetMod hSNetMod);

//调试接口
//打印帮助命令列表
void signethelp(void* dwTelHdl);

//打印版本
void signetver(void* dwTelHdl);

//设置打印级别
void signetdl(void* dwTelHdl,u8 byLvl);

//设置打印级别
void signetnodebug(void* dwTelHdl);

//打印调试帮助命令列表
void signetdebughelp(void* dwTelHdl);

//设置打印级别
void signetdebugset(void* dwTelHdl,u8 byMinPrtLvl,u8 byMaxPrtLvl);
//打印模块状态
void signetmdlstatus(void* dwTelHdl,u32 dwIdx);

//设置发送信令丢失率
void signetsndsigloseset(void* dwTelHdl,u32 dwIdx,u32 dwRate);
void signetsndmsgloseset(HSNetMod hSNetMod,u32 dwRate);
//设置接受信令丢失率
void signetrcvsigloseset(void* dwTelHdl,u32 dwIdx,u32 dwRate);
void signetrcvmsgloseset(HSNetMod hSNetMod,u32 dwRate);
//设置发送丢包率
void signetsndpacketloseset(void* dwTelHdl,HSig hSig,u32 byRate);

//打印客户列表
void signetclientlist(void* dwTelHdl,u16 wModIdx);

//打印客户信息
void signetclientinfo(void* dwTelHdl,u16 wModIdx,u32 dwIdx);

//打印服务信息
void signetserverinfo(void* dwTelHdl,u16 wModIdx);

//打印接受列表
void signetacceptlist(void* dwTelHdl,u16 wModIdx);

//打印接受信息
void signetacceptinfo(void* dwTelHdl,u16 wModIdx,u32 dwIdx);



//add by lee 2012-6-25
void sigcleantransfile(HSig hSig);
#ifdef __cplusplus
}
#endif
#endif

