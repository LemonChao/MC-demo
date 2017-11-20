/*****************************************************************************
模块名  ： avnet
文件名  ： avnet.h
相关文件：avnet.c
文件实现功能：AVNET头文件
作者    ：EastWood
版本    ：RC00
版权    ：FOCUS公司
------------------------------------------------------------------------------
修改记录:
日  期      	版本        修改人      修改内容
26/12/2006 	    1.0         EastWood    创建  
*****************************************************************************/

#ifndef __AVNET_H
#define __AVNET_H
#ifdef __cplusplus
extern "C" {
#endif

#define AVNET_VER "AVNET V3R1 I090804R090804"
#define AVOK  0   //成功
#define AVMODNOTEXISTERR (AVNET_ERRBASE+1)//不存在该模块
#define AVTRANSNOTEXISTERR (AVNET_ERRBASE+2)//不存在该TRANS
#define	AVPOINTERNULLERR  (AVNET_ERRBASE+3) //指针为空
#define AVMEMERR   (AVNET_ERRBASE+4)   //内存不足
#define	AVBINDERR  (AVNET_ERRBASE+5)   //绑定失败
#define	AVSEMERR   (AVNET_ERRBASE+6)   //信号量出错
#define	AVTIMEERR  (AVNET_ERRBASE+7)   //创建定时器出错
#define AVBUFFULLERR (AVNET_ERRBASE+8)  //缓存满
#define	AVSIZELONGERR (AVNET_ERRBASE+9)  //太长
#define	AVPARAMERR    (AVNET_ERRBASE+10)  //参数出错
#define	AVPORTCONFLICTERR (AVNET_ERRBASE+11) //端口冲突
#define	AVTHREADERR    (AVNET_ERRBASE+12) //创建线程出错
#define	AVTRANSEXITERR    (AVNET_ERRBASE+13) //TRANS退出出错
#define	AVSNDERR    (AVNET_ERRBASE+14) //发送出错
#define	AVTRANSTYPEERR    (AVNET_ERRBASE+15) //类型出错

#define	AVUNKNOWN   (AVNET_ERRBASE+255) //未知错误
#define TAG_ALL    0xffff    //所有TAG
typedef u32		HAVMOD;
typedef u32		HAVTrans;   
typedef u32     AVRET;

//NatBus节点类型
#define AVNATBUS_NODETYPE_SERVICE      (u32)1
#define AVNATBUS_NODETYPE_CLIENT    (u32)2

//发送统计
typedef struct tagAVSndStatis
{
	u32 m_dwSndFrmNum;     //发送帧数
	u32 m_dwSndPackNum;	   //发送包数
	u32 m_dwSndBytes;      //发送字节数
	u32 m_dwMemDropFrmNum; //缓存满丢帧数
	u32 m_dwMemDropPackNum;    //缓存满丢包数
	u32 m_dwMemDropBytes;      //缓存满丢字节数
	u32 m_dwNetDropFrmNum;     //网络丢帧数
	u32 m_dwNetDropPackNum;    //网络丢包数
	u32 m_dwNetDropBytes;      //网络丢字节数
	u32 m_dwNDropPRate5S;			//最近5秒中的丢包率
    u32 m_dwNDropPRate30S;			//最近30秒中的丢包率
	u32 m_dwNDropPRate5M;			//最近5分钟的丢包率
	u32 m_dwNBitRate5S;				//最近5秒中的码率
	u32 m_dwNBitRate30S;			//最近30秒中的码率
	u32 m_dwNBitRate5M;				//最近5分中的码率
	u32 m_dwSndFrmRate;             //发送帧率
}TAVSndStatis;

//接收统计
typedef struct tagAVTransStatis
{
	u32 m_dwRcvFrmNum;
	u32 m_dwRcvPackNum;	
	u32 m_dwRcvBytes;
	u32 m_dwLostFrmNum;
	u32 m_dwLostPackNum;
	u32 m_dwLostBytes;
	u32 m_dwNDropPRate5S;			//最近5秒中的丢包率
    u32 m_dwNDropPRate30S;			//最近30秒中的丢包率
	u32 m_dwNDropPRate5M;			//最近5分钟的丢包率
	u32 m_dwNBitRate5S;				//最近5秒中的码率
	u32 m_dwNBitRate30S;			//最近30秒中的码率
	u32 m_dwNBitRate5M;				//最近5分中的码率
	u32 m_dwRcvFrmRate;
}TAVRcvStatis;


//接收回调
typedef void (*FrameCallBack)(HAVTrans hAVTrans,TAVRawFrame *ptAVRawFrame, u16 wTag, u32 awPackLen[],u16 wPackTotal,u32 dwContext);
typedef void (*RtpPackCallBack)(HAVTrans hAVTrans,TAVPack *ptAVRtpPack, u16 wTag,u32 dwContext);
typedef void (*PackLostAlarmCallBack)(HAVTrans hAVTrans,u8 byLostRate,u32 dwContext);
typedef void (*NetBandCallBack)(HAVTrans hAVTrans,u32 dwNetBand,u32 dwContext);


//AVTrans初始化结构
typedef struct tagAVTransParam
{
	u16					m_wBindPort;		//绑定的端口
	u16                 m_wTag;             //标识
	u32					m_dwMaxFrmSize;     //最大帧长
	u32					m_dwMaxPackSize;		// 最大包长
	u32					m_dwSndNetBand;        //发送带宽
	u32					m_dwMaxSndAddr;		//最多发送的目的数, 发送端使用
	u32					m_dwSndBufSize;		//发送缓冲大小, 发送端使用
	u32					m_dwReSndBufSize;	//重传缓冲大小, 发送端使用
	u32					m_dwRcvBufSize;     //接收缓冲大小, 接收端使用
	FrameCallBack		m_pFrmPrc;			//帧回调, 接收端使用
	RtpPackCallBack		m_pPackPrc;			//包回调, 接收端使用
	NetBandCallBack     m_pNetBandPrc;      //带宽回调,发送端使用
	u32                 m_dwContext;       //回调上下文
}TAVTransParam;

//AVMemPortTrans初始化结构
typedef struct tagAVMemPortTransParam
{
	HANDLE m_hMemPortMdl;   //内存端口模块句柄
	u32					m_dwMemPort;		//内存端口
	u32					m_dwRcvBufSize;     //接收缓冲大小, 接收端使用
	FrameCallBack		m_pFrmPrc;			//帧回调, 接收端使用
	RtpPackCallBack		m_pPackPrc;			//包回调, 接收端使用
	u32                 m_dwContext;       //回调上下文
}TAVMemPortTransParam;

//AVNET模块初始化
AVRET AVModInit(TCommInitParam tCommInitParam,HAVMOD *phAVMod);
//AVNET模块退出
AVRET AVModExit(HAVMOD hAVMod);
//创建AVTrans
AVRET AVTransCreate(HAVMOD hAVMod, TAVTransParam tAVTransParam, HAVTrans *phAVTrans);
//创建内存端口Trans
AVRET AVMemPortTransCreate(HAVMOD hAVMod, TAVMemPortTransParam tAVMemPortTransParam,HAVTrans *phAVTrans);
//删除AVTrans
AVRET AVTransDelete(HAVMOD hAVMod, HAVTrans hAVTrans);
//获取AVTrans初始化信息
AVRET AVTransInitInfoGet(HAVTrans hAVTrans, TAVTransParam *ptAVTransParam);
//获取内存端口Trans初始化信息
AVRET AVMemPortTransInitInfoGet(HAVTrans hAVTrans, TAVMemPortTransParam *ptAVMemPortTransParam);
//设置某个发送目的
AVRET AVSndDstAddrSet(HAVTrans hAVTrans, u32 dwIdx, TNetAddr tDstNetParam,u16 wTag); 
//获取某个发送目的
AVRET AVSndDstAddrGet(HAVTrans hAVTrans, u32 dwIdx, TNetAddr *ptDstNetParam,u16 *pwTag); 
//清除某个发送目的
AVRET AVSndDstAddrClear(HAVTrans hAVTrans,u32 dwIdx);

//发送包
AVRET AVFramePacksSnd(HAVTrans hAVTrans, TAVPack atAVPack[],u16 wPackNum);

//发送帧
AVRET AVRawFrameSnd(HAVTrans hAVTrans, TAVRawFrame *ptAVRawFrame);

//设置发送加密(未实现)
AVRET AVSndEncryptSet(HAVTrans hAVTrans, u8 *pbyKeyBuf, u32 dwKeyLen, u8 byEncType);
//获取发送统计
AVRET AVSndGetStatis(HAVTrans hAVTrans, u32 dwIdx, TAVSndStatis *ptAVSndStatis);
//设置发送重传
AVRET AVSndRepeatSet(HAVTrans hAVTrans,BOOL bOpen);
//设置发送丢包率
AVRET AVSndLoseRateSet(HAVTrans hAVTrans,u8 byRate);
//开始接受
AVRET AVRcvStart(HAVTrans hAVTrans);
//停止接受
AVRET AVRcvStop(HAVTrans hAVTrans);
//获取接受统计
AVRET AVRcvGetStatis(HAVTrans hAVTrans,TAVRcvStatis *ptAVRcvStatis);
//设置接受重传
AVRET AVRcvRepeatSet(HAVTrans hAVTrans,BOOL bOpen);
//设置接受转发目的
AVRET AVRcvRelaySet(HAVTrans hAVTrans, TNetAddr tTransSndAddr);
//获取接受转发目的
AVRET AVRcvRelayGet(HAVTrans hAVTrans, TNetAddr *ptTransSndAddr);
//开始接受转发
AVRET AVRcvRelayStart(HAVTrans hAVTrans);
//停止接受转发
AVRET AVRcvRelayStop(HAVTrans hAVTrans);
//设置丢包告警
AVRET AVRcvPackLostAlarmSet(HAVTrans hAVTrans,u32 dwCheckItvlS,u8 byThreshold,PackLostAlarmCallBack pPackLostAlarmPrc,u32 dwContext);
//设置发送丢包率
AVRET AVRcvLoseRateSet(HAVTrans hAVTrans,u8 byRate);
//设置解密(未实现)
AVRET AVTransDecryptSet(HAVTrans hAVTrans, u8 *pbyKeyBuf, u32 dwKeyLen, u8 byEncType);

//Nat地址映射通知回调
//若映射发生变化，也通过该回调告知重新映射后的地址
typedef void (*AVNatBusAddrMapingNtfCB)(HAVTrans hAVTrans, TNetAddr tDstAddr, TNetAddr tLocalNatAddr, u32 dwContext);

//无法和对端建立通信通知回调（在指定超时时间内无响应）
//超时后，NatBus将该目的设置为空闲状态不再进行检测，若需要再检测，调用NatBusDetectStart
typedef void (*AVNatBusComInvalidNtfCB)(HAVTrans hAVTrans,TNetAddr tDstAddr, u32 dwContext);

//Tag源地址通知回调
typedef void (*AVNatBusTagSrcAddrNtfCB)(HAVTrans hAVTrans,u64 qwTag, u32 dwSrcIP, u16 wSrcPort);

//注册NatBus回调
typedef struct tagAVNatBusCBS
{
	AVNatBusAddrMapingNtfCB m_pAVNatBusAddrMapingNtfCB;
	AVNatBusComInvalidNtfCB m_pAVNatBusComInvalidNtfCB;
	AVNatBusTagSrcAddrNtfCB m_pAVNatBusTagSrcAddrNtfCB;
}TAVNatBusCBS;

//设置回调
AVRET AVNatBusCBSReg(HAVMOD hAVMod,TAVNatBusCBS* ptAVNatBusCBS);

//创建探测节点，节点类型
AVRET AVNatBusNodeCreate(HAVTrans hAVTrans,u32 dwNodeType);
//删除探测节点
AVRET AVNatBusNodeDel(HAVTrans hAVTrans);
//增加探测目的
AVRET AVNatBusDstAdd(HAVTrans hAVTrans,TNetAddr tDstAddr, u64 qwPrimaryTag,u64 qwSlaveTag, u32 dwTimeOutS, u32 dwContext);
//删除探测目的
AVRET AVNatBusDstDel(HAVTrans hAVTrans,TNetAddr tDstAddr);
//开始某个目的探测
AVRET AVNatBusDetectStart(HAVTrans hAVTrans,TNetAddr tDstAddr);
//停止某个目的探测
AVRET AVNatBusDetectStop(HAVTrans hAVTrans, TNetAddr tDstAddr);
//获取某个目的NAT地址
AVRET AVNatBusPortMappingGet(HAVTrans hAVTrans,TNetAddr tDstAddr,TNetAddr *ptLocalNatAddr);



//获取版本
s8* AVVerGet(IN OUT s8 *pchVerBuf, IN u32 dwLen);

//得到AVNET错误码的解释
s8* AVErrInfoGet(u32 dwErrno, s8 *pbyBuf, u32 dwInLen);

//AVNET运行状况检查
u32 AVHealthCheck(HAVMOD hAVMod);

//调试接口
//打印帮助命令列表
void avnethelp(void* dwTelHdl);
//打印调试帮助
void avnetdebughelp(void* dwTelHdl);
//打印版本
void avnetver(void* dwTelHdl);
//设置打印级别
void avnetdl(void* dwTelHdl,u8 byLvl);
//设置打印级别
void avnetnodebug(void* dwTelHdl);
//设置打印级别
void avnetdebugset(void* dwTelHdl,u8 byMinPrtLvl,u8 byMaxPrtLvl);
//打印模块状态
void avnetmdlstatus(void* dwTelHdl,u32 dwIdx);
//打印收发列表
void avnettranslist(void* dwTelHdl);
//打印发送状态
void avnetsndstatus(void* dwTelHdl,u32 dwIdx);
//打印发送统计
void avnetsndstatis(void* dwTelHdl,u32 dwIdx);
//打印接受状态
void avnetrcvstatus(void* dwTelHdl,u32 dwIdx);
//打印接受统计
void avnetrcvstatis(void* dwTelHdl,u32 dwIdx);
//转发设置
void avnetrelay(void* dwTelHdl,u32 dwIdx, u32 dwAddrNetEndian, u16 wPort);
//设置发送丢包率
void avsndpacketloseset(void* dwTelHdl,u32 dwIdx,u8 byRate);
//设置接受丢包率
void avrcvpacketloseset(void* dwTelHdl,u32 dwIdx,u8 byRate);
//开始限制带宽
void avrcvrestrictbandstart(void* dwTelHdl,u32 dwIdx,u32 dwBand);
//停止限制带宽
void avrcvrestrictbandstop(void* dwTelHdl,u32 dwIdx);
//设置倍速发
void avsndbandmultiple(void* dwTelHdl,u32 dwIdx,u32 dwBandMultiple);

//发送目的信息
typedef struct tagSndDstInfo
{
	u32 m_dwUsed;   //是否在使用
	u32 m_dwIP;     //发送目的IP
	u16 m_wPort;    //发送目的端口
	TAVSndStatis m_tAVSndStatis;   //发送统计
	u32 m_dwRcvBand;  //当前接受带宽
	u32 m_dwCurSndBand;  //当前发送带宽
	u32 m_dwMaxNetBand;  //最大网络带宽
	u32 m_dwAvgNetBand;  //平均网络带宽
	u32 m_dwMinNetBand;  //最小网络带宽
	u32 m_qwLResndStatMs;  //上一次重传统计的时间
	u32 m_dwLResndStatSndPackNum;  //上一次重传统计的包数
	u32 m_dwLResndStatResndPackNum;  //上一次重传统计的重传包数

}TSndDstInfo;

//发送Trans信息
typedef struct tagSndTransInfo
{
	u16 m_wBindPort; //发送端口
	u32 m_dwSndBufSize;  //发送缓存
	u32 m_dwTotalSndCnt;   //发送队列总个数
	u32 m_dwUsedSndCnt;    //发送队列使用个数
	u32 m_dwReSndBufSize;  //重传发送缓存
	u32 m_dwTotalReSndCnt;  //重传队列总个数
	u32 m_dwUsedReSndCnt;   //重传队列使用个数
	u32 m_dwSndNetBand;     //发送带宽
	u32 m_dwMaxFrmSize;     //最大帧长
	u32 m_dwMaxPackSize;    //最大包长
	u32 m_bReSnd;           //发送重传
	u8 m_bySndSimLoseRate;     //发送模拟丢包率
	u32 m_dwSndBandMultiple;   //设置倍速发
	u32 m_dwBig200SndItvlCnt;  //发送间隔大于200
	u32 m_dwBig100SndItvlCnt;  //发送间隔大于100
	u32 m_dwLess100SndItvlCnt;  //发送间隔小于100;
	u8 m_bySndTimeSeq;       //发送时间序号
	u8 m_byLastSndTimeSeq;   //上一个发送时间序号
	u64 m_qwLNBStatMs;       //上一次带宽统计的时间
	u32 m_dwLNBStatSndBytes;  //上一次带宽统计字节数
	u32 m_dwSndBytes;         //发送字节数
	u32 m_dwLastSndBand;      //上一个发送带宽
	u32 m_dwMaxSndAddr;     //最大目的数
	TSndDstInfo m_atSndDstInfo[64];   //发送目的信息

}TSndTransInfo;

//接收Trans信息
typedef struct tagRcvTransInfo
{
	u16 m_wBindPort;  //接受端口
	u32 m_dwMaxFrmSize;   //最大帧长
	u32 m_dwMaxPackSize;   //最大包长
	u32 m_dwRcvBufSize;    //接受缓存
	u32 m_dwTotalRcvCnt;   //接受队列总个数
	u32 m_dwUsedRcvCnt;    //接受队列使用个数
	BOOL m_bRcvStart;      //接受是否开始
	BOOL m_bRcvRepeatStart;   //接受重传是否开始
	BOOL m_bRcvRelayStart;    //转发是否开始
	u32 m_dwRelayIP;          //转发IP
	u16 m_wRelayPort;         //转发端口
	u8 m_byRcvSimLoseRate;    //接受模拟丢包率
	u32 m_dwLastRcvFrameId;   //上一帧
	u32 m_dwRcvFrmRate;       //接受帧率
	u32 m_dwRcvFrmNum;        //接受帧数
	u32 m_dwRcvPackNum;       //接受包数
	u32 m_dwRcvBytes;         //接受字节数
	u32 m_dwLostFrmNum;       //丢帧数
	u32 m_dwLostPackNum;      //丢包数
	u32 m_dwLostBytes;        //丢字节数
	u32 m_dwNDropPRate5S;     //最近5秒中的丢包率
	u32 m_dwNDropPRate30S;    //最近30秒中的丢包率
	u32 m_dwNDropPRate5M;     //最近5分钟的丢包率
	u32 m_dwRcvBand;          //当前接受带宽
	u32 m_dwNBitRate5S;       //最近5秒中的码率
	u32 m_dwNBitRate30S;      //最近30秒中的码率 
	u32 m_dwNBitRate5M;       //最近5分中的码率 
	u32 m_dwCheckItvlS;       //丢包告警检测间隔 
	u8 m_byThreshold;         //丢包告警阀值 
	u8 m_byLostRate;          //当前丢包率
	u32 m_dwFrameJumpCnt;     //帧跳变数
	u8 m_byLastSndTimeSeq;    //上一个发送时间序号
	u32 m_dwMaxNetBand;       //最大网络带宽
	u32 m_dwCurNetBand;       //当前网络带宽
	u32 m_dwMinNetBand;       //最小网络带宽
	u64 m_qwLastPackRcvTimeUs; //上一个包的接受时间
	u32 m_dwPackRcvTimeDiff;    //包接受时间差
	u32 m_dwRcvTimeDiffCnt;     //接受时间差个数 
	u32 m_dwRcvTimeBytes;       //接受时间内字节数 
	u64 m_qwLastBandFeedBackMs;  //上一次回馈的时间

}TRcvTransInfo;

//获取发送Trans信息
u32 AVSndTransInfoGet(IN HAVTrans hAVSndTrans, OUT TSndTransInfo *ptSndTransInfo);

//获取接收Trans信息
u32 AVRcvTransInfoGet(IN HAVTrans hAVRcvTrans, OUT TRcvTransInfo *ptRcvTransInfo);

#ifdef __cplusplus
}
#endif
#endif

