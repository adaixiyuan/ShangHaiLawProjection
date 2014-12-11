//
//  ZXY_SecondSectionDetailInfoVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_SecondSectionDetailInfoVC.h"
#import "ZXY_SecondTVCell.h"
#import "MJRefresh.h"
#import <AFNetworking/AFNetworking.h>
#import "LawEntityHelper.h"
#import "UserServiceInfo.h"
#import "ZXY_UserCaseCell.h"
#import "LawCaseTypeEntity.h"
#import "ServiceAdd/ZXY_ServiceContractAddVC.h"
#import "ZXY_NewAuditContractVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZXY_LetterAddVC.h"
#import "ZXY_AddCaseVC.h"

#define SECONDUNIT 10
#define ONECOLOR [UIColor colorWithRed:23.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1];
#define TWOCOLOR [UIColor colorWithRed:59.0/255.0 green:148.0/255.0 blue:223.0/255.0 alpha:1];
#define THIRDCOLOR [UIColor colorWithRed:29.0/255.0 green:195.0/255.0 blue:142.0/255.0 alpha:1];
#define FOURCOLOR [UIColor colorWithRed:92.0/255.0 green:205.0/255.0 blue:72.0/255.0 alpha:1];
#define FIVECOLOR [UIColor colorWithRed:252.0/255.0 green:135.0/255.0 blue:70.0/255.0 alpha:1];
@interface ZXY_SecondSectionDetailInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataForTV;
    SecondSectionType _currentType;
    NSInteger currentNum;
    NSInteger maxNum;
    NSInteger currentPage;
    NSInteger maxPage;
    NSInteger sumNum;
    NSMutableDictionary *categoryDic;
    BOOL isRefresh;
    __weak IBOutlet UITableView *currentTv;
    __weak IBOutlet UILabel *addNewServiceLbl;
    __weak IBOutlet UIActivityIndicatorView *waitIndicator;
    __weak IBOutlet UILabel *remainLbl;
    NSString *serviceTypeID;
    NSMutableDictionary *lawDic;
    NSString *myCaseType;
    NSDictionary *dicForDetail;
    NSDictionary *optionDicForCell;
    BOOL isShowDetail;
    __weak IBOutlet UIButton *caseBtn;
    __weak IBOutlet UIView *caseView;
    UISegmentedControl *suchSeg;
}
- (IBAction)addMyCase:(id)sender;

@end

@implementation ZXY_SecondSectionDetailInfoVC

