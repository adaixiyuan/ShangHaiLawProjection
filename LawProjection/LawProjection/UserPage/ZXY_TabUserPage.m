//
//  ZXY_TabUserPage.m
//  LawProjection
//
//  Created by developer on 14-9-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_TabUserPage.h"
#import "UIViewController+ZXY_VCCategory.h"
#import "ZXY_UserLawListTVCell.h"
#import "UserInfoDetail.h"
#import "ZXY_FirstSctionDetailInfoVC.h"
#import "ZXY_SecondSectionDetailInfoVC.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ZXY_TabUserPage ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    __weak IBOutlet UITableView *currentTV;
    NSDictionary *dataForTable;
    FirstSectionType _selectionType;
    SecondSectionType _secondeType;
    NSString *trackURL;
}
@end

@implementation ZXY_TabUserPage

- (void)viewDidLoad {

    [super viewDidLoad];
    [self initNavi];
    [self initData];
    
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:@"我的" withPositon:1 ];
    NSString *rightTitle = @"";
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
       rightTitle = @"登录";
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 80 , 30)];
        leftBtn.layer.cornerRadius = 4;
        leftBtn.layer.masksToBounds= YES;
        leftBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        leftBtn.layer.borderWidth  = 1;
        [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [leftBtn setTitle:rightTitle forState:UIControlStateNormal];
        [leftBtn setTitle:rightTitle forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(setNaviRightAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.rightBarButtonItem = item;

    }
    else
    {
//        rightTitle = @"个人信息";
//        [self.navigationItem.rightBarButtonItem ]
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *rightTitle = @"";
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
        rightTitle = @"登录";
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 80 , 30)];
        leftBtn.layer.cornerRadius = 4;
        leftBtn.layer.masksToBounds= YES;
        leftBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        leftBtn.layer.borderWidth  = 1;
        [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [leftBtn setTitle:rightTitle forState:UIControlStateNormal];
        [leftBtn setTitle:rightTitle forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(setNaviRightAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.rightBarButtonItem = item;
    }
    else
    {
        
        self.navigationItem.rightBarButtonItem = nil;
    }

    [currentTV reloadData];
}

- (void)setNaviRightAction
{
    NSLog(@"ok");
    BOOL isUserLogin = [[UserInfoDetail sharedInstance] isUserLogin];
    if(isUserLogin)
    {
        [self performSegueWithIdentifier:@"toUserInfoListVC" sender:self];
    }
    else
    {
        [self startLoginView];
    }
}

- (void)initData
{
    NSURL *pathDicFile = [[NSBundle mainBundle] URLForResource:@"UserInfoService" withExtension:@"plist"];
    dataForTable = [[NSDictionary alloc] initWithContentsOfURL:pathDicFile];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        NSArray *sectionOneArr = [dataForTable objectForKey:@"section1"];
        if([[UserInfoDetail sharedInstance] isUserLogin])
        {
            return sectionOneArr.count;
        }
        else
        {
            return sectionOneArr.count-1;
        }
        
    }
    else if(section == 1)
    {
        NSArray *sectionTwoArr = [dataForTable objectForKey:@"section2"];
        return sectionTwoArr.count;
    }
    else
    {
        NSArray *sectionThreeArr = [dataForTable objectForKey:@"section3"];
        return sectionThreeArr.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_UserLawListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:UserLawListTVCellID];
    if(indexPath.section == 0)
    {
        NSArray *sectionOneArr = [dataForTable objectForKey:@"section1"];
        NSDictionary *currentDic ;
        if([[UserInfoDetail sharedInstance] isUserLogin])
        {
            currentDic = [sectionOneArr objectAtIndex:indexPath.row];
        }
        else
        {
            currentDic = [sectionOneArr objectAtIndex:indexPath.row+1];

        }
        
        cell.titleLBL.text = [currentDic objectForKey:@"name"];
    }
    else if (indexPath.section == 1)
    {
        NSArray *sectionTwoArr = [dataForTable objectForKey:@"section2"];
        NSDictionary *currentDic = [sectionTwoArr objectAtIndex:indexPath.row];
        cell.titleLBL.text = [currentDic objectForKey:@"name"];
    }
    else
    {
        NSArray *sectionTwoThree = [dataForTable objectForKey:@"section3"];
        NSDictionary *currentDic = [sectionTwoThree objectAtIndex:indexPath.row];
        cell.titleLBL.text = [currentDic objectForKey:@"name"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row ==0 && indexPath.section == 0)
//    {
//        BOOL isUserLogin = [[UserInfoDetail sharedInstance] isUserLogin];
//        if(isUserLogin)
//        {
//            [self performSegueWithIdentifier:@"toUserInfoListVC" sender:self];
//        }
//        else
//        {
//            [self startLoginView];
//        }
//
//    }
    if(indexPath.section == 2 && indexPath.row == 1)
    {
        // 关于法律
        UIStoryboard *icyStoryboard = [UIStoryboard storyboardWithName:@"LCYAboutLaw" bundle:nil];
        [self.navigationController pushViewController:icyStoryboard.instantiateInitialViewController animated:YES];
        return;
//        [self performSegueWithIdentifier:@"toAboutVC" sender:self];
//        return;
    }
    if([[UserInfoDetail sharedInstance] isUserLogin])
    {
        NSInteger currentRow = indexPath.row;
        NSInteger currentSection = indexPath.section;
        if(currentRow == 0 && currentSection == 0)
        {
            [self performSegueWithIdentifier:@"toUserInfoListVC" sender:self];
        }
        else if(currentRow == 1 && currentSection == 0)
        {
//            _selectionType = UserOrderType;
//            [self performSegueWithIdentifier:@"toFirstSection" sender:self];
            // 我的订单
            UIStoryboard *icyStoryboard = [UIStoryboard storyboardWithName:@"LCYOrderList" bundle:nil];
            [self.navigationController pushViewController:icyStoryboard.instantiateInitialViewController animated:YES];
            return;
        }
        else if (currentRow == 2&& currentSection ==0)
        {
            [self performSegueWithIdentifier:@"toServiceListVC" sender:self];
        }
        else if (currentRow == 0 && currentSection ==1)
        {
            _selectionType = LawConsultType;
            [self performSegueWithIdentifier:@"toFirstSection" sender:self];
        }
        else if (currentSection == 1&&currentRow == 4)
        {
            _selectionType = LawTrainType;
            [self performSegueWithIdentifier:@"toFirstSection" sender:self];
        }
        else if (currentRow == 5 && currentSection ==1)
        {
            _secondeType = SecondCaseType;
            [self performSegueWithIdentifier:@"toSecondSectionVC" sender:self];
        }
        else if (currentRow == 1&&currentSection == 1)
        {
            _secondeType   = SecondLetterType;
            [self performSegueWithIdentifier:@"toSecondSectionVC" sender:self];
            // 签发律师函
//            UIStoryboard *icyStoryboard = [UIStoryboard storyboardWithName:@"LCYLawyerLetter" bundle:nil];
//            [self.navigationController pushViewController:icyStoryboard.instantiateInitialViewController animated:YES];
//            return;
        }
        else if (currentSection == 1 &&currentRow == 3)
        {
            _secondeType   = SecondAuditType;
            [self performSegueWithIdentifier:@"toSecondSectionVC" sender:self];
        }
        else if(currentRow == 2&&currentSection ==1)
        {
            _secondeType = SecondDraftType;
            [self performSegueWithIdentifier:@"toSecondSectionVC" sender:self];
        }
        else if(currentRow == 0&&currentSection == 2)
        {
            [self performSegueWithIdentifier:@"toActiveVC" sender:self];
        }
        else if(currentRow == 2&&currentSection == 2)
        {
            [self toUpdateView];
        }
    }
    else
    {
        [self startLoginView];
    }
}

- (void)toUpdateView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=945218505"]]];
    [request setHTTPMethod:@"GET"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSString *latestVersion = [jsonData objectForKey:@"version"];
   trackURL = [jsonData objectForKey:@"trackViewUrl"];//地址trackViewUrl
    NSString *trackName = [jsonData objectForKey:@"trackName"];//trackName
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    double doubleCurrentVersion = [currentVersion doubleValue];
    double doubleUpdateVersion  = latestVersion.doubleValue;
    if (doubleCurrentVersion < doubleUpdateVersion) {
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:trackName
                                           message:@"有新版本，是否升级！"
                                          delegate: self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles: @"升级", nil];
        alert.tag = 1001;
        [alert show];
    }
    else{
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:trackName
                                           message:@"暂无新版本"
                                          delegate: nil
                                 cancelButtonTitle:@"好的"
                                 otherButtonTitles: nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackURL]];
    }
}

- (void)startLoginView
{
    [self performSegueWithIdentifier:@"toLoginVC" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toFirstSection"])
    {
        ZXY_FirstSctionDetailInfoVC *firstSction = [segue destinationViewController];
        [firstSction setFirstSectionType:_selectionType];
    }
    if([segue.identifier isEqualToString:@"toSecondSectionVC"])
    {
        ZXY_SecondSectionDetailInfoVC *secondSection = [segue destinationViewController];
        [secondSection setSecondSectionType:_secondeType];
    }
}


@end
