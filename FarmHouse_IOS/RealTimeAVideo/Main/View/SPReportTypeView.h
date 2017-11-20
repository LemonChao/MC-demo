//
//  SPReportTypeView.h
//  ReactiveCocoa
//
//  Created by sunpeng on 2017/4/27.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EmptyTypeOnline = 0,
    EmptyTypeOffline,
    EmptyTypeUpline,
    EmptyTypeRemove
} EmptyType;

@interface SPReportTypeView : UIView

+ (instancetype)initFromNibSelectBlock:(void(^)(NSInteger type))block;

@end
