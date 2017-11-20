/*****************************************************************************
模块名      : charegecomm.h
文件名      : charegecomm.h
相关文件    : 各模块的开发文件
文件实现功能: 提供vss监控系统保险定损行业相关的公共定义
作者        : chenhb 
版本        : V1.0  Copyright(C) 2012-2016 DS, All rights reserved.
-----------------------------------------------------------------------------
修改记录:
日  期        版本        修改人      修改内容
2012/03/03    1.0         chenhb      Create
******************************************************************************/

#ifndef _VSS_CHARGECOMM_H
#define _VSS_CHARGECOMM_H

//坐席类型
typedef enum tagAgentLevel
{
	e_AgentType_Normal = 1,		//普通坐席
	e_AgentType_Monitor= 2,     //班长坐席
	e_AgentType_Up= 3,			//上级坐席
}EAgentLevel;

//坐席工作状态
typedef enum tagAgentWorkStatus
{
	e_Agent_Free = 1,		//空闲
	e_Agent_Busy,			//忙碌
	e_Agent_WaitAddition,  //等待补充定损
	e_Agent_Offline,        //离线
}EAgentWorkStatus;

//定损设备状态
typedef enum tagChargeDevStatus
{
	e_ChargeDev_Offline = 0,	//设备下线
	e_ChargeDev_Online,			//设备上线
}EChargeDevStatus;


//定损中断类型
typedef enum tagChargeBreakType
{
	e_ChargeBreaType_PuOffline = 1,		//设备掉线，网络中断
	e_ChargeBreaType_Transfer,			//定损转接失败
}EChargeBreakType;

//定损转交方式
typedef enum tagChargeTransferType
{
	e_ChargeTrans_UpLever = 1,		//转交给上级
	e_ChargeTrans_DstAgent,			//指定给某个坐席
}EChargeTransferType;

// 定损结果, 在JLNetSdk中定义
// typedef enum tagChargeResult
// {
// 	e_ChargeRet_Complete = 1,		//定损完成
// 	e_ChargeRet_Transfer,			//转移
// 	e_ChargeRet_WaitAddition,		//待补充
// 	e_ChargeRet_Break,				//定损中断
// 	e_ChargeRet_Timeout,			//定损员操作超时
// 	e_ChargeRet_Refuse,				//定损员拒接
// 	e_ChargeRet_NotAnswer,			//无人接听
// }EChargeResult;


#endif // _VSS_CHARGEDEF_H





