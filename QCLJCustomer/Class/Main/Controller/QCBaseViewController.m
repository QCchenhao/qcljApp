//
//  QCBaseViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/15.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QCBaseViewController.h"
#import "Comment.h"
#import "ShareView.h"
#import <TencentOpenAPI/TencentOAuth.h>//qq分享
#import "TencentOpenAPI/QQApiInterface.h"
#import "WXApi.h"// wechat分享

//
/**
 用于分享的资料
 */
#define kAppStoreNsstring @"https://itunes.apple.com/us/app/qi-cai-le-ju/id1116052001"
#define kAppStoreTitle  @"七彩乐居"
#define kAppStoreDescription @"全国30个城市、超100万家庭的选择、好评率高达98%，七彩乐居4000-999-001"
#define kAppStoreImageNsstring @"http://www.bjleju.com/qcljlogo.png"


@interface QCBaseViewController()<ShareViewDelegate,TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    
}

@end
@implementation QCBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:kQQAppId andDelegate:self];

}


/**
 导航栏右边的分享
 */
-(void)clickShareBtn
{
    VDLog(@"分享");
    
    ShareView *shareView = [[ShareView alloc]init];
    shareView.sharedelegate = self;
    [shareView showShareView];
}
#pragma mark - ShareViewDelegate
-(void)shareViewDidClickShareView:(ShareView *)shareView selBtn:(ShareViewType)shareType
{
    NSLog(@"%ld",shareType);
    switch (shareType) {
        case ShareViewQQ:
            [self sendGoToQQ];
            break;
        case ShareViewQZone:
            [self sendGoToQZone];
            break;
        case ShareViewWeiXin:
            [self sendGoToWeiXin];
            break;
        case ShareViewWeiXinFriend:
            [self sendGoToWeiXinFriend];
            break;
            
        default:
            break;
    }
}
/**
 分享到QQ
 */
-(void)sendGoToQQ
{
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL :[NSURL URLWithString:kAppStoreNsstring] title:kAppStoreTitle description:kAppStoreDescription previewImageURL:nil];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    [self handleSendResult:sent];
}
/**
 分享到QZone
 */
-(void)sendGoToQZone
{
    NSURL *previewURL = [NSURL URLWithString:kAppStoreImageNsstring];
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:kAppStoreNsstring] title:kAppStoreTitle description:kAppStoreDescription previewImageURL:previewURL];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    [self handleSendResult:sent];
}
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    NSString *message = nil;
    
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            message = @"App未注册";
            [CHMBProgressHUD showMessage:message];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            message = @"发送参数错误";
            [CHMBProgressHUD showMessage:message];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            message = @"未安装手机QQ";
            [CHMBProgressHUD showMessage:message];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            message = @"API接口不支持";
            [CHMBProgressHUD showMessage:message];
            break;
        }
        case EQQAPISENDFAILD:
        {
            message = @"发送失败";
            [CHMBProgressHUD showMessage:message];
            break;
        }
        default:
        {
            break;
        }
    }
    
    
}

/**
 分享到WeiXin
 */
-(void)sendGoToWeiXin
{
    if ([WXApi isWXAppInstalled]) {
        
        WXMediaMessage *message = [WXMediaMessage message];
        //标题
        message.title = kAppStoreTitle;
        //内容
        message.description = kAppStoreDescription;
        //图片地址
        NSString* path = kAppStoreImageNsstring;
        //网络图片url
        NSURL* url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //获取网络图片数据
        NSData* data = [NSData dataWithContentsOfURL:url];
        //根据图片数据流构造image
        UIImage *image = [UIImage imageWithData: data];
        NSData *imagedata=UIImagePNGRepresentation(image);
        message.thumbData = imagedata;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = kAppStoreNsstring;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;//WXSceneTimeline;//WXSceneTimeline
        if( ![WXApi sendReq:req] )
        {
            NSLog(@"failed");
        }
    }
    else
    {
        
        [CHMBProgressHUD showMessage:@"未安装微信"];

    }
    //SendMessageToWXReq的scene成员，如果scene填WXSceneSession，那么消息会发送至微信的会话内。如果scene填WXSceneTimeline，那么消息会发送至朋友圈。如果scene填WXSceneFavorite,那么消息会发送到“我的收藏”中。scene默认值为WXSceneSession。
}

/**
 分享到WeiXinFriend
 */
-(void)sendGoToWeiXinFriend
{
    
    if ([WXApi isWXAppInstalled]) {
        
        WXMediaMessage *message = [WXMediaMessage message];
        //标题
        message.title = kAppStoreTitle;
        //内容
        message.description = kAppStoreDescription;
        //图片地址
        NSString* path = kAppStoreImageNsstring;
        //网络图片url
        NSURL* url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //获取网络图片数据
        NSData* data = [NSData dataWithContentsOfURL:url];
        //根据图片数据流构造image
        UIImage *image = [UIImage imageWithData: data];
        NSData *imagedata=UIImagePNGRepresentation(image);
        message.thumbData = imagedata;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = kAppStoreNsstring;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;//WXSceneTimeline;//WXSceneTimeline
        if( ![WXApi sendReq:req] )
        {
            NSLog(@"failed");
        }
    }
    else
    {
        [CHMBProgressHUD showMessage:@"未安装微信"];
    }
}
/**
 发送请求
 */
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
