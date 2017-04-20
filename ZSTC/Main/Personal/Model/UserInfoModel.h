//
//  UserInfoModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel
/*
{
    "memberCode": "60000035",
    "memberType": "01",
    "memberSubtype": "00",
    "memberIncome": "04",
    "memberName": "会员1",
    "memberThridPartid": null,
    "extendId": 146,
    "memberId": "4028e4755543a628015543a80d690001",
    "memberPhone": "15527736835",
    "memberNikename": "",
    "memberBirthday": "",
    "memberPointsTotal": 0,
    "memberPointsLeft": 0,
    "memberLevel": "1",
    "memberSex": "0",
    "memberAddress": "",
    "memberPostCode": "",
    "memberContactName": "",
    "memberContactMobil": "",
    "memberEmail": "",
    "memberPhotoUrl": null,
    "memberLastlogin": "20160612160854",
    "memberPushType": null,
    "memberPush": null,
    "memberUserid": "0000000000000000000000000000001",
    "memberCtime": "20160612160854",
    "memberUtime": null
}
 */

@property (nonatomic, copy) NSString *memberCode;
@property (nonatomic, copy) NSString *memberType;
@property (nonatomic, copy) NSString *memberSubtype;
@property (nonatomic, copy) NSString *memberIncome;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *memberThridPartid;
@property (nonatomic, strong) NSNumber *extendId;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *memberPhone;
@property (nonatomic, copy) NSString *memberNikename;
@property (nonatomic, copy) NSString *memberBirthday;
@property (nonatomic, strong) NSNumber *memberPointsTotal;
@property (nonatomic, strong) NSNumber *memberPointsLeft;
@property (nonatomic, copy) NSString *memberLevel;
@property (nonatomic, copy) NSString *memberSex;
@property (nonatomic, copy) NSString *memberAddress;
@property (nonatomic, copy) NSString *memberPostCode;
@property (nonatomic, copy) NSString *memberContactName;
@property (nonatomic, copy) NSString *memberContactMobil;
@property (nonatomic, copy) NSString *memberEmail;
@property (nonatomic, copy) NSString *memberPhotoUrl;
@property (nonatomic, copy) NSString *memberLastlogin;
@property (nonatomic, copy) NSString *memberPushType;
@property (nonatomic, copy) NSString *memberPush;
@property (nonatomic, copy) NSString *memberUserid;
@property (nonatomic, copy) NSString *memberCtime;
@property (nonatomic, copy) NSString *memberUtime;



@end
