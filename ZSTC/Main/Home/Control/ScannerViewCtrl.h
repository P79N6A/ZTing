//
//  ScannerViewCtrl.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/24.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTBaseViewCtrl.h"

@protocol ZTScannerViewCtrlDelegate <NSObject>
/**
 *  扫描成功后返回扫描结果
 *
 *  @param result 扫描结果
 */
- (void)didFinshedScanning:(NSString *)result;

@end

@interface ScannerViewCtrl : ZTBaseViewCtrl

@property (nonatomic,assign) id<ZTScannerViewCtrlDelegate> delegate;

@end
