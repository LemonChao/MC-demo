//
//  LCOfflineModel.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCOfflineModel : NSObject

@end


/// offline charge image model
@interface LCOfflineImgModel : NSObject<NSCoding>

/** 9922017033017389825841_20170330173858.jpg */
@property(nonatomic, copy) NSString *filePath;

/** offline image description */
@property(nonatomic, copy) NSString *imgDescrip;

//@property(nonatomic, assign) BOOL isPlaceHolder;
/** 是否背景占位 4期*/
@property(nonatomic, getter=isPlaceHolder) BOOL placeHolder;

/** 离线图片 4期 */
@property(nonatomic, strong) UIImage *image;

@property(nonatomic, strong) UIImage *placeholderImg;

- (instancetype)initWithImageContentsOfFile:(NSString *)filePath description:(NSString *)description;

@end
