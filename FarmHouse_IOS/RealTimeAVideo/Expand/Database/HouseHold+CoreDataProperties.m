//
//  HouseHold+CoreDataProperties.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/3/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "HouseHold+CoreDataProperties.h"

@implementation HouseHold (CoreDataProperties)

+ (NSFetchRequest<HouseHold *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HouseHold"];
}

@dynamic reportNum;
@dynamic timestamp;
@dynamic masterid;
@dynamic nhid;
@dynamic name;
@dynamic cardid;
@dynamic maritalStatus;
@dynamic tel;
@dynamic sum;
@dynamic address;
@dynamic zipCode;
@dynamic income;
@dynamic sex;
@dynamic nation;
@dynamic familytype;
@dynamic openbank;
@dynamic banknumber;

@end
