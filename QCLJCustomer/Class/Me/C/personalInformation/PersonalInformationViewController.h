//
//  PersonalInformationViewController.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnMeNameBlock)(UIImage * ueseImage,NSString *nameStr);

@interface PersonalInformationViewController : UIViewController

@property (nonatomic, copy) ReturnMeNameBlock returnMeNameBlock;
- (void)returnText:(ReturnMeNameBlock)block;

@end
 