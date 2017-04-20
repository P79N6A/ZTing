//
//  SetNickViewController.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTBaseViewCtrl.h"

@protocol UpdateNickCompleteDelegate <NSObject>

- (void)updateNickComplete:(NSString *)nick;

@end

@interface SetNickViewController : ZTBaseViewCtrl

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) id<UpdateNickCompleteDelegate> delegate;

@end
