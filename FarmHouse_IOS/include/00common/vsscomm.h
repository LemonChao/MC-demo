#ifndef _H_VSS_COMM_
#define _H_VSS_COMM_

//////////////////////////////////////////////////////////////////////////
//消息ID定义
#define VSS_MSG_BASE                   3000    //起始消息号
//DirSvc 目录服务起始消息，----保留
#define VSS_DIR_SVC_MSG_BASE				(VSS_MSG_BASE+1000)
//CuAcessSvc 客户端单元接入服务起始消息
#define VSS_CUACCESS_SVC_MSG_BASE           (VSS_MSG_BASE+2000)
//CmuAcessSvc 中心管理单元接入服务起始消息
#define VSS_CMUACCESS_SVC_MSG_BASE          (VSS_MSG_BASE+3000)
//PuAcessSvc 前端单元接入服务起始消息
#define VSS_PUACCESS_SVC_MSG_BASE           (VSS_MSG_BASE+4000)
//MediaDispSvc 媒体转分发服务起始消息
#define VSS_MEDIADISP_SVC_MSG_BASE			(VSS_MSG_BASE+5000)
//RecSvc 录像服务起始消息
#define VSS_REC_SVC_MSG_BASE				(VSS_MSG_BASE+6000)
//RecPlaySvc 放像服务起始消息
#define VSS_RECPLAY_SVC_MSG_BASE			(VSS_MSG_BASE+6500)
//LogSvc 日志服务起始消息
#define VSS_LOG_SVC_MSG_BASE				(VSS_MSG_BASE+7000)
//AlarmSvc 告警服务起始消息
#define VSS_ALARM_SVC_MSG_BASE				(VSS_MSG_BASE+8000)
//TVWallSvc 电视墙服务起始消息
#define VSS_TVWALL_SVC_MSG_BASE				(VSS_MSG_BASE+9000)
//NMSvc 网络管理服务起始消息
#define VSS_NM_SVC_MSG_BASE					(VSS_MSG_BASE+10000)
//UISvc 界面应用服务起始消息
#define VSS_UI_SVC_MSG_BASE					(VSS_MSG_BASE+15000)

////////// 以下行业相关服务消息ID定义
//保险行业起始消息号
#define VSS_INSURE_MSG_BASE           20000
//AgentSvc起始消息，坐席（客服）调度服务
#define VSS_AGENT_SVC_MSG_BASE         (VSS_INSURE_MSG_BASE+1000)

//Svc模块内部消息分段
#define VSS_INNERMSG_BASE                   100000    //起始内部消息号
//DirSvc 起始内部消息
#define VSS_DIR_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+1000)
//CuAcessSvc 起始内部消息
#define VSS_CUACCESS_SVC_INNERMSG_BASE          (VSS_INNERMSG_BASE+2000)
//CmuAcessSvc 起始内部消息
#define VSS_CMUACCESS_SVC_INNERMSG_BASE         (VSS_INNERMSG_BASE+3000)
//PuAcessSvc 起始内部消息
#define VSS_PUACCESS_SVC_INNERMSG_BASE          (VSS_INNERMSG_BASE+4000)
//MediaDispSvc 起始内部消息
#define VSS_MEDIADISP_SVC_INNERMSG_BASE			(VSS_INNERMSG_BASE+5000)
//RecSvc 起始内部消息
#define VSS_REC_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+6000)
//RecPlaySvc 起始内部消息
#define VSS_RECPLAY_SVC_INNERMSG_BASE			(VSS_INNERMSG_BASE+6500)
//LogSvc 起始内部消息
#define VSS_LOG_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+7000)
//AlarmSvc 起始内部消息
#define VSS_ALARM_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+8000)
//TVWallSvc 起始内部消息
#define VSS_TVWALL_SVC_INNERMSG_BASE			(VSS_INNERMSG_BASE+9000)
//NMSvc 起始内部消息
#define VSS_NM_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+10000)
//UISvc 起始内部消息
#define VSS_UI_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+15000)

//AgentSvc 起始内部消息
#define VSS_AGENT_SVC_INNERMSG_BASE					(VSS_INNERMSG_BASE+21000)

//定义码流通道类型
// #define VSS_CHNTYPE_VIDEOENC          1       //视频编码
// #define VSS_CHNTYPE_VIDEODEC          2       //视频解码
// #define VSS_CHNTYPE_AUDIOENC          3       //音频编码
// #define VSS_CHNTYPE_AUDIODEC          4       //音频解码


#define VSS_TRANSDATA_MAXLEN     512
//PDU最大长度
#define VSS_PDU_MAXLEN                (32<<10)

#define VSS_NAME_MAXLEN        32
#define VSS_PSW_MAXLEN         32
#define VSS_TEL_MAXLEN         16
#define VSS_LIST_MAXNUM        64
#define VSS_URL_MAXLEN         128
#define VSS_FILENAME_MAXLEN    256  
#define LOGMETADATA_USERDATA_MAXLEN    256
#define VSS_SERIAL_MAXLEN              32

#define VSS_REPORTNO_LEN 			32	// 报案号长度
#define VSS_PLATENO_LEN 			16	// 车牌号长度

// #define VSS_GBEID_MAXLEN       128

#define VSS_EVIDENCE_MAXLEN    512    // 证据最大长度(汉字256个，英文512)
#define VSS_3G_MSG_MAXLEN      512
#define VSS_VERSTR_MAXLEN             256  //版本信息最大长度
#define VSS_ETHIP_MAXNUM              16   //网口最大IP地址个数

#define VSS_ROLE_OF_DOMAIN_MAXNUM  64   //每个Domain拥有的最大角色个数
#define VSS_DEVTREE_HEIGHT_MAXNUM  64    //顶级CMS到最后一级dev的级数(设备树高度)
#define VSS_USRTREE_HEIGHT_MAXNUM  32    //顶级Domain到最后一级user的级数(用户树高度)
#define VSS_EVENT_INDEX_MAXNUM        16  //事件索引最大个数，索引即事件查询条件

