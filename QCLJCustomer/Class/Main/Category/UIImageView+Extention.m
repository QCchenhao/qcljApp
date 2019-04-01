//
//  UIImageView+Extention.m
//  七彩乐居
//
//  Created by QCJJ－iOS on 16/3/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UIImageView+Extention.h"

#import "Comment.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Extention)

-(void)setHeader:(NSString *)urlStr
{
    
    // 原型的站位图
    UIImage *placeHolderImage = [[UIImage imageNamed:@"order_placeholder"]circleImage];
   
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        // 如果image有值 就变圆  没有值 显示站位
        self.image = image ? [image circleImage] : placeHolderImage;
    }];
}

//将图片保存到本地
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    [preferences setObject:UIImagePNGRepresentation(image) forKey:key];
}

//本地是否有相关图片
+ (BOOL)LocalHaveImage:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    if (imageData) {
        return YES;
    }
    return NO;
}

//从本地获取图片
+ (UIImage*)GetImageFromLocal:(NSString*)key {
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //[preferences persistentDomainForName:LocalPath];
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    else {
        NSLog(@"未从本地获得图片");
    }
    return image;
}
/**
 大方占位图类型
 */
- (void)imageToNamed:(NSString * )name
{
   
    UIImage *image  = [UIImage imageNamed:name];
    
    if (image == nil) {
        NSString * URLQZ = [MYUserDefaults objectForKey:@"img"];
        if (!URLQZ) {
            //需要的
//             [MyHttpTool getImageURLString];
        }
         NSURL* imagePath1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@@2x.png",URLQZ,name]];

        //给一张默认图片，先使用默认图片，当图片加载完成后再替换
        [self sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"placeholder_oneImage"]];
        
        
    }else {
        self.image = image;
    }
    
    
    
    
}
/**
小圆占位图类型
 */
- (void)imageToSmallNamed:(NSString * )name
{
    UIImage *image  = [UIImage imageNamed:name];
    [image circleImage];
    
    if (image == nil) {
        NSString * URLQZ = [MYUserDefaults objectForKey:@"imageURL"];
        if (!URLQZ) {
            //需要的
//            [MyHttpTool getImageURLString];
        }
        //        NSURL* imagePath1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.bjleju.com/apppic/Resources_To_IOS_App/%@@2x.png",name]];
        NSURL* imagePath1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@@2x.png",URLQZ,name]];
        //        NSLog(@"%@",[NSString stringWithFormat:@"%@%@@2x.png",URLQZ,name]);
        UIImage * image = [UIImage imageNamed:@"placeholder_small_Image"];
        
        //给一张默认图片，先使用默认图片，当图片加载完成后再替换
        [self sd_setImageWithURL:imagePath1 placeholderImage:[image circleImage]];
        
        
    }else {
        self.image = image;
    }
    
    
    
    
}

- (void)imageToCircleImage:(NSString * )name
{
    UIImage *image1  = [UIImage imageNamed:name];
    
    if (image1 == nil) {
        
        NSURL* imagePath1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.bjleju.com/apppic/Resources_To_IOS_App/%@@2x.png",name]];
        
        [self sd_setImageWithURL:imagePath1 placeholderImage:[UIImage imageNamed:@"placeholder_small_Image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.image = image;
            self.image = [self.image circleImage];
        }];
        
        
    }else {
        self.image = image1;
    }
    
    
    
    
}

@end
