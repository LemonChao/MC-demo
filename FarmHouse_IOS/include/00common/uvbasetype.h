/*****************************************************************************
模块名      : vssbasetype
文件名      : vssbasetype.h
相关文件    : 各模块的开发文件
文件实现功能: 提供ds公司软件开发的基本类型定义
作者        : zr 
版本        : V1.0  Copyright(C) 2006-2008 DS, All rights reserved.
-----------------------------------------------------------------------------
修改记录:
日  期      版本        修改人      修改内容
2010/03/17  1.0         zr          Create

注：目前只考虑了windows平台，随着开发平台的增加，会不断兼容。
    为避免32位系统，64位系统的不一致， 32位整型用long来定义，不用int。
	推荐用u32风格的定义
******************************************************************************/

#ifndef _UV_BASETYPE_H
#define _UV_BASETYPE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif 

//整型定义

typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t u8;
typedef uint64_t u64;

typedef int32_t s32;
typedef int16_t s16;
typedef int8_t s8;
typedef int64_t s64;



//兼容其它风格的整型定义

#ifndef _MSC_VER     //msc 已定义的UINT32类型

typedef  u64				UINT64;
typedef  u32				UINT32;
typedef  u16				UINT16;
typedef  u8					UINT8;

typedef  s64				INT64;
typedef  s32				INT32;
typedef  s16				INT16;
typedef  s8					INT8;

#endif //_MSC_VER



#if 0

//兼容其它风格的整型定义
#ifdef _CODEC_TYPE      //由于某些模块调用的系统库如db已有 uint32_t 的定义，所以此处用宏来避免冲突

typedef  u64				uint64_t;
typedef  u32				uint32_t;
typedef  u16				uint16_t;
typedef  u8					uint8_t;

typedef  s64				int64_t;
typedef  s32				int32_t;
typedef  s16				int16_t;
typedef  s8					int8_t;

#endif //_CODEC_TYPE

#endif

//浮点型定义
#ifndef f32
typedef	float				f32;
#endif

#ifndef f64
typedef double				f64;
#endif



//BOOL 定义
#ifndef _HAVE_TYPE_BOOL
#ifdef __APPLE__
#ifndef __OBJC__
typedef  int				BOOL;
#endif
#endif
#endif


// 字符指针
#ifndef _MSC_VER

#ifndef LPSTR
#define LPSTR   char *
#endif

#ifndef LPCSTR
#define LPCSTR  const char *
#endif

#endif //_MSC_VER


//句柄
#ifndef _MSC_VER

typedef void *  HANDLE;

#endif //_MSC_VER


typedef void *  EHANDLE;	//esight句柄，避免和操作系统的同名


//BOOL常量
#ifndef TRUE
#define TRUE				(BOOL)1
#endif

#ifndef FALSE
#define FALSE				(BOOL)0
#endif


//参数标识定义
#ifndef IN
#define IN
#endif /* for Input */

#ifndef OUT
#define OUT
#endif /* for Output */

#define INVALID_U8ID					(u8)0xff
#define INVALID_U16ID					(u16)0xffff
#define INVALID_U32ID					(u32)0xffffffff
#define INVALID_U64ID					(u64)0xffffffffffffffffLL
#define CRITICAL_U64ID                  (u64)0x8000000000000000LL
// 
// //u64与mac地址字符串的转换，如果pStr为空，返回0。mac地址非法也返回0
// //mac地址的格式为 "00:11:22:33:44:55"
// u8 HexChar2Int(s8 ch);
// 
// s8 Int2HexChar(u8 byVal);
// 
// 
// #define MACADDR_LEN		17
// #define MACADDR_SPLIT	':'
// #define MACBASE 16
// #define MACVAL_MAX (u64)0xffffffffffffLL
// 
// u64 MAC2U64(const s8 *pchMac);
// 
// s8* U642MAC(u64 qwVal);

//FCC定义, 由于FOURCC在 mmsystem.h 中已定义，为防止冲突，取名FCC

typedef u32 FCC;

#define MAKEFCC(ch0, ch1, ch2, ch3)                              \
		((u32)(u8)(ch0) | ((u32)(u8)(ch1) << 8) |   \
		((u32)(u8)(ch2) << 16) | ((u32)(u8)(ch3) << 24 ))


//FCC 转换为字符串（不超过4个）, 要求dwInLen>4
#define ONEBYTE_BASE 256
s8 *FCC2STR(FCC tFccVal);



typedef u64 OCC;

//字符串（不超过8个）转换为u64
OCC STR2OCC(const s8 *pStr);

//u64 转换为字符串（不超过8个）, 要求dwInLen>8
BOOL OCC2STR(OCC tOccVal, s8 *pStr, u32 dwInLen);


//64位字节序转换, 最好用cpu的类型区分。目前在i386, arm, mips上是小头序, ppc上为大头序

u64 htonq(u64 qwData);

u64 ntohq(u64 qwData);




///////////////////////// 序列号转换 /////////////////////////

#define BASE_36				    36 //36进制(0-9, a-z, A-Z)
#define BASE36VAL_LEN			11  //36进制数值的位数

/*=================================================================
函 数 名: ShiftBase36
功    能: 转换36进制，适用于56位2进制的数据
输入参数:
返回值说明：成功，TRUE；失败，FALSE
=================================================================*/
BOOL ShiftBase36(u64 qwVal, u32 adwVal[BASE36VAL_LEN]);


/*=================================================================
函 数 名: Base36VAl2Char
功    能: 
输入参数:	dwBase36VAl -- 模块号

返回值说明：成功，TRUE；失败，FALSE
=================================================================*/
BOOL Base36VAl2Char(IN u32 dwBase36VAl, OUT s8 *pchVal);


//11位字符串序列号转换为u64整形序列号
u64 Sn11CC2U64(IN s8 *pch11CCSn);


//u64整形序列号转换为11位字符串序列号
BOOL SnU64To11CC(IN u64 qwU64Sn, IN OUT s8 *pch11CCSn, IN u32 dwBufLen);

/************************************************************************
名称：ShiftByte
参数：
功能：字节高4位，低4位互换
返回：
*************************************************************************/
u8 ShiftByte(u8 byVal);



#define ESMAKEU16(u8Hi, u8Low)		( ((u16)u8Hi << 8) | (u16)u8Low )
#define ESMAKEU32(u16Hi, u16Low)	( ((u32)u16Hi << 16) | (u32)u16Low )
#define ESMAKEU64(u32Hi, u32Low)	( ((u64)u32Hi << 32) | (u64)u32Low )

#define ESLOU8(u16Val)				(u8)(u16Val & 0xff)
#define ESHIU8(u16Val)				(u8)(u16Val >> 8)
#define ESLOU16(u32Val)				(u16)(u32Val & 0xffff)		
#define ESHIU16(u32Val)				(u16)(u32Val >> 16)
#define ESLOU32(u64Val)				(u32)u64Val	& 0xffffffff)	
#define ESHIU32(u64Val)				(u32)(u64Val >> 32)		

#define WORKROOT_DIR "workroot"
//#define LIB_DIR "V1.0"

#define LIB_THIRD_IMPORT(libname)  "../../../../02Lib/win32/third/"libname
#define LIB_DEBUG_IMPORT(libname)  "../../../../02Lib/win32/debug/"libname
#define LIB_RELEASE_IMPORT(libname)  "../../../../02Lib/win32/release/"libname

#ifdef __cplusplus
}
#endif  // __cplusplus

#endif // _UV_BASETYPE_H


