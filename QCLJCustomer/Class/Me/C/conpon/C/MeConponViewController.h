//
//  MeConponViewController.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConponMode.h"

typedef void (^ReturnMeConponBlock)(ConponMode * conponMode);

@interface MeConponViewController : UIViewController
@property(nonatomic,copy) NSString *orderID;

@property (nonatomic, copy) ReturnMeConponBlock returnMeConponBlock;
- (void)returnText:(ReturnMeConponBlock)block;

@end
