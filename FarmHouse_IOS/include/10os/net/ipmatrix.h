#ifndef __IPMATRIX_H
#define __IPMATRIX_H
#ifdef __cplusplus
extern "C" {
#endif

typedef void* HIMMdl;

#define IM_VER "IPMATRIX V3R1 I080911R080911"
#define IMOK 					0   					//成功
#define IMUNKNOWERR 			(IPMATRIX_ERRBASE+1)   	//未知错误
#define IMMEMERR   				(IPMATRIX_ERRBASE+2)   	//内存不足
#define IMPARAMERR   			(IPMATRIX_ERRBASE+3)   	//参数出错
#define	IMCTHREADERR  			(IPMATRIX_ERRBASE+4)  	//创建线程出错
#define	IMCSEMERR     			(IPMATRIX_ERRBASE+5)  	//创建信号量出错
#define IMCSOCKETERR  			(IPMATRIX_ERRBASE+6)  	//创建套接字错误
#define	IMNORULEERR   			(IPMATRIX_ERRBASE+7) 	//RULE不存在
#define	IMINBUFLACKERR    		(IPMATRIX_ERRBASE+8) 	//输入BUF的长度不够
#define	IMHAVEINITERR    		(IPMATRIX_ERRBASE+9)	//已初始化
#define IMNOTINITERR     		(IPMATRIX_ERRBASE+10)	//未初始化
#define IMSOCKETSTARTUPERR     	(IPMATRIX_ERRBASE+11)	//启动套接字失败
#define IMRULEFULLERR       	(IPMATRIX_ERRBASE+12)	//规则满
#define IMPOINTERNULLERR    	(IPMATRIX_ERRBASE+13)  	//指针为空
#define IMCTIMERERR    			(IPMATRIX_ERRBASE+14)  	//创建定时器出错
#define IMRULEEXISTERR    		(IPMATRIX_ERRBASE+15)  	//RULE已存在
#define IMSNDERR    			(IPMATRIX_ERRBASE+16)  	//发送出错
#define IMCEPOLLEERR 			(IPMATRIX_ERRBASE+17) 	//创建epoll失败
#define IMSETEPOLLEERR 			(IPMATRIX_ERRBASE+18) 	//设置epoll失败
#define	IMPORTCONFLICTERR       (IPMATRIX_ERRBASE+19)   //端口冲突

static const s8* g_achIMErrInfo[] = {
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
 "创建定时器出错",
 "RULE已存在",
 "发送出错",
 "创建epoll失败",
 "设置epoll失败",
 "端口冲突",
};
	
//IPMATRIX初始化
u32  IMInit(TCommInitParam tCommInitParam,TIMInitParam *ptIMInitParam,HIMMdl *phIMMdl);

//增加码流交换规则
u32 IMRuleAdd(HIMMdl hIMMdl,u32 dwRuleId,TRuleInfo *ptRuleInfo);

//删除规则
u32 IMRuleDel(HIMMdl hIMMdl,u32 dwRuleId);

//删除规则
u32 IMRuleRDel(HIMMdl hIMMdl,TRuleInfo *ptRuleInfo);

//获取所有交换规则ID
u32 IMRuleIdAllGet(HIMMdl hIMMdl,u32 *pdwArray, u32 dwArrayLen, u32 *pdwRuleNumer);

//获取下一个规则
u32 IMRuleInfoNextNGet(HIMMdl hIMMdl,u32 dwRuleId,u32 dwMaxRuleNum,TRuleInfo atRuleInfo[],u32 adwRuleId[],u32 *pdwRealRuleNum);

//获取规则信息
u32 IMRuleInfoGet(HIMMdl hIMMdl,u32 dwRuleId,TRuleInfo *ptRuleInfo);

//获取规则状态
u32 IMRuleStatisGet(HIMMdl hIMMdl,u32 dwRuleId,  TRuleStatis *ptStatis);

//获取规则状态
u32 IMRuleStatisRGet(HIMMdl hIMMdl,TRuleInfo *ptRuleInfo,TRuleStatis *ptStatis);

//关闭IPMATRIX
u32 IMClose(HIMMdl hIMMdl);	

//获取版本
s8* IMVerGet(s8 *pchVerBuf, u32 dwLen);

//得到IM错误码的解释
s8* IMErrInfoGet(u32 dwErrno, s8 *pbyBuf, u32 dwInLen);

//IM运行状况检查
u32 IMHealthCheck(void);

//打印帮助命令列表
void imhelp(void* dwTelHdl);

//打印调试帮助
void imdebughelp(void* dwTelHdl);

//设置打印级别
void imdl(void* dwTelHdl,u8 byLvl);

//设置无调试打印
void imnodebug(void* dwTelHdl);

//设置调试打印级别
void imdebugset(void* dwTelHdl,u8 byPrtType,u8 byMinPrtLvl,u8 byMaxPrtLvl);

//打印模块列表
void immdllist(void* dwTelHdl);

//打印所有交换规则
void imruledump(void* dwTelHdl,u32 dwMdlIdx);

//打印指定id的交换规则
void imprintrule(void* dwTelHdl,u32 dwMdlIdx, u32 dwRuleId);

BOOL IMPrintRulebyMdl(void* dwTelHdl,  void *handle, u32 dwRuleId);

//打印使用的套接字
void imsockdump(void* dwTelHdl,u32 dwMdlIdx);

//打印版本
void imver(void* dwTelHdl);

//打印标签映射地址列表
void imtagmapaddrlist(void* dwTelHdl,u32 dwMdlIdx);

//打印探测节点
void imnatbusnodeshow(void* dwTelHdl,u32 dwMdlIdx);

//打印节点上的通信信息
void imnatbuscomshow(void* dwTelHdl,u32 dwMdlIdx);

//清除指定socket的包统计
void imclearsockpackstat(u32 dwMdlIdx);

void imruledump_port(u32 dwMdlIdx);

#ifdef __cplusplus
}
#endif
#endif

