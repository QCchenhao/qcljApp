//
//  MembershipCardCell.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/9.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MembershipCardMode;

@protocol MembershipCardCellDelegatre <NSObject>

/**
 立即充值
 */
-(void)clickInstantRechargeBtn:(UIButton *)btn;

@end
@interface MembershipCardCell : UITableViewCell

@property (strong, nonatomic)  MembershipCardMode *membershipCardMode;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak,nonatomic)  id <MembershipCardCellDelegatre>membershipCardDelegate;

@end
