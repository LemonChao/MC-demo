/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *
 ****************************************************************************/
#ifndef	__JL_AV_SESSION_H__
#define	__JL_AV_SESSION_H__


#define	RTP_AV_SPEEX_PAYLOAD_TYPE		97
#define	RTP_AV_H264_PAYLOAD_TYPE		109
#define	RTP_AV_H264_PAYLOAD_RESEND_TYPE	110
#define	RTP_AV_AUDIO_RESEND_TYPE		121
#define	RTP_AV_VIDEO_RESEND_TYPE		122
#define	RTP_AV_SEND_REPORT_TYPE			123


typedef struct {
  unsigned char 	flags;            /* Protocol version, padding flag, extension flag,and CSRC count */
  unsigned char 	mpt;              /* marker bit and payload type */
  unsigned short 	seq;              /* sequence number */
  unsigned int		ts;               /* timestamp */
  unsigned int 		deviceId;         /* synchronization source */
  unsigned int		check;
} jlrtp_hdr_t;

#define BITFIELD(field, mask, shift) \
   (((field) & (mask)) >> (shift))
#define SET_BITFIELD(field, val, mask, shift) \
   do { \
     (field) &= ~(mask); \
     (field) |= (((val) << (shift)) & (mask)); \
   } while (0)
/* Protocol version */
#define RTP_VERSION(hdr) BITFIELD((hdr).flags, 0xC0, 6)
#define SET_RTP_VERSION(hdr, val) SET_BITFIELD((hdr).flags, (val), 0xC0, 6)

/* Padding flag */
#define RTP_P(hdr) BITFIELD((hdr).flags, 0x20, 5)
#define SET_RTP_P(hdr, val) SET_BITFIELD((hdr).flags, (val), 0x20, 5)

/* Extension flag */
#define RTP_X(hdr) BITFIELD((hdr).flags, 0x10, 4)
#define SET_RTP_X(hdr, val) SET_BITFIELD((hdr).flags, (val), 0x10, 4)

/* CSRC Count */
#define RTP_CC(hdr) BITFIELD((hdr).flags, 0x0F, 0)
#define SET_RTP_CC(hdr, val) SET_BITFIELD((hdr).flags, (val), 0x0F, 0)

/* Marker bit */
#define RTP_M(hdr) BITFIELD((hdr).mpt, 0x80, 7)
#define SET_RTP_M(hdr, val) SET_BITFIELD((hdr).mpt, (val), 0x80, 7)

/* Payload Type bit */
#define RTP_PT(hdr) BITFIELD((hdr).mpt, 0x7F, 0)
#define SET_RTP_PT(hdr, val) SET_BITFIELD((hdr).mpt, (val), 0x7F, 0)

/* Key Frame bit */
#define RTP_EXT_K(ext_hdr) BITFIELD((ext_hdr).mpt, 0x8000, 0)
#define SET_RTP_EXT_K(ext_hdr, val) SET_BITFIELD((ext_hdr).vPackNum, (val), 0x8000, 0)

/* Video Packet Num bit */
#define RTP_EXT_VPNUM(ext_hdr) BITFIELD((ext_hdr).mpt, 0x7FFF, 0)
#define SET_RTP_EXT_VPNUM(ext_hdr, val) SET_BITFIELD((ext_hdr).vPackNum, (val), 0x7FFF, 0)


typedef struct {           			/* RTP Header Extension */
  unsigned short 	etype;          /* extension type */
  unsigned short	len;            /* extension length */
  unsigned short	vPackNum;
  unsigned short	vPackSeq;
  unsigned short	vWidth;
  unsigned short	vHeight;
}jlrtp_hdr_ext;


typedef	struct
{
	unsigned int	lost_video_frame;
	unsigned int	recv_video_byte;
	unsigned int	report_interval;
	unsigned int	send_audio_frame;
	unsigned int	play_audio_frame;
	unsigned int	play_video_frame;		
}vsend_report_t;


typedef struct
{
	unsigned char	key;
	unsigned char	resend;
	unsigned short	seq;
	unsigned int	ts;	
	unsigned short	width;
	unsigned short	height;
	unsigned short	subNum;
	unsigned short	subSeq;	
}video_packet_t;


typedef	struct
{
	unsigned char	resend;
	unsigned short	seq;
	unsigned int	ts;	
}audio_packet_t;

int jlrtp_init();

int jlrtp_release();

int jlrtp_create_session(unsigned short port);

int jlrtp_release_session(int socket);

int jlrtp_send_video_packet(int socket,
				char 	pt,
				unsigned int	deviceId,
				video_packet_t * pPack,
				char *	payload, 
				int 	len,
				char  *	toIp,
				unsigned short toPort);

int jlrtp_send_audio_packet(int socket,
				char 	pt,	
				unsigned int 	deviceId,
				audio_packet_t * pPack,
				char *	payload, 
				int 	len,
				char *	toIp,
				unsigned short toPort);

int jlrtp_recv_video_packet(int socket,		
							char  *pt,
							unsigned int	*	deviceId,
							video_packet_t  *   pPack,
							char *	payload, 
							int	 *	len,
							char *	fromIp,
							unsigned short 	*	fromPort);

int jlrtp_recv_audio_packet(int socket,
							char  *	pt,
							unsigned int 	*	deviceId,
							audio_packet_t  * 	pPack,
							char 	*	payload, 
							int 	*	len,
							char 	*	fromIp,
							unsigned short 	*	fromPort);



#endif	//__JL_AV_SESSION_H__

