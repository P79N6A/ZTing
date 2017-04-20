//
//  ZTNetworkClient.h
//  ZSTC
//
//  Created by 焦平 on 2017/3/23.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFNetworking;

typedef void (^ProgressFloat)(float progressFloat);
typedef void (^Succeed)(id responseObject);
typedef void (^Failure)(NSError *error);

@interface ZTNetworkClient : NSObject

+ (ZTNetworkClient *) sharedInstance;

/** get请求*/
- (void)GET:(NSString *)URLString dict:(id)dict progressFloat:(ProgressFloat)progressFloat succeed:(Succeed)succeed failure:(Failure)failure;

/** post请求*/
- (void)POST:(NSString *)URLString dict:(id)dict progressFloat:(ProgressFloat)progressFloat succeed:(Succeed)succeed failure:(Failure)failure;

/** 下载文件*/
-(void)DOWNLOAD:(NSString *)URLString progressFloat:(ProgressFloat)progressFloat downLoadDic:(Succeed)downLoadDic;

/** 上传多张图片*/
-(void)UPLOAD:(NSString *)URLString dict:(id)dict imageArray:(id)imageArray progressFloat:(ProgressFloat)progressFloat succeed:(Succeed)succeed failure:(Failure)failure;

@end
