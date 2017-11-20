#ifndef pduparser_H
#define pduparser_H



u32 Pack_TVSSNetAddr(IN const TVSSNetAddr *ptTVSSNetAddr, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TVSSNetAddr(IN const void *pBuf, IN u32 dwBufLen, IN OUT TVSSNetAddr *ptTVSSNetAddr );

void Print_TVSSNetAddr(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TVSSNetAddr *ptTVSSNetAddr );

u32 Pack_TJLPuDevInfo(IN const TJLPuDevInfo *ptTJLPuDevInfo, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuDevInfo(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuDevInfo *ptTJLPuDevInfo );

void Print_TJLPuDevInfo(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuDevInfo *ptTJLPuDevInfo );

u32 Pack_TJLChargeInfo(IN const TJLChargeInfo *ptTJLChargeInfo, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLChargeInfo(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLChargeInfo *ptTJLChargeInfo );

void Print_TJLChargeInfo(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLChargeInfo *ptTJLChargeInfo );

u32 Pack_TJLJpegParam(IN const TJLJpegParam *ptTJLJpegParam, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLJpegParam(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLJpegParam *ptTJLJpegParam );

void Print_TJLJpegParam(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLJpegParam *ptTJLJpegParam );

u32 Pack_TJLPuLoginAuthInfo(IN const TJLPuLoginAuthInfo *ptTJLPuLoginAuthInfo, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuLoginAuthInfo(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuLoginAuthInfo *ptTJLPuLoginAuthInfo );

void Print_TJLPuLoginAuthInfo(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuLoginAuthInfo *ptTJLPuLoginAuthInfo );

u32 Pack_TJLParamCfgData(IN const TJLParamCfgData *ptTJLParamCfgData, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLParamCfgData(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLParamCfgData *ptTJLParamCfgData );

void Print_TJLParamCfgData(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLParamCfgData *ptTJLParamCfgData );

u32 Pack_TJLPuMsgHead(IN const TJLPuMsgHead *ptTJLPuMsgHead, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuMsgHead(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuMsgHead *ptTJLPuMsgHead );

void Print_TJLPuMsgHead(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuMsgHead *ptTJLPuMsgHead );

u32 Pack_TJLPuLoginReq(IN const TJLPuLoginReq *ptTJLPuLoginReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuLoginReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuLoginReq *ptTJLPuLoginReq );

void Print_TJLPuLoginReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuLoginReq *ptTJLPuLoginReq );

u32 Pack_TJLPuLoginRsp(IN const TJLPuLoginRsp *ptTJLPuLoginRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuLoginRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuLoginRsp *ptTJLPuLoginRsp );

void Print_TJLPuLoginRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuLoginRsp *ptTJLPuLoginRsp );

u32 Pack_TJLPuLogoutReq(IN const TJLPuLogoutReq *ptTJLPuLogoutReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuLogoutReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuLogoutReq *ptTJLPuLogoutReq );

void Print_TJLPuLogoutReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuLogoutReq *ptTJLPuLogoutReq );

u32 Pack_TJLPuLogoutRsp(IN const TJLPuLogoutRsp *ptTJLPuLogoutRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuLogoutRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuLogoutRsp *ptTJLPuLogoutRsp );

void Print_TJLPuLogoutRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuLogoutRsp *ptTJLPuLogoutRsp );

u32 Pack_TJLPuRealMediaSwitchReq(IN const TJLPuRealMediaSwitchReq *ptTJLPuRealMediaSwitchReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuRealMediaSwitchReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuRealMediaSwitchReq *ptTJLPuRealMediaSwitchReq );

void Print_TJLPuRealMediaSwitchReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuRealMediaSwitchReq *ptTJLPuRealMediaSwitchReq );

u32 Pack_TJLPuRealMediaSwitchRsp(IN const TJLPuRealMediaSwitchRsp *ptTJLPuRealMediaSwitchRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuRealMediaSwitchRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuRealMediaSwitchRsp *ptTJLPuRealMediaSwitchRsp );

void Print_TJLPuRealMediaSwitchRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuRealMediaSwitchRsp *ptTJLPuRealMediaSwitchRsp );

u32 Pack_TJLPuRealMediaStopCmd(IN const TJLPuRealMediaStopCmd *ptTJLPuRealMediaStopCmd, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuRealMediaStopCmd(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuRealMediaStopCmd *ptTJLPuRealMediaStopCmd );

void Print_TJLPuRealMediaStopCmd(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuRealMediaStopCmd *ptTJLPuRealMediaStopCmd );

u32 Pack_TJLPuSnapPicReq(IN const TJLPuSnapPicReq *ptTJLPuSnapPicReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuSnapPicReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuSnapPicReq *ptTJLPuSnapPicReq );

void Print_TJLPuSnapPicReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuSnapPicReq *ptTJLPuSnapPicReq );

u32 Pack_TJLPuSnapPicRsp(IN const TJLPuSnapPicRsp *ptTJLPuSnapPicRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuSnapPicRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuSnapPicRsp *ptTJLPuSnapPicRsp );

void Print_TJLPuSnapPicRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuSnapPicRsp *ptTJLPuSnapPicRsp );

