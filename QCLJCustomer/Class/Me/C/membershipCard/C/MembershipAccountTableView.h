//
//  MembershipAccountTableView.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MembershipAccountTableView : UITableViewController
/**
 区分两个状态
 */
@property(assign, nonatomic) NSString * stateType;

/**
 区分两个控制器 100 会员余额   200账户查询
 */
@property(assign, nonatomic) NSString * VCType;
/**
 检索 时间的搜索
 */
-(void)retrievalLaodMoreTopicToMin:(NSString *)min max:(NSString *)max;

@end
