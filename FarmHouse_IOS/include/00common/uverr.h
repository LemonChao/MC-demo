/*****************************************************************************
模块名      : uverr
文件名      : uverr.h
相关文件    : 各模块的XXXErr.c
文件实现功能: 提供Focus监控系统中错误码的解释信息
作者        : yangxin 
版本        : V1.0  Copyright(C) 2006-2008 FOCUS, All rights reserved.
-----------------------------------------------------------------------------
修改记录:
日  期      版本        修改人      修改内容
2007/6/22   1.0         yangxin      Create
2007/8/21   1.0         yangxin      增加 ERRLOWBITS_GET
2007/8/24   1.0         yangxin      增加 COMMDB_ERRBASE
2007/10/30  1.0			yangxin		 增加 47FocusAAATP 的定义
2007/11/01  1.0			yangxin		 增加 SmartEnc6104Hisi 的定义
2007/11/21  1.0			yangxin		 增加 E6201BSP_ERRBASE  的定义
2007/12/03  1.0			yangxin		 增加 SKEYBOARD_ERRBASE  的定义
2007/12/08  1.0			yangxin		 增加 CBBW5RKDog 的相关定义
2007/12/12  1.0			yangxin		 增加CBBA2MGuipTP的相关定义
2007/12/21  1.0			yangxin		 增加HisiBspComm, SmartStub的相关定义
2008/01/04  1.0			yangxin		 增加CBBU7SmartUPnP的相关定义
2008/04/05  1.0			yangxin		 增加CBBM5ATP的相关定义
2008/04/11  1.0			yangxin		 增加CBBV8WebServer的相关定义
2008/07/25  1.0			yangxin		 增加IPVU_RSRVSNDTBL_ERRBASE
2008/10/14  1.0			yangxin		 增加CBBJ2FSDB的相关定义
2008/11/03  1.0			yangxin		 增加CBBH6DNSRegM的相关定义
2008/11/12  1.0			yangxin		 增加CBBJ50TRANSACTION的相关定义
2008/11/25  1.0			yangxin		 增加CBBE80Hi3511Codec的相关定义
2008/11/25  1.0			yangxin		 增加CBBM6IPVUATP的相关定义
2009/04/13  1.0			yangxin		 增加CBB11MemPort的相关定义
2009/05/04  1.0			yangxin		 增加ABSVEnc的相关定义
2009/07/27  1.0			yangxin		 增加CBBV61BPTREE的相关定义
2009/08/18  1.0			yangxin		 增加CBBF95YUVQue的相关定义
******************************************************************************/

#ifndef _uverr_H
#define _uverr_H