u32 Pack_TJLParamCfgReq(IN const TJLParamCfgReq *ptTJLParamCfgReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLParamCfgReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLParamCfgReq *ptTJLParamCfgReq );

void Print_TJLParamCfgReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLParamCfgReq *ptTJLParamCfgReq );

u32 Pack_TJLParamCfgRsp(IN const TJLParamCfgRsp *ptTJLParamCfgRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLParamCfgRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLParamCfgRsp *ptTJLParamCfgRsp );

void Print_TJLParamCfgRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLParamCfgRsp *ptTJLParamCfgRsp );

u32 Pack_TJLParamMdfNtf(IN const TJLParamMdfNtf *ptTJLParamMdfNtf, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLParamMdfNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLParamMdfNtf *ptTJLParamMdfNtf );

void Print_TJLParamMdfNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLParamMdfNtf *ptTJLParamMdfNtf );

u32 Pack_TJPuReportRuleReq(IN const TJPuReportRuleReq *ptTJPuReportRuleReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuReportRuleReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuReportRuleReq *ptTJPuReportRuleReq );

void Print_TJPuReportRuleReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuReportRuleReq *ptTJPuReportRuleReq );

u32 Pack_TJPuReportRuleRsp(IN const TJPuReportRuleRsp *ptTJPuReportRuleRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuReportRuleRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuReportRuleRsp *ptTJPuReportRuleRsp );

void Print_TJPuReportRuleRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuReportRuleRsp *ptTJPuReportRuleRsp );

u32 Pack_TJLPuChargeCallReq(IN const TJLPuChargeCallReq *ptTJLPuChargeCallReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuChargeCallReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuChargeCallReq *ptTJLPuChargeCallReq );

void Print_TJLPuChargeCallReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuChargeCallReq *ptTJLPuChargeCallReq );

u32 Pack_TJLPuChargeCallRsp(IN const TJLPuChargeCallRsp *ptTJLPuChargeCallRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuChargeCallRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuChargeCallRsp *ptTJLPuChargeCallRsp );

void Print_TJLPuChargeCallRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuChargeCallRsp *ptTJLPuChargeCallRsp );

u32 Pack_TJLPuChargeCallRsp2(IN const TJLPuChargeCallRsp2 *ptTJLPuChargeCallRsp2, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuChargeCallRsp2(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuChargeCallRsp2 *ptTJLPuChargeCallRsp2 );

void Print_TJLPuChargeCallRsp2(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuChargeCallRsp2 *ptTJLPuChargeCallRsp2 );

u32 Pack_TJLPuChargeBreakNtf(IN const TJLPuChargeBreakNtf *ptTJLPuChargeBreakNtf, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuChargeBreakNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuChargeBreakNtf *ptTJLPuChargeBreakNtf );

void Print_TJLPuChargeBreakNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuChargeBreakNtf *ptTJLPuChargeBreakNtf );

