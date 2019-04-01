//
//  NSString+File.m
//  河科院微博
//
//  Created by 👄 on 15/7/31.
//  Copyright (c) 2015年 sczy. All rights reserved.
//


#import "NSString+File.h"


@implementation NSString (File)

- (float) heightWithFont: (UIFont *) font withinWidth: (float) width
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return ceil(textRect.size.height);
}

- (float) widthWithFont: (UIFont *) font
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return textRect.size.width;
}

- (long long)fileSize
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 1.路径不存在就返回
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    if (fileExists == NO) return 0;
    
    // 2.判断路径是不是文件夹
    if (isDirectory) { // 是
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:self error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            totalSize += [fullSubpath fileSize];
        }
        return totalSize;
    } else { // 不是
        // 计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:self error:nil];
        return [attr[NSFileSize] longLongValue];
    }
}

+ (CGSize)sizeWithString:(NSString *)string fontSize:(UIFont *)fontSize maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    NSDictionary *stringDict = @{NSFontAttributeName : fontSize};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:stringDict context:nil].size;
}

//
//#pragma 正则匹配邮箱
//+ (BOOL) checkEmail:(NSString *)email
//{
//    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:email];
//}
//#pragma 正则匹配手机号
//+ (BOOL)checkTelNumber:(NSString *) telNumber
//{
//    NSString *pattern =@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:telNumber];
//    return isMatch;
//}
//
//
//#pragma 正则匹配用户密码6-20位数字和字母组合
//+ (BOOL)checkPassword:(NSString *) password
//{
//    NSString *pattern =@"^[a-zA-Z0-9]{6,20}+$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:password];
//    return isMatch;
//    
//}
//
//#pragma 正则匹配用户姓名,2-4位的中文或英文
//+ (BOOL)checkUserName : (NSString *) userName
//{
////    NSString *pattern =@"^[a-zA-Z一-龥]{1,20}";#pragma 正则匹配用户姓名,20位的中文或英文
////    NSString *pattern =@"^[\u4E00-\u9FA5]{2,4}";
////        NSString *pattern =@"^([\u4E00-\u9FA5]+|[a-zA-Z]+)$";//真是姓名判断
//    
//     NSString *pattern =@"^([\u4E00-\u9FA5]+|[a-zA-Z]+)$";//真是姓名判断
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:userName];
//    return isMatch;
//    
//    
//}
//
//
//#pragma 正则匹配用户身份证号15或18位
//+ (BOOL)checkUserIdCard: (NSString *) idCard
//{
//    NSString *pattern =@"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:idCard];
//    return isMatch;
//}
//
//#pragma 正则匹员工号,12位的数字
//+ (BOOL)checkEmployeeNumber : (NSString *) number
//{
//    NSString *pattern = @"^[0-9]{12}";
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:number];
//    return isMatch;
//    
//}
//
//#pragma 正则匹配URL
//+ (BOOL)checkURL : (NSString *) url
//{
//    NSString *pattern =@"^[0-9A-Za-z]{1,50}";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:url];
//    return isMatch;
//    
//}
@end


