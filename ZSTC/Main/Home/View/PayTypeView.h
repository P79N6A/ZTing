//
//  PayTypeView.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

typedef enum {
    AccountPay = 0,
    AliPay,
    WeChatPay
}PayType;

#import <UIKit/UIKit.h>

@protocol SelPayDelegate <NSObject>

- (void)selPay:(PayType)payType;

@end

@interface PayTypeView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<SelPayDelegate> delegate;

@end
