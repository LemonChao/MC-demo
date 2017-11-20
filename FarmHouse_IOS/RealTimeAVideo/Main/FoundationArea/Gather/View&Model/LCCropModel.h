//
//  LCCropModel.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/5/17.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

//采集 农产品，农具 model
@interface LCCropModel : NSObject

/** 农畜，农产品 ，农具表 id*/
@property(nonatomic, copy) NSString *cropid;

/** 农户id */
@property(nonatomic, copy) NSString *farmerid;

/** 品种 */
@property(nonatomic, copy) NSString *varieties;

/** 种类，设备名称 */
@property(nonatomic, copy) NSString *name;

@end
