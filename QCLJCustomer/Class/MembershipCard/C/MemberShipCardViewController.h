//
//  MemberShipCardViewController.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

//支付宝
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface MemberShipCardViewController : UIViewController <WXApiDelegate>
- (void)refressh;
@end
