/*****************************************************************************
模块名  ： ipmatrix
文件名  ： ipmatrix.h
相关文件：
文件实现功能：IPMATRIX头文件
作者    ：EastWood
版本    ：RC00
版权    ：FOCUS公司
------------------------------------------------------------------------------
修改记录:
日  期      	版本        修改人      修改内容
26/12/2006 	    1.0         EastWood    创建  
*****************************************************************************/
#ifndef __IPMATRIXDEF_H
#define __IPMATRIXDEF_H

#ifdef __cplusplus
extern "C" {
#endif
	

#define RULESRC_RCVPORT			1		//根据接收端口转发
#define RULESRC_SRCADDR			2		//根据源地址转发
#define RULESRC_TAG				3		//根据标签转发

#define RULEDST_RMTADDR			1		//发送到远端地址
#define RULEDST_LOCMEM			2		//发送到本地，即要调用回调函数
#define RULEDST_TAG             3       //发送到标签对应的地址

typedef struct tagAddr
{
	u32 m_dwIp;
	u16 m_wPort;
}TAddr;

typedef union taguRuleSrc
{
	u16		m_wRcvPort;		   //接收端口
	u64		m_qwTagId;		   //标签
	TAddr	m_tSrcAddr;		   //源地址
}URuleSrc;

typedef struct tagRuleSrcInfo
{
	u8			m_byRuleSrcType; //码流交换的接收规则类型
	URuleSrc	m_uRuleSrc;      //具体的接收规则
}TRuleSrcInfo;

typedef union taguRuleDst
{
	u16   m_wMemPort;   //内存端口号, RULEDST_LOCMEM (发送到本地)时使用, 具体含义由调用者解释
	TAddr m_tDstAddr;
	u64		m_qwTagId;		   //标签
}URuleDst;


typedef struct tagRuleDstInfo
{
	u8			m_byRuleDstType; //码流交换的发送规则类型
	URuleDst	m_uRuleDst;      //具体的发送规则
}TRuleDstInfo;


typedef struct tagRuleInfo
{
	TRuleSrcInfo m_tRuleSrcInfo;  //源规则
	TRuleDstInfo m_tRuleDstInfo;  //目的规则
	u32 m_dwRuleContext;  //规则上下文
}TRuleInfo;

typedef struct tagRuleStatis
{
	u32 m_dwRcvPacketNum;   //接受包数
	u32 m_dwSndPacketNum;   //发送包数
}TRuleStatis;

typedef void (*RcvDataCallBack)(u32 dwRuleId,TRuleSrcInfo *ptRuleSrcInfo,u8 *pData,u32 dwDataLen);

typedef struct tagIMInitParam
{
	u16 m_wRuleMaxNumber; //允许的码流交换规则最大总数
    u16 m_wPortRuleSrcAndTag;   //按源和标签转发的接受端口
    u16 m_wRuleSrcNumber; //允许按源转发的规则的最大数
	u16 m_wRuleTagNumber; //允许按标签转发的规则的最大数
    u16 m_wRulePortStart; //按端口转发的起始端口
    u16 m_wRulePortEnd;  //按端口转发的终止端口
    RcvDataCallBack m_pRcvDataPro;  //回调函数
}TIMInitParam;

#ifdef __cplusplus
}
#endif
#endif
