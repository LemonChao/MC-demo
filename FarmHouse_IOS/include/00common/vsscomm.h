#ifndef _H_VSS_COMM_
#define _H_VSS_COMM_

//////////////////////////////////////////////////////////////////////////
//��ϢID����
#define VSS_MSG_BASE                   3000    //��ʼ��Ϣ��
//DirSvc Ŀ¼������ʼ��Ϣ��----����
#define VSS_DIR_SVC_MSG_BASE				(VSS_MSG_BASE+1000)
//CuAcessSvc �ͻ��˵�Ԫ���������ʼ��Ϣ
#define VSS_CUACCESS_SVC_MSG_BASE           (VSS_MSG_BASE+2000)
//CmuAcessSvc ���Ĺ���Ԫ���������ʼ��Ϣ
#define VSS_CMUACCESS_SVC_MSG_BASE          (VSS_MSG_BASE+3000)
//PuAcessSvc ǰ�˵�Ԫ���������ʼ��Ϣ
#define VSS_PUACCESS_SVC_MSG_BASE           (VSS_MSG_BASE+4000)
//MediaDispSvc ý��ת�ַ�������ʼ��Ϣ
#define VSS_MEDIADISP_SVC_MSG_BASE			(VSS_MSG_BASE+5000)
//RecSvc ¼�������ʼ��Ϣ
#define VSS_REC_SVC_MSG_BASE				(VSS_MSG_BASE+6000)
//RecPlaySvc ���������ʼ��Ϣ
#define VSS_RECPLAY_SVC_MSG_BASE			(VSS_MSG_BASE+6500)
//LogSvc ��־������ʼ��Ϣ
#define VSS_LOG_SVC_MSG_BASE				(VSS_MSG_BASE+7000)
//AlarmSvc �澯������ʼ��Ϣ
#define VSS_ALARM_SVC_MSG_BASE				(VSS_MSG_BASE+8000)
//TVWallSvc ����ǽ������ʼ��Ϣ
#define VSS_TVWALL_SVC_MSG_BASE				(VSS_MSG_BASE+9000)
//NMSvc ������������ʼ��Ϣ
#define VSS_NM_SVC_MSG_BASE					(VSS_MSG_BASE+10000)
//UISvc ����Ӧ�÷�����ʼ��Ϣ
#define VSS_UI_SVC_MSG_BASE					(VSS_MSG_BASE+15000)

////////// ������ҵ��ط�����ϢID����
//������ҵ��ʼ��Ϣ��
#define VSS_INSURE_MSG_BASE           20000
//AgentSvc��ʼ��Ϣ����ϯ���ͷ������ȷ���
#define VSS_AGENT_SVC_MSG_BASE         (VSS_INSURE_MSG_BASE+1000)

//Svcģ���ڲ���Ϣ�ֶ�
#define VSS_INNERMSG_BASE                   100000    //��ʼ�ڲ���Ϣ��
//DirSvc ��ʼ�ڲ���Ϣ
#define VSS_DIR_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+1000)
//CuAcessSvc ��ʼ�ڲ���Ϣ
#define VSS_CUACCESS_SVC_INNERMSG_BASE          (VSS_INNERMSG_BASE+2000)
//CmuAcessSvc ��ʼ�ڲ���Ϣ
#define VSS_CMUACCESS_SVC_INNERMSG_BASE         (VSS_INNERMSG_BASE+3000)
//PuAcessSvc ��ʼ�ڲ���Ϣ
#define VSS_PUACCESS_SVC_INNERMSG_BASE          (VSS_INNERMSG_BASE+4000)
//MediaDispSvc ��ʼ�ڲ���Ϣ
#define VSS_MEDIADISP_SVC_INNERMSG_BASE			(VSS_INNERMSG_BASE+5000)
//RecSvc ��ʼ�ڲ���Ϣ
#define VSS_REC_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+6000)
//RecPlaySvc ��ʼ�ڲ���Ϣ
#define VSS_RECPLAY_SVC_INNERMSG_BASE			(VSS_INNERMSG_BASE+6500)
//LogSvc ��ʼ�ڲ���Ϣ
#define VSS_LOG_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+7000)
//AlarmSvc ��ʼ�ڲ���Ϣ
#define VSS_ALARM_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+8000)
//TVWallSvc ��ʼ�ڲ���Ϣ
#define VSS_TVWALL_SVC_INNERMSG_BASE			(VSS_INNERMSG_BASE+9000)
//NMSvc ��ʼ�ڲ���Ϣ
#define VSS_NM_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+10000)
//UISvc ��ʼ�ڲ���Ϣ
#define VSS_UI_SVC_INNERMSG_BASE				(VSS_INNERMSG_BASE+15000)

//AgentSvc ��ʼ�ڲ���Ϣ
#define VSS_AGENT_SVC_INNERMSG_BASE					(VSS_INNERMSG_BASE+21000)

//��������ͨ������
// #define VSS_CHNTYPE_VIDEOENC          1       //��Ƶ����
// #define VSS_CHNTYPE_VIDEODEC          2       //��Ƶ����
// #define VSS_CHNTYPE_AUDIOENC          3       //��Ƶ����
// #define VSS_CHNTYPE_AUDIODEC          4       //��Ƶ����


#define VSS_TRANSDATA_MAXLEN     512
//PDU��󳤶�
#define VSS_PDU_MAXLEN                (32<<10)

#define VSS_NAME_MAXLEN        32
#define VSS_PSW_MAXLEN         32
#define VSS_TEL_MAXLEN         16
#define VSS_LIST_MAXNUM        64
#define VSS_URL_MAXLEN         128
#define VSS_FILENAME_MAXLEN    256  
#define LOGMETADATA_USERDATA_MAXLEN    256
#define VSS_SERIAL_MAXLEN              32

