//
//  Order.m
//  AlixPayDemo
//
//  Created by 方彬 on 11/2/13.
//
//

#import "Order.h"

@implementation Order

- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.inputCharset) {
        [discription appendFormat:@"_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.body) {
        [discription appendFormat:@"&body=\"%@\"", self.body];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    if (self.outTradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.outTradeNO];
    }
    if (self.partner) {
        [discription appendFormat:@"&partner=\"%@\"", self.partner];
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.sellerID) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.sellerID];
    }
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.subject) {
        [discription appendFormat:@"&subject=\"%@\"", self.subject];
    }
    
    if (self.totalFee) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.totalFee];
    }
    
    
//    if (self.itBPay) {
//        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
//    }
//    if (self.showURL) {
//        [discription appendFormat:@"&show_url=\"%@\"",self.showURL];//m.alipay.com
//    }
//    if (self.appID) {
//        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
//    }
//    for (NSString * key in [self.outContext allKeys]) {
//        [discription appendFormat:@"&%@=\"%@\"", key, [self.outContext objectForKey:key]];
//    }
    return discription;
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"totalFee" : @"total_fee",
             @"outTradeNO" : @"out_trade_no",
             @"notifyURL" : @"notify_url",
             @"inputCharset" : @"_input_charset",
             @"sellerID" : @"seller_id",
             @"paymentType" : @"payment_type"
             };
}



@end
