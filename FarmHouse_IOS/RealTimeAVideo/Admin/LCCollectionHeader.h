//
//  LCCollectionHeader.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/24.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OfflineModel,GatherPhoto;

// 离线拍照区头
@interface LCCollectionHeader : UICollectionReusableView
typedef void (^Block)();
@property(nonatomic, copy) Block btnBlock;

/** 户主id */
@property(nonatomic, copy) NSString *farmerId;
/** 户主名字 */
@property(nonatomic, copy) NSString *farmerName;
@property(nonatomic, strong) UITextField *houseField;
@property(nonatomic) BOOL autoUpdate;
@end


/// 未上传区头
@interface LCHeadUNupload : UICollectionReusableView

typedef void (^Block)();


@property(nonatomic, strong) UILabel *houseName;
@property(nonatomic, copy) Block btnBlock;
@property(nonatomic, copy) NSString *farmerId;
@property(nonatomic, copy) NSString *farmerNamer;
@property(nonatomic, copy) NSString *houseInfo;

- (void)setUnuploadHead:(OfflineModel *)model;
@end


// 已上传区头
@interface LCHeadUpload : UICollectionReusableView


- (void)setUploadHead:(OfflineModel *)model;
@end



typedef NS_ENUM(NSInteger, HeadGatherType) {
    HeadGatherFieldUnable = 0,
    HeadGatherFieldEnable,      //default, 户主姓名可以编辑修改
};
/// 采集功能区->农户照片采集
@interface LCHeadGather : UICollectionReusableView

typedef void (^Block)();
@property(nonatomic, copy) Block btnBlock;

/** 户主姓名 */
@property(nonatomic, strong) UITextField *nameField;

/** 户主id */
@property(nonatomic, copy) NSString *farmerId;

/** 户主名字 */
@property(nonatomic, copy) NSString *farmerName;

@property(nonatomic, assign) HeadGatherType headType;


- (void)setGatherHead:(GatherPhoto *)model;
@end