#define VSS_REPORTNO_LEN 			32	// �����ų���
#define VSS_PLATENO_LEN 			16	// ���ƺų���

// #define VSS_GBEID_MAXLEN       128

#define VSS_EVIDENCE_MAXLEN    512    // ֤����󳤶�(����256����Ӣ��512)
#define VSS_3G_MSG_MAXLEN      512
#define VSS_VERSTR_MAXLEN             256  //�汾��Ϣ��󳤶�
#define VSS_ETHIP_MAXNUM              16   //�������IP��ַ����

#define VSS_ROLE_OF_DOMAIN_MAXNUM  64   //ÿ��Domainӵ�е�����ɫ����
#define VSS_DEVTREE_HEIGHT_MAXNUM  64    //����CMS�����һ��dev�ļ���(�豸���߶�)
#define VSS_USRTREE_HEIGHT_MAXNUM  32    //����Domain�����һ��user�ļ���(�û����߶�)
#define VSS_EVENT_INDEX_MAXNUM        16  //�¼��������������������¼���ѯ����

// #define  VSS_DATAEXPLSVC_RSPBUF_MAXLEN  256*32

#define VSS_BLOCK_DATA_SIZE  (1024*1024)      // ��һBlock��ռ�ֽ���
#define VSS_UNIT_DATA_SIZE   (1024*1024*128)  // ��һUnit��ռ�ֽ���
#define VSS_BLOCK_INFO_SIZE (1024*4)        // ÿ��Unit���Block��Ϣ�Ĵ�С
#define VSS_UNIT_INFO_SIZE  (1024*4)        // ÿ��Unit���Unit��Ϣ�Ĵ�С

//����ObjInfo����
//#define VSS_OBJINFO_BUF_MAXLEN    (1024*4)

//data logicģ�����ƶ���
// #define VSS_MODULE_NAME_DIRDL    "DirDataLogicModule"
// #define VSS_MODULE_NAME_NMCDL    "NMCDataLogicModule"
// #define VSS_MODULE_NAME_EVTDL    "EvtDataLogicModule"
// #define VSS_MODULE_NAME_MEDIADL  "MediaDataLogicModule"
// #define VSS_MODULE_NAME_RECDL    "RecDataLogicModule"
// #define VSS_MODULE_NAME_STATUSDL "StatusDataLogicModule"
// #define VSS_MODULE_NAME_SSNDL    "SsnDataLogicModule"

//�����豸�����ִ�
#define PU_MANUF_SIMPU		"simpu"
#define PU_MANUF_JL			"JL"
#define PU_MANUF_HAIKANG	"HaiKang"
#define PU_MANUF_DAHUA		"DaHua"

//�ͻ��˶˿ڶ��� 
#define  SIGPORT_CU             6000		//��ؿͻ���
#define  SIGPORT_CHARGE_CU      6010		//����ͻ���
//�ͻ���ý��˿�
//#define  MEDIAPORT_CMC          6500

//����������˿�
//RK�����ķ���˿�
#define  RK_DISCOVERYPORT      9999
#define  SIGPORT_RK            10000
#define  SIGPORT_SIMPU         5500		//ģ��ǰ��
#define  SIGPORT_JLNETSDK        5600		//�豸����SDK
#define  SIGPORT_CMS           9000		//���Ĺ��������
#define  SIGPORT_MDS	       9010		//ý��ת�ַ�������
#define  SIGPORT_RECS	       9020		//¼�������
#define  SIGPORT_TVWS	       9030		//����ǽ������
#define  SIGPORT_DIRS          9100		//Ŀ¼��������----Ԥ��
 
//�ͻ���ý��˿�
//CUý��˿�
#define MEDIAPORTBASE_CU        12000
//MDSý��˿�
#define MEDIAPORTBASE_MDS         16000
//¼���ý��˿�
#define MEDIAPORTBASE_RECS        20000
//����ǽý��˿�
#define MEDIAPORTBASE_TVWS        24000
//NetSdký��˿�
#define MEDIAPORTBASE_NETSDK	  28000
//Pu(SimPu)ý��˿�
#define MEDIAPORTBASE_PU         32000


//Telnet�˿ڶ���
#define TELPORT_RK     3500
#define TELPORT_CMS    3600
#define TELPORT_MDS    3610
#define TELPORT_RECS   3620
#define TELPORT_TVWS   3630
#define TELPORT_SIMPU  3700
#define TELPORT_DIRS   3800		//Ŀ¼��������----Ԥ��
#define TELPORT_CU     3900
#define TELPORT_CHARGE_CU  3910

#define TELPORT_JLNETSDK	3450
#define TELPORT_JLPLAY		3451
#define TELPORT_CHARGE_CLTSDK	3456

//�ڴ�˿ڶ���
//��ƵԴ�˿�
#define VSRCMEMPORT_START     1000
//��ƵԴ�˿�
#define ASRCMEMPORT_START     1100
//��ƵĿ�Ķ˿�
#define VDSTMEMPORT_START     1200
//��ƵĿ�Ķ˿�
#define ADSTMEMPORT_START     1300

#define RK_MULTICASTIP    "234.32.0.1"

//����ǽ��Ϣ�������
#define TVW_CHANGETYPE_BASEINFO       1
#define TVW_CHANGETYPE_EXPCFG         2
#define TVW_CHANGETYPE_POLLITEM       4

