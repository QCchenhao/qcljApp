//
//  PersonalInformationViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "Comment.h"
#import "ServiceAddressViewController.h"//地址

#import "HMDatePickView.h"//时间选择器
#import "CHAlertController.h"//封装系统弹窗
#import "QCUIImagePickerController.h"//重写相册改变按钮颜色

//#import "NSMutableDictionary+Extension.h"//加密
#import "MD5.h"

@interface PersonalInformationViewController()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PopDelegate>
@property (strong,nonatomic)  UITextField *nameTextField;
@property (strong,nonatomic) UIImageView *iconImageView;
@property (strong,nonatomic)  UITextField *phoneTextField;
@property (strong,nonatomic)  UIButton *addressBtn;
@property (strong,nonatomic)  UIButton *birthdayBtn;
@property(nonatomic,copy) NSString *addressId;
@property (assign, nonatomic)  BOOL  isShow;//服务时长弹窗显示

@property (strong,nonatomic) NSData *userImageData;//图片data
@end

@implementation PersonalInformationViewController

-(void)returnText:(ReturnMeNameBlock)block
{
    self.returnMeNameBlock = block;
}
//重写loadView 使键盘上移导航栏不随着上移
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QiCaiBackGroundColor;
    self.navigationItem.title = @"个人信息";
    UIBarButtonItem *queryBtnItem = [UIBarButtonItem addBarBtnItemWithTItle:@"保存" titleColor:[UIColor whiteColor] target:self action:@selector(clickTJBtn)];
    self.navigationItem.rightBarButtonItem = queryBtnItem;
    
    [self setupUI];
}
/**
 保存
 */
-(void)clickTJBtn
{
    [CHMBProgressHUD showPromptWithMessage:@"请小主确保信息无误后再提交" buttonArr:@[@"返回编辑",@"确定提交"]];
    [CHMBProgressHUD shareinstance].popDelegate = self;
}

