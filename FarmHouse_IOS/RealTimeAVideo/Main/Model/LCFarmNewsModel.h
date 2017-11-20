//
//  LCFarmNewsModel.h
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/22.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCFarmNewsModel : NSObject

/** 当前第几页 */
@property (nonatomic, assign) NSInteger pageNo;

/** 一页几条数据 */
@property (nonatomic, copy) NSString *pagesize;

/** 对于json中id */
@property (nonatomic, copy) NSString *newsid;

/** imagename */
@property (nonatomic, copy) NSString *imagename;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 图片路径 */
@property (nonatomic, copy) NSString *path;

/** 简介 */
@property (nonatomic, copy) NSString *synopsis;

/** 时间 */
@property (nonatomic, copy) NSString *datetime;


/** 内容,仅限详情使用 */
@property (nonatomic, copy) NSString *content;

@end


@interface LCHouseholderModel : NSObject

/** 农户主键编号 */
@property (nonatomic, copy) NSString *masterid;

/** 协保员编号 */
@property (nonatomic, copy) NSString *nhid;

/** 户主姓名 必填 */
@property (nonatomic, copy) NSString *name;

/** 身份证号 必填 */
@property (nonatomic, copy) NSString *cardid;

/** 婚配状况 */
@property (nonatomic, copy) NSString *maritalStatus;

/** 户主电话 必填 */
@property (nonatomic, copy) NSString *tel;

/** 家庭人口 必填 */
@property (nonatomic, copy) NSString *sum;

/** 通讯地址 */
@property (nonatomic, copy) NSString *address;

/** 邮编 */
@property (nonatomic, copy) NSString *zipCode;

/** 收入（万元）*/
@property (nonatomic, copy) NSString *income;

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 民族 */
@property (nonatomic, copy) NSString *nation;

/** 家庭类别 必填 */
@property (nonatomic, copy) NSString *familytype;

/** 开户银行 必填 */
@property (nonatomic, copy) NSString *openbank;

/** 银行账号 必填 */
@property (nonatomic, copy) NSString *banknumber;

@end

