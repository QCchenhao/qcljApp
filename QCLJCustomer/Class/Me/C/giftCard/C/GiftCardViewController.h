//
//  GiftCardViewController.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnMeMembershipCardBlock)();

@interface GiftCardViewController : UIViewController
@property (nonatomic, copy) ReturnMeMembershipCardBlock returnMeMembershipCardBlock;
- (void)returnText:(ReturnMeMembershipCardBlock)block;
@end
