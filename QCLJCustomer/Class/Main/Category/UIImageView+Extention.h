//
//  UIImageView+Extention.h
//  七彩乐居
//
//  Created by QCJJ－iOS on 16/3/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extention)
/*站位图-圆角*/
-(void)setHeader:(NSString *)urlStr;
/*将图片保存到本地*/
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key ;
/*本地是否有相关图片*/
+ (BOOL)LocalHaveImage:(NSString*)key;
/*从本地获取图片*/
+ (UIImage*)GetImageFromLocal:(NSString*)key;
/*判断本地没有图片拼接请求路径网上请求————大站位图*/
- (void)imageToNamed:(NSString * )name;
/*判断本地没有图片拼接请求路径网上请求并减成圆形*/
- (void)imageToCircleImage:(NSString * )name;
/*判断本地没有图片拼接请求路径网上请求并减成圆形————小站位图*/
- (void)imageToSmallNamed:(NSString * )name;
@end
