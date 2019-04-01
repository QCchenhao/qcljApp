//
//  QCTopicViewController.h
//  七彩乐居
//
//  Created by QCJJ－iOS on 16/3/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface QCTopicViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray * tops;

@property(assign, nonatomic) StateType  stateType;
@property(assign, nonatomic) OrderType  orderType;

- (void)orderRefresh;
@end
