/*****************************************************************************
ģ����      : vssbasetype
�ļ���      : vssbasetype.h
����ļ�    : ��ģ��Ŀ����ļ�
�ļ�ʵ�ֹ���: �ṩds��˾��������Ļ������Ͷ���
����        : zr 
�汾        : V1.0  Copyright(C) 2006-2008 DS, All rights reserved.
-----------------------------------------------------------------------------
�޸ļ�¼:
��  ��      �汾        �޸���      �޸�����
2010/03/17  1.0         zr          Create

ע��Ŀǰֻ������windowsƽ̨�����ſ���ƽ̨�����ӣ��᲻�ϼ��ݡ�
    Ϊ����32λϵͳ��64λϵͳ�Ĳ�һ�£� 32λ������long�����壬����int��
	�Ƽ���u32���Ķ���
******************************************************************************/

#ifndef _UV_BASETYPE_H
#define _UV_BASETYPE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif 

//���Ͷ���

typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t u8;
typedef uint64_t u64;

typedef int32_t s32;
typedef int16_t s16;
typedef int8_t s8;
typedef int64_t s64;



//���������������Ͷ���

#ifndef _MSC_VER     //msc �Ѷ����UINT32����

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

//���������������Ͷ���
#ifdef _CODEC_TYPE      //����ĳЩģ����õ�ϵͳ����db���� uint32_t �Ķ��壬���Դ˴��ú��������ͻ

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

//�����Ͷ���
#ifndef f32
typedef	float				f32;
#endif

#ifndef f64
typedef double				f64;
#endif



//BOOL ����
#ifndef _HAVE_TYPE_BOOL
#ifdef __APPLE__
#ifndef __OBJC__
typedef  int				BOOL;
#endif
#endif
#endif


// �ַ�ָ��
#ifndef _MSC_VER

#ifndef LPSTR
#define LPSTR   char *
#endif

#ifndef LPCSTR
#define LPCSTR  const char *
#endif

#endif //_MSC_VER


//���
#ifndef _MSC_VER

typedef void *  HANDLE;

#endif //_MSC_VER


typedef void *  EHANDLE;	//esight���������Ͳ���ϵͳ��ͬ��


//BOOL����
#ifndef TRUE
#define TRUE				(BOOL)1
#endif

#ifndef FALSE
#define FALSE				(BOOL)0
#endif


//������ʶ����
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
// //u64��mac��ַ�ַ�����ת�������pStrΪ�գ�����0��mac��ַ�Ƿ�Ҳ����0
// //mac��ַ�ĸ�ʽΪ "00:11:22:33:44:55"
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

//FCC����, ����FOURCC�� mmsystem.h ���Ѷ��壬Ϊ��ֹ��ͻ��ȡ��FCC

typedef u32 FCC;

#define MAKEFCC(ch0, ch1, ch2, ch3)                              \
		((u32)(u8)(ch0) | ((u32)(u8)(ch1) << 8) |   \
		((u32)(u8)(ch2) << 16) | ((u32)(u8)(ch3) << 24 ))


//FCC ת��Ϊ�ַ�����������4����, Ҫ��dwInLen>4
#define ONEBYTE_BASE 256
s8 *FCC2STR(FCC tFccVal);



typedef u64 OCC;

//�ַ�����������8����ת��Ϊu64
OCC STR2OCC(const s8 *pStr);

//u64 ת��Ϊ�ַ�����������8����, Ҫ��dwInLen>8
BOOL OCC2STR(OCC tOccVal, s8 *pStr, u32 dwInLen);


//64λ�ֽ���ת��, �����cpu���������֡�Ŀǰ��i386, arm, mips����Сͷ��, ppc��Ϊ��ͷ��

u64 htonq(u64 qwData);

u64 ntohq(u64 qwData);




///////////////////////// ���к�ת�� /////////////////////////

#define BASE_36				    36 //36����(0-9, a-z, A-Z)
#define BASE36VAL_LEN			11  //36������ֵ��λ��

/*=================================================================
�� �� ��: ShiftBase36
��    ��: ת��36���ƣ�������56λ2���Ƶ�����
�������:
����ֵ˵�����ɹ���TRUE��ʧ�ܣ�FALSE
=================================================================*/
BOOL ShiftBase36(u64 qwVal, u32 adwVal[BASE36VAL_LEN]);


/*=================================================================
�� �� ��: Base36VAl2Char
��    ��: 
�������:	dwBase36VAl -- ģ���

����ֵ˵�����ɹ���TRUE��ʧ�ܣ�FALSE
=================================================================*/
BOOL Base36VAl2Char(IN u32 dwBase36VAl, OUT s8 *pchVal);


//11λ�ַ������к�ת��Ϊu64�������к�
u64 Sn11CC2U64(IN s8 *pch11CCSn);


//u64�������к�ת��Ϊ11λ�ַ������к�
BOOL SnU64To11CC(IN u64 qwU64Sn, IN OUT s8 *pch11CCSn, IN u32 dwBufLen);

/************************************************************************
���ƣ�ShiftByte
������
���ܣ��ֽڸ�4λ����4λ����
���أ�
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


