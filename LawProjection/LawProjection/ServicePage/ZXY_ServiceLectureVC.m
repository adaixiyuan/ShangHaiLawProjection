//
//  ZXY_ServiceLectureVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ServiceLectureVC.h"
#import "ZXY_ServiceLectureCell.h"
@interface ZXY_ServiceLectureVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZXY_ServiceLectureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    [self setNaviTitle:@"法律培训" withPositon:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_ServiceLectureCell *cell = [tableView dequeueReusableCellWithIdentifier:ServiceLectureCellID];
    return cell;
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
