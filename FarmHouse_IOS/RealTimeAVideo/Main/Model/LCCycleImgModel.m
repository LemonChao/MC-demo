//
//  LCCycleImgModel.m
//  RealTimeAVideo
//
//  Created by Lemon on 16/12/22.
//  Copyright © 2016年 YiWanLian. All rights reserved.
//

#import "LCCycleImgModel.h"

@implementation LCCycleImgModel

- (void)setDownpath:(NSString *)downpath {
    if (_downpath != downpath) {
        _downpath = [NSString stringWithFormat:@"%@%@",[ActivityApp shareActivityApp].baseURL, downpath];
        [_downpath copy];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@, downpath:%@, url:%@,flag:%@",self.title, self.downpath, self.url, self.flag];
}
@end


@implementation ColumnModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"columnid":@"id"};
}

- (void)setImageurl:(NSString *)imageurl {
    
    if (_imageurl != imageurl) {
        _imageurl = [NSString stringWithFormat:@"%@%@",[ActivityApp shareActivityApp].baseURL, imageurl];
    }
}


@end
