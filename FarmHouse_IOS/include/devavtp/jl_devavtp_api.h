/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *
 ****************************************************************************/
#ifndef	__JL_DEVAVTP_API_H__
#define	__JL_DEVAVTP_API_H__

typedef	void (* JLNOTIFYCB)(int param1,int param2);

typedef	struct
{
	unsigned int	lost_video_frame;
	unsigned int	recv_video_byte;
	unsigned int	report_interval;
	unsigned int	resend_video_packet;
	unsigned int	send_video_byte;
	unsigned int	play_video_frame;	
	unsigned int	play_audio_frame;
	unsigned int 	send_audio_frame;
}avtp_vreport_t;


//typedef	struct
//{
//	unsigned int	deviceId;
//	unsigned int	audio_listen_port;
//	unsigned int	video_listen_port;
//	unsigned int	syslog_level;
//			char	server_ip[20];
//}devavtp_config_t;

typedef	struct
{
	unsigned int	sys_state;
	unsigned int	syslog_level;
}avtp_info_t;
#define JL_LOG_INFO		0
#define JL_LOG_WARNING	1
#define JL_LOG_ERROR	2

#define JL_LOG_INFO		0
#define JL_LOG_WARNING	1
#define JL_LOG_ERROR	2
int jl_devavtp_init(devavtp_config_t *pConfig);

int jl_devavtp_config(char * server_ip,unsigned int deviceId);

int jl_devavtp_release();

int jl_devavtp_open_channel(unsigned short target_audio_port,unsigned short target_video_port);

int set_devavtp_vreport_cb(JLNOTIFYCB cbfunc);

int jl_devavtp_send_audio(unsigned short seq,unsigned int ts,unsigned int len,char *payload);

int jl_devavtp_recv_audio(unsigned short * seq,unsigned int * ts,unsigned int * len,char *payload);

int jl_devavtp_send_video(char key,unsigned short seq,unsigned int ts,unsigned short width,unsigned short height,unsigned int len,char *payload);

int jl_devavtp_recv_video(char *key,unsigned short * seq,unsigned int * ts,unsigned int * len,char *payload);


#endif	//__JL_DEVAVTP_API_H__

