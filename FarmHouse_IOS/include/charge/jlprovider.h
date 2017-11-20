#ifndef JLPROVIDER_F285CE66_2D7D_40BE_AF3A_E523BC6C7D9E
#define JLPROVIDER_F285CE66_2D7D_40BE_AF3A_E523BC6C7D9E

#if defined(_LINUX_) || defined(__ANDROID__)
#include "jlprovider_anddroid.h"
#elif defined(__APPLE__)
#include "jlprovider_ios.h"
#endif

#endif
