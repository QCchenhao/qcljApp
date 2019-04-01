//
//  SDCycleScrollView+extent.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/12/6.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "SDCycleScrollView+extent.h"
#import "Comment.h"

@implementation SDCycleScrollView (extent)
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLsGroup placeholderImage:(UIImage *)placeholderImage Target:(id)target
{
    NSMutableArray * imageArr = [NSMutableArray array];
    for (NSString * str in imageURLsGroup) {
        NSString * imagePath1 = [NSString stringWithFormat:@"http://115.47.58.225/h5/h5/images/%@.jpg",str];
        [imageArr addObject:imagePath1];
    }

    SDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imageURLStringsGroup = [NSMutableArray arrayWithArray:imageArr];
    cycleScrollView.delegate = target;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.currentPageDotColor = QiCaiNavBackGroundColor; // 自定义分页控件小圆标颜色
    cycleScrollView.pageDotColor = [UIColor whiteColor];/** 其他分页控件小圆标颜色 */
    cycleScrollView.placeholderImage = placeholderImage;//[UIImage imageNamed:@"placeholder"];
    return cycleScrollView;
}
@end
