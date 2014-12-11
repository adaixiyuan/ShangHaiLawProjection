//
//  ZXY_UserProtocalWebVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-14.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserProtocalWebVC.h"

@interface ZXY_UserProtocalWebVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *protocalWeb;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressCircle;

@end

@implementation ZXY_UserProtocalWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initWebV];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"用户注册协议" withPositon:1];
    [self setNaviTitleColor:[UIColor whiteColor]];
    [self setRightNaviItem:@"home_phone"];
}


- (void)initWebV
{
    NSString *protocalPath = [[NSBundle mainBundle] pathForResource:@"UserProtocalHTML" ofType:@"html"];
    NSString *htmlString   = [NSString stringWithContentsOfFile:protocalPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:protocalPath];
    self.protocalWeb.delegate = self;
    [self.protocalWeb loadHTMLString:htmlString baseURL:url];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.progressCircle startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progressCircle stopAnimating];
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
