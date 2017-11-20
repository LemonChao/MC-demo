//
//  LCWalletModel.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/26.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCWalletModel.h"

@implementation LCWalletModel

@end


/// 零钱
@implementation LCChangeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"primaryid" : @"id"};
}


@end



/// 银行卡
@implementation LCBankCardModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"primaryid" : @"id"};
}



@end


/// 交易记录(明细)
@implementation LCTradRecordModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"primaryid" : @"id"};
}



@end
