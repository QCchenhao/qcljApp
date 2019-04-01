//
//  UIButton+extent.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UIButton+extent.h"
#import "Comment.h"

//#import <objc/runtime.h>

@implementation UIButton (extent)

- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
{
    //    self.backgroundColor = [UIColor cyanColor];
    
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case MKButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case MKButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case MKButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

//static char topNameKey;
//static char rightNameKey;
//static char bottomNameKey;
//static char leftNameKey;
//
//- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
//{
//    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
//    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
//    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
//    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//- (CGRect) enlargedRect
//{
//    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
//    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
//    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
//    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
//    if (topEdge && rightEdge && bottomEdge && leftEdge)
//    {
//        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
//                          self.bounds.origin.y - topEdge.floatValue,
//                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
//                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
//    }
//    else
//    {
//        return self.bounds;
//    }
//}
//
//- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
//{
//    CGRect rect = [self enlargedRect];
//    if (CGRectEqualToRect(rect, self.bounds))
//    {
//        return [super hitTest:point withEvent:event];
//    }
//    return CGRectContainsPoint(rect, point) ? self : nil;
//}
//


/**
 文字按钮
 */
+ (instancetype)addButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor font:(UIFont *)font Target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    if (backgroundColor) {
        btn.backgroundColor = backgroundColor;
    }
    
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //    btn.clipsToBounds = YES;
    //
    //    btn.layer.borderWidth = 0.6;
    //    btn.layer.cornerRadius = 3;
    //    btn.layer.borderColor = MYColor(193, 177, 122).CGColor;
    
    return btn;
    
}

/**
 图片按钮
 */
+ (instancetype)addButtonWithFrame:(CGRect)frame image:(NSString *)image highImage:(NSString *)highImage backgroundColor:(UIColor *)backgroundColor Target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = frame;
    if (backgroundColor) {
        btn.backgroundColor = backgroundColor;
    }
    
    // 设置图片
    [btn setImage:[UIImage imageWithName:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageWithName:highImage] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageWithName:highImage] forState:UIControlStateSelected];
    
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btn;
    
}
+(instancetype)addBackBtnTarget:(id)target action:(SEL)action
{
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0,70,54);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return backBtn;
}
/*
 @brief 弹窗按钮
 */
+ (instancetype)addPopButtonWhiteTitle:(NSString *)title frame:(CGRect)frame titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor layerBorderColor:(UIColor *)layerBorderColor Target:(id)target action:(SEL)action{
    
    UIButton * btn = [[UIButton alloc]init];
    btn.frame  = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = CGRectGetHeight(btn.frame) / 2;
    btn.layer.borderWidth = 1;
    if (backgroundColor) {
        btn.backgroundColor = backgroundColor;
    }
    if (layerBorderColor) {
        btn.layer.borderColor = layerBorderColor.CGColor;
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
/**
 @brief 底部的提交的btn
 */
+(instancetype)addZhuFuBtnWithTitle:(NSString *)title rect:(CGRect)rect Target:(id)target action:(SEL)action
{
    UIButton *Btn = [[UIButton alloc]init];
    Btn.frame = rect;
    [Btn setTitle:title forState:UIControlStateNormal];
//    Btn.titleLabel.font = QiCai12PFFont;
    [Btn.titleLabel setFont:QiCaiDetailTitle12Font];
    Btn.backgroundColor = QiCaiNavBackGroundColor;
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return Btn;
    
}
/**
 左图右边文字
 */
+(instancetype)addBtnWithFrame:(CGRect)frame btnBackGroundColor:(UIColor *)btnBackGroundColor leftImageName:(NSString *)leftNorImageName leftHeightImageName:(NSString *)leftHeightImageName btnTitle:(NSString *)title titleColor:(UIColor *)color titltFont:(UIFont *)font imageEdge:(UIEdgeInsets)imageEdge titleEdge:(UIEdgeInsets)titleEdge
{
    UIButton *membershipCardBtn = [[UIButton alloc]init];
    membershipCardBtn.frame = frame;
    membershipCardBtn.backgroundColor = btnBackGroundColor;
    [membershipCardBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftNorImageName]] forState:UIControlStateNormal];
    [membershipCardBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftHeightImageName]] forState:UIControlStateHighlighted];
    [membershipCardBtn setTitle:title forState:UIControlStateNormal];
    [membershipCardBtn setTitleColor:color forState:UIControlStateNormal];
    membershipCardBtn.titleLabel.font = font;
        [membershipCardBtn setImageEdgeInsets:imageEdge];
    [membershipCardBtn setTitleEdgeInsets:titleEdge];
    
    return membershipCardBtn;
}
/**
 右图片button
 */