-(void)PopButton:(UIButton *)PopButton
{
    VDLog(@"popView按钮个数===%ld",PopButton.tag);
    if (PopButton.tag == 0) {//返回编辑
        
    }else{
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *userId = [MYUserDefaults objectForKey:@"userId"];
        params[@"userId"]= userId ;
        
        NSLog(@"%@",self.birthdayBtn.titleLabel.text);
        
        if (self.birthdayBtn.titleLabel.text && ![self.birthdayBtn.titleLabel.text isEqualToString:@""] && ![self.birthdayBtn.titleLabel.text isEqualToString:@"default"] && ![self.birthdayBtn.titleLabel.text isEqualToString:@"请选择生日"]) {
            
            params[@"birthday"] = self.birthdayBtn.titleLabel.text;
            
        }else{

        }
        
        if (self.nameTextField.text) {
            
            params[@"name"]= self.nameTextField.text;
            
        }
        
        if (self.addressId) {
            
            params[@"addressId"]= self.addressId;
            
        }else
        {
            if ([MYUserDefaults objectForKey:@"addressId"]) {
                
                params[@"addressId"] = [MYUserDefaults objectForKey:@"addressId"];
                
            }else
            {
                
            }
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/memberAction.do?method=memberUpdate",kQICAIHttp];
        
        NSLog(@"%@",urlStr);
         NSLog(@"%@",params);
        
        [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:urlStr params:params success:^(id  _Nullable responseObject) {
            
            NSLog(@"%@",responseObject);
            
            if ([responseObject[@"message"]  isEqual: @0]) {
                
                [CHMBProgressHUD showSuccess:@"保存成功"];
                
                //重新覆盖掉原来的旧数据
                [MYUserDefaults setObject:self.nameTextField.text forKey:@"name"];
                [MYUserDefaults setObject:self.birthdayBtn.titleLabel.text forKey:@"birthday"];
                
                if (self.addressId) {
                    
                    [MYUserDefaults setObject:self.addressId forKey:@"addressId"];
                    [MYUserDefaults setObject:self.addressBtn.titleLabel.text forKey:@"address"];
                }
                [MYUserDefaults synchronize];
                
                //本地保存
                [UIImageView SaveImageToLocal:self.iconImageView.image Keys:@"userImageData"];
                
                if (_userImageData ) {
                    [self addUserImage];
                    
                    _userImageData = nil;
                }
                
            }else if ([responseObject[@"message"]  isEqual: @1])
            {
                [CHMBProgressHUD showMessage:@"重新登录"];
                
            }else if ([responseObject[@"message"]  isEqual: @2]) {
                
                VDLog(@"参数错误");
            }
        } failure:nil];
        
        
    }

    [[CHMBProgressHUD shareinstance].hud hide:YES];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.returnMeNameBlock != nil) {
        
        self.returnMeNameBlock([[UIImageView GetImageFromLocal:@"userImageData"] circleImage],[MYUserDefaults objectForKey:@"name"]);
    }
}
-(void)setupUI
{
    CGFloat MyInformationCellHeight = 40;
    
    UIView *bjView = [[UIView alloc]init];
    bjView.backgroundColor = [UIColor whiteColor];
    bjView.frame = CGRectMake(0, QiCaiMargin, MYScreenW, MyInformationCellHeight * 4 + 10);
    [self.view addSubview:bjView];
    
    CGFloat labelX = QiCaiMargin * 2;
    CGFloat labelW = 60;
    NSArray *arr = @[@"头像",@"手机号",@"常用地址",@"生日"];
    
    /**line
     */
    for (int i = 1;  i < 5; i ++) {
        
        UIView *lineView = [[UIView alloc]init];
        CGFloat lineY;
        CGFloat labelY;
        CGFloat labelH;
        CGFloat ArrowCenterY ;
        
        if (i == 1) {
            
             lineY = 50;
            labelY = 0;
            labelH = 50;
            ArrowCenterY = 25;
        }
        else
        {
            lineY = MyInformationCellHeight * i + 10;
            labelY = MyInformationCellHeight * (i - 1) + 10;
            labelH = MyInformationCellHeight;
            ArrowCenterY = MyInformationCellHeight * (i - 1) + MyInformationCellHeight / 2 + 10;

        }
        lineView.frame = CGRectMake(0, lineY, MYScreenW, 1);
        lineView.backgroundColor = QiCaiBackGroundColor;
        [bjView addSubview:lineView];
        
        //左边的label
        UILabel *iconLabelLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(labelX, labelY, labelW, labelH) text:arr[i - 1] textColor:QiCaiDeepColor backgroundColor:[UIColor clearColor] size:12 textAlignment:NSTextAlignmentLeft];
        [bjView addSubview:iconLabelLabel];
        
        //右边的尖尖的image
        UIImageView * arrowImageView = [[UIImageView alloc]init];
        arrowImageView.image =[UIImage imageNamed:@"main_icon_arrow"];
        arrowImageView.frame = CGRectMake( MYScreenW -  20, 15, 8, 15);
        arrowImageView.centerY = ArrowCenterY;
        [bjView addSubview:arrowImageView];
        
        //右边的控件
        CGFloat textFieldX = CGRectGetMaxX(iconLabelLabel.frame) + QiCaiMargin;
        
        if (i == 1) {//姓名  头像
            
            UITextField *nameTextField = [UITextField addTextFieldWithFrame:CGRectMake(MYScreenW - 130, labelY, 60, labelH) textFieldDelegate:self contentView:bjView textFieldFont:QiCai10PFFont backGroundColor:[UIColor clearColor] attributedPlaceholder:@"请输入姓名" palceHolderTitleColor:QiCaiShallowColor textFieldBorderColor:[UIColor clearColor] borderWidth:0];
            nameTextField.textAlignment = NSTextAlignmentLeft;
            self.nameTextField = nameTextField;
            [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            NSString *nameStr = [MYUserDefaults objectForKey:@"name"];
            if (nameStr && ![nameStr isEqualToString:@"default"] && ![nameStr isEqualToString:@""]) {
                
//                nameStr = [MYUserDefaults objectForKey:@"name"];
                nameTextField.text = nameStr;
            }else
            {
                nameStr = @"请输入姓名";
                nameTextField.placeholder = nameStr;
            }
            
            //头像
            UIImageView *imageView = [[UIImageView alloc]init];
            self.iconImageView = imageView;
            imageView.frame = CGRectMake(MYScreenW - 70, 5, 40,40);
            imageView.layer.cornerRadius = 20;
            imageView.layer.masksToBounds = YES;
            if ([UIImageView LocalHaveImage:@"userImageData" ]) {
                imageView.image = [[UIImageView GetImageFromLocal:@"userImageData"] circleImage];
            }else{
                imageView.image = [UIImage imageNamed:@"me_personal_information"];
            }
            
            //添加手势
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickphotoBtn)];
            tapGesture.numberOfTouchesRequired = 1;
            [imageView addGestureRecognizer:tapGesture];
            [bjView addSubview:imageView];
            
            //右边的尖尖
            UIButton *btn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 70, 5, 70,40)image:nil highImage:nil backgroundColor:[UIColor clearColor] Target:self action:@selector(clickphotoBtn)];
            [bjView addSubview:btn];
    
        }else if (i == 2)//手机号
        {
            self.phoneTextField = [UITextField addTextFieldWithFrame:CGRectMake(textFieldX, labelY, MYScreenW - textFieldX - 30, labelH) textFieldDelegate:self contentView:bjView textFieldFont:QiCai10PFFont backGroundColor:[UIColor clearColor] attributedPlaceholder:@"请输入手机号" palceHolderTitleColor:QiCaiShallowColor textFieldBorderColor:[UIColor clearColor] borderWidth:0];
            self.phoneTextField.returnKeyType = UIReturnKeyDone;
            self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;//没有小数点的数字键盘
            self.phoneTextField.textAlignment = NSTextAlignmentRight;
            self.phoneTextField = self.phoneTextField;
            if ([MYUserDefaults objectForKey:@"mob"]) {
                self.phoneTextField.text = [MYUserDefaults objectForKey:@"mob"];
                self.phoneTextField.userInteractionEnabled = NO;//禁止编辑
            }

        }else if (i == 3)//地址
        {
            self.addressBtn = [UIButton addButtonWithFrame:CGRectMake(textFieldX, labelY, MYScreenW - textFieldX - 30, labelH) title:@"请选择地址" backgroundColor:[UIColor clearColor] titleColor:QiCaiShallowColor font:QiCai10PFFont Target:self action:@selector(clickAddressBtn)];
            self.addressBtn.titleLabel.numberOfLines = 0;
            [self.addressBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];           
            [bjView addSubview:self.addressBtn];
            
            if ([MYUserDefaults objectForKey:@"address"] && ![[MYUserDefaults objectForKey:@"address"] isEqualToString:@""] && ![[MYUserDefaults objectForKey:@"address"] isEqualToString:@"default"] ) {
                
                [self.addressBtn setTitle:[MYUserDefaults objectForKey:@"address"] forState:UIControlStateNormal];
            }
            
        }else if (i ==4)
        {
            self.birthdayBtn = [UIButton addButtonWithFrame:CGRectMake(textFieldX, labelY, MYScreenW - textFieldX - 30, labelH) title:@"请选择生日" backgroundColor:[UIColor clearColor] titleColor:QiCaiShallowColor font:QiCai10PFFont Target:self action:@selector(clickBirthdayBtn)];
            self.birthdayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [bjView addSubview:self.birthdayBtn];
            
            if ([MYUserDefaults objectForKey:@"birthday"] && ![[MYUserDefaults objectForKey:@"birthday"] isEqualToString:@""] && ![[MYUserDefaults objectForKey:@"birthday"] isEqualToString:@"default"]) {
                
                [self.birthdayBtn setTitle:[MYUserDefaults objectForKey:@"birthday"] forState:UIControlStateNormal];
            }

        }
        
    }
    
    UIButton *bcBtn = [UIButton addZhuFuBtnWithTitle:@"保存" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - QiCaiNavHeight, MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickTJBtn)];
    [self.view addSubview:bcBtn];
}