#define VSS_GPSINFO_MAXLEN 256
#define VSS_ACTION_EXTRA_LEN 256
//������
typedef enum EVssErrCode
{
	VSS_OK = 0,                          //�����ɹ�
	VSS_System,                          //ϵͳ����
	VSS_InstLimit,                       //�޿���ʵ��
	VSS_InstInvalid,                     //��Чʵ��
	VSS_InvalidConn,                     //��Ч����
	VSS_PDUParseErr,                     //PDU��������
	VSS_NotInit,                         //δ��ʼ��
	VSS_AlreadyInit,                     //�Ѿ���ʼ��
	VSS_ParamErr,                        //��������
	VSS_MsgErr,                          //��Ϣ����
	VSS_SsnErr,                          //����Ssn
	VSS_AlreadyLogin,                    //�û��Ѿ���½
	VSS_UserNotExist,                    //�û�������
	VSS_PswErr,                          //�������
	VSS_PriLimit,                        //��Ȩ�޲���
	VSS_ObjNotExist,                     //�������󲻴���
	VSS_ChnErr,                          //�����ͨ����
	VSS_VODUsed,                         //VODͨ���Ѿ�ռ��
	VSS_CltBandWidthLimit,               //�ͻ��˴�������
	VSS_DevBandWidthLimit,               //�豸��������
	VSS_SrvBandWidthLimit,               //��������������
// 	VSS_IPVUOFFLINE,                     //IPVU������
// 	VSS_IPVULOGINING,                    //IPVU���ڵ�¼
	VSS_PUOFFLINE,                     //IPVU������
	VSS_PULOGINING,                    //IPVU���ڵ�¼
	VSS_DBOPTERR,                        //���ݿ��������
	VSS_IPVUNOTRESPONSE,                 //����ʱ��IPVUû����Ӧ
	VSS_TRANSSVRERR,                     //��������ڲ�����
	VSS_ADecUsed,                        //����ͨ����ռ��
	VSS_SvrLimit,                        //��������Դ����
	VSS_Timeout,                         //��ʱ
	VSS_LoginRedirect,                   // ��¼�ض���
	VSS_ISEXIST,                          // �Ѵ���
	VSS_SvcLimit,                       //������������
	VSS_ClientMediaSwitch_Failed,       //�ͻ���ý�彨��ý�彻��ʧ��
	VSS_MdsMediaSwitch_Failed,			//ý�����������ý�彻��ʧ��
	VSS_ClientFileTransChn_Failed,       //�ͻ���ý�彨���ļ�����ͨ��ʧ��
	VSS_MdsFileTransChn_Failed,			 //ý������������ļ�����ͨ��ʧ��

	VSS_VersionErr = 101, //�汾ƥ�����
	VSS_PuNoExist, //�豸�����ڣ�δ������
}EVssErrCode;

//ͳһ�������Ͷ���
typedef enum EVssUOType
{
	VSS_UOTYPE_DOMAIN = 1,      //��
	VSS_UOTYPE_SYSADMIN,        //ϵͳ����Ա
	VSS_UOTYPE_NMADMIN,         //�������Ա
	VSS_UOTYPE_ROLE,            //��ɫ
	VSS_UOTYPE_USER,            //�û�
	VSS_UOTYPE_USRGRP,          //�û���
	VSS_UOTYPE_DIR,             //��֤��Ȩ������
	VSS_UOTYPE_DIRC,            // ���ÿͻ���
	VSS_UOTYPE_CMS,             //���Ĺ��������
	VSS_UOTYPE_CU,             // ��ؿͻ���, ����ͻ���
	VSS_UOTYPE_NMS,             //���ܷ�����
	VSS_UOTYPE_NMC,             // ���ܿͻ���
	VSS_UOTYPE_DATAEXPL,               // dataExplore�ͻ���
	VSS_UOTYPE_DEVGRP,          //�豸��
	VSS_UOTYPE_PU,              //ǰ��
	VSS_UOTYPE_PUCHILD,     // PU���ӣ���VENC��VDEC��AENC��ADEC�ȶ������͵ļ���
	VSS_UOTYPE_IOINPUT,         //�����������
	VSS_UOTYPE_IOOUTPUT,        //�����������
	VSS_UOTYPE_VENCCHN,              //��Ƶ����ͨ��
	VSS_UOTYPE_AENCCHN,              //��Ƶ����ͨ��
	VSS_UOTYPE_ENCCHN,               //����ͨ��  // add by dongxia
	VSS_UOTYPE_VINPUT,               //��Ƶ�����
	VSS_UOTYPE_AINPUT,               //��Ƶ�����
	VSS_UOTYPE_VDECCHN,              //��Ƶ����ͨ��
	VSS_UOTYPE_ADECCHN,              //��Ƶ����ͨ��
	VSS_UOTYPE_DECCHN,               //����ͨ�� // add by dongxia
	VSS_UOTYPE_RECCHN,               //¼��ͨ��
	VSS_UOTYPE_RECPLYSRC,            //����Դ

	VSS_UOTYPE_MDS,    //ý��ת�ַ�������
	VSS_UOTYPE_SWITCHID,              //����ID
	VSS_UOTYPE_VTRANSCHN,              //��Ƶ����ͨ��
	VSS_UOTYPE_ATRANSCHN,              //��Ƶ����ͨ��	

	VSS_UOTYPE_RECS,    //¼�������
	VSS_UOTYPE_WSBLOCK,           //д�洢��
	VSS_UOTYPE_RSBLOCK,           //���洢��
	VSS_UOTYPE_RECT,                //¼��ƻ�ģ��

	VSS_UOTYPE_WNDHDL,               //���ھ��


// 	VSS_UOTYPE_POLLPRJ,             //��Ѳ����
//  VSS_UOTYPE_EXPSCHEMA,           //���Ԥ��	

// 	//���ӵ�ͼ
// 	VSS_UOTYPE_EMAP,
// 	//���ӵ�ͼ��
// 	VSS_UOTYPE_EMAPGRP,

// 	VSS_UOTYPE_TVWS,    //����ǽ������
// 	//����ǽ��
// 	VSS_UOTYPE_TVWALLGRP,
// 	//����ǽ
// 	VSS_UOTYPE_TVWALL,
// 	//����ǽGrid
// 	VSS_UOTYPE_TVWALL_GRID, //mdf by chenhb ���� VSS_UOTYPE_SCREEN,

// 	VSS_UOTYPE_NVRS,    //NVRS
// 	VSS_UOTYPE_BKUPS,              //���ݷ�����

// 	//GUI���ڶ���
// 	VSS_UOTYPE_REALWNDIDX,        //ʵʱ�����������
// 	VSS_UOTYPE_GUIWND_REC,        //CMC�ڲ�DecChn��¼�ƴ���
// 	VSS_UOTYPE_GUIWND_PLAYBACK,   //���񴰿�
//  VSS_UOTYPE_STREAMHDL,            //ý�������

// 	VSS_UOTYPE_3GGW,    //3G����
// 	VSS_UOTYPE_E1,      //E1����
// 
// 	VSS_UOTYPE_SVCMDLTEST,           //Svc��ģ�����
// 
// 	VSS_UOTYPE_MCCSDKSVR,             //ý���������
// 	VSS_UOTYPE_MCCSDKCLT,             //ý�����ͻ���
//
// 	VSS_UOTYPE_MEGAEPLATFORM,       //ȫ����ƽ̨
// 
// 	
// 	VSS_UOTYPE_MEDIASSN,              //ý��Ự
// 
// 	VSS_UOTYPE_AOUTPORT,              //��Ƶ�����
// 	
// 	VSS_UOTYPE_PLYCHNID,           //����������
// 
// 
// 	VSS_UOTYPE_ASFFILE,            //Asf�ļ�

// 	VSS_UOTYPE_TS,                 //ʱ϶
// 	VSS_UOTYPE_MPARTY,              //ý����
// 
// 	VSS_UOTYPE_ISUPCHN,              //ISUPͨ��
// 	VSS_UOTYPE_SIPCHN,               //SIPͨ��
// 	VSS_UOTYPE_3SDKADA_DEVMP,        //3SdkAdaʹ���豸ý���
// 	VSS_UOTYPE_3SDKADA_CHNMP,        //3SdkAdaʹ��ͨ��ý���
// 	VSS_UOTYPE_3SDKADA_HDLMP,        //3SdkAdaʹ�þ��ý���

}EVssUOType;


