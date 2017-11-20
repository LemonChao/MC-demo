/*****************************************************************************
模块名      : vssdefine.h
文件名      : vssdefine.h
相关文件    : 各模块的开发文件
文件实现功能: 提供vss监控系统应用相关的基本规则定义
作者        : chenhb 
版本        : V1.0  Copyright(C) 2006-2008 DS, All rights reserved.
-----------------------------------------------------------------------------
修改记录:
日  期        版本        修改人      修改内容
2012/03/05    1.0         chenhb          Create

说明：本文件定义多个模块共同遵守的应用相关的规则，如媒体类型、用户名最大长度等。
	  网络传输，数据库存储模块慎用此模块中的结构!!!	
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

//while 循环宏定义

#ifdef _LINUX_
#define __FUNCDNAME__ "noname"
#endif

#define MAXWHILE_DFTCYCLE (u32)(0xfffffffe)

//缺省循环次数
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

//指定循环次数(建议使用)
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

//主要用于任务的循环
#define WHILE_FOREVER(cond)	while(cond)



//带超时的条件等待
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


//带超时的条件等待，bTimeout的值反映是否超时，必须为BOOL变量
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

// #define ESIGHT_NONEDEV					(u32)(-1)			//无效设备
// 
// #define EPC_STR		"EsightPc"
// #define EPC_AREHUB	"EsightAreHub"
// 
// #define ESIGHT_SERIALNO_MAXLEN			(u32)64	//序列号长度
// #define ESIGHT_HVER_LEN					(u32)32	//硬件版本号长度
// #define ESIGHT_SVER_LEN					(u32)32	//软件版本号长度	
// #define ESIGHT_MACADDR_LEN				(u32)32  //mac地址长度

//统一对象类型
#define UOTYPE_INVALID					(u8)0  //无效的类型

#define UOTYPE_IPVU						(u8)1	//IPVU	
#define UOTYPE_MS						(u8)2   //监控工作站
#define UOTYPE_VMCS						(u8)3	//监控服务器
#define UOTYPE_VMCC						(u8)4	//监控客户端
#define UOTYPE_IPVU_ENCPORT				(u8)5	//编码端口（采集端口）
#define UOTYPE_IPVU_DECPORT				(u8)6	//解码端口（播放端口）
#define UOTYPE_IPVU_SERIALPORT			(u8)7	//串口
#define	UOTYPE_IPVU_ONOFFPORT			(u8)8	//二进制端口
#define UOTYPE_IPVU_ENCCHN				(u8)9	//编码通道
#define UOTYPE_IPVU_DECCHN				(u8)10	//解码通道
#define UOTYPE_IPVU_RECCHN				(u8)11	//录像通道
#define UOTYPE_IPVU_PLYCHN				(u8)12	//放像通道

#define UOTYPE_IPVU_VENCPORT			(u8)13	//视频编码端口
#define UOTYPE_IPVU_VDECPORT			(u8)14	//视频解码端口
#define UOTYPE_IPVU_AENCPORT			(u8)15	//音频编码端口
#define UOTYPE_IPVU_ADECPORT			(u8)16	//音频编码端口

#define UOTYPE_IPVU_VENCCHN				(u8)17	//视频编码通道
#define UOTYPE_IPVU_VDECCHN				(u8)18	//视频解码通道
#define UOTYPE_IPVU_AENCCHN				(u8)19	//音频编码通道
#define UOTYPE_IPVU_ADECCHN				(u8)20	//音频解码通道


#define UOTYPE_VMTSESSION				UOTYPE_VMCC
#define UOTYPE_VMS						UOTYPE_VMCS

//内部编号定义
#define SYSTIMEID_INTRA					0
#define PTMID_INTRA						0
#define DEVID_INTRA						0


//本机IP地址最大数
#define MAX_LOCALIP_NUM      16

//最大帧长, 包长
#define MAX_HD_VIDFRM_LEN	(u32)(512<<10) //高清图像，V3R0不支持
#define MAX_VIDFRM_LEN		(u32)(128<<10)
#define MAX_AUDFRM_LEN		(u32)(4<<10)
#define MAX_PACK_LEN		(u32)1400
#define MAXNALU_ONEFRAME	(u32)512 //一帧码流中片的最大个数

//定码率，变码率
#define BITRATE_CBR			0 //定码率
#define BITRATE_VBR			1 //变码率

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

#define MAX_MASK_NUM			4			//视频遮挡区域的最大个数(hi3510最多1个，hi3511最多4个)
#define WM_KEY_LEN				8			//水印密钥长度
#define WM_STR_LEN				16			//水印字符串长度

#define MAX_3511_MDBLOCK_WIDTH	44			//704/16
#define MAX_3511_MDBLOCK_HEIGHT	36			//576/16
#define MAX_3511_MDBLOCK_NUM	(MAX_3511_MDBLOCK_WIDTH * MAX_3511_MDBLOCK_HEIGHT)

#define MAX_MDBLOCK_WIDTH		MAX_3511_MDBLOCK_WIDTH
#define MAX_MDBLOCK_HEIGHT		MAX_3511_MDBLOCK_HEIGHT
#define MAX_MDBLOCK_NUM			MAX_3511_MDBLOCK_NUM


//定义FastFile块大小
#define FASTFILE_BLOCKSIZE       4096

//定义DVR上各应用在磁盘上的起始偏移量

//定义DiskTool起始偏移量
#define DISKTOOL_STARTOFFSET         ((u64)0)
//定义DiskTool结束偏移量
#define DISKTOOL_ENDOFFSET           ((u64)1*1024*1024)
//DiskHunter起始偏移量
#define DISKHUNTER_STARTOFFSET       DISKTOOL_ENDOFFSET
//数据库裸分区起始偏移量
#define RAWPARTION_STARTOFFSET		 ((u64)8*1024*1024)
//LOGDB起始偏移量
#define RAW_LOGDBOFFSET              RAWPARTION_STARTOFFSET
//SUnit主控DB起始偏移量
#define RAW_SUNITDBOFFSET            (RAW_LOGDBOFFSET+((u64)1<<20)*128)
//SUnit描述信息起始偏移量
#define RAW_SUNITDETAILOFFSET        (RAW_SUNITDBOFFSET+(((u64)1)<<32))
// 从盘SUnit描述信息起始偏移量
// #define RAW_SUNITDETAILOFFSET_SLAVE     RAWPARTION_STARTOFFSET


#define MAX_SVER_LEN     32  //软件版本号最大长度
#define MAX_FILENAME_LEN 256 // 文件名
#define MAX_DIRNAME_LEN  256 // 路径名


//视频分辨率
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

/*=========================== 放像倍速 ===================================*/
#define RP_PLY_FAST_4				(u8)10			//4倍速快放
#define RP_PLY_FAST_2				(u8)20			//2倍速快放
#define RP_PLY_NORMAL               (u8)40			//正常速率
#define RP_PLY_SLOW_2				(u8)80			//1/2慢放
#define RP_PLY_SLOW_4				(u8)160			//1/4慢放

