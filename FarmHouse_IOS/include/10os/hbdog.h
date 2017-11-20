#ifndef _HB_DOG_H
#define _HB_DOG_H

#ifdef __cplusplus
extern "C"{
#endif

#define HBDOG_VER    "1.0"

#define HBD_OK  0
#define HBD_E_BEGIN  0xffff0001

enum EmRKDogErrorNo
{
	HBD_PARAMERR = HBD_E_BEGIN,		//0x01
	HBD_LACKMEMERR,
	HBD_NOMEMMAPERR, //没有内存映射
	HBD_BSPERR,  
	HBD_MEMMAPERR,
	HBD_NOHBITEM,
	HBD_NOALLOCATTED,
	HBD_ERR_END
};

/*============== 由创建者调用的函数 BEGIN ================*/

//看门狗初始化，开辟共享内存
u32 HBDog_Init(IN TCommInitParam *ptCommInit, IN u32 dwHBItemNum, IN u32 dwMaxHBCount, OUT u32 *pdwHBDogHdl);

//看门狗模块退出
u32 HBDog_Exit(IN u32 dwHBDogHdl);

//设置当前待加入心跳表索引
u32 HBDog_WaitAttIdxSet(IN u32 dwHBDogHdl, IN u32 dwHBItemIdx);

//获取当前待加入心跳表索引
u32 HBDog_WaitAttIdxGet(IN u32 dwHBDogHdl, OUT u32 *pdwHBItemIdx);

//心跳检测，若超过心跳最大值，pbHB返回FALSE
u32 HBDog_HBCheck(IN u32 dwHBDogHdl, IN u32 dwHBItemIdx, OUT BOOL *pbHB);

//重置心跳表项
u32 HBDog_HBItemReset(IN u32 dwHBDogHdl, IN u32 dwHBItemIdx);

//心跳表上下文获取
u32 HBDog_CtxGet(IN u32 dwHBDogHdl, IN u32 dwHBItemIdx, OUT OCC *ptCtx);

/*============== 由创建者调用的函数 END ================*/

/*============== 由看门狗的使用者调用的函数 BEGIN================*/

//申请加入监测系统，得到看门狗句柄
u32 HBDog_Attach(IN TCommInitParam *ptCommInit, OUT u32 *pdwHBDogHdl);

//申请退出监测系统
u32 HBDog_Detach(IN u32 dwHBDogHdl);

//喂狗
u32 HBDog_Feed(IN u32 dwHBDogHdl);

//看门狗上下文设置
u32 HBDog_CtxSet(IN u32 dwHBDogHdl, IN OCC tCtx);

/*============== 由看门狗的使用者调用的函数 END================*/


/*============== 创建者和使用者公共函数 ================*/

//获取心跳表大小
u32 HBDog_HBItemNumGet(IN u32 dwHBDogHdl, OUT u32 *pdwHBNum);

//版本号获取
char* HBDogVerGet(IN OUT char *pchVerBuf, IN u32 dwBufLen);

//错误码解析
char* HBDogErrInfoGet(IN u32 dwErrorNo, IN char *pchErrInfo, IN u32 dwInBytes);

void hbdogver(IN void* dwTelHdl);

//看门狗服务端信息，由创建者调用
void dogsinfo(IN void* dwTelHdl, IN u32 dwRKDogHdl);

//看门狗客户端信息，由使用者调用
void dogcinfo(IN void* dwTelHdl, IN u32 dwRKDogHdl);

#ifdef __cplusplus
}
#endif

#endif // _RK_DOG_H

