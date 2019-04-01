//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyBaseCellMode.h"


//typedef void (^ReturnBlock)(NSString *showImage);


@interface MyBaseCellArrowMode : MyBaseCellMode
@property (assign, nonatomic)  Class descVC;

-(instancetype)initWithTitle:(NSString *)title descVC:(Class)descVC;
+(instancetype)cellWithTitle:(NSString *)title descVC:(Class)descVC;


//@property (nonatomic, copy) ReturnBlock returnBlock;
//- (void)returnBlock:(ReturnBlock)block;
@end
