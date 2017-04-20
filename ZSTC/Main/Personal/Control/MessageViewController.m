//
//  MessageViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "MessageViewController.h"
#import "InOutTableViewController.h"
#import "CountTableViewController.h"
#import "PropertyTableViewController.h"
#import "DiscountTableViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (instancetype)init {
    self = [super initWithViewControllerClasses:@[[InOutTableViewController class], [CountTableViewController class], [PropertyTableViewController class], [DiscountTableViewController class] ] andTheirTitles:@[@"进出场", @"账户", @"资产", @"优惠"]];
    if(self){
        [self _initView];
    }
    return self;
}
- (void)_initView {
    self.menuHeight = 50;   // page导航栏高度
    
    self.titleColorSelected = MainColor;    // 标题选中颜色
    
    self.titleSizeNormal = 16;  // 未选中字体大小
    self.titleSizeSelected = 16;    // 选中字体大小
    
    self.menuBGColor = [UIColor whiteColor];
    self.menuViewStyle = WMMenuViewStyleLine;   // 下方进度模式
    self.progressWidth = KScreenWidth/4 + 20;    // 下方进度条宽度
    self.progressHeight = 4;    // 下方进度条高度
    self.menuViewBottomSpace = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.menuHeight, KScreenWidth, 1)];
    lineView.backgroundColor = MainColor;
    [self.menuView addSubview:lineView];
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
