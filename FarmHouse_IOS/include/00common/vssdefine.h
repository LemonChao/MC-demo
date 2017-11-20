/*****************************************************************************
ģ����      : vssdefine.h
�ļ���      : vssdefine.h
����ļ�    : ��ģ��Ŀ����ļ�
�ļ�ʵ�ֹ���: �ṩvss���ϵͳӦ����صĻ���������
����        : chenhb 
�汾        : V1.0  Copyright(C) 2006-2008 DS, All rights reserved.
-----------------------------------------------------------------------------
�޸ļ�¼:
��  ��        �汾        �޸���      �޸�����
2012/03/05    1.0         chenhb          Create

˵�������ļ�������ģ�鹲ͬ���ص�Ӧ����صĹ�����ý�����͡��û�����󳤶ȵȡ�
	  ���紫�䣬���ݿ�洢ģ�����ô�ģ���еĽṹ!!!	
******************************************************************************/

#ifndef _VSS_VMDEF_H
#define _VSS_VMDEF_H

#ifdef __cplusplus
extern "C" {
#endif


#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef _LINUX_
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#endif //_LINUX_

//while ѭ���궨��

#ifdef _LINUX_
#define __FUNCDNAME__ "noname"
#endif

#define MAXWHILE_DFTCYCLE (u32)(0xfffffffe)

//ȱʡѭ������
#define WHILE_DFTLIMIT_BEGIN(cond) \
{ \
	u32 dwFocusVMWhileCycle = 0; \
	while(cond) \
	{ \
		dwFocusVMWhileCycle++; \
		if(dwFocusVMWhileCycle > MAXWHILE_DFTCYCLE) \
		{ \
			AccuPrt(OalTeltHdlGet(), PRTGNL_OCC, "file: %s, line: %d, func: %s, while cycle(%u) > MAXWHILE_DFTCYCLE(%u)\n", \
					__FILE__, __LINE__, __FUNCDNAME__, dwFocusVMWhileCycle, MAXWHILE_DFTCYCLE); \
					break; \
		}

#define WHILE_DFTLIMIT_END \
	}\
}

//ָ��ѭ������(����ʹ��)
#define WHILE_LIMIT_BEGIN(cond, dwMaxWhileCycle) \
{ \
	u32 dwFocusVMWhileCycle = 0; \
	while(cond) \
	{ \
		dwFocusVMWhileCycle++; \
		if(dwFocusVMWhileCycle > dwMaxWhileCycle) \
		{ \
			AccuPrt(OalTeltHdlGet(), PRTGNL_OCC, "file: %s, line: %d, func: %s, while cycle(%u) > maxcycle(%u)\n", \
				__FILE__, __LINE__, __FUNCDNAME__, dwFocusVMWhileCycle, dwMaxWhileCycle); \
			break; \
		}	

#define WHILE_LIMIT_END \
	}\
}

//��Ҫ���������ѭ��
#define WHILE_FOREVER(cond)	while(cond)



//����ʱ�������ȴ�
#define EST_COND_WAIT(cdtn, timewaitms) \
{ \
	int dwWaitSum = 0; \
	while(!(cdtn)) \
	{ \
		OalTaskDelay(20); \
		dwWaitSum += 20; \
		if(dwWaitSum > timewaitms) \
		{ \
			break; \
		} \
	} \
}


//����ʱ�������ȴ���bTimeout��ֵ��ӳ�Ƿ�ʱ������ΪBOOL����
#define EST_COND_WAIT_RETURN(cdtn, timewaitms, bTimeout) \
{ \
	int dwWaitSum = 0; \
	bTimeout = FALSE; \
	while(!(cdtn)) \
	{ \
	OalTaskDelay(20); \
	dwWaitSum += 20; \
	if(dwWaitSum > timewaitms) \
		{ \
		bTimeout = TRUE; \
		break; \
		} \
	} \
}

// #define ESIGHT_NONEDEV					(u32)(-1)			//��Ч�豸
// 
// #define EPC_STR		"EsightPc"
// #define EPC_AREHUB	"EsightAreHub"
// 
// #define ESIGHT_SERIALNO_MAXLEN			(u32)64	//���кų���
// #define ESIGHT_HVER_LEN					(u32)32	//Ӳ���汾�ų���
// #define ESIGHT_SVER_LEN					(u32)32	//����汾�ų���	
// #define ESIGHT_MACADDR_LEN				(u32)32  //mac��ַ����

//ͳһ��������
#define UOTYPE_INVALID					(u8)0  //��Ч������

#define UOTYPE_IPVU						(u8)1	//IPVU	
#define UOTYPE_MS						(u8)2   //��ع���վ
#define UOTYPE_VMCS						(u8)3	//��ط�����
#define UOTYPE_VMCC						(u8)4	//��ؿͻ���
#define UOTYPE_IPVU_ENCPORT				(u8)5	//����˿ڣ��ɼ��˿ڣ�
#define UOTYPE_IPVU_DECPORT				(u8)6	//����˿ڣ����Ŷ˿ڣ�
#define UOTYPE_IPVU_SERIALPORT			(u8)7	//����
#define	UOTYPE_IPVU_ONOFFPORT			(u8)8	//�����ƶ˿�
#define UOTYPE_IPVU_ENCCHN				(u8)9	//����ͨ��
#define UOTYPE_IPVU_DECCHN				(u8)10	//����ͨ��
#define UOTYPE_IPVU_RECCHN				(u8)11	//¼��ͨ��
#define UOTYPE_IPVU_PLYCHN				(u8)12	//����ͨ��

#define UOTYPE_IPVU_VENCPORT			(u8)13	//��Ƶ����˿�
#define UOTYPE_IPVU_VDECPORT			(u8)14	//��Ƶ����˿�
#define UOTYPE_IPVU_AENCPORT			(u8)15	//��Ƶ����˿�
#define UOTYPE_IPVU_ADECPORT			(u8)16	//��Ƶ����˿�

#define UOTYPE_IPVU_VENCCHN				(u8)17	//��Ƶ����ͨ��
#define UOTYPE_IPVU_VDECCHN				(u8)18	//��Ƶ����ͨ��
#define UOTYPE_IPVU_AENCCHN				(u8)19	//��Ƶ����ͨ��
#define UOTYPE_IPVU_ADECCHN				(u8)20	//��Ƶ����ͨ��


#define UOTYPE_VMTSESSION				UOTYPE_VMCC
#define UOTYPE_VMS						UOTYPE_VMCS

//�ڲ���Ŷ���
#define SYSTIMEID_INTRA					0
#define PTMID_INTRA						0
#define DEVID_INTRA						0


//����IP��ַ�����
#define MAX_LOCALIP_NUM      16

//���֡��, ����
#define MAX_HD_VIDFRM_LEN	(u32)(512<<10) //����ͼ��V3R0��֧��
#define MAX_VIDFRM_LEN		(u32)(128<<10)
#define MAX_AUDFRM_LEN		(u32)(4<<10)
#define MAX_PACK_LEN		(u32)1400
#define MAXNALU_ONEFRAME	(u32)512 //һ֡������Ƭ��������

//�����ʣ�������
#define BITRATE_CBR			0 //������
#define BITRATE_VBR			1 //������

#define MAX_IPADDRSTR_LEN			(u32)15
#define MAX_MACADDRSTR_LEN			(u32)17

#ifdef _WIN32
#else
#ifndef max
#define max(a,b)            (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a,b)            (((a) < (b)) ? (a) : (b))
#endif
#endif

#define MAX_MASK_NUM			4			//��Ƶ�ڵ������������(hi3510���1����hi3511���4��)
#define WM_KEY_LEN				8			//ˮӡ��Կ����
#define WM_STR_LEN				16			//ˮӡ�ַ�������

#define MAX_3511_MDBLOCK_WIDTH	44			//704/16
#define MAX_3511_MDBLOCK_HEIGHT	36			//576/16
#define MAX_3511_MDBLOCK_NUM	(MAX_3511_MDBLOCK_WIDTH * MAX_3511_MDBLOCK_HEIGHT)

#define MAX_MDBLOCK_WIDTH		MAX_3511_MDBLOCK_WIDTH
#define MAX_MDBLOCK_HEIGHT		MAX_3511_MDBLOCK_HEIGHT
#define MAX_MDBLOCK_NUM			MAX_3511_MDBLOCK_NUM


//����FastFile���С
#define FASTFILE_BLOCKSIZE       4096

//����DVR�ϸ�Ӧ���ڴ����ϵ���ʼƫ����

//����DiskTool��ʼƫ����
#define DISKTOOL_STARTOFFSET         ((u64)0)
//����DiskTool����ƫ����
#define DISKTOOL_ENDOFFSET           ((u64)1*1024*1024)
//DiskHunter��ʼƫ����
#define DISKHUNTER_STARTOFFSET       DISKTOOL_ENDOFFSET
//���ݿ��������ʼƫ����
#define RAWPARTION_STARTOFFSET		 ((u64)8*1024*1024)
//LOGDB��ʼƫ����
#define RAW_LOGDBOFFSET              RAWPARTION_STARTOFFSET
//SUnit����DB��ʼƫ����
#define RAW_SUNITDBOFFSET            (RAW_LOGDBOFFSET+((u64)1<<20)*128)
//SUnit������Ϣ��ʼƫ����
#define RAW_SUNITDETAILOFFSET        (RAW_SUNITDBOFFSET+(((u64)1)<<32))
// ����SUnit������Ϣ��ʼƫ����
// #define RAW_SUNITDETAILOFFSET_SLAVE     RAWPARTION_STARTOFFSET


#define MAX_SVER_LEN     32  //����汾����󳤶�
#define MAX_FILENAME_LEN 256 // �ļ���
#define MAX_DIRNAME_LEN  256 // ·����


//��Ƶ�ֱ���
#define VRES_QCIF			(u8)1	//176*144
#define VRES_CIF			(u8)2	//352*288
#define VRES_2CIF			(u8)3	//704*288
#define VRES_4CIF			(u8)4	//704*576
#define VRES_D1				(u8)5	//704*576
#define VRES_HALFD1			(u8)6	//704*288

#define VRES_QVGA			(u8)7	//320*240
#define VRES_VGA			(u8)8	//640*480
#define VRES_SVGA			(u8)9	//800*600
#define VRES_XGA			(u8)10	//1024*768
#define VRES_1DOT3MP		(u8)11	//1280*1024
#define VRES_2MP			(u8)12	//1600*1200

#define VRES_QQCIF			(u8)13	//80*64

#define VRES_720P			(u8)14	//1280*720


#define VRES_NUM			14


#define CIF_WIDTH			352
#define CIF_HEIGHT			288

#define D1_WIDTH			704
#define D1_HEIGHT			576

/*=========================== ������ ===================================*/
#define RP_PLY_FAST_4				(u8)10			//4���ٿ��
#define RP_PLY_FAST_2				(u8)20			//2���ٿ��
#define RP_PLY_NORMAL               (u8)40			//��������
#define RP_PLY_SLOW_2				(u8)80			//1/2����
#define RP_PLY_SLOW_4				(u8)160			//1/4����

/*==========================  ����״̬ ====================================*/
#define RP_STATE_STOP				(u8)0				//0 //ֹͣ״̬
#define RP_STATE_PLYING			    (u8)1				//1 //���ڲ���״̬
#define RP_STATE_PAUSE				(u8)2				//2 //��ͣ״̬
#define RP_STATE_STEP				(u8)5				//3 //��������״̬

#define SCHEDULE_ALL_TYPE			(u8)0
#define SCHEDULE_ONCE_TYPE			(u8)1
#define SCHEDULE_PERIOD_TYPE		(u8)2
#define SCHEDULE_HAND_TYPE			(u8)3
#define SCHEDULE_ALARM_TYPE			(u8)4

#define TIMESECT_NO_REC			    (u8)0
#define TIMESECT_REC_TYPE			(u8)1
#define TIMESECT_ALARMREC_TYPE		(u8)2 //����������Ч

#define TIMESECT_HYBRIDREC_TYPE		(u8)10 //���¼�����ͣ�����Сʱ¼�����Ͷ��壬��ʾСʱ�ڵķ���¼���������ٴ������������е�2��

//��ʾ����
#define MAX_MULPIC_NUM		(u8)16


//ý������
#define	MEDIATYPE_H261       (u8)10		/*H261  */ 
#define	MEDIATYPE_H263       (u8)20		/*H263  */
#define	MEDIATYPE_MPEG2      (u8)30		/*MPEG2 */
#define	MEDIATYPE_MPEG4      (u8)40		/*MPEG4 */
#define	MEDIATYPE_H264       (u8)50		/*H264  */
#define	MEDIATYPE_MJPEG      (u8)60		/*MOTION_JPEG*/

#define	MEDIATYPE_PCM        (u8)70	    /*PCM */
#define	MEDIATYPE_G711A      (u8)100	/*G711A */
#define	MEDIATYPE_G711U      (u8)110	/*G711U */
#define	MEDIATYPE_G722		 (u8)120	/*G722  */
#define	MEDIATYPE_G723		 (u8)130	/*G723  */
#define	MEDIATYPE_G726		 (u8)135	/*G726  */
#define	MEDIATYPE_G728		 (u8)140	/*G728  */
#define	MEDIATYPE_G729       (u8)150	/*G729  */
#define	MEDIATYPE_MP3        (u8)160	/*MP3   */
#define	MEDIATYPE_AMR        (u8)170	/*AMR   */
#define	MEDIATYPE_ILBC       (u8)180	/*ILBC  */ //JL�Զ�����Ƶ�����ʽ
#define	MEDIATYPE_UNKNOWN    (u8)255	

//��ɫֵ
#define ESTRGB(r,g,b)				((u32)(((u8)(r)|((u16)((u8)(g))<<8))|(((u32)(u8)(b))<<16)))

#define	ESBGCOLOR_OVERLAY			ESTRGB(1, 1, 2)


#define MACADDR_LEN		(u32)17
#define MACADDR_SPLIT	':'
#define MACBASE 16
#define MACVAL_MAX (u64)0xffffffffffffLL

//�����ַ����
typedef struct tagNetAddr
{
	u32   m_dwIp;	 //��ַ(������)
	u16   m_wPort;   //�˿�(������)
}TNetAddr;

//�ļ�ϵͳ����
typedef enum enumFSType
{
	e_FSType_NTFS = 0,
	e_FSType_EXT3,
	e_FSType_FAT32,
	e_FSType_CRAMFS,
	e_FSType_NUDE, //�����
    e_FSType_HFS,
	e_FSType_UNSUPPORT	
}EFsType;


//�����ڴ�˿�Ӧ������
#define MEMPORT_APPTYPE_ENCSND       1     //���뷢��
#define MEMPORT_APPTYPE_FORMFRM      2     //��֡
#define MEMPORT_APPTYPE_RECDL        3     //¼������

//�ڴ�˿ڴ���ṹ
typedef struct{
	u32 m_dwAppType;   //Ӧ������
	u8 *m_pInBuf;      //����Buf
	u32 m_dwInBufLen;  //����Buf����
	u8 *m_pOutBuf;     //���Buf
	u32 m_dwOutBufLen;  //���Buf����

}TMemPortTransData;


typedef struct tagDiskHDiskInfo
{
	char m_szDiskSN[MAX_FILENAME_LEN+1];     //���̴���
	u32 m_dwDiskSizeMB;                      //���̴�С
	u32 m_dwMediaSizeMB;   //�洢ý��Ŀռ��С
	u32 m_dwDiskStatus;    //����״̬ DISKH_DISKSTATUS_NEW or DISKH_DISKSTATUS_HISTORY or DISKH_DISKSTATUS_INVALID

}TDiskHDiskInfo;
// 
// //��Ƶ���������������
// typedef enum 
// { 
// 	SENC_VID_BITRATE,
// 	SENC_VID_FRMRATE,
// 	SENC_VID_IFRM_ITVL,
// 	SENC_VID_RES,       //�ֱ���
// 	//All Param....
// 	SENC_VID_ATTR_UNKNOW
// }ESEncVEncAttrType;
// 
// typedef struct tagESTRect
// {
// 	u32 m_dwX;
// 	u32 m_dwY;
// 	u32 m_dwWidth;
// 	u32 m_dwHeight;
// }TESTRect;
// typedef struct tagESTMoniterInfo
// {
// 	u32 m_dwMonitorKeyID;      //��ʾ�����
// 	TESTRect m_tRect;
// }TESTMoniterInfo;
// typedef struct tagVOChnAttr
// {
// 	u32 m_dwPriority; //���ȼ�[0, 16)
// 	TESTRect m_tRect;
// 	BOOL m_bZoomable;
// }TVOChnAttr;

//���������غ�����
typedef enum EMediaPayLoad
{
	E_MEDIAPAYLOAD_SYSCTX = 1,
	E_MEDIAPAYLOAD_VIDEO,
	E_MEDIAPAYLOAD_AUDIO,
	E_MEDIAPAYLOAD_MIX,
}EMediaPayLoad;

//ԭʼ��Ƶ֡
typedef struct tagVRawFrame
{	
	u32 m_dwWidth; 
	u32 m_dwHeight;
	u32 m_dwTimeStampMs; //ʱ����Ϣ,��λ����
	u32 m_dwFormatType;  //0:yuv420,1:yuyv
	u32 m_dwLen;         //֡����
	u8* m_pbyFrameBuf;   //֡����
}TVRawFrame;

//ԭʼ��Ƶ֡
typedef struct tagARawFrame
{	
	u32 m_dwTimeStampMs; // ʱ����Ϣ,��λ����
	u32 m_dwLen;         // ֡����
	u8* m_pbyFrameBuf;   // ֡����

}TARawFrame;

/* ֡�ṹ*/
typedef struct tagAVRawFrame
{
	u8				m_byPayLoad;  //�غ�
	u32				m_dwFrameId;    //֡���
	u32				m_dwTimeStamp;  //ʱ���
	BOOL			m_bKeyFrame;  //�Ƿ�ؼ�֡
	u32				m_dwWidth;                //ͼ���
	u32				m_dwHeight;                 //ͼ���
	u8				*m_pFrame;         //֡���ݣ�������
	u32				m_dwFrameLen;          //������С
}TAVRawFrame;

//֡�ṹ
typedef struct tagAVFrame
{
	TAVRawFrame m_tRawFrame;
	u32             m_dwMediaCtx;      //ý��������
}TAVFrame;

/*  ���ṹ*/
typedef struct tagAVPack
{
	u8              m_byPayLoad;  //�غ�
	u32				m_dwFrameId;    //֡���
	u16				m_wFramePackTotal;  //�ܰ���
	u16             m_wPackSeq;     //�����
	BOOL			m_bLast;            //�Ƿ�߽�
	u32				m_dwTimeStamp;  //ʱ���
	BOOL			m_bKeyFrame;  //�Ƿ�ؼ�֡
	u32				m_dwWidth;                //ͼ���
	u32				m_dwHeight;                 //ͼ���
	u8              *m_pPack;          //������
	u32				m_dwPackSize;   //�����ݴ�С    
}TAVPack;

typedef struct tagDWPlyFrmHead
{
	u8		m_byStreamIdx;   //������
	u8      m_byPayLoad;  //�غ�
	u8      m_byKeyFlag;     //�ؼ�֡��־
	u8      m_byReserve;     //����
	u32		m_dwMediaContext;	//
	u64     m_qwStamp;       //��֡���ݵľ���ʱ���
	u32     m_dwWidth;       //���
	u32     m_dwHeight;      //�߶�
	u32     m_dwFrmLen;      //֡��
	u8*     m_pFrame;        //֡��Ч����
}TDWPlyFrmHead;

//VOD¼������ʱ����Ƭ��Ƭͷ
//�ڴ�˿�¼������ʱ����Ƭ��Ƭͷ
// typedef struct tagDWPlyFragmentHead
// {
// 	u64     m_qwStamp;           //��Ƭ���ڿ�ľ���ʱ���
// 	u32     m_dwBlockDurationMs; //��Ƭ���ڿ�ĳ���
// 	u32     m_dwFragmentSeq;     //��Ƭ�ڿ��е�λ��, ==0 ��ʾ��������Ϣ
// 	u32     m_dwFragmentTotal;   //��Ƭ���ڿ����Ƭ��
// 	u32     m_dwPackStartSeq;    //��Ƭ�ڵ���ʼ�����
// 	u32     m_dwPackEndSeq;      //��Ƭ�ڵĽ��������
// 	u32     m_dwBlockID;         //��Ƭ���ڿ�ID��INVALID_U32ID��ʾ��ǰ��������һ��Block
// 	u32     m_dwBlockSize;       //��Ƭ���ڿ�Ĵ�С(�ֽ�)
// 	u32		 m_dwMediaContext;	 //ý��������
// 	u32     m_dwFragmentLen;     //Ƭ��
// 	u8*     m_pFragment;         //Ƭ��Ч����
// }TDWPlyFragmentHead;

//���뷢���ڴ�˿ڽṹ
typedef struct tagEncSndAVPacks
{
	u32 m_dwPackNum;
	TAVPack *m_ptAVPack;

}TEncSndAVPacks;

//�ڴ�˿���֡ԭʼ���ṹ
typedef struct tagFormFrmRawAVPack
{
	u8 *m_pPack;
	u32 m_dwPackLen;

}TFormFrmRawAVPack;

typedef struct tagDispChnPos
{   
	u32 m_dwTopLeftX;	//���ϽǺ�����
	u32	m_dwTopLeftY;	// ���Ͻ�������
	u32 m_dwBtmRightX;	// ���½Ǻ�����
	u32	m_dwBtmRightY;  // ���½�������
}TDispChnPos; 

typedef struct tagLayout
{
	u32 m_dwHNum;			//X ���򻮷ֵĵ�Ԫ
	u32 m_dwVNum;			// Y
	u32 m_dwPicNum;			//��ʾ�Ļ������
	TDispChnPos m_atDispChnPos[MAX_MULPIC_NUM]; //ͨ��λ������
}TDispPortLayout;

//����������ÿ��ģ�鶼��Ҫ�ģ�
typedef struct tagCommInitParam
{
	void*               m_hTimerLib;               //��ʱ����
	void*               m_hMem;                    //�ڴ����
	u32                 m_hWDHdl;                  //���Ź�
	void* m_dwTelHdl;                //telnet���
	void*				m_hRealTimerLib;			   //ʵʱ��ʱ����,�������ȼ�������(�����)����
	void*				m_hSlowTimerLib;			   //����ʵʱ���������
	void*				m_hNetTimerLib;			   //�������������
	u32					m_dwErrDescDict;           //�����������ֵ�
	u32 				m_dwOdbcInstId;            //odbc����
	u32 				m_dwSessionId;             //odbcSesstion
	u32					m_dwReserve2;
	u32					m_dwReserve3;
	u32					m_dwReserve4;
	u32					m_dwReserve5;
	u32					m_dwReserve6;
}TCommInitParam;

u64 MAC2U64(const s8 *pchMac);
s8* U642MAC(u64 qwVal);

/*=================================================================
�� �� ��: VerCmp
��    ��: �汾�űȽ�
�������:	psVerA -- �汾A
			psVerB -- �汾B
����ֵ˵�����汾����ͬ��TRUE����ͬ��FALSE
=================================================================*/
BOOL VerCmp(IN s8 *psVerA, IN s8 *psVerB);
/*=============================================================================
������: ConvertU8ToHexStr
����  : �ֽ�ת16���ƴ�
����  : u8 *pBuf
u32 dwInBufLen
char* pchHexStr
u32 dwMaxHexStrLen
����ֵ: BOOL 
--------------------------------------------------------------------------
�޸ļ�¼:
��    ��     �汾        �޸���      �޸�����
2007/8/22    1.0         Steven      ����
=============================================================================*/
BOOL ConvertU8ToHexStr(u8 *pBuf,u32 dwInBufLen,char* pchHexStr,u32 dwMaxHexStrLen);

/*=============================================================================
������: ConvertHexStrToU8
����  : 16���ƴ�ת�ֽ�
����  : char *pchHexStr
u8 *pBuf
u32 dwInBufLen
����ֵ: BOOL 
--------------------------------------------------------------------------
�޸ļ�¼:
��    ��     �汾        �޸���      �޸�����
2007/8/22    1.0         Steven      ����
=============================================================================*/
BOOL ConvertHexStrToU8(char *pchHexStr,u8 *pBuf,u32 dwInBufLen);

//��Ƶ�ֱ���ת���
BOOL Res2WH(IN u8 byRes, OUT u32 *pdwWidth, OUT u32 *pdwHeight);


//���ת��Ƶ�ֱ���
BOOL WH2Res( IN u32 dwWidth, IN u32 dwHeight, OUT u8 *pbyRes);


//��Ƶ�ֱ���תΪQCIF�ĸ���
BOOL Res2QCIFNum(IN u8 byRes, OUT u32 *pdwQCIFNum);

#ifdef __cplusplus
}
#endif

// #define EST_SIZEALIGN(x, align) ((x + align - 1)/align * align)

// exe xml��Դ���ƶ���
// #define DSVSS_CMC_GUIXML         "CMCXML"         // CMC
// #define DSVSS_MNGAPP_GUIXML      "MNGAPPXML"      // Mngapp
// #define DSVSS_MNC_GUIXML         "NMCXML"         // NMC
// #define DSVSS_CMCINSTALL_GUIXML  "CMCINSTALLXML"  // CMCInstall
// #define DSVSS_DATAEXPLORE_GUIXML  "DATAEXPLOREXML"  // DataExplore
// #define DSVSS_TVWALLS_GUIXML       "TVWALLSXML"  // TVW Server

#endif // _VSS_VMDEF_H





