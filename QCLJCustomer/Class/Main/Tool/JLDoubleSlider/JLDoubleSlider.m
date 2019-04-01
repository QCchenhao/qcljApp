//
//  JLDoubleSlider.m
//  JLDoubleSliderDemo
//
//  Created by linger on 16/1/13.
//  Copyright © 2016年 linger. All rights reserved.
//

#import "JLDoubleSlider.h"
#import "UIView+Extension.h"
//#import "UIImage+extent.h"
#import "UIButton+extent.h"
#import "Comment.h"


static const CGFloat sliderOffY = 32.0f;
static const CGFloat btnDiameter = 30.0f;

@interface JLDoubleSlider ()

@property (nonatomic,assign)CGFloat CurrentMinNum;

@property (nonatomic,assign)CGFloat CurrentMaxNum;



@end

@implementation JLDoubleSlider

{
    
    UIView *_minSliderLine;
    UIView *_maxSliderLine;
    UIView *_mainSliderLine;
    
    
    CGFloat _constOffY;
    
//    CGFloat _tatol;
}

- (instancetype)initWithFrame:(CGRect)frame jointArr:(NSArray *)jointArr unit:(NSString *)unit
{
    if (self == [super initWithFrame:frame]) {
//        if (frame.size.height < 80.0f) {
//            self.height = 80.0f;
//        }
        [self createMainViewWithJointArr:jointArr unit:unit];
    }
    return self;
}
//- (NSMutableArray *)jointArr{
//    if (!_jointArr) {
//        <#statements#>
//    }
//}
- (void)createMainViewWithJointArr:(NSArray *)jointArr unit:(NSString *)unit{
//    self.backgroundColor = [UIColor yellowColor];
//    _minLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.width/2.0f, 40)];
//    _maxLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2.0f, 10 ,self.width/2.0f , 40)];
//    _minLabel.textAlignment = NSTextAlignmentLeft;
//    _maxLabel.textAlignment = NSTextAlignmentRight;
//    _minLabel.adjustsFontSizeToFitWidth = YES;
//    //文字自动适应UILabel宽度的
//    _maxLabel.adjustsFontSizeToFitWidth = YES;
//    [self addSubview:_minLabel];
//    [self addSubview:_maxLabel];
    
    _jointArr = jointArr;
    self.minNum = jointArr[0];
    self.maxNum = jointArr[jointArr.count - 1];
    self.unit = unit;
//    self.joint = joint;
    
    _mainSliderLine = [[UIView alloc]initWithFrame:CGRectMake(btnDiameter / 2,sliderOffY, self.width -  btnDiameter , 1)];
    _mainSliderLine.backgroundColor = QiCaiNavBackGroundColor;
    [self addSubview:_mainSliderLine];
    
    _minSliderLine = [[UIView alloc]initWithFrame:CGRectMake(btnDiameter / 2, _mainSliderLine.y, 0, _mainSliderLine.height)];
    _minSliderLine.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_minSliderLine];
    
    _maxSliderLine = [[UIView alloc]initWithFrame:CGRectMake(self.width - btnDiameter / 2, _mainSliderLine.y, 0, _mainSliderLine.height)];
    _maxSliderLine.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_maxSliderLine];


    if (_jointArr.count > 0) {
        for (NSInteger i = 0; i < _jointArr.count ; i++) {
            UIView * temp = [[UIView alloc]init];
            CGFloat  tempH = 6 + 2;
            temp.frame = CGRectMake(0, CGRectGetMinY(_mainSliderLine.frame) - tempH, 1, tempH);
            temp.centerX = _mainSliderLine.width / (_jointArr.count - 1) * i + btnDiameter / 2;
            temp.backgroundColor = [UIColor darkGrayColor];
            [self addSubview:temp];
            
            NSString * labelText ;
            if (unit) {
                labelText = [NSString stringWithFormat:@"%@%@",_jointArr[i],unit];
            }else{
                labelText = [NSString stringWithFormat:@"%@",_jointArr[i]];
            }
            UILabel * label = [UILabel addLabelWithFrame:CGRectMake(0, 0, _mainSliderLine.width / 4, 20) text:labelText size:12 textAlignment:NSTextAlignmentCenter];
            [self addSubview:label];
            label.centerX = temp.centerX;
            label.centerY = _mainSliderLine.centerY - 20;
        }

    }
    
    
    UIButton *minSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(0,sliderOffY + btnDiameter / 2, btnDiameter  , btnDiameter )];
//    minSliderButton.backgroundColor = QiCaiNavBackGroundColor;

//    UIImage * minSliderButtonImage = [UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(30, 30)];
    [minSliderButton setImage:[UIImage imageNamed:@"home_slider_on"]  forState:UIControlStateNormal];//图片可以很小
    [minSliderButton setImage:[UIImage imageNamed:@"home_slider_on"]  forState:UIControlStateHighlighted];//图片可以很小
