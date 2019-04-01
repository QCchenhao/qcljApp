//
//  NSString+File.h
//  河科院微博
//
//  Created by 👄 on 15/7/31.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (File)
- (long long)fileSize;

- (float) heightWithFont: (UIFont *) font withinWidth: (float) width;
- (float) widthWithFont: (UIFont *) font;

+ (CGSize)sizeWithString:(NSString *)string fontSize:(UIFont *)fontSize maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

//#pragma 正则匹配邮箱
//+ (BOOL) checkEmail:(NSString *)email;
//#pragma 正则匹配手机号
//+ (BOOL)checkTelNumber:(NSString *) telNumber;
//#pragma 正则匹配用户密码6-18位数字和字母组合
//+ (BOOL)checkPassword:(NSString *) password;
//#pragma 正则匹配用户姓名,20位的中文或英文
//+ (BOOL)checkUserName : (NSString *) userName;
//#pragma 正则匹配用户身份证号
//+ (BOOL)checkUserIdCard: (NSString *) idCard;
//#pragma 正则匹员工号,12位的数字
//+ (BOOL)checkEmployeeNumber : (NSString *) number;
//#pragma 正则匹配URL
//+ (BOOL)checkURL : (NSString *) url;
@end
