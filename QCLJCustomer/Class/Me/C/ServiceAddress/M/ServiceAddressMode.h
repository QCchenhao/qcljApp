//
//  ServiceAddressMode.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceAddressMode : NSObject
/**地址 */
@property (nonatomic, copy) NSString *address;
/**地址ID */
@property (nonatomic, copy) NSString *addressId;
/**地址状态 */
@property (nonatomic, copy) NSString *state; //1 为默认地址  2 不是默认地址
@end
