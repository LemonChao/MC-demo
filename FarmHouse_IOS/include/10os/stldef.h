#ifndef __STLDEF_H__
#define __STLDEF_H__

//定义常量
#define MAX_EVENTNAME_LEN 64 ///事件名称最大长度

enum EmSTLLogLvl
{
    emLogNone   =   0, //所有打印关闭
    emLogError  =   10,//10-19 //出错打印
    emLogWarn   =   20,//20-29 //警告打印
    emLogNormal =   100, //一般打印
	emLogParaChk=   110,//100-110 //参数校验
    emLogMsg    =   200,//200
	emLogTimer  =   230,//定时心跳
	emLogThread =   240,//线程心跳
    emLogTrace  =   250,//调用跟踪
	emLogAll    =   255 //所有打印
};

//////////////////////////////////////////////////////////////////////////
//ipvu各个子模块共用宏
#ifndef MAX
#define MAX(a,b)            (((u32)(a) > (u32)(b)) ? (a) : (b))
#endif

#ifndef MIN
#define MIN(a,b)            (((u32)(a) < (u32)(b)) ? (a) : (b))
#endif

//安全释放
#ifndef SAFE_FREE
#define SAFE_FREE(p) do {if((p) != NULL) free(p);(p)= NULL;} while(0)
#endif

//数据大小
#ifndef SIZE_ARRAY
#define SIZE_ARRAY(myArray) (sizeof(myArray)/sizeof(myArray[0]))
#endif

//内存对齐
#define SIZE_ALIGN(size, align) ( ((size)%(align) == 0) ? (size) : ( (size)/(align) + 1 ) * (align) )

//判断X是否是2的整数幂
#define IS_2_POW_N(X)   (((X)&(X-1)) == 0)

#define IS_ROUND2(n,pow2) (( n + pow2 - 1) & ~(pow2 - 1))

#define MAKEU16(low,high)   ((u16)((u8)(low)) | (((u16)(u8)(high))<<8))
#define MAKEU32(low,high)   ((u32)((u16)(low)) | (((u32)(u16)(high))<<16))
#define MAKEU64(low,high)   ((u64)((u32)(low)) | (((u64)(u32)(high))<<32))

//u16读取低8位,高8位
#define LOU16(l) ((u8)(l))
#define HIU16(l) ((u8)(((u16)(l) >> 8) & 0xFF))

//u32读取低16位,高16位
#define LOU32(l) ((u16)(l))
#define HIU32(l) ((u16)(((u32)(l) >> 16) & 0xFFFF))

//u64读取低32位,高32位
#define LOU64(l) ((u32)(l))
#define HIU64(l) ((u32)(((u64)(l) >> 32) & 0xFFFFFFFF))

//基于oal模块内存申请与释放
#define STL_MALLOC(hMemHdl,dwbytes,tag) OalMalloc(hMemHdl,dwbytes,tag)
#define STL_SAFE_FREE(hMemHdl,pMem)     do { if(pMem) { OalMFree(hMemHdl,pMem);pMem = NULL;}}while(0)

#define STL_NULL

#define STL_PARAM_CHK(exp,prtfunc,ret) \
    do \
{\
    if(exp)\
    {\
    prtfunc(emLogParaChk,"%s err,%s,%d!\n",#exp,__FILE__,__LINE__);\
    return ret;\
    }\
}while(0)

//////////////////////////////////////////////////////////////////////////
//事件处理函数原型
typedef void (*TPfnAppEventHandle)(void);

typedef struct tagEventMapEntry
{	 
	u32   m_dwEventID;                       //事件号	
    TPfnAppEventHandle  m_appEventFun;         //处理该事件时使用的应用回调处理函数		
	char  m_szEventName[1];   //该事件名称
}TEventMapEntry;

typedef struct tagEventMapTable 
{	
	u16                m_wEntryNum;	
	TEventMapEntry*    m_ptEvtMapEntries;
	char               m_szEvtMapTblName[MAX_EVENTNAME_LEN+1];
}TEventMapTable;


/*声明消息映射表*/
/*定义消息映射表*/
#define STL_BEGIN_EVENT_MAP(eventMapEntries) \
    static TEventMapEntry eventMapEntries[] = \
{ \
	
// Add Event Item
#define STL_ON_EVENT(MsgId,convertFun) \
{\
	MsgId,\
	(TPfnAppEventHandle)convertFun,\
	0\
}\

/*结束消息映射*/
#define STL_END_EVENT_MAP() \
}; \

//////////////////////////////////////////////////////////////////////////
typedef struct tagSTId2NameItem
{
	 u32   m_dwId;
	 char  m_szIdDesc[MAX_EVENTNAME_LEN+1];
}TSTId2NameItem;

// Begin Id to Name Map
#define STL_BEGIN_ID2NAME_MAP(errorCodeMapEntries) \
    TSTId2NameItem errorCodeMapEntries[] = \
{\
	
#define STL_ID_ITEM(id) \
{\
    id,\
#id\
},

// End Id2Name Map
#define STL_END_ID2NAME_MAP() \
}; \



#endif // end of file..........................