u32 Pack_TJLPuChargeCompleteNtf(IN const TJLPuChargeCompleteNtf *ptTJLPuChargeCompleteNtf, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLPuChargeCompleteNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuChargeCompleteNtf *ptTJLPuChargeCompleteNtf );

void Print_TJLPuChargeCompleteNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuChargeCompleteNtf *ptTJLPuChargeCompleteNtf );

//added by fzp
u32 Pack_TJLCallQueueCntNtf(IN const TJLCallQueueCntNtf *ptTJLCallQueueCntNtf, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLCallQueueCntNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLCallQueueCntNtf *ptTJLCallQueueCntNtf );

void Print_TJLCallQueueCntNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLCallQueueCntNtf *ptTJLCallQueueCntNtf );

u32 Pack_TJLChargeCallCancelNtf(IN const TJLChargeCallCancelNtf *ptTJLChargeCallCancelNtf, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLChargeCallCancelNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLChargeCallCancelNtf *ptTJLChargeCallCancelNtf );

void Print_TJLChargeCallCancelNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLChargeCallCancelNtf *ptTJLChargeCallCancelNtf );
//end

// Back call added by fzp
u32 Pack_TJLBackCallreq(IN const TJLBackCallreq *ptTJLBackCallreq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLBackCallreq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLBackCallreq *ptTJLBackCallreq);

void Print_TJLBackCallreq(IN void* dwTelHdl, IN OCC tOccName, IN const char* parentName, IN const TJLBackCallreq *ptTJLBackCallreq);

u32 Pack_TJLBackCallConfirmRsp(IN const TJLBackCallConfirmRsp *ptTJLBackCallConfirmRsp, IN u32 dwBufLen, IN OUT void* pBuf);

u32 UnPack_TJLBackCallConfirmRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLBackCallConfirmRsp *ptTJLBackCallConfirmRsp);

void Print_TJLBackCallConfirmRsp(IN void* dwTelHdl, IN OCC tOccName, IN const char* parentName, IN const TJLBackCallConfirmRsp *ptTJLBackCallConfirmRsp);

u32 Pack_TJLBackCallrsp(IN const TJLBackCallrsp *ptTJLBackCallrsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLBackCallrsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLBackCallrsp *ptTJLBackCallrsp );

void Print_TJLBackCallrsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLBackCallrsp *ptTJLBackCallrsp );

u32 Pack_TJLBackCallCancelReq(IN const TJLBackCallCancelReq *ptTJLBackCallCancelReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLBackCallCancelReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLBackCallCancelReq *ptTJLBackCallCancelReq );

void Print_TJLBackCallCancelReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLBackCallCancelReq *ptTJLBackCallCancelReq );

u32 Pack_TJLBackCallCancelRsp(IN const TJLBackCallCancelRsp *ptTJLBackCallCancelRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJLBackCallCancelRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLBackCallCancelRsp *ptTJLBackCallCancelRsp );

void Print_TJLBackCallCancelRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLBackCallCancelRsp *ptTJLBackCallCancelRsp );
// end

u32 Pack_TJPuAuthSnap(IN const TJPuAuthSnap *ptTJPuAuthSnap, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuAuthSnap(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuAuthSnap *ptTJPuAuthSnap );

void Print_TJPuAuthSnap(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuAuthSnap *ptTJPuAuthSnap );

u32 Pack_TJPuAuthSnapRsp(IN const TJPuAuthSnapRsp *ptTJPuAuthSnapRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuAuthSnapRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuAuthSnapRsp *ptTJPuAuthSnapRsp );

void Print_TJPuAuthSnapRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuAuthSnapRsp *ptTJPuAuthSnapRsp );

u32 Pack_TJPuAuthSnapCancel(IN const TJPuAuthSnapCancel *ptTJPuAuthSnapCancel, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuAuthSnapCancel(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuAuthSnapCancel *ptTJPuAuthSnapCancel );

void Print_TJPuAuthSnapCancel(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuAuthSnapCancel *ptTJPuAuthSnapCancel );

u32 Pack_TJPuAuthSnapCancelRsp(IN const TJPuAuthSnapCancelRsp *ptTJPuAuthSnapCancelRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuAuthSnapCancelRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuAuthSnapCancelRsp *ptTJPuAuthSnapCancelRsp );

void Print_TJPuAuthSnapCancelRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuAuthSnapCancelRsp *ptTJPuAuthSnapCancelRsp );

