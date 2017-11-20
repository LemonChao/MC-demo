//
//  LCCycleImgModel.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/22.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCCycleImgModel : NSObject

/** 标题 */
@property(nonatomic, copy) NSString *title;

/** 轮播图拼接路径 */
@property(nonatomic, copy) NSString *downpath;

/** 外部详情链接 */
@property(nonatomic, copy) NSString *url;//flag

/** 1：图片有外部链接，0：无 */
@property(nonatomic, copy) NSString *flag;

@end


@interface ColumnModel : NSObject

/** columnid */
@property(nonatomic, copy) NSString *columnid;

/** imageurl */
@property(nonatomic, copy) NSString *imageurl;

/** h5url */
@property(nonatomic, copy) NSString *h5url;

/** type */
@property(nonatomic, copy) NSString *type;

/** number */
@property(nonatomic, copy) NSString *number;


@end