// #define  VSS_DATAEXPLSVC_RSPBUF_MAXLEN  256*32

#define VSS_BLOCK_DATA_SIZE  (1024*1024)      // 单一Block所占字节数
#define VSS_UNIT_DATA_SIZE   (1024*1024*128)  // 单一Unit所占字节数
#define VSS_BLOCK_INFO_SIZE (1024*4)        // 每个Unit存放Block信息的大小
#define VSS_UNIT_INFO_SIZE  (1024*4)        // 每个Unit存放Unit信息的大小

//网管ObjInfo长度
//#define VSS_OBJINFO_BUF_MAXLEN    (1024*4)

//data logic模块名称定义
// #define VSS_MODULE_NAME_DIRDL    "DirDataLogicModule"
// #define VSS_MODULE_NAME_NMCDL    "NMCDataLogicModule"
// #define VSS_MODULE_NAME_EVTDL    "EvtDataLogicModule"
// #define VSS_MODULE_NAME_MEDIADL  "MediaDataLogicModule"
// #define VSS_MODULE_NAME_RECDL    "RecDataLogicModule"
// #define VSS_MODULE_NAME_STATUSDL "StatusDataLogicModule"
// #define VSS_MODULE_NAME_SSNDL    "SsnDataLogicModule"

//定义设备厂商字串
#define PU_MANUF_SIMPU		"simpu"
#define PU_MANUF_JL			"JL"
#define PU_MANUF_HAIKANG	"HaiKang"
#define PU_MANUF_DAHUA		"DaHua"

//客户端端口定义 
#define  SIGPORT_CU             6000		//监控客户端
#define  SIGPORT_CHARGE_CU      6010		//定损客户端
//客户端媒体端口
//#define  MEDIAPORT_CMC          6500

//服务器信令端口
//RK搜索的服务端口
#define  RK_DISCOVERYPORT      9999
#define  SIGPORT_RK            10000
#define  SIGPORT_SIMPU         5500		//模拟前端
#define  SIGPORT_JLNETSDK        5600		//设备接入SDK
#define  SIGPORT_CMS           9000		//中心管理服务器
#define  SIGPORT_MDS	       9010		//媒体转分发服务器
#define  SIGPORT_RECS	       9020		//录像服务器
#define  SIGPORT_TVWS	       9030		//电视墙服务器
#define  SIGPORT_DIRS          9100		//目录服务器，----预留
 
//客户端媒体端口
//CU媒体端口
#define MEDIAPORTBASE_CU        12000
//MDS媒体端口
#define MEDIAPORTBASE_MDS         16000
//录像机媒体端口
#define MEDIAPORTBASE_RECS        20000
//电视墙媒体端口
#define MEDIAPORTBASE_TVWS        24000
//NetSdk媒体端口
#define MEDIAPORTBASE_NETSDK	  28000
//Pu(SimPu)媒体端口
#define MEDIAPORTBASE_PU         32000


//Telnet端口定义
#define TELPORT_RK     3500
#define TELPORT_CMS    3600
#define TELPORT_MDS    3610
#define TELPORT_RECS   3620
#define TELPORT_TVWS   3630
#define TELPORT_SIMPU  3700
#define TELPORT_DIRS   3800		//目录服务器，----预留
#define TELPORT_CU     3900
#define TELPORT_CHARGE_CU  3910

#define TELPORT_JLNETSDK	3450
#define TELPORT_JLPLAY		3451
#define TELPORT_CHARGE_CLTSDK	3456

//内存端口定义
//视频源端口
#define VSRCMEMPORT_START     1000
//音频源端口
#define ASRCMEMPORT_START     1100
//视频目的端口
#define VDSTMEMPORT_START     1200
//音频目的端口
#define ADSTMEMPORT_START     1300

#define RK_MULTICASTIP    "234.32.0.1"

//电视墙信息变更类型
#define TVW_CHANGETYPE_BASEINFO       1
#define TVW_CHANGETYPE_EXPCFG         2
#define TVW_CHANGETYPE_POLLITEM       4

#define VSS_GPSINFO_MAXLEN 256
#define VSS_ACTION_EXTRA_LEN 256
//错误码
typedef enum EVssErrCode
{
	VSS_OK = 0,                          //操作成功
	VSS_System,                          //系统错误
	VSS_InstLimit,                       //无可用实例
	VSS_InstInvalid,                     //无效实例
	VSS_InvalidConn,                     //无效连接
	VSS_PDUParseErr,                     //PDU解析错误
	VSS_NotInit,                         //未初始化
	VSS_AlreadyInit,                     //已经初始化
	VSS_ParamErr,                        //参数错误
	VSS_MsgErr,                          //消息错误
	VSS_SsnErr,                          //错误Ssn
	VSS_AlreadyLogin,                    //用户已经登陆
	VSS_UserNotExist,                    //用户不存在
	VSS_PswErr,                          //密码错误
	VSS_PriLimit,                        //无权限操作
	VSS_ObjNotExist,                     //操作对象不存在
	VSS_ChnErr,                          //错误的通道号
	VSS_VODUsed,                         //VOD通道已经占用
	VSS_CltBandWidthLimit,               //客户端带宽限制
	VSS_DevBandWidthLimit,               //设备带宽限制
	VSS_SrvBandWidthLimit,               //服务器带宽限制
// 	VSS_IPVUOFFLINE,                     //IPVU不在线
// 	VSS_IPVULOGINING,                    //IPVU正在登录
	VSS_PUOFFLINE,                     //IPVU不在线
	VSS_PULOGINING,                    //IPVU正在登录
	VSS_DBOPTERR,                        //数据库操作错误
	VSS_IPVUNOTRESPONSE,                 //事务超时，IPVU没有响应
	VSS_TRANSSVRERR,                     //事务服务内部错误
	VSS_ADecUsed,                        //呼叫通道已占用
	VSS_SvrLimit,                        //服务器资源不足
	VSS_Timeout,                         //超时
	VSS_LoginRedirect,                   // 登录重定向
	VSS_ISEXIST,                          // 已存在
	VSS_SvcLimit,                       //超出服务能力
	VSS_ClientMediaSwitch_Failed,       //客户端媒体建立媒体交换失败
	VSS_MdsMediaSwitch_Failed,			//媒体服务器建立媒体交换失败
	VSS_ClientFileTransChn_Failed,       //客户端媒体建立文件传输通道失败
	VSS_MdsFileTransChn_Failed,			 //媒体服务器建立文件传输通道失败

	VSS_VersionErr = 101, //版本匹配错误
	VSS_PuNoExist, //设备不存在（未入网）
}EVssErrCode;

