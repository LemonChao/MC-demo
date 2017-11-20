#ifndef _LOG_H_
#define _LOG_H_

#ifdef __cplusplus
extern "C" {
#endif

#define JL_LOG_INFO		0
#define JL_LOG_WARNING	1
#define JL_LOG_ERROR	2

void myLog(int levels, char *tag, const char *fmt, ...);

#ifdef __cplusplus
}
#endif

#endif