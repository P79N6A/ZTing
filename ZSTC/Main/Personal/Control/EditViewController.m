//
//  EditViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

typedef enum {
    HeadSheet = 0,
    SexSheet
}SelectSheetType;

#import "EditViewController.h"

#import "SetNickViewController.h"

@interface EditViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UpdateNickCompleteDelegate>
{
    __weak IBOutlet UIImageView *_headImgView;
    __weak IBOutlet UILabel *_nickLabel;
    __weak IBOutlet UILabel *_numLabel;
    __weak IBOutlet UILabel *_sexLabel;
    __weak IBOutlet UILabel *_birthLabel;

    UIView *_dateView;
}
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    [self _initView];
    
    [self _createView];
}

- (void)_initView {
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = _headImgView.height/2;
    
    self.tableView.tableFooterView = [[UIView alloc] init]; // 去除无数据cell 下划线
    
    if(_userInfoModel.memberPhotoUrl != nil && ![_userInfoModel.memberPhotoUrl isKindOfClass:[NSNull class]] && _userInfoModel.memberPhotoUrl.length > 0){
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.memberPhotoUrl]];
    }
    
    _nickLabel.text = _userInfoModel.memberNikename;
    
    _numLabel.text = _userInfoModel.memberPhone;
    
    NSString *sexStr = @"";
    if([_userInfoModel.memberSex isEqualToString:@"0"]){
        sexStr = @"男";
    }else if([_userInfoModel.memberSex isEqualToString:@"1"]) {
        sexStr = @"女";
    }
    _sexLabel.text = sexStr;
    
    _birthLabel.text = _userInfoModel.memberBirthday;
    
}

#pragma mark 创建日期选择视图
- (void)_createView {
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _dateView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    _dateView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateCancel)];
    _dateView.userInteractionEnabled = YES;
    [_dateView addGestureRecognizer:tap];
    [self.view addSubview:_dateView];
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, _dateView.height - 160, _dateView.width, 160)];
    pickerView.tag = 101;
    pickerView.datePickerMode = UIDatePickerModeDate;
//    if(_userInfoModel.memberBirthday != nil){
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *date = [formatter dateFromString:_userInfoModel.memberBirthday];
//        pickerView.date = date;
//    }else {
        pickerView.date = [NSDate date];
//    }
    [_dateView addSubview:pickerView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, pickerView.top - 40, _dateView.width, 40)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    toolbar.barTintColor = [UIColor lightGrayColor];
    toolbar.translucent = YES;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dateCancel)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:KScreenWidth - 110];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dateDone)];
    toolbar.items = @[cancelItem,spaceButtonItem, doneItem];
    [_dateView addSubview:toolbar];
    
}

#pragma mark tableview 协议
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self alertHeadSheet:@"提示" withMessage:@"请选择图片来源" withOneItem:@"相册" withTwoItem:@"拍照" withSelTyep:HeadSheet];
            break;
            
        case 1:
            [self nickAction];
            break;
            
        case 3:
            [self alertHeadSheet:@"提示" withMessage:@"性别" withOneItem:@"男" withTwoItem:@"女" withSelTyep:SexSheet];
            break;
            
        case 4:
            [self birthAction];
            break;
            
    }
    
}

#pragma mark 选择头像/设置性别
- (void)alertHeadSheet:(NSString *)title withMessage:(NSString *)message withOneItem:(NSString *)oneItem withTwoItem:(NSString *)twoItem withSelTyep:(SelectSheetType)selectType{
    UIImagePickerController *imgPickControl = [[UIImagePickerController alloc]init];
    imgPickControl.delegate = self;
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:oneItem style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(selectType == HeadSheet){
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                imgPickControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imgPickControl animated:YES completion:nil];
            }
        }else if(selectType == SexSheet) {
            _sexLabel.text = oneItem;
            [self updateInfo:@"sex" withParamValue:@"0"];
        }
    }];
    UIAlertAction *camearAction = [UIAlertAction actionWithTitle:twoItem style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(selectType == HeadSheet){
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imgPickControl.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imgPickControl animated:YES completion:nil];
            }
        }else if(selectType == SexSheet) {
            _sexLabel.text = twoItem;
            [self updateInfo:@"sex" withParamValue:@"1"];
        }
    }];
    [alertControl addAction:cancelAction];
    [alertControl addAction:photoAction];
    [alertControl addAction:camearAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertControl animated:YES completion:nil];
    });
}
#pragma mark 图片选择协议UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    _headImgView.image = image;
    
    [self uploadHeadImage:image];
}

#pragma mark 设置昵称
- (void)nickAction {
    SetNickViewController *setNickVC = [[SetNickViewController alloc] init];
    setNickVC.nick = _userInfoModel.memberNikename;
    setNickVC.delegate = self;
    [self.navigationController pushViewController:setNickVC animated:YES];
}

#pragma mark 设置生日
- (void)birthAction {
    self.tableView.scrollEnabled = NO;
    _dateView.hidden = NO;
}
// 取消
- (void)dateCancel {
    self.tableView.scrollEnabled = YES;
    _dateView.hidden = YES;
}
// 完成
- (void)dateDone {
    self.tableView.scrollEnabled = YES;
    _dateView.hidden = YES;
    
    UIDatePicker *pickerView = [_dateView viewWithTag:101];
    NSDate *selDate = pickerView.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *selBirth = [formatter stringFromDate:selDate];
    _birthLabel.text = selBirth;
    
    [self updateInfo:@"memberBirthday" withParamValue:selBirth];
}


#pragma mark 昵称设置完成协议
- (void)updateNickComplete:(NSString *)nick {
    _nickLabel.text = nick;
    
    [self updateInfo:@"memberNikeName" withParamValue:nick];
    
}

#pragma mark 头像图片上传
- (void)uploadHeadImage:(UIImage *)image {
    NSString *upUrl = [NSString stringWithFormat:@"%@member/uploadHeadImg", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
//    [params setObject:_userInfoModel.memberName forKey:@"memberName"];
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:@"uploadHeadImg" forKey:@"headPic"];
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] UPLOAD:upUrl dict:params imageArray:@[image] progressFloat:^(float progressFloat) {
        NSLog(@"%f", progressFloat);
    } succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

#pragma mark 调用修改信息接口
- (void)updateInfo:(NSString *)paramKey withParamValue:(NSString *)paramValue {
    NSString *upUrl = [NSString stringWithFormat:@"%@member/updateMemberExtend", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_userInfoModel.memberName forKey:@"memberName"];
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:paramValue forKey:paramKey];
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:upUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if([responseObject[@"success"] boolValue]){
            [_delegate editInfoComplete];
        }
    } failure:^(NSError *error) {
        [self hideHud];
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
