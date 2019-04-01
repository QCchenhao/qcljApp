//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyBaseCellMode.h"

@implementation MyBaseCellMode

-(instancetype)initWithtitle:(NSString *)title
{
    if (self = [super init]) {
        
        self.title = title;
    }
    return self;
    
}

+(instancetype)cellWithtitle:(NSString *)title
{
    return [[self alloc]initWithtitle:title];
}
@end