- (void)viewDidLoad {
    [self initData];
    [super viewDidLoad];
    [self initTableHeaderOrFooter];
    if(_currentType == SecondCaseType)
    {
        [self initSegment];
        UIColor *blueCoc = NAVIBARCOLOR;
        caseBtn.layer.borderColor = blueCoc.CGColor;
        caseBtn.layer.borderWidth = 1;
        [caseView setHidden:YES];
    }
    else
    {
        [self initNavi];
        [caseBtn setHidden:YES];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentNum = SECONDUNIT;
    maxNum     = 0;
    currentPage = 0;
    isRefresh = YES;
    
    [self.tabBarController.tabBar setHidden:YES];
    if([[UserInfoDetail sharedInstance] isUserLogin])
    {
        if(_currentType == SecondCaseType)
        {
            [self startLoad];
        }
        else
        {
            [self startDownRemain];
        }
        
    }
    isShowDetail = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSecondSectionType:(SecondSectionType)currentType
{
    _currentType = currentType;
}


- (void)initData
{
    currentNum = SECONDUNIT;
    maxNum     = 0;
    currentPage = 0;
    dataForTV = [[NSArray alloc] init];
    isRefresh = NO;
    categoryDic = [[NSMutableDictionary alloc] init];
    lawDic = [[NSMutableDictionary alloc] init];
    myCaseType = @"delegate";
}

- (void)startDownRemain
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [waitIndicator startAnimating];
    [remainLbl setHidden:YES];
    [addNewServiceLbl setTextColor:[UIColor grayColor]];
    [addNewServiceLbl setText:[self returnAddLblText]];
    addNewServiceLbl.userInteractionEnabled = NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *csrfToken = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *realCSRF  = [ZXY_APIFiles encode:csrfToken];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?_csrf=%@",API_HOST_URL,API_SERVICE_LIST_URL,realCSRF];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSData *data = [operation responseData];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [waitIndicator stopAnimating];
        if([dic.allKeys containsObject:@"error"])
        {
            NSDictionary *errorDic = [dic objectForKey:@"error"];
            // NSString *codeString   = [errorDic objectForKey:@"code"];
            NSString *errorInfo    = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:@"" andContent:errorInfo];
        }
        else
        {
            NSLog(@"%@",operation.responseString);
            NSDictionary *allHeader = operation.response.allHeaderFields;
            NSString *csrftoken     = [ZXY_APIFiles getCSRFToken:allHeader];
            [[UserInfoDetail sharedInstance] setOthersInfo:csrftoken withKey:ZXY_VALUES_CSRF];
            NSData *returnData = [operation responseData];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
            
            NSArray *saveArr = [jsonDic objectForKey:@"data"];
            [LawEntityHelper saveUserServiceInfo:saveArr];
            NSArray *serviceInfoArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"UserServiceInfo" withContent:serviceTypeID andKey:@"serviceType"];
            [self startLoad];
            if(serviceInfoArr.count >0)
            {
                UserServiceInfo *serviceInfo = [serviceInfoArr objectAtIndex:0];
                NSNumber *remainNum = [serviceInfo remainAmounttotal];
                NSInteger remainInt = remainNum.integerValue;
                if(remainInt >0)
                {
                    //[remainLbl setHidden:NO];
                    NSString *remainString = [NSString stringWithFormat:@"(%ld)",(long)remainInt];
                    [addNewServiceLbl setText:[NSString stringWithFormat:@"%@%@",[self returnAddLblText],remainString]];
                    UIColor *naviClor = NAVIBARCOLOR;
                    [addNewServiceLbl setTextColor:naviClor];
                    addNewServiceLbl.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAddService)];
                    [addNewServiceLbl addGestureRecognizer:tapGes];
                }
                else
                {
//                    [remainLbl setHidden:NO];
//                    remainLbl.text = [NSString stringWithFormat:@"(0)"];
//                    remainLbl.textColor = [UIColor grayColor];
                }
            }
            
        }
        NSLog(@"%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        if(![ZXY_SystemRelative isNetAvilible])
        {
            [waitIndicator stopAnimating];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
            return;
        }
        else
        {
            self.navigationItem.leftBarButtonItem.enabled = NO;
            [waitIndicator stopAnimating];
            [self performSelector:@selector(toLoginVC) withObject:self afterDelay:1];
        }
//        [self performSegueWithIdentifier:@"toLoginVC" sender:self];
//                NSLog(@"%@",error);
    }];

}

- (void)startAddService
{
    isShowDetail = NO;
    NSLog(@"可以添加");
    if(_currentType == SecondDraftType)
    {
        [self performSegueWithIdentifier:@"addNewContract" sender:self];
    }
    if(_currentType == SecondAuditType)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"ZXY_NewServiceStory" bundle:nil];
        ZXY_NewAuditContractVC *auditVC  =  [story instantiateInitialViewController];
        [self.navigationController pushViewController:auditVC animated:YES];
    }
    if(_currentType == SecondLetterType)
    {
        [self performSegueWithIdentifier:@"toLetterAdd" sender:self];
    }
    
}

- (NSString *)returnAddLblText
{
    if(_currentType == SecondLetterType)
    {
        serviceTypeID = @"ST0002";
        return @"新的签发";
    }
    else if(_currentType == SecondAuditType)
    {
        serviceTypeID = @"ST0004";
        return @"新的审核";
    }
    else if(_currentType == SecondDraftType)
    {
        serviceTypeID = @"ST0003";
        return @"新的起草";
    }
    else
    {
        serviceTypeID = @"";
        [waitIndicator stopAnimating];
        [remainLbl setHidden:YES];
        UIColor *naviColor = NAVIBARCOLOR;
        [addNewServiceLbl setTextColor:naviColor];
        addNewServiceLbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAddService)];
        [addNewServiceLbl addGestureRecognizer:tapGes];
        return @"新的委托";
    }

}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:[self titleWithCurrentType] withPositon:1 ];
    [self setRightNaviItem:@"home_phone"];
}

- (void)initSegment
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    UISegmentedControl *segMent;
    segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"委托中",@"代理中",@"历史记录", nil]];
    [segMent addTarget:self action:@selector(chooseMycaseMirrow:) forControlEvents:UIControlEventValueChanged];
    
    [segMent setSelectedSegmentIndex:0];
    segMent.frame = CGRectMake(0, 0, 160, 30);
    UIColor *naviColor = NAVIBARCOLOR;
    [segMent setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:naviColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [segMent setTintColor:[UIColor whiteColor]];
    suchSeg = segMent;
    [self setNaviTitleView:segMent];
    
}


