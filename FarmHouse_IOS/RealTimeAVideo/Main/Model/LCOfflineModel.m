//
//  LCOfflineModel.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/23.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCOfflineModel.h"

@implementation LCOfflineModel

@end



/// offline charge image model
@implementation LCOfflineImgModel

- (instancetype)initWithImageContentsOfFile:(NSString *)filePath description:(NSString *)description {
    
    self = [super init];
    if (self) {
        self.filePath = filePath;
        self.imgDescrip = description;
    }
    return self;

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.imgDescrip = [aDecoder decodeObjectForKey:@"imgDescrip"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.imgDescrip forKey:@"imgDescrip"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@, %@", self.filePath, self.imgDescrip];
}

@end
