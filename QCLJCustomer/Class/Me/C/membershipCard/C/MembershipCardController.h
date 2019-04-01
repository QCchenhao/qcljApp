//
//  MembershipCardController.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/2.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTabBarControllViewBlock)();

@interface MembershipCardController : UIViewController
@property(nonatomic,copy) NSString *membershipCardStr;

@property (nonatomic, copy) ReturnTabBarControllViewBlock returnTabBarControllViewBlock;
- (void)returnTabBar:(ReturnTabBarControllViewBlock)block;

@end
