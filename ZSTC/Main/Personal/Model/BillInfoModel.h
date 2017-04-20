//
//  BillInfoModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface BillInfoModel : BaseModel
/*
{
    assetsLogId: "4028e44255e886980155ee39b4a20008",
    assetsLogMemberId: "4028e489559725280155972528a30000",
    assetsChangeType: "3",
    payType: "01",
    isFirst: "1",
    assetsLast: 482403,
    assetsChange: 1700,
    assetsAfter: 480703,
    assetsRemark: "会员ID：4028e489559725280155972528a30000 自助缴费：17.0元",
    assetsLogAddtime: "20160715190327",
    memberName: "小米",
    memberPhone: "18627032297",
    assetsOrderId: "8a04a41f55e1fd6e0155ec51ee200003"
}
 */

@property (nonatomic, copy) NSString *assetsLogId;
@property (nonatomic, copy) NSString *assetsLogMemberId;
@property (nonatomic, copy) NSString *assetsChangeType;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *isFirst;
@property (nonatomic, strong) NSNumber *assetsLast;
@property (nonatomic, strong) NSNumber *assetsChange;
@property (nonatomic, strong) NSNumber *assetsAfter;
@property (nonatomic, copy) NSString *assetsRemark;
@property (nonatomic, copy) NSString *assetsLogAddtime;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *memberPhone;
@property (nonatomic, copy) NSString *assetsOrderId;

@end
