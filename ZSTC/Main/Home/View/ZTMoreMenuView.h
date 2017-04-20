//
//  ZTMoreMenuView.h
//  ZSTC
//
//  Created by 焦平 on 2017/3/22.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviCommonObj.h>

@protocol MoreMenuViewDelegate;

@interface ZTMoreMenuView : UIView

@property (nonatomic, assign) id<MoreMenuViewDelegate> delegate;

@property (nonatomic, assign) AMapNaviViewTrackingMode trackingMode;
@property (nonatomic, assign) BOOL showNightType;

@end

@protocol MoreMenuViewDelegate <NSObject>
@optional

- (void)moreMenuViewFinishButtonClicked;
- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode;
- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType;

@end
