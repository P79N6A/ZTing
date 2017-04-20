//
//  ZTCustomAntionView.h
//  ZSTC
//
//  Created by 焦平 on 2017/3/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class ZTAnnotation;

@interface  ZTCustomAntionView : MAAnnotationView

//一定要重写，否则当滑动地图，annotation出现和消失时候会出现数据混乱
- (void)setAnnotation:(id<MAAnnotation>)annotation;

@end
