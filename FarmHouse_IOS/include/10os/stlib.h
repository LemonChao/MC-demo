#ifndef __STLIB_H__
#define __STLIB_H__

//.........................................
#ifdef __cplusplus
extern "C"{
#endif //..................................

#include "stldef.h"
// #include "stlxml.h"
// #include "stmempool.h"

#ifdef _WIN32 //...........................

    typedef unsigned int socket_t;
    typedef int socklen_t;

#pragma comment(lib,"netapi32.lib") 

#else //!_WIN32_..........................

typedef int socket_t;

#ifndef INVALID_SOCKET
#define INVALID_SOCKET  (socket_t)(~0)
#endif

#ifndef SOCKET_ERROR
#define SOCKET_ERROR            (-1)
#endif

#endif //!_LINUX_........................


#define SOCK_CREATE_ERR			    (u32)0x00000001
#define SOCK_REUSEADDR_ERR          (u32)0x00000002
#define SOCK_BIND_ERR				(u32)0x00000003
#define SOCK_JOINMULTICAST_ERR      (u32)0x00000004

    typedef struct tagSTMacAddr
    {
        u8  m_abyData[6];
    }TMacAddr;

    /*=============================================================================
    函数名: StlUdpSocketCreate
    功能  : 创建一个UDP监听端口
    参数  : u32 dwIpNetEndian:IP地址(网络序)
    u16 wPort:端口
    socket_t *ptSock:返回的socket句柄
    BOOL bReUseAddr:是否允许重复绑定
    返回值: u32  
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    u32  StlUdpSocketCreate(u32 dwIpNetEndian,u16 wPort,socket_t *ptSock,BOOL bReUseAddr);

    /*=============================================================================
    函数名: StlJoinMulticastGroup
    功能  : 加入组播组
    参数  : socket_t tSock
    u32 dwMultiIpNetEndian:多播的Ip,网络序
    u32 dwLocalIpNetEndian:本地的Ip
    返回值: BOOL 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    BOOL StlJoinMulticastGroup(socket_t tSock,u32 dwMultiIpNetEndian,u32 dwLocalIpNetEndian);

	BOOL StlJoinBroadcast(socket_t tSock);
	
	u32  StlBroadcastIpGet(u32 dwIpNetEndian,u32 dwNetMask);
	
	BOOL StlIsMulticastIp(u32 dwIpNetEndian);

	BOOL StlSockRcvBufSizeSet(socket_t tSock,u32 dwBufSize);
	
	BOOL StlSockSndBufSizeSet(socket_t tSock,u32 dwBufSize);

    /*=============================================================================
    函数名: StlSockTTLSet
    功能  : 生存时间(路由)
    参数  : socket_t tSock
    u32 dwTTL
    返回值: BOOL 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    BOOL StlSockTTLSet(socket_t tSock,u32 dwTTL);

    /*=============================================================================
    函数名: StlLeaveMulticastGroup
    功能  : 离开组播组
    参数  : socket_t tSock
    u32 dwMultiIpNetEndian
    返回值: BOOL 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    BOOL StlLeaveMulticastGroup(socket_t tSock,u32 dwMultiIpNetEndian);

    /*=============================================================================
    函数名: StlMCLoopbackDisable
    功能  : 多播禁止环回
    参数  : socket_t sock
    返回值: BOOL 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    BOOL StlMulticastLoopbackDisable(socket_t sock);

    /*=============================================================================
    函数名: StlSendPacket
    功能  : 发送消息
    参数  : socket_t tSock
    char *pBuf
    u32 dwPacketLen
    u32 dwDstIpNetEndian
    u16 wDstPort
    返回值: int  
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    int  StlSendPacket(socket_t tSock,char *pBuf,u32 dwPacketLen,u32 dwDstIpNetEndian,u16 wDstPort);

    /*=============================================================================
    函数名: StlRecvPacket
    功能  : 接收消息
    参数  : socket_t tSock
    char *pBuf
    int nLen
    u32 *pdwSrcIP
    u16 *pwSrcPort
    返回值: int  
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    int  StlRecvPacket(socket_t tSock,char *pBuf,int nLen,u32 *pdwSrcIP ,u16 *pwSrcPort );

    /*=============================================================================
    函数名: StlLocalIpGet
    功能  : 取本地IP地址
    参数  : u16 wNifNum:本地接口索引
    返回值: 返回本地IP个数
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    u16 StlLocalIpGet(u16 wNifIdx,u32 *pdwIpNetEndian);

    /*=============================================================================
    函数名: StlGetIPByName
    功能  : StlIpAddrGetByName,可以解析域名等
    参数  : char* strHostName
    u32 *pdwIpNetEndian
    返回值: BOOL 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/30    1.0         Steven      创建
    =============================================================================*/
    BOOL StlIpAddrGetByName(char* strHostName,IN u32 adwIpNetEndian[],IN u16 wMaxIpNum,u16 *pwRealIpNum);

    /*=============================================================================
    函数名: StlLocalPortGet
    功能  : 获取本地空闲绑定端口
    参数  : u32 dwIpNetEndian
    u16 wStartPort
    u16 wRange
    u16 *pwBindPort
    返回值: BOOL 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    BOOL StlLocalPortGet(u32 dwIpNetEndian,u16 wStartPort,u16 wRange,u16 *pwBindPort);

    /*=============================================================================
    函数名: StlGetMacAddr
    功能  : 获取本地MAC地址
    参数  : TMacAddr *ptMacAddr
    u8 byIdx
    返回值: BOOL是否成功
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    BOOL StlLocalMacGet(u8 byNifIdx,TMacAddr *ptMacAddr);

    /*=============================================================================
    函数名: *StlIp2Str
    功能  : IP转换为字符串
    参数  : u32 dwIpNetEndian
    返回值: char 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    char *StlIp2Str(u32 dwIpNetEndian);
	//字符串转为IP
    u32 StlStr2Ip(char *strIp);

    //////////////////////////////////////////////////////////////////////////
    // 消息分发公共数据结构和函数
    /*=============================================================================
    函数名: StlInitEventMapTable
    功能  : 初始化事件映射表
    参数  : TEventMapEntry eventMap[]
    u16 wEntryNum
    char* eventMapTableName
    TEventMapTable* pEventMapTable
    返回值: BOOL 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    BOOL StlInitEventMapTable( TEventMapEntry eventMap[], u16 wEntryNum, char* eventMapTableName, TEventMapTable* pEventMapTable);

    /*=============================================================================
    函数名: StlGetEventMapEntry
    功能  : 根据事件ID得到入口
    参数  : TEventMapTable* pEventMapTable
    u32 dwEvent
    返回值: TEventMapEntry* 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    TEventMapEntry* StlGetEventMapEntry(TEventMapTable* pEventMapTable, u32 dwEvent);

    //////////////////////////////////////////////////////////////////////////
    //通用ID到名子的映射
    //id到名子映射结构
    /*====================================================
    函数名: StlInitID2NameMapTable
    功能  : 初始化ID2Name映射
    参数  : TSTId2NameEntry eventMap[]:数组指针
    u32 dwEntryNum:大小
    返回值: BOOL 
    说明  : 
    =====================================================*/
    TSTId2NameItem* StlInitID2NameMapTable( TSTId2NameItem eventMap[], u32 dwEntryNum);

    /*====================================================
    函数名: StlGetID2NameEntry
    功能  : 根据ID获取相应的入口
    参数  : TSTId2NameEntry idMap[]
    u32 dwEntryNum
    u32 dwId
    返回值: TSTId2NameEntry * 
    说明  : 
    =====================================================*/
    TSTId2NameItem * StlGetID2NameEntry(TSTId2NameItem idMap[],u32 dwEntryNum,u32 dwId);


    /*====================================================
    函数名: ConvertU8ToHexStr
    功能  : 字节转16进制串
    参数  : u8 *pBuf
    u32 dwInBufLen
    char* pchHexStr
    u32 dwMaxHexStrLen
    返回值: BOOL 
    说明  : 
    =====================================================*/
    BOOL StlU8ToHexStr(u8 *pBuf,u32 dwInBufLen,char* pchHexStr,u32 dwMaxHexStrLen);

    /*====================================================
    函数名: ConvertHexStrToU8
    功能  : 16进制串转字节
    参数  : char *pchHexStr
    u8 *pBuf
    u32 dwInBufLen
    返回值: BOOL 
    说明  : 
    =====================================================*/
    BOOL StlHexStrToU8(char *pchHexStr,u8 *pBuf,u32 dwInBufLen);

    //启动应用程序
    /*====================================================
    函数名:  StlCreateProcess
    功能  : 创建一个进程
    参数  : char *pchCmdline:进程路径(必须是全路径,不支持相对路径)
    char *pchWorkdir:工作目录
    u32 *pdwProcessId:进程ID
    返回值: BOOL  
    说明  : 
    =====================================================*/

    BOOL   StlCreateProcess(IN char *pchCmdline,IN char *pchWorkdir,OUT u32 *pdwProcessId);
    /*=============================================================================
    函数名:  StlCloseProcess
    功能  : 关闭一个进程
    参数  : IN u32 dwProcessId
    返回值: BOOL  
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/22    1.0         Steven      创建
    =============================================================================*/
    BOOL   StlCloseProcess(IN u32 dwProcessId);

    // 加密解密 [8/19/2007]
    /*====================================================
    函数名: MD5Encrypt
    功能  : MD5加密
    参数  : char *strText:输入要加密的字符串
    char *strKey:加密的KEY
    OUT char *pchCryptoBuf:输出的字符串32字节
    u32 dwInBufBytes:至少33字节长度
    返回值: BOOL 
    说明  : 1.普通加密,strKey为NULL,输出32字节有效长度.
	        2.strKey不为NULL,输出有效长度64字节.
    =====================================================*/
    BOOL MD5Encrypt(char *strText,char *strKey,OUT char *pchCryptoBuf,u32 dwInBufBytes);
    
    //base64加密解密
    #define XYSSL_ERR_BASE64_BUFFER_TOO_SMALL -0x0010 //错误码
    #define XYSSL_ERR_BASE64_INVALID_CHARACTER -0x0012 //错误码
    /**
    * \brief Encode a buffer into base64 format
    *
    * \param dst destination buffer
    * \param dlen size of the buffer
    * \param src source buffer
    * \param slen amount of data to be encoded
    *
    * \return 0 if successful, or XYSSL_ERR_BASE64_BUFFER_TOO_SMALL.
    * *dlen is always updated to reflect the amount
    * of data that has (or would have) been written.
    *
    * \note Call this function with *dlen = 0 to obtain the
    * required buffer size in *dlen
    */
    int base64_encode( u8 *dst, int *dlen, u8 *src, int slen );
    /**
    * \brief Decode a base64-formatted buffer
    *
    * \param dst destination buffer
    * \param dlen size of the buffer
    * \param src source buffer
    * \param slen amount of data to be decoded
    *
    * \return 0 if successful, XYSSL_ERR_BASE64_BUFFER_TOO_SMALL, or
    * XYSSL_ERR_BASE64_INVALID_DATA if the input data is not
    * correct. *dlen is always updated to reflect the amount
    * of data that has (or would have) been written.
    *
    * \note Call this function with *dlen = 0 to obtain the
    * required buffer size in *dlen
    */
    int base64_decode( u8 *dst, int *dlen, u8 *src, int slen );
    /*================ 内存管理封装 =================*/

    /*=============================================================================
    函数名: OalCalloc
    功能  : 内存分配,成功以后,内存自动清0
    参数  : void* hMemHdl
    u32 dwBytes
    u32 dwMemTag
    返回值: void * 
    --------------------------------------------------------------------------
    修改记录:
    日    期     版本        修改人      修改内容
    2007/8/29    1.0         Steven      创建
    =============================================================================*/
    void * InnerOalCalloc(void* hMemHdl,u32 dwBytes,u32 dwMemTag,char *sFileName, s32 sdwLine);

    #define OalCalloc(hAlloc, dwBytes, dwTag) InnerOalCalloc((hAlloc),(dwBytes),(dwTag), __FILE__, __LINE__) 

	//成功返回:OALSEM_SIGNALED,失败:OALSEM_FAILED
	u32 InnerEnterCriticSec( TLightLock* ptLightLock, char szLockName[], char* szFileName, u32 dwLine );
#define EnterCriticSec(tLightLock) InnerEnterCriticSec( &tLightLock, #tLightLock, __FILE__, __LINE__ )

    #define LeaveCriticSec(tLightLock) LightLockUnLock(&tLightLock)								   

    #define DeleteCriticSec(tLightLock) LightLockDelete(&tLightLock)
    //////////////////////////////////////////////////////////////////////////
    //通用打印,主要用于模块初始化时参数打印
    //输出到OalTelHdlGet()句柄上,
    //level:打印级别目前无效
    void stlLog(u8 level,s8* lpszFormat,...);

	//////////////////////////////////////////////////////////////////////////
	//调试接口
	//控制本模块的打印级别
	void stldl(u8 level);

//.........................................
#ifdef __cplusplus
}
#endif //..................................


#endif // !! __STLIB_H__
