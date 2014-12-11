//
//  ZXY_WebVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_WebVC.h"
#import "WeChatSDK/WXApi.h"
#import "WeChatSDK/WXApiObject.h"
#import "ZXYFileOperateHelper.h"
#import <MessageUI/MessageUI.h>
#import "TencentSDK/TencentOpenAPI.framework/Headers/TencentOAuth.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
//tencentMessage
#import <TencentOpenAPI/TencentMessageObject.h>
@interface ZXY_WebVC ()<UIActionSheetDelegate,UIWebViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,WXApiDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
    NSString *urlString;
    NSInteger _currentScene;
    NSMutableData *connectionData;
    BOOL  isZone;
}
@property (weak, nonatomic) IBOutlet UIWebView *currentWeb;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
- (IBAction)shareAction:(id)sender;

@end

@implementation ZXY_WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fileString = [[ZXYFileOperateHelper sharedInstance] cathePath];
    //NSString *filePath   = [fileString stringByAppendingPathComponent:[self toFileName]];
    NSMutableURLRequest *requests = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [self.currentWeb loadRequest:requests];

//    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
//    {
//        [self readFileContent];
//    }
//    else
//    {
//        connectionData = [[NSMutableData alloc] init];
//        NSMutableURLRequest *requests = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
//        NSURLConnection *connection = [NSURLConnection connectionWithRequest:requests delegate:self];
//        [connection start];
//    }
    [self initNavi];
    // Do any additional setup after loading the view from its nib.
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *fileString = [[ZXYFileOperateHelper sharedInstance] cathePath];
    NSString *filePath   = [fileString stringByAppendingPathComponent:[self toFileName]];
    [connectionData writeToFile:filePath atomically:YES];
    [self readFileContent];
}

- (void)readFileContent
{
    NSString *fileString = [[ZXYFileOperateHelper sharedInstance] cathePath];
    NSString *filePath   = [fileString stringByAppendingPathComponent:[self toFileName]];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self.currentWeb loadRequest:[NSURLRequest requestWithURL:url]];
}

- (NSString *)toFileName
{
    NSArray *fileID = [urlString componentsSeparatedByString:@"fileId="];
    NSArray *fileName = [self.title componentsSeparatedByString:@"."];
    return [NSString stringWithFormat:@"%@.%@",[fileID lastObject],[fileName lastObject]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setRightNaviItem:@"home_phone"];
}

- (void)setDownLoadURL:(NSString *)stringURL
{
    urlString = stringURL;
}



- (void)sendFileContent
{
    if(![WXApi isWXAppInstalled])
    {
        [self showAlertWarnningView:@"提示" andContent:@"请下载安装微信。"];
    }
    if(![WXApi isWXAppSupportApi])
    {
        [self showAlertWarnningView:@"提示" andContent:@"请下载安装最新版本的微信。"];
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description = self.title;
    [message setThumbImage:[UIImage imageNamed:@"58.png"]];
    NSArray *currentFileType = [self.title componentsSeparatedByString:@"."];
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = [currentFileType lastObject];
   // NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"pdf"];
    NSString *fileString = [[ZXYFileOperateHelper sharedInstance] cathePath];
    NSString *filePath   = [fileString stringByAppendingPathComponent:[self toFileName]];
    ext.fileData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _currentScene;
    
    [WXApi sendReq:req];
    
}

- (void) sendLinkContent
{
    if(![WXApi isWXAppInstalled])
    {
        [self showAlertWarnningView:@"提示" andContent:@"请下载安装微信。"];
    }
    if(![WXApi isWXAppSupportApi])
    {
        [self showAlertWarnningView:@"提示" andContent:@"请下载安装最新版本的微信。"];
    }

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"法率网：%@",self.title];
    message.description = nil;
    [message setThumbImage:[UIImage imageNamed:@"share.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _currentScene;
    
    [WXApi sendReq:req];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareAction:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信朋友圈",@"微信好友",@"QQ分享",@"邮件", nil];
    [action showInView:self.view];
    
}

- (void)toEmailView
{
    if( [MFMailComposeViewController canSendMail] )
    {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        //[mc setToRecipients:[NSArray arrayWithObjects:@"zhuqi0@126.com","@dave@iphonedevbook.com", nil]];
        [mc setSubject:@"法率网邮件分享"];
        NSString *urlStrings = [NSString stringWithFormat:@"<HTML><a href=%@>%@</a></HTML>",urlString,urlString];
        [mc setMessageBody:urlStrings isHTML:YES];
        [self presentViewController:mc animated:YES completion:^{
            
        }];
    }
    else
    {
        [self showAlertWarnningView:@"提示" andContent:@"请先登录邮箱。"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sendTencentShare
{
    if(![QQApiInterface isQQInstalled])
    {
        [self showAlertWarnningView:@"提示" andContent:@"请下载并安装QQ"];
        return;
    }
    
    if(![QQApiInterface isQQSupportApi])
    {
        [self showAlertWarnningView:@"提示" andContent:@"不支持当前版本的qq"];
        return;
    }
    @try {
        NSString *url = urlString;
        //分享图预览图URL地址
        UIImage *image = [UIImage imageNamed:@"share"];
        NSData  *imageData = UIImageJPEGRepresentation(image, 1);
        //NSString *previewImageUrl = @"share.png";
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                    title: @"【法率】"
                                    description:self.title
                                    previewImageData:imageData];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode sent ;
        //将内容分享到qq
        if(isZone)
        {
            sent = [QQApiInterface SendReqToQZone:req];
        }
        else
        {
            sent  = [QQApiInterface sendReq:req];
        }
        [self handleSendResult:sent];

    }
    @catch (NSException *exception) {
        [self showAlertWarnningView:@"请将此异常发送到开发者" andContent:exception.reason];
    }
    @finally {
        
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯文本分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯图片分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)sendToQZone
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        _currentScene = 1;
        [self sendLinkContent];
    }
    else if (buttonIndex == 1)
    {
        _currentScene = 0;
        [self sendLinkContent];
    }
    else if (buttonIndex == 3)
    {
        [self toEmailView];
    }
    else if (buttonIndex == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择分享的方式" delegate:self cancelButtonTitle:nil otherButtonTitles:@"QQ空间",@"QQ好友",@"取消", nil];
        alert.tag = 5001;
        [alert show];
        //[self sendTencentShare];
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 5001)
    {
        if(buttonIndex == 0)
        {
            isZone = YES;
            [self sendTencentShare];
        }
        else if (buttonIndex == 1)
        {
            isZone = NO;
            [self sendTencentShare];
        }
        else
        {
            
        }
    }
}
@end
