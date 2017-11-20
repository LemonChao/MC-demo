/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *
 ****************************************************************************/
#ifndef	__JL_VIDEO_SEND_BUFFER_H__
#define	__JL_VIDEO_SEND_BUFFER_H__

#include "jl_mem_manager.h"
#include "jl_av_session.h"


#ifndef	MAX_PACKET_SEQ
#define		MAX_PACKET_SEQ						65536
#endif

#define		MAX_VIDEO_PACKET_LEN				1400

#define		VIDEO_RESEND_MAX_PENDING			30
#define		VIDEO_RESEND_BUF_NUM				300

#define		VIDEO_SEND_QUEUE_LEN				30000

#define		VIDEO_FRAME_NUM						300
#define		VIDEO_FRAME_SUB_PACKET_NUM			100

#define		PACK_SEQ_EXCEED						60000



typedef struct 
{
	unsigned char 		fill;
	unsigned char 		reSend;
	unsigned int		len;
	unsigned short		subSeq;
	v_mem_block_t   *	pMem;		
}vpacket_t;

typedef struct
{
	unsigned char 		fill;
	unsigned char		Iframe;
	unsigned short		packetNum;
	unsigned short		seq;
	unsigned int		timeStamp;	
	unsigned short		width;
	unsigned short		height;
	vpacket_t			packet[VIDEO_FRAME_SUB_PACKET_NUM];
}vframe_t;

typedef struct
{
	unsigned short		sp;
	unsigned short		rp;
	unsigned short		wp;
	vframe_t			frame[VIDEO_FRAME_NUM];	
}vs_buffer_t;

typedef	struct
{
	unsigned char		Iframe;
	unsigned short		subPackNum;
	unsigned short		subSeq;		
	unsigned short		packSeq;
	unsigned int		timeStamp;	
	unsigned short		width;
	unsigned short		height;
	unsigned int		len;
	char   				data[MAX_VIDEO_PACKET_LEN];		
}vrspacket__t;

typedef	struct
{
	unsigned short		rp;
	unsigned short		wp;	
	vrspacket__t   		packet[VIDEO_RESEND_BUF_NUM];		
}vrs_buffer__t;

int vsbuf_init();

int vsbuf_release();

int vsbuf_read(unsigned short seq,
					unsigned short subSeq,
					unsigned char *key,
					unsigned int *ts,
					unsigned short * subNum,
					unsigned short * width,
					unsigned short * height,
					char *payload,
					unsigned int *len);

int vsbuf_write(	unsigned char key,
					unsigned char big, 
					unsigned short seq,
					unsigned int ts,
					unsigned short subSeq,
					unsigned short subNum,
					unsigned short width,
					unsigned short height,
					unsigned int len,
					char *payload);
int vsbuf_write2(char key,
				unsigned short seq,
				unsigned int ts,
				unsigned short width,
				unsigned short heigth,
				unsigned int len,
				char *payload);

int vsbuf_pack_num();

int vsbuf_frame_num();

int vsbuf_for_send(unsigned short * seq,
					unsigned short subSeq,
					unsigned char *key,
					unsigned int *ts,
					unsigned short subNum,
					unsigned short * width,
					unsigned short * height,
					char *payload,
					unsigned int *len);




int vrsbuf_init();


int vrsbuf_release();

int vresend_pack_num();

int vrsbuf_read(unsigned short *seq,
					unsigned short *subSeq,
					unsigned char *key,
					unsigned int *ts,
					unsigned short * subNum,
					unsigned short * width,
					unsigned short * height,
					char *payload,
					unsigned int *len);


int vrsbuf_write(	unsigned char key,
					unsigned short seq,
					unsigned int ts,
					unsigned short subSeq,
					unsigned short subNum,
					unsigned short width,
					unsigned short height,
					unsigned int len,
					char *payload);


#endif //__JL_VIDEO_SEND_BUFFER_H__

