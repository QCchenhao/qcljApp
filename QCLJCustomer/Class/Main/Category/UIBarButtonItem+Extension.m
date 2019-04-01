//
//  UITextField+Category.h
//  七彩乐居
//
//  Created by 李大娟 on 16/10/25.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "Comment.h"

@implementation UIBarButtonItem (Extension)

+(UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName higImageName:(NSString *)higIamgeName action:(SEL)action target:(id)target
{
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:higIamgeName] forState:UIControlStateHighlighted];
    btn1.size = btn1.currentImage.size;
    
    [btn1 addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn1];
}
+(UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName ButtonAdjustment:(CGFloat)adjustment action:(SEL)action target:(id)target
{
   UIBarButtonItem * bar =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStyleBordered  target:target action:action];
    if (iOS7) {
        
        bar.image = [bar.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [bar setBackgroundVerticalPositionAdjustment:adjustment forBarMetrics:UIBarMetricsDefault];
    
    return bar;
}
+(UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName  action:(SEL)action target:(id)target{
    return [UIBarButtonItem barButtonItemWithImageName:imageName ButtonAdjustment:5.0 action:action target:target];
}
+(UIBarButtonItem *)barButtonItemWithButton:(UIButton *) buttton ButtonAdjustment:(CGFloat)adjustment{
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:buttton];
    
    [leftButton setBackgroundVerticalPositionAdjustment:adjustment forBarMetrics:UIBarMetricsDefault];

    return leftButton;
}
+(UIBarButtonItem *)barButtonItemWithButton:(UIButton *) buttton {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:buttton];
    
    [leftButton setBackgroundVerticalPositionAdjustment:10.0 forBarMetrics:UIBarMetricsDefault];
    
    return leftButton;
}
/**
 文字  5.0
 */
+(UIBarButtonItem *)addBarBtnItemWithTItle:(NSString *)title titleColor:(UIColor *)titeColor target:(id)target action:(SEL)action
{
    UIButton * buttton = [[UIButton alloc]init];

    buttton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    buttton.frame = CGRectMake(0, 0, 100, 30);
    [buttton setTitle:title forState:UIControlStateNormal];
    [buttton setTitleColor:titeColor forState:UIControlStateNormal];
    [buttton.titleLabel setFont:QiCaiDetailTitle12Font];
    [buttton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:buttton];
    
    [barItem setBackgroundVerticalPositionAdjustment:10.0 forBarMetrics:UIBarMetricsDefault];

    
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
//    [barItem setBackgroundVerticalPositionAdjustment:10.0 forBarMetrics:UIBarMetricsDefault];
    return barItem;
}
@end
