//
//  CollectModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface CollectModel : BaseModel
/*
 {
     "collectId": 27,
     "collectParkid": "4028e442558f94c301559004b8480020",
     "collectMemberid": "4028e489559725280155972528a30000",
     "collectCollecttime": "20160701174545",
     "collectRemark": "关注停车场,停车场名称null",
     "parkName": "光谷停车场2",
     "memberName": "小米",
     "parkFeedesc": "//白天时段为7:00-------19:00,免费时间30分钟，30分钟至4小时收费2元，4小时至12小时，收费4元； //晚上时段为19:00-------7:00, 免费时间30分钟，30分钟至4小时收费3元，4小时至12小时，收费6元；",
     "parkAddress": "光谷大道116号",
     "parkPhotoid": "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/yunpark/40000015/20160630/20160630194333u=136927398,3974644461&fm=21&gp=0.jpg",
     "parkCapacity": "800",
     "parkIdle": "800",
     "parkFeelevel": "",
     "memberPhone": "18627032297"
 }
 */

@property (nonatomic, strong) NSNumber *collectId;
@property (nonatomic, copy) NSString *collectParkid;
@property (nonatomic, copy) NSString *collectMemberid;
@property (nonatomic, copy) NSString *collectCollecttime;
@property (nonatomic, copy) NSString *collectRemark;
@property (nonatomic, copy) NSString *parkName;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *parkFeedesc;
@property (nonatomic, copy) NSString *parkAddress;
@property (nonatomic, copy) NSString *parkPhotoid;
@property (nonatomic, copy) NSString *parkCapacity;
@property (nonatomic, copy) NSString *parkIdle;
@property (nonatomic, copy) NSString *parkFeelevel;
@property (nonatomic, copy) NSString *memberPhone;

@end
