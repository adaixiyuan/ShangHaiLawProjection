//
//  ZXY_FirstSctionDetailInfoVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_FirstSctionDetailInfoVC.h"
#import "FirstSectionCellFolder/ZXY_UserFirstSectionHeader.h"
#import <AFNetworking/AFNetworking.h>
#import "ZXY_UserLoginVC.h"
#import "MJRefresh.h"
#import "OrderStatusType.h"
#import "UserInfoEntity.h"
#import "LawCaseTypeEntity.h"
#import "ZXY_UserServiceDetailInfoVC.h"
#import "ZXY_WebVC.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define UNITDEFINENUM 5

@interface ZXY_FirstSctionDetailInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    FirstSectionType _currentType;
    NSArray *dataForTV;
    __weak IBOutlet UITableView *currentTV;
    NSInteger currentNum;
    NSInteger maxNum;
    NSInteger currentPage;
    NSInteger maxPage;
    NSInteger sumNum;
    NSString  *myCaseType;
    BOOL isRefresh;
    BOOL isDownLoad;
    NSMutableDictionary *categoryType;
    NSMutableDictionary *lawDic;
    NSIndexPath *userSelectIndex;
}

@end

@implementation ZXY_FirstSctionDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self startLoad];
    [self initTableHeaderOrFooter];
    [self initNavi];
}


- (void)initData
{
    currentNum = UNITDEFINENUM;
    maxNum     = 0;
    currentPage = 0;
    dataForTV = [[NSArray alloc] init];
    isRefresh = NO;
    isDownLoad = YES;
    myCaseType = @"delegate";
    categoryType = [[NSMutableDictionary alloc] init];
    lawDic       = [[NSMutableDictionary alloc] init];
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:[self titleWithCurrentType] withPositon:1 ];
    [self setRightNaviItem:@"home_phone"];
}

- (NSString *)titleWithCurrentType
{
    if(_currentType == UserOrderType)
    {
         return @"我的订单";
    }
    else if(_currentType == LawConsultType)
    {
         return @"法律咨询";
    }
    else
    {
        return @"法律培训";
    }
}


- (void)chooseDownOrNotDown:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    currentNum = UNITDEFINENUM;
    currentPage = 0;
    if(segment.selectedSegmentIndex == 0)
    {
        isDownLoad = YES;
    }
    else
    {
        isDownLoad = NO;
    }
    isRefresh = YES;
    [self startLoad];
}

- (void)chooseMycaseMirrow:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    currentNum = UNITDEFINENUM;
    currentPage = 0;
    if(segment.selectedSegmentIndex == 0)
    {
        myCaseType = @"delegate";
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        myCaseType = @"agent";
    }
    else
    {
        myCaseType = @"complete";
    }
    isRefresh = YES;
    [self startLoad];
    
}

