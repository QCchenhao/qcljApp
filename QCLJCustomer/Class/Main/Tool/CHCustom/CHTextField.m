//
//  CHTextField.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/17.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "CHTextField.h"

//#import "NSString+RegularExpression.h"//正则表达式工具类

#import "CHMBProgressHUD.h"

//#define NUMBERS @"0123456789\n" //（这个代表可以输入数字和换行，请注意这个\n，如果不写这个，Done按键将不会触发，如果用在SearchBar中，将会不触发Search事件，因为你自己限制不让输入\n，好惨，我在项目中才发现的。）
#define timeNuber 1.5
static const NSInteger kMaxLength = 4;
@implementation CHTextField

#pragma mark - 方法-------->
+ (instancetype)addCHTextFileWithLeftImage:(NSString *)leftImageName frame:(CGRect)frame placeholder:(NSString *)placeholder placeholderLabelFont:(CGFloat )placeholderLabelFont placeholderTextColor:(UIColor *)placeholderTextColor{
    
   
    
    CHTextField * telephoneLabel = [[CHTextField alloc]init];
    telephoneLabel.frame = frame;
    
    if (placeholderLabelFont) {
        telephoneLabel.placeholderLabelFont = [UIFont systemFontOfSize:placeholderLabelFont];
    }
    if (placeholderTextColor) {
        telephoneLabel.placeholderTextColor = placeholderTextColor;
    }
    telephoneLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    if (placeholder) {
        telephoneLabel.placeholder = placeholder;
    }
    
    if (leftImageName) {
        UIImageView * leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:leftImageName]];
        telephoneLabel.leftViewMode = UITextFieldViewModeAlways;
        telephoneLabel.leftView = leftImage;

    }
    
    telephoneLabel.textAlignment = NSTextAlignmentLeft;
    
    telephoneLabel.layer.borderWidth = 1;
    telephoneLabel.layer.borderColor = QiCaiBackGroundColor.CGColor;
    telephoneLabel.layer.cornerRadius = 1;
    
    return telephoneLabel;
}


#pragma mark - --------
#pragma mark - 调整图片间隔
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;//右偏10
    return iconRect;
}

//  重写占位符的x值
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    placeholderRect.origin.x += 1;//光标偏1
    return placeholderRect;
}

//  重写文字输入时的X值
- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x += 10;
    return editingRect;
}

//  重写文字显示时的X值
- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        //整个控件的默认尺寸(和某宝上面的按钮同样大小)
        if(CGRectIsEmpty(frame))
        {
            self.frame = CGRectMake(0, 0, 50, 30);
        };
        [self setupUI];
    }
    return self;
}
- (void)setCHTextFieldType:(CHTextFieldType)cHTextFieldType{
    _cHTextFieldType = cHTextFieldType;
    //处理键盘按钮类型
    if (cHTextFieldType == CHTextFieldTypeUnlimitedCH ) { /**无限制**/
        self.returnKeyType = UIReturnKeyDefault;
        self.keyboardType = UIKeyboardTypeDefault;
        
    }else if (cHTextFieldType == CHTextFieldTypeName) { /**姓名，限制输入为汉字**/
        self.returnKeyType = UIReturnKeyDefault;
        self.keyboardType = UIKeyboardTypeNamePhonePad;//没有符号的键盘
        self.placeholder = @"请输入联系人";
    }else if (cHTextFieldType == CHTextFieldTypeTelephone) { /**电话，手机**/
        self.returnKeyType = UIReturnKeyDone;
        self.keyboardType = UIKeyboardTypePhonePad;//没有小数点的数字键盘
//        self.placeholder = @"请输入手机号";
        self.placeholder = @"请输入11位手机号";
    }else if (cHTextFieldType == CHTextFieldTypeAmountOfMoney) { /**金额加小数点**/
        self.returnKeyType = UIReturnKeyDefault;
        self.keyboardType = UIKeyboardTypeDecimalPad;//数字加小数点
        self.placeholder = @"请输入金额";
    }else if (cHTextFieldType == CHTextFieldTypeUserIdCard) { /**银行卡 **/
        self.returnKeyType = UIReturnKeyDefault;
        self.keyboardType = UIKeyboardTypePhonePad;//没有小数点的数字键盘
        self.placeholder = @"请输入银行卡号";
    }else if (cHTextFieldType == CHTextFieldTypePassword) { /**密码 **/
        self.returnKeyType = UIReturnKeyDefault;
        self.keyboardType = UIKeyboardTypePhonePad;//没有小数点的数字键盘
        self.placeholder = @"请输入密码";
        //每输入一个字符就变成点 用语密码输入
        self.secureTextEntry = YES;
    }
}

#pragma mark - UI布局
- (void)setupUI
{
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.cHTextFieldType = CHTextFieldTypeUnlimitedCH;
    self.backgroundColor = [UIColor whiteColor];
//    self.CHMaximumSize = CGSizeMake(MYScreenW * 0.7, MYScreenH * 0.1);
//    [self setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [self setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];

}
#pragma mark - PlaceholderLabel的字体大小、颜色、及字体太小偏上问题
- (void)setPlaceholderLabelFont:(UIFont *)placeholderLabelFont{
    
    _placeholderLabelFont = placeholderLabelFont;
    [self setValue:placeholderLabelFont forKeyPath:@"_placeholderLabel.font"];
}
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor{
    
    _placeholderTextColor = placeholderTextColor;
    [self setValue:placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];
}
// 重写这个方法是为了使Placeholder居中，如果不写会出现类似于下图中的效果，文字稍微偏上了一些
- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:CGRectMake(0, self.height * 0.5 - 1, 0, 0)];
}
#pragma mark ----
//设置代理
- (void)setCHDelegate:(id)CHDelegate{
    self.delegate = self;
}
#pragma mark 限制输入文字长度
//限制输入文字长度
- (void)textFieldDidChange:(UITextField *)textField
{
    _cHTextFieldDidChangeDelegate ? [_cHTextFieldDidChangeDelegate CHTextFieldDidChange:textField] : nil;
    if (_cHTextFieldType == CHTextFieldTypeUnlimitedCH) {/**无限制**/
        
    }else if (_cHTextFieldType == CHTextFieldTypeName) {/**姓名，限制输入为汉字英文**/
        NSString *toBeString = textField.text;
        
        NSString *lang = [textField.textInputMode primaryLanguage];

        
        if([lang isEqualToString:@"zh-Hans"]){ //简体中文输入，包括简体拼音，健体五笔，简体手写
            
            UITextRange *selectedRange = [textField markedTextRange];
            
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            
            
            if (!position){//非高亮
                
                if (toBeString.length > kMaxLength) {
                    
                    textField.text = [toBeString substringToIndex:kMaxLength];
                    
                }
                
            }
            
        }else{//中文输入法以外
            
            if (toBeString.length > kMaxLength) {
                
                
            }
            
        }
    }else if (_cHTextFieldType == CHTextFieldTypeTelephone) {/**电话，手机**/
        
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
            //错误弹出提示
//            [CHMBProgressHUD showMessage:@"手机号只有十一位" afterDelayTime:timeNuber];
//            [CHMBProgressHUD showPrompt:@"手机号只有十一位"];
            self.isChShakeAnimation ? [self shakeAnimation] : nil;
            
        }else if (textField.text.length == 11) {
            if ([NSString checkTelNumber:textField.text]) {//手机格式判断
                [textField resignFirstResponder];//正确收回键盘
            }else{
                //错误弹出提示
//                [CHMBProgressHUD showMessage:@"手机号格式不正确" afterDelayTime:timeNuber];
//                [CHMBProgressHUD showPrompt:@"手机号格式不正确"];
                self.isChShakeAnimation ? [self shakeAnimation] : nil;
            }
        }
    }else if (_cHTextFieldType == CHTextFieldTypeAmountOfMoney) {/**金额加小数点**/
        
    }else if (_cHTextFieldType == CHTextFieldTypeUserIdCard) {/**银行卡 **/
        
    }else{
        
    }
    
      

    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    return YES;
}// return NO to disallow editing.
/*
 已经开始编辑的时候 会触发这个方法textFieldDidEndEditing
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    
    //要想在用户结束编辑时阻止文本字段消失，可以返回NO
    
    //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
    
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
/*
 结束编辑的时候调用
 */
#pragma mark 结束编辑的时候调用判断格式
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //收回键盘
    [textField resignFirstResponder];
    
    BOOL isMatch = false;
    if (_cHTextFieldType == CHTextFieldTypeUnlimitedCH) {
        
    }else if (_cHTextFieldType == CHTextFieldTypeName) {
        
        //判断输入用户姓名格式是否正确
        isMatch = [NSString checkUserName:textField.text];
        if (isMatch) {
            NSLog(@"匹配");
        }else{
            NSLog(@"用户姓名不匹配");
//            [CHMBProgressHUD showMessage:@"用户姓名格式不正确" afterDelayTime:timeNuber];
//            [CHMBProgressHUD showPrompt:@"手机号格式不正确"];
            self.isChShakeAnimation ? [self shakeAnimation] : nil;
        }
        
    }else if (_cHTextFieldType == CHTextFieldTypeTelephone) {/**电话，手机**/
        
        //判断输入手机号格式是否正确
        isMatch = [NSString checkTelNumber:textField.text];
        
        if (isMatch) {
            NSLog(@"匹配");
        }else{
            NSLog(@"手机号不匹配");
//            [CHMBProgressHUD showMessage:@"手机号格式不正确"  afterDelayTime:timeNuber];
            self.isChShakeAnimation ? [self shakeAnimation] : nil;
        }
    }else if (_cHTextFieldType == CHTextFieldTypeAmountOfMoney) {
        
        //判断输入金额格式是否正确
        isMatch = [NSString checkMoney:textField.text];
        
        if (isMatch) {
            NSLog(@"匹配");
            
        }else{
            NSLog(@"金额不匹配");
//            [CHMBProgressHUD showMessage:@"金额格式不正确"  afterDelayTime:timeNuber];
            self.isChShakeAnimation ? [self shakeAnimation] : nil;
        }
        textField.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
        _payMoneyBlock ? _payMoneyBlock(textField.text) : nil;
       
    }else if (_cHTextFieldType == CHTextFieldTypeUserIdCard) {
        
        //除去字符串中的空格
        NSString *bankNumber = @"";
        bankNumber = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //判断输入银行卡格式是否正确
        isMatch = [NSString checkBankCardNumber:bankNumber];
        
        if (isMatch) {
            NSLog(@"匹配");
            //匹配银行
            NSString * bank;
            
            NSString *bankNumber = @"";
            bankNumber = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
            bank = [CHTextField getBankName:bankNumber];

            //getBankName方法没有结果调用 backbankenameWithBanknumber方法
            if ([bank isEqualToString:@""]) {
                bank = [CHTextField backbankenameWithBanknumber:bankNumber];
            }
            //判断bank 是否含有 "·"
            NSArray *array ;
            if([bank rangeOfString:@"·"].location !=NSNotFound) //_roaldSearchText
            {
                array = [bank componentsSeparatedByString:@"·"]; //从字符A中分隔成2个元素的数组
                NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
                
                //有的话截取 "·"以前的字符串
                NSRange range = [bank rangeOfString:@"·"];
                NSString *str = [bank substringToIndex:range.location];
                bank = @"";
                bank = str;
            }
                _backBankenameBlock ? _backBankenameBlock(array[0],array[1]) : nil;

//            }
            
        }else{
            NSLog(@"银行卡不匹配");

//            [CHMBProgressHUD showMessage:@"银行卡格式不正确" afterDelayTime:timeNuber];
            self.isChShakeAnimation ? [self shakeAnimation] : nil;
        }

        
    }else{
        
    }

     _formatBlock ? _formatBlock(isMatch) : nil;
        
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

/*
 可以得到用户输入的字符
 */
#pragma mark 限制输入字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    
  
    
    if (_cHTextFieldType == CHTextFieldTypeUnlimitedCH) {
        
    }else if (_cHTextFieldType == CHTextFieldTypeName) {
        
//        if (textField.text.length > 0) {
//            BOOL basicTest = [NSString checkUserName:textField.text];
//            if (!basicTest) {
//                return NO;
//            }
//        }
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"➋➌➍➎➏➐➑➒\n"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(basicTest || [NSString checkUserName:string])
        {
            return YES;
        }else{
            return NO;
        }
        

        
        
        
    }else if (_cHTextFieldType == CHTextFieldTypeTelephone) {/**电话，手机**/
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            return NO;
        }

        
    }else if (_cHTextFieldType == CHTextFieldTypeAmountOfMoney) {
        
        cs = [[NSCharacterSet characterSetWithCharactersInString: @".0123456789\n"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger dotNum = 0;
        NSInteger flag=0;
        const NSInteger limited = 2;
        for (float i = futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                dotNum ++;
                if (flag > limited) {
                    return NO;
                }
                if(dotNum>1){
                    return NO;
                }
            }
            flag++;
        }
        //判断小数点出现一次
        if(!basicTest)
        {
            return NO;
        }else {//判断首位不是小数点
            if (textField.text.length == 0 &&[string isEqualToString:@"."] ) {
                return NO;
            }
        }
        
    }else if (_cHTextFieldType == CHTextFieldTypeUserIdCard) {
        
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 21) {
            return NO;
        }
        
        [textField setText:newString];
        
        return NO;
        
    }else{
        
    }

    
    
    //其他的类型不需要检测，直接写入
    return YES;

    
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    
    //这对于想要加入撤销选项的应用程序特别有用
    
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    
    //要防止文字被改变可以返回NO
    
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    
}// return NO to not change text

