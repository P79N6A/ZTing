//
//  LoginModel.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface LoginModel : BaseModel


@property (nonatomic,copy) NSString *memberCar;

@property (nonatomic,strong) NSNumber *memberCode;

@property (nonatomic,strong) NSNumber *memberCtime;

@property (nonatomic,copy) NSString *memberId;

@property (nonatomic,copy) NSString *memberIncome;

@property (nonatomic,copy) NSString *memberName;

@property (nonatomic,copy) NSString *memberPhone;

@property (nonatomic,copy) NSString *memberStatus;

@property (nonatomic,copy) NSString *memberSubtype;

@property (nonatomic,copy) NSString *memberThridPartid;

@property (nonatomic,copy) NSString *memberType;

@property (nonatomic,copy) NSString *memberUserid;

@property (nonatomic,copy) NSString *memberUtime;

/*
memberCar = "<null>";
memberCode = 60000037;
memberCtime = 20170410095454;
memberId = 8a21dd2c5b285b67015b55922bd8002e;
memberIncome = 02;
memberName = tcb20170410;
memberPhone = 15116664934;
memberStatus = 01;
memberSubtype = 00;
memberThridPartid = "<null>";
memberType = 01;
memberUserid = "<null>";
memberUtime = "<null>";
*/
@end