//统一对象类型定义
typedef enum EVssUOType
{
	VSS_UOTYPE_DOMAIN = 1,      //域
	VSS_UOTYPE_SYSADMIN,        //系统管理员
	VSS_UOTYPE_NMADMIN,         //网络管理员
	VSS_UOTYPE_ROLE,            //角色
	VSS_UOTYPE_USER,            //用户
	VSS_UOTYPE_USRGRP,          //用户组
	VSS_UOTYPE_DIR,             //认证鉴权服务器
	VSS_UOTYPE_DIRC,            // 配置客户端
	VSS_UOTYPE_CMS,             //中心管理服务器
	VSS_UOTYPE_CU,             // 监控客户端, 定损客户端
	VSS_UOTYPE_NMS,             //网管服务器
	VSS_UOTYPE_NMC,             // 网管客户端
	VSS_UOTYPE_DATAEXPL,               // dataExplore客户端
	VSS_UOTYPE_DEVGRP,          //设备组
	VSS_UOTYPE_PU,              //前端
	VSS_UOTYPE_PUCHILD,     // PU孩子，是VENC，VDEC，AENC，ADEC等多种类型的集合
	VSS_UOTYPE_IOINPUT,         //开关量输入口
	VSS_UOTYPE_IOOUTPUT,        //开关量输出口
	VSS_UOTYPE_VENCCHN,              //视频编码通道
	VSS_UOTYPE_AENCCHN,              //音频编码通道
	VSS_UOTYPE_ENCCHN,               //编码通道  // add by dongxia
	VSS_UOTYPE_VINPUT,               //视频输入口
	VSS_UOTYPE_AINPUT,               //音频输入口
	VSS_UOTYPE_VDECCHN,              //视频解码通道
	VSS_UOTYPE_ADECCHN,              //音频解码通道
	VSS_UOTYPE_DECCHN,               //解码通道 // add by dongxia
	VSS_UOTYPE_RECCHN,               //录像通道
	VSS_UOTYPE_RECPLYSRC,            //放像源

	VSS_UOTYPE_MDS,    //媒体转分发服务器
	VSS_UOTYPE_SWITCHID,              //交换ID
	VSS_UOTYPE_VTRANSCHN,              //视频传输通道
	VSS_UOTYPE_ATRANSCHN,              //音频传输通道	

	VSS_UOTYPE_RECS,    //录像服务器
	VSS_UOTYPE_WSBLOCK,           //写存储块
	VSS_UOTYPE_RSBLOCK,           //读存储块
	VSS_UOTYPE_RECT,                //录像计划模板

	VSS_UOTYPE_WNDHDL,               //窗口句柄


// 	VSS_UOTYPE_POLLPRJ,             //轮巡方案
//  VSS_UOTYPE_EXPSCHEMA,           //浏览预案	

// 	//电子地图
// 	VSS_UOTYPE_EMAP,
// 	//电子地图组
// 	VSS_UOTYPE_EMAPGRP,

// 	VSS_UOTYPE_TVWS,    //电视墙服务器
// 	//电视墙组
// 	VSS_UOTYPE_TVWALLGRP,
// 	//电视墙
// 	VSS_UOTYPE_TVWALL,
// 	//电视墙Grid
// 	VSS_UOTYPE_TVWALL_GRID, //mdf by chenhb 代替 VSS_UOTYPE_SCREEN,

// 	VSS_UOTYPE_NVRS,    //NVRS
// 	VSS_UOTYPE_BKUPS,              //备份服务器

// 	//GUI窗口对象
// 	VSS_UOTYPE_REALWNDIDX,        //实时浏览窗口索引
// 	VSS_UOTYPE_GUIWND_REC,        //CMC内部DecChn给录制窗口
// 	VSS_UOTYPE_GUIWND_PLAYBACK,   //放像窗口
//  VSS_UOTYPE_STREAMHDL,            //媒体流句柄

// 	VSS_UOTYPE_3GGW,    //3G网关
// 	VSS_UOTYPE_E1,      //E1类型
// 
// 	VSS_UOTYPE_SVCMDLTEST,           //Svc层模块测试
// 
// 	VSS_UOTYPE_MCCSDKSVR,             //媒体接入服务端
// 	VSS_UOTYPE_MCCSDKCLT,             //媒体接入客户端
//
// 	VSS_UOTYPE_MEGAEPLATFORM,       //全球眼平台
// 
// 	
// 	VSS_UOTYPE_MEDIASSN,              //媒体会话
// 
// 	VSS_UOTYPE_AOUTPORT,              //音频输出口
// 	
// 	VSS_UOTYPE_PLYCHNID,           //播放器类型
// 
// 
// 	VSS_UOTYPE_ASFFILE,            //Asf文件

// 	VSS_UOTYPE_TS,                 //时隙
// 	VSS_UOTYPE_MPARTY,              //媒体组
// 
// 	VSS_UOTYPE_ISUPCHN,              //ISUP通道
// 	VSS_UOTYPE_SIPCHN,               //SIP通道
// 	VSS_UOTYPE_3SDKADA_DEVMP,        //3SdkAda使用设备媒体点
// 	VSS_UOTYPE_3SDKADA_CHNMP,        //3SdkAda使用通道媒体点
// 	VSS_UOTYPE_3SDKADA_HDLMP,        //3SdkAda使用句柄媒体点

}EVssUOType;