//    [minSliderButton setImageEdgeInsets:UIEdgeInsetsMake(btnDiameter, btnDiameter, btnDiameter, btnDiameter)];//这里设置图片和frame外框之间的间隙
    //设置按钮按下会发光
    minSliderButton.showsTouchWhenHighlighted = YES;
    minSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
    minSliderButton.layer.masksToBounds = YES;
//    minSliderButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    minSliderButton.layer.borderWidth = 0.5;
    UIPanGestureRecognizer *minSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinSliderButton:)];
    [minSliderButton addGestureRecognizer:minSliderButtonPanGestureRecognizer];
    [self addSubview:minSliderButton];
    minSliderButton.centerY = _mainSliderLine.centerY;
    _minSlider = minSliderButton;
    
    
    UIButton *maxSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width - btnDiameter , sliderOffY + btnDiameter / 2 , btnDiameter , btnDiameter )];
//    maxSliderButton.backgroundColor = QiCaiNavBackGroundColor;
    maxSliderButton.showsTouchWhenHighlighted = YES;
    maxSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
    maxSliderButton.layer.masksToBounds = YES;
    [maxSliderButton setImage:[UIImage imageNamed:@"home_slider_on"]  forState:UIControlStateNormal];
    [maxSliderButton setImage:[UIImage imageNamed:@"home_slider_on"]  forState:UIControlStateHighlighted];//图片可以很小
//    maxSliderButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    maxSliderButton.layer.borderWidth = 0.5;
    UIPanGestureRecognizer *maxSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMaxSliderButton:)];
    [maxSliderButton addGestureRecognizer:maxSliderButtonPanGestureRecognizer];
    [self addSubview:maxSliderButton];
    maxSliderButton.centerY = _mainSliderLine.centerY;
    _maxSlider = maxSliderButton;
    _constOffY = _mainSliderLine.centerY;
    
}

- (void)panMinSliderButton:(UIPanGestureRecognizer *)pgr
{
    CGPoint point = [pgr translationInView:self];
    static CGPoint center;
    if (pgr.state == UIGestureRecognizerStateBegan) {
        center = pgr.view.center;
    }
    pgr.view.center = CGPointMake(center.x + point.x, center.y + point.y);
    pgr.view.centerY = _constOffY;
    
    
    if (pgr.view.centerX > _maxSlider.centerX - _mainSliderLine.width / (_jointArr.count - 1) / 2 ) {
        pgr.view.centerX = _maxSlider.centerX - _mainSliderLine.width / (_jointArr.count - 1)  ;
    }else{
        if (pgr.view.centerX < btnDiameter / 2) {
            pgr.view.centerX = btnDiameter / 2;
        }
        if (pgr.view.centerX > self.width-btnDiameter / 2) {
            pgr.view.centerX = self.width-btnDiameter / 2;
        }
    }
    _minSliderLine.frame = CGRectMake(_minSliderLine.x, _minSliderLine.y,  pgr.view.centerX-_minSliderLine.x, _minSliderLine.height);
//    [self valueMinChange:pgr.view.x];
    
    if (pgr.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"%f",pgr.view.x);
        NSInteger viewLeft = pgr.view.x;
        NSInteger width = _mainSliderLine.width / (_jointArr.count - 1) ;
        CGFloat wid =  _mainSliderLine.width / (_jointArr.count - 1);
        //倍数
        NSInteger multiple = viewLeft / width;
        //余数
        NSInteger remainder = viewLeft % width;
        if (remainder >= width / 2) {
            multiple++;
        }
        
//        NSLog(@"倍数 =%ld",(long)multiple);
//        NSLog(@"余数 =%ld",(long)remainder);
        
//        pgr.view.centerX = multiple * width + btnDiameter /2;
        pgr.view.centerX =  wid * multiple + btnDiameter/ 2 ;

//        if (multiple == 4) {
//            pgr.view.centerX = self.width - btnDiameter / 2;
//        }else
        if (multiple == 0) {
            pgr.view.centerX = btnDiameter / 2;
        }
        pgr.view.centerY = _constOffY;
        
        _minSliderLine.frame = CGRectMake(_minSliderLine.x, _minSliderLine.y,  pgr.view.centerX-_minSliderLine.x, _minSliderLine.height);
        
        [self valueMinChange:multiple];
        
        
    }

}
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
//{
//    CGRect bounds = self.bounds;
//    //若原热区小于44x44，则放大热区，否则保持原大小不变
//    CGFloat widthDelta = MAX(77.0 - bounds.size.width, 0);
//    CGFloat heightDelta = MAX(77.0 - bounds.size.height, 0);
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//    return CGRectContainsPoint(bounds, point);
//}
- (void)panMaxSliderButton:(UIPanGestureRecognizer *)pgr
{
    CGPoint point = [pgr translationInView:self];
    static CGPoint center;
    if (pgr.state == UIGestureRecognizerStateBegan) {
        center = pgr.view.center;
//        NSLog(@"%f",point.x);
    }
    
    pgr.view.center = CGPointMake(center.x + point.x, center.y + point.y);
    pgr.view.centerY = _constOffY;
    
    if (pgr.view.centerX < _minSlider.centerX + _mainSliderLine.width / (_jointArr.count - 1) / 2) {
        pgr.view.centerX = _minSlider.centerX + _mainSliderLine.width / (_jointArr.count - 1) ;
    }else{
        if (pgr.view.centerX < btnDiameter / 2) {
            pgr.view.centerX = btnDiameter / 2;
        }
        if (pgr.view.centerX > self.width-btnDiameter / 2) {
            pgr.view.centerX = self.width-btnDiameter / 2;
        }
    }
    _maxSliderLine.frame = CGRectMake(pgr.view.centerX, _maxSliderLine.y, self.width-pgr.view.centerX-btnDiameter/2, _maxSliderLine.height);
//    [self valueMaxChange:pgr.view.x];
    
    
    //
    if (pgr.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"%f",pgr.view.x);
        NSInteger viewLeft = pgr.view.x;
        NSInteger width = _mainSliderLine.width / (_jointArr.count - 1);
         CGFloat wid =  _mainSliderLine.width / (_jointArr.count - 1);
        //倍数
        NSInteger multiple = viewLeft / width;
        //余数
        NSInteger remainder = viewLeft % width;
        if (remainder >= width / 2) {
            multiple++;
        }
        
//        NSLog(@"倍数 =%ld",(long)multiple);
//        NSLog(@"余数 =%ld",(long)remainder);
        
//        pgr.view.centerX = multiple * width + btnDiameter ;
        pgr.view.centerX = wid * multiple + btnDiameter / 2;
        
        if (multiple == 4) {
            pgr.view.centerX = self.width - btnDiameter / 2;
        }
        pgr.view.centerY = _constOffY;
        
        _maxSliderLine.frame = CGRectMake(pgr.view.centerX, _maxSliderLine.y, self.width-pgr.view.centerX-btnDiameter/2, _maxSliderLine.height);
        
        [self valueMaxChange:multiple];
        
        
    }

}

