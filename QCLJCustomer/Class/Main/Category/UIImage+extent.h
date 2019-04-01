//
//  UIImage+extent.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/1.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extent)
+(UIImage *)resizableImage:(NSString *)name;

- (instancetype)circleImage;
- (instancetype)circleImage2;


/*
 *生成一张纯色的图片
 */
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
/*
 *中间拉伸
 */
+(UIImage *)imageWithName:(NSString *)name;
/**
 对图片进行处理，最大尺寸不超过
 */
+(UIImage *)imageScale:(UIImage *)image maxEdge:(float)maxEdge;

@end
