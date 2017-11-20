//
//  Macros.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/12.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#ifdef __OBJC__

#endif


/**
 屏幕宽度和高度
 */
#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HIGHT            ([UIScreen mainScreen].bounds.size.height)

#define KWINOW              [UIApplication sharedApplication].keyWindow
#define KSHWOMSG(string)    [KWINOW makeToast:string duration:1 position:CSToastPositionCenter];

#pragma mark - 文件
//NSUserDefaults
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//获取本地文件
#define LOAD_IMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

/**
 设置信息
 */
#pragma mark - Setting

//当前系统设置国家的country iso code
#define countryISO  [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode]
//当前系统设置语言的iso code
#define languageISO [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]
//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


//plist文件内容
#pragma mark  - 版本信息

#define InfoPlistDic                [[NSBundle mainBundle] infoDictionary]
#define ReadInfoPlistDic(_name)     [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)_name] //获取infoPlist文件中的 属性

//!< app版本
#define AppVersion                  [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]
//!< app build 版本
#define AppBuildVersion             ReadInfoPlistDic(kCFBundleVersionKey)      //APP 版本

#define AppBundleIdentifier         ReadInfoPlistDic(kCFBundleIdentifierKey)   //

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[[NSDate date] timeIntervalSinceNow])



/*
 各版本尺寸
 1 iPhone4      640*960   320*480 2倍
 2 iPhone4S     640*960   320*480 2倍
 3 iPhone5      640*1136  320*568 2倍
 4 iPhone5S     640*1136  320*568 2倍
 5 iPhone5C     640*1136  320*568 2倍 H/W:1.775
 6 iPhone6      750*1334  375*667 2倍 H/W:1.778
 7 iPhone6 Plus 1242*2208 414*736 3倍 H/W:1.777
 
 各版本比例
 iPhone5，    autoSizeScaleX=1，autoSizeScaleY=1；
 iPhone6，    autoSizeScaleX=1.171875，autoSizeScaleY=1.17429577；
 iPhone6Plus，autoSizeScaleX=1.29375， autoSizeScaleY=1.295774；
 */

////////////////////////////////////////////////////////////////////////////////////

#define AutoSizeScreenWidth_AutoSize  ([[UIScreen mainScreen] bounds].size.width)
#define AutoSizeScreenHeight_AutoSize ([[UIScreen mainScreen] bounds].size.height)

#define AutoSizeScaleX_AutoSize ((AutoSizeScreenHeight_AutoSize > 480.0) ? (AutoSizeScreenWidth_AutoSize / 320.0) : 1.0)
#define AutoSizeScaleY_AutoSize ((AutoSizeScreenHeight_AutoSize > 480.0) ? (AutoSizeScreenHeight_AutoSize / 568.0) : 1.0)

#define X(a)                      CGRectGetMinX(a.frame)         //控件左边面的X坐标
#define NW(a)                     CGRectGetMaxX(a.frame)         //控件右面的X坐标
#define Y(a)                      CGRectGetMinY(a.frame)         //控件上面的Y坐标
#define NH(a)                     CGRectGetMaxY(a.frame)         //控件下面的Y坐标

#define HEIGHT(a)                 CGRectGetHeight(a.frame)       //控件的高度
#define WIDTH(a)                  CGRectGetWidth(a.frame)        //控件的宽度


////////////////////////////////////////////////////////////////////////////////////

CG_INLINE CGFloat
AutoCGRectGetMinX(CGRect rect)
{
    CGFloat x = rect.origin.x * AutoSizeScaleX_AutoSize;
    return x;
}

CG_INLINE CGFloat
AutoCGRectGetMinY(CGRect rect)
{
    CGFloat y = rect.origin.y * AutoSizeScaleX_AutoSize;
    return y;
}

CG_INLINE CGFloat
AutoCGRectGetWidth(CGRect rect)
{
    CGFloat width = rect.size.width * AutoSizeScaleX_AutoSize;
    return width;
}

CG_INLINE CGFloat
AutoCGRectGetHeight(CGRect rect)
{
    CGFloat height = rect.size.height * AutoSizeScaleX_AutoSize;
    return height;
}

