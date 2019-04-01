//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyBaseCellArrowMode.h"

@implementation MyBaseCellArrowMode

//- (void)returnBlock:(ReturnBlock)block
//{
//    
//}
-(instancetype)initWithTitle:(NSString *)title descVC:(Class)descVC
{
    if (self = [super initWithtitle:title]) {
        self.descVC = descVC;
//        self.returnBlock = descVC
    }
    return self;
}

+(instancetype)cellWithTitle:(NSString *)title descVC:(Class)descVC
{
    return [[self alloc]initWithTitle:title descVC:descVC];
    
}
@end

