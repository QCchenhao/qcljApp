//
//  OrderTableViewCell.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "Comment.h"

@interface OrderTableViewCell ()

@property (nonatomic,strong) UILabel * orderTypLabel;//订单类型
@property (nonatomic,strong)UILabel * dateLabel;//时间
@property (nonatomic,strong)UILabel * locationLabel;//定位
@property (nonatomic,strong) UILabel * orderMumberLabel;//订单编号
@property (nonatomic,strong) UILabel * serviceTypLabel;//服务类型

@property (nonatomic,strong) UIView * line2;//下划线2

@property (nonatomic,strong) UIButton * redButton;//左按钮
@property (nonatomic,strong) UIButton * whiteButton;//右按钮

@property (nonatomic,assign) CGRect rightButtonRect1;
@property (nonatomic,assign) CGRect leftButtonRect2;

@end
@implementation OrderTableViewCell
- (UIButton *)redButton{
    if (!_redButton) {
       _redButton = [UIButton addButtonWithFrame:_leftButtonRect2 ButtonTitle:@"确认付款" titleColor:[UIColor whiteColor] titleFont:QiCaiDetailTitle12Font borderColor:QiCaiNavBackGroundColor backGroundColor:QiCaiNavBackGroundColor Target:nil action:nil btnCornerRadius:CGRectGetHeight(_leftButtonRect2) / 2];
        [self.contentView addSubview:_redButton];
    }
    return _redButton;
}
- (UIButton *)whiteButton{
    if (!_whiteButton) {
        _whiteButton = [UIButton addButtonWithFrame:_rightButtonRect1 ButtonTitle:@"取消订单" titleColor:[UIColor grayColor] titleFont:QiCaiDetailTitle12Font borderColor:QiCaiBackGroundColor backGroundColor:nil Target:nil action:nil btnCornerRadius:CGRectGetHeight(_rightButtonRect1) / 2];
        [self.contentView addSubview:_whiteButton];
    }
    return _whiteButton;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIView * lins = [[UIView alloc]init];
        lins.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 8);
        lins.backgroundColor = QiCaiBackGroundColor;
        [self.contentView addSubview:lins];
        
        //服务类型
        _serviceTypLabel = [UILabel addLabelWithFrame:CGRectMake(10, 10,  CGRectGetWidth(self.contentView.frame) * 0.15, 30) text:@"月嫂" size:12 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_serviceTypLabel];
        
        //订单编号
        _orderMumberLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(_serviceTypLabel.frame) + 10, CGRectGetMinY(_serviceTypLabel.frame), CGRectGetWidth(self.contentView.frame) * 0.7, CGRectGetHeight(_serviceTypLabel.frame)) text:@"订单编号：201610160001" size:12 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_orderMumberLabel];
        
        //订单类型
        _orderTypLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) * 0.65 - 10, CGRectGetMinY(_serviceTypLabel.frame), CGRectGetWidth(self.contentView.frame) * 0.35, CGRectGetHeight(_serviceTypLabel.frame)) text:@"● 待审查" textColor:QiCaiNavBackGroundColor backgroundColor:nil size:10 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_orderTypLabel];
        
        //下划线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_serviceTypLabel.frame), CGRectGetWidth(self.contentView.frame), 1)];
        line.backgroundColor = QiCaiBackGroundColor;
        [self.contentView addSubview:line];
        
        //时间
        UIImageView * timeImageView = [[UIImageView alloc]init];
        timeImageView.frame = CGRectMake(15, 0, 15, 15);
        timeImageView.image = [UIImage imageNamed:@"order_list_time"];
        [self.contentView addSubview:timeImageView];
        
        _dateLabel =[UILabel addLayerLabelWithFrame:CGRectMake(CGRectGetMaxX(timeImageView.frame) + 13, CGRectGetMaxY(line.frame) + 5, CGRectGetWidth(self.contentView.frame) * 0.8, 24) text:@"2016-9-29" textColor:[UIColor lightGrayColor] size:10 layerCornerRadius:0 layerBorderWidth:0 layerBorderColor:nil];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_dateLabel];
        
        timeImageView.centerY = _dateLabel.centerY;
        
        //定位
        UIImageView * locationImageView = [[UIImageView alloc]init];
        locationImageView.frame = CGRectMake(15, 0, 15, 15);
        locationImageView.image = [UIImage imageNamed:@"order_list_location"];
        locationImageView.centerX = timeImageView.centerX;
        [self.contentView addSubview:locationImageView];
        
        _locationLabel =[UILabel addLayerLabelWithFrame:CGRectMake(CGRectGetMaxX(locationImageView.frame) + 13, CGRectGetMaxY(_dateLabel.frame) + 5, CGRectGetWidth(self.contentView.frame) * 0.8, 24) text:@"北京" textColor:[UIColor lightGrayColor] size:10 layerCornerRadius:0 layerBorderWidth:0 layerBorderColor:nil];
