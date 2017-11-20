//
//  LCSearchModel.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/27.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCSearchModel.h"

@implementation Farmer

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"farmerid":@"id"};
}


@end

@implementation LCSearchModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"caseid":@"id"};
}



@end


@implementation LCReportImgModel

- (void)setImagepath:(NSString *)imagepath {
    if (_imagepath != imagepath) {
        _imagepath = [NSString stringWithFormat:@"%@%@", [ActivityApp shareActivityApp].baseURL, imagepath];
        [_imagepath copy];
    }
}


@end


@implementation LCDisasterModel

@end
