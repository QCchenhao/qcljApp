//
//  HWTitleMenuViewController.h
//  黑马微博2期
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QCTitleMenuDelegate <NSObject>//代理

//传递参数
-(void)ClickBtnTitleMenuBtn:(NSInteger )btn;
@end

@interface HWTitleMenuViewController : UITableViewController

@property (weak,nonatomic) id <QCTitleMenuDelegate>titleMenuDelegate;

@property  NSInteger indexTitleMenu;//选中行数

@property (nonatomic,strong)NSArray * titleArr;
@end
