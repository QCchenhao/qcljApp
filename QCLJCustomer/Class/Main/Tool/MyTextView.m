//
//  MyTextView.m
//  七彩乐居
//
//  Created by 李大娟 on 16/3/22.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyTextView.h"
#import "Comment.h"

@interface MyTextView()

@end

@implementation MyTextView
-(instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        
        self.alwaysBounceVertical = YES;
        
        UILabel *placeLabel  = [[UILabel alloc]init];
        self.placeLabel = placeLabel;
        placeLabel.numberOfLines = 0;
        placeLabel.textColor = [UIColor grayColor];
        [self addSubview:placeLabel];
        
        self.font = QiCaiDetailTitle12Font;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

-(void)textChange
{
    self.placeLabel.hidden = self.text.length != 0;
}

// 外界改变textView的font会调用setFont，保持textView的font和placeLabel的font一致
-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeLabel.font = self.font;
    
    // 根据最新的文字的大小font,重新计算placelabel的size
    [self setNeedsLayout];
}
-(void)setPlaceHoledr:(NSString *)placeHoledr
{
    _placeHoledr = placeHoledr;
    self.placeLabel.text = placeHoledr;
    [self setNeedsLayout];
}
-(void)setPlaceHoledrColor:(UIColor *)placeHoledrColor
{
    _placeHoledrColor = placeHoledrColor;
    self.placeLabel.textColor = placeHoledrColor;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeLabel.x = 6;
    self.placeLabel.y = 8;
    self.placeLabel.width = self.width - self.placeLabel.x * 2;
    
    // 指定我要以这个大小的字体显示
    NSDictionary *attributeDict = @{NSFontAttributeName : QiCaiDetailTitle12Font};
    // 最大范围
     CGSize maxSize = CGSizeMake(self.placeLabel.width, MAXFLOAT);
    CGSize size = [self.placeLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
    self.placeLabel.height = size.height;
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
