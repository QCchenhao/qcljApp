//
//  OrderTableViewCell.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"

@protocol QCTopicCellDelegate <NSObject>//代理


/**
 //取消订单
 */
-(void)cancelButtonClick:(UIButton *)btn;
/**
//确认付款
 */
- (void)payButtonChile:(UIButton *)btn;
/**
//续约订单
 */
- (void)renewButtonChile:(UIButton *)btn;
/**
//确认完成
 */
- (void)completeButtonChile:(UIButton *)btn;
/**
//我来点评
 */
- (void)commentButtonChile:(UIButton *)btn;
/**
//再来一单
 */
- (void)againButtonChile:(UIButton *)btn;


@end


@interface OrderTableViewCell : UITableViewCell

@property (weak,nonatomic) id <QCTopicCellDelegate>topDelegate;

@property (nonatomic,strong) OrderModel * orderModel;

@end
