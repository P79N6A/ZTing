//
//  PaySucViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/25.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "PaySucViewController.h"

@interface PaySucViewController ()

@end

@implementation PaySucViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自助缴费";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
