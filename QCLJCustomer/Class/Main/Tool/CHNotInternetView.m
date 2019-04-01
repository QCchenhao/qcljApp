//
//  CHNotInternetView.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/30.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "CHNotInternetView.h"
#import "Comment.h"

@implementation CHNotInternetView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStars:2];
}
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];        
    }
    return self;
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

- (void)reloadDataAction:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"立即预约"]) {
        btn.tag = 111;
    }else{
        btn.tag = 222;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadNetworkRequest:)]) {
        [self.delegate performSelector:@selector(reloadNetworkRequest:) withObject:btn];
    }
}

- (void)setCHtitle:(NSString *)CHtitle{
    
    _CHtitle = CHtitle;
    
    UILabel *topLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY([ self.subviews objectAtIndex:self.subviews.count - 1].frame) + 9, MYScreenW, 15) text:CHtitle textColor:QiCaiDeepColor backgroundColor:[UIColor clearColor] size:12 textAlignment:NSTextAlignmentCenter];
    [self addSubview:topLabel];

    
}
- (void)setMessage1:(NSString *)message1{
    
    UILabel *topLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY([ self.subviews objectAtIndex:self.subviews.count - 1].frame) + 9, MYScreenW, 15) text:message1 textColor:QiCaiShallowColor backgroundColor:[UIColor clearColor] size:10 textAlignment:NSTextAlignmentCenter];
    [self addSubview:topLabel];
}
- (void)setMessage2:(NSString *)message2{
    UILabel *topLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY([ self.subviews objectAtIndex:self.subviews.count - 1].frame) + 9, MYScreenW, 15) text:message2 textColor:QiCaiShallowColor backgroundColor:[UIColor clearColor] size:12 textAlignment:NSTextAlignmentCenter];
    [self addSubview:topLabel];
}
- (void)setMessage3:(NSString *)message3{
    UILabel *topLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY([ self.subviews objectAtIndex:self.subviews.count - 1].frame) , MYScreenW, 15) text:message3 textColor:QiCaiShallowColor backgroundColor:[UIColor clearColor] size:12 textAlignment:NSTextAlignmentCenter];
    [self addSubview:topLabel];
}
- (void)setBtnStr:(NSString *)btnStr{
    //按钮
    UIButton *phoneBtn = [UIButton addButtonWithFrame:CGRectMake(0, CGRectGetMaxY([ self.subviews objectAtIndex:self.subviews.count - 1].frame)  + 10, 137, 30) title:btnStr backgroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] font:QiCai12PFFont Target:nil action:nil];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",@"home_btn_normal"]] forState:UIControlStateNormal];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",@"home_btn_normal"]] forState:UIControlStateHighlighted];
    [phoneBtn addTarget:self action:@selector(reloadDataAction:) forControlEvents:UIControlEventTouchUpInside];
    //    UIButton *btn = [self addSummitBtnWithFrame:CGRectMake(0, btnY, btnWidth, btnHigh) title:btnTitle titleFont:QiCai14PFFont norImageName:@"home_btn_normal" highImageName:@"home_btn_select" target:self action:@selector(buttonChlie:)];
    
    phoneBtn.centerX = self.centerX;
    [self addSubview:phoneBtn];

}
- (void)setImageStr:(NSString *)imageStr{
    UIButton *iconImageViewBtn = [UIButton addButtonWithFrame:CGRectMake(0, 85, 120, 120) image:imageStr highImage:imageStr backgroundColor:[UIColor clearColor] Target:nil action:nil];
    
    iconImageViewBtn.centerX = CGRectGetWidth(self.frame) / 2;
    [self addSubview:iconImageViewBtn];

}
@end
