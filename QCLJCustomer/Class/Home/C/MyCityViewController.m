//
//  MyCityViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/25.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyCityViewController.h"
#import "Comment.h"
//#import "LocationViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>


@interface MyCityViewController()<UIScrollViewDelegate,AMapLocationManagerDelegate>
@property (strong, nonatomic)  UIButton *lastCityBtn;

@property (copy, nonatomic) NSString * cityStr;
@property (nonatomic,strong)AMapLocationManager * locManager;

@end

@implementation MyCityViewController
- (void)returnText:(ReturnMyCityBlock)block{
    self.returnMyCityBlock = block;
}
- (AMapLocationManager *)locManager
{
    if (!_locManager) {
        _locManager = [[AMapLocationManager alloc] init];
        _locManager.distanceFilter = 20;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locManager.delegate = self;
        //            [_locManager requestWhenInUseAuthorization];//使用的时候获取定位信息
        [_locManager stopUpdatingLocation];
    }
    return _locManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    [self setUpUI];
    
}

-(void)setUpUI
{
    [self setupNav];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, MYScreenW, MYScreenH - 54)];
    scrollView.delegate = self;
    scrollView.backgroundColor = QiCaiBackGroundColor;
    [self.view addSubview:scrollView];
    
//     NSArray *arr = @[@"北京",@"天津",@"石家庄",@"邢台",@"宿迁",@"江阴",@"淮安",@"永城",@"邓州",@"郑州",@"烟台",@"莱州",@"寿光",@"莱芜",@"聊城",@"鞍山",@"营口", @"沈阳",@"盘锦",@"朔州",@"西双版纳",@"长春",@"松原",@"南昌",@"呼和浩特",@"南宁",@"伊宁",@"长沙"];
    NSArray *arr = @[@"北京市"];
    
    int btnCol = 3;
//    NSUInteger row = arr.count / btnCol;
    
    //定位的city
    UILabel * locationLabel = [[UILabel alloc]init];
    locationLabel.text = @"定位城市";
    locationLabel.textColor = QiCaiDeepColor;
    locationLabel.font = QiCaiDetailTitle10Font;
    locationLabel.textAlignment = NSTextAlignmentLeft;
    locationLabel.frame = CGRectMake(QiCaiMargin * 2, QiCaiMargin, MYScreenW, 30);
    [scrollView addSubview:locationLabel];
    
    //开通的城市
    UIButton *currentCityBtn = [[UIButton alloc]init];
    currentCityBtn.frame = CGRectMake(QiCaiMargin * 2, QiCaiMargin + CGRectGetMaxY(locationLabel.frame) , (MYScreenW - 6 * QiCaiMargin) / 3, 30);
    currentCityBtn.tag = 100;
    [currentCityBtn setTitle:@"定位中" forState:UIControlStateNormal];
    [currentCityBtn setTitleColor:QiCaiDeepColor forState:UIControlStateNormal];
    [currentCityBtn setTitleColor:QiCaiNavBackGroundColor forState:UIControlStateSelected];
    currentCityBtn.titleLabel.font = QiCaiDetailTitle12Font;
    [currentCityBtn addTarget:self action:@selector(cityMenuDidClickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    currentCityBtn.layer.borderWidth = 0.5;
//    currentCityBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    currentCityBtn.layer.cornerRadius = 5;
    [currentCityBtn setBackgroundImage:[UIImage imageWithName:@"home_radio_off"] forState:UIControlStateNormal];
    [currentCityBtn setBackgroundImage:[UIImage imageWithName:@"home_radio_on"] forState:UIControlStateSelected];
    
    //定位
    [self setLocManagersuccess:^(AMapLocationReGeocode *success) {
        [currentCityBtn setTitle:success.province forState:UIControlStateNormal];
        
    }];
    
    [scrollView addSubview:currentCityBtn];
    
    //目前开通的city
    UILabel *cityLabel = [[UILabel alloc]init];
    cityLabel.text = @"目前开通的城市";
    cityLabel.textColor = QiCaiDeepColor;
    cityLabel.font = QiCaiDetailTitle10Font;
    cityLabel.textAlignment = NSTextAlignmentLeft;
    cityLabel.frame = CGRectMake(QiCaiMargin * 2, QiCaiMargin + CGRectGetMaxY(currentCityBtn.frame), MYScreenW, 40);
    [scrollView addSubview:cityLabel];
    
    CGFloat btnW = (MYScreenW - 6 * QiCaiMargin) / 3;
    CGFloat btnH = 30;
    CGFloat btnX = QiCaiMargin * 2;
    CGFloat btnY = QiCaiMargin + CGRectGetMaxY(cityLabel.frame);
    
    for (int i = 0; i < arr.count; i ++) {
        
        NSString *cityName = arr[i];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:cityName forState:UIControlStateNormal];
        [btn setTitleColor:QiCaiDeepColor forState:UIControlStateNormal];
        [btn setTitleColor:QiCaiNavBackGroundColor forState:UIControlStateSelected];
        [btn setTitleColor:QiCaiNavBackGroundColor forState:UIControlStateSelected];
        btn.titleLabel.font = QiCaiDetailTitle12Font;
        [btn addTarget:self action:@selector(cityMenuDidClickBtn:) forControlEvents:UIControlEventTouchUpInside];
//        btn.layer.borderWidth = 0.5;
//        btn.layer.borderColor = [UIColor grayColor].CGColor;
//        btn.layer.cornerRadius = 5;
        [btn setBackgroundImage:[UIImage imageWithName:@"home_radio_off"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithName:@"home_radio_on"] forState:UIControlStateSelected];
        
        [scrollView addSubview:btn];
        
        btn.tag = i;
        
        if (self.cityHomeStr) {
            if ([self.cityHomeStr isEqualToString:arr[i]]) {
                btn.selected = YES;
                btn.layer.borderColor = QiCaiNavBackGroundColor.CGColor;
                self.lastCityBtn.selected = NO;
                self.lastCityBtn.layer.borderColor = [UIColor grayColor].CGColor;
                self.lastCityBtn = btn;
                self.cityStr = btn.titleLabel.text;
            }else{
                if (btn.tag == 0) {
                    btn.selected = YES;
                    btn.layer.borderColor = QiCaiNavBackGroundColor.CGColor;
                    self.lastCityBtn = btn;
                    self.cityStr = btn.titleLabel.text;
                }

            }
        }else{
            if (btn.tag == 0) {
                btn.selected = YES;
                btn.layer.borderColor = QiCaiNavBackGroundColor.CGColor;
                self.lastCityBtn = btn;
                self.cityStr = btn.titleLabel.text;
            }

        }
        int row = i / btnCol;
        int col = i % btnCol;
        
        CGFloat btnx;
        CGFloat btny;
        
        btny = btnY + row * (btnH + QiCaiMargin);
        btnx = btnX + col * (btnW + QiCaiMargin);
        
        btn.frame = CGRectMake(btnx, btny, btnW, btnH);
    }
    
    scrollView.contentSize = CGSizeMake(0, MYScreenH + QiCaiMargin);
    
}

