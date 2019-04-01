                                //
//  GaodePOIViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "GaodePOIViewController.h"

#import "Comment.h"

#import <MAMapKit/MAMapKit.h>

#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapSearchKit/AMapSearchKit.h>

#import <AMapLocationKit/AMapLocationKit.h>

#import "POIAnnotation.h"

#import "AmapTabeleController.h"

#define fanwei  50000
#define latitude1 39.916019
#define longitude1 116.521316

@interface GaodePOIViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) MAMapView * mapView;

//@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic,strong)AMapLocationManager * locManager;

@property (nonatomic,strong)AmapTabeleController * amapVC;

@property (nonatomic,strong)CHTextField * searchTextFile;
@property (nonatomic,copy)NSString * addessStr;

@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@end

@implementation GaodePOIViewController
//重写loadView 使键盘上移导航栏不随着上移
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (AmapTabeleController * )amapVC{
    if (!_amapVC) {
        _amapVC = [[AmapTabeleController alloc]init];
        _amapVC.title = @"全部订单";
        [self addChildViewController:_amapVC];
        _amapVC.view.frame = CGRectMake(0, 200, self.view.width, 300);
        [self.view addSubview:_amapVC.view];
        
    }
    return _amapVC;
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
    
    self.navigationItem.title = @"添加服务地址";
    
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    [AMapServices sharedServices].apiKey = @"d4e29c2ba936dc6276fe62099d8a5aa7";
    
    ///初始化地图
    MAMapView * mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    mapView.frame = CGRectMake(0, 0, 340, 200);
    mapView.delegate = self;
    self.mapView = mapView;
    
    
    ///把地图添加至view
    [self.view addSubview:mapView];
    //设置追踪用户目前的位置（在_mapView创建的地方编写即可）
    mapView.showsUserLocation = YES;
    
    //直接跟随到用户目前的界面
    [mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    
    
//    //构造圆
//    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(latitude1, longitude1) radius:fanwei];
//    
//    //在地图上添加圆
//    [mapView addOverlay: circle];
    
    
    //POI 构造 AMapSearchAPI
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
//    //设置周边检索的参数
//    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
//    
//    request.location            = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude  longitude:self.coordinate.longitude];
//    //    request.keywords            = @"";
//    /* 按照距离排序. */
//    request.sortrule            = 0;
//    request.requireExtension    = YES;
//    request.radius              = fanwei;
//    request.types               = @"商务住宅|住宅区|住宅小区|大厦";
//    
//    //发起周边检索
//    [self.search AMapPOIAroundSearch:request];
    
    
    
//    
//    //设置坐标
//    CLLocationCoordinate2D coordinate = self.coordinate;
//    //设置缩放
//    MACoordinateSpan span = MACoordinateSpanMake(0.3, 0.3);
//    // 设置区域
//    MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
//    //显示区域
//    mapView.region = region;
    
    //定位
    // 带逆地理信息的一次定位（返回坐标和地址信息）
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
            NSLog(@"reGeocode:%@", regeocode);
        }
        
        //设置坐标
        CLLocationCoordinate2D coordinate = location.coordinate;
        self.coordinate = coordinate;
        //设置缩放
        MACoordinateSpan span = MACoordinateSpanMake(0.1, 0.1);
        // 设置区域
        MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
        //显示区域
        mapView.region = region;
        
        //搜索
        [self ChlieSearch];
    }];
    
    
    //    /**
    //     初始化高德地图
    //     */
    //    self.geocoder = [[CLGeocoder alloc]init];
    //    /* 下面会详述该方法 */
    //    //[self location];
    //    [self listPlacemark];
    
    //添加搜索框
    [self addSearch];


}
- (void)addSearch{
    //搜索view
    UIView * searchView = [[UIView alloc]init];
    searchView.frame = CGRectMake(10, 10, CGRectGetWidth(self.view.frame) - 20, 35);
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    //加阴影
    searchView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    searchView.layer.shadowOffset = CGSizeMake(2,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟
    searchView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    searchView.layer.shadowRadius = 4;//阴影半径，默认3
    
    CHTextField * searchTextFile = [CHTextField addCHTextFileWithLeftImage:@"address_search" frame:CGRectMake(0, 0, CGRectGetWidth(searchView.frame) * 0.7, CGRectGetHeight(searchView.frame)) placeholder:@"" placeholderLabelFont:12 placeholderTextColor:QiCaiShallowColor];
    
    searchTextFile.placeholder = @"请输入小区或者是大厦名称";
    searchTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    searchTextFile.CHDelegate = self;
    searchTextFile.layer.borderWidth = 0;
    _searchTextFile = searchTextFile;
    [searchView addSubview:searchTextFile];
    
    UIButton * SearchButton = [[UIButton alloc]init];
    SearchButton.frame = CGRectMake(CGRectGetMaxX(searchTextFile.frame) + 10 , 0 , 70, 35);
    [SearchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [SearchButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [SearchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [SearchButton addTarget:self action:@selector(ChlieSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    SearchButton.centerY = CGRectGetHeight(searchView.frame) / 2;
    [searchView addSubview:SearchButton];
    
    __weak __typeof(self)weakSelf = self;
    self.amapVC.AmapIndexBlock = ^(NSString * str){
        weakSelf.addessStr = str;
        NSLog(@"%@",weakSelf.addessStr);
    };
    
    //立即预定
    NSString * buttonStr ;
    if (self.adderssID) {
        buttonStr = @"确认修改";
    }else{
        buttonStr = @"确认添加";
    }
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:buttonStr rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickMaternityMatronSummit)];
    [self.view addSubview:maternityMatronsummitBtn];
}
- (void)clickMaternityMatronSummit{
    
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params addParamsClientTimeAndTokenTo:params];
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    if (self.addessStr.length > 0) {
       params[@"address"] = self.addessStr;
    }else{
        [CHMBProgressHUD showPrompt:@"地址添加失败"];
        return;
    }
    
    params[@"userId"] = userId;

    NSString * URLStr;
    
    if (self.adderssID) {//修改地址接口
        URLStr=  [NSString stringWithFormat:@"%@/addressAction.do?method=updateAddress",kQICAIHttp];
        params[@"addressId"] = self.adderssID;
    }else{//添加地址接口
        URLStr=  [NSString stringWithFormat:@"%@/addressAction.do?method=saveAddresses",kQICAIHttp];
    }
    
    if ([self.isHomeorder isEqualToString:@"200"]) {
        _GaodePOIBlock ? _GaodePOIBlock(_addessStr, _adderssID) : nil;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
            if ([responseObject[@"message"]  isEqual: @0]) //0 成功
            {

                _GaodePOIBlock ? _GaodePOIBlock(_addessStr, responseObject[@"id"]) : nil;
                [self.navigationController popViewControllerAnimated:YES];
                [MYUserDefaults setObject:_addessStr forKey:@"address"];
                [MYUserDefaults setObject:responseObject[@"id"] forKey:@"addressId"];
                [MYUserDefaults synchronize];


            }else if ([responseObject[@"message"]  isEqual: @4])//4重新登录
            {
                
            }else if ([responseObject[@"message"]  isEqual: @2]) {
                
                
            }
        } failure:nil];

    }
    
    
}
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth = 2.f;
        circleView.strokeColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.6 alpha:0.5];
        //        circleView.fillColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:0.5];
        circleView.fillColor = [UIColor clearColor];
        //        circleView.lineDash = YES;//YES表示虚线绘制，NO表示实线绘制
        
        return circleView;
    }
    return nil;
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    
    if (response.pois.count == 0)
    {
        //取消弹窗
        [CHMBProgressHUD hide];
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 移除地图上的大头针（标注）. */
    [self.mapView removeAnnotations:self.mapView.annotations];
    
//    /* 将结果以annotation的形式加载到地图上. */
//    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:YES];
    }
    
    [self.amapVC loadNewTopic:response.pois type:@"001"];
}
//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        //取消弹窗
        [CHMBProgressHUD hide];
        return;
    }
    AMapTip *obj   = response.tips[3];
    //设置坐标 CLLocation *location
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
    //设置缩放
    MACoordinateSpan span = MACoordinateSpanMake(0.1, 0.1);
    // 设置区域
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
    //显示区域
    self.mapView.region = region;
    
     [self.amapVC loadNewTopic:response.tips type:@"002"];
}
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
//        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:reuseIndetifier];
//        }
//        annotationView.image = [UIImage imageNamed:@"restaurant"];
//        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
//        return annotationView;
//    }
//    return nil;
//}

