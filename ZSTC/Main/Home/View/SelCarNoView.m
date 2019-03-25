//
//  SelCarNoView.m
//  ZSTC
//
//  Created by coder on 2018/11/8.
//  Copyright © 2018年 HNZT. All rights reserved.
//

#import "SelCarNoView.h"
#import "CarCell.h"
#import "BindCarModel.h"

#define KColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LineColor                KColorFromRGB(0xefefef)
#define CColor                   KColorFromRGB(0x666666)
#define DColor                   KColorFromRGB(0x999999)
#define RemindRedColor           KColorFromRGB(0xF05F50)

@interface SelCarNoView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray *dataArr;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *sureBtn;
@property (nonatomic ,strong) UIViewController *vc;

@property (nonatomic ,copy) NSString *totalBalance;

@end

@implementation SelCarNoView

- (instancetype)initTotalPay:(NSString *)totalBalance vc:(UIViewController *)vc dataSource:(NSArray *)dataSource{
    if (self = [super init]) {
        self.vc = vc;
        self.totalBalance = totalBalance;
        self.dataArr = dataSource;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initPop];
    [self setUpUI];
}

- (void)initPop {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = 60;
    height += self.dataArr.count * 60;
    self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, height);
    self.popupController.navigationBarHidden = YES;
    [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
}

-(void)closeBlockView {
    [self backgroundTap];
}

- (void)backgroundTap  {
    [self.popupController dismiss];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"CarCell" bundle:nil] forCellReuseIdentifier:@"CarCell"];
        [self.view addSubview:_tableView];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        v.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, 1)];
        line.backgroundColor = LineColor;
        [v addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-30, 50)];
        label.centerX = KScreenWidth/2;
        label.textAlignment = 0;
        label.text = [NSString stringWithFormat:@"选择车辆"];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = CColor;
        label.numberOfLines = 1;
        [v addSubview:label];
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"pay_close"] forState:UIControlStateNormal];
        xButton.frame = CGRectMake(KScreenWidth - 35, 11, 22, 22);
        [v addSubview:xButton];
        [xButton addTarget:self action:@selector(backgroundTap) forControlEvents:UIControlEventTouchUpInside];

        _tableView.tableHeaderView = v;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"CarCell"];
    CarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [self configCell:cell data:[self.dataArr objectAtIndex:indexPath.row] indexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.SelCarNum) {
        BindCarModel *model = [self.dataArr objectAtIndex:indexPath.row];
        self.SelCarNum([NSString stringWithFormat:@"%@",model.carNo]);
        [self backgroundTap];
    }
}

- (void)configCell:(CarCell *)cell data:(BindCarModel *)model indexPath:(NSIndexPath *)indexPath{

    BindCarModel *currentModel = model;
    if (![currentModel.carNike isKindOfClass:[NSNull class]]) {
        cell.carNameLabel.text = currentModel.carNike;
    }else{
        cell.carNameLabel.text = @"";
    }
    
    cell.carNoLabel.text = [NSString stringWithFormat:@"%@",currentModel.carNo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
