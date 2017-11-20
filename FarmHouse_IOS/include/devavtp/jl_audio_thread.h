/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *
 ****************************************************************************/
#ifndef	__JL_AUDIO_THREAD_H__
#define	__JL_AUDIO_THREAD_H__


typedef	struct
{
	unsigned int	deviceId;
	unsigned short	audio_port;
			char	audio_ip[20];
}audio_config_t;

int audio_channel_init(unsigned short target_port);

int audio_thread_start(char * server_ip,unsigned short port,unsigned int deviceId);
	  
int audio_thread_stop();
	 
int audio_send_packet(unsigned short seq,
								 unsigned int ts,
								 char * data,
								 unsigned int len);
	  
#endif  //__JL_AUDIO_THREAD_H__