CG_INLINE CGPoint
AutoCGPointMake(CGFloat x, CGFloat y)
{
    CGPoint point;
    point.x = x * AutoSizeScaleX_AutoSize;
    point.y = y * AutoSizeScaleY_AutoSize;
    
    return point;
}

CG_INLINE CGSize
AutoCGSizeMake(CGFloat width, CGFloat height)
{
    CGSize size;
    size.width = width * AutoSizeScaleX_AutoSize;
    size.height = height * AutoSizeScaleY_AutoSize;
    
    return size;
}


CG_INLINE CGRect
AutoCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * AutoSizeScaleX_AutoSize;
    rect.origin.y = y * AutoSizeScaleY_AutoSize;
    rect.size.width = width * AutoSizeScaleX_AutoSize;
    rect.size.height = height * AutoSizeScaleY_AutoSize;
    return rect;
}


CG_INLINE UIEdgeInsets
AutoEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    UIEdgeInsets inset;
    inset.top = top * AutoSizeScaleX_AutoSize;
    inset.left = left * AutoSizeScaleY_AutoSize;
    inset.bottom = bottom * AutoSizeScaleX_AutoSize;
    inset.right  = right * AutoSizeScaleY_AutoSize;
    return inset;
}

////////////////////////////////////////////////////////////////////////////////////

CG_INLINE CGRect
AutoWHCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height, BOOL autoW, BOOL autoH)
{
    CGRect rect;
    rect.origin.x = x;
    rect.origin.y = y;
    rect.size.width = (autoW ? (width * AutoSizeScaleX_AutoSize) : width);
    rect.size.height = (autoH ? (height * AutoSizeScaleY_AutoSize) : height);
    
    return rect;
}

CG_INLINE CGFloat
AutoWHGetHeight(CGFloat height)
{
    CGFloat autoHeight = height * AutoSizeScaleY_AutoSize;
    return autoHeight;
}

CG_INLINE CGFloat
AutoWHGetWidth(CGFloat width)
{
    CGFloat autoWidth = width * AutoSizeScaleX_AutoSize;
    return autoWidth;
}


/*
 ----以UI宽度为375时的比例调整
 */
CG_INLINE CGFloat
WRatioGetWidth(CGFloat width)
{
    CGFloat ratioSise = 0.00;
    if (AutoSizeScreenHeight_AutoSize < 736) {
        ratioSise = 1.0;
    } else {
        ratioSise = AutoSizeScreenWidth_AutoSize / 375.0;
    }
    CGFloat autoWidth = width *ratioSise;
    return autoWidth;
}

CG_INLINE CGFloat
WRatioGetHeight(CGFloat height)
{
    CGFloat ratioSise = 0.00;
    if (AutoSizeScreenHeight_AutoSize < 736) {
        ratioSise = 1.0;
    } else {
        ratioSise = AutoSizeScreenHeight_AutoSize / 667.0;
    }
    CGFloat autoHeight = height *ratioSise;
    return autoHeight;
}

////////////////////////////////////////////////////////////////////////////////////






//
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#pragma mark 大小-体

/// 10号字体
#define kSize10 AutoWHGetWidth(10.0)

/// 11号字体
#define kSize11 iPhone6P?13.0:11.0

/// 12号字体
#define kSize12 iPhone6P?14.0:12.0

/// 13号字体
#define kSize13 iPhone6P?15.0:13.0

/// 14号字体
#define kSize14 iPhone6P?16.0:14.0

/// 15号字体
#define kSize15 iPhone6P?17.0:15.0

/// 16号字体
#define kSize16 iPhone6P?18.0:16.0

/// 17号字体
#define kSize17 iPhone6P?19.0:17.0

/// 18号字体
#define kSize18 iPhone6P?20.0:18.0

/// 20号字体
#define kSize20 iPhone6P?22.0:20.0

/// 21号字体
#define kSize21 iPhone6P?23.0:21.0
/// 22号字体
#define kSize22 iPhone6P?24.0:22.0
/// 22号字体
#define kSize23 iPhone6P?25.0:23.0
/// 26号字体
#define kSize26 iPhone6P?28.0:26.0
/// 36号字体
#define kSize36 iPhone6P?38.0:36.0

