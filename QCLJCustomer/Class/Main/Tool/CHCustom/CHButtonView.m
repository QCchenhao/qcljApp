//
//  CHButtonView.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/24.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "CHButtonView.h"
#import "Comment.h"


#define CHButtonViewBtnFont [UIFont systemFontOfSize:11]
#define CHButtonViewCol 4
#define CHButtonViewBtnWidth MYScreenW / CHButtonViewCol
#define CHButtonViewBtnMargin 5
#define CHButtonViewBtnHeight CHButtonViewBtnWidth

@implementation CHButtonView

- (void)addHomeButtonWithTitle:(NSString *)title imageName:(NSString *)imageName seaction:(SEL)seaction{
    
//    UIView * view = [[UIView alloc]init];
//    view.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    for (int i = 0; i < count; i ++) {
        
        UIButton *btn =self.subviews[i];
        int row = i / CHButtonViewCol;
        int col = i % CHButtonViewCol;
        CGFloat btnX = col * CHButtonViewBtnWidth;
        CGFloat btnY = row * CHButtonViewBtnWidth;
        btn.frame = CGRectMake(btnX, btnY, CHButtonViewBtnWidth, CHButtonViewBtnHeight);
    }
    
}

@end
