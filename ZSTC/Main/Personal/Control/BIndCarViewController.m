//
//  BIndCarViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/17.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BIndCarViewController.h"
#import <IQKeyboardManager.h>

@interface BIndCarViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITextField *_provinceTF;
    __weak IBOutlet UITextField *_letterTF;
    __weak IBOutlet UITextField *_numTF;
    __weak IBOutlet UILabel *_typeLabel;
    __weak IBOutlet UITextField *_nickTF;

    __weak IBOutlet UIButton *_addBt;
    
    UIView *_carTypeView;
    NSString *_carType;     // 车牌类型(1-小型车，2-中型车，3-大型车，4-电动车，5-摩托车)
}
@end

@implementation BIndCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _carType = @"1";
    
    [self _initView];
}

- (void)_initView {
    _addBt.layer.masksToBounds = YES;
    _addBt.layer.cornerRadius = 4;
    
    [_provinceTF becomeFirstResponder];
    _provinceTF.delegate = self;
    _letterTF.delegate = self;
    _numTF.delegate = self;
    
    self.title = @"添加车辆";
    
    UITapGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeAction)];
    _typeLabel.userInteractionEnabled = YES;
    [_typeLabel addGestureRecognizer:typeTap];
    
    _carTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _carTypeView.hidden = YES;
    _carTypeView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [self.view addSubview:_carTypeView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidCarTypeView)];
//    _carTypeView.userInteractionEnabled = YES;
//    [_carTypeView addGestureRecognizer:tap];
    
    UITableView *typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(_typeLabel.left, 180, _typeLabel.width, 120) style:UITableViewStylePlain];
    typeTableView.delegate = self;
    typeTableView.dataSource = self;
//    typeTableView.backgroundColor = MainColor;
    typeTableView.scrollEnabled = NO;
    [_carTypeView addSubview:typeTableView];
    
}

- (void)typeAction {
    [self.view endEditing:YES];
    _carTypeView.hidden = NO;
}

#pragma mark 新增车辆
- (IBAction)addAction:(id)sender {
    if(_provinceTF.text == nil && _provinceTF.text.length <= 0){
        [self showHint:@"请检查车牌号码"];
        return;
    }
    if(_letterTF.text == nil && _letterTF.text.length <= 0){
        [self showHint:@"请检查车牌号码"];
        return;
    }
    if(_provinceTF.text == nil && _provinceTF.text.length < 5){
        [self showHint:@"请检查车牌号码"];
        return;
    }
    
    NSString *carNum = [NSString stringWithFormat:@"%@%@%@", _provinceTF.text, _letterTF.text, _numTF.text];
    
    NSString *addCarUrl = [NSString stringWithFormat:@"%@member/addMemberCar", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:carNum forKey:@"carNo"];
    [params setObject:_carType forKey:@"carType"];
    if(_nickTF.text != nil && _nickTF.text.length > 0){
        [params setObject:_nickTF.text forKey:@"carNike"];
    }
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:addCarUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if(responseObject[@"success"]){
            [self.navigationController popViewControllerAnimated:YES];
            // 发送添加车辆成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KAddCarNotification object:nil];
        }
        [self showHint:responseObject[@"message"]];
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)hidCarTypeView {
    _carTypeView.hidden = YES;
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField == _provinceTF && text.length > 1){
        [textField resignFirstResponder];
        [_letterTF becomeFirstResponder];
//        return NO;
    }
    
    if(textField == _letterTF && text.length > 1){
        [textField resignFirstResponder];
        [_numTF becomeFirstResponder];
//        return NO;
    }
    
    if(textField == _numTF && text.length > 5){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark UItableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carTypeCell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"小型车";
            break;
        
        case 1:
            cell.textLabel.text = @"中型车";
            break;
            
        case 2:
            cell.textLabel.text = @"大型车";
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _carTypeView.hidden = YES;
    switch (indexPath.row) {
        case 0:
            _carType = @"1";
            _typeLabel.text = @"小型车";
            break;
            
        case 1:
            _carType = @"2";
            _typeLabel.text = @"中型车";
            break;
            
        case 2:
            _carType = @"3";
            _typeLabel.text = @"大型车";
            break;
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