//        _locationLabel.backgroundColor = [UIColor orangeColor];
        _locationLabel.numberOfLines = 0;
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_locationLabel];
        locationImageView.centerY = _locationLabel.centerY;
        
        //下划线2
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_locationLabel.frame), CGRectGetWidth(self.contentView.frame), 1)];
        _line2.backgroundColor = QiCaiBackGroundColor;
        [self.contentView addSubview:_line2];
        
        _leftButtonRect2 = CGRectMake(17, 0,( CGRectGetWidth(self.contentView.frame) - 2 * 17 - 13) / 2, 30);

//        [self.contentView addSubview:self.redButton];
        
          _rightButtonRect1= CGRectMake(CGRectGetMaxX(_leftButtonRect2) + 13, 0, CGRectGetWidth(_leftButtonRect2), CGRectGetHeight(_leftButtonRect2));
        
//
        
//        self.redButton.centerY = CGRectGetMaxY(_line2.frame) + 23.5;
//        self.whiteButton.centerY = self.redButton.centerY;



    }
    return self;
}

- (void)setOrderModel:(OrderModel *)orderModel{
    
    _orderModel = orderModel;
    
    NSString * stateStr ;
    switch (orderModel.state) {
        case 0:
            
            if ([orderModel.orderType isEqualToString:@"门店缴费"]) {
                stateStr = @"待付款";
                [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                
                [self addButton:self.whiteButton buttonTitle:@"取消" frame:self.leftButtonRect2 target:self action:@selector(cancelBtnClick:)];
                [self addButton:self.redButton buttonTitle:@"确认付款" frame:self.rightButtonRect1 target:self action:@selector(payBtnChile:)];
                self.whiteButton.hidden = NO;
                self.redButton.hidden = NO;
                
                self.whiteButton.tag = 0;
            }else{
                stateStr = @"未审核";
                [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                
                [self addButton:self.whiteButton buttonTitle:@"取消订单" frame:self.rightButtonRect1 target:self action:@selector(cancelBtnClick:)];
                self.whiteButton.tag = 0;
            }
            
            break;
        case 1:
            stateStr = @"未接单";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.whiteButton buttonTitle:@"取消订单" frame:self.rightButtonRect1 target:self action:@selector(cancelBtnClick:)];
            self.whiteButton.tag = 0;
            break;
        case 2:
            stateStr = @"面试中";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.whiteButton buttonTitle:@"取消" frame:self.leftButtonRect2 target:self action:@selector(cancelBtnClick:)];
            self.whiteButton.tag = 0;
            [self addButton:self.redButton buttonTitle:@"确认付款" frame:self.rightButtonRect1 target:self action:@selector(payBtnChile:)];
            self.whiteButton.hidden = NO;
            self.redButton.hidden = NO;
            break;
        case 3:
            stateStr = @"待付款";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.whiteButton buttonTitle:@"取消" frame:self.leftButtonRect2 target:self action:@selector(cancelBtnClick:)];
            self.whiteButton.tag = 0;
            [self addButton:self.redButton buttonTitle:@"确认付款" frame:self.rightButtonRect1 target:self action:@selector(payBtnChile:)];
            self.whiteButton.hidden = NO;
            self.redButton.hidden = NO;
            break;
        case 4:
            stateStr = @"待上门服务";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.whiteButton buttonTitle:@"续约订单" frame:self.leftButtonRect2 target:self action:@selector(renewBtnChile:)];
            [self addButton:self.redButton buttonTitle:@"确认完成" frame:self.rightButtonRect1 target:self action:@selector(completeBtnChile:)];
            self.whiteButton.hidden = NO;
            self.redButton.hidden = NO;
            self.whiteButton.tag = 10;
            break;
        case 5:
            stateStr = @"服务中";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.whiteButton buttonTitle:@"续约订单" frame:self.leftButtonRect2 target:self action:@selector(renewBtnChile:)];
            [self addButton:self.redButton buttonTitle:@"确认完成" frame:self.rightButtonRect1 target:self action:@selector(completeBtnChile:)];
            
            self.whiteButton.hidden = NO;
            self.redButton.hidden = NO;
            self.whiteButton.tag = 10;
            break;
        case 6:
            stateStr = @"待雇主确认";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.whiteButton buttonTitle:@"续约订单" frame:self.leftButtonRect2 target:self action:@selector(renewBtnChile:)];
            [self addButton:self.redButton buttonTitle:@"确认完成" frame:self.rightButtonRect1 target:self action:@selector(cancelBtnClick:)];
            self.whiteButton.hidden = NO;
            self.redButton.hidden = NO;
            self.whiteButton.tag = 10;
            break;
        case 7:
            stateStr = @"待评价";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.whiteButton buttonTitle:@"我来点评" frame:self.leftButtonRect2 target:self action:@selector(commentBtnChile:)];
            [self addButton:self.redButton buttonTitle:@"再来一单" frame:self.rightButtonRect1 target:self action:@selector(againBtnChile:)];
            self.whiteButton.hidden = NO;
            self.redButton.hidden = NO;
            break;
        case 8:
            if ([orderModel.orderType isEqualToString:@"门店缴费"]) {
                stateStr = @"已完成";
            }else{
                stateStr = @"已评价";
            }
            
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.redButton buttonTitle:@"再来一单" frame:self.rightButtonRect1 target:self action:@selector(againBtnChile:)];
            break;
        case 9:
            stateStr = @"已取消";
            break;
        case 10:
            stateStr = @"重新分配阿姨";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self addButton:self.whiteButton buttonTitle:@"续约订单" frame:self.leftButtonRect2 target:self action:@selector(renewBtnChile:)];
            [self addButton:self.redButton buttonTitle:@"确认完成" frame:self.rightButtonRect1 target:self action:@selector(completeBtnChile:)];
            self.whiteButton.hidden = NO;
            self.redButton.hidden = NO;
            self.whiteButton.tag = 10;
            break;
        case 11:
            stateStr = @"已付定金";
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            [self.whiteButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self.redButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self addButton:self.whiteButton buttonTitle:@"取消" frame:self.leftButtonRect2 target:self action:@selector(cancelBtnClick:)];
            [self addButton:self.redButton buttonTitle:@"确认付款" frame:self.rightButtonRect1 target:self action:@selector(payBtnChile:)];
            self.whiteButton.hidden = NO;
            self.redButton.hidden = NO;
            break;
            
        default:
            break;
    }
    

    _orderTypLabel.text = [NSString stringWithFormat:@"● %@",stateStr];
    _dateLabel.text = orderModel.createTime;
    if (![orderModel.address isEqualToString:@""]) {
        _locationLabel.text = orderModel.address;
    }else{
        _locationLabel.text = @"无地址";
    }
    _orderMumberLabel.text = orderModel.stid;
    _serviceTypLabel.text = orderModel.orderType;
    
    _serviceTypLabel.width = orderModel.orderType.length * 13;
    _orderMumberLabel.x  = CGRectGetMaxX(_serviceTypLabel.frame) + 10;
}

