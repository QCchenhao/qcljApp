//
//  QiCaiNewViewController.m
//  七彩乐居
//
//  Created by 李大娟 on 16/2/29.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QiCaiNewViewController.h"
#import "Comment.h"
#import "QiCaiTabBarController.h"

#define kImageMaxCount 3

@interface QiCaiNewViewController ()<UIScrollViewDelegate,UITabBarControllerDelegate>

@property (weak,nonatomic) UIPageControl *pageControll;

@end

@implementation QiCaiNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    
    
//    UIImageView * figureurl_qq_2 = [[UIImageView alloc]init];
//        figureurl_qq_2.image = [UIImage imageNamed:@"Member_me_user_ placeholder"];
    
//     [figureurl_qq_2 imageToNamed:@"Member_me_user_ placeholder"];
     //本地保存
//     [UIImageView SaveImageToLocal:figureurl_qq_2.image Keys:@"userImageData"];
    
    [self setupScrollView];
    [self setupPageControl];

    
}

-(void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(kImageMaxCount * self.view.width, 0);

    for (int i = 0; i < kImageMaxCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:scrollView.frame];
        imageView.userInteractionEnabled = YES;
        imageView.x = i * scrollView.width;
        
       NSString *name = [NSString stringWithFormat:@"page%d",i +1];

        imageView.image = [UIImage imageNamed:name];
        
        if (i == kImageMaxCount - 1) {
            [self setupLastImageView:imageView];
        }
        
        [scrollView addSubview:imageView];
    }
    
        [self.view addSubview:scrollView];
    
    
}

-(void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.centerX = self.view.width * 0.5;
    pageControl.y = self.view.height - 30;
    pageControl.numberOfPages = kImageMaxCount;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = MYColor(246, 200, 219);
    [self.view addSubview:pageControl];
    self.pageControll = pageControl;
}

-(void)setupLastImageView:(UIImageView *)imageView
{
    [self setupStartBtn:imageView];
}

-(void)setupStartBtn:(UIImageView *)imageView
{
    UIButton *startBtn = [[UIButton alloc]init];
    startBtn.size = CGSizeMake(200, 30);
    startBtn.centerX = self.view.width * 0.5;
    startBtn.centerY = self.view.height * 0.87;
    
    [startBtn setTitle:@"开始进入" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.layer.cornerRadius = 15;
    startBtn.layer.borderWidth = 1;
    startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
//    [startBtn setBackgroundImage:[UIImage imageWithName:@"xuanfu_kuang"] forState:UIControlStateNormal];
//    [startBtn setBackgroundImage:[UIImage imageWithName:@"xuanfu_kuang"] forState:UIControlStateHighlighted];
    [startBtn addTarget:self action:@selector(clickStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
}



-(void)clickStartBtn:(UIButton *)startBtn
{
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    QiCaiTabBarController *tabBarVC = [[QiCaiTabBarController alloc]init];
    tabBarVC.delegate = (id)([UIApplication sharedApplication].delegate);
    window.rootViewController = tabBarVC;
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControll.currentPage = scrollView.contentOffset.x / scrollView.width + 0.5;
}

@end