- (void)valueMinChange:(NSInteger)index
{
//    _minLabel.text = [NSString stringWithFormat:@"%.f%@",_minNum + (_tatol * (num-btnDiameter )),_unit];
//    _currentMinValue = _minNum + (_tatol * (num-btnDiameter ));
    
    _currentMinValue = _jointArr[index];
    
    _sliderBlock ? _sliderBlock(_currentMinValue , _currentMaxValue) : nil;
}

- (void)valueMaxChange:(NSInteger)index
{
//    _maxLabel.text = [NSString stringWithFormat:@"%.f%@",_minNum +(_tatol * (num-btnDiameter)),_unit];
//    _currentMaxValue = _minNum +(_tatol * (num-btnDiameter));
    
    _currentMaxValue = _jointArr[index];
    
    _sliderBlock ? _sliderBlock(_currentMinValue , _currentMaxValue) : nil;
}


-(void)setMinNum:(NSString *)minNum
{
    _minNum = minNum;
//    _tatol = (_maxNum - _minNum)/(self.width - btnDiameter * 2);
//    if (_tatol < 0) {
//        _tatol = -_tatol;
//    }
    
//    _minLabel.text = [NSString stringWithFormat:@"%.f%@",minNum,_unit];
    _currentMinValue = [NSString stringWithFormat:@"%@",minNum];
}

-(void)setMaxNum:(NSString *)maxNum
{
    _maxNum = maxNum;
//    _tatol = (_maxNum - _minNum)/(self.width - btnDiameter * 2);
//    if (_tatol < 0) {
//        _tatol = -_tatol;
//    }
//    _maxLabel.text = [NSString stringWithFormat:@"%.f%@",maxNum,_unit];
    _currentMaxValue = maxNum;
}

- (void)setJointArr:(NSMutableArray *)jointArr{
//    if (!_jointArr) {
//        _jointArr =
//    }
    _jointArr = jointArr;
}
//- (void)setJointUnit:(NSString *)jointUnit{
//    _jointUnit = jointUnit;
//}

-(void)setMinTintColor:(UIColor *)minTintColor
{
    _minTintColor = minTintColor;
    _minSliderLine.backgroundColor = minTintColor;
}

-(void)setMaxTintColor:(UIColor *)maxTintColor
{
    _maxTintColor = maxTintColor;
    _maxSliderLine.backgroundColor = maxTintColor;
}

-(void)setMainTintColor:(UIColor *)mainTintColor
{
    _mainTintColor = mainTintColor;
    _mainSliderLine.backgroundColor = mainTintColor;
}

-(void)setUnit:(NSString *)unit
{
    _unit = unit;
}


@end
