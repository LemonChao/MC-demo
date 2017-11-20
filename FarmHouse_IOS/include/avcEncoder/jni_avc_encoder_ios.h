int yv12zoom(char* in_buf, int in_width, int in_height,char* out_buf,int out_width,int out_height);
void YV12toYUV420PS(char* in_buf, char* out_buf, int width, int height, int planar);
void setKeyFrmFlag(char* in_buf, int h264FrmLen, int headlen, int* key_flag, int planar);
void setKeyFrm(char* in_buf);
