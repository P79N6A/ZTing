//
//  BillModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@class BillInfoModel;
@interface BillModel : BaseModel
/*
{
draw: 2,
start: 0,
length: 10,
data: [
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
       }],
recordsTotal: 16,
recordsFiltered: 16,
totalPages: 0,
error: null,
offset: 0,
limit: 2147483647
}
 */

@property (nonatomic, strong) NSNumber *start;
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, strong) NSNumber *recordsTotal;   // 总记录

@end