- (void)initTableHeaderOrFooter
{
    [currentTV addHeaderWithCallback:^{
        currentPage = 0;
        maxNum = 0;
        isRefresh = YES;
        currentNum = UNITDEFINENUM;
        [self startLoad];
    } dateKey:@"firstSectionTableV"];
    [currentTV addFooterWithCallback:^{
        if(currentPage<maxPage)
        {
            currentPage++;
            if(currentPage==maxNum-1)
            {
                currentNum = maxNum%maxPage;
                if(currentNum>=0)
                {
                    [self startLoad];
                }
            }
            else
            {
                [self startLoad];
            }
        }
        else
        {
            [currentTV footerEndRefreshing];
        }
        
    }];
    currentTV.headerPullToRefreshText = @"刷新数据";
    currentTV.headerReleaseToRefreshText = @"松开刷新数据";
    currentTV.headerRefreshingText = @"正在刷新";
    
    currentTV.footerPullToRefreshText = @"加载数据";
    currentTV.footerReleaseToRefreshText = @"松开加载更多数据";
    currentTV.footerRefreshingText = @"正在加载数据";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFirstSectionType:(FirstSectionType)currentType
{
    _currentType = currentType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataForTV.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *infoDic = [dataForTV objectAtIndex:indexPath.row];
    if(_currentType == UserOrderType)
    {
        ZXY_UserOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:UserOrderCellID];
        
        NSString *numOfNum = [infoDic objectForKey:@"num"];
        NSString *timeDate = [infoDic objectForKey:@"createAt"];
        NSNumber *countNum  = [infoDic objectForKey:@"count"];
        NSNumber *amountNum = [infoDic objectForKey:@"amount"];
        NSString *statusId  = [infoDic objectForKey:@"status"];
        NSArray *statusArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"OrderStatusType" withContent:statusId andKey:@"statusID"];
        NSDictionary *productDic = [infoDic objectForKey:@"$product"];
        NSDictionary *optionsDic = [productDic objectForKey:@"options"];
        NSDictionary *categoryName = [optionsDic objectForKey:@"category"];
        NSDictionary *subCate      = [categoryName objectForKey:[productDic objectForKey:@"nameId"]];
        orderCell.orderIDLbl.text    = numOfNum;
        orderCell.orderTimeLbl.text  = timeDate;
        orderCell.orderPriceLbl.text = [NSString stringWithFormat:@"%@ 元",amountNum];
        orderCell.orderNameLbl.text  = [NSString stringWithFormat:@"%@ X %@",[subCate objectForKey:@"name"],countNum.stringValue];
        if(statusArr.count)
        {
            OrderStatusType *orderType = [statusArr objectAtIndex:0];
            orderCell.statusLbl.text = orderType.statusName;
        }
        return orderCell;
    }
    else if(_currentType == LawTrainType)
    {
        ZXY_UserLawTrainCell *trainCell = [tableView dequeueReusableCellWithIdentifier:UserLawTrainCellID];
        NSString *trainName = [infoDic objectForKey:@"name"];
        NSString *timeString = [infoDic objectForKey:@"expire"];
        trainCell.dateTimeLbl.text = [NSString stringWithFormat:@"有效期至：%@",[self dateFromISODateStringM:timeString]];
        trainCell.titleLbl.text = trainName;
        trainCell.indexLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        trainCell.desText.text  = [infoDic objectForKey:@"description"];
        return trainCell;
    }
    else if (_currentType == LawConsultType)
    {
        ZXY_UserLawConsultCell *consultCell = [tableView dequeueReusableCellWithIdentifier:UserLawConsultCellID];
        NSString *createAt  = [infoDic objectForKey:@"startTime"];
        NSString *formatTime= [self dateFromISODateString:createAt];
        NSString *content   = [infoDic objectForKey:@"question"];
        NSString *unitString= [infoDic objectForKey:@"duration"];
        consultCell.contentTextV.text = content;
        consultCell.timeLbl.text      = formatTime;
        consultCell.unitLbl.text      = [NSString stringWithFormat:@"%@ 分钟",unitString];
        return consultCell;
    }
    else
    {
        ZXY_UserCaseCell *caseCell = [tableView dequeueReusableCellWithIdentifier:UserCaseCellID];
        NSString *numString = [infoDic objectForKey:@"num"];
        NSString *roleString = [[infoDic objectForKey:@"role"] stringValue];
        NSString *timeString = [infoDic objectForKey:@"createAt"];
        NSString *caseTypeID = [infoDic objectForKey:@"type"];
        NSString *statusString = [infoDic objectForKey:@"status"];
        NSArray  *caseArr    = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCaseTypeEntity" withContent:caseTypeID andKey:@"value"];
        if(caseArr.count >0)
        {
            LawCaseTypeEntity *caseType = [caseArr objectAtIndex:0];
            caseCell.typeLbl.text = [NSString stringWithFormat:@"类型：%@",caseType.name];
        }
        NSArray *lawAr      = [infoDic objectForKey:@"intention"];
        if(lawAr.count >0)
        {
            NSString *intendID = [lawAr objectAtIndex:0];
            NSDictionary *lawNow  = [lawDic objectForKey:intendID];
            caseCell.expectLawerLbl.text = [NSString stringWithFormat:@"意向律师：%@",[lawNow objectForKey:@"name"]];
        }
        caseCell.codeLbl.text = [NSString stringWithFormat:@"案件编号：%@",numString];
        caseCell.timeLbl.text = timeString;
        if([roleString isEqualToString:@"1"])
        {
            caseCell.roleLbl.text = @"较色：原告";
        }
        else
        {
            caseCell.roleLbl.text = @"较色：被告";
        }
        
        if([statusString isEqualToString:@"0"])
        {
            caseCell.statusLbl.text = @"状态：双方切磋";
        }
        else
        {
            caseCell.statusLbl.text = @"状态：托管代理费";
        }
        return caseCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentType == UserOrderType)
    {
        return 88;
    }
    else if(_currentType == LawTrainType)
    {
        return 114;
    }
    else if (_currentType == LawConsultType)
    {
        return 93;
    }
    else
    {
        return 126;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentType == UserOrderType)
    {
        userSelectIndex = indexPath;
        [self performSegueWithIdentifier:@"toDetailOrderVC" sender:self];
    }
    if(_currentType == LawTrainType)
    {
        return;
//        NSDictionary *infoDic = [dataForTV objectAtIndex:indexPath.row];
//        ZXY_WebVC *web = [[ZXY_WebVC alloc] init];
//        web.title = [infoDic objectForKey:@"name"];
//        NSString *fileID = [infoDic objectForKey:@"file"];
//        NSString *urlString = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
//        [web setDownLoadURL:urlString];
//        [self.navigationController pushViewController:web animated:YES];
    }
}

