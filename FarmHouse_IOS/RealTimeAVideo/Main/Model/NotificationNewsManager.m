//
//  NotificationNewsManager.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/18.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//
#import "NotificationNewsManager.h"

@implementation NotificationNewsManager
{
    NSTimer *timer;
}


static NSString *maxNewsid;

+ (void)initialize {
    maxNewsid = UDSobjectForKey(@"maxNewsid") ? UDSobjectForKey(@"maxNewsid") : @"0";
//    maxNewsid = @"0";
}


- (void)createForNotificationNewsTimer {
    
    timer = [NSTimer timerWithTimeInterval:10.0
                                    target:self
                                  selector:@selector(getNotificationNews)
                                  userInfo:nil
                                   repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}


- (void)getNotificationNews {
    //1.检查是否登陆
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN];
    if (!result) return;
    [self requestForNotificationNews];
}

- (void)requestForNotificationNews {

    NSDictionary *sendDic = @{@"flag":@"searchaccpush",
                              @"userid":UDSobjectForKey(USERID)?UDSobjectForKey(USERID):@"",
                              @"power":@"1",
                              @"id":maxNewsid};
    
    [LCAFNetWork POST:@"collect" params:sendDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[STATE] intValue]) {
            
            maxNewsid = responseObject[MESSAGE];
            [[NSUserDefaults standardUserDefaults] setObject:maxNewsid forKey:@"maxNewsid"];
            [self convertIntoModel:responseObject];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", [error localizedDescription]);
    }];

    
}

- (void)convertIntoModel:(id)reponse {
//   需要手动先创建实例，再进行字典转模型，且不能处理容器属性


    for (NSDictionary *dic in reponse[DATA]) {
        
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            NotificationNews *news = [NotificationNews MR_findFirstByAttribute:@"newsid" withValue:[dic objectForKey:@"id"] inContext:localContext];
            
            if (!news) {
                news = [NotificationNews MR_createEntityInContext:localContext];
            }
            
            [news yy_modelSetWithDictionary:dic];
            news.isRead = NO;
            NSLog(@"----%@",news);
            
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            DLog(@"Save data into DB succeeded!");

            //post notification to MainVC
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedFreshNotificationNews" object:nil];
            
        }];
        
    }
    
}

- (void)readAllNotificationNews {
    NSArray *news = [NotificationNews MR_findAll];
    for (NotificationNews *non in news) {
        
        DLog(@"news count %@", non.newsid);
    }
}

- (void)deleteNotificationNews:(NotificationNews *)notifNews {
    
}


- (void)deleteAll {
    
}

@end
