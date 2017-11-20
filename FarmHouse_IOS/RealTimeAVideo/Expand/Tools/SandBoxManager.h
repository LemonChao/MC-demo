//
//  SandBoxManager.h
//  Kamera
//
//  Created by Lemon on 16/10/20.
//  Copyright © 2016年 eWanLan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SandBoxManager : NSObject


/** create directory in the caches directory */
+ (NSString *)creatFileUnderCaches;



/**
 delete cache file

 @param pathStr filePath eg. @"/IMG"

 */
+ (BOOL)deleteCacheFileWithPath:(NSString *)pathStr;


/**
 create directory under the caches directory begain with "/"
 
 @param flileName file name with "/"
 
 @return file Path
 */
+ (NSString *)creatPathUnderCaches:(NSString *)fileName;



/**
 save Image to the caches directory
 
 @param directoryPath image's Path
 @param image         image
 @param imageName     image's name
 @param imgType       image's type
 
 @return image.type if sucessed, else nil
 */
+ (NSString *)writeToDirectory:(NSString *)directoryPath WithImage:(UIImage *)image imageName:(NSString *)imageName imgType:(NSString *)imgType;


/**
 save Image to the caches directory
 
 @param directoryPath image's Path
 @param image         image
 @param imageName     image's name
 @param imgType       image's type
 
 @return image.type if sucessed, else nil
 */
+ (NSString *)writeToDirectory:(NSString *)directoryPath WithData:(NSData *)imageData imageName:(NSString *)imageName imgType:(NSString *)imgType;


@end
