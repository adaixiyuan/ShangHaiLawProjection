//
//  LCYPhoneViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYPhoneViewController.h"

@interface LCYPhoneViewController ()

@end

@implementation LCYPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航栏电话
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // TODO: 加上打电话点击事件
    [rightBarButton setImage:[UIImage imageNamed:@"home_phone"] forState:UIControlStateNormal];
    [rightBarButton sizeToFit];
    [rightBarButton addTarget:self action:@selector(setNaviRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    // 返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton addTarget:self action:@selector(backNavigation:) forControlEvents:UIControlEventTouchUpInside];
    [backBarButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backBarButton sizeToFit];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNaviRightAction
{
    
    NSString *phoneNumber = @"4008607766";
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backNavigation:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


@end