- (void)buttonChlie:(UIButton *)btn{
    
}
#pragma mark -button触发按钮
//取消订单
- (void)cancelBtnClick:(UIButton *)btn
{
    if (btn.tag == 0) {
        if ([self.topDelegate respondsToSelector:@selector(cancelButtonClick:)]) {
            [self.topDelegate cancelButtonClick:btn];
        }
    }
    
}
//确认付款
- (void)payBtnChile:(UIButton *)btn
{
    VDLog(@"确认付款");
    //    实现代理
    if ([self.topDelegate respondsToSelector:@selector(payButtonChile:)]) {
        [self.topDelegate payButtonChile:(UIButton *)btn];
    }
}
//续约订单
- (void)renewBtnChile:(UIButton *)btn
{
    //    实现代理
    if ([self.topDelegate respondsToSelector:@selector(renewButtonChile:)]) {
        [self.topDelegate renewButtonChile:(UIButton *)btn];
    }

}
//确认完成
- (void)completeBtnChile:(UIButton *)btn
{
    VDLog(@"确认完成");
    //    实现代理
    if ([self.topDelegate respondsToSelector:@selector(completeButtonChile:)]) {
        [self.topDelegate completeButtonChile:(UIButton *)btn];
    }
}
//我来点评
- (void)commentBtnChile:(UIButton *)btn
{
    //    实现代理
    if ([self.topDelegate respondsToSelector:@selector(commentButtonChile:)]) {
        [self.topDelegate commentButtonChile:(UIButton *)btn];
    }
}
//再来一单
- (void)againBtnChile:(UIButton *)btn
{
    //    实现代理
    if ([self.topDelegate respondsToSelector:@selector(againButtonChile:)]) {
        [self.topDelegate againButtonChile:(UIButton *)btn];
    }
}

//创建button方法
- (void)addButton:(UIButton *)btn buttonTitle:(NSString *)buttonTitle frame:(CGRect)frame target:(id)target action:(SEL)action{
    
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    btn.frame = frame;
    if (btn == self.whiteButton) {
        self.redButton.hidden = YES;
//        self.whiteButton.hidden = NO;
        btn.hidden = NO;
    }else{
        self.whiteButton.hidden = YES;
        btn.hidden = NO;
    }
    
    self.redButton.centerY = CGRectGetMaxY(_line2.frame) + 23.5;
    self.whiteButton.centerY = self.redButton.centerY;

}
@end