#ifdef __cplusplus
extern "C" {
#endif 

#define ERRBASE_SET(base)		((u32)base << 16)  //错误码的基数放在高16位，低16位为各模块内部具体的错误码				
#define ERRBASE_GET(err)		(err & 0xffff0000) //得到具体错误码的基数
#define ERRLOWBITS_GET(err)		(err & 0x0000ffff) //得到具体错误码的低16位

#define MAX_ERRINFO_LEN			100 //错误码解释的最大长度。定义此宏完全是为了函数调用方便。实际模块的错误码解释的长度并不限制。
							    

/*================================= 错误码分配 ================================*/

#define EXBSP_ERRBASE				ERRBASE_SET(6)		//CBBG00EXBsp

#define E6101ENC_ERRBASE			ERRBASE_SET(20)		//CBBE06101ENC
#define E6201DEC_ERRBASE			ERRBASE_SET(30)		//CBBF06201DEC
#define E6101OSD_ERRBASE			ERRBASE_SET(40)		//CBBE56101OSD
#define	HISIAENC_ERRBASE			ERRBASE_SET(50)		//CBBF6HisiAEnc
#define	HISIADEC_ERRBASE			ERRBASE_SET(60)		//CBBF8HisiADec
#define	HISI_CODEC_ERRBASE			ERRBASE_SET(66)		//CBBE80Hi3511Codec
#define	HISI_PLAY_ERRBASE			ERRBASE_SET(68)		//CBBF82Hi3511Play

#define SPIENC_ERRBASE				ERRBASE_SET(70)		//CBBE7SpiEnc

#define COMMDB_ERRBASE				ERRBASE_SET(0xffff) //db公共错误基数，由于底层数据库的错误码为负数。
#define ESDB_ERRBASE                ERRBASE_SET(190)

#define RPDB_ERRBASE				ERRBASE_SET(100)	//CBBJ0RPDB
#define FSDB_ERRBASE				ERRBASE_SET(105)	//CBBJ2FSDB
#define AAADBA_ERRBASE				ERRBASE_SET(110)	//CBB90AAADBA
#define CLTDBA_ERRBASE				ERRBASE_SET(120)	//CBBP0CLTDBA
#define DEVDBA_ERRBASE				ERRBASE_SET(130)	//CBBQ0DEVDBA
#define SVRDBA_ERRBASE				ERRBASE_SET(140)	//CBBR0SVRDBA
#define NMDBA_ERRBASE				ERRBASE_SET(150)	//CBBS0NMDBA
#define LOGDBA_ERRBASE				ERRBASE_SET(160)	//CBBT0LOGDBA
#define	TRANSDB_ERRBASE				ERRBASE_SET(170)	//CBBJ5TRANSDB
#define	TRANSACTION_ERRBASE			ERRBASE_SET(175)	//CBBJ50TRANSACTION
#define	RPFINEAPI_ERRBASE			ERRBASE_SET(180)	//CBBJ6RPFineAPI

#define OAL_ERRBASE					ERRBASE_SET(200)	//CBBL0OAL
#define OTL_ERRBASE					ERRBASE_SET(210)	//CBBM0OTL
#define ATP_ERRBASE					ERRBASE_SET(220)	//CBBM5ATP
#define IPVUATP_ERRBASE				ERRBASE_SET(230)	//CBBM6IPVUATP
#define ABSVENC_ERRBASE				ERRBASE_SET(250)	//CBBM32ABSVENC
#define ABSVDEC_ERRBASE				ERRBASE_SET(251)	//CBBM33ABSVDEC
#define ABSAENC_ERRBASE				ERRBASE_SET(252)	//CBBM30ABSAENC
#define ABSADEC_ERRBASE				ERRBASE_SET(253)	//CBBM31ABSADEC

#define WIRELESS_ERRBASE			ERRBASE_SET(280)	//CBBM8WIRELESS

#define FSMP_ERRBASE				ERRBASE_SET(300)	//10FocusFSMP
#define AVNET_ERRBASE				ERRBASE_SET(310)	//CBB20AVNet
#define VODNET_ERRBASE				ERRBASE_SET(315)	//CBB22VODNet
#define SIGNET_ERRBASE				ERRBASE_SET(320)	//CBB25SIGNet
#define TCPNET_ERRBASE				ERRBASE_SET(325)	//CBB26TcpNet
#define IPMATRIX_ERRBASE			ERRBASE_SET(330)	//CBB10Ipmatrix
#define MEMPORT_ERRBASE				ERRBASE_SET(335)	//CBB11MemPort	
#define DIPMATRIX_ERRBASE			ERRBASE_SET(340)	//CBB80DIpMatrix
#define RPFS_ERRBASE				ERRBASE_SET(350)	//CBBI0RPFS
#define ISC_ERRBASE					ERRBASE_SET(360)	//CBBV2ISC
#define EXML_ERRBASE				ERRBASE_SET(370)	//CBBV5EXML
#define BPTREE_ERRBASE				ERRBASE_SET(375)	//CBBV61BPTREE
#define TUPLEFILE_ERRBASE				ERRBASE_SET(376)	//CBBV3TupleFile
#define GROUPDB_ERRBASE				ERRBASE_SET(377)	//CBBV4GroupDB
#define DISTDB_ERRBASE				ERRBASE_SET(378)	//CBBV43DistDB
#define WINH264DEC_ERRBASE			ERRBASE_SET(380)	//50Winh264Dec
#define WEBSERVER_ERRBASE			ERRBASE_SET(390)	//CBBV8WebServer
#define FASTFILE_ERRBASE			ERRBASE_SET(392)	//CBBV7FastFile
#define DISKFILE_ERRBASE			ERRBASE_SET(394)	//CBBV10DiskFile	


#define ASFFILE_ERRBASE             ERRBASE_SET(500) //CBBL2ASFFILE

#define SENC_ERRBASE				ERRBASE_SET(600)	//CBBB9SmartEncInterface, 注：SmartEncWin32, SmartEncHisi 共用此基数，但各自模块都有自己的实现
#define SENCWIN32_ERRBASE			SENC_ERRBASE	//CBBB0SmartEncWin32
#define SMARTENCHISI_ERRBASE		SENC_ERRBASE	//CBBB5SmartEncHisi

#define SDEC_ERRBASE				ERRBASE_SET(610)	//CBBC9SmartDecInterface, 注：SmartDecWin32, SmartDecHisi 共用此基数，但各自模块都有自己的实现
#define SDECWIN32_ERRBASE			SDEC_ERRBASE	//CBBC0SmartDecWin32
#define SDECHISI_ERRBASE			SDEC_ERRBASE	//CBBC5SmartDecHisi

#define SMARTEVENT_ERRBASE			ERRBASE_SET(612)	//CBBC8SmartEvent	
#define MDPU_ERRBASE				ERRBASE_SET(614)	//CBBC30MDPU	

#define SRP_ERRBASE					ERRBASE_SET(620)	//CBBH0SmartRP
#define MRPDATA_ERRBASE				ERRBASE_SET(622)	//CBBH1MRPDATA
#define DNSREGC_ERRBASE				ERRBASE_SET(625)	//CBBH6DNSRegM
#define SIO_ERRBASE					ERRBASE_SET(630)	//CBBU0SmartIO
#define SPTZ_ERRBASE				ERRBASE_SET(640)	//CBBU5SmartPTZ
#define SKEYBOARD_ERRBASE			ERRBASE_SET(680)	//CBBU6SmartKeyBoard
#define SUPNP_ERRBASE				ERRBASE_SET(690)	//CBBU7SmartUPnP
#define NATBUS_ERRBASE				ERRBASE_SET(695)	//CBBU8NatBus

#define SENC6104_ERRBASE			ERRBASE_SET(650)	//CBBB7SMARTENC6104HISI

#define SAUDENC_ERRBASE				ERRBASE_SET(660)    //CBBB4SmartAudioEncHisi
#define SAUDDEC_ERRBASE				ERRBASE_SET(670)    //CBBC4SmartAudioDecHisi

#define	IPVULOGIC_ERRBASE			ERRBASE_SET(700)	//CBBD0IPVULOGIC
#define	RPLOGIC_ERRBASE				ERRBASE_SET(701)	//CBBD8RPLogic
#define	E6101IPVULOGIC_ERRBASE		ERRBASE_SET(710)	//CBBD56101IPVULogic
#define VMSBFINEAPI_ERRBASE			ERRBASE_SET(720)	//CBBX1VMSBFINEAPI
#define VMSBSIMPLEAPI_ERRBASE		ERRBASE_SET(730)	//CBBX5VMSBSIMPLEAPI
#define VMSPFINEAPI_ERRBASE			ERRBASE_SET(735)	//CBBX8FineAPI
#define IPVUSECURITY_ERRBASE	    ERRBASE_SET(740)	//CBBD66101Security
#define	RKDOG_ERRBASE				ERRBASE_SET(750)	//CBBW5RKDog
#define	HVRLOGIC_ERRBASE			ERRBASE_SET(760)	//CBBD6HVRLOGIC
#define	IPVUHUB_ERRBASE				ERRBASE_SET(770)	//IPVUHUB_ERRBASE
#define	FLASHMEMSHADOW_ERRBASE		ERRBASE_SET(780)	//CBBD12FlashMemShadow

#define S2HSTREAM_ERRBASE			ERRBASE_SET(790)	//CBBF92S2HStream
#define YUVQUE_ERRBASE				ERRBASE_SET(792)	//CBBF95YUVQue
#define PCILMSG_ERRBASE				ERRBASE_SET(794)	//CBBF96PCILMsg

#define HxS_ERRBASE					ERRBASE_SET(800)	//CBBK2HXSTACK

#define GUITP_ERRBASE				ERRBASE_SET(1000)		//CBBA0GuiTP	
#define VMSP_ERRBASE				ERRBASE_SET(1050)		//32FocusVMSP
#define MSTP_ERRBASE				ERRBASE_SET(1100)		//36FocusMSTP
#define WINGUIP_ERRBASE				ERRBASE_SET(1200)		//40WinGuiP
#define VMCCTP_ERRBASE				ERRBASE_SET(1300)		//46FocusVMCCTP
#define VMCCTPNET_ERRBASE			ERRBASE_SET(1500)		//46FocusVMCCTP
#define MSTPNET_ERRBASE				ERRBASE_SET(1400)		//36FocusMSTP

#define VMCS_ERRBASE				ERRBASE_SET(2000)		//33FocusVMCS
#define MSDEV_ERRBASE				ERRBASE_SET(2100)		//37FocusMSDEV
#define VMCC_ERRBASE				ERRBASE_SET(2200)		//45FocusVMCC
#define LMTP_ERRBASE				ERRBASE_SET(2300)		//44FocusLMTTP
#define LMTPNET_ERRBASE				ERRBASE_SET(2400)		//44FocusLMTTP
#define AAATP_ERRBASE				ERRBASE_SET(2500)		//47FocusAAATP

#define TVWALL_ERRBASE				ERRBASE_SET(2600)		//43FocusTVWALL
#define TVWALLTEST_ERRBASE			ERRBASE_SET(2700)		//
#define TVWALLNETTEST_ERRBASE		ERRBASE_SET(2800)		//

#define RK_ERRBASE					ERRBASE_SET(5000)		//CBBW0RunKeeper	

#define MGuipTP_ERRBASE				ERRBASE_SET(6000)		//CBBA2MGuipTP
#define MGuipNTTP_ERRBASE			ERRBASE_SET(6100)		//CBBA2MGuipNTTP

#define SMARTSTUB_ERRBASE			ERRBASE_SET(6200)		//CBBX10SMARTSTUB


#define IPVU_MSLTBL_ERRBASE		    ERRBASE_SET(7002)		//CBBZ0IPVUDBA
#define IPVU_GLBPARATBL_ERRBASE	    ERRBASE_SET(7003)		//CBBZ0IPVUDBA
#define IPVU_EVTLOGTBL_ERRBASE	    ERRBASE_SET(7005)		//CBBZ0IPVUDBA
#define IPVU_CLTTBL_ERRBASE         ERRBASE_SET(7006)		//CBBZ0IPVUDBA
#define IPVU_ENCCFGTBL_ERRBASE	    ERRBASE_SET(7007)       //CBBZ0IPVUDBA
#define IPVU_CFGTBL_ERRBASE	        ERRBASE_SET(7008)       //CBBZ0IPVUDBA
#define IPVU_NMTBL_ERRBASE	        ERRBASE_SET(7009)       //CBBZ0IPVUDBA
#define IPVU_USERTBL_ERRBASE        ERRBASE_SET(7010)       //CBBZ0IPVUDBA
#define IPVU_RSRVSNDTBL_ERRBASE     ERRBASE_SET(7011)    //CBBZ0IPVUDBA
#define IPVU_RPLTBL_ERRBASE         ERRBASE_SET(7012)       //CBBZ0IPVUDBA
#define IPVU_DECTBL_ERRBASE         ERRBASE_SET(7013)       //CBBZ0IPVUDBA

#define HOME_SVRTBL_ERRBASE	        ERRBASE_SET(7100)		//CBBR2HSDBA
#define PCIMEDENV_ERRBASE           ERRBASE_SET(8000)

#define HTTPCLT_ERRBASE             ERRBASE_SET(8100)

/*=================================================================
函 数 名: ErrInfoGet
功    能: 得到错误码的解释
输入参数: dwErrno -- 错误码
		  pbyBuf -- 输入缓冲，带回描述信息
		  dwInLen -- 输入缓冲长度
返回值:	  返回  pbyBuf	

说明:     建议实现时用 strncpy(pbyBuf, strErrInfo, dwInLen); 
					   pbyBuf[dwInLen - 1] = '\0'; 	
=================================================================*/
typedef s8* (ErrInfoGet)(IN u32 dwErrno, IN OUT s8 *pbyBuf, IN u32 dwInLen);


/*================================= 错误码解释接口 ================================*/
ErrInfoGet EXBspErrInfoGet;			//CBBG00EXBsp

ErrInfoGet E6101EncErrInfoGet;		//CBBE06101ENC
ErrInfoGet E6201DecErrInfoGet;		//CBBF06201DEC
ErrInfoGet E6101OsdErrInfoGet;		//CBBE56101OSD
ErrInfoGet HisiAEncErrInfoGet;		//CBBF6HisiAEnc
ErrInfoGet HisiADecErrInfoGet;		//CBBF8HisiADec
ErrInfoGet HisiCodecErrInfoGet;		//CBBE80Hi3511Codec
ErrInfoGet Hi3511PlayErrInfoGet;	//CBBF82Hi3511Play


ErrInfoGet SpiEncErrInfoGet;		//CBBE7SpiEnc

ErrInfoGet RPDBErrInfoGet;			//CBBJ0RPDB
ErrInfoGet FSDBErrInfoGet;			//CBBJ2FSDB
ErrInfoGet AAADbaErrInfoGet;		//CBB90AAADBA
ErrInfoGet CltDbaErrInfoGet;		//CBBP0CLTDBA	
ErrInfoGet DevDbaErrInfoGet;		//CBBQ0DEVDBA
ErrInfoGet SvrDbaErrInfoGet;		//CBBR0SVRDBA	
ErrInfoGet NMDbaErrInfoGet;			//CBBS0NMDBA
ErrInfoGet LogDbaErrInfoGet;		//CBBT0LOGDBA
ErrInfoGet TransDbErrInfoGet;		//CBBJ5TRANSDB
ErrInfoGet TransActionErrInfoGet;	//CBBJ50TRANSACTION
ErrInfoGet RPFineApiErrInfoGet;		//CBBJ6RPFineAPI
ErrInfoGet AsfFileErrInfoGet;       //CBBL2ASFFILE

ErrInfoGet OalErrInfoGet;			//CBBL0OAL
ErrInfoGet OtlErrInfoGet;			//CBBM0OTL
ErrInfoGet AtpErrInfoGet;			//CBBM5ATP
ErrInfoGet IpvuAtpErrInfoGet;		//CBBM6IPVUATP

ErrInfoGet ABSVEncErrInfoGet;		//CBBM32ABSVENC
ErrInfoGet ABSVDecErrInfoGet;		//CBBM33ABSVDEC
ErrInfoGet ABSAEncErrInfoGet;		//CBBM30ABSAENC
ErrInfoGet ABSADecErrInfoGet;		//CBBM31ABSADEC


ErrInfoGet WirelessErrInfoGet;		//CBBM8WIRELESS

ErrInfoGet FsmpErrInfoGet;			//10FocusFSMP
ErrInfoGet AVNetErrInfoGet;			//CBB20AVNet
ErrInfoGet VODNetErrInfoGet;		//CBB22VODNet
ErrInfoGet SigNetErrInfoGet;		//CBB25SIGNet
ErrInfoGet TcpNetErrInfoGet;		//CBB26TcpNet
ErrInfoGet IMErrInfoGet;			//CBB10Ipmatrix
ErrInfoGet MPErrInfoGet;			//CBB11MemPort
ErrInfoGet DIMErrInfoGet;			//CBB80DIpMatrix
ErrInfoGet RPFSErrInfoGet;			//CBBI0RPFS
ErrInfoGet EXmlErrInfoGet;			//CBBV5EXML
ErrInfoGet BPTreeErrInfoGet;		//CBBV61BPTREE
ErrInfoGet TupleFileErrInfoGet;		//CBBV3TupleFile
ErrInfoGet GroupDBErrInfoGet;		//CBBV4GroupDB
ErrInfoGet DistDBErrInfoGet;		//CBBV43DistDB

ErrInfoGet WinH264DecErrInfoGet;	//50Winh264Dec
ErrInfoGet WebServerErrInfoGet;		//CBBV8WebServer

ErrInfoGet FastFileErrInfoGet;		//CBBV7FastFile
ErrInfoGet DiskFileErrInfoGet;		//CBBV10DiskFile


ErrInfoGet CommIscErrInfoGet;		//CBBV2ISC
ErrInfoGet ISC6101sErrInfoGet;		//CBBV2ISC

ErrInfoGet SEncWin32ErrInfoGet;		//CBBB0SmartEncWin32
ErrInfoGet SEncHisiErrInfoGet;		//CBBB5SmartEncHisi
ErrInfoGet SEncSpiErrInfoGet;		//CBBB7SmartEncSpi
ErrInfoGet SDecWin32ErrInfoGet;		//CBBC0SmartDecWin32
ErrInfoGet SDecHisiErrInfoGet;		//CBBC5SmartDecHisi
ErrInfoGet SEventErrInfoGet;		//CBBC8SmartEvent
ErrInfoGet MDPUErrInfoGet;			//CBBC30MDPU


ErrInfoGet SRPErrInfoGet;			//CBBH0SmartRP
ErrInfoGet MRPDErrInfoGet;			//CBBH1MRPD	
ErrInfoGet DNSRegCErrInfoGet;		//CBBH6DNSRegM
ErrInfoGet SIOErrInfoGet;			//CBBU0SmartIO
ErrInfoGet SPTZErrInfoGet;			//CBBU5SmartPTZ
ErrInfoGet SKeyBoardErrInfoGet;		//CBBU6SmartKeyBoard
ErrInfoGet SUPNPErrInfoGet;			//CBBU7SmartUPnP
ErrInfoGet NatBusErrInfoGet;		//CBBU8NatBus
ErrInfoGet SEnc6104HisiErrInfoGet;	//CBBB7SMARTENC6104HISI
ErrInfoGet SAudEncHisiErrInfoGet;	//CBBB4SmartAudioEncHisi
ErrInfoGet SAudDecHisiErrInfoGet;	//CBBC4SmartAudioDecHisi

ErrInfoGet IpvuLogicErrInfoGet;		//CBBD0IPVULOGIC	
ErrInfoGet RpLogicErrInfoGet;		//CBBD8RPLogic		
ErrInfoGet E6101IpvuLogicErrInfoGet; //CBBD56101IPVULogic
ErrInfoGet VmsbFApiErrInfoGet;		//CBBX1VMSBFINEAPI
ErrInfoGet VmsbSApiErrInfoGet;		//CBBX5VMSBSIMPLEAPI
ErrInfoGet VmspFineApiErrInfoGet;	//CBBX8FineAPI
ErrInfoGet IpvuSecurityErrInfoGet;	//CBBD66101Security
ErrInfoGet RKDOGErrInfoGet;			//CBBW5RKDog
ErrInfoGet HVRLogicErrInfoGet;		//CBBD6HVRLOGIC
ErrInfoGet IpvuHubErrInfoGet;		//IPVUHUB
ErrInfoGet FlashMemShadowErrInfoGet;	//CBBD12FlashMemShadow


ErrInfoGet GuiTPErrInfoGet;			//CBBA0GuiTP
ErrInfoGet VMSPErrInfoGet;			//32FocusVMSP
ErrInfoGet MSTPErrInfoGet;			//36FocusMSTP
ErrInfoGet MSTPNetErrInfoGet;		//36FocusMSTP
ErrInfoGet WinGuiPErrInfoGet;		//40WinGuiP
ErrInfoGet VMCCTPErrInfoGet;		//46FocusVMCCTP
ErrInfoGet VMCCTPNetErrInfoGet;		//46FocusVMCCTP

ErrInfoGet VMCSErrInfoGet;			//33FocusVMCS
ErrInfoGet MSDevErrInfoGet;			//37FocusMSDEV
ErrInfoGet VMCCErrInfoGet;			//45FocusVMCC
ErrInfoGet LMTPErrInfoGet;			//44FocusLMTTP
ErrInfoGet LMTPNetErrInfoGet;			//44FocusLMTTP

ErrInfoGet AAATPErrInfoGet;			//47FocusAAATP
ErrInfoGet AAATPNetErrInfoGet;		//47FocusAAATP

ErrInfoGet TVWALLErrInfoGet;			//
ErrInfoGet TVWALLTESTErrInfoGet;		//
ErrInfoGet TVWALLNETTESTErrInfoGet;		//


ErrInfoGet RKErrInfoGet;			//CBBW0RunKeeper

ErrInfoGet MGuipTPErrInfoGet;		//CBBA2MGuipTP
ErrInfoGet MGuipNTTPErrInfoGet;		//CBBA2MGuipNTTP

ErrInfoGet SmartStubErrInfoGet;		//CBBX10SMARTSTUB

ErrInfoGet IpvuDBErrInfoGet;		//CBBZ0IPVUDBA

ErrInfoGet HmSvrDBErrInfoGet;		//CBBR2HSDBA

ErrInfoGet DimDbErrInfoGet;

ErrInfoGet HxSErrInfoGet;	//CBBK2HXSTACK


#ifdef __cplusplus
}
#endif  // __cplusplus


#endif // _uverr_H