//-(void)clickCurrentBtn:(UIButton *)btn
//{
//    
//}
-(void)cityMenuDidClickBtn:(UIButton *)btn
{
    if (btn == self.lastCityBtn) {
//        [self.leftBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
//        self.currentCityName = btn.titleLabel.text;
//        self.cityView.hidden = YES;
        self.cityStr = btn.titleLabel.text;
    }else{
        btn.selected = YES;
        btn.layer.borderColor = QiCaiNavBackGroundColor.CGColor;
        self.lastCityBtn.selected = NO;
        self.lastCityBtn.layer.borderColor = [UIColor grayColor].CGColor;
        self.lastCityBtn = btn;
        self.cityStr = btn.titleLabel.text;
//        [self.leftBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
//        self.currentCityName = btn.titleLabel.text;
        
    }
    
    if (btn.tag == 100) {
        //定位
        [self setLocManagersuccess:^(AMapLocationReGeocode *success) {
            [btn setTitle:success.province forState:UIControlStateNormal];
        }];
    }else{

    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)setupNav
{
    //nav
    UIView *navView = [[UIView alloc]init];
    navView.frame = CGRectMake(0, 0, MYScreenW, 54);
    navView.backgroundColor = QiCaiNavBackGroundColor;
    [self.view addSubview:navView];
    
    //leftBtn
    UIButton *leftBtn = [UIButton addButtonWithFrame:CGRectMake(10, 20, 30, 30) image:@"home_city_close" highImage:@"home_city_close" backgroundColor:nil Target:self action:@selector(back)];
    [navView addSubview:leftBtn];
    
    //centerLabel
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = QiCaiNavTitle14Font;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"城市选择";
    titleLabel.frame = CGRectMake(70, 23,MYScreenW - 140 , 30);
    titleLabel.centerX = navView.centerX;
    [navView addSubview:titleLabel];
 
}
- (void)setLocManagersuccess:(void (^)(AMapLocationReGeocode * success))success{
    
    [self.locManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode.province);
        }
        
        
        if (success) {
            success(regeocode);
            self.cityStr = regeocode.province;
        }
       
    }];

}
#pragma mark - CLLocationMangerDelegate methods
/**
 *  授权状态发生改变时调用
 */
- (void)locationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locManager startUpdatingLocation];
    }
}

-(void)back
{
    if ([self.cityStr isEqualToString:@"定位中"] || [self.cityStr isEqualToString:@""]) {
        self.cityStr = @"北京市";
    }
    if (self.returnMyCityBlock != nil) {
        self.returnMyCityBlock(self.cityStr);
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
