//
//  ZXY_CityZoneVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-15.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_CityZoneVC.h"
#import "ZXYProvider.h"
#import "LawCityEntity.h"
#import "ZXY_UserCityCell.h"

@interface ZXY_CityZoneVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *allDataForShow;
    LawCityEntity *provinceEntity;
    LawCityEntity *cityEntity;
    LawCityEntity *zoneEntity;
    BOOL isProvince;
    BOOL isCity;
    BOOL isZone;
    BOOL _isLevelCity;
    __weak IBOutlet UITableView *currentTable;
}
@end

@implementation ZXY_CityZoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    self.title = @"选择省";
}

- (void)initData
{
    allDataForShow = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:@"root" andKey:@"parent" orderBy:@"sort" isDes:YES];
    isProvince = YES;
    isCity     = NO;
    isZone     = NO;
}

- (void)setLevel:(BOOL)isLevelCity
{
    _isLevelCity = isLevelCity;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_UserCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zxyusercitycellID"];
    LawCityEntity *entity = [allDataForShow objectAtIndex:indexPath.row];
    cell.cityName.text = entity.name;
    return cell;
}

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allDataForShow.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LawCityEntity *entity = [allDataForShow objectAtIndex:indexPath.row];
    if(isProvince)
    {
        provinceEntity = entity;
        self.title = provinceEntity.name;
        isProvince = NO;
        isCity     = YES;
        isZone     = NO;
        allDataForShow = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:entity.cityID andKey:@"parent" orderBy:@"sort" isDes:YES];
        [tableView reloadData];
    }
    else if(isCity)
    {
        cityEntity     = entity;
        self.title     = cityEntity.name;
        allDataForShow = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:entity.cityID andKey:@"parent" orderBy:@"sort" isDes:YES];
        
        isProvince = NO;
        isCity     = NO;
        isZone     = YES;
        if(_isLevelCity)
        {
            [self sendDataBeforePop];
        }
        else
        {
            [tableView reloadData];
        }
    }
    else
    {
        zoneEntity     = entity;
        isProvince = NO;
        isCity     = NO;
        isZone     = YES;
        self.title = cityEntity.name;
        [self sendDataBeforePop];
    }
}

- (void)setNaviLeftAction
{
    if(isProvince)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if(isCity)
    {
        isProvince = YES;
        isCity = NO;
        isZone = NO;
        cityEntity = nil;
        provinceEntity = nil;
        allDataForShow = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:@"root" andKey:@"parent" orderBy:@"sort" isDes:YES];
        [currentTable reloadData];
        return;
    }
    if(isZone)
    {
        isProvince = NO;
        isCity     = YES;
        isZone     = NO;
        zoneEntity = nil;
        
        allDataForShow = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:provinceEntity.cityID andKey:@"parent" orderBy:@"sort" isDes:YES];
        cityEntity = nil;
        [currentTable reloadData];
        

    }
    
}

- (void)sendDataBeforePop
{
    if([self.delegate respondsToSelector:@selector(userChooseCityDelegate:andCityEntity:withZoneEntity:)])
    {
        NSLog(@"province %@ city %@ zone %@",provinceEntity.name,cityEntity.name,zoneEntity.name);
        [self.delegate userChooseCityDelegate:provinceEntity andCityEntity:cityEntity withZoneEntity:zoneEntity];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
