//
//  FeedBackViewController.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController
@property (nonatomic, copy) NSString *type ;//类型 0 取消订单  1.0 从C端来的意见反馈 1.1 阿姨端来的意见反馈  1.2 从经销商端的意见反馈  2 对订单的投诉
@property (nonatomic, copy) NSString * orderID;

@end