// 自定义大头针标注
- (MAAnnotationView *)mapView:(MAMapView *)mapView
            viewForAnnotation:(id<MAAnnotation>)annotation {
    // If the annotation is the user location, just return nil.（如果是显示用户位置的Annotation,则使用默认的蓝色圆点）
    if ([annotation isKindOfClass:[MAUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[POIAnnotation class]]) {
        // Try to dequeue an existing pin view first.（这里跟UITableView的重用差不多）
//        MAPinAnnotationView *customPinView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
//        if (!customPinView){
//            // If an existing pin view was not available, create one.
//            customPinView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
//        }
//        // 重新设置数据模型 (一定要记得!!!), 为了防止循环利用时, 数据混乱
//        customPinView.annotation = annotation;
//        
//        //iOS9中用pinTintColor代替了pinColor
//        customPinView.canShowCallout= YES; //设置气泡可以弹出，默认为NO// 设置大头针下落动画
//        customPinView.animatesDrop = YES; //设置标注动画显示，默认为NO
//        customPinView.draggable = YES; //设置标注可以拖动，默认为NO
//        customPinView.pinColor = MAPinAnnotationColorPurple;//设置大头针颜色
//        
////        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
////        rightButton.backgroundColor = [UIColor grayColor];
////        [rightButton setTitle:@"查看详情" forState:UIControlStateNormal];
////        customPinView.rightCalloutAccessoryView = rightButton;
//        
//        // Add a custom image to the left side of the callout.（设置弹出起泡的左面图片）
//        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LiuXSlider_on"]];
//        customPinView.leftCalloutAccessoryView = myCustomImage;
//        customPinView.image = [UIImage imageNamed:@"LiuXSlider_on"];
//        //        customPinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"LiuXSlider_on%ld",((MyCustomAnnotation*)annotation).idx]];
//        // 设置大头针显示图片(如果是系统的大头针视图, 那么就无法进行自定义)
////        customPinView.image = [UIImage imageNamed:@"category_1.png"];
////        customPinView.image = [UIImage imageNamed:@"list_order_tags_all_off"];
//        
//
//        return customPinView;
//        
//        //        //修改大头针图片
//        //        MAAnnotationView* aView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPointAnnotation"];
//        //        aView.image = [UIImage imageNamed:@"LiuXSlider_on"];
//        //        aView.canShowCallout = YES;
//        //        return aView;
    }
    
    return nil;//返回nil代表使用默认样式
}
//为了响应“查看详情”的点击事件，只要实现以下代理方法：
-(void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"点击了查看详情");
}
//搜索
- (void)ChlieSearch{

    //菊花
    [CHMBProgressHUD showProgress:nil];
    
    NSLog(@"搜索");
    //设置周边检索的参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
//    request.location            = [AMapGeoPoint locationWithLatitude:latitude1  longitude:longitude1];
        request.location            = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude  longitude:self.coordinate.longitude];
    request.keywords            = _searchTextFile.text;
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    request.radius              = fanwei;
//    request.types               = @"商务住宅|住宅区|住宅小区|大厦";
    
    //发起周边检索
    [self.search AMapPOIAroundSearch:request];
}
//
- (void)ChlieSearchBtn:(UIButton *)btn{
    //发起输入提示搜索
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    //关键字
    if (_searchTextFile.text.length > 0) {
        tipsRequest.keywords = _searchTextFile.text;
    }
    
    //城市
//    tipsRequest.city = _currentCity;
    
    //执行搜索
    [_search AMapInputTipsSearch: tipsRequest];
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
- (void)locationManager:(AMapLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
