/***************************************************************************
 *
 * Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
 *
 * THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF TongLang Inc.
 * The copyright notice above does not evidence any actual or intended
 * publication of such source code.
 * Description:
 *		This file define the signalling message implement of JLDevSDK !
 * History:
 *		create by LiShiShan at 2012-03-23
 ****************************************************************************/
#ifndef	__JL_SYSLOG_H__
#define	__JL_SYSLOG_H__
	 
	 
#define		LOG_LEVEL_INFO			0x00
#define		LOG_LEVEL_WARNING		0x01
#define		LOG_LEVEL_ERROR			0x02
#define		LOG_LEVEL_EMERG			0x03


#ifdef __cplusplus
extern "C" 
{
#endif	 
void jl_syslog(int priority,const char * format,...);

#ifdef __cplusplus
}
#endif

#endif //__JL_SYSLOG_H__


