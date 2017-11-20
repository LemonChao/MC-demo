//
//  LCWalletModel.h
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/26.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCWalletModel : NSObject

@end

/// 零钱
@interface LCChangeModel : NSObject

/** 零钱 数据库主键id*/
@property(nonatomic, copy) NSString *primaryid;

@property(nonatomic, copy) NSString *monery;

/** 用户id */
@property(nonatomic, copy) NSString *userid;


@end


/// 银行卡
@interface LCBankCardModel : NSObject

/** 银行名称 */
@property(nonatomic, copy) NSString *bank;

/** 开户人 */
@property(nonatomic, copy) NSString *bankname;

/** 银行卡号 */
@property(nonatomic, copy) NSString *banknumber;

/** 银行卡 数据库主键id*/
@property(nonatomic, copy) NSString *primaryid;

/** tel*/
@property(nonatomic, copy) NSString *tel;

/** 用户id */
@property(nonatomic, copy) NSString *userid;

@end


/// 交易记录(明细)
@interface LCTradRecordModel : NSObject

/** 交易明细 数据库主键id */
@property(nonatomic, copy) NSString *primaryid;

/** 零钱表id */
@property(nonatomic, copy) NSString *changeid;

/** 操作时间 */
@property(nonatomic, copy) NSString *time;

/** 操作类型 0：提取，1：存入 */
@property(nonatomic, copy) NSString *type;

/** 操作前金额 */
@property(nonatomic, copy) NSString *beforemonery;

/** 交易金额 */
@property(nonatomic, copy) NSString *monery;

/** 操作后金额 */
@property(nonatomic, copy) NSString *aftermonery;

/** 备注 如转账失败，奖金等 */
//@property(nonatomic, copy) NSString *content;


@end
