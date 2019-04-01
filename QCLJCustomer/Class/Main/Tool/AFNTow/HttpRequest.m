//
//  HttpRequest.m
//  基于AFNetWorking的再封装
//
//  Created by 吴红星 on 16/1/2.
//  Copyright © 2016年 wuhongxing. All rights reserved.
//

#import "HttpRequest.h"

#import "AFNetworking.h"
#import "UploadParam.h"

#import "AppDelegate.h"
#import "Comment.h"

#import "NSMutableDictionary+Extension.h"//加密

//#import "UIViewController+CHNotNetController.h"//状态分类
//#import "CHNotInternetView.h"//状态页面
//#import "CHMBProgressHUD.h"

////项目里面访问AppDelegate做全局变量
//#define MYAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@implementation HttpRequest

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    // 位置网络
                    NSLog(@"位置网络");
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    // 无法联网
                    NSLog(@"无法联网");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    // 手机自带网络
                    NSLog(@"当前使用的是2G/3G/4G网络");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    // WIFI
                    NSLog(@"当前在WIFI网络下");
                }
            }
        }];
    });
    return _instance;
}

#pragma mark -- GET请求 --
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
//    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 30;
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- POST请求 --
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置请求超时的时间
    [manager.requestSerializer setTimeoutInterval:30.0];
    // 取消请求
    // 仅仅是取消请求, 不会关闭session
    [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
#pragma mark -- POST/GET网络请求 --
- (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    switch (type) {
        case HttpRequestTypeGet:
        {
            [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
    }
}

- (void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(NSArray<UploadParam *> *)uploadParams success:(void (^)())success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UploadParam *uploadParam in uploadParams) {
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 下载数据
- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)())progress success:(void (^)())success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress();
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
    [downLoadTask resume];
}

#pragma mark -- POST请求，封装全局的无网络界面 --
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters sss:(UIViewController *)VC
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置请求超时的时间
    [manager.requestSerializer setTimeoutInterval:30.0];
    // 取消请求
    // 仅仅是取消请求, 不会关闭session
    [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
- (void)post_Internet_general_getWithTarget:(nonnull UIViewController*)target tableView:(UITableView *)tableView modelArr:(NSMutableArray *)modelArr url:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
//    //取消弹窗
//    [CHMBProgressHUD hide];
    
    if(MYAppDelegate.isNetworkState == YES){// 没有网络
        //取消弹窗
        [CHMBProgressHUD hide];
        
        if (modelArr) {//如果有数组
            if(modelArr.count>0){// 如果已有数据，然后没有网络
                //给出提示
                [CHMBProgressHUD showPrompt:@"暂无网络"];
                return;
            }else{

                [target showNotInternetViewToAbnormalState:AbnormalStateNoNetwork message1:nil message2:nil];
            }
            if (tableView) {
                [tableView reloadData];
                [tableView.mj_header endRefreshing];
                [tableView.mj_footer endRefreshing];
                
            }
            
        }else{// 如果没数组，然后没有网络

            [CHMBProgressHUD showPrompt:@"暂无网络"];
        }
        
    }else{ // 有网络
        [target hiddenNotInternetView];
        
        //juhua
        [CHMBProgressHUD showProgress:nil];
        
        //加密
        [NSMutableDictionary addParamsClientTimeAndTokenTo:params];
        
        // 打印请求的路径和参数
         VDLog(@"%@\n%@",url,params);
        

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //设置请求超时的时间
        [manager.requestSerializer setTimeoutInterval:30.0];
        // 取消请求
        // 仅仅是取消请求, 不会关闭session
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];

        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //取消弹窗
            [CHMBProgressHUD hide];
            
            if (tableView) {
                [tableView.mj_header endRefreshing];
                [tableView.mj_footer endRefreshing];
            }
            
            VDLog(@"%@",responseObject);
            
            if (success) {
                success(responseObject);
            }
            [tableView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            VDLog(@"%@",error);
            
            //取消弹窗
            [CHMBProgressHUD hide];
            
            if (failure) {
                failure(error);
            }else{
            
                if (modelArr) {
                    [modelArr removeAllObjects];
                    
                    if (tableView) {
                        
                        [target showNotInternetViewToAbnormalState:AbnormalStateNoNetwork message1:nil message2:nil];
                    }
                }else{
                    [CHMBProgressHUD showFail:@"网络失败，请稍后再试"];
                }
            }
            
            if (tableView) {
                [tableView reloadData];
                [tableView.mj_header endRefreshing];
                [tableView.mj_footer endRefreshing];
                
            }

            
        }];

    }
   
}

@end
