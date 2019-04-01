//
//  MembershipCardMode.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/9.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MembershipCardMode.h"

@implementation MembershipCardMode
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"memberID" : @"id"};
}
@end
