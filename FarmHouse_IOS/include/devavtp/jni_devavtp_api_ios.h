#include "jl_devavtp_api.h"

/**
 发送音频数据
 
 @param seq     <#seq description#>
 @param ts      <#ts description#>
 @param len     <#len description#>
 @param payload <#payload description#>
 
 @return <#return value description#>
 */
int devavtp_send_audio(unsigned short seq, unsigned int ts, unsigned int len, char* payload);


/**
 发送视频数据
 
 @param key     <#key description#>
 @param seq     <#seq description#>
 @param ts      <#ts description#>
 @param width   <#width description#>
 @param height  <#height description#>
 @param len     <#len description#>
 @param payload <#payload description#>
 
 @return <#return value description#>
 */
int devavtp_send_video(char* key, unsigned short seq, unsigned int ts, unsigned short width, unsigned short height, unsigned int len, char* payload);


/**
 接收音频数据
 
 @param seq     标记每一帧，初始帧为0
 @param ts      时间戳，初始为0
 @param len     接收这一段数据的长度，传0
 @param payload 接收数据存放的地址
 
 @return <#return value description#>
 */
int devavtp_recv_audio(unsigned short* seq,unsigned int* ts, unsigned int* len, char* payload);


/**
 断开定损传输库的连接
 */
int devavtp_release();


/**
 devatp 库初始化
 
 @param config 配置参数
 
 @return 0:success, 1:faild
 */
int devavtp_init(devavtp_config_t* config);


/**
 devavtp 库配置
 
 @param config 配置参数
 
 @return 0:success, 1:faild
 */
int devavtp_config(devavtp_config_t* config);



/**
 devavtp 库打开传输通道
 
 @param a_port 音频传输端口
 @param v_port 视频传输端口
 
 @return 0:success, 1:faild
 */
int devavtp_open_channel(unsigned short a_port, unsigned short v_port);
