//
//  ThirdPartyLoginModel.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/23.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdPartyLoginModel : NSObject
/**
 用户姓名
 */
@property (nonatomic, copy) NSString * name;
/**
 用户手机号
 */
@property (nonatomic, copy) NSString * mob;
/**
 用户生日
 */
@property (nonatomic, copy) NSString * birthday;
/**
 用户ID
 */
@property (nonatomic, copy) NSString * userId;
/**
 用户地址
 */
@property (nonatomic, copy) NSString * address;
///**
// 用户姓名
// */
//@property (nonatomic, copy) NSString * contactName;
///**
//                                             
//                                             */
//@property (nonatomic, copy) NSString * contactTel;
/**
 用户地址ID
 */
@property (nonatomic, copy) NSString * addressId;
/**
 用户会员卡金额
 */
@property (nonatomic, copy) NSString * money;
///**
// 用户优惠券数量
// */
//@property (nonatomic, copy) NSString * couponCount;
/**
用户头像                                     
*/
@property (nonatomic, copy) NSString * img;
//
//[MYUserDefaults setObject:dataDic[@"name"] forKey:@"name"];
//[MYUserDefaults setObject:dataDic[@"mob"] forKey:@"mob"];
////        [MYUserDefaults setObject:dataDic[@"sex"] forKey:@"sex"];
//[MYUserDefaults setObject:dataDic[@"birthday"] forKey:@"birthday"];
//[MYUserDefaults setObject:dataDic[@"userId"] forKey:@"userId"];
//[MYUserDefaults setObject:dataDic[@"address"] forKey:@"address"];
//[MYUserDefaults setObject:dataDic[@"contactName"] forKey:@"contactName"];
//[MYUserDefaults setObject:dataDic[@"contactTel"] forKey:@"contactTel"];
//[MYUserDefaults setObject:dataDic[@"addressId"] forKey:@"addressId"];
//[MYUserDefaults setObject:dataDic[@"money"] forKey:@"money"];//会员卡金额
//[MYUserDefaults setObject:dataDic[@"couponCount"] forKey:@"couponCount"];//优惠券数量
//
//[MYUserDefaults setObject:dataDic[@"img"] forKey:@"img"];
//[MYUserDefaults synchronize];

@end
