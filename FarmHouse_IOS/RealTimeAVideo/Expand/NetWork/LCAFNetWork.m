//
//  LCAFNetWork.m
//  LCAFNETWORKING
//
//  Created by Lemon on 16/11/15.
//  Copyright © 2016年 LemonChao. All rights reserved.
//


#import "LCAFNetWork.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "PPNetworkCache.h"
#import "RSAEncryptor.h" //RSA 只加密user接口
#import "NSString+md5String.h"

@implementation LCAFNetWork

+(void)GET:(NSString *)url params:(NSDictionary *)params
   success:(LCResponseSuccess)success fail:(LCResponseFail)fail{
    
    AFHTTPSessionManager *manager = [LCAFNetWork managerWithBaseURL:nil sessionConfiguration:NO];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id dic = [LCAFNetWork responseConfiguration:responseObject error:&error];
        if (error) {
            DLog(@"Serialization Error:%@", [error localizedDescription]);
            return;
        }
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

+(void)GET:(NSString *)url baseURL:(NSString *)baseUrl params:(NSDictionary *)params
   success:(LCResponseSuccess)success fail:(LCResponseFail)fail{
    
    AFHTTPSessionManager *manager = [LCAFNetWork managerWithBaseURL:baseUrl sessionConfiguration:NO];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id dic = [LCAFNetWork responseConfiguration:responseObject error:&error];
        if (error) {
            DLog(@"Serialization Error:%@", [error localizedDescription]);
            return;
        }
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

static  int RSA_MAX_BYTES = 100;


/// 获取公钥
+ (NSString *)getPublicKey {
    
    NSString *version = AppBuildVersion;
    
    int v = ([version intValue]% 499);
    int index = (491*(v^2) + 487*v + 1315423911) % 500;

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"publicKeys" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];

    return [NSString stringWithString:array[index]];
}


+(void)POST:(NSString *)url params:(NSDictionary *)params
    success:(LCResponseSuccess)success fail:(LCResponseFail)fail{
    
    NSMutableDictionary *mParams = params.mutableCopy;
    
    if ([url isEqualToString:@"user"]) {
        
        //1.遍历map
        __block NSString *paramUrlStr = @"";
        [mParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            paramUrlStr = [NSString stringWithFormat:@"%@%@=%@&", paramUrlStr, key, obj];
        }];
        
        unsigned long length = [paramUrlStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        Byte paramUrl[length];
        strcpy((char *)paramUrl, paramUrlStr.UTF8String);
        
        //param分段（最多3段)
        Byte *input1 = NULL;
        Byte *input2 = NULL;
        Byte *other = NULL;
        NSString *md5factor = [NSString string];
        NSString *publickKey = [self getPublicKey];
        if (length < RSA_MAX_BYTES) {
            input1 = malloc(length);
            memcpy(input1, paramUrl, length);
        }
        else if (length < 2*RSA_MAX_BYTES) {
            input1 = malloc(RSA_MAX_BYTES);
            input2 = malloc(length - RSA_MAX_BYTES);
            memcpy(input1, paramUrl, RSA_MAX_BYTES);
            memcpy(input2, paramUrl+RSA_MAX_BYTES, length-RSA_MAX_BYTES);
        }
        else if (length < 3*RSA_MAX_BYTES) {
            input1 = malloc(RSA_MAX_BYTES);
            input2 = malloc(RSA_MAX_BYTES);
            other = malloc(length-2*RSA_MAX_BYTES);
            memcpy(input1, paramUrl, RSA_MAX_BYTES);
            memcpy(input2, paramUrl+RSA_MAX_BYTES, RSA_MAX_BYTES);
            memcpy(other, paramUrl+2*RSA_MAX_BYTES, length-2*RSA_MAX_BYTES);
        }
        
        
        [mParams removeAllObjects];
        
        if (input1 != NULL) {
            NSString *encodeStr =  [RSAEncryptor encryptString:[[NSString alloc] initWithBytes:input1 length:strlen((char *)input1) encoding:NSUTF8StringEncoding] publicKey:publickKey];
            [mParams setObject:encodeStr forKey:@"data"];
            md5factor = [md5factor stringByAppendingString:encodeStr];
            free(input1);
        }
        if (input2 != NULL) {
            NSString *encodeStr2 =  [RSAEncryptor encryptString:[[NSString alloc] initWithBytes:input2 length:strlen((char *)input2) encoding:NSUTF8StringEncoding] publicKey:publickKey];
            [mParams setObject:encodeStr2 forKey:@"data2"];
            md5factor = [md5factor stringByAppendingString:encodeStr2];
            free(input2);
        }
        if (other != NULL) {
            NSString *encodeStr3 =  [RSAEncryptor encryptString:[[NSString alloc] initWithBytes:other length:strlen((char *)other) encoding:NSUTF8StringEncoding] publicKey:publickKey];
            [mParams setObject:encodeStr3 forKey:@"other"];
            md5factor = [md5factor stringByAppendingString:encodeStr3];
            free(other);
        }
        
        //3.
        NSString *version = AppBuildVersion;
        
        NSString *signfactor = @"EwanlanSince20160606@Beijing";
        md5factor = [md5factor stringByAppendingString:version];
        md5factor = [md5factor stringByAppendingString:signfactor];
        
        NSString *md = [NSString md5String:md5factor];
        [mParams setObject:version forKey:@"version"];
        [mParams setObject:md forKey:@"sign"];
        
        NSLog(@"map = %@\n md5factor = %@", mParams, md5factor);
        
    }
    //发送请求
    AFHTTPSessionManager *manager = [LCAFNetWork managerWithBaseURL:[ActivityApp shareActivityApp].baseURL sessionConfiguration:NO];
    [manager POST:url parameters:mParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id dic = [LCAFNetWork responseConfiguration:responseObject error:&error];
        if (error) {
            DLog(@"Serialization Error:%@\nURL:%@==%@", [error localizedDescription], url, mParams);
            fail(task,error);
            return;
        }
        DLog(@"URL:%@%@\n%@",[ActivityApp shareActivityApp].baseURL, url, dic);
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

+(void)POST:(NSString *)url baseURL:(NSString *)baseUrl params:(NSDictionary *)params
    success:(LCResponseSuccess)success fail:(LCResponseFail)fail{
    
    AFHTTPSessionManager *manager = [LCAFNetWork managerWithBaseURL:baseUrl sessionConfiguration:NO];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id dic = [LCAFNetWork responseConfiguration:responseObject error:&error];
        if (error) {
            DLog(@"Serialization Error:%@\nURL:%@==%@", [error localizedDescription], url, params);
            return;
        }
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

+(void)POST:(NSString *)url params:(NSDictionary *)params responseCache:(LCHttpRequestCache)responseCache success:(LCResponseSuccess)success fail:(LCResponseFail)fail {
    
    //读取缓存
    NSString *URL = [NSString stringWithFormat:@"%@%@", [ActivityApp shareActivityApp].baseURL, url];
    responseCache !=nil ? responseCache([PPNetworkCache httpCacheForURL:URL parameters:params]) : nil;
    
    AFHTTPSessionManager *manager = [LCAFNetWork managerWithBaseURL:[ActivityApp shareActivityApp].baseURL sessionConfiguration:NO];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id dic = [LCAFNetWork responseConfiguration:responseObject error:&error];
        
        if (error) {
            DLog(@"Serialization Error:%@\nURL:%@==%@", [error localizedDescription], url, params);
            fail(task,error);
            return;
        }
        DLog(@"URL:%@%@\n%@",[ActivityApp shareActivityApp].baseURL, url, dic);
        success(task,dic);
        
        //对数据进行异步缓存
        if ([dic[STATE] intValue]==1) {
            [PPNetworkCache setHttpCache:dic URL:URL parameters:params];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}



+(void)uploadWithURL:(NSString *)url params:(NSDictionary *)params fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *) mimeType progress:(LCProgress)progress success:(LCResponseSuccess)success fail:(LCResponseFail)fail{
    
    AFHTTPSessionManager *manager = [LCAFNetWork managerWithBaseURL:[ActivityApp shareActivityApp].baseURL sessionConfiguration:NO];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id dic = [LCAFNetWork responseConfiguration:responseObject error:&error];
        if (error) {
            DLog(@"Serialization Error:%@\nURL:%@==%@", [error localizedDescription], url, params);
            return;
        }
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

+(void)uploadWithURL:(NSString *)url
             baseURL:(NSString *)baseurl
              params:(NSDictionary *)params
            fileData:(NSData *)filedata
                name:(NSString *)name
            fileName:(NSString *)filename
            mimeType:(NSString *) mimeType
            progress:(LCProgress)progress
             success:(LCResponseSuccess)success
                fail:(LCResponseFail)fail{
    
    AFHTTPSessionManager *manager = [LCAFNetWork managerWithBaseURL:baseurl sessionConfiguration:YES];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id dic = [LCAFNetWork responseConfiguration:responseObject error:&error];
        if (error) {
            DLog(@"Serialization Error:%@\nURL:%@==%@", [error localizedDescription], url, params);
            return;
        }
        success(task,dic);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}


+(NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                 savePathURL:(NSURL *)fileURL
                                    progress:(LCProgress )progress
                                     success:(void (^)(NSURLResponse *, NSURL *))success
                                        fail:(void (^)(NSError *))fail{
    AFHTTPSessionManager *manager = [self managerWithBaseURL:nil sessionConfiguration:YES];
    
    NSURL *urlpath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            fail(error);
        }else{
            
            success(response,filePath);
        }
    }];
    
    [downloadtask resume];
    
    return downloadtask;
}

#pragma mark - Private

+(AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL  sessionConfiguration:(BOOL)isconfiguration{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =nil;
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    if (isconfiguration) {
        
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    [manager.requestSerializer setValue:APP_key forHTTPHeaderField:@"APP_key"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];

    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    return manager;
}

+(id)responseConfiguration:(id)responseObject error:(NSError **)error{
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:error];

    return dic;
}
@end
