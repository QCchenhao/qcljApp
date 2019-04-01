//
//  MyMessageCell.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyMessageMode;

@interface MyMessageCell : UITableViewCell
@property (strong, nonatomic)  MyMessageMode *myMessageMode;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
