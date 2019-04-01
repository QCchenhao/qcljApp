//
//  UILabel+extent.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/24.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UILabel+extent.h"
#import "Comment.h"

@implementation UILabel (extent)
#pragma mark - 公有方法->
#pragma mark - 字体颜色单行无行间距无框->
+ (instancetype)addNoLayerLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor size:(CGFloat)size textAlignment:(NSTextAlignment)textAlignment{
    
    return [self addLabelWithFrame:frame text:text textColor:textColor backgroundColor:backgroundColor size:size textAlignment:textAlignment lineSpacing:0 layerCornerRadius:0 layerBorderWidth:0   layerBorderColor:nil];
}
#pragma mark - 字体颜色单行无行间距无框-无背景颜色无字体颜色>
+ (instancetype)addLabelWithFrame:(CGRect)frame text:(NSString *)text size:(CGFloat)size textAlignment:(NSTextAlignment)textAlignment{
    
    return [self addNoLayerLabelWithFrame:frame text:text textColor:QiCaiShallowColor backgroundColor:nil size:size textAlignment:textAlignment];
}
#pragma mark - label左图右文单行->
+ (instancetype)addLeftImageAndLabelWithImgeName:(UIImage *)image interval:(NSInteger)interval frame:(CGRect)frame imageFrame:(CGRect)imageFrame text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor size:(CGFloat)size textAlignment:(NSTextAlignment)textAlignment{
    
    UILabel * label =[self addLabelWithFrame:frame text:text textColor:textColor backgroundColor:backgroundColor size:size textAlignment:textAlignment lineSpacing:0 layerCornerRadius:0 layerBorderWidth:0   layerBorderColor:nil];
    //间隔
    NSMutableString * mutableStr = [[NSMutableString alloc]init];
    
    for (NSInteger i = 0; i < interval; i++) {
        [mutableStr appendFormat:@" "];
    }
    // 创建一个富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",mutableStr,label.text]];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = image;
    
    // 设置图片大小
    //    attch.bounds = CGRectMake(0, -3, 15, 15);
//    [CGRectIsNull imageFrame]
    
    if (CGRectIsEmpty(imageFrame)) {//判断是否为零矩阵
        attch.bounds = CGRectMake(0, -CGRectGetHeight(frame) * 0.12, CGRectGetHeight(frame) / 1.2, CGRectGetHeight(frame) / 1.2);
    }else{
        attch.bounds = imageFrame;
    }
    
    
    // 创建带有图片的富文本
    //    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]init];
    NSAttributedString *string2 =  [NSMutableAttributedString attributedStringWithAttachment:attch];
    //先添加string2 string2在左
    [string appendAttributedString:string2];
    //在添加attri在string2右边
    [string appendAttributedString:attri];
    // 用label的attributedText属性来使用富文本
    label.attributedText = string;

    return label;
}
#pragma mark - 私有方法->
+ (instancetype)addLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor size:(CGFloat)size textAlignment:(NSTextAlignment)textAlignment lineSpacing:(CGFloat)lineSpacing layerCornerRadius:(CGFloat)layerCornerRadius layerBorderWidth:(CGFloat)layerBorderWidth layerBorderColor:(UIColor *)layerBorderColor{
    
    UILabel * label = [[UILabel alloc]init];
    label.frame = frame;
    //若有文字
    if (text) {
        label.text = text;
    }
    //若有文字颜色
    if (textColor) {
        label.textColor = textColor;
    }
    //若有字体大小
    if (size) {
        label.font = [UIFont fontWithName:@"Helvetica" size:size];//若有文字字体
    }
    //判断多行
    label.numberOfLines = 0;
    //判断对齐
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    //label行间距
    if (lineSpacing != 0) {
        
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:label.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:lineSpacing];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [label.text length])];
        [label setAttributedText:attributedString1];
        [label sizeToFit];

    }
    //背景颜色
    if (backgroundColor != 0) {
        label.backgroundColor = backgroundColor;
    }
    //设置圆角半径
    if (layerCornerRadius != 0) {
        label.layer.cornerRadius = layerCornerRadius;
        label.clipsToBounds = YES;//label需要加上这个属性（iOS7以后需要设置）
    }
    //设置框的宽度
    if (layerBorderWidth != 0) {
        label.layer.borderWidth = layerBorderWidth;
    }
    //设置框的颜色
    if (layerBorderColor) {
        label.layer.borderColor = layerBorderColor.CGColor;
    }
    

    return label;
}
#pragma mark - 字体颜色单行无行间距有框->
+ (instancetype)addLayerLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor size:(CGFloat)size layerCornerRadius:(CGFloat)layerCornerRadius layerBorderWidth:(CGFloat)layerBorderWidth layerBorderColor:(UIColor *)layerBorderColor{
    
    return [self addLabelWithFrame:frame text:text textColor:textColor backgroundColor:nil size:size textAlignment:NSTextAlignmentCenter lineSpacing:0 layerCornerRadius:layerCornerRadius layerBorderWidth:layerBorderWidth layerBorderColor:layerBorderColor];
}
#pragma mark - 字体颜色多行有行间距->
+ (instancetype)addLayerLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor size:(CGFloat)size lineSpacing:(CGFloat)lineSpacing{
    
    return [self addLabelWithFrame:frame text:text textColor:textColor backgroundColor:nil size:size textAlignment:NSTextAlignmentCenter lineSpacing:lineSpacing layerCornerRadius:0 layerBorderWidth:0 layerBorderColor:nil];
}
#define UILABEL_LINE_SPACE 2
#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}
//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
+ (instancetype)setRichLabelText:(UILabel *)label startStr:(NSString *)startStr endStr:(NSString *)emdStr font:(UIFont *)font color:(UIColor *)color{
    
    //label富文本
    
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    NSRange range;
    if (startStr && emdStr) {
        NSRange startRange = [label.text rangeOfString:startStr];
        NSRange endRange = [label.text rangeOfString:emdStr];
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
        NSRange startRange = [label.text rangeOfString:startStr];
        range = NSMakeRange(startRange.location + startRange.length , label.text.length -  startRange.location - startRange.length);
        
    }else if (startStr == nil && emdStr) {
        //从首部开始到指定的字符串  12345
        //        NSInteger leftRange = [label.text rangeOfString:emdStr].location + 1;
        NSRange endRange = [label.text rangeOfString:emdStr];
        
        range = NSMakeRange(0 , label.text.length - endRange.length);
    }
    if (font) {
        [textStr addAttribute:NSFontAttributeName value:font range:range];
    }
    //NSRange range = NSMakeRange(startRange.location , endRange.location - startRange.location + endRange.length);//设置字符串两个特定字符之间的位置（包括这两个）
    if (color) {
        [textStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    label.attributedText = textStr;
    
    return label;
}

@end
