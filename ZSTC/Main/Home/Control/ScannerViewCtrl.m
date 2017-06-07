//
//  ScannerViewCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/24.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ScannerViewCtrl.h"
#import "QRCScanner.h"

@interface ScannerViewCtrl ()<QRCodeScanneDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ScannerViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"二维码扫描";
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    QRCScanner *scanner = [[QRCScanner alloc]initQRCScannerWithView:self.view];
    scanner.delegate = self;
    [self.view addSubview:scanner];
    
    //从相册选取二维码
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(readerImage)];
    
}

#pragma mark - 扫描二维码成功后结果的代理方法
- (void)didFinshedScanningQRCode:(NSString *)result{
    
    if ([self.delegate respondsToSelector:@selector(didFinshedScanning:)]) {
        [self.delegate didFinshedScanning:result];
    }
    else{
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 从相册获取二维码图片
- (void)readerImage{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *result = [QRCScanner scQRReaderForImage:srcImage];
    
    if ([self.delegate respondsToSelector:@selector(didFinshedScanning:)]) {
        [self.delegate didFinshedScanning:result];
    }
    else{
        
    }
    [self.navigationController popViewControllerAnimated:YES];
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