/*==========================  放像状态 ====================================*/
#define RP_STATE_STOP				(u8)0				//0 //停止状态
#define RP_STATE_PLYING			    (u8)1				//1 //正在播放状态
#define RP_STATE_PAUSE				(u8)2				//2 //暂停状态
#define RP_STATE_STEP				(u8)5				//3 //步进播放状态

#define SCHEDULE_ALL_TYPE			(u8)0
#define SCHEDULE_ONCE_TYPE			(u8)1
#define SCHEDULE_PERIOD_TYPE		(u8)2
#define SCHEDULE_HAND_TYPE			(u8)3
#define SCHEDULE_ALARM_TYPE			(u8)4

#define TIMESECT_NO_REC			    (u8)0
#define TIMESECT_REC_TYPE			(u8)1
#define TIMESECT_ALARMREC_TYPE		(u8)2 //仅对周期有效

#define TIMESECT_HYBRIDREC_TYPE		(u8)10 //混合录像类型，用于小时录像类型定义，表示小时内的分钟录像类型至少存在以上类型中的2种

//显示布局
#define MAX_MULPIC_NUM		(u8)16


//媒体类型
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
#define	MEDIATYPE_ILBC       (u8)180	/*ILBC  */ //JL自定义音频编码格式
#define	MEDIATYPE_UNKNOWN    (u8)255	

