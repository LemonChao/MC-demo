//
//  LCSearchModel.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/27.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Farmer : NSObject

/** farmerid */
@property(nonatomic, copy) NSString *farmerid;

/** 农户姓名 */
@property(nonatomic, copy) NSString *name;

/** 地址 */
@property(nonatomic, copy) NSString *address;

@end


@interface LCSearchModel : NSObject

/** 案件id */
@property(nonatomic, copy) NSString *caseid;

/** 协保员id */
@property(nonatomic, copy) NSString *user_id;

/** 报案号 */
@property(nonatomic, copy) NSString *number;

/** 农户id */
@property(nonatomic, copy) NSString *nhId;

/** 案件状态 */
@property(nonatomic, copy) NSString *state;

/** starttime */
@property(nonatomic, copy) NSString *starttime;

/** endtime */
@property(nonatomic, copy) NSString *endtime;

/** 在线离线 */
@property(nonatomic, copy) NSString *type;

/**  */
@property(nonatomic, copy) NSString *finally_amount;

@property(nonatomic, strong) Farmer *farmer;

@end


/// 案件查询图片详情
@interface LCReportImgModel : NSObject

/** 描述 */
@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *imagepath;

@end


/// 灾情和救助物质
@interface LCDisasterModel : NSObject

/** 灾情 */
@property(nonatomic, copy) NSString *disaster;

/** 救助物资 */
@property(nonatomic, copy) NSString *relief_material;

@end

