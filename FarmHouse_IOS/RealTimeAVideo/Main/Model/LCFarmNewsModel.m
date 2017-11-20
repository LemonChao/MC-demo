//
//  LCFarmNewsModel.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/22.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCFarmNewsModel.h"

@implementation LCFarmNewsModel

- (void)setPath:(NSString *)path {
    if (_path != path) {
        _path = [NSString stringWithFormat:@"%@%@", [ActivityApp shareActivityApp].baseURL, path];
        [_path copy];
    }
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"newsid":@"id"};
}


- (NSString *)description {
    return [NSString stringWithFormat:@"path:%@, newsid:%@, imagename:%@, title:%@, synopsis:%@, datetime:%@", _path, _newsid, _imagename, _title, _synopsis, _datetime];
}


@end






@implementation LCHouseholderModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"masterid":@"id"};
}

@end