//对象配置变化类型
typedef enum EVSSObjChange
{
	//前部分是配置变化类型
	E_OBJCFG_CHANGE_START,
	E_OBJCHANGE_ADD,    //TVSSObjBasic
	E_OBJCHANGE_DEL,    //TVSSObjBasic
	E_OBJCHANGE_UPDATE_BASICINFO,       //TVSSObjBasic
	E_OBJCHANGE_UPDATE_LOGININFO,       //TVSSDevLoginInfo
	E_OBJCHANGE_UPDATE_CHNINFO,         //TVSSChnInfo
	E_OBJCHANGE_UPDATE_DEVPOS,          //TVSSDevPos
	E_OBJCHANGE_UPDATE_DEVEXTINFO,          //TVSSDevExtInfo
	E_OBJCHANGE_GRIDEXPCFG,         //TVSSGridExpInfo
	E_OBJCHANGE_RECSCHELISTCFG,     //TRecTemplScheListRpt
	E_OBJCHANGE_DOMAINEXTINFOCFG,   //TVSSUserExtInfo，只在增加组织机构时服务端内部增加数据报回客户端时用到

	E_OBJCFG_CHANGE_END,

	//后部分是状态变化类型
	E_OBJSTATUS_CHANGE_START = E_OBJCFG_CHANGE_START+1000,    
	E_OBJCHANGE_COMMSTATUS,           //TVSSObjStatus
	E_OBJCHANGE_DEVCAP,               //TVSSDevCap

// 	// 网管对象信息
// 	E_NMOBJINFO_DEVSYSINFO,              //TDevSysInfo
// 	E_NMOBJINFO_ETHNETADDR,             //TVSSEthNetAddr
// 	E_NMOBJINFO_CPUUSG,                 //TVSSCpuUsg
// 	E_NMOBJINFO_MEMUSG,                 //TVSSMemUsg
// 	E_NMOBJINFO_DEVTIMEINFO,            //TDevTimeInfo
// 	E_NMOBJINFO_RECPARAINFO,           //TRecParaInfo
// 	E_NMOBJINFO_DISKINFO,              //TDEVDISKINFO
// 	E_NMOBJINFO_CHNSTATUSINFO,         //ChnStatusInfo
// 
// 	E_NMOBJINFO_RSP,                    //TVSSObjNMInfoGetRsp
// 
// 	//网管对象信息
// 
// 	E_OBJSTATUS_CHANGE_END,
}EVSSObjChange;

//日志级别定义
typedef enum EVssLogLevel
{
	E_LOG_DEBUG,	//内部调试
	E_LOG_SYSERR,   //系统错误
	E_LOG_SYSWARN,  //系统告警
	E_LOG_SYSMSG_RUN,   //系统运行消息
	E_LOG_SYSMSG_SSN,   //系统会话消息
	E_LOG_SYSMSG_COMM,  //系统通用消息(主要是用户操作类）
	E_LOG_OTHERS,	//其他消息
}EVssLogLevel;

//日志记录的事件类型定义
typedef enum EVssEvtType
{
	//内部调试事件( ID : 1 -- 10000 )
	E_EVT_DEBUG_BEGIN = 1, 
	E_EVT_HEALTHCHECK_FAILED,           //系统HealthCheck失败

	//////////////////////////////////////////////////////////////////////////
	// 系统错误( ID : 10001 -- 11000 )
	E_EVT_SYSERR_BEGIN = 10001,
	E_EVT_SYSERR_INIT,  //启动失败
	E_EVT_SYSERR_SVC,   //服务异常
	E_EVT_SYSERR_MEDIAR,//媒体处理异常
	E_EVT_SYSERR_DB,    //数据库异常
	E_EVT_SYSERR_NET,   //网络异常

	//////////////////////////////////////////////////////////////////////////
	// 系统告警
	//系统网管告警( ID : 11001 -- 12000 )
	E_EVT_SYSWARN_BEGIN =11001,
	E_EVT_SYSWARN_CPU,	     //Cpu使用率过高告警
	E_EVT_SYSWARN_MEMORY,	 //内存使用率过高告警
	E_EVT_SYSWARN_DISK,	     //磁盘异常告警
	E_EVT_SYSWARN_NET_FULL,	 //网络带宽负荷满告警
	E_EVT_SYSWARN_HARDWARE_ADD,      //硬件接入告警
	E_EVT_SYSWARN_HARDWARE_DEL,      //硬件拔出告警
	E_EVT_SYSWARN_VIDEO_LOST,        //视频源丢失告警    //跟编码通道相关
	E_EVT_SYSWARN_RECSPACE_FULL,     //录像空间满告警
	E_EVT_SYSWARN_DEVSSN,    //设备会话告警

	//////////////////////////////////////////////////////////////////////////
	// 系统消息
	//系统运行事件( ID : 12001 -- 13000 )
	E_EVT_SYSMSG_BEGIN=12001,
	E_EVT_SYSMSG_INIT,                   //系统初始化
	E_EVT_SYSMSG_EXIT,                   //系统退出
	E_EVT_SYSMSG_REBOOT,                     //系统重启

	//系统会话事件( ID : 12101 -- 12200 )
	E_EVT_SYSMSG_USER_LOGIN=12101,          //用户登录
	E_EVT_SYSMSG_USER_LOGOUT,         //用户注销
	E_EVT_SYSMSG_USER_DISCON,         //用户异常断开连接

	E_EVT_SYSMSG_PU_ONLINE,           //PU上线
	E_EVT_SYSMSG_PU_OFFLINE,          //PU下线
	E_EVT_SYSMSG_PU_CONNERR,          //PU连接失败

	E_EVT_SYSMSG_CMU_LOGIN,          //用户登录
	E_EVT_SYSMSG_CMU_LOGOUT,         //用户注销
	E_EVT_SYSMSG_CMU_DISCON,         //用户异常断开连接


	//系统操作事件( ID : 12201 -- 12300 )
	E_EVT_SYSMSG_MEDIASWITCH= 12201,
	E_EVT_SYSMSG_MEDIASWITCH_STOP,

	//录像事件( ID : 12301 -- 12400 )
	E_EVT_SYSMSG_REC_BEGIN= 12301,
	E_EVT_SYSMSG_REC_STOP,
	
}EVssEvtType;

