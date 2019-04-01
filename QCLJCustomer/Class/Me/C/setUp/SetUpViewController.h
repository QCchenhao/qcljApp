//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnSetUpViewBlock)();
@interface SetUpViewController : UIViewController

@property (nonatomic, copy) ReturnSetUpViewBlock returnSetUpViewBlock;
- (void)returnPop:(ReturnSetUpViewBlock)block;

@end