u32 Pack_TJPuSendPictureNtf(IN const TJPuSendPictureNtf *ptTJPuSendPictureNtf, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuSendPictureNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuSendPictureNtf *ptTJPuSendPictureNtf );

void Print_TJPuSendPictureNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuSendPictureNtf *ptTJPuSendPictureNtf );

u32 Pack_TJPuDeviceInfoNtf(IN const TJPuDeviceInfoNtf *ptTJPuDeviceInfoNtf, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuDeviceInfoNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuDeviceInfoNtf *ptTJPuDeviceInfoNtf );

void Print_TJPuDeviceInfoNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuDeviceInfoNtf *ptTJPuDeviceInfoNtf );

u32 Pack_TJPuLensCtrlReq(IN const TJPuLensCtrlReq *ptTJPuLensCtrlReq, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuLensCtrlReq(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuLensCtrlReq *ptTJPuLensCtrlReq );

void Print_TJPuLensCtrlReq(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuLensCtrlReq *ptTJPuLensCtrlReq );

u32 Pack_TJPuLensCtrlRsp(IN const TJPuLensCtrlRsp *ptTJPuLensCtrlRsp, IN u32 dwBufLen, IN OUT void* pBuf );

u32 UnPack_TJPuLensCtrlRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuLensCtrlRsp *ptTJPuLensCtrlRsp );

void Print_TJPuLensCtrlRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuLensCtrlRsp *ptTJPuLensCtrlRsp );

// add by zlz -->>
u32 Pack_TJPuDeviceGpsNtf(IN const TJPuDeviceGpsNtf *ptTJPuDeviceGpsNtf, IN u32 dwBufLen, IN OUT void* pBuf );
u32 UnPack_TJPuDeviceGpsNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuDeviceGpsNtf *ptTJPuDeviceGpsNtf );
void Print_TJPuDeviceGpsNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuDeviceGpsNtf *ptTJPuDeviceGpsNtf);

u32 Pack_TJPuDeviceNetNtf(IN const TJPuDeviceNetNtf *ptTJPuDeviceNetNtf, IN u32 dwBufLen, IN OUT void* pBuf );
u32 UnPack_TJPuDeviceNetNtf(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuDeviceNetNtf *ptTJPuDeviceNetNtf );
void Print_TJPuDeviceNetNtf(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuDeviceNetNtf *ptTJPuDeviceNetNtf);

u32 Pack_TJPuOnlineAction(IN const TJPuOnlineAction *ptTJPuOnlineAction, IN u32 dwBufLen, IN OUT void* pBuf);
u32 UnPack_TJPuOnlineAction(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuOnlineAction *ptTJPuOnlineAction);
void Print_TJPuOnlineAction(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuOnlineAction *ptTJPuOnlineAction);

u32 Pack_TJLPuChargeChangeRsp(IN const TJLPuChargeChangeRsp *ptTJLPuChargeChangeRsp, IN u32 dwBufLen, IN OUT void* pBuf );
u32 UnPack_TJLPuChargeChangeRsp(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJLPuChargeChangeRsp *ptTJLPuChargeChangeRsp );
void Print_TJLPuChargeChangeRsp(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJLPuChargeChangeRsp *ptTJLPuChargeChangeRsp );
//add by zlz <<--

//shm add begin for transparent channel test.
u32 Pack_TJPuTransparentChnl(IN const TJPuTransparentChnl *ptTJPuTransparentChnl, IN u32 dwBufLen, IN OUT void* pBuf );
u32 UnPack_TJPuTransparentChnl(IN const void *pBuf, IN u32 dwBufLen, IN OUT TJPuTransparentChnl *ptTJPuTransparentChnl );
void Print_TJPuTransparentChnl(IN void* dwTelHdl, IN OCC tOccName,  IN const char* parentName, IN const TJPuTransparentChnl *ptTJPuTransparentChnl );
//shm add end for transparent channel test.

#endif /*pduparser_H*/
