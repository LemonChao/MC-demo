#if defined(_LINUX_) || defined(__ANDROID__)

#elif defined(__APPLE__)
int Speex_open(int compression);
int Speex_encode(short* in_buf, int in_len, char* out_buf, int* out_size);
/**
 * decode_frame  输入音频数据
 *  out_buf 输出数据
 */

/**
 Speex 解码成 pcm
 
 @param encoded 输入音频数据
 @param out     输出音频数据
 @param size    解码长度
 
 @return
 */
int Speex_decode(char* encoded, short* out, int size);
int  Speex_getFrameSize();

/**
 Speex 库关闭
 */
void Speex_close();
int  Speex_setMicWaveScale(int scale);
int  Speex_setSpeakerWaveScale(int scale);
int  Speex_setMicAgcMaxGain(int gain);
int  Speex_setSpeakerAgcMaxGain(int gain);
int  Speex_setMicAgcLevel(int level);
int  Speex_setSpeakerAgcLevel(int level);
int  Speex_setMicNoiseSuppress(int level);
#endif
