//
//  ServiceAddressTableTableViewController.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/12/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceAddressMode.h"
#import "ServiceAddressCell.h"

typedef void (^ReturnAddTextTableBlock)(NSString *address ,NSString *adderssID);

@interface ServiceAddressTableTableViewController : UITableViewController

@property (nonatomic, copy) ReturnAddTextTableBlock returnAddTextTableBlock;

- (void)returnAddTableText:(ReturnAddTextTableBlock)block;

@end
