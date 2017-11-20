//
//  LCNonghuModel.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/6.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 农户户主基本信息
@interface LCHouseHoldModel : NSObject

/** 户主id */
@property(nonatomic, copy) NSString *nhid;

/** 户主name */
@property(nonatomic, copy) NSString *name;

/** 户主地址 */
@property(nonatomic, copy) NSString *address;

@end




/// 农户家庭成员信息
@interface LCHouseMemberModel : NSObject

/** 成员id */
@property(nonatomic, copy) NSString *memberid;

/** 家庭成员的户主id */
@property(nonatomic, copy) NSString *nhid;

/** 所属的户主的协保员id */
@property(nonatomic, copy) NSString *userId;

/** 成员name */
@property(nonatomic, copy) NSString *name;

@end




/// 农户房屋信息
@interface LCHouseInfoModel : NSObject

/** 房屋id */
@property(nonatomic, copy) NSString *houseid;

/** 房屋地址 */
@property(nonatomic, copy) NSString *address;

/** 房屋的户主id */
@property(nonatomic, copy) NSString *nhid;

@end


// 户主图片Model
@interface LCHouseHoldImage : NSObject

/** imageid */
@property(nonatomic, copy) NSString *imageid;

/** 描述 */
@property(nonatomic, copy) NSString *imagecontent;

/** 图片url */
@property(nonatomic, copy) NSString *imageurl;

/** id */
@property(nonatomic, copy) NSString *nhid;

@end
