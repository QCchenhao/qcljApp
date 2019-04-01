//
//  JLDoubleSlider.h
//  JLDoubleSliderDemo
//
//  Created by linger on 16/1/13.
//  Copyright © 2016年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLDoubleSlider : UIView
- (instancetype)initWithFrame:(CGRect)frame jointArr:(NSArray *)jointArr unit:(NSString *)unit;
/**
 设置最小值
 */
@property (nonatomic,copy)NSString * minNum;

/**
 设置最大值
 */
@property (nonatomic,copy)NSString * maxNum;

/**
 设置min 颜色
 */
@property (nonatomic,weak)UIColor *minTintColor;

/**
 设置max 颜色
 */
@property (nonatomic,weak)UIColor *maxTintColor;

/**
 设置 中间 颜色
 */
@property (nonatomic,weak)UIColor *mainTintColor;

/**
 显示较小的数Label
 */
//@property (nonatomic,strong)UILabel *minLabel;

/**
 显示较大的数Label
 */
//@property (nonatomic,strong)UILabel *maxLabel;

/**
 当前最小值
 */
@property (nonatomic,copy)NSString *  currentMinValue;

/**
 当前最大值
 */
@property (nonatomic,copy)NSString * currentMaxValue;

/**
 显示 min 滑块
 */
@property (nonatomic,strong)UIButton *minSlider;

/**
 显示 max 滑块
 */
@property (nonatomic,strong)UIButton *maxSlider;

/**
 设置单位
 */
@property (nonatomic,copy)NSString * unit;

/**
 设置节点
 */
@property (nonatomic,assign)NSInteger  joint;
/**
 设置节点数据
 */
@property (nonatomic,strong)NSArray * jointArr;
///**
// 设置节点单位
// */
//@property (nonatomic,copy)NSString * jointUnit;
/** 
 加减按钮的回调
 */
@property (nonatomic, copy) void(^sliderBlock)( NSString * currentMinValue, NSString * currentMaxValue);
@end
