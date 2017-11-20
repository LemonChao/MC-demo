//
//  GatherPhoto+CoreDataProperties.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/4/10.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "GatherPhoto+CoreDataProperties.h"

@implementation GatherPhoto (CoreDataProperties)

+ (NSFetchRequest<GatherPhoto *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GatherPhoto"];
}

@dynamic userid;
@dynamic photoArray;
@dynamic isUpload;
@dynamic houseName;
@dynamic houseInfo;
@dynamic nhid;
@dynamic reportNum;
@dynamic reserveOne;
@dynamic reserveTwo;
@dynamic imageContent;

@end


@implementation PhotoArray

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
