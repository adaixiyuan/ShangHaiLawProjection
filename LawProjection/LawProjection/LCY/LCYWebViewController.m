//
//  LCYWebViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/6.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYWebViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface LCYWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *icyWebView;

@end

@implementation LCYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    NSString *URLString = [NSString stringWithFormat:@"%@%@?_csrf=%@&fileId=%@", API_HOST_URL, @"file/download.json", afterCSRF,self.evidence.fileID];
    NSLog(@"URL = %@",URLString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [self.icyWebView loadRequest:request];
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
