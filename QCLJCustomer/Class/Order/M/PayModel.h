//
//  PayModel.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/22.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>

//**支付类型**/
typedef  enum  PayType : NSInteger {
    payForOrder  = 0,//**服务订单**/
    paymentOrder , //快速缴费
    payForMemCard  //会员卡
} PayType;

@interface PayModel : NSObject
//快速缴费
/*!
 //缴费类型  服务订单payForOrder   快速缴费paymentOrder   会员卡payForMemCard 
*/
@property(assign, nonatomic) PayType  payType;

/**
 //优惠券ID
 */
@property (nonatomic, copy) NSString * couponLogId;
/**
 ////是否使用会员卡 没有传0
 */
@property (nonatomic, copy) NSString * iscard;
/**
//优惠券ID 没有传0
 */
@property (nonatomic, copy) NSString * coupon;


/*!
//收款经纪人
 */
@property (nonatomic, copy) NSString * agentName;
/*!
//佣金
 */
@property (nonatomic, copy) NSString * commission;
/*!
//代收工资
 */
@property (nonatomic, copy) NSString * wages;
/*!
//保险
 */
@property (nonatomic, copy) NSString * insurance;
/*!
//总金额
 */
@property (nonatomic, copy) NSString * amount;
/*!
//雇主电话
 */
@property (nonatomic, copy) NSString * mob;
/*!
//雇主姓名
 */
@property (nonatomic, copy) NSString * name;
/*!
//若没有userid 此项必须要写
 */
@property (nonatomic, copy) NSString * userType ;
/*!
//用户主键（未登录不写此参数）
 */
@property (nonatomic, copy) NSString * userId ;
/*!
订单号主键
 */
@property (nonatomic, copy) NSString *stid;//
@end
