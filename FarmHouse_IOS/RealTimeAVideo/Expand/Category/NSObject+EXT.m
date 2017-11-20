//
//  NSObject+EXT.m
//  ZXNews
//
//  Created by HHL on 16/4/15.
//  Copyright © 2016年 LXH. All rights reserved.
//

#import "NSObject+EXT.h"
#import <sys/utsname.h>
@implementation NSObject (EXT)

-(NSString *)ai_version{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
-(NSInteger)ai_build{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [app_build integerValue];
}
-(NSString *)ai_identifier{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return bundleIdentifier;
}
-(NSString *)ai_currentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages firstObject];
    return [NSString stringWithString:currentLanguage];
}
-(NSString *)ai_deviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return [NSString stringWithString:deviceString];
}
#pragma mark 创建时间
-(NSString*)dataWithFormat:(NSString*)format{
    NSDateFormatter *dateFormateter = [[NSDateFormatter alloc] init];
    [dateFormateter setDateFormat:format];
    NSString *dataString = [dateFormateter stringFromDate:[NSDate date]];
    return dataString;
}

void arrayCopy(const void *src, int srcPos, void *dst, int destPos, size_t length)
{
    //检查源数组和目的数组不为空
//    if (src == NULL || dst == NULL) {
//        printf("we have null pointers\n");
//        return;
//    }
    
    //Do copy
    memcpy(dst + destPos, src + srcPos, length);
    
}

@end
