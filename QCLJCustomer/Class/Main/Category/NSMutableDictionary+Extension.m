//
//  NSMutableDictionary+Extension.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/12/6.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"
#import "Comment.h"
#import "MD5.h"//加密md5
@implementation NSMutableDictionary (Extension)
+ (void)addParamsClientTimeAndTokenTo:(NSMutableDictionary *) params{
    
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *clientTime = [NSString stringWithFormat:@"%llu",theTime];
    
    //加密
    NSString *token = [MD5 md5:[NSString stringWithFormat:@"%@%@",MD5Password,clientTime]];;
    
    VDLog(@"\n加密前：%@\n加密后：%@ ",clientTime,token);
    params[@"clientTime"] = clientTime;
    params[@"token"] = token;
}

@end
