//
//  CHNotInternetView.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/30.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHNotInternetViewDelegate  <NSObject>

- (void)reloadNetworkRequest:(UIButton *)sender;
@end

@interface CHNotInternetView : UIView

/**
 *  由代理控制器去执行刷新网络
 */
@property (nonatomic, strong) id<CHNotInternetViewDelegate>delegate;
/**
 *  //主标题 字体大 颜色重
 */
@property (nonatomic, copy) NSString * CHtitle;
/**
 *  //副标题1
 */
@property (nonatomic, copy) NSString * message1;
/**
 *  //副标题2
 */
@property (nonatomic, copy) NSString * message2;
/**
 *  //副标题3地址专用
 */
@property (nonatomic, copy) NSString * message3;
/**
 *  按钮文字
 */
@property (nonatomic, copy) NSString *btnStr;
/**
 *  图片名称
 */
@property (nonatomic, copy) NSString *imageStr;
@end
