//
//  BillingModel.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/25.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface BillingModel : BaseModel

@property (nonatomic,assign) int billingCartype;

@property (nonatomic,copy) NSString *billingRemark;

@end