//�������ñ仯����
typedef enum EVSSObjChange
{
	//ǰ���������ñ仯����
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
	E_OBJCHANGE_DOMAINEXTINFOCFG,   //TVSSUserExtInfo��ֻ��������֯����ʱ������ڲ��������ݱ��ؿͻ���ʱ�õ�

	E_OBJCFG_CHANGE_END,

	//�󲿷���״̬�仯����
	E_OBJSTATUS_CHANGE_START = E_OBJCFG_CHANGE_START+1000,    
	E_OBJCHANGE_COMMSTATUS,           //TVSSObjStatus
	E_OBJCHANGE_DEVCAP,               //TVSSDevCap

// 	// ���ܶ�����Ϣ
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
// 	//���ܶ�����Ϣ
// 
// 	E_OBJSTATUS_CHANGE_END,
}EVSSObjChange;

//��־������
typedef enum EVssLogLevel
{
	E_LOG_DEBUG,	//�ڲ�����
	E_LOG_SYSERR,   //ϵͳ����
	E_LOG_SYSWARN,  //ϵͳ�澯
	E_LOG_SYSMSG_RUN,   //ϵͳ������Ϣ
	E_LOG_SYSMSG_SSN,   //ϵͳ�Ự��Ϣ
	E_LOG_SYSMSG_COMM,  //ϵͳͨ����Ϣ(��Ҫ���û������ࣩ
	E_LOG_OTHERS,	//������Ϣ
}EVssLogLevel;

