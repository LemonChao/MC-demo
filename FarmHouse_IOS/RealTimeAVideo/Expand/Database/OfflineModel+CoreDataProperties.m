//
//  OfflineModel+CoreDataProperties.m
//  RealTimeAVideo
//
//  Created by Lemon on 2017/4/18.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "OfflineModel+CoreDataProperties.h"

@implementation OfflineModel (CoreDataProperties)

+ (NSFetchRequest<OfflineModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OfflineModel"];
}

@dynamic farmerId;
@dynamic farmerName;
@dynamic houseInfo;
@dynamic isUpload;
@dynamic offlineArray;
@dynamic reserveOne;
@dynamic userId;
@dynamic autoUpdate;

@end

@implementation OfflineArray

+ (Class)transformedValueClass{
    return [NSArray class];
}
+ (BOOL)allowsReverseTransformation{
    return YES;
}
- (id)transformedValue:(id)value{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}
- (id)reverseTransformedValue:(id)value{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
