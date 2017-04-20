//
//  CardModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface CardModel : BaseModel
/*
{
    "couponId": "4028e44254c69ee10154cd36bfa00070",
    "couponMemberId": "4028e44254c7b5a80154cc487a2f013e",
    "couponName": "5元红包",
    "couponCode": "12345",
    "couponRuleId": null,
    "couponStart": "20160607103630",
    "couponEnd": "20160614103030",
    "couponCashbal": 500,
    "couponRemarks": "这是一个五元测试红包",
    "couponStatus": "0",
    "couponUserid": null,
    "couponCtime": "20160607103530",
    "couponOrdre": null
}
*/

@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, copy) NSString *couponMemberId;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *couponCode;
@property (nonatomic, copy) NSString *couponRuleId;
@property (nonatomic, copy) NSString *couponStart;
@property (nonatomic, copy) NSString *couponEnd;
@property (nonatomic, copy) NSString *couponCashbal;
@property (nonatomic, copy) NSString *couponRemarks;
@property (nonatomic, copy) NSString *couponStatus;
@property (nonatomic, copy) NSString *couponUserid;
@property (nonatomic, copy) NSString *couponCtime;
@property (nonatomic, copy) NSString *couponOrdre;

@end
