/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 *
 ****************************************************************************/
#ifndef	__MISC_API_H__
#define	__MISC_API_H__



#define			MAX_LOST_RESEND_NUM			100

typedef struct
{
	unsigned short		seq;
	unsigned char		subSeq;
}lost_seq_t;

int misc_parse_vlost(char *lossStr, lost_seq_t  lostSeq[MAX_LOST_RESEND_NUM]);

int misc_parse_alost(char *lossStr, unsigned short  lostSeq[MAX_LOST_RESEND_NUM]);


#endif  //__MISC_API_H__