#pragma mark 限制输入文字长度
//限制输入文字长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameTextField) {/**姓名，限制输入为汉字英文**/
        NSString *toBeString = textField.text;
        
        NSString *lang = [textField.textInputMode primaryLanguage];
        
        if([lang isEqualToString:@"zh-Hans"]){ //简体中文输入，包括简体拼音，健体五笔，简体手写
            
            UITextRange *selectedRange = [textField markedTextRange];
            
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            if (!position){//非高亮
                
                if (toBeString.length > 4) {
                    
                    textField.text = [toBeString substringToIndex:4];
                    
                }
                
            }
            
        }else{//中文输入法以外
            
            if (toBeString.length > 4) {
                
                
            }
            
        }
    }
}

/*
 可以得到用户输入的字符
 */
#pragma mark 限制输入字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    
    if (textField == self.nameTextField) {
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"➋➌➍➎➏➐➑➒\n"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(basicTest || [NSString checkUserName:string])
        {
            return YES;
        }else{
            return NO;
        }
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
    
    
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    
    //这对于想要加入撤销选项的应用程序特别有用
    
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    
    //要防止文字被改变可以返回NO
    
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    
}
/**
 地址
 */
-(void)clickAddressBtn
{
    ServiceAddressViewController *serviceAddressVC = [[ServiceAddressViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    [serviceAddressVC returnAddText:^(NSString * address , NSString * adderssID) {
        [_addressBtn setTitle:address forState:UIControlStateNormal];
        weakSelf.addressId = adderssID;
    }];
    [self.navigationController pushViewController:serviceAddressVC animated:YES];
}
/**
 生日
 */
-(void)clickBirthdayBtn
{
    self.isShow = NO;
    
    /** 自定义日期选择器 */
    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.view.frame];
    //距离当前日期的年份差（设置最大可选日期）
    datePickVC.maxYear = 0;
    //设置最小可选日期(年分差)
    datePickVC.minYear = 130;
    datePickVC.date = [NSDate date];
    //设置字体颜色
    datePickVC.fontColor =  QiCaiNavBackGroundColor;
    //日期回调
    datePickVC.completeBlock = ^(NSString *selectDate) {
        [self.birthdayBtn setTitle:selectDate forState:UIControlStateNormal];
//        [self.birthdayBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
//                                      imageTitleSpace:13];
    };
    //配置属性
    [datePickVC configuration];
    
    [self.view addSubview:datePickVC];
}
/**
 头像
 */
-(void)clickphotoBtn
{
    
    [CHAlertController CHAlertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet CallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
        }
        else if (buttonIndex == 1)
        {
            //打开相机
            [self camera];
        }else{
            //打开相册
            [self picture];
        }

    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];

}
/**
 上传头像
 */
