//
//  GaodePOIViewController.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GaodePOIViewController : UIViewController

/** 地址的回调*/
@property (nonatomic, copy) void(^GaodePOIBlock)(NSString *address ,NSString *adderssID);

/** 修改地址ID*/
@property (nonatomic, copy) NSString * adderssID;

/** 用来判断是否是订单提交页面*/
@property (nonatomic, copy) NSString * isHomeorder;// 200 是未注册订单提交页面  201 是注册无常用地址订单提交页面

@end
