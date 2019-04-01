//
//  MemberBalanceCell.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/2.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberBalanceMode;

@interface MemberBalanceCell : UITableViewCell

@property (strong, nonatomic)  MemberBalanceMode *memberBalanceMode;
@property(nonatomic,copy) NSString *memcardNum;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end
