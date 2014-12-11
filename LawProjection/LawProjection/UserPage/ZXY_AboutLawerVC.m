//
//  ZXY_AboutLawerVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-19.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_AboutLawerVC.h"

@interface ZXY_AboutLawerVC ()

@end

@implementation ZXY_AboutLawerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:@"关于法律" withPositon:1 ];
    [self setRightNaviItem:@"home_phone"];

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
