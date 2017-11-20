/*****************************************************************************
ģ����      : charegecomm.h
�ļ���      : charegecomm.h
����ļ�    : ��ģ��Ŀ����ļ�
�ļ�ʵ�ֹ���: �ṩvss���ϵͳ���ն�����ҵ��صĹ�������
����        : chenhb 
�汾        : V1.0  Copyright(C) 2012-2016 DS, All rights reserved.
-----------------------------------------------------------------------------
�޸ļ�¼:
��  ��        �汾        �޸���      �޸�����
2012/03/03    1.0         chenhb      Create
******************************************************************************/

#ifndef _VSS_CHARGECOMM_H
#define _VSS_CHARGECOMM_H

//��ϯ����
typedef enum tagAgentLevel
{
	e_AgentType_Normal = 1,		//��ͨ��ϯ
	e_AgentType_Monitor= 2,     //�೤��ϯ
	e_AgentType_Up= 3,			//�ϼ���ϯ
}EAgentLevel;

//��ϯ����״̬
typedef enum tagAgentWorkStatus
{
	e_Agent_Free = 1,		//����
	e_Agent_Busy,			//æµ
	e_Agent_WaitAddition,  //�ȴ����䶨��
	e_Agent_Offline,        //����
}EAgentWorkStatus;

//�����豸״̬
typedef enum tagChargeDevStatus
{
	e_ChargeDev_Offline = 0,	//�豸����
	e_ChargeDev_Online,			//�豸����
}EChargeDevStatus;


//�����ж�����
typedef enum tagChargeBreakType
{
	e_ChargeBreaType_PuOffline = 1,		//�豸���ߣ������ж�
	e_ChargeBreaType_Transfer,			//����ת��ʧ��
}EChargeBreakType;

//����ת����ʽ
typedef enum tagChargeTransferType
{
	e_ChargeTrans_UpLever = 1,		//ת�����ϼ�
	e_ChargeTrans_DstAgent,			//ָ����ĳ����ϯ
}EChargeTransferType;

// ������, ��JLNetSdk�ж���
// typedef enum tagChargeResult
// {
// 	e_ChargeRet_Complete = 1,		//�������
// 	e_ChargeRet_Transfer,			//ת��
// 	e_ChargeRet_WaitAddition,		//������
// 	e_ChargeRet_Break,				//�����ж�
// 	e_ChargeRet_Timeout,			//����Ա������ʱ
// 	e_ChargeRet_Refuse,				//����Ա�ܽ�
// 	e_ChargeRet_NotAnswer,			//���˽���
// }EChargeResult;


#endif // _VSS_CHARGEDEF_H