//Log元数据
typedef struct TLogMetaData
{
	//u64 m_qwLogSqeID;   //日志流水号
	u32 m_dwLogTime;      //日志时间
	u32 m_dwLogLevel;	  //日志等级 见EVssLogLevel
	u32 m_dwEvtType;      //具体的日志记录的事件类型 如设备运行，用户登陆，设备接入等，见
	u32 m_dwHostObjType;		//事件主格对象对象类型
	u64 m_qwHostObjID;			//事件主格对象对象ID;
	u32 m_dwAccusatObjType;		//事件宾格对象对象类型
	u64 m_qwAccusatObjID;		//事件宾格对象对象ID;
	u32 m_deLogDescLen; //日志描述长度
	char m_szLogDesc[LOGMETADATA_USERDATA_MAXLEN+1]; //日志描述
}TLogMetaData;

// 
// //事件类别定义
// typedef enum EEvtClassify
// {
// 	//所有事件
// 	E_EVT_CLASSIFY_ALL = 1,  //因此类别在数据库可能会作为所以，建议不用 0 
// 
// 	//调试事件
// 	E_EVT_CLASSIFY_DEBUG, 
// 
// 	//当前告警
// 	E_EVT_CLASSIFY_CURRENTALARM,
// 
// 	//历史告警
// 	E_EVT_CLASSIFY_HISTORYALARM,
// 
// 	//日志型事件开始
// 	E_EVT_CLASSIFY_LOGBEGIN = 10000,
// 
// 	//网管告警事件
// 	E_EVT_CLASSIFY_NMWARNING,
// 
// 	//业务告警事件
// 	E_EVT_CLASSIFY_APPALARM,
// 
// 	//系统事件
// 	E_EVT_CLASSIFY_SYSTEM,
// 
// 	//会话事件
// 	E_EVT_CLASSIFY_SSN,
// 
// 	//目录操作事件
// 	E_EVT_CLASSIFY_DIROP,
// 
// 	//实时流事件
// 	E_EVT_CLASSIFY_REALMEDIA,
// 
// 	//录像事件
// 	E_EVT_CLASSIFY_REC,
// 
// 	//参数配置事件
// 	E_EVT_CLASSIFY_PARAMCFG,
// 
// 	//智能分析事件
// 	E_EVT_CLASSIFY_INTELLECT,
// 
// }EEvtClassify;
// 
// //事件次类型定义
// typedef enum EVssEvtType
// {
// 	//内部调试事件( ID : 1 -- 100000 )
// 	E_EVT_DEBUG_BEGIN = 1, 
// 	E_EVT_HEALTHCHECK_FAILED,           //系统HealthCheck失败
// 	E_EVT_DEBUG_END = 100000, 
// 
// 	//网管告警( ID : 100001 -- 101000 )
// 	E_EVT_NMWARNING_BEGIN,
// 	E_EVT_CPU_WARNING,	     //Cpu使用率过高告警
// 	E_EVT_MEMORY_WARNING,	 //内存使用率过高告警
// 	E_EVT_DISK_WARNING,	     //磁盘异常告警
// 	E_EVT_NET_FULL_WARNING,	 //网络带宽负荷满告警
// 	E_EVT_HARDWARE_ADD,      //硬件接入告警
// 	E_EVT_HARDWARE_DEL,      //硬件拔出告警
// 	E_EVT_VIDEO_LOST,        //视频源丢失告警    //跟编码通道相关
// 	E_EVT_RECSPACE_FULL,     //录像空间满告警
// 	E_EVT_DEVSSN_WARNING,    //设备会话告警
// 	E_EVT_NMWARNING_END = 101000,
// 
// 	//业务告警( ID : 101001 -- 102000 )
// 	E_EVT_APPALARM_BEGIN,
// 	E_EVT_IOINPUT_ALARM,        //开关量输入告警      
// 	E_EVT_IOOUTPUT_ALARM,	    //开关量输出告警
// 	E_EVT_MD_ALARM,	            //移动侦测告警             //跟编码通道相关
// 	
// 	E_EVT_MOVEING_REGION_ALARM,       // 在区域内移动
// 	E_EVT_LOITERING_REGION_ALARM,     // 在区域内徘徊告警
// 	E_EVT_CONGREGATE_REGION_ALARM,    // 在区域内聚集
// 	E_EVT_UNATTENDEDOBJ_REGION_ALARM, // 遗留物告警
// 	E_EVT_REMOVEOBJ_ALARM,            // 物体搬移告警
// 	E_EVT_REGION_ENTER_ALARM,         // 入侵告警,警戒区进入
// 	E_EVT_REGION_LEAVE_ALARM,         // 入侵告警,警戒区离开
// 	E_EVT_TRIPWIRE_ALARM,             // 穿越绊线告警
// 	E_EVT_FENCE_ALARM,                // 翻越围墙告警
// 	E_EVT_OBJECT_COUNT_ALARM,         // 物品计数
// 	E_EVT_SMOKE_ALARM,                // 烟告警
// 	E_EVT_FIRE_ALARM,                 // 火告警
// 	E_EVT_STPVEHICLE_ALARM,           // 非法停车告警
// 
// 	E_EVT_CAMMOVE_ALARM,        //摄像机移位告警
// 	E_EVT_SIGLOST_ALARM,        //信号丢失告警
// 	E_EVT_OBJTRACK_ALARM,       //对象跟踪告警
// 	E_EVT_TRACKSTART_ALARM,		//云台开始跟踪告警
// 
// 	E_EVT_OBJGPSPOS_ALARM,		//对象GPS坐标变化
// 
// 	E_EVT_APPALARM_END = 102000,
// 
// 	//系统事件( ID : 102001 -- 103000 )
// 	E_EVT_SYSTEM_BEGIN,
// 	E_EVT_SYS_INIT,                   //系统初始化
// 	E_EVT_SYS_EXIT,                   //系统退出
// 	E_EVT_REBOOT,                     //系统重启
// 	E_EVT_SYSTEM_END = 103000,
// 
// 	//会话事件( ID : 103001 -- 104000 )
// 	E_EVT_SSN_BEGIN,
// 	E_EVT_USER_LOGIN,          //用户登录
// 	E_EVT_USER_LOGOUT,         //用户注销
// 	E_EVT_USER_DISCON,         //用户断开连接
// 
// 	E_EVT_PU_ONLINE,           //PU上线
// 	E_EVT_PU_OFFLINE,          //PU下线
// 	E_EVT_PU_CONNERR,          //PU连接失败
// 	E_EVT_SSN_END = 104000,
// 
// 	//目录操作事件( ID : 104001 -- 105000 )
// 	E_EVT_DIROP_BEGIN,
// 	E_EVT_CMS_ADD,   //CMS入网
// 	E_EVT_CMS_DEL,   //CMS退网
// 	E_EVT_CMS_NAMEMDY,   //修改CMS名称
// 
// 	E_EVT_PU_ADD,          //前端设备入网
// 	E_EVT_PU_DEL,          //前端设备退网
// 	E_EVT_PU_NAMEMDY,      //修改前端设备名称
// 
// 	E_EVT_DEVGRP_ADD,       //增加设备组
// 	E_EVT_DEVGRP_DEL,       //删除设备组
// 	E_EVT_DEVGRP_NAMEMDY,       //修改设备组名称
// 
// 	E_EVT_DOMAIN_ADD,       //添加域
// 	E_EVT_DOMAIN_DEL,       //删除域
// 	E_EVT_DOMAIN_NAMEMDY,   //修改域名称
// 
// 	E_EVT_USR_ADD,          //增加用户
// 	E_EVT_USR_DEL,          //删除用户
// 	E_EVT_USR_PWD_MDY,      //修改用户密码
// 	E_EVT_USR_ROLE_SET,     //设置用户角色
// 
// 	E_EVT_USRGRP_ADD,       //增加用户组
// 	E_EVT_USRGRP_DEL,       //删除用户组
// 	E_EVT_USRGRP_NAMEMDY,       //修改用户组名称
// 	E_EVT_USRGRP_ROLE_SET,      //设置用户组角色
// 
// 	E_EVT_ROLE_ADD,         //增加角色
// 	E_EVT_ROLE_DEL,         //删除角色
// 	E_EVT_ROLE_NAMEMDY,         //修改角色名称
// 	E_EVT_ROLE_PRI_ADD,      //增加角色权限
// 	E_EVT_ROLE_PRI_DEL,      //删除角色权限
// 	E_EVT_DIROP_END = 105000,
// 
// 	//实时流事件( ID : 105001 -- 106000 )
// 	E_EVT_REALMEDIA_BEGIN,
// 	E_EVT_REALMEDIA_END = 106000,
// 
// 	//录像事件( ID : 106001 -- 107000 )
// 	E_EVT_REC_BEGIN,
// 	E_EVT_REC_END = 107000,
// 
// 	//参数配置事件( ID : 107001 -- 108000 )
// 	E_EVT_PARAMCFG_BEGIN,
// 	E_EVT_PARAMCFG_END = 108000,
// 
// }EVssEvtType;

