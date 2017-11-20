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
	HBD_NOMEMMAPERR, //û���ڴ�ӳ��
	HBD_BSPERR,  
	HBD_MEMMAPERR,
	HBD_NOHBITEM,
	HBD_NOALLOCATTED,
	HBD_ERR_END
};

/*============== �ɴ����ߵ��õĺ��� BEGIN ================*/

//���Ź���ʼ�������ٹ����ڴ�
u32 HBDog_Init(IN TCommInitParam *ptCommInit, IN u32 dwHBItemNum, IN u32 dwMaxHBCount, OUT u32 *pdwHBDogHdl);

//���Ź�ģ���˳�
u32 HBDog_Exit(IN u32 dwHBDogHdl);

//���õ�ǰ����������������
u32 HBDog_WaitAttIdxSet(IN u32 dwHBDogHdl, IN u32 dwHBItemIdx);

//��ȡ��ǰ����������������
u32 HBDog_WaitAttIdxGet(IN u32 dwHBDogHdl, OUT u32 *pdwHBItemIdx);

//������⣬�������������ֵ��pbHB����FALSE
u32 HBDog_HBCheck(IN u32 dwHBDogHdl, IN u32 dwHBItemIdx, OUT BOOL *pbHB);

//������������
u32 HBDog_HBItemReset(IN u32 dwHBDogHdl, IN u32 dwHBItemIdx);

//�����������Ļ�ȡ
u32 HBDog_CtxGet(IN u32 dwHBDogHdl, IN u32 dwHBItemIdx, OUT OCC *ptCtx);

/*============== �ɴ����ߵ��õĺ��� END ================*/

/*============== �ɿ��Ź���ʹ���ߵ��õĺ��� BEGIN================*/

//���������ϵͳ���õ����Ź����
u32 HBDog_Attach(IN TCommInitParam *ptCommInit, OUT u32 *pdwHBDogHdl);

//�����˳����ϵͳ
u32 HBDog_Detach(IN u32 dwHBDogHdl);

//ι��
u32 HBDog_Feed(IN u32 dwHBDogHdl);

//���Ź�����������
u32 HBDog_CtxSet(IN u32 dwHBDogHdl, IN OCC tCtx);

/*============== �ɿ��Ź���ʹ���ߵ��õĺ��� END================*/


/*============== �����ߺ�ʹ���߹������� ================*/

//��ȡ�������С
u32 HBDog_HBItemNumGet(IN u32 dwHBDogHdl, OUT u32 *pdwHBNum);

//�汾�Ż�ȡ
char* HBDogVerGet(IN OUT char *pchVerBuf, IN u32 dwBufLen);

//���������
char* HBDogErrInfoGet(IN u32 dwErrorNo, IN char *pchErrInfo, IN u32 dwInBytes);

void hbdogver(IN void* dwTelHdl);

//���Ź��������Ϣ���ɴ����ߵ���
void dogsinfo(IN void* dwTelHdl, IN u32 dwRKDogHdl);

//���Ź��ͻ�����Ϣ����ʹ���ߵ���
void dogcinfo(IN void* dwTelHdl, IN u32 dwRKDogHdl);

#ifdef __cplusplus
}
#endif

#endif // _RK_DOG_H

