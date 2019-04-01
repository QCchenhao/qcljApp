//
//  QCSKStoreProductViewViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/17.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QCSKStoreProductViewViewController.h"

@interface QCSKStoreProductViewViewController ()

@end

@implementation QCSKStoreProductViewViewController
#pragma mark status bar style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark navigationBar tintColor & title textColor
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                     NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14]
                                                     }];
    }

    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
