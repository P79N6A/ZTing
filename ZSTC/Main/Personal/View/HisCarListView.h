//
//  HisCarListView.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BindCarModel.h"

@protocol SelectBindCarDelegate <NSObject>

- (void)selectBindCar:(BindCarModel *)bindCarModel;

@end

@interface HisCarListView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *bindCarData;
@property (nonatomic, assign) id<SelectBindCarDelegate> delegate;

@end
