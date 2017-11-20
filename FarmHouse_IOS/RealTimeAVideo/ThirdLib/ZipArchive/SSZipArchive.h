//
//  SSZipArchive.h
//  SSZipArchive
//
//  Created by Sam Soffes on 7/21/10.
//  Copyright (c) Sam Soffes 2010-2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "unzip.h"

@protocol SSZipArchiveDelegate;

@interface SSZipArchive : NSObject

/**
 * @param          path    源文件
 * @param   destination    目的文件
 *
 * @return 返回 YES 表示成功，返回 NO 表示解压失败。
 */
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;

/**
 Description

 @param path 源文件
 @param destination 目的文件
 @param overwrite YES 会覆盖 destination 路径下的同名文件，NO 则不会。
 @param password 需要输入密码的才能解压的压缩包
 @param error 返回解压时遇到的错误信息
 @return 返回 YES 表示成功，返回 NO 表示解压失败
 */
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination overwrite:(BOOL)overwrite password:(NSString *)password error:(NSError **)error;

/**
 Description

 @param path 源文件
 @param destination 目的文件
 @param delegate 设置代理
 @return 返回 YES 表示成功，返回 NO 表示解压失败
 */
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination delegate:(id<SSZipArchiveDelegate>)delegate;

/**
 Description

 @param path 源文件
 @param destination 目的文件
 @param overwrite YES 会覆盖 destination 路径下的同名文件，NO 则不会。
 @param password 需要输入密码的才能解压的压缩包
 @param error 返回解压时遇到的错误信息
 @param delegate 设置代理
 @return 返回 YES 表示成功，返回 NO 表示解压失败
 */
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination overwrite:(BOOL)overwrite password:(NSString *)password error:(NSError **)error delegate:(id<SSZipArchiveDelegate>)delegate;

// Zip

/**
 Description

 @param path 目的路径（格式：～／xxx.zip 结尾的路径）
 @param filenames 要压缩的文件路径
 @return 返回 YES 表示成功，返回 NO 表示压缩失败。
 */
+ (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray *)filenames;


/**
 初始化压缩对象

 @param path 目的路径（格式：～／xxx.zip 结尾的路径）
 @return 初始化后的对像
 */
- (id)initWithPath:(NSString *)path;

/**
 打开压缩对象

 @return 返回 YES 表示成功，返回 NO 表示失败。
 */
- (BOOL)open;

/**
 添加要压缩的文件的路径

 @param path 文件路径
 @return 返回 YES 表示成功，返回 NO 表示失败。
 */
- (BOOL)writeFile:(NSString *)path;

/**
 向此路径的文件里写入数据

 @param data 要写入的数据
 @param filename 文件路径
 @return 返回 YES 表示成功，返回 NO 表示失败
 */
- (BOOL)writeData:(NSData *)data filename:(NSString *)filename;

/**
 关闭压缩对象

 @return 返回 YES 表示成功，返回 NO 表示失败。
 */
- (BOOL)close;

@end


@protocol SSZipArchiveDelegate <NSObject>

@optional


/**
 将要解压
 */
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo;
/**
 解压完成
 */
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath WithFilePaths:(NSMutableArray *)filePaths;
/**
 将要解压
 */
- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;
/**
 解压完成
 */
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;

@end
