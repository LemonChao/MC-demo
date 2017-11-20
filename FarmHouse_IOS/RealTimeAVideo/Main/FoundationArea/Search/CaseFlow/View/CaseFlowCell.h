//
//  CaseFlowCell.h
//  EWLMedicalSafety
//
//  Created by sunpeng on 2017/3/17.
//  Copyright © 2017年 sunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseFlowModel.h"
#import "LCCaseFlowViewController.h"

typedef void(^FullBlock)();

@interface CaseFlowCell : UITableViewCell

@property (nonatomic, strong)CaseFlowModel *model;

@property (nonatomic, copy)FullBlock block;

@property (nonatomic, strong)LCCaseFlowViewController *vc;

@end
