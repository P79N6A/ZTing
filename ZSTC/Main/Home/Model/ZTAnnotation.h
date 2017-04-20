//
//  ZTAnnotation.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
//注意导入框架

#import <MAMapKit/MAMapKit.h>
#import "AnnotationModel.h"

//该模型是大头针模型 所以必须实现协议MKAnnotation协议 和CLLocationCoordinate2D中的属性coordinate
@interface ZTAnnotation : MAPointAnnotation<MAAnnotation>

@property (nonatomic,strong) AnnotationModel *model;

@end
