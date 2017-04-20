//
//  UIView+ViewControllerRespond.m
//  ChatDemo-UI2.0
//
//  Created by mac  on 15/12/6.
//  Copyright © 2015年 mac . All rights reserved.
//

#import "UIView+ViewControllerRespond.h"

@implementation UIView (ViewControllerRespond)
- (UIViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if([next isKindOfClass:[UIViewController class]]){
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}
@end
