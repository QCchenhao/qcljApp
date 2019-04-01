//
//  MemberBalanceMode.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/2.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberBalanceMode : NSObject
/**
 流水号
 */
@property(nonatomic,copy) NSString *cnum;
/**
时间
 */
@property(nonatomic,copy) NSString *time;
/**
 金额
 */
@property(nonatomic,copy) NSString *money;
/**
68 消费 99充值
 */
@property(nonatomic,copy) NSString *type;

/**
 控制分割线的显示隐藏
 */
@property (assign, nonatomic)  BOOL isTopShow;
@property (assign, nonatomic)  BOOL isBottomShow;
@end
