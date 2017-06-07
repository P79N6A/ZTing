//
//  LoginViewController.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "LoginViewController.h"
#import "PersonalViewController.h"
#import "LoginModel.h"

@interface LoginViewController ()<MBProgressHUDDelegate>

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UITextField *accountTextField;

@property (nonatomic,strong) UITextField *passWordTextField;

@property (nonatomic,strong) UIButton *getVerifyCodeBtn;

@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) Boolean isError;
@property (nonatomic,assign) int seconds;

@property (nonatomic,copy) NSString *checktoken;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(10, 20, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    [self loadSubViews];
}

-(void)loadSubViews
{
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"icon_user_head"];
    self.iconView = iconView;
    iconView.layer.cornerRadius = 80/2;
    [self.view addSubview:iconView];
    
    self.iconView.sd_layout
    .topSpaceToView(self.view,74)
    .centerXIs(KScreenWidth/2)
    .widthIs(80)
    .heightIs(80);

    
    UITextField *accountTextField = [[UITextField alloc] init];
    accountTextField.layer.borderColor = color(219, 219, 219, 1).CGColor;
    accountTextField.layer.borderWidth = 0.5;
    accountTextField.font = [UIFont systemFontOfSize:14];
    accountTextField.placeholder = @"请输入手机号";
    self.accountTextField = accountTextField;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    accountTextField.leftView = leftView;
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:accountTextField];
    
    self.accountTextField.sd_layout
    .topSpaceToView(self.iconView,35)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(45);

    
    UITextField *passWordTextField = [[UITextField alloc] init];
    passWordTextField.layer.borderColor = color(219, 219, 219, 1).CGColor;
    passWordTextField.layer.borderWidth = 0.5;
    passWordTextField.font = [UIFont systemFontOfSize:14];
    passWordTextField.placeholder = @"请输入验证码";
    passWordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passWordTextField = passWordTextField;
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    passWordTextField.leftView = leftView1;
    passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passWordTextField];
    
    self.passWordTextField.sd_layout
    .topSpaceToView(self.accountTextField,0)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 100)
    .heightIs(45);

    
    UIButton *getVerifyCodeBtn = [[UIButton alloc] init];
    [getVerifyCodeBtn addTarget:self action:@selector(getVerifyCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [getVerifyCodeBtn setTitle:@"发送" forState:UIControlStateNormal];
    [getVerifyCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [getVerifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getVerifyCodeBtn setBackgroundColor:MainColor];
    self.getVerifyCodeBtn = getVerifyCodeBtn;
    [self.view addSubview:getVerifyCodeBtn];
    
    self.getVerifyCodeBtn.sd_layout
    .topSpaceToView(self.accountTextField, 0)
    .leftSpaceToView(self.passWordTextField, 0)
    .rightSpaceToView(self.view, 15)
    .heightIs(45);
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:MainColor];
    loginBtn.layer.cornerRadius = 3;
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    
    self.loginBtn.sd_layout
    .topSpaceToView(self.passWordTextField, 30)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(45);

    
}

-(void)getVerifyCodeBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.accountTextField.text.length != 0&&![Utils valiMobile:self.accountTextField.text]) {
        
        [Utils alertTitle:@"提示" message:@"手机号码格式不正确" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        
        return;
    }else if (self.accountTextField.text.length == 0) {
        
        [Utils alertTitle:@"提示" message:@"手机号码不能为空" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@member/login/sendMsg",KDomain];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.accountTextField.text forKey:@"phone"];
    
    [self startTimer];
    
    [[ZTNetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"success"] boolValue]) {
            NSDictionary *dataDic = responseObject[@"data"];
            _checktoken = dataDic[@"checktoken"];
        }
        [self showHint:responseObject[@"message"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showHint:@"网络不给力,请稍后重试!"];
    }];
    
}

-(void)startTimer
{
    _seconds = 60;            // 倒计时秒
    [self hiddenKeyBoard];     // 隐藏键盘
    self.getVerifyCodeBtn.enabled = NO; // 在倒计时的时候禁用按钮
    self.getVerifyCodeBtn.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    [self.getVerifyCodeBtn setTitle:@"60 s" forState:UIControlStateNormal];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
     
                                     target:self
     
                                   selector:@selector(handleTimer:)
     
                                   userInfo:nil
     
                                    repeats:YES];
}

/** 定时器回调 */
- (void)handleTimer:(NSTimer *)timer {
    _timer = timer;
    if (_seconds > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _getVerifyCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%i s", _seconds];
        });
        
        if (_isError) {
            [self stopCountdown];
        }
        _seconds--;
    } else {
        // 结束定时器
        [self stopCountdown];
    }
}

- (void)stopCountdown {
    [_timer invalidate];
    _timer = nil;
    _isError = NO;
    _getVerifyCodeBtn.enabled = YES;
    [_getVerifyCodeBtn setBackgroundColor:MainColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_getVerifyCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    });
}

//隐藏键盘
- (void)hiddenKeyBoard {
    
    [self allEditActionsResignFirstResponder];
}

- (void)allEditActionsResignFirstResponder{
    
    //手机
    [_accountTextField resignFirstResponder];
    
}

-(void)loginBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.accountTextField.text.length != 0&&![Utils valiMobile:self.accountTextField.text]) {
        
        [Utils alertTitle:@"提示" message:@"手机号码格式不正确" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        
        return;
    }else if (self.accountTextField.text.length == 0) {
        
        [Utils alertTitle:@"提示" message:@"手机号码不能为空" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        
        return;
    }else if(self.passWordTextField.text.length == 0){
        [Utils alertTitle:@"提示" message:@"请输入验证码" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        
        return;
    }
    
    //显示加载等待框
    [self showHudInView:self.view hint:@""];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]* 1000];
    
    NSString *uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@member/login/phoneLogin",KDomain];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.accountTextField.text forKey:@"phone"];
    [params setValue:self.passWordTextField.text forKey:@"checkNum"];
    [params setValue:_checktoken forKey:@"checktoken"];
    [params setValue:timeSp forKey:@"ts"];
    [params setValue:@"01" forKey:@"income"];
    [params setValue:uuidStr forKey:@"guid"];
    
    [[ZTNetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud]; // 隐藏加载框
//        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"success"] boolValue]) {
            NSDictionary *dataDic = responseObject[@"data"];
            NSDictionary *memberDic = dataDic[@"member"];
            
            LoginModel *model = [[LoginModel alloc] initWithDataDic:memberDic];
            
            [TheUserDefaults setValue:model.memberId forKey:@"memberId"];
            [TheUserDefaults setValue:dataDic[@"token"] forKey:@"token"];
            [TheUserDefaults setBool:YES forKey:KLoginState];
            [TheUserDefaults synchronize];
            [self MemberEquid];
            
            // 发送登录完成通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KLoginNotification object:nil];
        }else
        {
            [self showHint:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [self hideHud]; // 隐藏加载框
    }];
}

-(void)MemberEquid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@member/login/setMemberEquid",KDomain];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:KMemberId forKey:@"memberId"];
    [params setValue:[TheUserDefaults objectForKey:@"registrationID"] forKey:@"equid"];
    [params setValue:@"1" forKey:@"pushEquipType"];
    [params setValue:KToken forKey:@"token"];
    
    [[ZTNetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        [self hideHud]; // 隐藏加载框
        
//        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"success"] boolValue]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        [self hideHud]; // 隐藏加载框
    }];
}

-(void)backBtnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
