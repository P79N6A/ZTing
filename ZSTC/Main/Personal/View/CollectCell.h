//
//  CollectCell.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"

@protocol ParkDelegate <NSObject>

- (void)routePark:(NSString *)parkId;
- (void)navPark:(NSString *)parkId;

@end

@interface CollectCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_parkImageView;
    __weak IBOutlet UILabel *_parkLabel;
    __weak IBOutlet UILabel *_numLabel;
    __weak IBOutlet UILabel *_costLabel;
 
    __weak IBOutlet UIButton *_routeBt;
    __weak IBOutlet UIButton *_navBt;
    
    __weak IBOutlet NSLayoutConstraint *_routeBtWidth;  // 路线按钮宽度约束
    __weak IBOutlet NSLayoutConstraint *_navBtWidth;    // 导航按钮宽度约束
    
}

@property (nonatomic, retain) CollectModel *collectModel;
@property (nonatomic, assign) id<ParkDelegate> delegate;

@end
