//
//  ConponMode.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConponMode : NSObject
/**
优惠券ID
 */
@property(nonatomic,copy) NSString *couponLogId;

/**
 logo 地址
 */
@property(nonatomic,copy) NSString *url;

/**
 可优惠金额
 */
@property(nonatomic,copy) NSString *money;

/**
 门店限制
 */
@property(nonatomic,copy) NSString *depLimit;

/**
 开始使用时间
 */
@property(nonatomic,copy) NSString *startTime;
/**
结束时间
 */
@property(nonatomic,copy) NSString *endTime;

/**
 金额门槛
 */
@property(nonatomic,copy) NSString *moneyLimit;

/**
 对应订单类型
 */
@property(nonatomic,copy) NSString *serviceLimit;

/**
 0 未过期 1过期
 */
@property(nonatomic,copy) NSString *isOverdue;

/**
 是否已使用（应该都是0 出现1 就是BUG）
 */
@property(nonatomic,copy) NSString *isuse;

@end
