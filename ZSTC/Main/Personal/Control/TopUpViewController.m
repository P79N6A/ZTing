//
//  TopUpViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "TopUpViewController.h"

@interface TopUpViewController ()
{
    __weak IBOutlet UITextField *_topupAccountTF;
    __weak IBOutlet UIView *_ailiPayView;
    __weak IBOutlet UIButton *_ailiSelBt;
    __weak IBOutlet UIView *_weChatPayView;
    __weak IBOutlet UIButton *_weChatSelBt;

    
    __weak IBOutlet UIButton *_topupBt;
}
@end

@implementation TopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
}

- (void)_initView {
    UITapGestureRecognizer *ailiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ailiSel)];
    _ailiPayView.userInteractionEnabled = YES;
    [_ailiPayView addGestureRecognizer:ailiTap];
    
    UITapGestureRecognizer *weChatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatSel)];
    _weChatPayView.userInteractionEnabled = YES;
    [_weChatPayView addGestureRecognizer:weChatTap];
    
    _topupBt.layer.masksToBounds = YES;
    _topupBt.layer.cornerRadius = 4;
    _topupBt.backgroundColor = MainColor;
}

#pragma mark 选择支付方式
- (IBAction)ailiSel {
    _ailiSelBt.selected = YES;
    _weChatSelBt.selected = NO;
}

- (IBAction)weChatSel {
    _ailiSelBt.selected = NO;
    _weChatSelBt.selected = YES;
}


#pragma mark 充值
- (IBAction)topupAction {
    if(_topupAccountTF.text == nil || _topupAccountTF.text.length <= 0){
        [self showHint:@"请输入充值金额"];
        return;
    }
    
    NSString *payMoney = [NSString stringWithFormat:@"%.0f", _topupAccountTF.text.floatValue * 100];
    
    NSString *topupUrl = [NSString stringWithFormat:@"%@account/memberRecharge", KDomain];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:payMoney forKey:@"payMoney"];
    
    [[ZTNetworkClient sharedInstance] GET:topupUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            
            NSLog(@"%@", responseObject);
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    if(_ailiSelBt.selected){
        // 支付宝
        
        
    }else {
        // 微信
        
        
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
