//
//  MyCityViewController.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/25.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnMyCityBlock)(NSString *cityStr);

@interface MyCityViewController : UIViewController

@property (nonatomic, copy) NSString * cityHomeStr;

@property (nonatomic, copy) ReturnMyCityBlock returnMyCityBlock;
- (void)returnText:(ReturnMyCityBlock)block;

@end