//��־��¼���¼����Ͷ���
typedef enum EVssEvtType
{
	//�ڲ������¼�( ID : 1 -- 10000 )
	E_EVT_DEBUG_BEGIN = 1, 
	E_EVT_HEALTHCHECK_FAILED,           //ϵͳHealthCheckʧ��

	//////////////////////////////////////////////////////////////////////////
	// ϵͳ����( ID : 10001 -- 11000 )
	E_EVT_SYSERR_BEGIN = 10001,
	E_EVT_SYSERR_INIT,  //����ʧ��
	E_EVT_SYSERR_SVC,   //�����쳣
	E_EVT_SYSERR_MEDIAR,//ý�崦���쳣
	E_EVT_SYSERR_DB,    //���ݿ��쳣
	E_EVT_SYSERR_NET,   //�����쳣

	//////////////////////////////////////////////////////////////////////////
	// ϵͳ�澯
	//ϵͳ���ܸ澯( ID : 11001 -- 12000 )
	E_EVT_SYSWARN_BEGIN =11001,
	E_EVT_SYSWARN_CPU,	     //Cpuʹ���ʹ��߸澯
	E_EVT_SYSWARN_MEMORY,	 //�ڴ�ʹ���ʹ��߸澯
	E_EVT_SYSWARN_DISK,	     //�����쳣�澯
	E_EVT_SYSWARN_NET_FULL,	 //������������澯
	E_EVT_SYSWARN_HARDWARE_ADD,      //Ӳ������澯
	E_EVT_SYSWARN_HARDWARE_DEL,      //Ӳ���γ��澯
	E_EVT_SYSWARN_VIDEO_LOST,        //��ƵԴ��ʧ�澯    //������ͨ�����
	E_EVT_SYSWARN_RECSPACE_FULL,     //¼��ռ����澯
	E_EVT_SYSWARN_DEVSSN,    //�豸�Ự�澯

	//////////////////////////////////////////////////////////////////////////
	// ϵͳ��Ϣ
	//ϵͳ�����¼�( ID : 12001 -- 13000 )
	E_EVT_SYSMSG_BEGIN=12001,
	E_EVT_SYSMSG_INIT,                   //ϵͳ��ʼ��
	E_EVT_SYSMSG_EXIT,                   //ϵͳ�˳�
	E_EVT_SYSMSG_REBOOT,                     //ϵͳ����

	//ϵͳ�Ự�¼�( ID : 12101 -- 12200 )
	E_EVT_SYSMSG_USER_LOGIN=12101,          //�û���¼
	E_EVT_SYSMSG_USER_LOGOUT,         //�û�ע��
	E_EVT_SYSMSG_USER_DISCON,         //�û��쳣�Ͽ�����

	E_EVT_SYSMSG_PU_ONLINE,           //PU����
	E_EVT_SYSMSG_PU_OFFLINE,          //PU����
	E_EVT_SYSMSG_PU_CONNERR,          //PU����ʧ��

	E_EVT_SYSMSG_CMU_LOGIN,          //�û���¼
	E_EVT_SYSMSG_CMU_LOGOUT,         //�û�ע��
	E_EVT_SYSMSG_CMU_DISCON,         //�û��쳣�Ͽ�����


	//ϵͳ�����¼�( ID : 12201 -- 12300 )
	E_EVT_SYSMSG_MEDIASWITCH= 12201,
	E_EVT_SYSMSG_MEDIASWITCH_STOP,

	//¼���¼�( ID : 12301 -- 12400 )
	E_EVT_SYSMSG_REC_BEGIN= 12301,
	E_EVT_SYSMSG_REC_STOP,
	
}EVssEvtType;

//LogԪ����
typedef struct TLogMetaData
{
	//u64 m_qwLogSqeID;   //��־��ˮ��
	u32 m_dwLogTime;      //��־ʱ��
	u32 m_dwLogLevel;	  //��־�ȼ� ��EVssLogLevel
	u32 m_dwEvtType;      //�������־��¼���¼����� ���豸���У��û���½���豸����ȣ���
	u32 m_dwHostObjType;		//�¼���������������
	u64 m_qwHostObjID;			//�¼�����������ID;
	u32 m_dwAccusatObjType;		//�¼���������������
	u64 m_qwAccusatObjID;		//�¼�����������ID;
	u32 m_deLogDescLen; //��־��������
	char m_szLogDesc[LOGMETADATA_USERDATA_MAXLEN+1]; //��־����
}TLogMetaData;