- (void)addUserImage{
    
    //上传头像
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    
    NSString *URL = [NSString stringWithFormat:@"%@/headImageAction.do?method=uploadHeadImage&userId=%@",kQICAIHttp,userId];
    NSLog(@"%@",URL);
    //    UIImage * image = self.imageView.image;
    //上传的图片转化二进制
    NSData * imageData = _userImageData;
    
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *clientTime = [NSString stringWithFormat:@"%llu",theTime];
    //加密
    NSString *token = [MD5 md5:[NSString stringWithFormat:@"%@%@",MD5Password,clientTime]];;
    
    NSString * md5_url_Str = [NSString stringWithFormat:@"%@&clientTime=%@&token=%@",URL,clientTime,token];
    //加密
//    [NSMutableDictionary addParamsClientTimeAndTokenTo:params];
    
    //2.上传文件
    [manager POST:md5_url_Str parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传文件参数
        [formData appendPartWithFileData:imageData name:@"userHeadImage" fileName:@"userHeadImage.png" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf%%", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        if ([responseObject[@"message"] isEqual:@0]) {
            
//            [CHMBProgressHUD showSuccess:@"图片上传完成"];
            //本地保存
            [UIImageView SaveImageToLocal:self.iconImageView.image Keys:@"userImageData"];
            
        }else if ([responseObject[@"message"] isEqual:@502]) {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
        [CHMBProgressHUD showFail:@"网路失败，请稍后重试"];
        
    }];
    
    
}
//#pragma mark 限制输入文字长度
////限制输入文字长度
//- (void)textFieldDidChange:(UITextField *)textField
//{
//    if (textField == self.phoneTextField) {/**电话，手机**/
//        
//        if (textField.text.length > 11) {
//            textField.text = [textField.text substringToIndex:11];
//            //错误弹出提示
//            [CHMBProgressHUD showMessage:@"手机号只有十一位" afterDelayTime:2.0];
//
//            
//        }else if (textField.text.length == 11) {
//            if ([NSString checkTelNumber:textField.text]) {//手机格式判断
//                [textField resignFirstResponder];//正确收回键盘
//            }else{
//                //错误弹出提示
//                [CHMBProgressHUD showMessage:@"手机号格式不正确" afterDelayTime:2.0];
//            }
//        }
//    }
//
//}
/*
 结束编辑的时候调用
 */
#pragma mark 结束编辑的时候调用判断格式
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //收回键盘
    [textField resignFirstResponder];
    
    BOOL isMatch = false;
    if (textField == self.phoneTextField) {
        
        //判断输入手机号格式是否正确
        isMatch = [NSString checkTelNumber:textField.text];
        
        if (isMatch) {
            NSLog(@"匹配");
        }else{
            NSLog(@"手机号不匹配");
            [CHMBProgressHUD showMessage:@"手机号格式不正确"  afterDelayTime:2.0];
            
        }
    }else if ( textField == self.nameTextField){
//        textField.textAlignment = NSTextAlignmentRight;
    }
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if ( textField == self.nameTextField){
//        self.nameTextField.textAlignment = NSTextAlignmentLeft;
//    }
//}
/**打开相机
 */
-(void)camera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        UIAlertView *alertView = [[UIAlertView  alloc]initWithTitle:nil message:@"模拟器无法打开相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    QCUIImagePickerController *imagePC = [[QCUIImagePickerController alloc]init];
    imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePC.delegate = self;
    imagePC.allowsEditing = YES;
    [self presentViewController:imagePC animated:YES completion:nil];
}
/**
 打开相册
 */
-(void)picture
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    QCUIImagePickerController *imagePC = [[QCUIImagePickerController alloc]init];
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePC.delegate = self;
    imagePC.allowsEditing = YES;
    [self presentViewController:imagePC animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        image = [UIImage imageScale:image maxEdge:300];
        self.iconImageView.image = image;
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 0.001);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        _userImageData = data;
    }
    
    //关闭相册界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
