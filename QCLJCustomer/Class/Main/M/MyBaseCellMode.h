//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void(^MyBlock) ();

@interface MyBaseCellMode : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *icon;

@property (copy, nonatomic)  MyBlock myBlock;

@property(nonatomic,copy) NSString *subTitle;

-(instancetype)initWithtitle:(NSString *)title;

+(instancetype)cellWithtitle:(NSString *)title;

@end
