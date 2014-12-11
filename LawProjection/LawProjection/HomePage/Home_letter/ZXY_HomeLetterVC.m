//
//  ZXY_HomeLetterVC.m
//  LawProjection
//
//  Created by developer on 14-9-23.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_HomeLetterVC.h"
#import "ZXY_HomeLetterCellTableViewCell.h"
#import <AFNetworking/AFNetworking.h>

NSString *const HomeLetterVCID=@"letterVC_ID";

@interface ZXY_HomeLetterVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataForTable;
}
@end

@implementation ZXY_HomeLetterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dataForTable = [[NSMutableArray alloc] init];
   
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataForTable.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_HomeLetterCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HOMELETTERCELLID];
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
