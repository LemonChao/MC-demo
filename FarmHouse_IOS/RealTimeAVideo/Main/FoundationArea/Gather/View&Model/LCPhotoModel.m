//
//  LCPhotoModel.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCPhotoModel.h"

@implementation LCPhotoModel


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.imgDescrip = [aDecoder decodeObjectForKey:@"imgDescrip"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
//        self.placeholderImg = [aDecoder decodeObjectForKey:@"placeholderImg"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.imgDescrip forKey:@"imgDescrip"];
    [aCoder encodeObject:self.image forKey:@"image"];
//    [aCoder encodeObject:self.placeholderImg forKey:@"placeholderImg"];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@, %@", self.filePath, self.imgDescrip];
}

@end
