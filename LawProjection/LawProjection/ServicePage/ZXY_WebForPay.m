//
//  ZXY_WebForPay.m
//  LawProjection
//
//  Created by 宇周 on 14/11/10.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_WebForPay.h"

@interface ZXY_WebForPay ()<UIWebViewDelegate>
{
    NSDictionary *_parameter;
    __weak IBOutlet UIWebView *payWeb;
}
@end

@implementation ZXY_WebForPay

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startPay];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setThisURLParameter:(NSDictionary *)parameter
{
    _parameter = parameter;
}

- (void)startPay
{
    NSString *afterString = [ZXY_APIFiles encode:[[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF]];
    NSString *urlString = [NSString stringWithFormat:@"%@order/pay?orderId=%@&pay_method=%@&_csrf=%@",API_HOST_URL,[_parameter objectForKey:@"_id"],@"alipay",afterString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [payWeb loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"web error is %@",error);
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
