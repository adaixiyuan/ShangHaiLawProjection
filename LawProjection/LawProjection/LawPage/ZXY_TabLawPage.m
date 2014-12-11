//
//  ZXY_TabLawPage.m
//  LawProjection
//
//  Created by developer on 14-9-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_TabLawPage.h"
#import "UIViewController+ZXY_VCCategory.h"
#import "ZXY_SearchLawerVC.h"
#import "ZXY_UserLoginVC.h"
#import "ZXY_SecondSectionDetailInfoVC.h"
#import "ZXY_AddCaseVC.h"

@interface ZXY_TabLawPage ()
{
    NSDictionary *listDic;
    __weak IBOutlet UILabel *firstRow;
    __weak IBOutlet UILabel *secondRow;
    __weak IBOutlet UIButton *moreCaseBtn;
    __weak IBOutlet UIButton *searBtn;
}
- (IBAction)moreCaseAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *moreInfo;
- (IBAction)moreCaseListAction:(id)sender;
@end

@implementation ZXY_TabLawPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self setNaviTitleImage:@"home_law"];
    [self setRightNaviItem:@"home_phone"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startLoad];
}

- (void)initView
{
    moreCaseBtn.layer.cornerRadius = 4;
    moreCaseBtn.layer.masksToBounds=YES;
    searBtn.layer.cornerRadius     = 4;
    searBtn.layer.masksToBounds    = YES;
}

- (IBAction)searchLawerAction:(id)sender
{
//    if([[UserInfoDetail sharedInstance] isUserLogin])
//    {
        [self performSegueWithIdentifier:@"toSearchLawVC" sender:self];
//    }
//    else
//    {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
//        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
////        loginVC.onComplete = ^(){
////            [self performSegueWithIdentifier:@"toSearchLawVC" sender:self];
////        };
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
}

- (void)startLoad
{
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
        firstRow.text = @"";
        secondRow.text = @"";
        [moreCaseBtn setEnabled:NO];
        return;
    }
    [moreCaseBtn setEnabled:NO];
    NSString *urlString  = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_USER_CASE_LIST];
    NSDictionary *parameter = @{
                                @"filter":@"delegate",
                                @"skip"  :[NSNumber numberWithInt:0],
                                @"limit" :[NSNumber numberWithInt:2],
                                @"type"  :@"customer"
                                };
    [self startLoadDataGETCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if(![returnDic.allKeys containsObject:@"data"])
        {
            [[UserInfoDetail sharedInstance] userLogOut];
        }
        else
        {
            listDic = [returnDic objectForKey:@"data"];
            NSArray *allArr = [listDic objectForKey:@"items"];
            for(int i = 0;i<allArr.count;i++)
            {
                NSDictionary *currentDic = [allArr objectAtIndex:i];
                NSString *createTime     = [self dateFromISODateString: currentDic[@"createAt"]];
                if(i == 0)
                {
                    firstRow.text = [NSString stringWithFormat:@"案件编号：%@  提交时间：%@",currentDic[@"num"],createTime];
                }
                if(i == 1)
                {
                    secondRow.text = [NSString stringWithFormat:@"案件编号：%@  提交时间：%@",currentDic[@"num"],createTime];
                }
                
            }
            [moreCaseBtn setEnabled:YES];
        }
    } errorBlock:^(NSError *error) {
        [[UserInfoDetail sharedInstance] userLogOut];
        [moreCaseBtn setEnabled:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
}


- (IBAction)moreCaseAction:(id)sender {
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
        //[self performSegueWithIdentifier:@"toLoginVC" sender:self];
        return;
        
    }
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
    ZXY_AddCaseVC *caseAdd       = [story instantiateViewControllerWithIdentifier:@"caseAddVCID"];
    caseAdd.title = @"案件委托";
    [caseAdd.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self.navigationController pushViewController:caseAdd animated:YES];
}

- (IBAction)moreCaseListAction:(id)sender {
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
        //[self performSegueWithIdentifier:@"toLoginVC" sender:self];
        return;
    }
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
    ZXY_SecondSectionDetailInfoVC *second = [story instantiateViewControllerWithIdentifier:@"secondSectionID"];
    [second setSecondSectionType:SecondCaseType];
    [self.navigationController pushViewController:second animated:YES];
    
}

- (NSString *)dateFromISODateString:(NSString *)isodate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"];
    NSDate *currentDate = [dateFormatter dateFromString:isodate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *stringDate    =    [dateFormatter stringFromDate:currentDate];
    return stringDate;
}

@end
