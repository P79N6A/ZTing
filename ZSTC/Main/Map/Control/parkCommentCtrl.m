//
//  parkCommentCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "parkCommentCtrl.h"
#import "CWStarRateView.h"
#import "ZTCustomTextView.h"
#import "LoginViewController.h"

@interface parkCommentCtrl ()<CWStarRateViewDelegate>
{
    CGFloat totalScore;
    CGFloat parkEnvironmentScore;
    CGFloat parkPriceScore;
    CGFloat parkServiceScore;
}

@property (nonatomic,strong) UILabel *overallratingLab;
@property (nonatomic,strong) CWStarRateView *overallratingStarView;
@property (nonatomic,strong) UILabel *parkEnvironmentLab;
@property (nonatomic,strong) CWStarRateView *parkEnvironmentStarView;
@property (nonatomic,strong) UILabel *parkPriceLab;
@property (nonatomic,strong) CWStarRateView *parkPriceStarView;
@property (nonatomic,strong) UILabel *parkServiceLab;
@property (nonatomic,strong) CWStarRateView *parkServiceStarView;

@property (nonatomic,strong) ZTCustomTextView *commentTextView;
@property (nonatomic,strong) UIButton *determineBtn;

@end

@implementation parkCommentCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initView];
}

-(void)_initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"添加评论";
    // 设置返回按钮
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    UILabel *overallratingLab = [[UILabel alloc] init];
    self.overallratingLab = overallratingLab;
    overallratingLab.font = [UIFont boldSystemFontOfSize:16];
    overallratingLab.textColor = color(60, 60, 60, 1);
    overallratingLab.textAlignment = NSTextAlignmentCenter;
    overallratingLab.text = @"综合评分";
    [self.view addSubview:overallratingLab];
    
    CWStarRateView *overallratingStarView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 120, 40) numberOfStars:5];
    self.overallratingStarView = overallratingStarView;
    overallratingStarView.tag = 100;
    overallratingStarView.scorePercent = 0;
    overallratingStarView.allowIncompleteStar = NO;
    overallratingStarView.hasAnimation = YES;
    overallratingStarView.delegate = self;
    [self.view addSubview:overallratingStarView];
    
    UILabel *parkEnvironmentLab = [[UILabel alloc] init];
    parkEnvironmentLab.font = [UIFont systemFontOfSize:14];
    parkEnvironmentLab.textColor = color(159, 159, 159, 1);
    parkEnvironmentLab.textAlignment = NSTextAlignmentCenter;
    parkEnvironmentLab.text = @"停车环境";
    self.parkEnvironmentLab = parkEnvironmentLab;
    [self.view addSubview:parkEnvironmentLab];
    
    CWStarRateView *parkEnvironmentStarView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 30) numberOfStars:5];
    self.parkEnvironmentStarView = parkEnvironmentStarView;
    parkEnvironmentStarView.tag = 110;
    parkEnvironmentStarView.delegate = self;
    parkEnvironmentStarView.scorePercent = 0;
    parkEnvironmentStarView.allowIncompleteStar = NO;
    parkEnvironmentStarView.hasAnimation = YES;
    [self.view addSubview:parkEnvironmentStarView];
    
    UILabel *parkPriceLab = [[UILabel alloc] init];
    parkPriceLab.font = [UIFont systemFontOfSize:14];
    parkPriceLab.textColor = color(159, 159, 159, 1);
    parkPriceLab.textAlignment = NSTextAlignmentCenter;
    parkPriceLab.text = @"停车价格";
    self.parkPriceLab = parkPriceLab;
    [self.view addSubview:parkPriceLab];
    
    CWStarRateView *parkPriceStarView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 30) numberOfStars:5];
    self.parkPriceStarView = parkPriceStarView;
    parkPriceStarView.tag = 120;
    parkPriceStarView.delegate = self;
    parkPriceStarView.scorePercent = 0;
    parkPriceStarView.allowIncompleteStar = NO;
    parkPriceStarView.hasAnimation = YES;
    [self.view addSubview:parkPriceStarView];

    UILabel *parkServiceLab = [[UILabel alloc] init];
    parkServiceLab.font = [UIFont systemFontOfSize:14];
    parkServiceLab.textColor = color(159, 159, 159, 1);
    parkServiceLab.textAlignment = NSTextAlignmentCenter;
    parkServiceLab.text = @"停车服务";
    self.parkServiceLab = parkServiceLab;
    [self.view addSubview:parkServiceLab];
    
    CWStarRateView *parkServiceStarView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 30) numberOfStars:5];
    self.parkServiceStarView = parkServiceStarView;
    parkServiceStarView.tag = 130;
    parkServiceStarView.delegate = self;
    parkServiceStarView.scorePercent = 0;
    parkServiceStarView.allowIncompleteStar = NO;
    parkServiceStarView.hasAnimation = YES;
    [self.view addSubview:parkServiceStarView];
    
    ZTCustomTextView *commentTextView = [[ZTCustomTextView alloc] init];
    self.commentTextView = commentTextView;
    commentTextView.layer.cornerRadius = 2;
    commentTextView.layer.borderWidth = 1;
    commentTextView.layer.borderColor = color(237, 237, 237, 1).CGColor;
    commentTextView.placeholder = @"请输入评论内容";
    commentTextView.placeholderColor = color(159, 159, 159, 1);
    commentTextView.font = [UIFont systemFontOfSize:14];
    commentTextView.textColor = color(179, 179, 179, 1);
    [self.view addSubview:commentTextView];

    UIButton *determineBtn = [[UIButton alloc] init];
    [determineBtn addTarget:self action:@selector(determineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.determineBtn = determineBtn;
    determineBtn.backgroundColor = MainColor;
    [determineBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    determineBtn.layer.cornerRadius = 3;
    [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:determineBtn];
    
    CGSize overallRatingSize = [_overallratingLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    self.overallratingLab.sd_layout
    .topSpaceToView(self.view, 94)
    .leftSpaceToView(self.view, 80)
    .widthIs(overallRatingSize.width)
    .heightIs(overallRatingSize.height);
    
    overallratingStarView.sd_layout
    .leftSpaceToView(overallratingLab, 15)
    .topSpaceToView(self.view, 94 - (40 - overallratingLab.height)/2)
    .widthIs(120)
    .heightIs(40);
    
    CGSize parkEnvironmentSize = [_overallratingLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.parkEnvironmentLab.sd_layout
    .topSpaceToView(_overallratingLab, 40)
    .leftSpaceToView(self.view, 100)
    .widthIs(parkEnvironmentSize.width)
    .heightIs(parkEnvironmentSize.height);
    
    parkEnvironmentStarView.sd_layout
    .leftSpaceToView(parkEnvironmentLab, 15)
    .topSpaceToView(_overallratingLab, 40 - (30 - parkEnvironmentLab.height)/2)
    .widthIs(80)
    .heightIs(30);
    
    CGSize parkPriceSize = [_overallratingLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.parkPriceLab.sd_layout
    .topSpaceToView(_parkEnvironmentLab, 30)
    .leftSpaceToView(self.view, 100)
    .widthIs(parkPriceSize.width)
    .heightIs(parkPriceSize.height);
    
    parkPriceStarView.sd_layout
    .leftSpaceToView(parkPriceLab, 15)
    .topSpaceToView(_parkEnvironmentLab, 30 - (30 - parkPriceLab.height)/2)
    .widthIs(80)
    .heightIs(30);

    CGSize parkServiceSize = [_overallratingLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.parkServiceLab.sd_layout
    .topSpaceToView(_parkPriceLab, 30)
    .leftSpaceToView(self.view, 100)
    .widthIs(parkServiceSize.width)
    .heightIs(parkServiceSize.height);
    
    parkServiceStarView.sd_layout
    .leftSpaceToView(parkServiceLab, 15)
    .topSpaceToView(_parkPriceLab, 30 - (30 - parkServiceLab.height)/2)
    .widthIs(80)
    .heightIs(30);
    
    self.commentTextView.sd_layout
    .topSpaceToView(parkServiceLab, 25)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(150);
    
    determineBtn.sd_layout
    .bottomSpaceToView(self.view, 20)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(35);

}

#pragma mark 星星视图代理
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    if (starRateView.tag == 100) {
        totalScore = newScorePercent*5;
    }else if (starRateView.tag == 110){
        parkEnvironmentScore = newScorePercent*5;
    }else if (starRateView.tag == 120){
        parkPriceScore = newScorePercent*5;
    }else
    {
        parkServiceScore = newScorePercent*5;
    }
}

#pragma mark 提交评论

-(void)determineBtnAction:(UIButton *)sender
{
    [self showHudInView:self.view hint:@""];
    if (![TheUserDefaults boolForKey:KLoginState]) {
        LoginViewController *loginViewCtrl = [[LoginViewController alloc] init];
        [self presentViewController:loginViewCtrl animated:YES completion:nil];
        return;
    }
    
    NSString *commentUrl = [NSString stringWithFormat:@"%@comment/addComment",KDomain];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setValue:KMemberId forKey:@"memberId"];
    [params setValue:KToken forKey:@"token"];
    [params setValue:self.parkId forKey:@"parkId"];
    [params setValue:[NSString stringWithFormat:@"%.f",parkEnvironmentScore] forKey:@"commentScore1"];
    [params setValue:[NSString stringWithFormat:@"%.f",parkPriceScore] forKey:@"commentScore3"];
    [params setValue:[NSString stringWithFormat:@"%.f",parkServiceScore] forKey:@"commentScore2"];
    [params setValue:[NSString stringWithFormat:@"%.f",totalScore] forKey:@"commentTotal"];
    [params setValue:_commentTextView.text forKey:@"commentContent"];
    
    [[ZTNetworkClient sharedInstance] POST:commentUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        
//        NSLog(@"%@",responseObject);
        if([responseObject[@"success"] boolValue]){
            [self hideHud];
            [self showHint:@"感谢您的评价"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self showHint:@"网络状况差，请重新发送"];
    }];
    
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