/*
 当用户全部清空的时候的时候 会调用
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    
    //可以设置在特定条件下才允许清除内容

    return YES;
}// called when clear button pressed. return NO to ignore (no notifications)
/*
 当用户按下return键或者按回车键，keyboard消失
 */
#pragma mark - 用户按下return键设置回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    //收回键盘
//    [textField resignFirstResponder];
    
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起[textField resignFirstResponder];
    
    //查一下resign这个单词的意思就明白这个方法了

    
    return YES;
}// called when 'return' key pressed. return NO to ignore.
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

#pragma 根据输入银行卡号判断银行
+ (NSString *)backbankenameWithBanknumber:(NSString *)banknumber{
    NSString *bankNumber = [banknumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *dic;
    NSString *bank = @"";
    NSString *bank1 = @"";
    NSString *bank2 = @"";
    NSString *bankname;
    bank1 = [bankNumber substringToIndex:5];
    bank = [bankNumber substringToIndex:6];
    bank2 = [bankNumber substringToIndex:8];
    if (!dic) {
        dic = @{@"402791":@"工商银行",@"427028":@"工商银行",@"427038":@"工商银行",@"548259":@"工商银行",@"620200":@"工商银行",@"620302":@"工商银行",@"620402":@"工商银行",@"620403":@"工商银行",@"620404":@"工商银行",@"620405":@"工商银行",@"620406":@"工商银行",@"620407":@"工商银行",@"620408":@"工商银行",@"620409":@"工商银行",@"620410":@"工商银行",@"620411":@"工商银行",@"620412":@"工商银行",@"620502":@"工商银行",@"620503":@"工商银行",@"620512":@"工商银行",@"620602":@"工商银行",@"620604":@"工商银行",@"620607":@"工商银行",@"620609":@"工商银行",@"620611":@"工商银行",@"620612":@"工商银行",@"620704":@"工商银行",@"620706":@"工商银行",@"620707":@"工商银行",@"620708":@"工商银行",@"620709":@"工商银行",@"620710":@"工商银行",@"620711":@"工商银行",@"620712":@"工商银行",@"620713":@"工商银行",@"620714":@"工商银行",@"620802":@"工商银行",@"620904":@"工商银行",@"620905":@"工商银行",@"621101":@"工商银行",@"621102":@"工商银行",@"621103":@"工商银行",@"621105":@"工商银行",@"621106":@"工商银行",@"621107":@"工商银行",@"621202":@"工商银行",@"621203":@"工商银行",@"621204":@"工商银行",@"621205":@"工商银行",@"621206":@"工商银行",@"621207":@"工商银行",@"621208":@"工商银行",@"621209":@"工商银行",@"621210":@"工商银行",@"621211":@"工商银行",@"621302":@"工商银行",@"621303":@"工商银行",@"621304":@"工商银行",@"621305":@"工商银行",@"621306":@"工商银行",@"621307":@"工商银行",@"621308":@"工商银行",@"621309":@"工商银行",@"621311":@"工商银行",@"621313":@"工商银行",@"621315":@"工商银行",@"621317":@"工商银行",@"621402":@"工商银行",@"621404":@"工商银行",@"621405":@"工商银行",@"621406":@"工商银行",@"621407":@"工商银行",@"621408":@"工商银行",@"621409":@"工商银行",@"621410":@"工商银行",@"621502":@"工商银行",@"621511":@"工商银行",@"621602":@"工商银行",@"621603":@"工商银行",@"621604":@"工商银行",@"621605":@"工商银行",@"621606":@"工商银行",@"621607":@"工商银行",@"621608":@"工商银行",@"621609":@"工商银行",@"621610":@"工商银行",@"621611":@"工商银行",@"621612":@"工商银行",@"621613":@"工商银行",@"621614":@"工商银行",@"621615":@"工商银行",@"621616":@"工商银行",@"621617":@"工商银行",@"621804":@"工商银行",@"621807":@"工商银行",@"621813":@"工商银行",@"621814":@"工商银行",@"621817":@"工商银行",@"621901":@"工商银行",@"621903":@"工商银行",@"621904":@"工商银行",@"621905":@"工商银行",@"621906":@"工商银行",@"621907":@"工商银行",@"621908":@"工商银行",@"621909":@"工商银行",@"621910":@"工商银行",@"621911":@"工商银行",@"621912":@"工商银行",@"621913":@"工商银行",@"621914":@"工商银行",@"621915":@"工商银行",@"622002":@"工商银行",@"622003":@"工商银行",@"622004":@"工商银行",@"622005":@"工商银行",@"622006":@"工商银行",@"622007":@"工商银行",@"622008":@"工商银行",@"622009":@"工商银行",@"622010":@"工商银行",@"622011":@"工商银行",@"622012":@"工商银行",@"622013":@"工商银行",@"622014":@"工商银行",@"622015":@"工商银行",@"622016":@"工商银行",@"622017":@"工商银行",@"622018":@"工商银行",@"622019":@"工商银行",@"622020":@"工商银行",@"622102":@"工商银行",@"622103":@"工商银行",@"622104":@"工商银行",@"622105":@"工商银行",@"622110":@"工商银行",@"622111":@"工商银行",@"622114":@"工商银行",@"622302":@"工商银行",@"622303":@"工商银行",@"622304":@"工商银行",@"622305":@"工商银行",@"622306":@"工商银行",@"622307":@"工商银行",@"622308":@"工商银行",@"622309":@"工商银行",@"622313":@"工商银行",@"622314":@"工商银行",@"622315":@"工商银行",@"622317":@"工商银行",@"622402":@"工商银行",@"622403":@"工商银行",@"622404":@"工商银行",@"622502":@"工商银行",@"622504":@"工商银行",@"622505":@"工商银行",@"622509":@"工商银行",@"622510":@"工商银行",@"622513":@"工商银行",@"622517":@"工商银行",@"622604":@"工商银行",@"622605":@"工商银行",@"622606":@"工商银行",@"622703":@"工商银行",@"622706":@"工商银行",@"622715":@"工商银行",@"622806":@"工商银行",@"622902":@"工商银行",@"622903":@"工商银行",@"622904":@"工商银行",@"623002":@"工商银行",@"623006":@"工商银行",@"623008":@"工商银行",@"623011":@"工商银行",@"623012":@"工商银行",@"623014":@"工商银行",@"623015":@"工商银行",@"623100":@"工商银行",@"623202":@"工商银行",@"623301":@"工商银行",@"623400":@"工商银行",@"623500":@"工商银行",@"623602":@"工商银行",@"623700":@"工商银行",@"623803":@"工商银行",@"623901":@"工商银行",@"624000":@"工商银行",@"624100":@"工商银行",@"624200":@"工商银行",@"624301":@"工商银行",@"624402":@"工商银行",@"620058":@"工商银行",@"620516":@"工商银行",@"621225":@"工商银行",@"621226":@"工商银行",@"621227":@"工商银行",@"621281":@"工商银行",@"621288":@"工商银行",@"621721":@"工商银行",@"621722":@"工商银行",@"621723":@"工商银行",@"622200":@"工商银行",@"622202":@"工商银行",@"622203":@"工商银行",@"622208":@"工商银行",@"900000":@"工商银行",@"900010":@"工商银行",@"620086":@"工商银行",@"621558":@"工商银行",@"621559":@"工商银行",@"621618":@"工商银行",@"621670":@"工商银行",@"623062":@"工商银行",@"421349":@"建设银行",@"434061":@"建设银行",@"434062":@"建设银行",@"524094":@"建设银行",@"526410":@"建设银行",@"552245":@"建设银行",@"621080":@"建设银行",@"621082":@"建设银行",@"621466":@"建设银行",@"621488":@"建设银行",@"621499":@"建设银行",@"622966":@"建设银行",@"622988":@"建设银行",@"436742":@"建设银行",@"589970":@"建设银行",@"620060":@"建设银行",@"621081":@"建设银行",@"621284":@"建设银行",@"621467":@"建设银行",@"621598":@"建设银行",@"621621":@"建设银行",@"621700":@"建设银行",@"622280":@"建设银行",@"622700":@"建设银行",@"436742":@"建设银行",@"622280":@"建设银行",@"623211":@"建设银行",@"620059":@"农业银行",@"621282":@"农业银行",@"621336":@"农业银行",@"621619":@"农业银行",@"621671":@"农业银行",@"622821":@"农业银行",@"622822":@"农业银行",@"622823":@"农业银行",@"622824":@"农业银行",@"622825":@"农业银行",@"622826":@"农业银行",@"622827":@"农业银行",@"622828":@"农业银行",@"622840":@"农业银行",@"622841":@"农业银行",@"622843":@"农业银行",@"622844":@"农业银行",@"622845":@"农业银行",@"622846":@"农业银行",@"622847":@"农业银行",@"622848":@"农业银行",@"622849":@"农业银行",@"623018":@"农业银行",@"623206":@"农业银行",@"621626":@"平安银行",@"623058":@"平安银行",@"602907":@"平安银行",@"622298":@"平安银行",@"622986":@"平安银行",@"622989":@"平安银行",@"627066":@"平安银行",@"627067":@"平安银行",@"627068":@"平安银行",@"627069":@"平安银行",@"412962":@"发展银行",@"412963":@"发展银行",@"415752":@"发展银行",@"415753":@"发展银行",@"622535":@"发展银行",@"622536":@"发展银行",@"622538":@"发展银行",@"622539":@"发展银行",@"622983":@"发展银行",@"998800":@"发展银行",@"690755":@"招商银行",@"402658":@"招商银行",@"410062":@"招商银行",@"468203":@"招商银行",@"512425":@"招商银行",@"524011":@"招商银行",@"621286":@"招商银行",@"622580":@"招商银行",@"622588":@"招商银行",@"622598":@"招商银行",@"622609":@"招商银行",@"690755":@"招商银行",@"433670":@"中信银行",@"433671":@"中信银行",@"433680":@"中信银行",@"442729":@"中信银行",@"442730":@"中信银行",@"620082":@"中信银行",@"621767":@"中信银行",@"621768":@"中信银行",@"621770":@"中信银行",@"621771":@"中信银行",@"621772":@"中信银行",@"621773":@"中信银行",@"622690":@"中信银行",@"622691":@"中信银行",@"622692":@"中信银行",@"622696":@"中信银行",@"622698":@"中信银行",@"622998":@"中信银行",@"622999":@"中信银行",@"968807":@"中信银行",@"968808":@"中信银行",@"968809":@"中信银行",@"620085":@"广大银行",@"620518":@"广大银行",@"621489":@"广大银行",@"621492":@"广大银行",@"622660":@"广大银行",@"622661":@"广大银行",@"622662":@"广大银行",@"622663":@"广大银行",@"622664":@"广大银行",@"622665":@"广大银行",@"622666":@"广大银行",@"622667":@"广大银行",@"622668":@"广大银行",@"622669":@"广大银行",@"622670":@"广大银行",@"622671":@"广大银行",@"622672":@"广大银行",@"622673":@"广大银行",@"622674":@"广大银行",@"620535":@"广大银行",@"622516":@"浦发银行",@"622517":@"浦发银行",@"622518":@"浦发银行",@"622521":@"浦发银行",@"622522":@"浦发银行",@"622523":@"浦发银行",@"984301":@"浦发银行",@"984303":@"浦发银行",@"621352":@"浦发银行",@"621793":@"浦发银行",@"621795":@"浦发银行",@"621796":@"浦发银行",@"621351":@"浦发银行",@"621390":@"浦发银行",@"621792":@"浦发银行",@"621791":@"浦发银行",@"84301":@"浦发银行",@"84336":@"浦发银行",@"84373":@"浦发银行",@"84385":@"浦发银行",@"84390":@"浦发银行",@"87000":@"浦发银行",@"87010":@"浦发银行",@"87030":@"浦发银行",@"87040":@"浦发银行",@"84380":@"浦发银行",@"84361":@"浦发银行",@"87050":@"浦发银行",@"84342":@"浦发银行",@"415599":@"民生银行",@"421393":@"民生银行",@"421865":@"民生银行",@"427570":@"民生银行",@"427571":@"民生银行",@"472067":@"民生银行",@"472068":@"民生银行",@"622615":@"民生银行",@"622616":@"民生银行",@"622617":@"民生银行",@"622618":@"民生银行",@"622619":@"民生银行",@"622620":@"民生银行",@"622622":@"民生银行",@"601428":@"交通银行",@"405512":@"交通银行",@"622258":@"交通银行",@"622259":@"交通银行",@"622260":@"交通银行",@"622261":@"交通银行",@"622262":@"交通银行",@"621056":@"交通银行",@"621335":@"交通银行",@"621096":@"邮政储蓄银行",@"621098":@"邮政储蓄银行",@"622150":@"邮政储蓄银行",@"622151":@"邮政储蓄银行",@"622181":@"邮政储蓄银行",@"622188":@"邮政储蓄银行",@"955100":@"邮政储蓄银行",@"621095":@"邮政储蓄银行",@"620062":@"邮政储蓄银行",@"621285":@"邮政储蓄银行",@"621798":@"邮政储蓄银行",@"621799":@"邮政储蓄银行",@"621797":@"邮政储蓄银行",@"620529":@"邮政储蓄银行",@"622199":@"邮政储蓄银行",@"62215049":@"邮政储蓄银行",@"62215050":@"邮政储蓄银行",@"62215051":@"邮政储蓄银行",@"62218850":@"邮政储蓄银行",@"62218851":@"邮政储蓄银行",@"62218849":@"邮政储蓄银行",@"621622":@"邮政储蓄银行",@"621599":@"邮政储蓄银行",@"623219":@"邮政储蓄银行",@"621674":@"邮政储蓄银行",@"623218":@"邮政储蓄银行",@"621660":@"中国银行",@"621661":@"中国银行",@"621662":@"中国银行",@"621663":@"中国银行",@"621665":@"中国银行",@"621667":@"中国银行",@"621668":@"中国银行",@"621669":@"中国银行",@"621666":@"中国银行",@"456351":@"中国银行",@"601382":@"中国银行",@"621256":@"中国银行",@"621212":@"中国银行",@"621283":@"中国银行",@"620061":@"中国银行",@"621725":@"中国银行",@"621330":@"中国银行",@"621331":@"中国银行",@"621332":@"中国银行",@"621333":@"中国银行",@"621297":@"中国银行",@"621568":@"中国银行",@"621569":@"中国银行",@"621672":@"中国银行",@"623208":@"中国银行",@"621620":@"中国银行",@"621756":@"中国银行",@"621757":@"中国银行",@"621758":@"中国银行",@"621759":@"中国银行",@"621785":@"中国银行",@"621786":@"中国银行",@"621787":@"中国银行",@"621788":@"中国银行",@"621789":@"中国银行",@"621790":@"中国银行"};
    }
    
    for (NSString *s in [dic allKeys]) {
        if ([bank1 isEqualToString:s]||[bank isEqualToString:s]||[bank2 isEqualToString:s]) {
            //            bankname = [dic objectForKey:s];
            bankname = dic[s];
            NSLog(@"bankname%@",bankname);
            break ;
        }
    }
    
    return bankname;
}
#pragma 根据输入银行卡号判断银行22222
+ (NSString *)getBankName:(NSString*) cardId{
    
    //除去字符串中的空格
    NSString *bankNumber = @"";
    bankNumber = [cardId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //"发卡行.卡种名称",
   
    
    
    NSArray* bankName = @[@"邮储银行·绿卡通" , @"邮储银行·绿卡银联标准卡" , @"邮储银行·绿卡银联标准卡" , @"邮储银行·绿卡专用卡" , @"邮储银行·绿卡银联标准卡",@"邮储银行·绿卡(银联卡)" , @"邮储银行·绿卡VIP卡" , @"邮储银行·银联标准卡" , @"邮储银行·中职学生资助卡" , @"邮政储蓄银行·IC绿卡通VIP卡",@"邮政储蓄银行·IC绿卡通" , @"邮政储蓄银行·IC联名卡" , @"邮政储蓄银行·IC预付费卡" , @"邮储银行·绿卡银联标准卡" , @"邮储银行·绿卡通",@"邮政储蓄银行·武警军人保障卡" , @"邮政储蓄银行·中国旅游卡（金卡）" , @"邮政储蓄银行·普通高中学生资助卡" , @"邮政储蓄银行·中国旅游卡（普卡）",@"邮政储蓄银行·福农卡" , @"工商银行·牡丹运通卡金卡" , @"工商银行·牡丹运通卡金卡" , @"工商银行·牡丹运通卡金卡" , @"工商银行·牡丹VISA卡(单位卡)",@"工商银行·牡丹VISA信用卡" , @"工商银行·牡丹VISA卡(单位卡)" , @"工商银行·牡丹VISA信用卡" , @"工商银行·牡丹VISA信用卡" , @"工商银行·牡丹VISA信用卡",@"工商银行·牡丹VISA信用卡" , @"工商银行·牡丹运通卡普通卡" , @"工商银行·牡丹VISA信用卡" , @"工商银行·牡丹VISA白金卡" , @"工商银行·牡丹贷记卡(银联卡)",@"工商银行·牡丹贷记卡(银联卡)" , @"工商银行·牡丹贷记卡(银联卡)" , @"工商银行·牡丹贷记卡(银联卡)" , @"工商银行·牡丹欧元卡" , @"工商银行·牡丹欧元卡",@"工商银行·牡丹欧元卡" , @"工商银行·牡丹万事达国际借记卡" , @"工商银行·牡丹VISA信用卡" , @"工商银行·海航信用卡" , @"工商银行·牡丹VISA信用卡", @"工商银行·牡丹万事达信用卡" , @"工商银行·牡丹万事达信用卡" , @"工商银行·牡丹万事达信用卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹万事达白金卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·海航信用卡个人普卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡", @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡", @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡", @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡",@"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·E时代卡" , @"工商银行·E时代卡" , @"工商银行·理财金卡" , @"工商银行·准贷记卡(个普)" , @"工商银行·准贷记卡(个普)" , @"工商银行·准贷记卡(个普)" , @"工商银行·准贷记卡(个普)" , @"工商银行·准贷记卡(个普)" , @"工商银行·牡丹灵通卡" , @"工商银行·准贷记卡(商普)" , @"工商银行·牡丹卡(商务卡)" , @"工商银行·准贷记卡(商金)" , @"工商银行·牡丹卡(商务卡)" , @"工商银行·贷记卡(个普)" , @"工商银行·牡丹卡(个人卡)" , @"工商银行·牡丹卡(个人卡)" , @"工商银行·牡丹卡(个人卡)" , @"工商银行·牡丹卡(个人卡)" , @"工商银行·贷记卡(个金)" , @"工商银行·牡丹交通卡" , @"工商银行·准贷记卡(个金)" , @"工商银行·牡丹交通卡" , @"工商银行·贷记卡(商普)" , @"工商银行·贷记卡(商金)" , @"工商银行·牡丹卡(商务卡)" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹交通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹灵通卡" , @"工商银行·牡丹贷记卡" , @"工商银行·牡丹贷记卡" , @"工商银行·牡丹贷记卡" , @"工商银行·牡丹贷记卡" , @"工商银行·牡丹灵通卡" , @"工商银行·中央预算单位公务卡" , @"工商银行·牡丹灵通卡" , @"工商银行·财政预算单位公务卡" , @"工商银行·牡丹卡白金卡" , @"工商银行·牡丹卡普卡" , @"工商银行·国航知音牡丹信用卡" , @"工商银行·国航知音牡丹信用卡" , @"工商银行·国航知音牡丹信用卡" , @"工商银行·国航知音牡丹信用卡" , @"工商银行·银联标准卡" , @"工商银行·中职学生资助卡" , @"工商银行·专用信用消费卡" , @"工商银行·牡丹社会保障卡" , @"中国工商银行·牡丹东航联名卡" , @"中国工商银行·牡丹东航联名卡" , @"中国工商银行·牡丹运通白金卡" , @"中国工商银行·福农灵通卡" , @"中国工商银行·福农灵通卡" , @"工商银行·灵通卡" , @"工商银行·灵通卡" , @"中国工商银行·中国旅行卡" , @"工商银行·牡丹卡普卡" , @"工商银行·国际借记卡" , @"工商银行·国际借记卡" , @"工商银行·国际借记卡" , @"工商银行·国际借记卡" , @"中国工商银行·牡丹JCB信用卡" , @"中国工商银行·牡丹JCB信用卡" , @"中国工商银行·牡丹JCB信用卡" , @"中国工商银行·牡丹JCB信用卡" , @"中国工商银行·牡丹多币种卡" , @"中国工商银行·武警军人保障卡" , @"工商银行·预付芯片卡" , @"工商银行·理财金账户金卡" , @"工商银行·灵通卡" , @"工商银行·牡丹宁波市民卡" , @"中国工商银行·中国旅游卡" , @"中国工商银行·中国旅游卡" , @"中国工商银行·中国旅游卡" , @"中国工商银行·借记卡" , @"中国工商银行·借贷合一卡" , @"中国工商银行·普通高中学生资助卡" , @"中国工商银行·牡丹多币种卡" , @"中国工商银行·牡丹多币种卡" , @"中国工商银行·牡丹百夫长信用卡" , @"中国工商银行·牡丹百夫长信用卡" , @"工商银行·工银财富卡" , @"中国工商银行·中小商户采购卡" , @"中国工商银行·中小商户采购卡" , @"中国工商银行·环球旅行金卡" , @"中国工商银行·环球旅行白金卡" , @"中国工商银行·牡丹工银大来卡" , @"中国工商银行·牡丹工银大莱卡" , @"中国工商银行·IC金卡" , @"中国工商银行·IC白金卡" , @"中国工商银行·工行IC卡（红卡）" , @"中国工商银行布鲁塞尔分行·借记卡" , @"中国工商银行布鲁塞尔分行·预付卡" , @"中国工商银行布鲁塞尔分行·预付卡" , @"中国工商银行金边分行·借记卡" , @"中国工商银行金边分行·信用卡" , @"中国工商银行金边分行·借记卡" , @"中国工商银行金边分行·信用卡" , @"中国工商银行加拿大分行·借记卡" , @"中国工商银行加拿大分行·借记卡" , @"中国工商银行加拿大分行·预付卡" , @"中国工商银行巴黎分行·借记卡" , @"中国工商银行巴黎分行·借记卡" , @"中国工商银行巴黎分行·贷记卡" , @"中国工商银行法兰克福分行·贷记卡" , @"中国工商银行法兰克福分行·借记卡" , @"中国工商银行法兰克福分行·贷记卡" , @"中国工商银行法兰克福分行·贷记卡" , @"中国工商银行法兰克福分行·借记卡" , @"中国工商银行法兰克福分行·预付卡" , @"中国工商银行法兰克福分行·预付卡" , @"中国工商银行印尼分行·借记卡" , @"中国工商银行印尼分行·信用卡" , @"中国工商银行米兰分行·借记卡" , @"中国工商银行米兰分行·预付卡" , @"中国工商银行米兰分行·预付卡" , @"中国工商银行阿拉木图子行·借记卡" , @"中国工商银行阿拉木图子行·贷记卡" , @"中国工商银行阿拉木图子行·借记卡" , @"中国工商银行阿拉木图子行·预付卡" , @"中国工商银行万象分行·借记卡" , @"中国工商银行万象分行·贷记卡" , @"中国工商银行卢森堡分行·借记卡" , @"中国工商银行卢森堡分行·贷记卡" , @"中国工商银行澳门分行·E时代卡" , @"中国工商银行澳门分行·E时代卡" , @"中国工商银行澳门分行·E时代卡" , @"中国工商银行澳门分行·理财金账户" , @"中国工商银行澳门分行·理财金账户" , @"中国工商银行澳门分行·理财金账户" , @"中国工商银行澳门分行·预付卡" , @"中国工商银行澳门分行·预付卡" , @"中国工商银行澳门分行·工银闪付预付卡" , @"中国工商银行澳门分行·工银银联公司卡" , @"中国工商银行澳门分行·Diamond" , @"中国工商银行阿姆斯特丹·借记卡" , @"中国工商银行卡拉奇分行·借记卡" , @"中国工商银行卡拉奇分行·贷记卡" , @"中国工商银行新加坡分行·贷记卡" , @"中国工商银行新加坡分行·贷记卡" , @"中国工商银行新加坡分行·借记卡" , @"中国工商银行新加坡分行·预付卡" , @"中国工商银行新加坡分行·预付卡" , @"中国工商银行新加坡分行·借记卡" , @"中国工商银行新加坡分行·借记卡" , @"中国工商银行马德里分行·借记卡" , @"中国工商银行马德里分行·借记卡" , @"中国工商银行马德里分行·预付卡" , @"中国工商银行马德里分行·预付卡" , @"中国工商银行伦敦子行·借记卡" , @"中国工商银行伦敦子行·工银伦敦借记卡" , @"中国工商银行伦敦子行·借记卡" , @"农业银行·金穗贷记卡" , @"农业银行·中国旅游卡" , @"农业银行·普通高中学生资助卡" , @"农业银行·银联标准卡" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·VISA白金卡" , @"农业银行·万事达白金卡" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡(银联卡)" , @"农业银行·金穗贷记卡" , @"农业银行·中职学生资助卡" , @"农业银行·专用惠农卡" , @"农业银行·武警军人保障卡" , @"农业银行·金穗校园卡(银联卡)" , @"农业银行·金穗星座卡(银联卡)" , @"农业银行·金穗社保卡(银联卡)" , @"农业银行·金穗旅游卡(银联卡)" , @"农业银行·金穗青年卡(银联卡)" , @"农业银行·复合介质金穗通宝卡" , @"农业银行·金穗海通卡" , @"农业银行·退役金卡" , @"农业银行·金穗贷记卡" , @"农业银行·金穗贷记卡" , @"农业银行·金穗通宝卡(银联卡)" , @"农业银行·金穗惠农卡" , @"农业银行·金穗通宝银卡" , @"农业银行·金穗通宝卡(银联卡)" , @"农业银行·金穗通宝卡(银联卡)" , @"农业银行·金穗通宝卡" , @"农业银行·金穗通宝卡(银联卡)" , @"农业银行·金穗通宝卡(银联卡)" , @"农业银行·金穗通宝钻石卡" , @"农业银行·掌尚钱包" , @"农业银行·银联IC卡金卡" , @"农业银行·银联预算单位公务卡金卡" , @"农业银行·银联IC卡白金卡" , @"农业银行·金穗公务卡" , @"中国农业银行贷记卡·IC普卡" , @"中国农业银行贷记卡·IC金卡" , @"中国农业银行贷记卡·澳元卡" , @"中国农业银行贷记卡·欧元卡" , @"中国农业银行贷记卡·金穗通商卡" , @"中国农业银行贷记卡·金穗通商卡" , @"中国农业银行贷记卡·银联白金卡" , @"中国农业银行贷记卡·中国旅游卡" , @"中国农业银行贷记卡·银联IC公务卡" , @"宁波市农业银行·市民卡B卡" , @"中国银行·联名卡" , @"中国银行·个人普卡" , @"中国银行·个人金卡" , @"中国银行·员工普卡" , @"中国银行·员工金卡" , @"中国银行·理财普卡" , @"中国银行·理财金卡" , @"中国银行·理财银卡" , @"中国银行·理财白金卡" , @"中国银行·中行金融IC卡白金卡" , @"中国银行·中行金融IC卡普卡" , @"中国银行·中行金融IC卡金卡" , @"中国银行·中银JCB卡金卡" , @"中国银行·中银JCB卡普卡" , @"中国银行·员工普卡" , @"中国银行·个人普卡" , @"中国银行·中银威士信用卡员" , @"中国银行·中银威士信用卡员" , @"中国银行·个人白金卡" , @"中国银行·中银威士信用卡" , @"中国银行·长城公务卡" , @"中国银行·长城电子借记卡" , @"中国银行·中银万事达信用卡" , @"中国银行·中银万事达信用卡" , @"中国银行·中银万事达信用卡" , @"中国银行·中银万事达信用卡" , @"中国银行·中银万事达信用卡" , @"中国银行·中银威士信用卡员" , @"中国银行·长城万事达信用卡" , @"中国银行·长城万事达信用卡" , @"中国银行·长城万事达信用卡" , @"中国银行·长城万事达信用卡" , @"中国银行·长城万事达信用卡" , @"中国银行·中银奥运信用卡" , @"中国银行·长城信用卡" , @"中国银行·长城信用卡" , @"中国银行·长城信用卡" , @"中国银行·长城万事达信用卡" , @"中国银行·长城公务卡" , @"中国银行·长城公务卡" , @"中国银行·中银万事达信用卡" , @"中国银行·中银万事达信用卡" , @"中国银行·长城人民币信用卡" , @"中国银行·长城人民币信用卡" , @"中国银行·长城人民币信用卡" , @"中国银行·长城信用卡" , @"中国银行·长城人民币信用卡" , @"中国银行·长城人民币信用卡" , @"中国银行·长城信用卡" , @"中国银行·银联单币贷记卡" , @"中国银行·长城信用卡" , @"中国银行·长城信用卡" , @"中国银行·长城信用卡" , @"中国银行·长城电子借记卡" , @"中国银行·长城人民币信用卡" , @"中国银行·银联标准公务卡" , @"中国银行·一卡双账户普卡" , @"中国银行·财互通卡" , @"中国银行·电子现金卡" , @"中国银行·长城人民币信用卡" , @"中国银行·长城单位信用卡普卡" , @"中国银行·中银女性主题信用卡" , @"中国银行·长城单位信用卡金卡" , @"中国银行·白金卡" , @"中国银行·中职学生资助卡" , @"中国银行·银联标准卡" , @"中国银行·金融IC卡" , @"中国银行·长城社会保障卡" , @"中国银行·世界卡" , @"中国银行·社保联名卡" , @"中国银行·社保联名卡" , @"中国银行·医保联名卡" , @"中国银行·医保联名卡" , @"中国银行·公司借记卡" , @"中国银行·银联美运顶级卡" , @"中国银行·长城福农借记卡金卡" , @"中国银行·长城福农借记卡普卡" , @"中国银行·中行金融IC卡普卡" , @"中国银行·中行金融IC卡金卡" , @"中国银行·中行金融IC卡白金卡" , @"中国银行·长城银联公务IC卡白金卡" , @"中国银行·中银旅游信用卡" , @"中国银行·长城银联公务IC卡金卡" , @"中国银行·中国旅游卡" , @"中国银行·武警军人保障卡" , @"中国银行·社保联名借记IC卡" , @"中国银行·社保联名借记IC卡" , @"中国银行·医保联名借记IC卡" , @"中国银行·医保联名借记IC卡" , @"中国银行·借记IC个人普卡" , @"中国银行·借记IC个人金卡" , @"中国银行·借记IC个人普卡" , @"中国银行·借记IC白金卡" , @"中国银行·借记IC钻石卡" , @"中国银行·借记IC联名卡" , @"中国银行·普通高中学生资助卡" , @"中国银行·长城环球通港澳台旅游金卡" , @"中国银行·长城环球通港澳台旅游白金卡" , @"中国银行·中银福农信用卡" , @"中国银行金边分行·借记卡" , @"中国银行雅加达分行·借记卡" , @"中国银行首尔分行·借记卡" , @"中国银行澳门分行·人民币信用卡" , @"中国银行澳门分行·人民币信用卡" , @"中国银行澳门分行·中银卡" , @"中国银行澳门分行·中银卡" , @"中国银行澳门分行·中银卡" , @"中国银行澳门分行·中银银联双币商务卡" , @"中国银行澳门分行·预付卡" , @"中国银行澳门分行·澳门中国银行银联预付卡" , @"中国银行澳门分行·澳门中国银行银联预付卡" , @"中国银行澳门分行·熊猫卡" , @"中国银行澳门分行·财富卡" , @"中国银行澳门分行·银联港币卡" , @"中国银行澳门分行·银联澳门币卡" , @"中国银行马尼拉分行·双币种借记卡" , @"中国银行胡志明分行·借记卡" , @"中国银行曼谷分行·借记卡" , @"中国银行曼谷分行·长城信用卡环球通" , @"中国银行曼谷分行·借记卡" , @"建设银行·龙卡准贷记卡" , @"建设银行·龙卡准贷记卡金卡" , @"建设银行·中职学生资助卡" , @"建设银行·乐当家银卡VISA" , @"建设银行·乐当家金卡VISA" , @"建设银行·乐当家白金卡" , @"建设银行·龙卡普通卡VISA" , @"建设银行·龙卡储蓄卡" , @"建设银行·VISA准贷记卡(银联卡)" , @"建设银行·VISA准贷记金卡" , @"建设银行·乐当家" , @"建设银行·乐当家" , @"建设银行·准贷记金卡" , @"建设银行·乐当家白金卡" , @"建设银行·金融复合IC卡" , @"建设银行·银联标准卡" , @"建设银行·银联理财钻石卡" , @"建设银行·金融IC卡" , @"建设银行·理财白金卡" , @"建设银行·社保IC卡" , @"建设银行·财富卡私人银行卡" , @"建设银行·理财金卡" , @"建设银行·福农卡" , @"建设银行·武警军人保障卡" , @"建设银行·龙卡通" , @"建设银行·银联储蓄卡" , @"建设银行·龙卡储蓄卡(银联卡)" , @"建设银行·准贷记卡" , @"建设银行·理财白金卡" , @"建设银行·理财金卡" , @"建设银行·准贷记卡普卡" , @"建设银行·准贷记卡金卡" , @"建设银行·龙卡信用卡" , @"建设银行·建行陆港通龙卡" , @"中国建设银行·普通高中学生资助卡" , @"中国建设银行·中国旅游卡" , @"中国建设银行·龙卡JCB金卡" , @"中国建设银行·龙卡JCB白金卡" , @"中国建设银行·龙卡JCB普卡" , @"中国建设银行·龙卡贷记卡公司卡" , @"中国建设银行·龙卡贷记卡" , @"中国建设银行·龙卡国际普通卡VISA" , @"中国建设银行·龙卡国际金卡VISA" , @"中国建设银行·VISA白金信用卡" , @"中国建设银行·龙卡国际白金卡" , @"中国建设银行·龙卡国际普通卡MASTER" , @"中国建设银行·龙卡国际金卡MASTER" , @"中国建设银行·龙卡万事达金卡" , @"中国建设银行·龙卡贷记卡" , @"中国建设银行·龙卡万事达白金卡" , @"中国建设银行·龙卡贷记卡" , @"中国建设银行·龙卡万事达信用卡" , @"中国建设银行·龙卡人民币信用卡" , @"中国建设银行·龙卡人民币信用金卡" , @"中国建设银行·龙卡人民币白金卡" , @"中国建设银行·龙卡IC信用卡普卡" , @"中国建设银行·龙卡IC信用卡金卡" , @"中国建设银行·龙卡IC信用卡白金卡" , @"中国建设银行·龙卡银联公务卡普卡" , @"中国建设银行·龙卡银联公务卡金卡" , @"中国建设银行·中国旅游卡" , @"中国建设银行·中国旅游卡" , @"中国建设银行·龙卡IC公务卡" , @"中国建设银行·龙卡IC公务卡" , @"交通银行·交行预付卡" , @"交通银行·世博预付IC卡" , @"交通银行·太平洋互连卡" , @"交通银行·太平洋万事顺卡" , @"交通银行·太平洋互连卡(银联卡)" , @"交通银行·太平洋白金信用卡" , @"交通银行·太平洋双币贷记卡" , @"交通银行·太平洋双币贷记卡" , @"交通银行·太平洋双币贷记卡" , @"交通银行·太平洋白金信用卡" , @"交通银行·太平洋双币贷记卡" , @"交通银行·太平洋万事顺卡" , @"交通银行·太平洋人民币贷记卡" , @"交通银行·太平洋人民币贷记卡" , @"交通银行·太平洋双币贷记卡" , @"交通银行·太平洋准贷记卡" , @"交通银行·太平洋准贷记卡" , @"交通银行·太平洋准贷记卡" , @"交通银行·太平洋准贷记卡" , @"交通银行·太平洋借记卡" , @"交通银行·太平洋借记卡" , @"交通银行·太平洋人民币贷记卡" , @"交通银行·太平洋借记卡" , @"交通银行·太平洋MORE卡" , @"交通银行·白金卡" , @"交通银行·交通银行公务卡普卡" , @"交通银行·太平洋人民币贷记卡" , @"交通银行·太平洋互连卡" , @"交通银行·太平洋借记卡" , @"交通银行·太平洋万事顺卡" , @"交通银行·太平洋贷记卡(银联卡)" , @"交通银行·太平洋贷记卡(银联卡)" , @"交通银行·太平洋贷记卡(银联卡)" , @"交通银行·太平洋贷记卡(银联卡)" , @"交通银行·交通银行公务卡金卡" , @"交通银行·交银IC卡" , @"交通银行香港分行·交通银行港币借记卡" , @"交通银行香港分行·港币礼物卡" , @"交通银行香港分行·双币种信用卡" , @"交通银行香港分行·双币种信用卡" , @"交通银行香港分行·双币卡" , @"交通银行香港分行·银联人民币卡" , @"交通银行澳门分行·银联借记卡" , @"中信银行·中信借记卡" , @"中信银行·中信借记卡" , @"中信银行·中信国际借记卡" , @"中信银行·中信国际借记卡" , @"中信银行·中国旅行卡" , @"中信银行·中信借记卡(银联卡)" , @"中信银行·中信借记卡(银联卡)" , @"中信银行·中信贵宾卡(银联卡)" , @"中信银行·中信理财宝金卡" , @"中信银行·中信理财宝白金卡" , @"中信银行·中信钻石卡" , @"中信银行·中信钻石卡" , @"中信银行·中信借记卡" , @"中信银行·中信理财宝(银联卡)" , @"中信银行·中信理财宝(银联卡)" , @"中信银行·中信理财宝(银联卡)" , @"中信银行·借记卡" , @"中信银行·理财宝IC卡" , @"中信银行·理财宝IC卡" , @"中信银行·理财宝IC卡" , @"中信银行·理财宝IC卡" , @"中信银行·理财宝IC卡" , @"中信银行·主账户复合电子现金卡" , @"光大银行·阳光商旅信用卡" , @"光大银行·阳光商旅信用卡" , @"光大银行·阳光商旅信用卡" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·阳光卡(银联卡)" , @"光大银行·借记卡普卡" , @"光大银行·社会保障IC卡" , @"光大银行·IC借记卡普卡" , @"光大银行·手机支付卡" , @"光大银行·联名IC卡普卡" , @"光大银行·借记IC卡白金卡" , @"光大银行·借记IC卡金卡" , @"光大银行·阳光旅行卡" , @"光大银行·借记IC卡钻石卡" , @"光大银行·联名IC卡金卡" , @"光大银行·联名IC卡白金卡" , @"光大银行·联名IC卡钻石卡" , @"华夏银行·华夏卡(银联卡)" , @"华夏银行·华夏白金卡" , @"华夏银行·华夏普卡" , @"华夏银行·华夏金卡" , @"华夏银行·华夏白金卡" , @"华夏银行·华夏钻石卡" , @"华夏银行·华夏卡(银联卡)" , @"华夏银行·华夏至尊金卡(银联卡)" , @"华夏银行·华夏丽人卡(银联卡)" , @"华夏银行·华夏万通卡" , @"民生银行·民生借记卡(银联卡)" , @"民生银行·民生银联借记卡－金卡" , @"民生银行·钻石卡" , @"民生银行·民生借记卡(银联卡)" , @"民生银行·民生借记卡(银联卡)" , @"民生银行·民生借记卡(银联卡)" , @"民生银行·民生借记卡" , @"民生银行·民生国际卡" , @"民生银行·民生国际卡(银卡)" , @"民生银行·民生国际卡(欧元卡)" , @"民生银行·民生国际卡(澳元卡)" , @"民生银行·民生国际卡" , @"民生银行·民生国际卡" , @"民生银行·薪资理财卡" , @"民生银行·借记卡普卡" , @"民生银行·民生MasterCard" , @"民生银行·民生MasterCard" , @"民生银行·民生MasterCard" , @"民生银行·民生MasterCard" , @"民生银行·民生JCB信用卡" , @"民生银行·民生JCB金卡" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生JCB普卡" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生信用卡(银联卡)" , @"民生银行·民生信用卡(银联卡)" , @"民生银行·民生银联白金信用卡" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生银联个人白金卡" , @"民生银行·公务卡金卡" , @"民生银行·民生贷记卡(银联卡)" , @"民生银行·民生银联商务信用卡" , @"民生银行·民VISA无限卡" , @"民生银行·民生VISA商务白金卡" , @"民生银行·民生万事达钛金卡" , @"民生银行·民生万事达世界卡" , @"民生银行·民生万事达白金公务卡" , @"民生银行·民生JCB白金卡" , @"民生银行·银联标准金卡" , @"民生银行·银联芯片普卡" , @"民生银行·民生运通双币信用卡普卡" , @"民生银行·民生运通双币信用卡金卡" , @"民生银行·民生运通双币信用卡钻石卡" , @"民生银行·民生运通双币标准信用卡白金卡" , @"民生银行·银联芯片金卡" , @"民生银行·银联芯片白金卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·两地一卡通" , @"招商银行·招行国际卡(银联卡)" , @"招商银行·招商银行信用卡" , @"招商银行·VISA商务信用卡" , @"招商银行·招行国际卡(银联卡)" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招行国际卡(银联卡)" , @"招商银行·世纪金花联名信用卡" , @"招商银行·招行国际卡(银联卡)" , @"招商银行·招商银行信用卡" , @"招商银行·万事达信用卡" , @"招商银行·万事达信用卡" , @"招商银行·万事达信用卡" , @"招商银行·万事达信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·一卡通(银联卡)" , @"招商银行·万事达信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·招商银行信用卡" , @"招商银行·一卡通(银联卡)" , @"招商银行·公司卡(银联卡)" , @"招商银行·金卡" , @"招商银行·招行一卡通" , @"招商银行·招行一卡通" , @"招商银行·万事达信用卡" , @"招商银行·金葵花卡" , @"招商银行·电子现金卡" , @"招商银行·银联IC普卡" , @"招商银行·银联IC金卡" , @"招商银行·银联金葵花IC卡" , @"招商银行·IC公务卡" , @"招商银行·招商银行信用卡" , @"招商银行信用卡中心·美国运通绿卡" , @"招商银行信用卡中心·美国运通金卡" , @"招商银行信用卡中心·美国运通商务绿卡" , @"招商银行信用卡中心·美国运通商务金卡" , @"招商银行信用卡中心·VISA信用卡" , @"招商银行信用卡中心·MASTER信用卡" , @"招商银行信用卡中心·MASTER信用金卡" , @"招商银行信用卡中心·银联标准公务卡(金卡)" , @"招商银行信用卡中心·VISA信用卡" , @"招商银行信用卡中心·银联标准财政公务卡" , @"招商银行信用卡中心·芯片IC信用卡" , @"招商银行信用卡中心·芯片IC信用卡" , @"招商银行香港分行·香港一卡通" , @"兴业银行·兴业卡(银联卡)" , @"兴业银行·兴业卡(银联标准卡)" , @"兴业银行·兴业自然人生理财卡" , @"兴业银行·兴业智能卡(银联卡)" , @"兴业银行·兴业智能卡" , @"兴业银行·visa标准双币个人普卡" , @"兴业银行·VISA商务普卡" , @"兴业银行·VISA商务金卡" , @"兴业银行·VISA运动白金信用卡" , @"兴业银行·万事达信用卡(银联卡)" , @"兴业银行·VISA信用卡(银联卡)" , @"兴业银行·加菲猫信用卡" , @"兴业银行·个人白金卡" , @"兴业银行·银联信用卡(银联卡)" , @"兴业银行·银联信用卡(银联卡)" , @"兴业银行·银联白金信用卡" , @"兴业银行·银联标准公务卡" , @"兴业银行·VISA信用卡(银联卡)" , @"兴业银行·万事达信用卡(银联卡)" , @"兴业银行·银联标准贷记普卡" , @"兴业银行·银联标准贷记金卡" , @"兴业银行·银联标准贷记金卡" , @"兴业银行·银联标准贷记金卡" , @"兴业银行·兴业信用卡" , @"兴业银行·兴业信用卡" , @"兴业银行·兴业信用卡" , @"兴业银行·银联标准贷记普卡" , @"兴业银行·银联标准贷记普卡" , @"兴业银行·兴业芯片普卡" , @"兴业银行·兴业芯片金卡" , @"兴业银行·兴业芯片白金卡" , @"兴业银行·兴业芯片钻石卡" , @"浦东发展银行·浦发JCB金卡" , @"浦东发展银行·浦发JCB白金卡" , @"浦东发展银行·信用卡VISA普通" , @"浦东发展银行·信用卡VISA金卡" , @"浦东发展银行·浦发银行VISA年青卡" , @"浦东发展银行·VISA白金信用卡" , @"浦东发展银行·浦发万事达白金卡" , @"浦东发展银行·浦发JCB普卡" , @"浦东发展银行·浦发万事达金卡" , @"浦东发展银行·浦发万事达普卡" , @"浦东发展银行·浦发单币卡" , @"浦东发展银行·浦发银联单币麦兜普卡" , @"浦东发展银行·东方轻松理财卡" , @"浦东发展银行·东方-轻松理财卡普卡" , @"浦东发展银行·东方轻松理财卡" , @"浦东发展银行·东方轻松理财智业金卡" , @"浦东发展银行·东方卡(银联卡)" , @"浦东发展银行·东方卡(银联卡)" , @"浦东发展银行·东方卡(银联卡)" , @"浦东发展银行·公务卡金卡" , @"浦东发展银行·公务卡普卡" , @"浦东发展银行·东方卡" , @"浦东发展银行·东方卡" , @"浦东发展银行·浦发单币卡" , @"浦东发展银行·浦发联名信用卡" , @"浦东发展银行·浦发银联白金卡" , @"浦东发展银行·轻松理财普卡" , @"浦东发展银行·移动联名卡" , @"浦东发展银行·轻松理财消贷易卡" , @"浦东发展银行·轻松理财普卡（复合卡）" , @"浦东发展银行·贷记卡" , @"浦东发展银行·贷记卡" , @"浦东发展银行·东方借记卡（复合卡）" , @"浦东发展银行·电子现金卡（IC卡）" , @"浦东发展银行·移动浦发联名卡" , @"浦东发展银行·东方-标准准贷记卡" , @"浦东发展银行·轻松理财金卡（复合卡）" , @"浦东发展银行·轻松理财白金卡（复合卡）" , @"浦东发展银行·轻松理财钻石卡（复合卡）" , @"浦东发展银行·东方卡" , @"恒丰银行·九州IC卡" , @"恒丰银行·九州借记卡(银联卡)" , @"恒丰银行·九州借记卡(银联卡)" , @"天津市商业银行·银联卡(银联卡)" , @"烟台商业银行·金通卡" , @"潍坊银行·鸢都卡(银联卡)" , @"潍坊银行·鸳都卡(银联卡)" , @"临沂商业银行·沂蒙卡(银联卡)" , @"临沂商业银行·沂蒙卡(银联卡)" , @"日照市商业银行·黄海卡" , @"日照市商业银行·黄海卡(银联卡)" , @"浙商银行·商卡" , @"浙商银行·商卡" , @"渤海银行·浩瀚金卡" , @"渤海银行·渤海银行借记卡" , @"渤海银行·金融IC卡" , @"渤海银行·渤海银行公司借记卡" , @"星展银行·星展银行借记卡" , @"星展银行·星展银行借记卡" , @"恒生银行·恒生通财卡" , @"恒生银行·恒生优越通财卡" , @"新韩银行·新韩卡" , @"上海银行·慧通钻石卡" , @"上海银行·慧通金卡" , @"上海银行·私人银行卡" , @"上海银行·综合保险卡" , @"上海银行·申卡社保副卡(有折)" , @"上海银行·申卡社保副卡(无折)" , @"上海银行·白金IC借记卡" , @"上海银行·慧通白金卡(配折)" , @"上海银行·慧通白金卡(不配折)" , @"上海银行·申卡(银联卡)" , @"上海银行·申卡借记卡" , @"上海银行·银联申卡(银联卡)" , @"上海银行·单位借记卡" , @"上海银行·首发纪念版IC卡" , @"上海银行·申卡贷记卡" , @"上海银行·申卡贷记卡" , @"上海银行·J分期付款信用卡" , @"上海银行·申卡贷记卡" , @"上海银行·申卡贷记卡" , @"上海银行·上海申卡IC" , @"上海银行·申卡贷记卡" , @"上海银行·申卡贷记卡普通卡" , @"上海银行·申卡贷记卡金卡" , @"上海银行·万事达白金卡" , @"上海银行·万事达星运卡" , @"上海银行·申卡贷记卡金卡" , @"上海银行·申卡贷记卡普通卡" , @"上海银行·安融卡" , @"上海银行·分期付款信用卡" , @"上海银行·信用卡" , @"上海银行·个人公务卡" , @"上海银行·安融卡" , @"上海银行·上海银行银联白金卡" , @"上海银行·贷记IC卡" , @"上海银行·中国旅游卡（IC普卡）" , @"上海银行·中国旅游卡（IC金卡）" , @"上海银行·中国旅游卡（IC白金卡）" , @"上海银行·万事达钻石卡" , @"上海银行·淘宝IC普卡" , @"北京银行·京卡借记卡" , @"北京银行·京卡(银联卡)" , @"北京银行·京卡借记卡" , @"北京银行·京卡" , @"北京银行·京卡" , @"北京银行·借记IC卡" , @"北京银行·京卡贵宾金卡" , @"北京银行·京卡贵宾白金卡" , @"吉林银行·君子兰一卡通(银联卡)" , @"吉林银行·君子兰卡(银联卡)" , @"吉林银行·长白山金融IC卡" , @"吉林银行·信用卡" , @"吉林银行·信用卡" , @"吉林银行·公务卡" , @"镇江市商业银行·金山灵通卡(银联卡)" , @"镇江市商业银行·金山灵通卡(银联卡)" , @"宁波银行·银联标准卡" , @"宁波银行·汇通借记卡" , @"宁波银行·汇通卡(银联卡)" , @"宁波银行·明州卡" , @"宁波银行·汇通借记卡" , @"宁波银行·汇通国际卡银联双币卡" , @"宁波银行·汇通国际卡银联双币卡" , @"平安银行·新磁条借记卡" , @"平安银行·平安银行IC借记卡" , @"平安银行·万事顺卡" , @"平安银行·平安银行借记卡" , @"平安银行·平安银行借记卡" , @"平安银行·万事顺借记卡" , @"焦作市商业银行·月季借记卡(银联卡)" , @"焦作市商业银行·月季城市通(银联卡)" , @"焦作市商业银行·中国旅游卡" , @"温州银行·金鹿卡" , @"汉口银行·九通卡(银联卡)" , @"汉口银行·九通卡" , @"汉口银行·借记卡" , @"汉口银行·借记卡" , @"盛京银行·玫瑰卡" , @"盛京银行·玫瑰IC卡" , @"盛京银行·玫瑰IC卡" , @"盛京银行·玫瑰卡" , @"盛京银行·玫瑰卡" , @"盛京银行·玫瑰卡(银联卡)" , @"盛京银行·玫瑰卡(银联卡)" , @"盛京银行·盛京银行公务卡" , @"洛阳银行·都市一卡通(银联卡)" , @"洛阳银行·都市一卡通(银联卡)" , @"洛阳银行·--" , @"大连银行·北方明珠卡" , @"大连银行·人民币借记卡" , @"大连银行·金融IC借记卡" , @"大连银行·大连市社会保障卡" , @"大连银行·借记IC卡" , @"大连银行·借记IC卡" , @"大连银行·大连市商业银行贷记卡" , @"大连银行·大连市商业银行贷记卡" , @"大连银行·银联标准公务卡" , @"苏州市商业银行·姑苏卡" , @"杭州商业银行·西湖卡" , @"杭州商业银行·西湖卡" , @"杭州商业银行·借记IC卡" , @"杭州商业银行·" , @"南京银行·梅花信用卡公务卡" , @"南京银行·梅花信用卡商务卡" , @"南京银行·梅花贷记卡(银联卡)" , @"南京银行·梅花借记卡(银联卡)" , @"南京银行·白金卡" , @"南京银行·商务卡" , @"东莞市商业银行·万顺通卡(银联卡)" , @"东莞市商业银行·万顺通卡(银联卡)" , @"东莞市商业银行·万顺通借记卡" , @"东莞市商业银行·社会保障卡" , @"乌鲁木齐市商业银行·雪莲借记IC卡" , @"乌鲁木齐市商业银行·乌鲁木齐市公务卡" , @"乌鲁木齐市商业银行·福农卡贷记卡" , @"乌鲁木齐市商业银行·福农卡准贷记卡" , @"乌鲁木齐市商业银行·雪莲准贷记卡" , @"乌鲁木齐市商业银行·雪莲贷记卡(银联卡)" , @"乌鲁木齐市商业银行·雪莲借记IC卡" , @"乌鲁木齐市商业银行·雪莲借记卡(银联卡)" , @"乌鲁木齐市商业银行·雪莲卡(银联卡)" , @"绍兴银行·兰花IC借记卡" , @"绍兴银行·社保IC借记卡" , @"绍兴银行·兰花公务卡" , @"成都商业银行·芙蓉锦程福农卡" , @"成都商业银行·芙蓉锦程天府通卡" , @"成都商业银行·锦程卡(银联卡)" , @"成都商业银行·锦程卡金卡" , @"成都商业银行·锦程卡定活一卡通金卡" , @"成都商业银行·锦程卡定活一卡通" , @"成都商业银行·锦程力诚联名卡" , @"成都商业银行·锦程力诚联名卡" , @"成都商业银行·锦程卡(银联卡)" , @"抚顺银行·借记IC卡" , @"临商银行·借记卡" , @"宜昌市商业银行·三峡卡(银联卡)" , @"宜昌市商业银行·信用卡(银联卡)" , @"葫芦岛市商业银行·一通卡" , @"葫芦岛市商业银行·一卡通(银联卡)" , @"天津市商业银行·津卡" , @"天津市商业银行·津卡贷记卡(银联卡)" , @"天津市商业银行·贷记IC卡" , @"天津市商业银行·--" , @"天津银行·商务卡" , @"宁夏银行·宁夏银行公务卡" , @"宁夏银行·宁夏银行福农贷记卡" , @"宁夏银行·如意卡(银联卡)" , @"宁夏银行·宁夏银行福农借记卡" , @"宁夏银行·如意借记卡" , @"宁夏银行·如意IC卡" , @"宁夏银行·宁夏银行如意借记卡" , @"宁夏银行·中国旅游卡" , @"齐商银行·金达卡(银联卡)" , @"齐商银行·金达借记卡(银联卡)" , @"齐商银行·金达IC卡" , @"徽商银行·黄山卡" , @"徽商银行·黄山卡" , @"徽商银行·借记卡" , @"徽商银行·徽商银行中国旅游卡（安徽）" , @"徽商银行合肥分行·黄山卡" , @"徽商银行芜湖分行·黄山卡(银联卡)" , @"徽商银行马鞍山分行·黄山卡(银联卡)" , @"徽商银行淮北分行·黄山卡(银联卡)" , @"徽商银行安庆分行·黄山卡(银联卡)" , @"重庆银行·长江卡(银联卡)" , @"重庆银行·长江卡(银联卡)" , @"重庆银行·长江卡" , @"重庆银行·借记IC卡" , @"哈尔滨银行·丁香一卡通(银联卡)" , @"哈尔滨银行·丁香借记卡(银联卡)" , @"哈尔滨银行·丁香卡" , @"哈尔滨银行·福农借记卡" , @"无锡市商业银行·太湖金保卡(银联卡)" , @"丹东银行·借记IC卡" , @"丹东银行·丹东银行公务卡" , @"兰州银行·敦煌卡" , @"南昌银行·金瑞卡(银联卡)" , @"南昌银行·南昌银行借记卡" , @"南昌银行·金瑞卡" , @"晋商银行·晋龙一卡通" , @"晋商银行·晋龙一卡通" , @"晋商银行·晋龙卡(银联卡)" , @"青岛银行·金桥通卡" , @"青岛银行·金桥卡(银联卡)" , @"青岛银行·金桥卡(银联卡)" , @"青岛银行·金桥卡" , @"青岛银行·借记IC卡" , @"吉林银行·雾凇卡(银联卡)" , @"吉林银行·雾凇卡(银联卡)" , @"南通商业银行·金桥卡(银联卡)" , @"南通商业银行·金桥卡(银联卡)" , @"日照银行·黄海卡、财富卡借记卡" , @"鞍山银行·千山卡(银联卡)" , @"鞍山银行·千山卡(银联卡)" , @"鞍山银行·千山卡" , @"青海银行·三江银行卡(银联卡)" , @"青海银行·三江卡" , @"台州银行·大唐贷记卡" , @"台州银行·大唐准贷记卡" , @"台州银行·大唐卡(银联卡)" , @"台州银行·大唐卡" , @"台州银行·借记卡" , @"台州银行·公务卡" , @"泉州银行·海峡银联卡(银联卡)" , @"泉州银行·海峡储蓄卡" , @"泉州银行·海峡银联卡(银联卡)" , @"泉州银行·海峡卡" , @"泉州银行·公务卡" , @"昆明商业银行·春城卡(银联卡)" , @"昆明商业银行·春城卡(银联卡)" , @"昆明商业银行·富滇IC卡（复合卡）" , @"阜新银行·借记IC卡" , @"嘉兴银行·南湖借记卡(银联卡)" , @"廊坊银行·白金卡" , @"廊坊银行·金卡" , @"廊坊银行·银星卡(银联卡)" , @"廊坊银行·龙凤呈祥卡" , @"内蒙古银行·百灵卡(银联卡)" , @"内蒙古银行·成吉思汗卡" , @"湖州市商业银行·百合卡" , @"湖州市商业银行·" , @"沧州银行·狮城卡" , @"南宁市商业银行·桂花卡(银联卡)" , @"包商银行·雄鹰卡(银联卡)" , @"包商银行·包头市商业银行借记卡" , @"包商银行·雄鹰贷记卡" , @"包商银行·包商银行内蒙古自治区公务卡" , @"包商银行·贷记卡" , @"包商银行·借记卡" , @"连云港市商业银行·金猴神通借记卡" , @"威海商业银行·通达卡(银联卡)" , @"威海市商业银行·通达借记IC卡" , @"攀枝花市商业银行·攀枝花卡(银联卡)" , @"攀枝花市商业银行·攀枝花卡" , @"绵阳市商业银行·科技城卡(银联卡)" , @"泸州市商业银行·酒城卡(银联卡)" , @"泸州市商业银行·酒城IC卡" , @"大同市商业银行·云冈卡(银联卡)" , @"三门峡银行·天鹅卡(银联卡)" , @"广东南粤银行·南珠卡(银联卡)" , @"张家口市商业银行·好运IC借记卡" , @"桂林市商业银行·漓江卡(银联卡)" , @"龙江银行·福农借记卡" , @"龙江银行·联名借记卡" , @"龙江银行·福农借记卡" , @"龙江银行·龙江IC卡" , @"龙江银行·社会保障卡" , @"龙江银行·--" , @"江苏长江商业银行·长江卡" , @"徐州市商业银行·彭城借记卡(银联卡)" , @"南充市商业银行·借记IC卡" , @"南充市商业银行·熊猫团团卡" , @"莱商银行·银联标准卡" , @"莱芜银行·金凤卡" , @"莱商银行·借记IC卡" , @"德阳银行·锦程卡定活一卡通" , @"德阳银行·锦程卡定活一卡通金卡" , @"德阳银行·锦程卡定活一卡通" , @"唐山市商业银行·唐山市城通卡" , @"曲靖市商业银行·珠江源卡" , @"曲靖市商业银行·珠江源IC卡" , @"温州银行·金鹿信用卡" , @"温州银行·金鹿信用卡" , @"温州银行·金鹿公务卡" , @"温州银行·贷记IC卡" , @"汉口银行·汉口银行贷记卡" , @"汉口银行·汉口银行贷记卡" , @"汉口银行·九通香港旅游贷记普卡" , @"汉口银行·九通香港旅游贷记金卡" , @"汉口银行·贷记卡" , @"汉口银行·九通公务卡" , @"江苏银行·聚宝借记卡" , @"江苏银行·月季卡" , @"江苏银行·紫金卡" , @"江苏银行·绿扬卡(银联卡)" , @"江苏银行·月季卡(银联卡)" , @"江苏银行·九州借记卡(银联卡)" , @"江苏银行·月季卡(银联卡)" , @"江苏银行·聚宝惠民福农卡" , @"江苏银行·江苏银行聚宝IC借记卡" , @"江苏银行·聚宝IC借记卡VIP卡" , @"长治市商业银行·长治商行银联晋龙卡" , @"承德市商业银行·热河卡" , @"承德银行·借记IC卡" , @"德州银行·长河借记卡" , @"德州银行·--" , @"遵义市商业银行·社保卡" , @"遵义市商业银行·尊卡" , @"邯郸市商业银行·邯银卡" , @"邯郸市商业银行·邯郸银行贵宾IC借记卡" , @"安顺市商业银行·黄果树福农卡" , @"安顺市商业银行·黄果树借记卡" , @"江苏银行·紫金信用卡(公务卡)" , @"江苏银行·紫金信用卡" , @"江苏银行·天翼联名信用卡" , @"平凉市商业银行·广成卡" , @"玉溪市商业银行·红塔卡" , @"玉溪市商业银行·红塔卡" , @"浙江民泰商业银行·金融IC卡" , @"浙江民泰商业银行·民泰借记卡" , @"浙江民泰商业银行·金融IC卡C卡" , @"浙江民泰商业银行·银联标准普卡金卡" , @"浙江民泰商业银行·商惠通" , @"上饶市商业银行·三清山卡" , @"东营银行·胜利卡" , @"泰安市商业银行·岱宗卡" , @"泰安市商业银行·市民一卡通" , @"浙江稠州商业银行·义卡" , @"浙江稠州商业银行·义卡借记IC卡" , @"浙江稠州商业银行·公务卡" , @"自贡市商业银行·借记IC卡" , @"自贡市商业银行·锦程卡" , @"鄂尔多斯银行·天骄公务卡" , @"鹤壁银行·鹤卡" , @"许昌银行·连城卡" , @"铁岭银行·龙凤卡" , @"乐山市商业银行·大福卡" , @"乐山市商业银行·--" , @"长安银行·长长卡" , @"长安银行·借记IC卡" , @"重庆三峡银行·财富人生卡" , @"重庆三峡银行·借记卡" , @"石嘴山银行·麒麟借记卡" , @"石嘴山银行·麒麟借记卡" , @"石嘴山银行·麒麟公务卡" , @"盘锦市商业银行·鹤卡" , @"盘锦市商业银行·盘锦市商业银行鹤卡" , @"平顶山银行·平顶山银行公务卡" , @"朝阳银行·鑫鑫通卡" , @"朝阳银行·朝阳银行福农卡" , @"朝阳银行·红山卡" , @"宁波东海银行·绿叶卡" , @"遂宁市商业银行·锦程卡" , @"遂宁是商业银行·金荷卡" , @"保定银行·直隶卡" , @"保定银行·直隶卡" , @"凉山州商业银行·锦程卡" , @"凉山州商业银行·金凉山卡" , @"漯河银行·福卡" , @"漯河银行·福源卡" , @"漯河银行·福源公务卡" , @"达州市商业银行·锦程卡" , @"新乡市商业银行·新卡" , @"晋中银行·九州方圆借记卡" , @"晋中银行·九州方圆卡" , @"驻马店银行·驿站卡" , @"驻马店银行·驿站卡" , @"驻马店银行·公务卡" , @"衡水银行·金鼎卡" , @"衡水银行·借记IC卡" , @"周口银行·如愿卡" , @"周口银行·公务卡" , @"阳泉市商业银行·金鼎卡" , @"阳泉市商业银行·金鼎卡" , @"宜宾市商业银行·锦程卡" , @"宜宾市商业银行·借记IC卡" , @"库尔勒市商业银行·孔雀胡杨卡" , @"雅安市商业银行·锦城卡" , @"雅安市商业银行·--" , @"安阳银行·安鼎卡" , @"信阳银行·信阳卡" , @"信阳银行·公务卡" , @"信阳银行·信阳卡" , @"华融湘江银行·华融卡" , @"华融湘江银行·华融卡" , @"营口沿海银行·祥云借记卡" , @"景德镇商业银行·瓷都卡" , @"哈密市商业银行·瓜香借记卡" , @"湖北银行·金牛卡" , @"湖北银行·汉江卡" , @"湖北银行·借记卡" , @"湖北银行·三峡卡" , @"湖北银行·至尊卡" , @"湖北银行·金融IC卡" , @"西藏银行·借记IC卡" , @"新疆汇和银行·汇和卡" , @"广东华兴银行·借记卡" , @"广东华兴银行·华兴银联公司卡" , @"广东华兴银行·华兴联名IC卡" , @"广东华兴银行·华兴金融IC借记卡" , @"濮阳银行·龙翔卡" , @"宁波通商银行·借记卡" , @"甘肃银行·神舟兴陇借记卡" , @"甘肃银行·甘肃银行神州兴陇IC卡" , @"枣庄银行·借记IC卡" , @"本溪市商业银行·借记卡" , @"盛京银行·医保卡" , @"上海农商银行·如意卡(银联卡)" , @"上海农商银行·如意卡(银联卡)" , @"上海农商银行·鑫通卡" , @"上海农商银行·国际如意卡" , @"上海农商银行·借记IC卡" , @"常熟市农村商业银行·粒金贷记卡(银联卡)" , @"常熟市农村商业银行·公务卡" , @"常熟市农村商业银行·粒金准贷卡" , @"常熟农村商业银行·粒金借记卡(银联卡)" , @"常熟农村商业银行·粒金IC卡" , @"常熟农村商业银行·粒金卡" , @"深圳农村商业银行·信通卡(银联卡)" , @"深圳农村商业银行·信通商务卡(银联卡)" , @"深圳农村商业银行·信通卡" , @"深圳农村商业银行·信通商务卡" , @"广州农村商业银行·福农太阳卡" , @"广东南海农村商业银行·盛通卡" , @"广东南海农村商业银行·盛通卡(银联卡)" , @"佛山顺德农村商业银行·恒通卡(银联卡)" , @"佛山顺德农村商业银行·恒通卡" , @"佛山顺德农村商业银行·恒通卡(银联卡)" , @"江阴农村商业银行·暨阳公务卡" , @"江阴市农村商业银行·合作贷记卡(银联卡)" , @"江阴农村商业银行·合作借记卡" , @"江阴农村商业银行·合作卡(银联卡)" , @"江阴农村商业银行·暨阳卡" , @"重庆农村商业银行·江渝借记卡VIP卡" , @"重庆农村商业银行·江渝IC借记卡" , @"重庆农村商业银行·江渝乡情福农卡" , @"东莞农村商业银行·信通卡(银联卡)" , @"东莞农村商业银行·信通卡(银联卡)" , @"东莞农村商业银行·信通信用卡" , @"东莞农村商业银行·信通借记卡" , @"东莞农村商业银行·贷记IC卡" , @"张家港农村商业银行·一卡通(银联卡)" , @"张家港农村商业银行·一卡通(银联卡)" , @"张家港农村商业银行·" , @"北京农村商业银行·信通卡" , @"北京农村商业银行·惠通卡" , @"北京农村商业银行·凤凰福农卡" , @"北京农村商业银行·惠通卡" , @"北京农村商业银行·中国旅行卡" , @"北京农村商业银行·凤凰卡" , @"天津农村商业银行·吉祥商联IC卡" , @"天津农村商业银行·信通借记卡(银联卡)" , @"天津农村商业银行·借记IC卡",@"鄞州农村合作银行·蜜蜂借记卡(银联卡)" , @"宁波鄞州农村合作银行·蜜蜂电子钱包(IC)" , @"宁波鄞州农村合作银行·蜜蜂IC借记卡" , @"宁波鄞州农村合作银行·蜜蜂贷记IC卡" , @"宁波鄞州农村合作银行·蜜蜂贷记卡",@"宁波鄞州农村合作银行·公务卡" , @"成都农村商业银行·福农卡" , @"成都农村商业银行·福农卡" , @"珠海农村商业银行·信通卡(银联卡)" , @"太仓农村商业银行·郑和卡(银联卡)" , @"太仓农村商业银行·郑和IC借记卡" , @"无锡农村商业银行·金阿福" , @"无锡农村商业银行·借记IC卡" , @"黄河农村商业银行·黄河卡" , @"黄河农村商业银行·黄河富农卡福农卡" , @"黄河农村商业银行·借记IC卡" , @"天津滨海农村商业银行·四海通卡", @"天津滨海农村商业银行·四海通e芯卡" , @"武汉农村商业银行·汉卡" , @"武汉农村商业银行·汉卡" , @"武汉农村商业银行·中国旅游卡" , @"江南农村商业银行·阳湖卡(银联卡)" , @"江南农村商业银行·天天红火卡",@"江南农村商业银行·借记IC卡" , @"海口联合农村商业银行·海口联合农村商业银行合卡" , @"湖北嘉鱼吴江村镇银行·垂虹卡" , @"福建建瓯石狮村镇银行·玉竹卡" , @"浙江平湖工银村镇银行·金平卡" , @"重庆璧山工银村镇银行·翡翠卡",@"重庆农村商业银行·银联标准贷记卡" , @"重庆农村商业银行·公务卡" , @"南阳村镇银行·玉都卡" , @"晋中市榆次融信村镇银行·魏榆卡" , @"三水珠江村镇银行·珠江太阳卡" , @"东营莱商村镇银行·绿洲卡" , @"建设银行·单位结算卡" , @"玉溪市商业银行·红塔卡" ];
    
    
    
    //BIN号
    
    NSArray* bankBin = @[@"621098", @"622150", @"622151", @"622181", @"622188", @"955100", @"621095", @"620062", @"621285", @"621798", @"621799",@"621797", @"620529", @"622199", @"621096", @"621622", @"623219", @"621674", @"623218", @"621599",@"370246", @"370248",@"370249", @"427010", @"427018", @"427019", @"427020", @"427029", @"427030", @"427039", @"370247", @"438125", @"438126",@"451804",@"451810", @"451811", @"458071", @"489734", @"489735", @"489736", @"510529", @"427062", @"524091", @"427064",@"530970", @"530990", @"558360", @"620200", @"620302", @"620402", @"620403" , @"620404", @"524047" , @"620406" , @"620407",@"525498" , @"620409" , @"620410" , @"620411" ,@"620412" ,@"620502", @"620503", @"620405", @"620408", @"620512", @"620602",@"620604", @"620607", @"620611", @"620612", @"620704", @"620706", @"620707", @"620708", @"620709", @"620710", @"620609", @"620712" , @"620713" , @"620714" , @"620802" , @"620711" , @"620904" , @"620905" , @"621001" , @"620902" , @"621103" , @"621105" , @"621106" , @"621107" , @"621102" , @"621203" , @"621204" , @"621205" , @"621206" , @"621207" , @"621208" , @"621209" , @"621210" , @"621302" , @"621303" , @"621202" , @"621305" , @"621306" , @"621307" , @"621309" , @"621311" , @"621313" , @"621211" , @"621315" , @"621304" , @"621402" , @"621404" , @"621405" , @"621406" , @"621407" , @"621408" , @"621409" , @"621410" , @"621502" , @"621317" , @"621511" , @"621602" , @"621603" , @"621604" , @"621605" , @"621608" , @"621609" , @"621610" , @"621611" , @"621612" , @"621613" , @"621614" , @"621615" , @"621616" , @"621617" , @"621607" , @"621606" , @"621804" , @"621807" , @"621813" , @"621814" , @"621817" , @"621901" , @"621904" , @"621905" , @"621906" , @"621907" , @"621908" , @"621909" , @"621910" , @"621911" , @"621912" , @"621913" , @"621915" , @"622002" , @"621903" , @"622004" , @"622005" , @"622006" , @"622007" , @"622008" , @"622010" , @"622011" , @"622012" , @"621914" , @"622015" , @"622016" , @"622003" , @"622018" , @"622019" , @"622020" , @"622102" , @"622103" , @"622104" , @"622105" , @"622013" , @"622111" , @"622114" , @"622200" , @"622017" , @"622202" , @"622203" , @"622208" , @"622210" , @"622211" , @"622212" , @"622213" , @"622214" , @"622110" , @"622220" , @"622223" , @"622225" , @"622229" , @"622230" , @"622231" , @"622232" , @"622233" , @"622234" , @"622235" , @"622237" , @"622215" , @"622239" , @"622240" , @"622245" , @"622224" , @"622303" , @"622304" , @"622305" , @"622306" , @"622307" , @"622308" , @"622309" , @"622238" , @"622314" , @"622315" , @"622317" , @"622302" , @"622402" , @"622403" , @"622404" , @"622313" , @"622504" , @"622505" , @"622509" , @"622513" , @"622517" , @"622502" , @"622604" , @"622605" , @"622606" , @"622510" , @"622703" , @"622715" , @"622806" , @"622902" , @"622903" , @"622706" , @"623002" , @"623006" , @"623008" , @"623011" , @"623012" , @"622904" , @"623015" , @"623100" , @"623202" , @"623301" , @"623400" , @"623500" , @"623602" , @"623803" , @"623901" , @"623014" , @"624100" , @"624200" , @"624301" , @"624402" , @"62451804" , @"62451810" , @"62451811" , @"62458071" , @"623700" , @"628288" , @"624000" , @"628286" , @"622206" , @"621225" , @"526836" , @"513685" , @"543098" , @"458441" , @"620058" , @"621281" , @"622246" , @"900000" , @"544210" , @"548943" , @"370267" , @"621558" , @"621559" , @"621722" , @"621723" , @"620086" , @"621226" , @"402791" , @"427028" , @"427038" , @"548259" , @"356879" , @"356880" , @"356881" , @"356882" , @"528856" , @"621618" , @"620516" , @"621227" , @"621721" , @"900010" , @"625330" , @"625331" , @"625332" , @"623062" , @"622236" , @"621670" , @"524374" , @"550213" , @"374738" , @"374739" , @"621288" , @"625708" , @"625709" , @"622597" , @"622599" , @"360883" , @"360884" , @"625865" , @"625866" , @"625899" , @"621376" , @"620054" , @"620142" , @"621428" , @"625939" , @"621434" , @"625987" , @"621761" , @"621749" , @"620184" , @"621300" , @"621378" , @"625114" , @"622159" , @"621720" , @"625021" , @"625022" , @"621379" , @"620114" , @"620146" , @"621724" , @"625918" , @"621371" , @"620143" , @"620149" , @"621414" , @"625914" , @"621375" , @"620187" , @"621433" , @"625986" , @"621370" , @"625925" , @"622926" , @"622927" , @"622928" , @"622929" , @"622930" , @"622931" , @"620124" , @"620183" , @"620561" , @"625116" , @"622227" , @"621372" , @"621464" , @"625942" , @"622158" , @"625917" , @"621765" , @"620094" , @"620186" , @"621719" , @"621719" , @"621750" , @"621377" , @"620148" , @"620185" , @"621374" , @"621731" , @"621781" , @"552599" , @"623206" , @"621671" , @"620059" , @"403361" , @"404117" , @"404118" , @"404119" , @"404120" , @"404121" , @"463758" , @"514027" , @"519412" , @"519413" , @"520082" , @"520083" , @"558730" , @"621282" , @"621336" , @"621619" , @"622821" , @"622822" , @"622823" , @"622824" , @"622825" , @"622826" , @"622827" , @"622828" , @"622836" , @"622837" , @"622840" , @"622841" , @"622843" , @"622844" , @"622845" , @"622846" , @"622847" , @"622848" , @"622849" , @"623018" , @"625996" , @"625997" , @"625998" , @"628268" , @"625826" , @"625827" , @"548478" , @"544243" , @"622820" , @"622830" , @"622838" , @"625336" , @"628269" , @"620501" , @"621660" , @"621661" , @"621662" , @"621663" , @"621665" , @"621667" , @"621668" , @"621669" , @"621666" , @"625908" , @"625910" , @"625909" , @"356833" , @"356835" , @"409665" , @"409666" , @"409668" , @"409669" , @"409670" , @"409671" , @"409672" , @"456351" , @"512315" , @"512316" , @"512411" , @"512412" , @"514957" , @"409667" , @"518378" , @"518379" , @"518474" , @"518475" , @"518476" , @"438088" , @"524865" , @"525745" , @"525746" , @"547766" , @"552742" , @"553131" , @"558868" , @"514958" , @"622752" , @"622753" , @"622755" , @"524864" , @"622757" , @"622758" , @"622759" , @"622760" , @"622761" , @"622762" , @"622763" , @"601382" , @"622756" , @"628388" , @"621256" , @"621212" , @"620514" , @"622754" , @"622764" , @"518377" , @"622765" , @"622788" , @"621283" , @"620061" , @"621725" , @"620040" , @"558869" , @"621330" , @"621331" , @"621332" , @"621333" , @"621297" , @"377677" , @"621568" , @"621569" , @"625905" , @"625906" , @"625907" , @"628313" , @"625333" , @"628312" , @"623208" , @"621620" , @"621756" , @"621757" , @"621758" , @"621759" , @"621785" , @"621786" , @"621787" , @"621788" , @"621789" , @"621790" , @"621672" , @"625337" , @"625338" , @"625568" , @"621648" , @"621248" , @"621249" , @"622750" , @"622751" , @"622771" , @"622772" , @"622770" , @"625145" , @"620531" , @"620210" , @"620211" , @"622479" , @"622480" , @"622273" , @"622274" , @"621231" , @"621638" , @"621334" , @"625140" , @"621395" , @"622725" , @"622728" , @"621284" , @"421349" , @"434061" , @"434062" , @"436728" , @"436742" , @"453242" , @"491031" , @"524094" , @"526410" , @"544033" , @"552245" , @"589970" , @"620060" , @"621080" , @"621081" , @"621466" , @"621467" , @"621488" , @"621499" , @"621598" , @"621621" , @"621700" , @"622280" , @"622700" , @"622707" , @"622966" , @"622988" , @"625955" , @"625956" , @"553242" , @"621082" , @"621673" , @"623211" , @"356896" , @"356899" , @"356895" , @"436718" , @"436738" , @"436745" , @"436748" , @"489592" , @"531693" , @"532450" , @"532458" , @"544887" , @"552801" , @"557080" , @"558895" , @"559051" , @"622166" , @"622168" , @"622708" , @"625964" , @"625965" , @"625966" , @"628266" , @"628366" , @"625362" , @"625363" , @"628316" , @"628317" , @"620021" , @"620521" , @"405512" , @"601428" , @"405512" , @"434910" , @"458123" , @"458124" , @"520169" , @"522964" , @"552853" , @"601428" , @"622250" , @"622251" , @"521899" , @"622254" , @"622255" , @"622256" , @"622257" , @"622258" , @"622259" , @"622253" , @"622261" , @"622284" , @"622656" , @"628216" , @"622252" , @"66405512" , @"622260" , @"66601428" , @"955590" , @"955591" , @"955592" , @"955593" , @"628218" , @"622262" , @"621069" , @"620013" , @"625028" , @"625029" , @"621436" , @"621002" , @"621335" , @"433670" , @"433680" , @"442729" , @"442730" , @"620082" , @"622690" , @"622691" , @"622692" , @"622696" , @"622698" , @"622998" , @"622999" , @"433671" , @"968807" , @"968808" , @"968809" , @"621771" , @"621767" , @"621768" , @"621770" , @"621772" , @"621773" , @"620527" , @"356837" , @"356838" , @"486497" , @"622660" , @"622662" , @"622663" , @"622664" , @"622665" , @"622666" , @"622667" , @"622669" , @"622670" , @"622671" , @"622672" , @"622668" , @"622661" , @"622674" , @"622673" , @"620518" , @"621489" , @"621492" , @"620535" , @"623156" , @"621490" , @"621491" , @"620085" , @"623155" , @"623157" , @"623158" , @"623159" , @"999999" , @"621222" , @"623020" , @"623021" , @"623022" , @"623023" , @"622630" , @"622631" , @"622632" , @"622633" , @"622615" , @"622616" , @"622618" , @"622622" , @"622617" , @"622619" , @"415599" , @"421393" , @"421865" , @"427570" , @"427571" , @"472067" , @"472068" , @"622620" , @"621691" , @"545392" , @"545393" , @"545431" , @"545447" , @"356859" , @"356857" , @"407405" , @"421869" , @"421870" , @"421871" , @"512466" , @"356856" , @"528948" , @"552288" , @"622600" , @"622601" , @"622602" , @"517636" , @"622621" , @"628258" , @"556610" , @"622603" , @"464580" , @"464581" , @"523952" , @"545217" , @"553161" , @"356858" , @"622623" , @"625911" , @"377152" , @"377153" , @"377158" , @"377155" , @"625912" , @"625913" , @"356885" , @"356886" , @"356887" , @"356888" , @"356890" , @"402658" , @"410062" , @"439188" , @"439227" , @"468203" , @"479228" , @"479229" , @"512425" , @"521302" , @"524011" , @"356889" , @"545620" , @"545621" , @"545947" , @"545948" , @"552534" , @"552587" , @"622575" , @"622576" , @"622577" , @"622579" , @"622580" , @"545619" , @"622581" , @"622582" , @"622588" , @"622598" , @"622609" , @"690755" , @"690755" , @"545623" , @"621286" , @"620520" , @"621483" , @"621485" , @"621486" , @"628290" , @"622578" , @"370285" , @"370286" , @"370287" , @"370289" , @"439225" , @"518710" , @"518718" , @"628362" , @"439226" , @"628262" , @"625802" , @"625803" , @"621299" , @"966666" , @"622909" , @"622908" , @"438588" , @"438589" , @"461982" , @"486493" , @"486494" , @"486861" , @"523036" , @"451289" , @"527414" , @"528057" , @"622901" , @"622902" , @"622922" , @"628212" , @"451290" , @"524070" , @"625084" , @"625085" , @"625086" , @"625087" , @"548738" , @"549633" , @"552398" , @"625082" , @"625083" , @"625960" , @"625961" , @"625962" , @"625963" , @"356851" , @"356852" , @"404738" , @"404739" , @"456418" , @"498451" , @"515672" , @"356850" , @"517650" , @"525998" , @"622177" , @"622277" , @"622516" , @"622517" , @"622518" , @"622520" , @"622521" , @"622522" , @"622523" , @"628222" , @"628221" , @"984301" , @"984303" , @"622176" , @"622276" , @"622228" , @"621352" , @"621351" , @"621390" , @"621792" , @"625957" , @"625958" , @"621791" , @"620530" , @"625993" , @"622519" , @"621793" , @"621795" , @"621796" , @"622500" , @"623078" , @"622384" , @"940034" , @"940015" , @"622886" , @"622391" , @"940072" , @"622359" , @"940066" , @"622857" , @"940065" , @"621019" , @"622309" , @"621268" , @"622884" , @"621453" , @"622684" , @"621016" , @"621015" , @"622950" , @"622951" , @"621072" , @"623183" , @"623185" , @"621005" , @"622172" , @"622985" , @"622987" , @"622267" , @"622278" , @"622279" , @"622468" , @"622892" , @"940021" , @"621050" , @"620522" , @"356827" , @"356828" , @"356830" , @"402673" , @"402674" , @"438600" , @"486466" , @"519498" , @"520131" , @"524031" , @"548838" , @"622148" , @"622149" , @"622268" , @"356829" , @"622300" , @"628230" , @"622269" , @"625099" , @"625953" , @"625350" , @"625351" , @"625352" , @"519961" , @"625839" , @"421317" , @"602969" , @"621030" , @"621420" , @"621468" , @"623111" , @"422160" , @"422161" , @"622865" , @"940012" , @"623131" , @"622178" , @"622179" , @"628358" , @"622394" , @"940025" , @"621279" , @"622281" , @"622316" , @"940022" , @"621418" , @"512431" , @"520194" , @"621626" , @"623058" , @"602907" , @"622986" , @"622989" , @"622298" , @"622338" , @"940032" , @"623205" , @"621977" , @"990027" , @"622325" , @"623029" , @"623105" , @"621244" , @"623081" , @"623108" , @"566666" , @"622455" , @"940039" , @"622466" , @"628285" , @"622420" , @"940041" , @"623118" , @"603708" , @"622993" , @"623070" , @"623069" , @"623172" , @"623173" , @"622383" , @"622385" , @"628299" , @"603506" , @"603367" , @"622878" , @"623061" , @"623209" , @"628242" , @"622595" , @"622303" , @"622305" , @"621259" , @"622596" , @"622333" , @"940050" , @"621439" , @"623010" , @"621751" , @"628278" , @"625502" , @"625503" , @"625135" , @"622476" , @"621754" , @"622143" , @"940001" , @"623026" , @"623086" , @"628291" , @"621532" , @"621482" , @"622135" , @"622152" , @"622153" , @"622154" , @"622996" , @"622997" , @"940027" , @"623099" , @"623007" , @"940055" , @"622397" , @"622398" , @"940054" , @"622331" , @"622426" , @"625995" , @"621452" , @"628205" , @"628214" , @"625529" , @"622428" , @"621529" , @"622429" , @"621417" , @"623089" , @"623200" , @"940057" , @"622311" , @"623119" , @"622877" , @"622879" , @"621775" , @"623203" , @"603601" , @"622137" , @"622327" , @"622340" , @"622366" , @"622134" , @"940018" , @"623016" , @"623096" , @"940049" , @"622425" , @"622425" , @"621577" , @"622485" , @"623098" , @"628329" , @"621538" , @"940006" , @"621269" , @"622275" , @"621216" , @"622465" , @"940031" , @"621252" , @"622146" , @"940061" , @"621419" , @"623170" , @"622440" , @"940047" , @"940017" , @"622418" , @"623077" , @"622413" , @"940002" , @"623188" , @"622310" , @"940068" , @"622321" , @"625001" , @"622427" , @"940069" , @"623039" , @"628273" , @"622370" , @"683970" , @"940074" , @"621437" , @"628319" , @"990871" , @"622308" , @"621415" , @"623166" , @"622132" , @"621340" , @"621341" , @"622140" , @"623073" , @"622147" , @"621633" , @"622301" , @"623171" , @"621422" , @"622335" , @"622336" , @"622165" , @"622315" , @"628295" , @"625950" , @"621760" , @"622337" , @"622411" , @"623102" , @"622342" , @"623048" , @"622367" , @"622392" , @"623085" , @"622395" , @"622441" , @"622448" , @"621413" , @"622856" , @"621037" , @"621097" , @"621588" , @"623032" , @"622644" , @"623518" , @"622870" , @"622866" , @"623072" , @"622897" , @"628279" , @"622864" , @"621403" , @"622561" , @"622562" , @"622563" , @"622167" , @"622777" , @"621497" , @"622868" , @"622899" , @"628255" , @"625988" , @"622566" , @"622567" , @"622625" , @"622626" , @"625946" , @"628200" , @"621076" , @"504923" , @"622173" , @"622422" , @"622447" , @"622131" , @"940076" , @"621579" , @"622876" , @"622873" , @"622962" , @"622936" , @"623060" , @"622937" , @"623101" , @"621460" , @"622939" , @"622960" , @"623523" , @"621591" , @"622961" , @"628210" , @"622283" , @"625902" , @"621010" , @"622980" , @"623135" , @"621726" , @"621088" , @"620517" , @"622740" , @"625036" , @"621014" , @"621004" , @"622972" , @"623196" , @"621028" , @"623083" , @"628250" , @"623121" , @"621070" , @"628253" , @"622979" , @"621035" , @"621038" , @"621086" , @"621498" , @"621296" , @"621448" , @"622945" , @"621755" , @"622940" , @"623120" , @"628355" , @"621089" , @"623161" , @"628339" , @"621074" , @"621515" , @"623030" , @"621345" , @"621090" , @"623178" , @"621091" , @"623168" , @"621057" , @"623199" , @"621075" , @"623037" , @"628303" , @"621233" , @"621235" , @"621223" , @"621780" , @"621221" , @"623138" , @"628389" , @"621239" , @"623068" , @"621271" , @"628315" , @"621272" , @"621738" , @"621273" , @"623079" , @"621263" , @"621325" , @"623084" , @"621327" , @"621753" , @"628331" , @"623160" , @"621366" , @"621388" , @"621348" , @"621359" , @"621360" , @"621217" , @"622959" , @"621270" , @"622396" , @"622511" , @"623076" , @"621391" , @"621339" , @"621469" , @"621625" , @"623688" , @"623113" , @"621601" , @"621655" , @"621636" , @"623182" , @"623087" , @"621696" , @"622955" , @"622478" , @"940013" , @"621495" , @"621688" , @"623162" , @"622462" , @"628272" , @"625101" , @"622323" , @"623071" , @"603694" , @"622128" , @"622129" , @"623035" , @"623186" , @"621522" , @"622271" , @"940037" , @"940038" , @"985262" , @"622322" , @"628381" , @"622481" , @"622341" , @"940058" , @"623115" , @"621258" , @"621465" , @"621528" , @"622328" , @"940062" , @"625288" , @"623038" , @"625888" , @"622332" , @"940063" , @"623123" , @"622138" , @"621066" , @"621560" , @"621068" , @"620088" , @"621067" , @"622531" , @"622329" , @"623103" , @"622339" , @"620500" , @"621024" , @"622289" , @"622389" , @"628300" , @"625516" , @"621516" , @"622859" , @"622869" , @"623075" , @"622895" , @"623125" , @"622947" , @"621561" , @"623095" , @"621073" , @"623109" , @"621361" , @"623033" , @"623207" , @"622891" , @"621363" , @"623189" , @"623510" , @"622995" , @"621053" , @"621230" , @"621229" , @"622218" , @"628267" , @"621392" , @"621481" , @"621310" , @"621396" , @"623251" , @"628351"];
    
    
    
    int index = -1;
    
    
    
    if(bankNumber==nil || bankNumber.length<16 || bankNumber.length>19){
        
        return @"";
        
    }
    
    
    
    //6位Bin号
    
    NSString* cardbin_6 = [bankNumber substringWithRange:NSMakeRange(0, 6)];
    
    
    
    for (int i = 0; i < bankBin.count; i++) {
        
        
        
        if ([cardbin_6 isEqualToString:bankBin[i]]) {
            
            index = i;
            
        }
        
        
        
    }
    
    
    
    if (index != -1) {
        
        return bankName[index];
        
    }
    
    
    
    //8位Bin号
    
    NSString* cardbin_8 = [bankNumber substringWithRange:NSMakeRange(0, 8)];
    
    
    
    for (int i = 0; i < bankBin.count; i++) {
        
        
        
        if ([cardbin_8 isEqualToString:bankBin[i]]) {
            
            index = i;
            
        }
        
        
        
    }
    
    
    
    if (index != -1) {
        
        return bankName[index];
        
    }
    
    
    
    return @"";
    
    
    
}
@end
