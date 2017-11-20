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
    ������: StlUdpSocketCreate
    ����  : ����һ��UDP�����˿�
    ����  : u32 dwIpNetEndian:IP��ַ(������)
    u16 wPort:�˿�
    socket_t *ptSock:���ص�socket���
    BOOL bReUseAddr:�Ƿ������ظ���
    ����ֵ: u32  
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    u32  StlUdpSocketCreate(u32 dwIpNetEndian,u16 wPort,socket_t *ptSock,BOOL bReUseAddr);

    /*=============================================================================
    ������: StlJoinMulticastGroup
    ����  : �����鲥��
    ����  : socket_t tSock
    u32 dwMultiIpNetEndian:�ಥ��Ip,������
    u32 dwLocalIpNetEndian:���ص�Ip
    ����ֵ: BOOL 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    BOOL StlJoinMulticastGroup(socket_t tSock,u32 dwMultiIpNetEndian,u32 dwLocalIpNetEndian);

	BOOL StlJoinBroadcast(socket_t tSock);
	
	u32  StlBroadcastIpGet(u32 dwIpNetEndian,u32 dwNetMask);
	
	BOOL StlIsMulticastIp(u32 dwIpNetEndian);

	BOOL StlSockRcvBufSizeSet(socket_t tSock,u32 dwBufSize);
	
	BOOL StlSockSndBufSizeSet(socket_t tSock,u32 dwBufSize);

    /*=============================================================================
    ������: StlSockTTLSet
    ����  : ����ʱ��(·��)
    ����  : socket_t tSock
    u32 dwTTL
    ����ֵ: BOOL 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    BOOL StlSockTTLSet(socket_t tSock,u32 dwTTL);

    /*=============================================================================
    ������: StlLeaveMulticastGroup
    ����  : �뿪�鲥��
    ����  : socket_t tSock
    u32 dwMultiIpNetEndian
    ����ֵ: BOOL 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    BOOL StlLeaveMulticastGroup(socket_t tSock,u32 dwMultiIpNetEndian);

    /*=============================================================================
    ������: StlMCLoopbackDisable
    ����  : �ಥ��ֹ����
    ����  : socket_t sock
    ����ֵ: BOOL 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    BOOL StlMulticastLoopbackDisable(socket_t sock);

    /*=============================================================================
    ������: StlSendPacket
    ����  : ������Ϣ
    ����  : socket_t tSock
    char *pBuf
    u32 dwPacketLen
    u32 dwDstIpNetEndian
    u16 wDstPort
    ����ֵ: int  
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    int  StlSendPacket(socket_t tSock,char *pBuf,u32 dwPacketLen,u32 dwDstIpNetEndian,u16 wDstPort);

    /*=============================================================================
    ������: StlRecvPacket
    ����  : ������Ϣ
    ����  : socket_t tSock
    char *pBuf
    int nLen
    u32 *pdwSrcIP
    u16 *pwSrcPort
    ����ֵ: int  
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    int  StlRecvPacket(socket_t tSock,char *pBuf,int nLen,u32 *pdwSrcIP ,u16 *pwSrcPort );

    /*=============================================================================
    ������: StlLocalIpGet
    ����  : ȡ����IP��ַ
    ����  : u16 wNifNum:���ؽӿ�����
    ����ֵ: ���ر���IP����
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    u16 StlLocalIpGet(u16 wNifIdx,u32 *pdwIpNetEndian);

    /*=============================================================================
    ������: StlGetIPByName
    ����  : StlIpAddrGetByName,���Խ���������
    ����  : char* strHostName
    u32 *pdwIpNetEndian
    ����ֵ: BOOL 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/30    1.0         Steven      ����
    =============================================================================*/
    BOOL StlIpAddrGetByName(char* strHostName,IN u32 adwIpNetEndian[],IN u16 wMaxIpNum,u16 *pwRealIpNum);

    /*=============================================================================
    ������: StlLocalPortGet
    ����  : ��ȡ���ؿ��а󶨶˿�
    ����  : u32 dwIpNetEndian
    u16 wStartPort
    u16 wRange
    u16 *pwBindPort
    ����ֵ: BOOL 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    BOOL StlLocalPortGet(u32 dwIpNetEndian,u16 wStartPort,u16 wRange,u16 *pwBindPort);

    /*=============================================================================
    ������: StlGetMacAddr
    ����  : ��ȡ����MAC��ַ
    ����  : TMacAddr *ptMacAddr
    u8 byIdx
    ����ֵ: BOOL�Ƿ�ɹ�
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    BOOL StlLocalMacGet(u8 byNifIdx,TMacAddr *ptMacAddr);

    /*=============================================================================
    ������: *StlIp2Str
    ����  : IPת��Ϊ�ַ���
    ����  : u32 dwIpNetEndian
    ����ֵ: char 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    char *StlIp2Str(u32 dwIpNetEndian);
	//�ַ���תΪIP
    u32 StlStr2Ip(char *strIp);

    //////////////////////////////////////////////////////////////////////////
    // ��Ϣ�ַ��������ݽṹ�ͺ���
    /*=============================================================================
    ������: StlInitEventMapTable
    ����  : ��ʼ���¼�ӳ���
    ����  : TEventMapEntry eventMap[]
    u16 wEntryNum
    char* eventMapTableName
    TEventMapTable* pEventMapTable
    ����ֵ: BOOL 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    BOOL StlInitEventMapTable( TEventMapEntry eventMap[], u16 wEntryNum, char* eventMapTableName, TEventMapTable* pEventMapTable);

    /*=============================================================================
    ������: StlGetEventMapEntry
    ����  : �����¼�ID�õ����
    ����  : TEventMapTable* pEventMapTable
    u32 dwEvent
    ����ֵ: TEventMapEntry* 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    TEventMapEntry* StlGetEventMapEntry(TEventMapTable* pEventMapTable, u32 dwEvent);

    //////////////////////////////////////////////////////////////////////////
    //ͨ��ID�����ӵ�ӳ��
    //id������ӳ��ṹ
    /*====================================================
    ������: StlInitID2NameMapTable
    ����  : ��ʼ��ID2Nameӳ��
    ����  : TSTId2NameEntry eventMap[]:����ָ��
    u32 dwEntryNum:��С
    ����ֵ: BOOL 
    ˵��  : 
    =====================================================*/
    TSTId2NameItem* StlInitID2NameMapTable( TSTId2NameItem eventMap[], u32 dwEntryNum);

    /*====================================================
    ������: StlGetID2NameEntry
    ����  : ����ID��ȡ��Ӧ�����
    ����  : TSTId2NameEntry idMap[]
    u32 dwEntryNum
    u32 dwId
    ����ֵ: TSTId2NameEntry * 
    ˵��  : 
    =====================================================*/
    TSTId2NameItem * StlGetID2NameEntry(TSTId2NameItem idMap[],u32 dwEntryNum,u32 dwId);


    /*====================================================
    ������: ConvertU8ToHexStr
    ����  : �ֽ�ת16���ƴ�
    ����  : u8 *pBuf
    u32 dwInBufLen
    char* pchHexStr
    u32 dwMaxHexStrLen
    ����ֵ: BOOL 
    ˵��  : 
    =====================================================*/
    BOOL StlU8ToHexStr(u8 *pBuf,u32 dwInBufLen,char* pchHexStr,u32 dwMaxHexStrLen);

    /*====================================================
    ������: ConvertHexStrToU8
    ����  : 16���ƴ�ת�ֽ�
    ����  : char *pchHexStr
    u8 *pBuf
    u32 dwInBufLen
    ����ֵ: BOOL 
    ˵��  : 
    =====================================================*/
    BOOL StlHexStrToU8(char *pchHexStr,u8 *pBuf,u32 dwInBufLen);

    //����Ӧ�ó���
    /*====================================================
    ������:  StlCreateProcess
    ����  : ����һ������
    ����  : char *pchCmdline:����·��(������ȫ·��,��֧�����·��)
    char *pchWorkdir:����Ŀ¼
    u32 *pdwProcessId:����ID
    ����ֵ: BOOL  
    ˵��  : 
    =====================================================*/

    BOOL   StlCreateProcess(IN char *pchCmdline,IN char *pchWorkdir,OUT u32 *pdwProcessId);
    /*=============================================================================
    ������:  StlCloseProcess
    ����  : �ر�һ������
    ����  : IN u32 dwProcessId
    ����ֵ: BOOL  
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/22    1.0         Steven      ����
    =============================================================================*/
    BOOL   StlCloseProcess(IN u32 dwProcessId);

    // ���ܽ��� [8/19/2007]
    /*====================================================
    ������: MD5Encrypt
    ����  : MD5����
    ����  : char *strText:����Ҫ���ܵ��ַ���
    char *strKey:���ܵ�KEY
    OUT char *pchCryptoBuf:������ַ���32�ֽ�
    u32 dwInBufBytes:����33�ֽڳ���
    ����ֵ: BOOL 
    ˵��  : 1.��ͨ����,strKeyΪNULL,���32�ֽ���Ч����.
	        2.strKey��ΪNULL,�����Ч����64�ֽ�.
    =====================================================*/
    BOOL MD5Encrypt(char *strText,char *strKey,OUT char *pchCryptoBuf,u32 dwInBufBytes);
    
    //base64���ܽ���
    #define XYSSL_ERR_BASE64_BUFFER_TOO_SMALL -0x0010 //������
    #define XYSSL_ERR_BASE64_INVALID_CHARACTER -0x0012 //������
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
    /*================ �ڴ�����װ =================*/

    /*=============================================================================
    ������: OalCalloc
    ����  : �ڴ����,�ɹ��Ժ�,�ڴ��Զ���0
    ����  : void* hMemHdl
    u32 dwBytes
    u32 dwMemTag
    ����ֵ: void * 
    --------------------------------------------------------------------------
    �޸ļ�¼:
    ��    ��     �汾        �޸���      �޸�����
    2007/8/29    1.0         Steven      ����
    =============================================================================*/
    void * InnerOalCalloc(void* hMemHdl,u32 dwBytes,u32 dwMemTag,char *sFileName, s32 sdwLine);

    #define OalCalloc(hAlloc, dwBytes, dwTag) InnerOalCalloc((hAlloc),(dwBytes),(dwTag), __FILE__, __LINE__) 

	//�ɹ�����:OALSEM_SIGNALED,ʧ��:OALSEM_FAILED
	u32 InnerEnterCriticSec( TLightLock* ptLightLock, char szLockName[], char* szFileName, u32 dwLine );
#define EnterCriticSec(tLightLock) InnerEnterCriticSec( &tLightLock, #tLightLock, __FILE__, __LINE__ )

    #define LeaveCriticSec(tLightLock) LightLockUnLock(&tLightLock)								   

    #define DeleteCriticSec(tLightLock) LightLockDelete(&tLightLock)
    //////////////////////////////////////////////////////////////////////////
    //ͨ�ô�ӡ,��Ҫ����ģ���ʼ��ʱ������ӡ
    //�����OalTelHdlGet()�����,
    //level:��ӡ����Ŀǰ��Ч
    void stlLog(u8 level,s8* lpszFormat,...);

	//////////////////////////////////////////////////////////////////////////
	//���Խӿ�
	//���Ʊ�ģ��Ĵ�ӡ����
	void stldl(u8 level);

//.........................................
#ifdef __cplusplus
}
#endif //..................................


#endif // !! __STLIB_H__