+ (instancetype)addRightArrowBtnFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color imageName:(UIImage *)imageName target:(id)target action:(SEL)action{
    UIButton * button = [[UIButton alloc]init];
    button.frame = frame;
//    button.backgroundColor = btnBackGroundColor;
    [button setImage:imageName forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftHeightImageName]] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    button.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
//    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
//                            imageTitleSpace:10];
//    button.titleLabel.textAlignment = NSTextAlignmentLeft;
//    CGFloat btnTitleW = button.titleLabel.bounds.size.width;
//    CGFloat btnImageW = button.imageView.image.size.width;
//    
//    [button setTitleEdgeInsets: UIEdgeInsetsMake(0,-btnImageW, 0, btnImageW)];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, btnTitleW, 0, -btnTitleW)];

    
    
    
    return button;
}
/**
 带框的Button(自定义边框颜色)
 */
+ (UIButton *)addButtonWithFrame:(CGRect)buttonFrame ButtonTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font borderColor:(UIColor *)borderColor backGroundColor:(UIColor *)backGroundColor Target:(id)target action:(SEL)action btnCornerRadius:(CGFloat)cornerRadiusFloat
{
    UIButton *button = [[UIButton alloc]init];
    button.frame = buttonFrame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.layer.cornerRadius = cornerRadiusFloat;
    button.layer.borderWidth = 1;
    button.layer.borderColor = borderColor.CGColor;
    if (backGroundColor) {
        button.backgroundColor = backGroundColor;
    }
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}
+ (instancetype)setRichButtonText:(UIButton *)button startStr:(NSString *)startStr endStr:(NSString *)emdStr font:(UIFont *)font color:(UIColor *)color{
    
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:button.titleLabel.text];
    NSRange range;
    if (startStr && emdStr) {
        NSRange startRange = [button.titleLabel.text rangeOfString:startStr];
        NSRange endRange = [button.titleLabel.text rangeOfString:emdStr];
        NSInteger temp = endRange.location - startRange.location - startRange.length;
        
        if (temp >= 0) {
            range = NSMakeRange(startRange.location + startRange.length, endRange.location -
                                startRange.location - startRange.length);//设置字符串两个特定字符之间的位置（不包括这两个）
        }else{
            range = NSMakeRange(0 ,0);
            VDLog(@"从开始字符到结束字符之间的距离为负数");
        }
        
    }else if (startStr && emdStr == nil ) {
        //从指定的字符串开始到尾部
        //        NSInteger leftRange = [label.text rangeOfString:startStr].location + 1;
        NSRange startRange = [button.titleLabel.text rangeOfString:startStr];
        range = NSMakeRange(startRange.location + startRange.length , button.titleLabel.text.length -  startRange.location - startRange.length);
        
    }else if (startStr == nil && emdStr) {
        //从首部开始到指定的字符串  12345
        //        NSInteger leftRange = [label.text rangeOfString:emdStr].location + 1;
        NSRange endRange = [button.titleLabel.text rangeOfString:emdStr];
        
        range = NSMakeRange(0 , button.titleLabel.text.length - endRange.length);
    }
    if (font) {
        [textStr addAttribute:NSFontAttributeName value:font range:range];
    }
    //NSRange range = NSMakeRange(startRange.location , endRange.location - startRange.location + endRange.length);//设置字符串两个特定字符之间的位置（包括这两个）
    if (color) {
        [textStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    [button setAttributedTitle:textStr forState:UIControlStateNormal];
//    button.titleLabel.attributedText = textStr;
    
    return button;
    
}

@end
