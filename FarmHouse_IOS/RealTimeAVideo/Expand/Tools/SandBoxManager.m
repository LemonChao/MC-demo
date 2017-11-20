//
//  SandBoxManager.m
//  Kamera
//
//  Created by Lemon on 16/10/20.
//  Copyright © 2016年 eWanLan. All rights reserved.
//

#import "SandBoxManager.h"

@implementation SandBoxManager


+ (NSString *)creatFileUnderCaches
{
    
    return [self creatPathUnderCaches:@"/IMG"];
}

+ (BOOL)deleteCacheFileWithPath:(NSString *)pathStr
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) firstObject];
    NSString *imageFP = [cachePath stringByAppendingString:pathStr];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageFP isDirectory:&isDir];
    bool isDelete = false;
//    if ( isDir == YES && existed == YES )
//    {
//        isDelete = [fileManager removeItemAtPath:imageFP error:nil];
//    }
    if ( existed == YES )
    {
        isDelete = [fileManager removeItemAtPath:imageFP error:nil];
    }

    return isDelete;
}


/**
 create directory under the caches directory begain with "/"
 
 @param flileName file name with "/"
 
 @return file Path
 */
+ (NSString *)creatPathUnderCaches:(NSString *)fileName {
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) firstObject];
    NSString *imageFP = [cachePath stringByAppendingString:fileName];
    
    BOOL isDir = NO;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageFP isDirectory:&isDir];
    bool isCreated = false;
    if (!(isDir == YES && existed == NO))
    {
        isCreated = [fileManager createDirectoryAtPath:imageFP withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (isCreated) {
        return imageFP;
    }else {
        NSLog(@"creatDirError = %@",error);
        return nil;
    }

}


/**
 save Image to the caches directory

 @param directoryPath image's Path
 @param image         image
 @param imageName     image's name
 @param imgType       image's type

 @return image.type if sucessed, else nil
 */
+ (NSString *)writeToDirectory:(NSString *)directoryPath WithImage:(UIImage *)image imageName:(NSString *)imageName imgType:(NSString *)imgType
{
    if (!directoryPath) return nil;
    
    return [self saveImageToDirectory:directoryPath WithImage:image imageName:imageName imgType:imgType];
    
}

+ (NSString *)saveImageToDirectory:(NSString *)directoryPath WithImage:(UIImage *)image imageName:(NSString *)imageName imgType:(NSString *)imageType
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = false;
    NSError *error;
    NSString *filePath;
    if ( isDir == YES && existed == YES )
    {
        if ([[imageType lowercaseString] isEqualToString:@"png"])
        {
            filePath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]];
            
            isSaved = [UIImagePNGRepresentation(image) writeToFile:filePath options:NSAtomicWrite error:&error];

        }
        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
        {
            filePath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
            
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath options:NSAtomicWrite error:&error];
        }
        else
        {
            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
        }
    }
    NSLog(@"filePath = %@", filePath);
    
    return isSaved ? filePath : nil;
}


+ (NSString *)writeToDirectory:(NSString *)directoryPath WithData:(NSData *)imageData imageName:(NSString *)imageName imgType:(NSString *)imgType {
    
    if (!directoryPath) return nil;
    
//    [imageData writeToFile:@"" atomically:NO];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = false;
    NSError *error;
    NSString *filePath;
    if ( isDir == YES && existed == YES )
    {
        if ([[imgType lowercaseString] isEqualToString:@"png"])
        {
            filePath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]];
            
            isSaved = [imageData writeToFile:filePath options:NSAtomicWrite error:&error];
            
        }
        else if ([[imgType lowercaseString] isEqualToString:@"jpg"] || [[imgType lowercaseString] isEqualToString:@"jpeg"])
        {
            filePath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
            
            isSaved = [imageData writeToFile:filePath options:NSAtomicWrite error:&error];
        }
        else
        {
            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imgType);
        }
    }
    NSLog(@"filePath = %@", filePath);
    
    return isSaved ? filePath : nil;

    
}




@end
