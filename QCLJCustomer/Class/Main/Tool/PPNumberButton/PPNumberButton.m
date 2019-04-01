//
//  PPNumberButton.m
//  PPNumberButton
//
//  Created by AndyPang on 16/8/31.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import "PPNumberButton.h"

#import "Comment.h"

#ifdef DEBUG
#define PPLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define PPLog(...)
#endif


@interface PPNumberButton ()<UITextFieldDelegate>

/** 减按钮*/
@property (nonatomic, strong) UIButton *decreaseBtn;
/** 加按钮*/
@property (nonatomic, strong) UIButton *increaseBtn;
/** 数量展示/输入框*/
@property (nonatomic, strong) UITextField *textField;
/** 快速加减定时器*/
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PPNumberButton

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
        //整个控件的默认尺寸(和某宝上面的按钮同样大小)
        if(CGRectIsEmpty(frame)) {
            self.frame = CGRectMake(0, 0, 110, 30);
        };
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

+ (instancetype)numberButtonWithFrame:(CGRect)frame
{
    return [[PPNumberButton alloc] initWithFrame:frame];
}
#pragma mark - UI布局
- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3.f;
    self.clipsToBounds = YES;
    
    //减,加按钮
    _decreaseBtn = [self setupButtonWithTitle:@"－"];
    _increaseBtn = [self setupButtonWithTitle:@"＋"];
    
    //数量展示/输入框
    _textField = [[UITextField alloc] init];
    _textField.text = @"1";
    _textField.enabled = NO;
    _textField.textColor = QiCaiShallowColor;
    _textField.delegate = self;
    _textField.font = [UIFont boldSystemFontOfSize:12];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self addSubview:_textField];
}

//设置加减按钮的公共方法
- (UIButton *)setupButtonWithTitle:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
    [self addSubview:button];
    return button;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    //加减按钮为正方形
    CGFloat height = self.frame.size.height;
    CGFloat width =  self.frame.size.width;
    _decreaseBtn.frame = CGRectMake(0, 0, height, height);
    _increaseBtn.frame = CGRectMake(width - height, 0, height, height);
    _textField.frame = CGRectMake(height, 0, width - height * 2, height);
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (self.maxNumber) {
         textField.text.length == 0 || textField.text.integerValue >= self.maxNumber ? _textField.text = [NSString stringWithFormat:@"%ld",(long)self.maxNumber] : nil;
    }else{
        textField.text.length == 0 || textField.text.integerValue <= 0 ? _textField.text = @"1" : nil;
    }
   
//    _numberBlock ? _numberBlock(_textField.text) : nil;
//    _delegate ? [_delegate PPNumberButton:self number:_textField.text] : nil;
    
    if (_unitSuffixStr) {
        if([textField.text rangeOfString:_unitSuffixStr].location !=NSNotFound)//_roaldSearchText
        {
           
        }else{
            _numberBlock ? _numberBlock(_textField.text) : nil;
            _delegate ? [_delegate PPNumberButton:self number:_textField.text] : nil;
            _textField.text = [NSString stringWithFormat:@"%@%@",_textField.text,_unitSuffixStr];
        }
    }else{
//        textField.text.length == 0 || textField.text.integerValue <= 0 ? _textField.text = @"1" : nil;
        _numberBlock ? _numberBlock(_textField.text) : nil;
        _delegate ? [_delegate PPNumberButton:self number:_textField.text] : nil;

    }

    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (_unitSuffixStr) {
        if([textField.text rangeOfString:_unitSuffixStr].location !=NSNotFound)//_roaldSearchText
        {
            NSLog(@"yes");
            NSRange endRange = [textField.text rangeOfString:_unitSuffixStr];

            NSRange range = NSMakeRange(0 , textField.text.length - endRange.length);
            textField.text = [textField.text substringWithRange:range];//截取范围类的字符串
            NSLog(@"截取的值为：%@",textField.text);
        }
    }
}
#pragma mark - 加减按钮点击响应
//点击: 单击逐次加减,长按连续加减
- (void)touchDown:(UIButton *)sender
{
    [_textField resignFirstResponder];
    
    if (sender == _increaseBtn) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(increase) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(decrease) userInfo:nil repeats:YES];
    }
    [_timer fire];
}
//松开
- (void)touchUp:(UIButton *)sender
{
    [self cleanTimer];
}

