//
//  CaseFlowModel.h
//  EWLMedicalSafety
//
//  Created by sunpeng on 2017/3/17.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CaseFlowModel : NSObject

@property (nonatomic, copy)NSString *userid, *content, *time, *use_Id, *reportid, *isshow, *isdelete, *username, *title, *userheadimage;
@property (nonatomic, strong)NSArray *imagepath;

@property (nonatomic, assign)CGFloat cellHeight, contentHeight, photoViewHeight, normalHeight;
//是否展开
@property (nonatomic, assign)BOOL isFull;
//是否隐藏展开btn
@property (nonatomic, assign)BOOL ishideFillBtn;

@end
