//
//  LCPhotoModel.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPhotoModel : NSObject

/** 9922017033017389825841_20170330173858.jpg */
@property(nonatomic, copy) NSString *filePath;

/** offline image description */
@property(nonatomic, copy) NSString *imgDescrip;

/** 是否背景占位 4期*/
//@property(nonatomic, getter=isPlaceHolder) BOOL placeHolder;

/** 离线图片 4期 */
@property(nonatomic, strong) UIImage *image;

/** 背景占位图 4期*/
//@property(nonatomic, strong) UIImage *placeholderImg;

@end
