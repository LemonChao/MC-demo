/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *
 ****************************************************************************/
#ifndef	__JL_VIDEO_THREAD_H__
#define	__JL_VIDEO_THREAD_H__


typedef	struct
{
	unsigned short	byte10ms;
	unsigned short	video_port;
	unsigned int	deviceId;
	unsigned int	send_video_byte;
	unsigned int	resend_pack_num;
			char	video_ip[20];			
}video_config_t;

int video_channel_init(unsigned short target_port);

int video_thread_start(char * server_ip,unsigned short port,unsigned int deviceId);
 
int video_thread_stop();

#endif  //__JL_VIDEO_THREAD_H__
