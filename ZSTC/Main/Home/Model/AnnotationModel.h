//
//  AnnotationModel.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface AnnotationModel : BaseModel
/*
 {
 distance = 16;
 exceptCount = 0;
 joinAgentName = "<null>";
 joinRegionName = "<null>";
 parkAddress = "\U6e56\U5357\U7701\U957f\U6c99\U5e02\U8299\U84c9\U533a\U8fdc\U5927\U4e8c\U8def";
 parkAddtime = 20160824190226;
 parkAddversion = "<null>";
 parkAgentid = 8a04a41f56bc33a20156bc33a29f0000;
 parkAppointmentnum = "<null>";
 parkCapacity = 706;
 parkCapdesc = "";
 parkCheck = 0;
 parkCode = 40000021;
 parkCollecttime = 20160824190226;
 parkContactphone = "";
 parkContacts = "";
 parkDiscountIndex = "<null>";
 parkFeedesc = "\U6682\U4e0d\U6536\U8d39";
 parkFeeindex = "";
 parkFeelevel = 0;
 parkFlag = 0;
 parkFreetime = "<null>";
 parkHearttime = 20170412143147;
 parkId = 8a04a41f56bc33a20156bc3726df0004;
 parkIdle = 36;
 parkIdleOccu = "<null>";
 parkIsCard = "";
 parkIsbussiness = "";
 parkIspc = "";
 parkIsshare = "<null>";
 parkIsstagger = "";
 parkJointime = 20160824190226;
 parkLat = 28198051;
 parkLng = 113069866;
 parkLogon = 0;
 parkName = "\U901a\U670d\U5929\U56ed\U505c\U8f66\U573a";
 parkPcid = 0000000000000000000000000000001;
 parkPhotoid = "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/yunpark/40000021/20170306/20170306095717IMG_04018.jpg";
 parkRegionid = FDE21623FDD9A825E040007F01000707;
 parkRemark = "";
 parkScore = "<null>";
 parkSofttype = "";
 parkStatus = 0;
 parkSubtype = 07;
 parkType = 2;
 parkUpdversion = "<null>";
 parkUser = "<null>";
 parkUserid = 0000000000000000000000000000001;
 parkUtime = 20161227161024;
 traceAmt = 0;
 }
 */

@property (nonatomic,copy) NSString *parkIsCard;
@property (nonatomic,strong) NSNumber *parkLat;
@property (nonatomic,copy) NSString *parkUser;
@property (nonatomic,strong) NSNumber *traceAmt;
@property (nonatomic,copy) NSString *parkFeedesc;
@property (nonatomic,copy) NSString *parkCode;
@property (nonatomic,copy) NSString *parkUpdversion;
@property (nonatomic,copy) NSString *parkIsshare;
@property (nonatomic,copy) NSString *parkFreetime;
@property (nonatomic,copy) NSString *parkHearttime;
@property (nonatomic,copy) NSString *parkFeelevel;
@property (nonatomic,strong) NSNumber *parkIdle;
@property (nonatomic,copy) NSString *parkAgentid;
@property (nonatomic,copy) NSString *parkCollecttime;
@property (nonatomic,copy) NSString *parkContactphone;
@property (nonatomic,copy) NSString *parkAppointmentnum;
@property (nonatomic,copy) NSString *parkDiscountIndex;
@property (nonatomic,copy) NSString *parkIsstagger;
@property (nonatomic,copy) NSString *parkRemark;
@property (nonatomic,copy) NSString *parkRegionid;
@property (nonatomic,copy) NSString *parkFlag;
@property (nonatomic,strong) NSNumber *exceptCount;
@property (nonatomic,copy) NSString *parkId;
@property (nonatomic,copy) NSString *parkType;
@property (nonatomic,copy) NSString *parkPhotoid;
@property (nonatomic,strong) NSNumber *distance;
@property (nonatomic,copy) NSString *parkStatus;
@property (nonatomic,copy) NSString *parkContacts;
@property (nonatomic,copy) NSString *parkName;
@property (nonatomic,copy) NSString *parkPcid;
@property (nonatomic,copy) NSString *parkAddtime;
@property (nonatomic,copy) NSString *parkSubtype;
@property (nonatomic,copy) NSString *parkIspc;
@property (nonatomic,copy) NSString *parkCapdesc;
@property (nonatomic,strong) NSNumber *parkLng;
@property (nonatomic,copy) NSString *parkAddress;
@property (nonatomic,copy) NSString *parkScore;
@property (nonatomic,strong) NSNumber *parkCapacity;
@property (nonatomic,copy) NSString *parkFeeindex;
@property (nonatomic,copy) NSString *parkIdleOccu;
@property (nonatomic,copy) NSString *parkJointime;
@property (nonatomic,copy) NSString *parkUserid;
@property (nonatomic,copy) NSString *parkUtime;
@property (nonatomic,copy) NSString *parkCheck;
@property (nonatomic,copy) NSString *parkAddversion;
@property (nonatomic,copy) NSString *joinAgentName;
@property (nonatomic,copy) NSString *parkIsbussiness;
@property (nonatomic,copy) NSString *joinRegionName;
@property (nonatomic,copy) NSString *parkSofttype;
@property (nonatomic,copy) NSString *parkLogon;

@end
