//
//  DetailsModel.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetailsModel : NSObject
/** 订单ID */
@property (nonatomic, copy) NSString * orderId;
/**订单编号 */
@property (nonatomic, copy) NSString *snum ;
/**订单类型 */
@property (nonatomic, assign) NSInteger stid  ;
/**订单状态*/
@property (nonatomic, assign) NSInteger state  ;
/**类型不是42 服务时间*/
@property (nonatomic, copy) NSString *stime  ;
/**类型不是42 地址 */
@property (nonatomic, copy) NSString *address   ;
/**类型为24 25 雇主信息即：男女宝宝，宝宝年龄 房屋
 大小，饭菜口味（里面为两个参数中间用
 逗号隔开）
  */
@property (nonatomic, copy) NSString *econdition  ;
/**类型为24 25 服务时长 */
@property (nonatomic, copy) NSString *smins ;
/**类型为24 25 心理价位 */
@property (nonatomic, copy) NSString *mprice   ;
/**类型为24 25 是否住家  0住家 1不住家 若为3则为空*/
@property (nonatomic, assign) NSInteger ishome   ;
/**当类型为40 套餐名称  1为保洁套餐  */
@property (nonatomic, copy) NSString *stype  ;
/**当类型为40 数量*/
@property (nonatomic, copy) NSString *count  ;
/**当类型为40 总价*/
@property (nonatomic, assign) CGFloat sprice ;
/**当类型为40 套餐价格（单价）*/
@property (nonatomic, assign) CGFloat price  ;
/**当类型为40 服务费*/
@property (nonatomic, assign) CGFloat einsu   ;
/**当类型为42 代收工资*/
@property (nonatomic, assign) CGFloat daishou   ;
/**当类型为42 佣金*/
@property (nonatomic, assign) CGFloat yongjin   ;
/**当类型为22 星级 */
@property (nonatomic, assign) NSInteger smoney  ;
///**当类型为41 服务类型  （具体服务的名称）*/
//@property (nonatomic, copy) NSString *stype  ;
/**当类型为41 公司名称*/
@property (nonatomic, copy) NSString *companyname    ;
/**当类型为42 总价*/
//@property (nonatomic, copy) NSString *sprice  ;
/**当订单状态为0 1  且类型为22 24 25  对阿姨的要求 学历，年龄，上岗证*/
@property (nonatomic, copy) NSString *acondition   ;
/**当订单状态为0 1  且类型为22 24 25  宠物*/
@property (nonatomic, copy) NSString *pet   ;
/**当订单状态不为0 1  且类型22 24 25 41   总价*/
//@property (nonatomic, copy) NSString *sprice   ;
/**当订单状态不为0 1  且类型22 24 25 41   保险*/
//@property (nonatomic, copy) NSString *einsu   ;
/**当订单状态不为0 1  且类型22 24 25 41   服务金额*/
//@property (nonatomic, copy) NSString *price  ;

/**
 *  服务中状态 阿姨电话
 */
@property (nonatomic, copy) NSString *domeTel;
@end
