//
//  TopUpViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "TopUpViewController.h"
#import "RechageModel.h"
#import "ZTAliPay.h"
#import "WXApi.h"
#import "ZTWeChatPayTools.h"

@interface TopUpViewController ()
{
    __weak IBOutlet UITextField *_topupAccountTF;
    __weak IBOutlet UIView *_ailiPayView;
    __weak IBOutlet UIButton *_ailiSelBt;
    __weak IBOutlet UIView *_weChatPayView;
    __weak IBOutlet UIButton *_weChatSelBt;

    
    __weak IBOutlet UIButton *_topupBt;
    
    RechageModel *_rechageModel;
}
@end

@implementation TopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
}

- (void)_initView {
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    UITapGestureRecognizer *ailiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ailiSel)];
    _ailiPayView.userInteractionEnabled = YES;
    [_ailiPayView addGestureRecognizer:ailiTap];
    
    UITapGestureRecognizer *weChatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatSel)];
    _weChatPayView.userInteractionEnabled = YES;
    [_weChatPayView addGestureRecognizer:weChatTap];
    
    _topupBt.layer.masksToBounds = YES;
    _topupBt.layer.cornerRadius = 4;
    _topupBt.backgroundColor = MainColor;
    
    self.title = @"充值";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipaySuccess:) name:@"alipaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayfa) name:@"alipayfa" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayDidntFinsh) name:@"alipayDidntFinsh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNetWor) name:@"alipayNetWor" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipaySuccess:) name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatF) name:@"wechatPayFalu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidntFinsh) name:@"wechatPaydidntFinsh" object:nil];
}

-(void)hudHud
{
    [self hideHud];
}

-(void)alipaySuccess:(id)sender
{
    [self hudHud];
//    RechageSuccessCtrl *rechageSuccessCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RechageSuccessCtrl"];
//    rechageSuccessCtrl.orderId = _rechageModel.orderId;
//    [self.navigationController pushViewController:rechageSuccessCtrl animated:YES];
    UIViewController *rechageSuccessCtrl = [[UIViewController alloc] init];
    [self.navigationController pushViewController:rechageSuccessCtrl animated:YES];
    
}

#pragma mark 微信支付失败
-(void)wechatF
{
    [self hudHud];
    [self showHint:@"微信支付失败"];
}

#pragma mark 微信支付用户退出支付  支付失败
-(void)wechatDidntFinsh
{
    [self hudHud];
    [self showHint:@"您取消了支付！"];
}

#pragma mark 支付宝支付失败
-(void)alipayfa
{
    [self hudHud];
    [self showHint:@"支付失败，请重新尝试！"];
}

-(void)alipayDidntFinsh
{
    [self hudHud];
    [self showHint:@"您取消了支付！"];
}

-(void)alipayNetWor
{
    [self hudHud];
    [self showHint:@"网络连接出错！"];
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
    
    NSString *topupUrl = [NSString stringWithFormat:@"%@pay/memberRecharge", KDomain];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:payMoney forKey:@"payMoney"];
    
    [[ZTNetworkClient sharedInstance] POST:topupUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            
            NSLog(@"%@", responseObject);
            _rechageModel = [[RechageModel alloc] init];
            _rechageModel.orderId = responseObject[@"orderId"];
            [self showHudInView:self.view hint:@""];
            
            if(_ailiSelBt.selected){
                // 支付宝
                if(_rechageModel.orderId != nil && ![_rechageModel.orderId isKindOfClass:[NSNull class]] && _rechageModel.orderId.length > 0){
                    [ZTAliPay aliPayWithOrderId:_rechageModel.orderId withComplete:^(NSString *stateCode) {
                        [self hideHud];
                        if([stateCode isEqualToString:@"6001"]){
                            [self showHint:@"您取消了支付"];
                        }
                    }];
                }
                
            }else {
                // 微信
                if(_rechageModel.orderId != nil && ![_rechageModel.orderId isKindOfClass:[NSNull class]] && _rechageModel.orderId.length > 0){
                    if([WXApi isWXAppInstalled]){
                        [ZTWeChatPayTools weChatPayWithOrderId:_rechageModel.orderId];
                    }else {
                        [self hideHud];
                        [self showHint:@"未安装微信应用"];
                    }
                }
                
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alipaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPayFalu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPaydidntFinsh" object:nil];
    
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
