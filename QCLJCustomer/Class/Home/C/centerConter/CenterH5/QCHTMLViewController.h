//
//  QCHTMLViewController.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/25.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QCWebViewController.h"//web控制器

//typedef enum : NSUInteger {
//    QCHTMLTypeMaternityMatron,//月嫂
//    QCHTMLTypeParental,//育儿嫂
//    QCHTMLTypeNanny,//保姆
//    QCHTMLTypeHomePackage,//保洁套餐
//    QCHTMLTypeEnterpriseSerview,//企业服务
//    QCHTMLTypeHomeEconmicsTraining,//家政培训
//    QCHTMLTypePensionService,//养老服务
//    QCHTMLTypeMembershipPrivileges,//会员特权
//    QCHTMLTypeConponInstructions,//优惠券使用说明
//    QCHTMLTypeGiftInstruction,//礼品卡兑换的使用说明
//    QCHTMLTypeUserProtocol,//用户协议
//    QCHTMLTypeRechargeProtocol,//充值协议
//} QCHTMLType;

@interface QCHTMLViewController : UIViewController
@property (assign, nonatomic)  QCHTMLType qcthmlType;

@end
