//
//  HMpickViewController.m
//  CustomDatePickView
//
//  Created by WXYT-iOS2 on 16/8/13.
//  Copyright © 2016年 WXYT-iOS2. All rights reserved.
//

#import "HMDatePickView.h"

#import "UIView+Extension.h"

@interface HMDatePickView()<UIGestureRecognizerDelegate>
{
    NSString *_dateStr;
}
@property(strong, nonatomic) UIDatePicker *hmDatePicker;

@end

@implementation HMDatePickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.227 alpha:0.5];
//        [self createPickerView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigMap)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}
- (void)bigMap{
    [self removeFromSuperview];
}
//http://www.cocoachina.com/ios/20161014/17748.html
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//    if ([touch.view isDescendantOfView:self.smallView]) {
//        return NO;
//    }
//    return YES;
//}

#pragma mark -- 选择器
- (void)configuration {
    //时间选择器
    UIView *dateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.93, self.frame.size.height  * 0.28)];
    dateBgView.backgroundColor = [UIColor whiteColor];
    dateBgView.centerX = self.frame.size.width /2 ;
    dateBgView.centerY = self.frame.size.height * 0.4 ;
    
    [self addSubview:dateBgView];
    
    //确定按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(dateBgView.bounds.size.width - 50, 0, 40, 30);
    commitBtn.tag = 1;
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(pressentPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [dateBgView addSubview:commitBtn];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0, 40, 30);
    cancelBtn.tag = 2;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(pressentPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [dateBgView addSubview:cancelBtn];
    
    UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 38,CGRectGetWidth(self.frame), CGRectGetHeight(dateBgView.frame)  * 0.7)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *currentDate = [NSDate date];
    
    if (self.fontColor) {
        [commitBtn setTitleColor:self.fontColor forState:UIControlStateNormal];
        [cancelBtn setTitleColor:self.fontColor forState:UIControlStateNormal];
    }
    
    //设置默认日期
    if (!self.date) {
        self.date = currentDate;
    }
    datePicker.date = self.date;
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    
    _dateStr = [formater stringFromDate:self.date];
    
    NSString *tempStr = [formater stringFromDate:self.date];
    NSArray *dateArray = [tempStr componentsSeparatedByString:@"-"];
    
    //设置日期选择器最大可选日期
    if (self.maxYear || self.maxYear == 0) {
        NSInteger maxYear = [dateArray[0] integerValue] - self.maxYear;
        NSString *maxStr = [NSString stringWithFormat:@"%ld-%@-%@",maxYear,dateArray[1],dateArray[2]];
        NSDate *maxDate = [formater dateFromString:maxStr];
        datePicker.maximumDate = maxDate;
    }
    
    //设置日期选择器最小可选日期
    if (self.minYear || self.minYear == 0) {
        
        NSInteger minYear = [dateArray[0] integerValue] - self.minYear;
        NSString *minStr = [NSString stringWithFormat:@"%ld-%@-%@",minYear,dateArray[1],dateArray[2]];
        NSDate* minDate = [formater dateFromString:minStr];
        datePicker.minimumDate = minDate;
    }
    
    [dateBgView addSubview: datePicker];
    self.hmDatePicker = datePicker;
    
    [self.hmDatePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -- 时间选择器确定/取消
- (void)pressentPickerView:(UIButton *)button {
    //确定
    if (button.tag == 1) {
        //确定
        self.completeBlock(_dateStr);
    }
    [self removeFromSuperview];
}

#pragma mark -- 时间选择器日期改变
-(void)selectDate:(id)sender {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    _dateStr =[outputFormatter stringFromDate:self.hmDatePicker.date];
    
}

@end
