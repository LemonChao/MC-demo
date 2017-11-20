/*****************************************************************************
模块名  ： dipmatrix
文件名  ： dipmatrix.h
相关文件：
文件实现功能：DIPMATRIX头文件
作者    ：EastWood
版本    ：RC00
版权    ：FOCUS公司
------------------------------------------------------------------------------
修改记录:
日  期      	版本        修改人      修改内容
26/12/2006 	    1.0         EastWood    创建  
*****************************************************************************/
#ifndef __DIPMATRIX_H
#define __DIPMATRIX_H

#ifdef __cplusplus
extern "C" {
#endif

#define DIM_VER "DIPMATRIX V3R0 RC10 b20071130 I071130R071130"
	
#define DIMOK 0   //成功
#define DIMUNKNOWERR (DIPMATRIX_ERRBASE+1)   //未知错误
#define DIMMEMERR   (DIPMATRIX_ERRBASE+2)   //内存不足
#define DIMPARAMERR   (DIPMATRIX_ERRBASE+3)   //参数出错
#define	DIMCTHREADERR  (DIPMATRIX_ERRBASE+4)  //创建线程出错
#define	DIMCSEMERR     (DIPMATRIX_ERRBASE+5)  //创建信号量出错
#define DIMCSOCKETERR  (DIPMATRIX_ERRBASE+6)  //创建套接字错误
#define	DIMNORULEERR   (DIPMATRIX_ERRBASE+7)  //RULE不存在
#define	DIMINBUFLACKERR    (DIPMATRIX_ERRBASE+8) //输入BUF的长度不够
#define	DIMHAVEINITERR    (DIPMATRIX_ERRBASE+9) //已初始化
#define DIMNOTINITERR     (DIPMATRIX_ERRBASE+10)  //未初始化
#define DIMSOCKETSTARTUP     (DIPMATRIX_ERRBASE+11) //启动套接字失败
#define DIMRULEFULLERR       (DIPMATRIX_ERRBASE+12) //规则满
#define DIMPOINTERNULLERR    (IPMATRIX_ERRBASE+13)  //指针为空

static const s8* g_achDIMErrInfo[] = {
 "未知错误",
 "内存不足",
 "参数出错",
 "创建线程出错",
 "创建信号量出错",
 "创建套接字错误", 
 "RULE不存在",
 "输入BUF的长度不够",
 "已初始化",
 "未初始化",
 "启动套接字失败",
 "规则满",
 "指针为空",
};

//链路管理回调函数
typedef void  (*ManageCallBack)( u32 dwNodeId,u16 wEvent,u32 dwRuleId,u32 dwErrorId);



//DIM服务器初始化，服务端只需调用这一个接口
u32 DIMSvrCreate(u16 wPort, RcvDataCallBack pDataPrc);

//节点数初始化，客户端调用
u32 DIMNodeNumInit(u32 dwNodeNum);

//链接DIM服务器, 成功的话，pdwNodeId返回一个非0的节点号
u32 DIMConnect(u32 *pdwNodeId, u32 dwIp, u16 wPort, u32 dwTimeOut, ManageCallBack pManage);

//断链DIM服务器
u32 DIMDisConnect(u32 dwNodeId);


//DIPMATRIX初始化
u32  DIMInit(TCommInitParam tCommInitParam,u32 dwNodeId, TIMInitParam *ptIMInitParam);


//增加码流交换规则, dwNodeId为0表示在本地建立规则
u32 DIMRuleAdd(u32 dwNodeId, u32 *pdwRuleId, TRuleInfo *ptRuleInfo);

//删除规则
u32  DIMRuleDel(u32 dwNodeId, u32 dwRuleId);

//获取指定节点的所有交换规则ID
u32  DIMRuleIdAllGet(u32 dwNodeId, u32 *pdwArrary, u32 dwArrayLen, u32 *pdwRuleNumer);

//获取规则的统计
u32  DIMRuleInfoGet(u32 dwNodeId, u32 dwRuleId,  TRuleInfo *ptRuleInfo);

//获取指定节点的规则统计
u32  DIMRuleStatisGet(u32 dwNodeId, u32 dwRuleId,  TRuleStatis *ptStatis);	

//关闭IPMATRIX
BOOL  DIMClose(u32 dwNodeId);	

//获取版本
s8* DIMVerGet(s8 *pchVerBuf, u32 dwLen);

//得到IM错误码的解释
s8* DIMErrInfoGet(u32 dwErrno, s8 *pbyBuf, u32 dwInLen);	

//DIM运行状况检查
BOOL DIMHealthCheck(void);  

//打印所有交换规则, 仅本地平台
void dimruledump(void* dwTelHdl);

//打印使用的套接字, 仅本地平台
void dimsockdump(void* dwTelHdl);

//打印版本
void dimver(void* dwTelHdl);

//打印帮助命令列表
void dimhelp(void* dwTelHdl);

//打印调试帮助
void dimdebughelp(void* dwTelHdl);

//设置打印级别
void dimdl(void* dwTelHdl,u8 byLvl);

//设置无调试打印
void dimnodebug(void* dwTelHdl);

//设置调试打印级别
void dimdebugset(void* dwTelHdl,u8 byPrtType,u8 byMinPrtLvl,u8 byMaxPrtLvl);



#ifdef __cplusplus
}
#endif
#endif
