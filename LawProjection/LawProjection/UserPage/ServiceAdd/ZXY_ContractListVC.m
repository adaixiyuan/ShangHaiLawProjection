//
//  ZXY_ContractListVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ContractListVC.h"
#import "ZXY_UserCityCell.h"
#import "ZXY_WebVC.h"
@interface ZXY_ContractListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *dataFORTV;
    NSMutableArray *allFileForShow;
}
@end

@implementation ZXY_ContractListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAttrInfoDic:(NSDictionary *)dataForTable
{
    if(allFileForShow == nil)
    {
        allFileForShow = [[NSMutableArray alloc] init];
    }
    dataFORTV = dataForTable;
    if([dataForTable[@"type"] isEqualToString:@"NW2999"])
    {
        
    }
    else
    {
        NSDictionary *dic = @{
                              @"name":dataFORTV[@"name"],
                              @"id"  :dataFORTV[@"file"]
                              };
        [allFileForShow addObject:dic];
    }
    NSArray *attaches = [dataFORTV objectForKey:@"attaches"];
    for(NSDictionary *dic in attaches)
    {
        if(![[dic objectForKey:@"type"] isEqualToString:@"template"])
        {
            [allFileForShow addObject:dic];
        }
    }
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allFileForShow.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_UserCityCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCityCellID];
    NSDictionary *attrDic = [allFileForShow objectAtIndex:indexPath.row];
    if([dataFORTV[@"type"] isEqualToString:@"NW2999"])
    {
        cell.cityName.text = [attrDic objectForKey:@"fileName"];
    }
    else
    {
        cell.cityName.text = [attrDic objectForKey:@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *attaches     = [dataFORTV objectForKey:@"attaches"];
    NSDictionary *attrDic = [allFileForShow objectAtIndex:indexPath.row];
    NSString *fileID ;
    NSString *fileName;
    if([dataFORTV[@"type"] isEqualToString:@"NW2999"])
    {
        fileID = [attrDic objectForKey:@"fileId"];
        fileName = [attrDic objectForKey:@"fileName"];
    }
    else
    {
        fileID = [attrDic objectForKey:@"id"];
        fileName = [attrDic objectForKey:@"name"];
    }
    NSString *urlString   = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
    ZXY_WebVC *web = [[ZXY_WebVC alloc] init];
    web.title = fileName;
    [web setDownLoadURL:urlString];
    [self.navigationController pushViewController:web animated:YES];
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