// typedef enum EVSSEvtOriginal
// {
// 	E_EVT_ALARM_RECOVERY=0,
// 	E_EVT_ALARM_CREATE,
// 
// }EVSSEvtOriginal;
// 
// typedef enum EVSSPerfLogType
// {
// 	E_PU_PERFLOG_CPU,
// 	E_PU_PERFLOG_MEM,
// 	E_PU_PERFLOG_ETHERT,
// 	E_PU_PERFLOG_CPUNO,
// 	E_PU_PERFLOG_MEMNO,
// 	E_PU_PERFLOG_ETHERTNO,
// }EVSSPerfLogType;

// 
// typedef enum EVSSRecPlayMode
// {
// 	E_RECPLAY_ASYNC = 0 ,
// 	E_RECPLAY_SYNC  = 1,
// }EVSSRecPlayMode;
// 
// //事件查询主类型
// typedef enum EVSSEvtQryMajorType
// {
// 	E_EVTQRY_MAJORTYPE_CURAPPALARM = 0,    //当前业务告警
// 	E_EVTQRY_MAJORTYPE_HISAPPALARM,        //历史业务告警
// 	E_EVTQRY_MAJORTYPE_ALLAPPALARM,           //所有业务告警(当前+历史)
// 	E_EVTQRY_MAJORTYPE_OPELOG,             //操作日志
// 	E_EVTQRY_MAJORTYPE_CURFAULTALARM,      //当前故障告警
// 	E_EVTQRY_MAJORTYPE_HISFAULTALARM,      //历史故障告警
// 	E_EVTQRY_MAJORTYPE_ALLFAULTALARM,      //所有故障告警
// }EVSSEvtQryMajorType;
// 
// //add by yxj
// typedef enum EVSSEvtStatisType
// {
// 	E_EVT_STATISTYPE_ALLALARM = 0,         //告警总数查询
// 	E_EVT_STATISTYPE_CURRENTALARM,        //当前告警总数查询
// 	E_EVT_STATISTYPE_ALLALARMTODAY,       //本日告警总数查询
// 	E_EVT_STATISTYPE_ALLALARMTHISWEEK,     //本周告警总数查询
// }EVSSEvtStatisType;
// //add by yxj end
// 
// typedef enum EVSSRadComboBoxType
// {
// 	E_RADCOMBOBOX_FAULT_LEVEL = 0,       //故障级别控件
// 	E_RADCOMBOBOX_FAULT_CLASS,           //故障类型控件
// 	E_RADCOMBOBOX_RESOLVED_CLASS,        //解决状态控件
// 	E_RADCOMBOBOX_STAT_CLASS,            //统计类别控件
// 	E_RADCOMBOBOX_EMOTION_CLASS,         //情绪状态控件
// 	E_RADCOMBOBOX_EVIDENCE_CLASS,        //证据控件
// 	
// }EVSSRadComboBoxType;
// 
// //认证请求的客户端类型
// //注：所有的客户端的认证请求发送到Dir Server，但是DIR Server和CMS、NMS之间的登录关系是：有DirServer往CMS登录，
// //这样可以分流Dir Server的瞬间压力
// typedef enum EVSSAuthCltType
// {
// 	VSS_AUTH_CLTTYPE_CMC,   //业务客户端
// 	VSS_AUTH_CLTTYPE_NMC,   //网管客户端
// 	VSS_AUTH_CLTTYPE_DIRCLT,   //DIR 客户端
// 	VSS_AUTH_CLTTYPE_DIRSVR,   //Dir server，这个类型主要用于DIR到CMS的登录认证
// 	
// }EVSSAuthCltType;
// 
// //单个对象的在线统计类型
// typedef enum EVSSObjDataType
// {
// 	E_OBJDATA_TYPE_BEGIN,
// 
// 	E_OBJDATA_SUBCMS_STATIS,  //下级CMS
// 	E_OBJDATA_SUBCMS_TOTALCNT,  
// 	E_OBJDATA_SUBCMS_ONLINECNT,
// 	E_OBJDATA_HKDEV_STATIS,  //海康设备
// 	E_OBJDATA_HKDEV_TOTALCNT,  
// 	E_OBJDATA_HKDEV_ONLINECNT,
// 	E_OBJDATA_DHDEV_STATIS,                   //大华设备
// 	E_OBJDATA_DHDEV_TOTALCNT, 
// 	E_OBJDATA_DHDEV_ONLINECNT,
// 	E_OBJDATA_CMCCLT_STATIS,           //业务客户端
// 	E_OBJDATA_CMCCLT_TOTALCNT,  
// 	E_OBJDATA_CMCCLT_ONLINECNT,
// 
// 	E_OBJDATA_TYPE_END,
// 
// }EVSSObjDataType;
// 
// //两个对象间的会话类型统计
// typedef enum EVSSObjRelaDataType
// {
// 	E_OBJRELA_SSNID,
// 	E_OBJRELA_DATA_TYPE_BEGIN,         
// 
// 	E_OBJRELA_LOGIN_FAILURE_CNT,             //登录失败次数
// 	E_OBJRELA_LIVEVIEW_FAILURE_CNT,        //live浏览失败次数
// 	E_OBJRELA_RECVIEW_FAILURE_CNT,        //录像浏览失败次数
// 	
// 	E_OBJRELA_DATA_TYPE_END,
// 
// }EVSSObjRelaDataType;  //两个对象间的数据类型



