//
//  UIImage+extent.m
//  QCLJCustomer
//
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UIImage+extent.h"

@implementation UIImage (extent)
+(UIImage *)resizableImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH * 0.5, imageW * 0.5, imageH * 0.5, imageW * 0.5) resizingMode:UIImageResizingModeStretch];
}

- (instancetype)circleImage
{
    // 开启图形上下文(目的:产生一个新的UIImage, 参数size就是新产生UIImage的size)
    UIGraphicsBeginImageContext(self.size);
    
    // 获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    
    // 裁剪(根据添加到上下文中的路径进行裁剪)
    // 以后超出裁剪后形状的内容都看不见
    CGContextClip(context);
    
    // 绘制图片到上下文中
    [self drawInRect:rect];
    
    // 从上下文中获得最终的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}
- (instancetype)circleImage2
{
    // 开启图形上下文(目的:产生一个新的UIImage, 参数size就是新产生UIImage的size)
    UIGraphicsBeginImageContext(self.size);
    
    // 获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //
    ////    // 添加一个圆
    ////    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    ////    CGContextAddEllipseInRect(context, rect);
    //
    //    /*画圆角矩形*/
    //    float fw = self.size.width;
    //    float fh = self.size.height;
    //
    //    CGContextMoveToPoint(context, fw, fh-5);  // 开始坐标右边开始
    //    CGContextAddArcToPoint(context, fw, fh, fw-5, fh, 2.5);  // 右下角角度
    //    CGContextAddArcToPoint(context, fw, fh, fw, fh-20, 2.5); // 左下角角度
    //    CGContextAddArcToPoint(context, fw, fh, fw-20, 250, 10); // 左上角
    //    CGContextAddArcToPoint(context, fw, fh, fw, fh-20, 10); // 右上角
    //    CGContextClosePath(context);
    //
    //    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    //
    //    // 裁剪(根据添加到上下文中的路径进行裁剪)
    //    // 以后超出裁剪后形状的内容都看不见
    CGContextClip(context);
    //
    //    // 绘制图片到上下文中
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //
    // 从上下文中获得最终的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //
    //    // 关闭图形上下文
    //    UIGraphicsEndImageContext();
    
    return image;
}

/*
 *生成一张纯色的图片
 */
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
/*
 *中间拉伸
 */
+(UIImage *)imageWithName:(NSString *)name
{
    UIImage *btnImage = [UIImage imageNamed:name];
    btnImage = [btnImage stretchableImageWithLeftCapWidth:floorf(btnImage.size.width/2) topCapHeight:floorf(btnImage.size.height/2)];
    return btnImage;
}

+(UIImage *)imageScale:(UIImage *)image maxEdge:(float)maxEdge
{
    float w = image.size.width;
    float h = image.size.height;
    
    float w1 = w;
    float h1 = h;
    if( w >= h )
    {
        if( w1 > maxEdge )
            w1 = maxEdge;
        
        h1 = w1 * h / w;
    }
    else{
        if( h1 > maxEdge )
            h1 = maxEdge;
        
        w1 = w * h1 / h;
    }
    
    
    UIGraphicsBeginImageContext(CGSizeMake(w1, h1));
    
    [image drawInRect:CGRectMake(0, 0, w1, h1)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
