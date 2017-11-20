/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *
 ****************************************************************************/
#ifndef	__JL_AUDIO_RECV_JITTER_H__
#define	__JL_AUDIO_RECV_JITTER_H__
	 
#ifndef	MAX_PACKET_SEQ
#define		MAX_PACKET_SEQ					65536
#endif

#ifndef	MAX_AUDIO_PACKET_LEN
#define		MAX_AUDIO_PACKET_LEN				160
#endif

#define		JB_AUDIO_EXCEED_SIZE				60000
//audio

#define		JB_AUDIO_MAX_BUFFER_NUM				300
#define		JB_AUDIO_MAX_JITTER_NUM				200
#define		JB_AUDIO_MIN_JITTER_NUM				6
#define		JB_AUDIO_ERRSEQ_BUF_NUM				4
#define		JB_AUDIO_PLAY_BUF_NUM				2
	 
	 
typedef struct
{
	unsigned char		fill;
	unsigned char		resend;
	unsigned short 	 	packSeq;
	unsigned int		timeStamp;
	unsigned int		len;
			char		data[MAX_AUDIO_PACKET_LEN]; 
}jb_apacket_t;
	 
typedef struct
{
	unsigned char	 	start_play;
	unsigned char	 	exceed_times;
	unsigned char	 	later_times;
	unsigned short  	rp;
	unsigned short  	wp;
	jb_apacket_t	 	packet[JB_AUDIO_MAX_BUFFER_NUM];
}jb_ajitter_t;
	 
	 
int jb_audio_init();


int jb_audio_release();
	 
	 
int jb_write_audio(unsigned short seq,
						 unsigned int timeStamp,
						 unsigned int len,
						 char *pData);
	 
	 
int jb_read_audio(unsigned short *seq,
					   unsigned int *timeStamp,
					   unsigned int *len,
					   char *pData);
	 
	 
	 
#endif //__JL_AUDIO_RECV_JITTER_H__


