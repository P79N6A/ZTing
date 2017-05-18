//
//  ZTBaseNavCtrl.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTBaseNavCtrl.h"

@interface ZTBaseNavCtrl ()

@end

@implementation ZTBaseNavCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = MainColor;
    bar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
