//
//  SelCarNoView.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelCarNoDelegate <NSObject>

- (void)selCarNoCompelete:(NSString *)carNo;

@end

@interface SelCarNoView : UIView <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<SelCarNoDelegate> delegate;

@end
