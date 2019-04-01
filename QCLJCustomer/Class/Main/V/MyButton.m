//
//  MyButton.m
//  七彩乐居
//
//  Created by 李大娟 on 16/3/2.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyButton.h"
#import "Comment.h"

@implementation MyButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleH = contentRect.size.height;
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSFontAttributeName] = QiCaiNavTitle14Font;
    
    //    iOS7之后才有
    
    CGSize titleSize;
    
#ifdef __IPHONE_7_0   // xcode5
    
    // 判段
    if (iOS7) {
        titleSize = [self.currentTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:md context:nil].size;
    }
    else    // iOS6
    {
//        titleSize = [self.currentTitle sizeWithFont:[UIFont systemFontOfSize:14]];
       
        NSDictionary *att = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        titleSize = [self.currentTitle sizeWithAttributes:att];
    }
    
#else   // 没有__IPHONE_7_0，xcode4
    
    titleSize = [self.currentTitle sizeWithFont:self.titleLabelFont];
    
#endif
    
    CGFloat titleW = titleSize.width;
    CGFloat titleX = 0;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageW = imageH;
//    CGFloat imageH = 15;
//    CGFloat imageW = 15;
    CGFloat imageX = contentRect.size.width - imageW;
//    self.imageView.contentMode = UIViewContentModeCenter;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    self.titleLabel.x = 0 ;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) - 7 ;
    
    
//    CGFloat y = self.y;
//    self.y = y + 2;
//    
//    CGFloat X = self.x;
//    self.x = X - 2;

//    self.imageView.backgroundColor = [UIColor orangeColor];
    //    NSLog(@"11111titleLabel==%f===imageView==%f",self.titleLabel.frame.origin.x, self.imageView.frame.origin.x);
}

@end
