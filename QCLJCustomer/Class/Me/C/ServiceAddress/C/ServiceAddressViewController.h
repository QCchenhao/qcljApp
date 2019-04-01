//
//  ServiceAddressViewController.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ServiceAddressCell.h"
#import "ServiceAddressMode.h"

typedef void (^ReturnAddTextBlock)(NSString *address ,NSString *adderssID);

@interface ServiceAddressViewController : UIViewController

@property (nonatomic, copy) ReturnAddTextBlock returnAddTextBlock;

- (void)returnAddText:(ReturnAddTextBlock)block;

@end