//媒体交换模式
typedef enum EVSSMediaSwitchMode
{
	E_SWITCHMODE_NONE = 0 ,	//无交换，用于标示无须音频或视频交换
	E_SWITCHMODE_SIMPLEX_RCV = 1 ,	//单向接收，用于主叫请求被叫的码流，如视频浏览，音频监听等
	E_SWITCHMODE_SIMPLEX_SND = 2 ,	//单向发送，用于主叫推送码流给被叫，如视频广播，喊话等
	E_SWITCHMODE_DUPLEX  = 3,		//双向交换，用于语音对讲，双向视频等
}EVSSMediaSwitchMode;


// PTZ命令，对应结构 TVSSPTZCtrlReq
typedef enum EVSSPTZCMD
{
	// 方向， TVSSPTZCtrlReq的m_dwParam1为控制速度,其他参数无效
	E_PTZ_DIRECT_LEFTUP = 1, 
	E_PTZ_DIRECT_UP,
	E_PTZ_DIRECT_RIGHTUP,
	E_PTZ_DIRECT_LEFT,
	E_PTZ_DIRECT_RIGHT,
	E_PTZ_DIRECT_LEFTDOWN,
	E_PTZ_DIRECT_DOWN,
	E_PTZ_DIRECT_RIGHTDOWN,
	E_PTZ_DIRECT_STOP,
	// 焦距， TVSSPTZCtrlReq的m_dwParam1为控制速度,其他参数无效
	E_PTZ_ZOOM_FAR,
	E_PTZ_ZOOM_NEAR,
	// 对焦， TVSSPTZCtrlReq的m_dwParam1为控制速度,其他参数无效
	E_PTZ_FOCUS_LARGE,
	E_PTZ_FOCUS_SMALL,
	E_PTZ_FOCUS_AUTO,
	// 光圈， TVSSPTZCtrlReq的m_dwParam1为控制速度,其他参数无效
	E_PTZ_APERTURE_LARGE,
	E_PTZ_APERTURE_SMALL,
	E_PTZ_APERTURE_AUTO,
	// 预置位， TVSSPTZCtrlReq的m_dwParam1为预置位位置，其他参数无效
	E_PTZ_PRESET_SET,
	E_PTZ_PRESET_GET,
	E_PTZ_PRESET_CLEAR,
	// 雨刷开发
	E_PTZ_RAIN_OPEN, 
	E_PTZ_RAIN_CLOSE,
	// 灯光开关
	E_PTZ_LIGHT_OPEN,
	E_PTZ_LIGHT_CLOSE,

}EVSSPTZCMD;

//放像控制命令
typedef enum EVSSRecPlayCMD
{
	E_RECPLAY_START = 1,
	E_RECPLAY_STOP, 
	E_RECPLAY_PAUSE, 
	E_RECPLAY_RESUME,
	E_RECPLAY_SEEK,
	E_RECPLAY_SPEED,
	E_RECPLAY_FORWARD,   //播放前进
	E_RECPLAY_BACKWARD,  //播放后退
	E_RECPLAY_RESTART,   //播放重新开始
	E_RECPLAY_PROGGET,   //播放进度获取

}EVSSRecPlayCMD;