//颜色值
#define ESTRGB(r,g,b)				((u32)(((u8)(r)|((u16)((u8)(g))<<8))|(((u32)(u8)(b))<<16)))

#define	ESBGCOLOR_OVERLAY			ESTRGB(1, 1, 2)


#define MACADDR_LEN		(u32)17
#define MACADDR_SPLIT	':'
#define MACBASE 16
#define MACVAL_MAX (u64)0xffffffffffffLL

//网络地址参数
typedef struct tagNetAddr
{
	u32   m_dwIp;	 //地址(网络序)
	u16   m_wPort;   //端口(本机序)
}TNetAddr;

//文件系统类型
typedef enum enumFSType
{
	e_FSType_NTFS = 0,
	e_FSType_EXT3,
	e_FSType_FAT32,
	e_FSType_CRAMFS,
	e_FSType_NUDE, //裸分区
    e_FSType_HFS,
	e_FSType_UNSUPPORT	
}EFsType;


//定义内存端口应用类型
#define MEMPORT_APPTYPE_ENCSND       1     //编码发送
#define MEMPORT_APPTYPE_FORMFRM      2     //组帧
#define MEMPORT_APPTYPE_RECDL        3     //录像下载

//内存端口传输结构
typedef struct{
	u32 m_dwAppType;   //应用类型
	u8 *m_pInBuf;      //输入Buf
	u32 m_dwInBufLen;  //输入Buf长度
	u8 *m_pOutBuf;     //输出Buf
	u32 m_dwOutBufLen;  //输出Buf长度

}TMemPortTransData;


typedef struct tagDiskHDiskInfo
{
	char m_szDiskSN[MAX_FILENAME_LEN+1];     //磁盘串号
	u32 m_dwDiskSizeMB;                      //磁盘大小
	u32 m_dwMediaSizeMB;   //存储媒体的空间大小
	u32 m_dwDiskStatus;    //磁盘状态 DISKH_DISKSTATUS_NEW or DISKH_DISKSTATUS_HISTORY or DISKH_DISKSTATUS_INVALID

}TDiskHDiskInfo;
// 
// //视频编码参数属性类型
// typedef enum 
// { 
// 	SENC_VID_BITRATE,
// 	SENC_VID_FRMRATE,
// 	SENC_VID_IFRM_ITVL,
// 	SENC_VID_RES,       //分辨率
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
// 	u32 m_dwMonitorKeyID;      //显示器编号
// 	TESTRect m_tRect;
// }TESTMoniterInfo;
// typedef struct tagVOChnAttr
// {
// 	u32 m_dwPriority; //优先级[0, 16)
// 	TESTRect m_tRect;
// 	BOOL m_bZoomable;
// }TVOChnAttr;

//定义码流载荷类型
typedef enum EMediaPayLoad
{
	E_MEDIAPAYLOAD_SYSCTX = 1,
	E_MEDIAPAYLOAD_VIDEO,
	E_MEDIAPAYLOAD_AUDIO,
	E_MEDIAPAYLOAD_MIX,
}EMediaPayLoad;

