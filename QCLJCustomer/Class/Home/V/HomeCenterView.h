//
//  HomeCenterView.h
//  七彩乐居
//
//  Created by 李大娟 on 16/3/1.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickHomeCenterViewDelegate <NSObject>

/**
 月嫂（Maternity matron）
 */
-(void)clickMaternityMatronBtn;

/**
 育儿嫂（Parental）
 */
-(void)clickParentalBtn;

/**
 保姆 Nanny
 */
-(void)clickNannyBtn;

/**
保洁套餐 Cleaning package
 */
-(void)clickCleaningPackageBtn;

/**
企业服务 Enterprise service
 */
-(void)clickEnterpriseServiceBtn;

/**
门店消费 Store consumption
 */
-(void)clickStoreConsumptionBtn;

@end


@interface HomeCenterView : UIView
@property (weak,nonatomic)  id <clickHomeCenterViewDelegate> homeCenterViewDelegate;

@end
