//
//  ConponViewCell.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConponMode;

@interface ConponViewCell : UITableViewCell
@property (strong, nonatomic)  ConponMode *conponMode;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end
