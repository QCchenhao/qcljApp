//
//  HomeCenterView.m
//  七彩乐居
//
//  Created by 李大娟 on 16/3/1.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "HomeCenterView.h"
#import "Comment.h"

typedef enum : NSUInteger {
    MyCenterBtnTypeNull,
    MyCenterBtnTypeOne,
    MyCenterBtnTypeTwo,
    MyCenterBtnTypeThree
} MyCenterBtnType;

typedef enum : NSUInteger {
    MyCenterViewTop,
    MyCenterViewBottom
} MyCenterViewType;



#define HomeCenterViewBtnFont [UIFont systemFontOfSize:11]
#define HomeCenterViewCol 3
#define HomeCenterViewBtnWidth MYScreenW / HomeCenterViewCol
#define HomeCenterViewBtnMargin 5
#define HomeCenterViewBtnHeight 96
#define kTopWidth 60

@implementation HomeCenterView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
       [self addMyCenterBtnWithTopImageView:@"home_moonSister" withBottomTitle:@"月嫂" type:MyCenterBtnTypeNull addTarget:@selector(clickMaternityMatronButton) isViewType:MyCenterViewTop];
       [self addMyCenterBtnWithTopImageView:@"home_parental" withBottomTitle:@"育儿嫂" type:MyCenterBtnTypeNull addTarget:@selector(clickParentalButton) isViewType:MyCenterViewTop];
       [self addMyCenterBtnWithTopImageView:@"home_nanny" withBottomTitle:@"保姆" type:MyCenterBtnTypeOne addTarget:@selector(clickNannyButton) isViewType:MyCenterViewTop];
        
        [self addMyCenterBtnWithTopImageView:@"home_cleaning" withBottomTitle:@"保洁套餐" type:MyCenterBtnTypeTwo addTarget:@selector(clickCleaningPackageButton) isViewType:MyCenterViewBottom];
        [self addMyCenterBtnWithTopImageView:@"home_enterpriseService" withBottomTitle:@"企业服务" type:MyCenterBtnTypeThree addTarget:@selector(clickEnterpriseServiceButton) isViewType:MyCenterViewBottom];
        [self addMyCenterBtnWithTopImageView:@"home_storeConsumption" withBottomTitle:@"门店缴费" type:MyCenterBtnTypeNull addTarget:@selector(clickStoreConsumptionButton) isViewType:MyCenterViewBottom];

    }
    return self;
    
}
-(void)clickMaternityMatronButton
{
    if ([self.homeCenterViewDelegate respondsToSelector:@selector(clickMaternityMatronBtn)]) {
        [self.homeCenterViewDelegate clickMaternityMatronBtn];
    }
}

-(void)clickParentalButton
{
    if ([self.homeCenterViewDelegate respondsToSelector:@selector(clickParentalBtn)]) {
        [self.homeCenterViewDelegate clickParentalBtn];
    }
}

-(void)clickNannyButton
{
    if ([self.homeCenterViewDelegate respondsToSelector:@selector(clickNannyBtn)]) {
        [self.homeCenterViewDelegate clickNannyBtn];
    }
}

-(void)clickCleaningPackageButton
{
    if ([self.homeCenterViewDelegate respondsToSelector:@selector(clickCleaningPackageBtn)]) {
        [self.homeCenterViewDelegate clickCleaningPackageBtn];
    }
}

-(void)clickEnterpriseServiceButton
{
    if ([self.homeCenterViewDelegate respondsToSelector:@selector(clickEnterpriseServiceBtn)]) {
        [self.homeCenterViewDelegate clickEnterpriseServiceBtn];
    }
}

-(void)clickStoreConsumptionButton
{
    if ([self.homeCenterViewDelegate respondsToSelector:@selector(clickStoreConsumptionBtn)]) {
        [self.homeCenterViewDelegate clickStoreConsumptionBtn];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    for (int i = 0; i < count; i ++) {
        
        UIButton *btn =self.subviews[i];
        int row = i / HomeCenterViewCol;
        int col = i % HomeCenterViewCol;
        CGFloat btnX = col * HomeCenterViewBtnWidth;
        CGFloat btnY = row * HomeCenterViewBtnHeight;
        btn.frame = CGRectMake(btnX, btnY, HomeCenterViewBtnWidth, HomeCenterViewBtnHeight);
    }
    
}
//快速创建btn
-(void)addMyCenterBtnWithTopImageView:(NSString *)imageName withBottomTitle:(NSString *)bottomTitle type:(MyCenterBtnType)typeString addTarget:(SEL)sel isViewType:(MyCenterViewType)centerViewTypeString
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.width = HomeCenterViewBtnWidth;
    view.height = HomeCenterViewBtnHeight;
    [self addSubview:view];

    
    //topButton
    UIButton *topButton = [[UIButton alloc]init];
    topButton.width = kTopWidth;
    topButton.height = kTopWidth;
    topButton.centerX = view.centerX;
    
    if (centerViewTypeString == MyCenterViewTop) {
        
        topButton.y = 13;
        
    }else if (centerViewTypeString == MyCenterViewBottom)
    {
        topButton.y = 6.5;

    }
    [topButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [view addSubview:topButton];
    
    //rightBtn
    if (typeString == MyCenterBtnTypeNull) {
        
    }else
    {
        UIButton *rightBtn = [[UIButton alloc]init];
        rightBtn.width = 48;
        rightBtn.height = 18;
        rightBtn.x = CGRectGetMinX(topButton.frame) + 20;
        rightBtn.y = CGRectGetMinY(topButton.frame) + 1.8;
        rightBtn.backgroundColor = [UIColor whiteColor];
        
        NSString *rightImageString;
        NSString *rightString;
        UIColor *rightTitleCover;
        
        if (typeString == MyCenterBtnTypeOne) {
            
            rightImageString = @"Home_hot";
            rightString = @"HOT";
            rightTitleCover = MYColor(255, 110, 166);
            
        }else if (typeString == MyCenterBtnTypeTwo)
        {
            rightImageString = @"Home_cleaning";
            rightString = @"立减10元";
            rightTitleCover = MYColor(133, 217, 209);
        }
        else if (typeString == MyCenterBtnTypeThree)
        {
            rightImageString = @"Home_enterprise";
            rightString = @"10元起";
            rightTitleCover = MYColor(220, 132, 125);

        }
        
        rightBtn.layer.borderWidth = 0.5;
        rightBtn.layer.borderColor = rightTitleCover.CGColor;
        rightBtn.layer.cornerRadius = CGRectGetHeight(rightBtn.frame) / 2 ;
        
        [rightBtn setTitle:[NSString stringWithFormat:@"%@",rightString] forState:UIControlStateNormal];
        [rightBtn setTitleColor:rightTitleCover forState:UIControlStateNormal];
        rightBtn.titleLabel.font = QiCai10PFFont;
        [view addSubview:rightBtn];
        
    }
    
    //titleLabel
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.x = 0;
    titleLabel.y = CGRectGetMaxY(topButton.frame) + 6;
    titleLabel.width = view.width;
    titleLabel.height = 12;
    titleLabel.text = [NSString stringWithFormat:@"%@",bottomTitle];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = QiCaiDeepColor;
    titleLabel.font = QiCaiDetailTitle12Font;
    [view addSubview:titleLabel];
    
    UIButton *coverBtn = [[UIButton alloc]init];
    coverBtn.frame = view.bounds;
    [coverBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:coverBtn];
    
    
}
@end