// 
// //�¼������
// typedef enum EEvtClassify
// {
// 	//�����¼�
// 	E_EVT_CLASSIFY_ALL = 1,  //�����������ݿ���ܻ���Ϊ���ԣ����鲻�� 0 
// 
// 	//�����¼�
// 	E_EVT_CLASSIFY_DEBUG, 
// 
// 	//��ǰ�澯
// 	E_EVT_CLASSIFY_CURRENTALARM,
// 
// 	//��ʷ�澯
// 	E_EVT_CLASSIFY_HISTORYALARM,
// 
// 	//��־���¼���ʼ
// 	E_EVT_CLASSIFY_LOGBEGIN = 10000,
// 
// 	//���ܸ澯�¼�
// 	E_EVT_CLASSIFY_NMWARNING,
// 
// 	//ҵ��澯�¼�
// 	E_EVT_CLASSIFY_APPALARM,
// 
// 	//ϵͳ�¼�
// 	E_EVT_CLASSIFY_SYSTEM,
// 
// 	//�Ự�¼�
// 	E_EVT_CLASSIFY_SSN,
// 
// 	//Ŀ¼�����¼�
// 	E_EVT_CLASSIFY_DIROP,
// 
// 	//ʵʱ���¼�
// 	E_EVT_CLASSIFY_REALMEDIA,
// 
// 	//¼���¼�
// 	E_EVT_CLASSIFY_REC,
// 
// 	//���������¼�
// 	E_EVT_CLASSIFY_PARAMCFG,
// 
// 	//���ܷ����¼�
// 	E_EVT_CLASSIFY_INTELLECT,
// 
// }EEvtClassify;
// 
// //�¼������Ͷ���
// typedef enum EVssEvtType
// {
// 	//�ڲ������¼�( ID : 1 -- 100000 )
// 	E_EVT_DEBUG_BEGIN = 1, 
// 	E_EVT_HEALTHCHECK_FAILED,           //ϵͳHealthCheckʧ��
// 	E_EVT_DEBUG_END = 100000, 
// 
// 	//���ܸ澯( ID : 100001 -- 101000 )
// 	E_EVT_NMWARNING_BEGIN,
// 	E_EVT_CPU_WARNING,	     //Cpuʹ���ʹ��߸澯
// 	E_EVT_MEMORY_WARNING,	 //�ڴ�ʹ���ʹ��߸澯
// 	E_EVT_DISK_WARNING,	     //�����쳣�澯
// 	E_EVT_NET_FULL_WARNING,	 //������������澯
// 	E_EVT_HARDWARE_ADD,      //Ӳ������澯
// 	E_EVT_HARDWARE_DEL,      //Ӳ���γ��澯
// 	E_EVT_VIDEO_LOST,        //��ƵԴ��ʧ�澯    //������ͨ�����
// 	E_EVT_RECSPACE_FULL,     //¼��ռ����澯
// 	E_EVT_DEVSSN_WARNING,    //�豸�Ự�澯
// 	E_EVT_NMWARNING_END = 101000,
// 
// 	//ҵ��澯( ID : 101001 -- 102000 )
// 	E_EVT_APPALARM_BEGIN,
// 	E_EVT_IOINPUT_ALARM,        //����������澯      
// 	E_EVT_IOOUTPUT_ALARM,	    //����������澯
// 	E_EVT_MD_ALARM,	            //�ƶ����澯             //������ͨ�����
// 	
// 	E_EVT_MOVEING_REGION_ALARM,       // ���������ƶ�
// 	E_EVT_LOITERING_REGION_ALARM,     // ���������ǻ��澯
// 	E_EVT_CONGREGATE_REGION_ALARM,    // �������ھۼ�
// 	E_EVT_UNATTENDEDOBJ_REGION_ALARM, // ������澯
// 	E_EVT_REMOVEOBJ_ALARM,            // ������Ƹ澯
// 	E_EVT_REGION_ENTER_ALARM,         // ���ָ澯,����������
// 	E_EVT_REGION_LEAVE_ALARM,         // ���ָ澯,�������뿪
// 	E_EVT_TRIPWIRE_ALARM,             // ��Խ���߸澯
// 	E_EVT_FENCE_ALARM,                // ��ԽΧǽ�澯
// 	E_EVT_OBJECT_COUNT_ALARM,         // ��Ʒ����
// 	E_EVT_SMOKE_ALARM,                // �̸澯
// 	E_EVT_FIRE_ALARM,                 // ��澯
// 	E_EVT_STPVEHICLE_ALARM,           // �Ƿ�ͣ���澯
// 
// 	E_EVT_CAMMOVE_ALARM,        //�������λ�澯
// 	E_EVT_SIGLOST_ALARM,        //�źŶ�ʧ�澯
// 	E_EVT_OBJTRACK_ALARM,       //������ٸ澯
// 	E_EVT_TRACKSTART_ALARM,		//��̨��ʼ���ٸ澯
// 
// 	E_EVT_OBJGPSPOS_ALARM,		//����GPS����仯
// 
// 	E_EVT_APPALARM_END = 102000,
// 
// 	//ϵͳ�¼�( ID : 102001 -- 103000 )
// 	E_EVT_SYSTEM_BEGIN,
// 	E_EVT_SYS_INIT,                   //ϵͳ��ʼ��
// 	E_EVT_SYS_EXIT,                   //ϵͳ�˳�
// 	E_EVT_REBOOT,                     //ϵͳ����
// 	E_EVT_SYSTEM_END = 103000,
// 
// 	//�Ự�¼�( ID : 103001 -- 104000 )
// 	E_EVT_SSN_BEGIN,
// 	E_EVT_USER_LOGIN,          //�û���¼
// 	E_EVT_USER_LOGOUT,         //�û�ע��
// 	E_EVT_USER_DISCON,         //�û��Ͽ�����
// 
// 	E_EVT_PU_ONLINE,           //PU����
// 	E_EVT_PU_OFFLINE,          //PU����
// 	E_EVT_PU_CONNERR,          //PU����ʧ��
// 	E_EVT_SSN_END = 104000,
// 
// 	//Ŀ¼�����¼�( ID : 104001 -- 105000 )
// 	E_EVT_DIROP_BEGIN,
// 	E_EVT_CMS_ADD,   //CMS����
// 	E_EVT_CMS_DEL,   //CMS����
// 	E_EVT_CMS_NAMEMDY,   //�޸�CMS����
// 
// 	E_EVT_PU_ADD,          //ǰ���豸����
// 	E_EVT_PU_DEL,          //ǰ���豸����
// 	E_EVT_PU_NAMEMDY,      //�޸�ǰ���豸����
// 
// 	E_EVT_DEVGRP_ADD,       //�����豸��
// 	E_EVT_DEVGRP_DEL,       //ɾ���豸��
// 	E_EVT_DEVGRP_NAMEMDY,       //�޸��豸������
// 
// 	E_EVT_DOMAIN_ADD,       //�����
// 	E_EVT_DOMAIN_DEL,       //ɾ����
// 	E_EVT_DOMAIN_NAMEMDY,   //�޸�������
// 
// 	E_EVT_USR_ADD,          //�����û�
// 	E_EVT_USR_DEL,          //ɾ���û�
// 	E_EVT_USR_PWD_MDY,      //�޸��û�����
// 	E_EVT_USR_ROLE_SET,     //�����û���ɫ
// 
// 	E_EVT_USRGRP_ADD,       //�����û���
// 	E_EVT_USRGRP_DEL,       //ɾ���û���
// 	E_EVT_USRGRP_NAMEMDY,       //�޸��û�������
// 	E_EVT_USRGRP_ROLE_SET,      //�����û����ɫ
// 
// 	E_EVT_ROLE_ADD,         //���ӽ�ɫ
// 	E_EVT_ROLE_DEL,         //ɾ����ɫ
// 	E_EVT_ROLE_NAMEMDY,         //�޸Ľ�ɫ����
// 	E_EVT_ROLE_PRI_ADD,      //���ӽ�ɫȨ��
// 	E_EVT_ROLE_PRI_DEL,      //ɾ����ɫȨ��
// 	E_EVT_DIROP_END = 105000,
// 
// 	//ʵʱ���¼�( ID : 105001 -- 106000 )
// 	E_EVT_REALMEDIA_BEGIN,
// 	E_EVT_REALMEDIA_END = 106000,
// 
// 	//¼���¼�( ID : 106001 -- 107000 )
// 	E_EVT_REC_BEGIN,
// 	E_EVT_REC_END = 107000,
// 
// 	//���������¼�( ID : 107001 -- 108000 )
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
// //�¼���ѯ������
// typedef enum EVSSEvtQryMajorType
// {
// 	E_EVTQRY_MAJORTYPE_CURAPPALARM = 0,    //��ǰҵ��澯
// 	E_EVTQRY_MAJORTYPE_HISAPPALARM,        //��ʷҵ��澯
// 	E_EVTQRY_MAJORTYPE_ALLAPPALARM,           //����ҵ��澯(��ǰ+��ʷ)
// 	E_EVTQRY_MAJORTYPE_OPELOG,             //������־
// 	E_EVTQRY_MAJORTYPE_CURFAULTALARM,      //��ǰ���ϸ澯
// 	E_EVTQRY_MAJORTYPE_HISFAULTALARM,      //��ʷ���ϸ澯
// 	E_EVTQRY_MAJORTYPE_ALLFAULTALARM,      //���й��ϸ澯
// }EVSSEvtQryMajorType;
// 
// //add by yxj
// typedef enum EVSSEvtStatisType
// {
// 	E_EVT_STATISTYPE_ALLALARM = 0,         //�澯������ѯ
// 	E_EVT_STATISTYPE_CURRENTALARM,        //��ǰ�澯������ѯ
// 	E_EVT_STATISTYPE_ALLALARMTODAY,       //���ո澯������ѯ
// 	E_EVT_STATISTYPE_ALLALARMTHISWEEK,     //���ܸ澯������ѯ
// }EVSSEvtStatisType;
// //add by yxj end
// 
// typedef enum EVSSRadComboBoxType
// {
// 	E_RADCOMBOBOX_FAULT_LEVEL = 0,       //���ϼ���ؼ�
// 	E_RADCOMBOBOX_FAULT_CLASS,           //�������Ϳؼ�
// 	E_RADCOMBOBOX_RESOLVED_CLASS,        //���״̬�ؼ�
// 	E_RADCOMBOBOX_STAT_CLASS,            //ͳ�����ؼ�
// 	E_RADCOMBOBOX_EMOTION_CLASS,         //����״̬�ؼ�
// 	E_RADCOMBOBOX_EVIDENCE_CLASS,        //֤�ݿؼ�
// 	
// }EVSSRadComboBoxType;
// 
// //��֤����Ŀͻ�������
// //ע�����еĿͻ��˵���֤�����͵�Dir Server������DIR Server��CMS��NMS֮��ĵ�¼��ϵ�ǣ���DirServer��CMS��¼��
// //�������Է���Dir Server��˲��ѹ��
// typedef enum EVSSAuthCltType
// {
// 	VSS_AUTH_CLTTYPE_CMC,   //ҵ��ͻ���
// 	VSS_AUTH_CLTTYPE_NMC,   //���ܿͻ���
// 	VSS_AUTH_CLTTYPE_DIRCLT,   //DIR �ͻ���
// 	VSS_AUTH_CLTTYPE_DIRSVR,   //Dir server�����������Ҫ����DIR��CMS�ĵ�¼��֤
// 	
// }EVSSAuthCltType;
// 
// //�������������ͳ������
// typedef enum EVSSObjDataType
// {
// 	E_OBJDATA_TYPE_BEGIN,
// 
// 	E_OBJDATA_SUBCMS_STATIS,  //�¼�CMS
// 	E_OBJDATA_SUBCMS_TOTALCNT,  
// 	E_OBJDATA_SUBCMS_ONLINECNT,
// 	E_OBJDATA_HKDEV_STATIS,  //�����豸
// 	E_OBJDATA_HKDEV_TOTALCNT,  
// 	E_OBJDATA_HKDEV_ONLINECNT,
// 	E_OBJDATA_DHDEV_STATIS,                   //���豸
// 	E_OBJDATA_DHDEV_TOTALCNT, 
// 	E_OBJDATA_DHDEV_ONLINECNT,
// 	E_OBJDATA_CMCCLT_STATIS,           //ҵ��ͻ���
// 	E_OBJDATA_CMCCLT_TOTALCNT,  
// 	E_OBJDATA_CMCCLT_ONLINECNT,
// 
// 	E_OBJDATA_TYPE_END,
// 
// }EVSSObjDataType;
// 
// //���������ĻỰ����ͳ��
// typedef enum EVSSObjRelaDataType
// {
// 	E_OBJRELA_SSNID,
// 	E_OBJRELA_DATA_TYPE_BEGIN,         
// 
// 	E_OBJRELA_LOGIN_FAILURE_CNT,             //��¼ʧ�ܴ���
// 	E_OBJRELA_LIVEVIEW_FAILURE_CNT,        //live���ʧ�ܴ���
// 	E_OBJRELA_RECVIEW_FAILURE_CNT,        //¼�����ʧ�ܴ���
// 	
// 	E_OBJRELA_DATA_TYPE_END,
// 
// }EVSSObjRelaDataType;  //������������������



//ý�彻��ģʽ
typedef enum EVSSMediaSwitchMode
{
	E_SWITCHMODE_NONE = 0 ,	//�޽��������ڱ�ʾ������Ƶ����Ƶ����
	E_SWITCHMODE_SIMPLEX_RCV = 1 ,	//������գ������������󱻽е�����������Ƶ�������Ƶ������
	E_SWITCHMODE_SIMPLEX_SND = 2 ,	//�����ͣ����������������������У�����Ƶ�㲥��������
	E_SWITCHMODE_DUPLEX  = 3,		//˫�򽻻������������Խ���˫����Ƶ��
}EVSSMediaSwitchMode;


// PTZ�����Ӧ�ṹ TVSSPTZCtrlReq
typedef enum EVSSPTZCMD
{
	// ���� TVSSPTZCtrlReq��m_dwParam1Ϊ�����ٶ�,����������Ч
	E_PTZ_DIRECT_LEFTUP = 1, 
	E_PTZ_DIRECT_UP,
	E_PTZ_DIRECT_RIGHTUP,
	E_PTZ_DIRECT_LEFT,
	E_PTZ_DIRECT_RIGHT,
	E_PTZ_DIRECT_LEFTDOWN,
	E_PTZ_DIRECT_DOWN,
	E_PTZ_DIRECT_RIGHTDOWN,
	E_PTZ_DIRECT_STOP,
	// ���࣬ TVSSPTZCtrlReq��m_dwParam1Ϊ�����ٶ�,����������Ч
	E_PTZ_ZOOM_FAR,
	E_PTZ_ZOOM_NEAR,
	// �Խ��� TVSSPTZCtrlReq��m_dwParam1Ϊ�����ٶ�,����������Ч
	E_PTZ_FOCUS_LARGE,
	E_PTZ_FOCUS_SMALL,
	E_PTZ_FOCUS_AUTO,
	// ��Ȧ�� TVSSPTZCtrlReq��m_dwParam1Ϊ�����ٶ�,����������Ч
	E_PTZ_APERTURE_LARGE,
	E_PTZ_APERTURE_SMALL,
	E_PTZ_APERTURE_AUTO,
	// Ԥ��λ�� TVSSPTZCtrlReq��m_dwParam1ΪԤ��λλ�ã�����������Ч
	E_PTZ_PRESET_SET,
	E_PTZ_PRESET_GET,
	E_PTZ_PRESET_CLEAR,
	// ��ˢ����
	E_PTZ_RAIN_OPEN, 
	E_PTZ_RAIN_CLOSE,
	// �ƹ⿪��
	E_PTZ_LIGHT_OPEN,
	E_PTZ_LIGHT_CLOSE,

}EVSSPTZCMD;