//加
- (void)increase
{

    _textField.text.length == 0 ? _textField.text = @"1" : nil;
    NSInteger number = [_textField.text integerValue] + 1;
    if (self.maxNumber) {
        if (number > self.maxNumber)
        {
            self.isShakeAnimation ? [self shakeAnimation] : nil;
            PPLog(@"数量不能大于self.maxNumber");
        }else{
            
            if (_unitSuffixStr) {
                _textField.text = [NSString stringWithFormat:@"%ld%@", number,_unitSuffixStr];
                _numberBlock ? _numberBlock([NSString stringWithFormat:@"%ld", number]) : nil;
                _delegate ? [_delegate PPNumberButton:self number:[NSString stringWithFormat:@"%ld", number]] : nil;

            }else{
                _textField.text = [NSString stringWithFormat:@"%ld", number];
                _numberBlock ? _numberBlock(_textField.text) : nil;
                _delegate ? [_delegate PPNumberButton:self number:_textField.text] : nil;

            }
           
        }
    }else{
        if (_unitSuffixStr) {
            _textField.text = [NSString stringWithFormat:@"%ld%@", number,_unitSuffixStr];
            _numberBlock ? _numberBlock([NSString stringWithFormat:@"%ld", number]) : nil;
            _delegate ? [_delegate PPNumberButton:self number:[NSString stringWithFormat:@"%ld", number]] : nil;
            
        }else{
            _textField.text = [NSString stringWithFormat:@"%ld", number];
            _numberBlock ? _numberBlock(_textField.text) : nil;
            _delegate ? [_delegate PPNumberButton:self number:_textField.text] : nil;
            
        }
 
    }
   
}

//减
- (void)decrease
{
    _textField.text.length == 0 ? _textField.text = @"1" : nil;
    NSInteger number = [_textField.text integerValue] - 1;
    if (number > 0)
    {
        if (_unitSuffixStr) {
            _textField.text = [NSString stringWithFormat:@"%ld%@", number,_unitSuffixStr];
            _numberBlock ? _numberBlock([NSString stringWithFormat:@"%ld", number]) : nil;
            _delegate ? [_delegate PPNumberButton:self number:[NSString stringWithFormat:@"%ld", number]] : nil;
            
        }else{
            _textField.text = [NSString stringWithFormat:@"%ld", number];
            _numberBlock ? _numberBlock(_textField.text) : nil;
            _delegate ? [_delegate PPNumberButton:self number:_textField.text] : nil;
            
        }
    }
    else
    {
        self.isShakeAnimation ? [self shakeAnimation] : nil;
        PPLog(@"数量不能小于1");
    }
}

- (void)cleanTimer
{
    if (_timer.isValid)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc
{
    [self cleanTimer];
}

#pragma mark - 加减按钮的属性设置

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
    _decreaseBtn.layer.borderColor = [borderColor CGColor];
    _increaseBtn.layer.borderColor = [borderColor CGColor];
    
    self.layer.borderWidth = 0.5;
    _decreaseBtn.layer.borderWidth = 0.5;
    _increaseBtn.layer.borderWidth = 0.5;
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont
{
    _increaseBtn.titleLabel.font = buttonTitleFont;
    _decreaseBtn.titleLabel.font = buttonTitleFont;
}

- (void)setTitleWithIncreaseTitle:(NSString *)increaseTitle decreaseTitle:(NSString *)decreaseTitle
{
    [_increaseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_decreaseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [_increaseBtn setTitle:increaseTitle forState:UIControlStateNormal];
    [_decreaseBtn setTitle:decreaseTitle forState:UIControlStateNormal];
}

- (void)setImageWithIncreaseImage:(UIImage *)increaseImage decreaseImage:(UIImage *)decreaseImage
{
    [_increaseBtn setTitle:@"" forState:UIControlStateNormal];
    [_decreaseBtn setTitle:@"" forState:UIControlStateNormal];
    
    [_increaseBtn setBackgroundImage:increaseImage forState:UIControlStateNormal];
    [_decreaseBtn setBackgroundImage:decreaseImage forState:UIControlStateNormal];
}

#pragma mark - 输入框中的内容设置
- (NSString *)currentNumber
{
    return _textField.text;
}

- (void)setCurrentNumber:(NSString *)currentNumber
{
    _textField.text = currentNumber;
}

- (void)setInputFieldFont:(UIFont *)inputFieldFont
{
    _textField.font = inputFieldFont;
}
#pragma mark - 初始有单位
- (void)setUnitSuffixStr:(NSString *)unitSuffixStr{
    _unitSuffixStr = unitSuffixStr;
    _textField.text = [NSString stringWithFormat:@"1%@",unitSuffixStr];
}
-(void)setInput:(BOOL)input{
    
    if (input) {
        _textField.enabled = YES;
    }else{
        _textField.enabled = NO;
    }
}
#pragma mark - 抖动动画
- (void)shakeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    //获取当前View的position坐标
    CGFloat positionX = self.layer.position.x;
    //设置抖动的范围
    animation.values = @[@(positionX-10),@(positionX),@(positionX+10)];
    //动画重复的次数
    animation.repeatCount = 3;
    //动画时间
    animation.duration = 0.07;
    //设置自动反转
    animation.autoreverses = YES;
    [self.layer addAnimation:animation forKey:nil];
}

@end
