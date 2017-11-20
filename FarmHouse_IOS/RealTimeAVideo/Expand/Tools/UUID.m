//
//  UUID.m
//  KeyUUID
//
//  Created by Lemon on 16/9/5.
//  Copyright © 2016年 Lemon. All rights reserved.
//

/// 使用keychain存储可以保证程序卸载重装时，UUID不变。但当刷机或者升级系统后，UUID还是会改变的。

/// 博客地址：http://blog.sina.com.cn/s/blog_5971cdd00102vqgy.html


#import "UUID.h"
#import "KeyChainStore.h"

@implementation UUID

+ (NSString *)getUUID

{
    
    NSString * strUUID = (NSString *)[KeyChainStore load:@"com.company.app.usernamepassword"];
    
    
    
    //首次执行该方法时，uuid为空
    
    if ([strUUID isEqualToString:@""] || !strUUID)
        
    {
        
        //生成一个uuid的方法        
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
        
        
    }
    
    return strUUID;
    
}


/** 获取设备号 6位非0数字 */
+ (NSString *)getDeviceNum
{
    
    NSString *str = [UUID getUUID];
    
    // Create character set with specified characters
    NSMutableCharacterSet *characterSet =
    [NSMutableCharacterSet characterSetWithCharactersInString:@"0-"];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [str componentsSeparatedByCharactersInSet:characterSet];
    
    // Create string from the array components
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    strOutput = [strOutput substringToIndex:6];
    DLog(@"strOutPut=%@", strOutput);
    
    return strOutput;

}

/**
 *  1.字母先转数字
 *  2.去除 -
 *  3.截取非0 6位
 */
/** NOT USE */
- (void)convertIntWithDeviceid:(NSString *)deviceid
{
    
    
    switch (1) {
        case 'A':
        {
           deviceid = [deviceid stringByReplacingOccurrencesOfString:@"A" withString:@"0"];
        }
            break;
            
        case 'B':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"B" withString:@"1"];
        }
            break;
            
        case 'C':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"C" withString:@"2"];
        }
            break;
            
        case 'D':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"D" withString:@"3"];
        }
            break;
            
        case 'E':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"E" withString:@"4"];
        }
            break;
            
        case 'F':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"F" withString:@"5"];
        }
            break;
            
        case 'a':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"a" withString:@"0"];
        }
            break;
            
        case 'b':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"b" withString:@"1"];
        }
            break;
            
        case 'c':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"c" withString:@"2"];
        }
            break;
            
        case 'd':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"d" withString:@"3"];
        }
            break;
            
        case 'e':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"e" withString:@"4"];
        }
            break;
            
        case 'f':
        {
            deviceid = [deviceid stringByReplacingOccurrencesOfString:@"f" withString:@"5"];
        }
            break;
            

        default:
            break;
    }
    
}

@end
