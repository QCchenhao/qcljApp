//
//  MyMessageMode.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMessageMode : NSObject
/**
 新闻名称
 */
@property(nonatomic,copy) NSString *newsname;
/**
 新闻id
 */
@property(nonatomic,copy) NSString *newsID;
/**
 新闻链接
 */
@property(nonatomic,copy) NSString *url;

@end
