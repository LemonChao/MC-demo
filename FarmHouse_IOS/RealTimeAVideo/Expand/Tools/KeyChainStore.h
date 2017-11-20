//
//  KeyChainStore.h
//  KeyUUID
//
//  Created by Lemon on 16/9/5.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;


@end
