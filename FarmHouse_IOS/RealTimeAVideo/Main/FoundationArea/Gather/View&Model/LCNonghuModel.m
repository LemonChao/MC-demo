//
//  LCNonghuModel.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/6.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCNonghuModel.h"
/// 农户户主基本信息
@implementation LCHouseHoldModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"nhid":@"id"};
}


@end




/// 农户家庭成员信息
@implementation LCHouseMemberModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"memberid":@"id"};
}



@end




/// 农户房屋信息
@implementation LCHouseInfoModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"houseid":@"id"};
}


@end




/// 户主图片Model
@implementation LCHouseHoldImage

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"imageid":@"id"};
}


- (void)setImageurl:(NSString *)imageurl {
    if (_imageurl != imageurl) {
        _imageurl = [NSString stringWithFormat:@"%@%@", [ActivityApp shareActivityApp].baseURL, imageurl];
    }
}

@end
