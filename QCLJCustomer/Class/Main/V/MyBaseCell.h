//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBaseCellMode.h"
#import "MyBaseCellArrowMode.h"

@interface MyBaseCell : UITableViewCell

@property (strong, nonatomic)  MyBaseCellMode *cellMode;
/**
 文字cell
 */
+(instancetype)CellWithTableView:(UITableView *)tableView;

@end