//原始视频帧
typedef struct tagVRawFrame
{	
	u32 m_dwWidth; 
	u32 m_dwHeight;
	u32 m_dwTimeStampMs; //时标信息,单位毫秒
	u32 m_dwFormatType;  //0:yuv420,1:yuyv
	u32 m_dwLen;         //帧长度
	u8* m_pbyFrameBuf;   //帧缓冲
}TVRawFrame;

//原始音频帧
typedef struct tagARawFrame
{	
	u32 m_dwTimeStampMs; // 时标信息,单位毫秒
	u32 m_dwLen;         // 帧长度
	u8* m_pbyFrameBuf;   // 帧缓冲

}TARawFrame;

/* 帧结构*/
typedef struct tagAVRawFrame
{
	u8				m_byPayLoad;  //载荷
	u32				m_dwFrameId;    //帧序号
	u32				m_dwTimeStamp;  //时间戳
	BOOL			m_bKeyFrame;  //是否关键帧
	u32				m_dwWidth;                //图像宽
	u32				m_dwHeight;                 //图像高
	u8				*m_pFrame;         //帧数据，纯码流
	u32				m_dwFrameLen;          //码流大小
}TAVRawFrame;

//帧结构
typedef struct tagAVFrame
{
	TAVRawFrame m_tRawFrame;
	u32             m_dwMediaCtx;      //媒体上下文
}TAVFrame;

/*  包结构*/
typedef struct tagAVPack
{
	u8              m_byPayLoad;  //载荷
	u32				m_dwFrameId;    //帧序号
	u16				m_wFramePackTotal;  //总包数
	u16             m_wPackSeq;     //包序号
	BOOL			m_bLast;            //是否边界
	u32				m_dwTimeStamp;  //时间戳
	BOOL			m_bKeyFrame;  //是否关键帧
	u32				m_dwWidth;                //图像宽
	u32				m_dwHeight;                 //图像高
	u8              *m_pPack;          //包数据
	u32				m_dwPackSize;   //包数据大小    
}TAVPack;

typedef struct tagDWPlyFrmHead
{
	u8		m_byStreamIdx;   //流索引
	u8      m_byPayLoad;  //载荷
	u8      m_byKeyFlag;     //关键帧标志
	u8      m_byReserve;     //保留
	u32		m_dwMediaContext;	//
	u64     m_qwStamp;       //该帧数据的绝对时间戳
	u32     m_dwWidth;       //宽度
	u32     m_dwHeight;      //高度
	u32     m_dwFrmLen;      //帧长
	u8*     m_pFrame;        //帧有效数据
}TDWPlyFrmHead;

//VOD录像下载时，分片的片头
//内存端口录像下载时，分片的片头
// typedef struct tagDWPlyFragmentHead
// {
// 	u64     m_qwStamp;           //该片所在块的绝对时间戳
// 	u32     m_dwBlockDurationMs; //该片所在块的长度
// 	u32     m_dwFragmentSeq;     //该片在块中的位置, ==0 表示块索引信息
// 	u32     m_dwFragmentTotal;   //该片所在块的总片数
// 	u32     m_dwPackStartSeq;    //该片内的起始包序号
// 	u32     m_dwPackEndSeq;      //该片内的结束包序号
// 	u32     m_dwBlockID;         //该片所在块ID，INVALID_U32ID表示当前传输的最后一个Block
// 	u32     m_dwBlockSize;       //该片所在块的大小(字节)
// 	u32		 m_dwMediaContext;	 //媒体上下文
// 	u32     m_dwFragmentLen;     //片长
// 	u8*     m_pFragment;         //片有效数据
// }TDWPlyFragmentHead;

//编码发送内存端口结构
typedef struct tagEncSndAVPacks
{
	u32 m_dwPackNum;
	TAVPack *m_ptAVPack;

}TEncSndAVPacks;

//内存端口组帧原始包结构
typedef struct tagFormFrmRawAVPack
{
	u8 *m_pPack;
	u32 m_dwPackLen;

}TFormFrmRawAVPack;