- (void)chooseMycaseMirrow:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    currentNum = SECONDUNIT;
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


- (NSString *)titleWithCurrentType
{
    if(_currentType == SecondLetterType)
    {
        return @"签发律师函";
    }
    else if(_currentType == SecondAuditType)
    {
        return @"合同审核";
    }
    else
    {
        return @"合同起草";
    }
}


- (void)initTableHeaderOrFooter
{
    [currentTv addHeaderWithCallback:^{
        currentNum = SECONDUNIT;
        currentPage = 0;
        maxNum = 0;
        isRefresh = YES;
        [self startLoad];
    } dateKey:@"secondSectionTableV"];
    [currentTv addFooterWithCallback:^{
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
            [currentTv footerEndRefreshing];
        }
        
    }];
    currentTv.headerPullToRefreshText = @"刷新数据";
    currentTv.headerReleaseToRefreshText = @"松开刷新数据";
    currentTv.headerRefreshingText = @"正在刷新";
    
    currentTv.footerPullToRefreshText = @"加载数据";
    currentTv.footerReleaseToRefreshText = @"松开加载更多数据";
    currentTv.footerRefreshingText = @"正在加载数据";
    
}


- (void)startLoad
{
//    if(![ZXY_SystemRelative isNetAvilible])
//    {
//        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
//        return;
//    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [suchSeg setUserInteractionEnabled:NO];
    NSString *urlString ;
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    if(_currentType == SecondLetterType)
    {
        urlString = [NSString stringWithFormat:@"%@%@?_csrf=%@&limit=%ld&skip=%ld",API_HOST_URL,API_LETTERLIST_URL,afterCSRF,(long)currentNum,(long)currentPage*SECONDUNIT];
    }
    else if (_currentType == SecondAuditType)
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&skip=%ld&limit=%ld",API_HOST_URL,API_AUDITLIST_URL,afterCSRF,(long)currentPage*SECONDUNIT,(long)currentNum];
    }
    else if (_currentType == SecondDraftType)
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&skip=%ld&limit=%ld",API_HOST_URL,API_DRAFTLIST_URL,afterCSRF,(long)currentPage*SECONDUNIT,(long)currentNum];
    }
    else if (_currentType == SecondCaseType)
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&filter=%@&type=customer&limit=%ld&skip=%ld",API_HOST_URL,API_USER_CASE_LIST,afterCSRF,myCaseType,(long)currentNum,(long)currentPage*SECONDUNIT];
    }
    else
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&limit=%ld&skip=%ld",API_HOST_URL,API_DRAFTLIST_URL,afterCSRF,(long)currentNum,(long)currentPage];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [suchSeg setUserInteractionEnabled:YES];
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
            
            NSDictionary *userDic  = [optionDic objectForKey:@"user"];
            for(int i = 0;i<userDic.allKeys.count;i++)
            {
                NSString *currentKey = [userDic.allKeys objectAtIndex:i];
                [lawDic setObject:[userDic objectForKey:currentKey] forKey:currentKey];
            }

            NSNumber *totalNum = [dataDic objectForKey:@"totalItems"];
            maxNum = totalNum.integerValue;
            
            if(maxNum%SECONDUNIT==0)
            {
                maxPage = maxNum/SECONDUNIT;
            }
            else
            {
                maxPage= maxNum/SECONDUNIT+1;
            }
            [currentTv headerEndRefreshing];
            [currentTv footerEndRefreshing];
            NSArray *allArray = [dataDic objectForKey:@"items"];
            NSDictionary *cateDic = [optionDic objectForKey:@"category"];
            for(int i = 0;i<cateDic.allKeys.count;i++)
            {
                NSString *currentKey = [cateDic.allKeys objectAtIndex:i];
                [categoryDic setObject:[cateDic objectForKey:currentKey] forKey:currentKey];
            }
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
                    [currentTv reloadData];
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
                [currentTv reloadData];
            }
        }
        else
        {
            [[UserInfoDetail sharedInstance] userLogOut];
            [self performSelector:@selector(toLoginVC) withObject:nil afterDelay:1];
            [suchSeg setUserInteractionEnabled:YES];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UserInfoDetail sharedInstance] userLogOut];
        [self performSelector:@selector(toLoginVC) withObject:nil afterDelay:1];
        [suchSeg setUserInteractionEnabled:YES];
    }];
    
}

