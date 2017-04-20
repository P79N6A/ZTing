//
//  UserExtModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface UserExtModel : BaseModel
/*
 {
 "carCount": 5,
 "cardCount": 0,
 "accountAmt": 0,
 "couponCount": 2
 }
 */

@property (nonatomic, strong) NSNumber *carCount;
@property (nonatomic, strong) NSNumber *cardCount;
@property (nonatomic, strong) NSNumber *accountAmt;
@property (nonatomic, strong) NSNumber *couponCount;

@end
