#ifndef __STLDEF_H__
#define __STLDEF_H__

//���峣��
#define MAX_EVENTNAME_LEN 64 ///�¼�������󳤶�

enum EmSTLLogLvl
{
    emLogNone   =   0, //���д�ӡ�ر�
    emLogError  =   10,//10-19 //�����ӡ
    emLogWarn   =   20,//20-29 //�����ӡ
    emLogNormal =   100, //һ���ӡ
	emLogParaChk=   110,//100-110 //����У��
    emLogMsg    =   200,//200
	emLogTimer  =   230,//��ʱ����
	emLogThread =   240,//�߳�����
    emLogTrace  =   250,//���ø���
	emLogAll    =   255 //���д�ӡ
};

//////////////////////////////////////////////////////////////////////////
//ipvu������ģ�鹲�ú�
#ifndef MAX
#define MAX(a,b)            (((u32)(a) > (u32)(b)) ? (a) : (b))
#endif

#ifndef MIN
#define MIN(a,b)            (((u32)(a) < (u32)(b)) ? (a) : (b))
#endif

//��ȫ�ͷ�
#ifndef SAFE_FREE
#define SAFE_FREE(p) do {if((p) != NULL) free(p);(p)= NULL;} while(0)
#endif

//���ݴ�С
#ifndef SIZE_ARRAY
#define SIZE_ARRAY(myArray) (sizeof(myArray)/sizeof(myArray[0]))
#endif

//�ڴ����
#define SIZE_ALIGN(size, align) ( ((size)%(align) == 0) ? (size) : ( (size)/(align) + 1 ) * (align) )

//�ж�X�Ƿ���2��������
#define IS_2_POW_N(X)   (((X)&(X-1)) == 0)

#define IS_ROUND2(n,pow2) (( n + pow2 - 1) & ~(pow2 - 1))

#define MAKEU16(low,high)   ((u16)((u8)(low)) | (((u16)(u8)(high))<<8))
#define MAKEU32(low,high)   ((u32)((u16)(low)) | (((u32)(u16)(high))<<16))
#define MAKEU64(low,high)   ((u64)((u32)(low)) | (((u64)(u32)(high))<<32))

//u16��ȡ��8λ,��8λ
#define LOU16(l) ((u8)(l))
#define HIU16(l) ((u8)(((u16)(l) >> 8) & 0xFF))

//u32��ȡ��16λ,��16λ
#define LOU32(l) ((u16)(l))
#define HIU32(l) ((u16)(((u32)(l) >> 16) & 0xFFFF))

//u64��ȡ��32λ,��32λ
#define LOU64(l) ((u32)(l))
#define HIU64(l) ((u32)(((u64)(l) >> 32) & 0xFFFFFFFF))

//����oalģ���ڴ��������ͷ�
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
//�¼�������ԭ��
typedef void (*TPfnAppEventHandle)(void);

typedef struct tagEventMapEntry
{	 
	u32   m_dwEventID;                       //�¼���	
    TPfnAppEventHandle  m_appEventFun;         //������¼�ʱʹ�õ�Ӧ�ûص�������		
	char  m_szEventName[1];   //���¼�����
}TEventMapEntry;

typedef struct tagEventMapTable 
{	
	u16                m_wEntryNum;	
	TEventMapEntry*    m_ptEvtMapEntries;
	char               m_szEvtMapTblName[MAX_EVENTNAME_LEN+1];
}TEventMapTable;


/*������Ϣӳ���*/
/*������Ϣӳ���*/
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

/*������Ϣӳ��*/
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


