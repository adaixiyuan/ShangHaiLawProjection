//
//  ZXY_LawerListVC.m
//  LawProjection
//
//  Created by 宇周 on 14/10/27.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_LawerListVC.h"
#import "ZXY_LawListCell.h"
#import "MJRefresh.h"
#import "ZXY_UserLoginVC.h"
#import <AFNetworking/AFNetworking.h>
#import "LCYLawyerDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZXY_AddCaseVC.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ZXY_LawerListVC ()<UITableViewDataSource,UITableViewDelegate,ZXY_LawListDelegate>
{
    NSArray *dataForTV;
    NSDictionary *urlParameter;
    NSInteger limitInt;
    NSInteger skipInt;
    NSInteger unitForDown;
    NSInteger maxInt;
    NSInteger maxNum;
    __weak IBOutlet UITableView *currentTV;
    NSDictionary *dataJson;
    __weak IBOutlet UIButton *submitBtn;
    NSMutableArray *isSelectArr;
    BOOL _isChoose;
}
- (IBAction)submitAction:(id)sender;
@end

@implementation ZXY_LawerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initData];
    [self initTableFooter];
    [self startLoad];
    if(_isChoose)
    {
        [submitBtn setTitle:@"选择律师" forState:UIControlStateHighlighted];
        [submitBtn setTitle:@"选择律师" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"查找律师" withPositon:1];
    UIColor *naviColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:naviColor forKey:NSForegroundColorAttributeName]];
    [self setRightNaviItem:@"home_phone"];
}

- (void)initData
{
    unitForDown = 5;
    skipInt = 0;
    limitInt = unitForDown;
    isSelectArr = [[NSMutableArray alloc] init]
    ;
}

- (void)initTableFooter
{
    [currentTV addFooterWithCallback:^{
        skipInt++;
        if(skipInt<maxInt)
        {
            if(skipInt==maxInt-1)
            {
                limitInt = maxNum%maxInt;
                if(limitInt>=0)
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

- (void)setURLParameters:(NSDictionary *)parameter
{
    urlParameter = [NSDictionary dictionaryWithDictionary:parameter];
}

- (void)startLoad
{
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    NSString *urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&limit=%d&skip=%d",API_HOST_URL,API_LAWERLIST_URL,afterCSRF,limitInt,skipInt];
    [self startLoadDataGET:urlString withParameter:urlParameter successBlock:^(NSData *responsData) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingMutableLeaves error:nil];
        dataJson  = [jsonDic objectForKey:@"data"];
        dataForTV = [dataJson objectForKey:@"items"];
        NSNumber *totalNum = [dataJson objectForKey:@"totalItems"];
        maxNum = totalNum.integerValue;
        
        if(maxNum%unitForDown==0)
        {
            maxInt = maxNum/unitForDown;
        }
        else
        {
            maxInt= maxNum/unitForDown+1;
        }
        [currentTV footerEndRefreshing];
        [currentTV reloadData];
    } errorBlock:^(NSError *errorInfo) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        loginVC.onComplete = ^()
        {
            [self startLoad];
        };
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
    
}

#pragma mark TableView 代理与数据源

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
    return 103;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_LawListCell *cell = [tableView dequeueReusableCellWithIdentifier:LawListCellID];
    NSDictionary *currentDic = [dataForTV objectAtIndex:indexPath.row];
    NSDictionary *extendDic  = [currentDic objectForKey:@"extend"];
    NSArray *photeDic   = [extendDic objectForKey:@"workPhoto"] ;
    NSString     *photoID    = [[photeDic objectAtIndex:0] objectForKey:@"fileId"];
    //NSString *idString       = [currentDic objectForKey:@"id"];
    cell.delegate = self;
    cell.nameLbl.text      = [currentDic objectForKey:@"name"];
    cell.keywordLbl.text   = [currentDic objectForKey:@"expertiseName"];
    cell.introduceLbl.text = [extendDic objectForKey:@"profile"];
    cell.currentLawyer         = currentDic;
    NSString *urlString    = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,photoID];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:urlString]];
    if([isSelectArr containsObject:currentDic])
    {
        //cell.selectImage.image = [UIImage imageNamed:@"chooseLawer_select"];
        [cell.selectImage setImage:[UIImage imageNamed:@"chooseLawer_select"] forState:UIControlStateNormal];
        [cell.selectImage setImage:[UIImage imageNamed:@"chooseLawer_select"] forState:UIControlStateHighlighted];
    }
    else
    {
        //cell.selectImage.image = [UIImage imageNamed:@"chooseLawer"];
        [cell.selectImage setImage:[UIImage imageNamed:@"chooseLawer"] forState:UIControlStateNormal];
        [cell.selectImage setImage:[UIImage imageNamed:@"chooseLawer"] forState:UIControlStateHighlighted];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *currentDic = dataForTV[indexPath.row];
    NSString *currentID = currentDic[@"_id"];
    UIStoryboard *icyStoryboard = [UIStoryboard storyboardWithName:@"LCYLawyerDetail" bundle:nil];
    LCYLawyerDetailViewController *lawyerDetailVC = [icyStoryboard instantiateInitialViewController];
    lawyerDetailVC.lawyerID = currentID;
    [self.navigationController pushViewController:lawyerDetailVC animated:YES];
}

- (void)selectCurrentLaw:(NSDictionary *)currentLaw
{
    if([isSelectArr containsObject:currentLaw])
    {
        [isSelectArr removeObject:currentLaw];
    }
    else
    {
        if(isSelectArr.count == 3)
        {
            [isSelectArr removeObjectAtIndex:0];
        }
        [isSelectArr addObject:currentLaw];
    }
    [currentTV reloadData];
}

- (void)setIsChoose:(BOOL)isChoose
{
    _isChoose = isChoose;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAction:(id)sender {
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
        //[self performSegueWithIdentifier:@"toLoginVC" sender:self];
        return;
        
    }
    
    
    if(_isChoose)
    {
        NSArray *allNaviVCS = [self.navigationController viewControllers];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lawyersNoti" object:isSelectArr];
        [self.navigationController popToViewController:[allNaviVCS objectAtIndex:(allNaviVCS.count-3)] animated:YES];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *stringURL = [NSString stringWithFormat:@"%@user/getRegInfo",API_HOST_URL];
        [self startLoadDataGETCSRF:stringURL withPatameter:nil successBlock:^(NSData *responseData) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if([userInfo.allKeys containsObject:@"error"])
            {
                [self performSelector:@selector(toLoginView) withObject:nil afterDelay:1];
                [[UserInfoDetail sharedInstance] userLogOut];
            }
            else
            {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
                ZXY_AddCaseVC *caseAdd       = [story instantiateViewControllerWithIdentifier:@"caseAddVCID"];
                caseAdd.title = @"案件委托";
                [caseAdd.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
                [caseAdd setLawyerList:isSelectArr];
                [self.navigationController pushViewController:caseAdd animated:YES];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSelector:@selector(toLoginView) withObject:nil afterDelay:1];
            [[UserInfoDetail sharedInstance] userLogOut];
        }];

        
    }
}

- (void)toLoginView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
    ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
    [self.navigationController pushViewController:loginVC animated:YES];
    //[self performSegueWithIdentifier:@"toLoginVC" sender:self];
    return;
}



@end
