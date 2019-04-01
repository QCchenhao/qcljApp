//
//  ThirdPartyLoginViewController.h
//  七彩乐居
//
//  Created by QCJJ－iOS on 16/6/16.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"

typedef void (^ReturnUeseNameTextToLogBlock)(UIImage * ueseImage,NSString *nameStr, NSString * mobStr , NSString * adderss );

@interface ThirdPartyLoginViewController : UIViewController
//-(void)getWeiXinReturnMessageWithCode:(NSString *)code;

/** 通过block去执行AppDelegate中的wechatLoginByRequestForUserInfo方法 */
//@property (copy, nonatomic) void (^requestForUserInfoBlock)();

- (void)getWeiXinOpenId:(BaseResp *)resp;

@property (nonatomic, copy) NSString * teleNuber;

@property (nonatomic, copy) ReturnUeseNameTextToLogBlock returnUeseNameTextToLogBlock;
- (void)returnText:(ReturnUeseNameTextToLogBlock)block;

@end
