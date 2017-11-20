#include "jl_main.h"

/**
 charge 库的初始化
 
 @param config 初始化参数
 
 @return 0:success, 1:faild
 */
int jinglian_charge_init(system_config_t* config);


/**
 charge 库的deinit
 
 @return 0:success, 1:faild
 */
int jinglian_charge_deinit();


/**
 charge 库的配置
 
 @param config 配置参数
 
 @return 0:success, 1:faild
 */
int jinglian_charge_config(system_config_t* config);


/**
 charge 库的连接
 
 @return 0:success, 1:faild
 */
int jinglian_charge_connect();


/**
 charge 库断开连接
 
 @return 0:success, 1:faild
 */
int jinglian_charge_disconnect();


/**
 登录定损服务器 不用手动调用，已在 connect 内部被动调用
 
 @return 0:success, 1:faild
 */
int jinglian_charge_login();


/**
 注销定损服务器登录 不用手动调用，已在 connect 内部被动调用
 
 @return 0:success, 1:faild
 */
int jinglian_charge_logout();
int jinglian_charge_get_report_rule();
int jinglian_charge_charge_call_req(char* reportNo, int isNewAgent);


/**
 图片发送，坐席拍照模式
 
 @param watermark 水印
 @param picFormat 未知
 @param pic_name  手机本地图片存储路径
 @param state     未知
 
 @return
 */
int jinglian_charge_pic_filedata_send(int watermark,int picFormat ,char* pic_name, int state);
int jinglian_charge_snap_pic_req();
int jinglian_charge_charge_break_ntf();
int jinglian_charge_charge_complete_ntf();
int jinglian_auth_snap_rsp(int result);
int jinglian_cancel_auth_snap_rsp(int result);


/**
 图片发送，坐席授权手机拍照模式
 
 @param quality   30
 @param dataSize  图片大小
 @param picFormat 0
 @param watermark 1
 @param pic_name  坐席图片存储路径
 @param loc_pic   手机本地图片存储路径
 
 @return 0:success, 1:faild
 */
int jinglian_authed_send_picture(int quality, int dataSize, int picFormat, int watermark, char* pic_name, char* loc_pic);


/**
 gps经纬度发送
 
 @param gps_info @"%.8f'%.8f'", latitude, longitude, eg.(34.76449865'113.60680905')
 
 @return 0:success, 1:faild
 */
int jinglian_gps_info_notify(char* gps_info);
//shm added begin for transparent channel test.
int jinglian_transparent_channel_notify(char* t_data);

int jinglian_wireless_signal_notify(int net_mode, int signal_val);


/**
 退出定损等待，该操作没有回调
 
 @param deviceid 手机设备号
 @param result   暂不清楚，传1可行
 
 @return 0:success, 1:faild
 */
int jinglian_charge_quit_call_wait(int deviceid, int result);
int jinglian_back_call_confirm_rsp(int sigid, int agentid);
int jinglian_back_call_response(int agentid, int contextid, char* reportNo, char* agentMsg, int result);
int jinglian_back_call_cancel(int agentid, int contextid, int result);


/**
 取消图片发送
 
 @return 0:success, 1:faild
 */
int devCancelFileTransf();


/**
 取消图片发送通知
 
 @param pic_name 图片路径，上传时发送给服务器的路径，不是本地存储路径，一般和 devCancelFileTransf() 配合使用
 
 @return 0:success, 1:faild
 */
int devCancelTransfNtf(char* pic_name);


/**
 手机端定损完成
 
 @param action 1
 @param status 1
 @param ext_pt 描述，随便写 eg. 定损完成
 
 @return 0:success, 1:faild
 */
int devOnlineAction(int action, int status, char* ext_pt);
int jinglian_charge_lens_ctrl_rsp(int result);


/**
 呼叫定损
 
 @param reportNo   报案号
 @param isNewAgent 是否找新的坐席员定损，传0，不确定为什么
 
 @return 0:success, 1:faild
 */
int jinglian_charge_charge_call_req2(char* reportNo, int isNewAgent);
