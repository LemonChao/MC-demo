#ifndef APP_INNER_H
#define APP_INNER_H
typedef enum pu_state{
	e_offline =0,
	e_connected,

	e_online,
	e_dialing,
	e_charging,
	e_streaming,
	e_waitagent

}pu_state;

typedef struct st_app_manager
{
	u32 tag;
	TCommInitParam comm_param;

	void* signet_client;
	u32 inst_stack;
	u32 node_id;
	pu_state state;
}st_app_manager;

#define MAX_CONN_NUN 16
#define LISTEN_PORT 8009


#define e_ChargeRspRet_Ok   0

#define e_ChargeRspRet_NoFree 1

#define e_ChargeRspRet_NotAnswer 2

#define e_ChargeRspRet_Refuse 3

#define e_ChargeRspRet_ErrReportNo 4

#define e_ChargeRspRet_ReportNo_AgentBusy 5

#define e_ChargeRspRet_SysBusy		6
// added by fzp 
#define e_ChargeRspRet_NoFree_Waiting_Cnt 7

#define e_ChargeRspRet_Redial_Later 14
#define e_ChargeRspRet_NoOnlineAgent 15
// end
#define  e_ChargeRet_Complete 0
#define  e_ChargeRet_WaitAddition 11
#define  e_ChargeRet_Break 12
#define  e_ChargeRet_Timeout 13

u32 init_netev();

void Make_TJLPuLoginReq( TJLPuLoginReq* ptMsg );
void Make_TJLPuLogoutReq(TJLPuLogoutReq *msg);
void Make_TJLPuChargeCallReq(TJLPuChargeCallReq *msg, char *reportNo);
void Make_TJLPuRealMediaSwitchRsp(TJLPuRealMediaSwitchRsp *msg);
void Make_TJLPuBackCallRsp(TJLBackCallrsp *msg, int agentid, int contextid, char *reportNum, char *agentInfo);
void Make_TJLPuBackCallCancelRsp(TJLBackCallCancelRsp *msg, int agentid, int contextid);
#endif
