//
//  NSString+md5String.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/11/19.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "NSString+md5String.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5String)

+ ( NSString *)md5String:( NSString *)str

{
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    return md5String;
    
}

/** md5 NB 加密 */

+ ( NSString *)md5StringNB:( NSString *)str

{
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    [md5String appendFormat : @"%02x" ,mdc[ 0 ]];
    
    for ( int i = 1 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]^mdc[ 0 ]];
        
    }
    
    return md5String;
    
}

+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}


@end
