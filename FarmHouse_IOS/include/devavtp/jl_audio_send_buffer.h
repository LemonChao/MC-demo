/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *
 ****************************************************************************/
#ifndef	__JL_AUDIO_SEND_BUFFER_H__
#define	__JL_AUDIO_SEND_BUFFER_H__
#include "jl_audio_recv_jitter.h"

#define		MAX_AUDIO_RESEND_NUM		200		


typedef struct
{
	unsigned char		fill;
	unsigned char		resend;
	unsigned short 	 	packSeq;
	unsigned int		timeStamp;
	unsigned int		len;
			char		data[MAX_AUDIO_PACKET_LEN]; 
}ars_apacket_t;

	 
typedef struct
{
	unsigned short  rp;
	unsigned short  wp;
	ars_apacket_t	packet[MAX_AUDIO_RESEND_NUM];
}ars_buffer_t;
	 
	 
int arsbuf_init();

int arsbuf_release();

	 
int arsbuf_read(unsigned short seq,
						 unsigned int *ts,
						 char *payload,
						 unsigned int *len);
int arsbuf_write(unsigned short seq,
						 unsigned int ts,
						 unsigned int len,
						 char *payload);

#endif	//__JL_AUDIO_SEND_BUFFER_H__


