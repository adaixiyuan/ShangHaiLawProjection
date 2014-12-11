//
//  ZXY_UserServiceListVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserServiceListVC.h"
#import "ZXY_UserServiceListCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "UserInfoDetail.h"
#import "LawEntityHelper.h"
#import "UserServiceInfo.h"
#import "AllServiceType.h"
#import "ZXY_UserLoginVC.h"
#import "ZXY_FirstSctionDetailInfoVC.h"
#import "ZXY_SecondSectionDetailInfoVC.h"


@interface ZXY_UserServiceListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataForTV;
    BOOL needWait;
    SecondSectionType secondType;
    FirstSectionType  firstType;
}
@property (weak, nonatomic) IBOutlet UITableView *currentTableV;

@end

@implementation ZXY_UserServiceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    dataForTV = [[NSArray alloc] init];
    NSArray *allServiceInfo = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"UserServiceInfo"];
    dataForTV = [dataForTV arrayByAddingObjectsFromArray:allServiceInfo];
    if(dataForTV.count>0)
    {
        [self.currentTableV reloadData];
        needWait = NO;
    }
    else
    {
        needWait = YES;
    }
    [self startLoad];
}

- (void)reloadDataOfTable
{
    NSArray *allServiceInfo = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"UserServiceInfo"];
    dataForTV = [NSArray arrayWithArray:allServiceInfo];
    [self.currentTableV reloadData];
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"服务管理" withPositon:1];
    [self setRightNaviItem:@"home_phone"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *allServiceInfo = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"UserServiceInfo"];
    dataForTV = [NSArray arrayWithArray:allServiceInfo];
    return [dataForTV count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allServiceInfo = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"UserServiceInfo"];
    dataForTV = [NSArray arrayWithArray:allServiceInfo];

    ZXY_UserServiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:UserServiceListCellID];
    UserServiceInfo *currentInfo = [dataForTV objectAtIndex:indexPath.row];
    AllServiceType *type = currentInfo.toAllServiceType;
    NSLog(@"%@",type.translation);
    NSInteger currentRow = indexPath.row;
    if(currentRow == 0)
    {
        cell.titleImageView.image = [UIImage imageNamed:@"service_Consult"];
        
    }
    else if (currentRow == 1)
    {
        cell.titleImageView.image = [UIImage imageNamed:@"service_letter"];
    }
    else if (currentRow == 2)
    {
        cell.titleImageView.image = [UIImage imageNamed:@"service_draft"];
    }
    else if (currentRow == 3)
    {
        cell.titleImageView.image = [UIImage imageNamed:@"service_audit"];
    }
    else
    {
        cell.titleImageView.image = [UIImage imageNamed:@"service_lecture"];
    }
    if([currentInfo.serviceType isEqualToString:@"ST0001"])
    {
        if(currentInfo.remainAmounttotal.integerValue>19999)
        {
            cell.lastLbl.text = [NSString stringWithFormat:@"剩余数量 无限次"];
        }
        else
        {
            cell.lastLbl.text = currentInfo.remainAmounttotal.stringValue;
        }
    }
    else
    {
        cell.lastLbl.text = [NSString stringWithFormat:@"剩余数量 %@%@",currentInfo.remainAmounttotal,currentInfo.unit];
    }
    cell.titleLbl.text        = currentInfo.serviceTypeName;
    cell.needToLbl.text       = [NSString stringWithFormat:@"进行中的数量 %@%@",currentInfo.usingAmounttotal,currentInfo.unit];
    cell.realFinishLbl.text   = [NSString stringWithFormat:@"已完成数量 %@%@",currentInfo.usedAmounttotal,currentInfo.unit];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow = indexPath.row;
    if(currentRow == 1)
    {
        secondType = SecondLetterType;
        [self performSegueWithIdentifier:@"toSecondSectionVC" sender:self];
    }
    else if (currentRow ==2)
    {
        secondType = SecondDraftType;
        [self performSegueWithIdentifier:@"toSecondSectionVC" sender:self];
    }
    else if ( currentRow == 3)
    {
        secondType = SecondAuditType;
        [self performSegueWithIdentifier:@"toSecondSectionVC" sender:self];
    }
    else if (currentRow == 4)
    {
        firstType = LawTrainType;
        [self performSegueWithIdentifier:@"toFirstSectionVC" sender:self];
    }
    else
    {
        firstType = LawConsultType;
        [self performSegueWithIdentifier:@"toFirstSectionVC" sender:self];
    }
}

// !!!: 开始下载数据
- (void)startLoad
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    if(needWait){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *csrfToken = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *realCSRF  = [ZXY_APIFiles encode:csrfToken];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?_csrf=%@",API_HOST_URL,API_SERVICE_LIST_URL,realCSRF];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(needWait){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        NSData *data = [operation responseData];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if([dic.allKeys containsObject:@"error"])
        {
            NSDictionary *errorDic = [dic objectForKey:@"error"];
           // NSString *codeString   = [errorDic objectForKey:@"code"];
            NSString *errorInfo    = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:@"" andContent:errorInfo];
        }
        else
        {
            NSDictionary *allHeader = operation.response.allHeaderFields;
            NSString *csrftoken     = [ZXY_APIFiles getCSRFToken:allHeader];
            [[UserInfoDetail sharedInstance] setOthersInfo:csrftoken withKey:ZXY_VALUES_CSRF];
            NSData *returnData = [operation responseData];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
            NSArray *saveArr = [jsonDic objectForKey:@"data"];
            [LawEntityHelper saveUserServiceInfo:saveArr];
             
            [self reloadDataOfTable];
        }
        NSLog(@"%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self performSegueWithIdentifier:@"toLoginVC" sender:self];
        if(needWait){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        NSLog(@"%@",error);
    }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toLoginVC"])
    {
        ZXY_UserLoginVC *loginVC = [segue destinationViewController];
        loginVC.onComplete = ^(){
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    else if ([segue.identifier isEqualToString:@"toSecondSectionVC"])
    {
        ZXY_SecondSectionDetailInfoVC *secondVC = [segue destinationViewController];
        [secondVC setSecondSectionType:secondType];
    }
    else
    {
        ZXY_FirstSctionDetailInfoVC *firstVC    = [segue destinationViewController];
        [firstVC setFirstSectionType:firstType];
    }

}


@end
