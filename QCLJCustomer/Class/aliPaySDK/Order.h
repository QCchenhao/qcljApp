//
//  Order.h
//  AlixPayDemo
//
//  Created by 方彬 on 11/2/13.
//
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

//接口名称，固定为mobile.securitypay.pay。
@property (nonatomic, copy) NSString *service;

//商户在支付宝签约时，支付宝为商户分配的唯一标识号(以2088开头的16位纯数字)。
@property (nonatomic, copy) NSString *partner;

//卖家支付宝账号对应的支付宝唯一用户号(以2088开头的16位纯数字),订单支付金额将打入该账户,一个partner可以对应多个seller_id。
@property (nonatomic, copy) NSString *sellerID;

//商户网站使用的编码格式，固定为utf-8。
@property (nonatomic, copy) NSString *inputCharset;

//支付类型，1：商品购买。(不传情况下的默认值)
@property (nonatomic, copy) NSString *paymentType;

//支付宝服务器主动通知商户网站里指定的页面http路径。
@property (nonatomic, copy) NSString *notifyURL;
//商户网站商品对应的唯一订单号。
@property (nonatomic, copy) NSString *outTradeNO;

//商品的标题/交易标题/订单标题/订单关键字等。
@property (nonatomic, copy) NSString *subject;

//该笔订单的资金总额，单位为RMB(Yuan)。取值范围为[0.01，100000000.00]，精确到小数点后两位。
@property (nonatomic, copy) NSString *totalFee;

//对一笔交易的具体描述信息。如果是多种商品，请将商品描述字符串累加传给body。
@property (nonatomic, copy) NSString *body;

@end
