//
//  NSString+Extension.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/25.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


- (NSString *)uploadPicName:(NSString *)deviceNum{
    //992+时间+设备号+检验位
    NSString *name = [NSString stringWithFormat:@"992%@%@", self, deviceNum];
    NSString *temp;
    int count = 0;
    for (int i = 0; i < name.length; i++) {
        temp = [name substringWithRange:NSMakeRange(i, 1)];
        
        count = [temp intValue] + count;
        
        printf("%d:   %d\n",[temp intValue], count);
    }
    
    return [name stringByAppendingString:[NSString stringWithFormat:@"%d", count % 10]];

}

- (BOOL)realStr {
    NSString *trueStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (trueStr == nil || trueStr.length == 0) return NO;
    return YES;
}

- (BOOL)trueStr {
    NSString *trueStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trueStr == nil || trueStr.length == 0) return NO;
    return YES;

    
    
}

@end
