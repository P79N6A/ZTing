//
//  MoneyViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "MoneyViewController.h"
#import "BillViewController.h"
#import "TopUpViewController.h"

@interface MoneyViewController ()
{
    __weak IBOutlet UIView *_topView;
    __weak IBOutlet UIView *_fullView;
    __weak IBOutlet UIView *_takeView;

    __weak IBOutlet UILabel *_accountLabel;
}
@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包";
    
    [self _initView];
    
    [self _loadData];
}

- (void)_initView {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(billAction)];
    
    _topView.backgroundColor = MainColor;
    
    UITapGestureRecognizer *fullTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullAction)];
    _fullView.userInteractionEnabled = YES;
    [_fullView addGestureRecognizer:fullTap];
    _fullView.layer.borderWidth = 0.5;
    _fullView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UITapGestureRecognizer *takeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeAction)];
    _takeView.userInteractionEnabled = YES;
    [_takeView addGestureRecognizer:takeTap];
    _takeView.layer.borderWidth = 0.5;
    _takeView.layer.borderColor = [[UIColor grayColor] CGColor];
    
}

- (void)_loadData {
    NSString *accountUrl = [NSString stringWithFormat:@"%@pay/getMemberAccount", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [[ZTNetworkClient sharedInstance] POST:accountUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            float account = [responseObject[@"accountBalanceAmt"] floatValue]/100;
            _accountLabel.text = [NSString stringWithFormat:@"%.2f", account];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 明细
- (void)billAction {
    BillViewController *billVC = [[BillViewController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}

#pragma mark 充值
- (void)fullAction {
    TopUpViewController *topupVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TopUpViewController"];
    [self.navigationController pushViewController:topupVC animated:YES];
}

#pragma mark 取钱
- (void)takeAction {
    [self showHint:@"敬请期待"];
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
