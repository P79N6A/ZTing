//
//  SetNickViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "SetNickViewController.h"

@interface SetNickViewController ()

@end

@implementation SetNickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    
    [self _initView];
}

- (void)_initView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNick)];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 40, 40)];
    textField.tag = 101;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = _nick;
    [self.view addSubview:textField];
    
    [textField becomeFirstResponder];
}

- (void)saveNick {
    [self.view endEditing:YES];
    UITextField *textField = [self.view viewWithTag:101];
    if(textField.text != nil && textField.text.length > 0){
        [_delegate updateNickComplete:textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self showHint:@"昵称不能为空"];
    }
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
