//
//  ZTAnnotation.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTAnnotation.h"

@implementation ZTAnnotation

-(void)setModel:(AnnotationModel *)model
{
    _model = model;
    
    NSString *parklat = [NSString stringWithFormat:@"%@",model.parkLat];
    NSMutableString *parkLatStr = [NSMutableString stringWithString:parklat];
    [parkLatStr insertString:@"." atIndex:2];
    
    NSString *parklng = [NSString stringWithFormat:@"%@",model.parkLng];
    NSMutableString *parkLngStr = [NSMutableString stringWithString:parklng];
    [parkLngStr insertString:@"." atIndex:3];
    
    self.coordinate = CLLocationCoordinate2DMake([parkLatStr doubleValue], [parkLngStr doubleValue]);
}


@end