// 字体适配
#pragma mark 大小-细体

/// 11号字体
#define kFontSize10 [UIFont systemFontOfSize:iPhone6P?12.0:10.0]
/// 11号字体
#define kFontSize11 [UIFont systemFontOfSize:iPhone6P?13.0:11.0]

/// 12号字体
#define kFontSize12 [UIFont systemFontOfSize:iPhone6P?14.0:12.0]

/// 13号字体
#define kFontSize13 [UIFont systemFontOfSize:iPhone6P?15.0:13.0]

/// 14号字体
#define kFontSize14 [UIFont systemFontOfSize:iPhone6P?16.0:14.0]

/// 15号字体
#define kFontSize15 [UIFont systemFontOfSize:iPhone6P?17.0:15.0]

/// 16号字体
#define kFontSize16 [UIFont systemFontOfSize:iPhone6P?18.0:16.0]

/// 17号字体
#define kFontSize17 [UIFont systemFontOfSize:iPhone6P?19.0:17.0]

/// 18号字体
#define kFontSize18 [UIFont systemFontOfSize:iPhone6P?20.0:18.0]

/// 19号字体
#define kFontSize19 [UIFont systemFontOfSize:iPhone6P?21.0:19.0]

/// 20号字体
#define kFontSize20 [UIFont systemFontOfSize:iPhone6P?22.0:20.0]

/// 21号字体
#define kFontSize21 [UIFont systemFontOfSize:iPhone6P?23.0:21.0]

/// 22号字体
#define kFontSize22 [UIFont systemFontOfSize:iPhone6P?24.0:22.0]

/// 23号字体
#define kFontSize23 [UIFont systemFontOfSize:iPhone6P?25.0:23.0]

/// 24号字体
#define kFontSize24 [UIFont systemFontOfSize:iPhone6P?26.0:24.0]

/// 25号字体
#define kFontSize25 [UIFont systemFontOfSize:iPhone6P?27.0:25.0]
/// 30号字体
#define kFontSize30 [UIFont systemFontOfSize:iPhone6P?32.0:30.0]

/// 30号字体
#define kFontSize50 [UIFont systemFontOfSize:iPhone6P?52.0:50.0]

#pragma mark 大小-粗体

/// 10号粗字体
#define kFontSizeBold10 [UIFont boldSystemFontOfSize:AutoWHGetWidth(10.0)]

/// 11号粗字体
#define kFontSizeBold11 [UIFont boldSystemFontOfSize:AutoWHGetWidth(11.0)]

/// 12号粗字体
#define kFontSizeBold12 [UIFont boldSystemFontOfSize:AutoWHGetWidth(12.0)]

/// 13号粗字体
#define kFontSizeBold13 [UIFont boldSystemFontOfSize:AutoWHGetWidth(13.0)]

/// 14号粗字体
#define kFontSizeBold14 [UIFont boldSystemFontOfSize:AutoWHGetWidth(14.0)]

/// 15号粗字体
#define kFontSizeBold15 [UIFont boldSystemFontOfSize:AutoWHGetWidth(15.0)]

/// 16号粗字体
#define kFontSizeBold16 [UIFont boldSystemFontOfSize:AutoWHGetWidth(16.0)]

/// 17号粗字体
#define kFontSizeBold17 [UIFont boldSystemFontOfSize:AutoWHGetWidth(17.0)]

/// 18号粗字体
#define kFontSizeBold18 [UIFont boldSystemFontOfSize:AutoWHGetWidth(18.0)]

/// 20号字粗体
#define kFontSizeBold20 [UIFont boldSystemFontOfSize:AutoWHGetWidth(20.0)]

/// 21号字粗体
#define kFontSizeBold21 [UIFont boldSystemFontOfSize:AutoWHGetWidth(21.0)]

/// 35号字粗体
#define kFontSizeBold35 [UIFont boldSystemFontOfSize:AutoWHGetWidth(35.0)]



#endif /* Macros_h */