- (void)toLoginVC
{
    if(self.view)
    {
        [[UserInfoDetail sharedInstance] userLogOut];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [waitIndicator stopAnimating];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"toLoginVC" sender:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataForTV.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentType == SecondCaseType)
    {
        return 126;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_SecondTVCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondTVCellID];
    cell.statusImage.layer.cornerRadius = 24;
    cell.statusImage.layer.masksToBounds=YES;
    NSDictionary *dicInfo = [dataForTV objectAtIndex:indexPath.row];
    if(_currentType == SecondLetterType)
    {
        NSString *typeString = [dicInfo objectForKey:@"type"];
        NSString *createAt = [NSString stringWithFormat:@"提交时间：%@",[self dateFromISODateString:[dicInfo objectForKey:@"createAt"]] ];;
        NSString *statusString = [dicInfo objectForKey:@"status"];
        NSString *nameString ;
        if([typeString isEqualToString:@"CT0001"])
        {
            nameString = [NSString stringWithFormat:@"收函人：%@",[dicInfo objectForKey:@"represents"]];
        }
        else
        {
            nameString = [NSString stringWithFormat:@"收函人：%@",[dicInfo objectForKey:@"name"]];
        }
        NSDictionary *cateSubDic = [categoryDic objectForKey:statusString];
        if ([dicInfo[@"status"] isEqualToString:@"LS0001"]) {
            cell.statusImage.backgroundColor = [UIColor colorWithRed:0.0 green:205.0/255.0 blue:1.0 alpha:1.0];
            cell.statusLbl.text   = @"提交";
        } else if ([dicInfo[@"status"] isEqualToString:@"LS0002"]) {
            cell.statusImage.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:166.0/255.0 blue:230.0/255.0 alpha:1.0];
            cell.statusLbl.text   = @"起草";
        } else if ([dicInfo[@"status"] isEqualToString:@"LS0003"]) {
            cell.statusImage.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:203.0/255.0 blue:160.0/255.0 alpha:1.0];
            cell.statusLbl.text   = @"确认";
        } else if ([dicInfo[@"status"] isEqualToString:@"LS0004"]) {
            cell.statusImage.backgroundColor = [UIColor colorWithRed:107.0/255.0 green:211.0/255.0 blue:90.0/255.0 alpha:1.0];
            cell.statusLbl.text   = @"发送";
        } else if ([dicInfo[@"status"] isEqualToString:@"LS0005"]) {
            cell.statusImage.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:88.0/255.0 alpha:1.0];
            cell.statusLbl.text   = @"存档";
        }

        
        cell.firstRowLbl.text = nameString;
        cell.currentStatus    = statusString;
        cell.secondRowLbl.text = createAt;
    }
    else if(_currentType == SecondAuditType)
    {
        NSArray *originalArr = [dicInfo objectForKey:@"originalContract"];
        NSDictionary *firstForshowDic = [originalArr objectAtIndex:0];
        NSString *statusString    = [dicInfo objectForKey:@"status"];
        if([statusString isEqualToString:@"AAS001"])
        {
            cell.statusImage.backgroundColor = ONECOLOR;
            cell.statusLbl.text      = @"提交";
        }
        else if ([statusString isEqualToString:@"AAS002"])
        {
            cell.statusImage.backgroundColor = TWOCOLOR;
            cell.statusLbl.text      = @"审核";
        }
        else if ([statusString isEqualToString:@"AAS003"])
        {
            cell.statusImage.backgroundColor = THIRDCOLOR;
            cell.statusLbl.text      = @"完成";
        }
        else if ([statusString isEqualToString:@"AAS004"])
        {
            cell.statusImage.backgroundColor = FOURCOLOR;
        }
        else
        {
            cell.statusImage.backgroundColor = FIVECOLOR;
        }
        NSString *createAt        = [NSString stringWithFormat:@"提交时间：%@",[self dateFromISODateString:[dicInfo objectForKey:@"createAt"]] ];
        cell.firstRowLbl.text     = [firstForshowDic objectForKey:@"fileName"];
        cell.secondRowLbl.text    = createAt;
        cell.currentStatus        = statusString;
        //NSDictionary *cateSubDic = [categoryDic objectForKey:statusString];
        
    }
    else if(_currentType == SecondCaseType)
    {
        ZXY_UserCaseCell *caseCell = [tableView dequeueReusableCellWithIdentifier:UserCaseCellID];
        NSString *numString = [dicInfo objectForKey:@"num"];
        NSString *roleString = [[dicInfo objectForKey:@"role"] stringValue];
        NSString *timeString = [NSString stringWithFormat:@"提交时间：%@",[self dateFromISODateString:[dicInfo objectForKey:@"createAt"]] ];;
        NSString *caseTypeID = [dicInfo objectForKey:@"type"];
        NSString *statusString = [dicInfo objectForKey:@"status"];
        NSString *stageString  = [dicInfo objectForKey:@"stage"];
        NSDictionary *caseTypeDic = [categoryDic objectForKey:caseTypeID];
        caseCell.typeLbl.text = [NSString stringWithFormat:@"类型：%@",caseTypeDic[@"name"]];
        NSArray *lawAr      = [dicInfo objectForKey:@"intention"];
        NSString *lawInfo   = @"";
        for(NSString *lawIntandID in lawAr)
        {
            NSDictionary *replyLaw = [dicInfo objectForKey:@"intentionReply"];
            NSDictionary *lawDicInfo = [lawDic objectForKey:lawIntandID];
            NSString     *lawName    = [lawDicInfo objectForKey:@"name"];
            if([replyLaw.allKeys containsObject:lawIntandID])
            {
                lawInfo = [NSString stringWithFormat:@"%@%@(已回复)",lawInfo,lawName];
            }
            else
            {
                lawInfo = [NSString stringWithFormat:@"%@%@",lawInfo,lawName];
            }
            if(![[lawAr lastObject] isEqualToString:lawIntandID])
            {
                lawInfo = [NSString stringWithFormat:@"%@,",lawInfo];
            }
        }
        caseCell.expectLawerLbl.text = [NSString stringWithFormat:@"意向律师：%@",lawInfo];
        caseCell.codeLbl.text = [NSString stringWithFormat:@"案件编号：%@",numString];
        caseCell.timeLbl.text = timeString;
        if([roleString isEqualToString:@"1"])
        {
            caseCell.roleLbl.text = @"角色：原告";
        }
        else
        {
            caseCell.roleLbl.text = @"角色：被告";
        }
        
        if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"1"])
        {
            caseCell.statusLbl.text = @"状态：双方切磋";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"0"])
        {
            caseCell.statusLbl.text = @"状态：双方切磋";
        }

        else if([statusString isEqualToString:@"1"]&&[stageString isEqualToString:@"1"])
        {
            caseCell.statusLbl.text = @"状态：托管代理费";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"2"])
        {
            caseCell.statusLbl.text = @"状态：签署诉讼&代理文件";
        }
        else if([statusString isEqualToString:@"1"]&&[stageString isEqualToString:@"2"])
        {
            caseCell.statusLbl.text = @"状态：签署诉讼&代理文件";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"3"])
        {
            caseCell.statusLbl.text = @"状态：法院受理";
        }
        else if([statusString isEqualToString:@"1"]&&[stageString isEqualToString:@"3"])
        {
            caseCell.statusLbl.text = @"状态：法院受理";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"4"])
        {
            caseCell.statusLbl.text = @"状态：开庭";
        }
        else if([statusString isEqualToString:@"1"]&&[stageString isEqualToString:@"4"])
        {
            caseCell.statusLbl.text = @"状态：开庭";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"5"])
        {
            caseCell.statusLbl.text = @"状态：判决";
        }
        else if([statusString isEqualToString:@"1"]&&[stageString isEqualToString:@"5"])
        {
            caseCell.statusLbl.text = @"状态：判决";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"7"])
        {
            caseCell.statusLbl.text = @"状态：案件调解/撤诉";
        }
        else if([statusString isEqualToString:@"1"]&&[stageString isEqualToString:@"7"])
        {
            caseCell.statusLbl.text = @"状态：案件调解/撤诉";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"6"])
        {
            caseCell.statusLbl.text = @"状态：已结束";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"8"])
        {
            caseCell.statusLbl.text = @"状态：已调解或撤诉";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"9"])
        {
            caseCell.statusLbl.text = @"状态：委托解除";
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"10"])
        {
            caseCell.statusLbl.text = @"状态：提出异议";
        }
        else
        {
            caseCell.statusLbl.text = @"状态：已撤销";
        }
        
        if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"1"])
        {
            
        }
        else if([statusString isEqualToString:@"1"]&&[stageString isEqualToString:@"1"])
        {
            
        }
        else if([statusString isEqualToString:@"0"]&&[stageString isEqualToString:@"0"])
        {
            
        }
        else
        {
            if([dicInfo.allKeys containsObject:@"lawyer"])
            {
                NSString *expectLawerID = [dicInfo objectForKey:@"lawyer"];
                NSDictionary *lawDicInfos = [lawDic objectForKey:expectLawerID];
                if([lawDic objectForKey:expectLawerID]==nil)
                {
                    caseCell.expectLawerLbl.text = [NSString stringWithFormat:@"受理律师："];
                }
                caseCell.expectLawerLbl.text = [NSString stringWithFormat:@"受理律师：%@",lawDicInfos[@"name"]];
                NSString *timeString = [NSString stringWithFormat:@"更新时间：%@",[self dateFromISODateString:[dicInfo objectForKey:@"updateAt"]] ];
                caseCell.timeLbl.text = timeString;
            }
        }
        
        return caseCell;

    }
    else
    {
        NSString *typeString      = [dicInfo objectForKey:@"type"];
        NSString *createAt        = [dicInfo objectForKey:@"createAt"];
        NSString *statusString    = [dicInfo objectForKey:@"status"];
       
        NSDictionary *cateSubDic  = [categoryDic objectForKey:typeString];
        
        NSString *firstRowString  = [cateSubDic objectForKey:@"name"];
        [cell.statusLbl setHidden:NO];
        [cell.statusImage setHidden:NO];
        if([statusString isEqualToString:@"1"])
        {
            cell.statusLbl.text = @"起草";
            cell.statusImage.backgroundColor = ONECOLOR;
        }
        else if([statusString isEqualToString:@"2"])
        {
            cell.statusLbl.text = @"完成";
            cell.statusImage.backgroundColor = TWOCOLOR;
        }
        else
        {
            [cell.statusImage setHidden:YES];
            [cell.statusLbl  setHidden:YES];
        }
        cell.firstRowLbl.text   = firstRowString;
        cell.secondRowLbl.text  = [NSString stringWithFormat:@"提交时间 ：%@",[self dateFromISODateString:createAt]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicInfo = [dataForTV objectAtIndex:indexPath.row];
    dicForDetail = dicInfo;
    if(_currentType == SecondDraftType)
    {
        isShowDetail = YES;
        [self performSegueWithIdentifier:@"addNewContract" sender:self];
    }
    else if(_currentType == SecondAuditType)
    {
        UIStoryboard *story                   = [UIStoryboard storyboardWithName:@"ZXY_NewServiceStory" bundle:nil];
        ZXY_NewAuditContractVC *auditContract = [story instantiateInitialViewController];
        [auditContract setAuditInfo:dicInfo];
        [self.navigationController pushViewController:auditContract animated:YES];
    }
    else if (_currentType == SecondLetterType)
    {
        isShowDetail = YES;
        [self performSegueWithIdentifier:@"toLetterAdd" sender:self];
    }
    else if(_currentType == SecondCaseType)
    {
        isShowDetail = YES;
        
        [self performSegueWithIdentifier:@"toAddCase" sender:dicInfo];
    }
}

- (NSString *)dateFromISODateString:(NSString *)isodate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"];
    NSDate *currentDate = [dateFormatter dateFromString:isodate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
   
    NSString *stringDate    =    [dateFormatter stringFromDate:currentDate];
    return stringDate;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"addNewContract"])
    {
        ZXY_ServiceContractAddVC *contractVc = [segue destinationViewController];
        if(isShowDetail)
        {
            [contractVc isDetailView:dicForDetail];
        }
    }
    if([segue.identifier isEqualToString:@"toLetterAdd"])
    {
        ZXY_LetterAddVC *letter = [segue destinationViewController];
        if(isShowDetail)
        {
            [letter setLetterDetail:dicForDetail];
        }
    }
    if([segue.identifier isEqualToString:@"toAddCase"])
    {
        ZXY_AddCaseVC *addCase = [segue destinationViewController];
        if(isShowDetail)
         {
             [addCase startFromCaseID:sender[@"_id"] andStage:sender[@"stage"] withStatud:sender[@"status"]];
         }
        else
        {
            addCase.title = @"案件委托";
            [addCase.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        }
    }
}



- (IBAction)addMyCase:(id)sender {
    if(_currentType == SecondCaseType)
    {
        [self performSegueWithIdentifier:@"toAddCase" sender:self];
    }
}
@end
