/***************************************************************************
*
* Copyright (c) 2012-2015 JingLian Inc.  All Rights Reserved
*
* THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF JingLian Inc.
* The copyright notice above does not evidence any actual or intended
* publication of such source code.
*
****************************************************************************/
#ifndef	__MEMORY_MANAGER_H__
#define	__MEMORY_MANAGER_H__


#define		V_MEM_POOL_BLOCK_LEN			1400

#define		V_MEM_POOL_BLOCK_NUM			(((300*1000)/(512 * 8) + 24) * 30 )


typedef	struct
{
	unsigned char		used;
	unsigned int		seq;
			char		buf[V_MEM_POOL_BLOCK_LEN];
}v_mem_block_t;


v_mem_block_t * v_pool_malloc();

void v_pool_free(v_mem_block_t * p_block);

#endif //__MEMORY_MANAGER_H__