typedef struct tagDispChnPos
{   
	u32 m_dwTopLeftX;	//左上角横坐标
	u32	m_dwTopLeftY;	// 左上角纵坐标
	u32 m_dwBtmRightX;	// 右下角横坐标
	u32	m_dwBtmRightY;  // 右下角纵坐标
}TDispChnPos; 

typedef struct tagLayout
{
	u32 m_dwHNum;			//X 方向划分的单元
	u32 m_dwVNum;			// Y
	u32 m_dwPicNum;			//显示的画面个数
	TDispChnPos m_atDispChnPos[MAX_MULPIC_NUM]; //通道位置数组
}TDispPortLayout;

//公共参数（每个模块都需要的）
typedef struct tagCommInitParam
{
	void*               m_hTimerLib;               //定时器库
	void*               m_hMem;                    //内存管理
	u32                 m_hWDHdl;                  //看门狗
	void* m_dwTelHdl;                //telnet句柄
	void*				m_hRealTimerLib;			   //实时定时器库,供高优先级的任务(如编码)调用
	void*				m_hSlowTimerLib;			   //供非实时的任务调用
	void*				m_hNetTimerLib;			   //供网络任务调用
	u32					m_dwErrDescDict;           //错误码描述字典
	u32 				m_dwOdbcInstId;            //odbc连接
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
函 数 名: VerCmp
功    能: 版本号比较
输入参数:	psVerA -- 版本A
			psVerB -- 版本B
返回值说明：版本号相同，TRUE；不同，FALSE
=================================================================*/
BOOL VerCmp(IN s8 *psVerA, IN s8 *psVerB);
/*=============================================================================
函数名: ConvertU8ToHexStr
功能  : 字节转16进制串
参数  : u8 *pBuf
u32 dwInBufLen
char* pchHexStr
u32 dwMaxHexStrLen
返回值: BOOL 
--------------------------------------------------------------------------
修改记录:
日    期     版本        修改人      修改内容
2007/8/22    1.0         Steven      创建
=============================================================================*/
BOOL ConvertU8ToHexStr(u8 *pBuf,u32 dwInBufLen,char* pchHexStr,u32 dwMaxHexStrLen);

/*=============================================================================
函数名: ConvertHexStrToU8
功能  : 16进制串转字节
参数  : char *pchHexStr
u8 *pBuf
u32 dwInBufLen
返回值: BOOL 
--------------------------------------------------------------------------
修改记录:
日    期     版本        修改人      修改内容
2007/8/22    1.0         Steven      创建
=============================================================================*/
BOOL ConvertHexStrToU8(char *pchHexStr,u8 *pBuf,u32 dwInBufLen);

//视频分辨率转宽高
BOOL Res2WH(IN u8 byRes, OUT u32 *pdwWidth, OUT u32 *pdwHeight);


//宽高转视频分辨率
BOOL WH2Res( IN u32 dwWidth, IN u32 dwHeight, OUT u8 *pbyRes);


//视频分辨率转为QCIF的个数
BOOL Res2QCIFNum(IN u8 byRes, OUT u32 *pdwQCIFNum);

#ifdef __cplusplus
}
#endif

// #define EST_SIZEALIGN(x, align) ((x + align - 1)/align * align)

// exe xml资源名称定义
// #define DSVSS_CMC_GUIXML         "CMCXML"         // CMC
// #define DSVSS_MNGAPP_GUIXML      "MNGAPPXML"      // Mngapp
// #define DSVSS_MNC_GUIXML         "NMCXML"         // NMC
// #define DSVSS_CMCINSTALL_GUIXML  "CMCINSTALLXML"  // CMCInstall
// #define DSVSS_DATAEXPLORE_GUIXML  "DATAEXPLOREXML"  // DataExplore
// #define DSVSS_TVWALLS_GUIXML       "TVWALLSXML"  // TVW Server

#endif // _VSS_VMDEF_H





