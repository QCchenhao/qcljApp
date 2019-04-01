//
//  MySimple.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MySimple.h"

//@interface MyChView : UIView
//
//@end
#pragma mark - 自定义 MyChView view
@implementation MyChView



@end

@implementation MySimple
//- (void)returnText:(ReturnBtnBlock)block{
//    self.btnBlock = block;
//}
#pragma mark - 单例
+(MyChView *)simpleInterests{
    
    static MyChView * popView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popView = [[MyChView alloc] init];
    });
    
    return popView;
    
}


/**
  给textfield添加右边的取消图片
 */
+(void)addRightViewWithTextField:(UITextField *)textField imageName:(NSString *)rightImageName rightWidth:(CGFloat)rightWidth rightHeight:(CGFloat)rightHeight
{
    
    UIButton *button = [textField valueForKey:@"_clearButton"];
    [button setImage:[UIImage imageNamed:@"icon_blueclear"] forState:UIControlStateNormal];
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
//    UIButton *clearButton = [textField valueForKey:@"_clearButton"];
//    if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
//        
//        if ([ currentThemeVersion] == DKThemeVersionNormal) {
//            [clearButton setImage:[UIImage imageNamed:@"Search-Topba-Close"] forState:UIControlStateNormal];
//            [clearButton setImage:[UIImage imageNamed:@"Search-Topba-Close-Night"] forState:UIControlStateHighlighted];
//        }else {
//            [clearButton setImage:[UIImage imageNamed:@"Search-Topba-Close-Night"] forState:UIControlStateNormal];
//            [clearButton setImage:[UIImage imageNamed:@"Search-Topba-Close-Highted-Night"] forState:UIControlStateHighlighted];
//        }
//    }
    
    UIImageView *rightView = [[UIImageView alloc]init];
    rightView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",rightImageName]];
    rightView.size = CGSizeMake(rightWidth + 10, rightHeight);//为了改变图片的位置
    rightView.contentMode = UIViewContentModeCenter;
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
   
    
}

/**
  @brief 提交的btn
 */
+(UIButton *)addSummitBtnWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)titleFont norImageName:(NSString *)norImageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *phoneBtn = [UIButton addButtonWithFrame:frame title:title backgroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] font:titleFont Target:target action:action];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",norImageName]] forState:UIControlStateNormal];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",highImageName]] forState:UIControlStateHighlighted];
    [phoneBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return phoneBtn;
}

/**
 占位view 没有查询到你想要的结果
 */
+(UIView *)addViewWithFrame:(CGRect)frame imageType:(MySimpleImageType)mySimplyImageTpye topTitle:(NSString *)topTitle topFont:(CGFloat)topFont topTitleColor:(UIColor *)topTitleColor bottomTitle:(NSString *)bottomTitle bottomFont:(CGFloat)bottomFont bottomColor:(UIColor *)bottomColor View:(UIView *)view
{
    [MySimple simpleInterests].hidden = NO;
    [[MySimple simpleInterests].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [view addSubview:[MySimple simpleInterests]];
    
    [MySimple simpleInterests].frame = frame;
    [MySimple simpleInterests].backgroundColor = [UIColor clearColor];
    
    NSString *norImageName;
    NSString *highImageName;
    
    if (mySimplyImageTpye == MySimpleImageTypeNo) {
        
        norImageName = @"home_placreNo";
        highImageName = @"home_placreNo";
        
    }else if (mySimplyImageTpye == MySimpleImageTypeOrderSearch)
    {
        norImageName = @"Home_order_serchPlace";
        highImageName = @"Home_order_serchPlace";
    }
    
    //占位图片
    UIButton *iconImageViewBtn = [UIButton addButtonWithFrame:CGRectMake(0, 85, 120, 120) image:norImageName highImage:highImageName backgroundColor:[UIColor clearColor] Target:nil action:nil];
    
    iconImageViewBtn.centerX = [MySimple simpleInterests].centerX;
    [[MySimple simpleInterests] addSubview:iconImageViewBtn];
    
    //上面的提示文字
    UILabel *topLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageViewBtn.frame) + 9, MYScreenW, 15) text:topTitle textColor:topTitleColor backgroundColor:[UIColor clearColor] size:topFont textAlignment:NSTextAlignmentCenter];
    [[MySimple simpleInterests] addSubview:topLabel];
    
    //下面的提示文字
    UILabel *bottomLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY(topLabel.frame) + 4, MYScreenW, 15) text:bottomTitle textColor:bottomColor backgroundColor:[UIColor clearColor] size:bottomFont textAlignment:NSTextAlignmentCenter];
    [[MySimple simpleInterests] addSubview:bottomLabel];
    
    return [MySimple simpleInterests];
}

/**
 下面带按钮的 占位view
 */