//放像速度
typedef enum EVSSRecPlaySpeed
{
	E_RECPLAY_SLOW8 = 1,
	E_RECPLAY_SLOW4,
	E_RECPLAY_SLOW2,
	E_RECPLAY_NORMALSPEED,
	E_RECPLAY_FAST2,
	E_RECPLAY_FAST4,
	E_RECPLAY_FAST8,

}EVSSRecPlaySpeed;

//屏幕浏览模式
typedef enum EScreenExpMod
{
	E_GRIDEXP_STOP = 1,
	E_GRIDEXP_SINGLE, 
	E_GRIDEXP_POLL, 

}EScreenExpMod;

//录像调度类型
typedef enum ERecScheType
{
	E_RECSCHE_ALARMREC = 1,    //告警才录像
	E_RECSCHE_CYCLE,           //周期性录像
	E_RECSCHE_ONCE,            //单次录像

}ERecScheType;

//PICELE类型
typedef enum EPicEleType
{
	E_PIC_LINE = 1,    //线
	E_PIC_TEXT,        //文本
	E_PIC_BMP32,       //BMP32图片

}EPicEleType;

//定义IO类型
typedef enum EIOType
{
	IOTYPE_LFS = 1,     //本地文件系统
	IOTYPE_RAWDEV,      //裸设备
	IOTYPE_NFS,         //网络文件系统

}EIOType;


//磁盘状态
typedef enum EDiskType
{
	E_RECSVCDISK_UNUSABLE,      //磁盘不可用
	E_RECSVCDISK_USABLE,        //使用中
}EDiskType;

//磁盘操作
typedef enum EDiskOptType
{
	E_RECSVCDISK_START = 1,   //启用
	E_RECSVCDISK_STOP,    //停用
}EDiskOptType;

//下载播放帧数据上下文
typedef enum EDWPlyFrmMedCtx
{
	E_PLY_NOFINISH = 0, // 播放未完成帧
	E_PLY_FINISH   = 1, // 播放完成帧

}EDWPlyFrmMedCtx;

//IO信息
typedef struct tagIOInfo
{
	//IOTYPE_LFS等
	u32 m_dwIOType;
	//磁盘ID IOTYPE_RAWDEV时有效
	char m_szDiskID[VSS_FILENAME_MAXLEN+1];
	//分区索引 IOTYPE_RAWDEV时有效 INVALID_U32ID表示不使用分区,直接打开设备
	u32 m_dwPartionIdx;
	//IO名称
	char m_szIOName[VSS_FILENAME_MAXLEN+1];
}TIOInfo;

// typedef struct tagTableInstCluster
// {
// 	u32 m_dwObjBasicTblInst;
// 	u32 m_dwObjHWTblInst;
// 	u32 m_dwObjNamDatTblInst;
// 	u32 m_dwObjUnNamDatTblInst;
// 	u32 m_dwDevExtInfoTblInst;
// 	u32 m_dwObjRelatUnNamDatTblInst;
// 	u32 m_dwUsrRoleListTblInst;
// 	u32 m_dwRolePriListTblInst;
// 	u32 m_dwCltOnlineTblInst;
// 	u32 m_dwLogEvtDatTblInst;         //事件数据表实例
// 	u32 m_dwStrmTopoTblInst;
// 	u32 m_dwSsnTblInst;
// 	u32 m_dwUsrExtInfoTblInstId;
// 	u32 m_dwSubScribeTblInstId;
// 	u32 m_dwObjPerfTblInstId;
// 	u32 m_dwObjPerfTblLogInstId;
// 	u32 m_dwMapTblInstId;
// 	u32 m_dwRecTblInstId;
// 	u32 m_dwChnInfoTblInstId;
// 	u32 m_dwGridBaseInfoTblInstId;
// 	u32 m_dwGridExpInfoTblInstId;
// 	u32 m_dwGridDispPortTblInstId;
// 	u32 m_dwHostSubTblInstId;
// 	u32 m_dwPollItmTblInstId;
// 	//u32 m_dwScreenPollTblInstId;
// 	u32 m_dwOverlayInfoTblInstId;
// 	u32 m_dwGuiDataSrcTblInstId;
// 	u32 m_dwAlarmRecCfgTblInstId;
// 	u32 m_dwRecScheduleTblInstId;
// 	u32 m_dwObjStatusTblId;
// 	u32 m_dwRecPathTblInstId;
// 	u32 m_dwUsedUnitTblInstId;
// 	u32 m_dwFreeUnitTblInstId;
// 	
// }TTableInstCluster;

//数据公共表资源
// typedef struct tagCommDataLInit
// {
// 	TCommInitParam m_tCommInitParam;
// 	TLightLock m_tDataLock;
// 	//memDB Table Instance
// // 	TTableInstCluster m_tTblInstCluster;
// }TCommDataLInit;

// typedef struct
// {
// 	u32 m_dwIP;
// 	u16 m_wPort;
// 	char m_szDBDriver[32];
// 	char m_szDBName[32];
// 	char m_szUserName[32];
// 	char m_szPsw[32];
// 	
// }TOdbcPara;
// 
// typedef struct  
// {
// 	TOdbcPara m_tOdbcPara;
// 
// }TOdbcCommDataLInit;

typedef struct tagDataLogicInstCluster
{
	u32 m_dwDirDLInst;
	u32 m_dwSsnDLInst;
	u32 m_dwStatusDLInst;
	u32 m_dwTransEngInst; //事务引擎
	u32 m_dwMediaDLInst;
	u32 m_dwRecDLInst;

// 	u32 m_dwChargeDBInst;
// 	u32 m_dwLogDLInst;
// 	u32 m_dwSubscDLInst;
// 	u32 m_dwLoDLInst;
// 	u32 m_dwGDSDLInst; // GDS实例
// 	u32 m_dwSUnitInst;
// 	u32 m_dwSBlcokInst;
// 	u32 m_dwBEvtDLInst;
// 	u32 m_dwNMDLInst;
// 	u32 m_dwARecDLInstId; //语音录音数据库
	
}TDataLogicInstCluster;



#endif
