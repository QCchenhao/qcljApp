//
//  UIViewController+CHNotNetController.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/30.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 异常状态
 */
typedef  enum  AbnormalState : NSInteger {
    AbnormalStateNoDataLookup = 0,//**无数据图片1 放大镜**/
    AbnormalStateNoDataNo,//**无数据图片2 NO图片**/
    AbnormalStateNoNetwork, //**无网络**/
    AbnormalStateNoDataNoAddress //**地图无数据**/
    
} AbnormalState;

@interface UIViewController (CHNotNetController)
- (void)showNotInternetViewToAbnormalState:(AbnormalState )AbnormalState message1:(NSString *)message1 message2:(NSString *)message2;
- (void)hiddenNotInternetView;
@end