+(UIView *)addViewWithFrame:(CGRect)frame imageType:(MySimpleImageType)mySimplyImageTpye topTitle:(NSString *)topTitle topFont:(CGFloat)topFont topTitleColor:(UIColor *)topTitleColor bottomTitle:(NSString *)bottomTitle bottomFont:(CGFloat)bottomFont bottomColor:(UIColor *)bottomColor bottonBtnTitle:(NSString *)btnTitle btnWidth:(CGFloat)btnWidth btnHeight:(CGFloat)btnHigh target:(id)target action:(SEL)action View:(UIView *)view
{
//    UIView *view = [[UIView alloc]init];
//    [self.view viewWithTag:(NSInteger)];
    
    
    
//    //下面的提示文字
//    if (bottomTitle) {
//        btnY = CGRectGetMaxY(bottomLabel.frame) + 5;
//    }else
//    {
//        btnY = CGRectGetMaxY(topLabel.frame) + 5;
//    }

    
    
    
//    if (view.tag != 100) {
//        view.tag = 100;
    
        [[MySimple simpleInterests].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [view  addSubview:[MySimple simpleInterests]];
        
        [MySimple simpleInterests].hidden = NO;
        [MySimple simpleInterests].frame = frame;
        [MySimple simpleInterests].backgroundColor = [UIColor clearColor];
        
        
        
        
        NSString *norImageName;
        NSString *highImageName;
        
        if (mySimplyImageTpye == MySimpleImageTypeNo) {
            
            norImageName = @"home_placreNo";
            highImageName = @"home_placreNo";
            
        }else if (mySimplyImageTpye == MySimpleImageTypeOrderSearch)
        {
            norImageName = @"Home_order_serchPlace";
            highImageName = @"Home_order_serchPlace";
        }
        //占位图片
        UIButton *iconImageViewBtn = [UIButton addButtonWithFrame:CGRectMake(0, 85, 120, 120) image:norImageName highImage:highImageName backgroundColor:[UIColor clearColor] Target:nil action:nil];
        iconImageViewBtn.tag = 1001;
        
        iconImageViewBtn.centerX = [MySimple simpleInterests].centerX;
        [[MySimple simpleInterests] addSubview:iconImageViewBtn];
        
        //上面的提示文字
        UILabel *topLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageViewBtn.frame) + 9, MYScreenW, 15) text:topTitle textColor:topTitleColor backgroundColor:[UIColor clearColor] size:topFont textAlignment:NSTextAlignmentCenter];
        topLabel.tag = 1002;
        
        [[MySimple simpleInterests] addSubview:topLabel];
        
        CGFloat btnY;
    
        //下面的提示文字
        if (bottomTitle) {
            
            UILabel *bottomLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY(topLabel.frame) + 4, MYScreenW, 15) text:bottomTitle textColor:bottomColor backgroundColor:[UIColor clearColor] size:bottomFont textAlignment:NSTextAlignmentCenter];
            [[MySimple simpleInterests] addSubview:bottomLabel];
            btnY = CGRectGetMaxY(bottomLabel.frame) + 5;
            bottomLabel.tag = 1003;
        }else
        {
            btnY = CGRectGetMaxY(topLabel.frame) + 5;
        }
        
        //按钮
        UIButton *btn = [self addSummitBtnWithFrame:CGRectMake(0, btnY, btnWidth, btnHigh) title:btnTitle titleFont:QiCai14PFFont norImageName:@"home_btn_normal" highImageName:@"home_btn_select" target:target action:action];
        btn.tag = 1004;
        //    UIButton *btn = [self addSummitBtnWithFrame:CGRectMake(0, btnY, btnWidth, btnHigh) title:btnTitle titleFont:QiCai14PFFont norImageName:@"home_btn_normal" highImageName:@"home_btn_select" target:self action:@selector(buttonChlie:)];
        
        btn.centerX = [MySimple simpleInterests].centerX;
        [[MySimple simpleInterests] addSubview:btn];
        
//    }else{
//        [MySimple simpleInterests].hidden = NO;
//        
//        //赋值
//        UIButton * iconImageViewBtn001 = (UIButton *)[[MySimple simpleInterests] viewWithTag:1001];
//        iconImageViewBtn001.centerX = [MySimple simpleInterests].centerX;
//        UILabel * topLabel001 = (UILabel *)[[MySimple simpleInterests] viewWithTag:1002];
//        UILabel * bottomLabel001 = (UILabel *)[[MySimple simpleInterests] viewWithTag:1003];
//        UIButton * btn001 = (UIButton *)[[MySimple simpleInterests] viewWithTag:1004];
//        
//    }

   


    
    return [MySimple simpleInterests];
}
- (void)buttonChlie:(UIButton *)btn{
    
    
}
@end