- (void)startLoad
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString ;
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    if(_currentType == UserOrderType)
    {
        urlString = [NSString stringWithFormat:@"%@%@?_csrf=%@&limit=%d&skip=%d",API_HOST_URL,API_USER_ORDERLIST,afterCSRF,currentNum,currentPage*UNITDEFINENUM];
    }
    else if (_currentType == LawTrainType)
    {
        NSString *downLoadMode ;
        downLoadMode = @"user";
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&mode=%@&skip=%d&limit=%d",API_HOST_URL,API_USER_LAWTRAIN,afterCSRF,downLoadMode,currentPage*UNITDEFINENUM,currentNum];
    }
    else if (_currentType == LawConsultType)
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&skip=%d&limit=%d",API_HOST_URL,API_USER_LAWCONSULT,afterCSRF,currentPage*UNITDEFINENUM,currentNum];
    }
    else
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&filter=%@&type=customer&limit=%d&skip=%d",API_HOST_URL,API_USER_CASE_LIST,afterCSRF,myCaseType,currentNum,currentPage*UNITDEFINENUM];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *currentHeader = [operation.response allHeaderFields];
        NSString *csrfString = [ZXY_APIFiles getCSRFToken:currentHeader];
        [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
        NSLog(@"%@",operation.responseString);
        NSData *returnData = [operation responseData];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        if([jsonDic.allKeys containsObject:@"data"])
        {
            NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
            NSDictionary *optionDic = [dataDic objectForKey:@"options"];
            NSDictionary *cateThis = [optionDic objectForKey:@"category"];
            NSDictionary *userDic  = [optionDic objectForKey:@"user"];
            
            for(int i = 0;i<cateThis.allKeys.count;i++)
            {
                NSString *currentKey = [cateThis.allKeys objectAtIndex:i];
                [categoryType setObject:[cateThis objectForKey:currentKey] forKey:currentKey];
            }
            
            for(int i = 0;i<userDic.allKeys.count;i++)
            {
                NSString *currentKey = [userDic.allKeys objectAtIndex:i];
                [lawDic setObject:[userDic objectForKey:currentKey] forKey:currentKey];
            }


            NSNumber *totalNum = [dataDic objectForKey:@"totalItems"];
            maxNum = totalNum.integerValue;
            if(maxNum%UNITDEFINENUM==0)
            {
                maxPage = maxNum/UNITDEFINENUM;
            }
            else
            {
                maxPage= maxNum/UNITDEFINENUM+1;
            }
            [currentTV headerEndRefreshing];
            [currentTV footerEndRefreshing];
            NSArray *allArray = [dataDic objectForKey:@"items"];
            if(allArray == nil)
            {
                return ;
            }
            else if (allArray.count ==0)
            {
                if(isRefresh)
                {
                    dataForTV = [NSArray arrayWithArray:allArray];
                    isRefresh = NO;
                    [currentTV reloadData];
                }
                return;
            }
            else
            {
                if(isRefresh)
                {
                    dataForTV = [NSArray arrayWithArray:allArray];
                    isRefresh = NO;
                }
                else
                {
                    dataForTV = [dataForTV arrayByAddingObjectsFromArray:allArray];
                }
                [currentTV reloadData];
            }
        }
        else
        {
            self.navigationItem.leftBarButtonItem.enabled = NO;
            [[UserInfoDetail sharedInstance] userLogOut];
            [self performSelector:@selector(toLoginVC) withObject:nil afterDelay:1];
           
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UserInfoDetail sharedInstance] userLogOut];
        [self performSelector:@selector(toLoginVC) withObject:nil afterDelay:1];
    }];
    
}

- (void)toLoginVC
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self performSegueWithIdentifier:@"toLoginVC" sender:self];
}


- (NSString *)dateFromISODateString:(NSString *)isodate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"];
    NSDate *currentDate = [dateFormatter dateFromString:isodate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *stringDate    =    [dateFormatter stringFromDate:currentDate];
    return stringDate;
}

- (NSString *)dateFromISODateStringM:(NSString *)isodate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"];
    NSDate *currentDate = [dateFormatter dateFromString:isodate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringDate    =    [dateFormatter stringFromDate:currentDate];
    return stringDate;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toLoginVC"])
    {
        ZXY_UserLoginVC *loginVC = [segue destinationViewController];
        loginVC.onComplete = ^()
        {
            [self startLoad];
        };
    }
    
    if([segue.identifier isEqualToString:@"toDetailOrderVC"])
    {
        NSDictionary *dicForDetail = [dataForTV objectAtIndex:userSelectIndex.row];
        ZXY_UserServiceDetailInfoVC *detailOrder = [segue destinationViewController];
        [detailOrder setUserOrderInfoDic:dicForDetail];
    }
}


@end
