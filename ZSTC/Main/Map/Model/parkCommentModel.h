//
//  parkCommentModel.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface parkCommentModel : BaseModel
/*
 {
 commentCommentTime = 20170303150925;
 commentContent = "\U6b27\U514b";
 commentId = 1;
 commentMemberid = 8a10c18958a8d3ae0158a9387c300016;
 commentParkid = 8a21dd2c5a3a259d015a83cef7b1009a;
 commentScore1 = 5;
 commentScore2 = 5;
 commentScore3 = 5;
 commentTotal = 5;
 memberName = tcb20161128;
 memberPhone = 15308408543;
 parkName = "\U9686\U5e73\U9ad8\U79d1\U7ba1\U59d4\U4f1a\U505c\U8f66\U573a";
 }
 */

@property (nonatomic,strong) NSNumber *commentId;

@property (nonatomic,strong) NSNumber *commentScore1;

@property (nonatomic,copy) NSString *commentParkid;

@property (nonatomic,strong) NSNumber *commentScore2;

@property (nonatomic,copy) NSString *memberName;

@property (nonatomic,copy) NSString *commentCommentTime;

@property (nonatomic,strong) NSNumber *commentScore3;

@property (nonatomic,copy) NSString *commentContent;

@property (nonatomic,copy) NSString *parkName;

@property (nonatomic,copy) NSString *commentMemberid;

@property (nonatomic,strong) NSNumber *commentTotal;

@property (nonatomic,copy) NSString *memberPhone;

@end