//�����������
typedef enum EVSSRecPlayCMD
{
	E_RECPLAY_START = 1,
	E_RECPLAY_STOP, 
	E_RECPLAY_PAUSE, 
	E_RECPLAY_RESUME,
	E_RECPLAY_SEEK,
	E_RECPLAY_SPEED,
	E_RECPLAY_FORWARD,   //����ǰ��
	E_RECPLAY_BACKWARD,  //���ź���
	E_RECPLAY_RESTART,   //�������¿�ʼ
	E_RECPLAY_PROGGET,   //���Ž��Ȼ�ȡ

}EVSSRecPlayCMD;

//�����ٶ�
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

//��Ļ���ģʽ
typedef enum EScreenExpMod
{
	E_GRIDEXP_STOP = 1,
	E_GRIDEXP_SINGLE, 
	E_GRIDEXP_POLL, 

}EScreenExpMod;

//¼���������
typedef enum ERecScheType
{
	E_RECSCHE_ALARMREC = 1,    //�澯��¼��
	E_RECSCHE_CYCLE,           //������¼��
	E_RECSCHE_ONCE,            //����¼��

}ERecScheType;

//PICELE����
typedef enum EPicEleType
{
	E_PIC_LINE = 1,    //��
	E_PIC_TEXT,        //�ı�
	E_PIC_BMP32,       //BMP32ͼƬ

}EPicEleType;

//����IO����
typedef enum EIOType
{
	IOTYPE_LFS = 1,     //�����ļ�ϵͳ
	IOTYPE_RAWDEV,      //���豸
	IOTYPE_NFS,         //�����ļ�ϵͳ

}EIOType;


//����״̬
typedef enum EDiskType
{
	E_RECSVCDISK_UNUSABLE,      //���̲�����
	E_RECSVCDISK_USABLE,        //ʹ����
}EDiskType;

//���̲���
typedef enum EDiskOptType
{
	E_RECSVCDISK_START = 1,   //����
	E_RECSVCDISK_STOP,    //ͣ��
}EDiskOptType;

//���ز���֡����������
typedef enum EDWPlyFrmMedCtx
{
	E_PLY_NOFINISH = 0, // ����δ���֡
	E_PLY_FINISH   = 1, // �������֡

}EDWPlyFrmMedCtx;

//IO��Ϣ
typedef struct tagIOInfo
{
	//IOTYPE_LFS��
	u32 m_dwIOType;
	//����ID IOTYPE_RAWDEVʱ��Ч
	char m_szDiskID[VSS_FILENAME_MAXLEN+1];
	//�������� IOTYPE_RAWDEVʱ��Ч INVALID_U32ID��ʾ��ʹ�÷���,ֱ�Ӵ��豸
	u32 m_dwPartionIdx;
	//IO����
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
// 	u32 m_dwLogEvtDatTblInst;         //�¼����ݱ�ʵ��
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

//���ݹ�������Դ
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
	u32 m_dwTransEngInst; //��������
	u32 m_dwMediaDLInst;
	u32 m_dwRecDLInst;

// 	u32 m_dwChargeDBInst;
// 	u32 m_dwLogDLInst;
// 	u32 m_dwSubscDLInst;
// 	u32 m_dwLoDLInst;
// 	u32 m_dwGDSDLInst; // GDSʵ��
// 	u32 m_dwSUnitInst;
// 	u32 m_dwSBlcokInst;
// 	u32 m_dwBEvtDLInst;
// 	u32 m_dwNMDLInst;
// 	u32 m_dwARecDLInstId; //����¼�����ݿ�
	
}TDataLogicInstCluster;



#endif
