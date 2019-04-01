//
//  OrderModel.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface OrderModel : NSObject

/**服务地址 */
@property (nonatomic, copy) NSString *address;
/** 服务时间 */
@property (nonatomic, copy) NSString *createTime;
/** 订单状态 */
@property (nonatomic, assign) NSInteger state;
/** 订单类型 */
@property (nonatomic, copy) NSString * orderType;
/** 订单编号 */
@property (nonatomic, copy) NSString * stid;
/** 订单ID */
@property (nonatomic, copy) NSString * orderId;


/**
 用来自适应cell的高度
 */
//@property(assign, nonatomic) CGFloat cellHeight;

@end
