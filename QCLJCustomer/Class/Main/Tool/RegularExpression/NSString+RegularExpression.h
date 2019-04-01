//
//  NSString+RegularExpression.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/19.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpression)
/*!
 @brief 正则匹配邮箱
 */
+ (BOOL) checkEmail:(NSString *)email;
/*!
 @brief 正则匹配手机号
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;
/*!
 @brief 正则匹配用户密码6-18位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *) password;
/*!
 @brief 正则匹配用户姓名,20位的中文或英文
 */
+ (BOOL)checkUserName : (NSString *) userName;
/*!
 @brief 正则匹配用户身份证号
 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;
/*!
 @brief 正则匹员工号,12位的数字
 */
+ (BOOL)checkEmployeeNumber : (NSString *) number;
/*!
 @brief 正则匹配URL
 */
+ (BOOL)checkURL : (NSString *) url;
/*!
 @brief 正则匹配银行卡
 */
+ (BOOL) checkBankCardNumber: (NSString *)bankCardNumber;
/*!
 @brief 正则匹配身份证号
 */
+ (BOOL) checkIdentityCard: (NSString *)identityCard;
/*!
 @brief 正则匹配手机号码验证
 */
+ (BOOL) checkMobile:(NSString *)mobile;
/*!
 @brief 正则匹配手机金额
 */
+ (BOOL)checkMoney:(NSString *)money;
@end
