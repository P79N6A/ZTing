//
//  EditViewController.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

@protocol EditInfoCompleteDelegate <NSObject>

- (void)editInfoComplete;

@end

#import "ZTBaseViewCtrl.h"
#import "UserInfoModel.h"

@interface EditViewController : UITableViewController

@property (nonatomic, retain) UserInfoModel *userInfoModel;
@property (nonatomic, assign) id<EditInfoCompleteDelegate> delegate;

@end
