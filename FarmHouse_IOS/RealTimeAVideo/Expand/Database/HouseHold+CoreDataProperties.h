//
//  HouseHold+CoreDataProperties.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "HouseHold+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HouseHold (CoreDataProperties)

+ (NSFetchRequest<HouseHold *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *reportNum;
@property (nonatomic) int32_t timestamp;
@property (nullable, nonatomic, copy) NSString *masterid; //实际值为NSNumber
@property (nullable, nonatomic, copy) NSString *nhid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *cardid;
@property (nullable, nonatomic, copy) NSString *maritalStatus;
@property (nullable, nonatomic, copy) NSString *tel;
@property (nullable, nonatomic, copy) NSString *sum;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *zipCode;
@property (nullable, nonatomic, copy) NSString *income;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nullable, nonatomic, copy) NSString *familytype;
@property (nullable, nonatomic, copy) NSString *openbank;
@property (nullable, nonatomic, copy) NSString *banknumber;

@end

NS_ASSUME_NONNULL_END
