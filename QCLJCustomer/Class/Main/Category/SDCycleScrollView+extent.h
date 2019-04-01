//
//  SDCycleScrollView+extent.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/12/6.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <SDCycleScrollView/SDCycleScrollView.h>

@interface SDCycleScrollView (extent)
/**
 *  网络轮播图
 *
 *  @param frame            frame
 *  @param imageURLsGroup   网络图片名称
 *  @param placeholderImage 站位图
 *  @param target           代理
 *
 *  @return SDCycleScrollView
 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLsGroup placeholderImage:(UIImage *)placeholderImage Target:(id)target;
@end
