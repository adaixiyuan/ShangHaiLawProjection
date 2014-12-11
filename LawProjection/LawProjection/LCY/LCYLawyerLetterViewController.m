//
//  LCYLawyerLetterViewController.m
//  LawProjection
//
//  Created by eagle on 14/10/31.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYLawyerLetterViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "LCYLawyerLetterCell.h"
#import "LCYNewLetterModel.h"
#import "LCYCommon.h"
#import "LCYNetworking.h"
#import "MJRefresh.h"
#import "LCYLawyerNewLetterViewController.h"

#pragma mark - 简化数据

@interface LCYLawyerLetterSimplifiedData : NSObject

@property (strong, nonatomic) NSString *receiver;

@property (strong, nonatomic) NSString *commitTime;

@property (nonatomic) LCYLawyerLetterStatus status;

@property (nonatomic) LCYNewLetterType type;


@end

@implementation LCYLawyerLetterSimplifiedData


@end


#pragma mark -

@interface LCYLawyerLetterViewController () <UITableViewDelegate, UITableViewDataSource>

/**
 *  需要显示的数据
 */
@property (copy, nonatomic) NSArray *listData;

/**
 *  数据选项
 */
@property (copy, nonatomic) NSDictionary *options;

/**
 *  简化显示数据
 */
@property (copy, nonatomic) NSArray *simplifiedData;


@property (nonatomic) BOOL firstOnLoad;

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bottomBarButtonItem;

@property (nonatomic) NSInteger skip;

@property (nonatomic) NSInteger limit;

@end

@implementation LCYLawyerLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.skip = 0;
    self.limit = 5;
    
    // 导航栏电话
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // TODO: 加上打电话点击事件
    [rightBarButton setImage:[UIImage imageNamed:@"home_phone"] forState:UIControlStateNormal];
    [rightBarButton sizeToFit];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    // 返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton addTarget:self action:@selector(backNavigation:) forControlEvents:UIControlEventTouchUpInside];
    [backBarButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backBarButton sizeToFit];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
    
    // 导航栏中间
    [self.navigationItem setTitle:@"签发律师函"];
    
    // 去掉多余的线
    [self.icyTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    __weak __typeof(self) weakSelf = self;
    [self.icyTableView addHeaderWithCallback:^{
        [weakSelf refreshData];
    }];
    [self.icyTableView addFooterWithCallback:^{
        [weakSelf appendData];
    }];
    [self.icyTableView setHeaderRefreshingText:@"正在刷新中......"];
    [self.icyTableView setFooterRefreshingText:@"正在加载......"];
    
    self.firstOnLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self refreshData];
    // 刷新法律服务剩余数量
    [self.bottomBarButtonItem setEnabled:NO];
    __weak __typeof(self) weakSelf = self;
    [[LCYNetworking sharedInstance] getRequestWithApi:@"service/sumList" parameters:nil success:^(NSDictionary *responseObject) {
        NSArray *resultArray = responseObject[@"data"];
        NSString *integerString;
        for (NSDictionary *oneDictionary in resultArray) {
            if ([oneDictionary[@"serviceTypeName"] isEqualToString:@"签发律师函"]) {
                integerString = oneDictionary[@"remainAmounttotal"];
                break;
            }
        }
        if (integerString) {
            NSInteger remainCount = [integerString integerValue];
            if (remainCount > 0) {
                weakSelf.bottomBarButtonItem.title = [NSString stringWithFormat:@"新的签发（%@）",[NSNumber numberWithInteger:remainCount]];
                [weakSelf.bottomBarButtonItem setEnabled:YES];
            }
        }
    } failed:^{
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backNavigation:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showNew"]) {
        if (sender &&
            [sender isMemberOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = sender;
            LCYLawyerLetterSimplifiedData *simpleData = self.simplifiedData[indexPath.row];
            NSDictionary *fullData = self.listData[indexPath.row];
            LCYLawyerNewLetterViewController *newLetterVC = [segue destinationViewController];
            
            LCYNewLetterModel *model = [[LCYNewLetterModel alloc] init];
            // 类型
            model.type = [fullData[@"type"] isEqualToString:@"CT0001"] ? LCYNewLetterTypeEnterprise : LCYNewLetterTypePersonal;
            // 名字
            if (model.type == LCYNewLetterTypeEnterprise) {
                // 企业
                model.enterprise = fullData[@"corporate"];
                model.receiverName = fullData[@"represents"];
            } else {
                // 个人
                model.receiverName = fullData[@"name"];
            }
            // 电话
            model.telephone = fullData[@"phone"];
            // 省、市、区
            LCYNewLetterLocation *province = [[LCYNewLetterLocation alloc] init];
            province.name = fullData[@"address"][@"province"][@"name"];
            province.icyID = fullData[@"address"][@"province"][@"id"];
            LCYNewLetterLocation *city = [[LCYNewLetterLocation alloc] init];
            city.name = fullData[@"address"][@"city"][@"name"];
            city.icyID = fullData[@"address"][@"city"][@"id"];
            LCYNewLetterLocation *town = [[LCYNewLetterLocation alloc] init];
            town.name = fullData[@"address"][@"town"][@"name"];
            town.icyID = fullData[@"address"][@"town"][@"id"];
            model.province = province;
            model.city = city;
            model.town = town;
            // 详细地址
            model.address = fullData[@"address"][@"streets"];
            // 邮编
            model.postCode = fullData[@"address"][@"postcode"];
            // 问题
            model.question = fullData[@"problem"];
            // 期望
            model.expectation = fullData[@"expectation"];
            // 证据
            NSMutableArray *tempArray = [NSMutableArray array];
            NSArray *envidences = fullData[@"evidences"];
            for (NSDictionary *envidenceInfo in envidences) {
                LCYNewLetterEvidence *info = [[LCYNewLetterEvidence alloc] init];
                info.fileID = envidenceInfo[@"fileId"];
                info.fileName = envidenceInfo[@"fileName"];
                [tempArray addObject:info];
            }
            model.evidence = tempArray;
            // 纪录id
            model.dbIdentifier = fullData[@"_id"];
            
            [newLetterVC configExistModel:model currentStatus:simpleData.status];
        }
    }
}


/**
 *  初始化界面数据
 */
- (void)refreshData {
//    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
//    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
//    NSString *URLString = [NSString stringWithFormat:@"%@%@?_csrf=%@&limit=%d&skip=%d", API_HOST_URL, API_LETTERLIST_URL, afterCSRF, 5, 0];
//   
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    __weak __typeof(self) weakSelf = self;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // 刷新CSRF
//        NSLog(@"%@", operation.responseString);
//        NSDictionary *currentHeader = [operation.response allHeaderFields];
//        NSString *csrfString = [ZXY_APIFiles getCSRFToken:currentHeader];
//        [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
//        
//        // 读取数据
//        weakSelf.listData = [NSArray arrayWithArray:responseObject[@"data"][@"items"]];
//        weakSelf.options = [NSDictionary dictionaryWithDictionary:responseObject[@"data"][@"options"]];
//        [weakSelf simplifyData];
//        
//        [weakSelf reloadTableView];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        // 访问失败，重新获取csrf
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
//        UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"userLoginVC"];
//        [weakSelf.navigationController pushViewController:viewController animated:YES];
//    }];
    
    self.skip = 0;
    NSDictionary *parameters = @{
                                 @"skip":[NSNumber numberWithInteger:self.skip],
                                 @"limit":[NSNumber numberWithInteger:self.limit]
                                 };
    __weak __typeof(self) weakSelf = self;
    [[LCYNetworking sharedInstance] getRequestWithApi:@"letter/list" parameters:parameters success:^(NSDictionary *responseObject) {
        [weakSelf parseResponse:responseObject append:NO];
        weakSelf.skip = weakSelf.limit;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf.icyTableView headerEndRefreshing];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // 访问失败，重新获取csrf
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    }];
}

- (void)appendData {
    NSDictionary *parameters = @{
                                 @"skip":[NSNumber numberWithInteger:self.skip],
                                 @"limit":[NSNumber numberWithInteger:self.limit]
                                 };
    __weak __typeof(self) weakSelf = self;
    [[LCYNetworking sharedInstance] getRequestWithApi:@"letter/list" parameters:parameters success:^(NSDictionary *responseObject) {
        [weakSelf parseResponse:responseObject append:YES];
        weakSelf.skip += weakSelf.limit;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf.icyTableView footerEndRefreshing];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // 访问失败，重新获取csrf
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    }];
}

- (void)parseResponse:(NSDictionary *)object append:(BOOL)append {
    if (!append) {
        self.listData = [NSArray arrayWithArray:object[@"data"][@"items"]];
        self.options = [NSDictionary dictionaryWithDictionary:object[@"data"][@"options"]];
    } else {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.listData];
        [tempArray addObjectsFromArray:object[@"data"][@"items"]];
         self.listData = tempArray;
        NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithDictionary:self.options];
        [tempDictionary addEntriesFromDictionary:object[@"data"][@"options"]];
        self.options = tempDictionary;
    }
    [self simplifyData];
    [self.icyTableView reloadData];
}

- (void)simplifyData {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *oneDic in self.listData) {
        LCYLawyerLetterSimplifiedData *data = [[LCYLawyerLetterSimplifiedData alloc] init];
        if ([oneDic[@"type"] isEqualToString:@"CT0001"]) {
            data.type = LCYNewLetterTypeEnterprise;
            data.receiver = oneDic[@"represents"];
        } else {
            data.type = LCYNewLetterTypePersonal;
            data.receiver = oneDic[@"name"];
        }
        if ([oneDic[@"status"] isEqualToString:@"LS0001"]) {
            data.status = LCYLawyerLetterStatusCommit;
        } else if ([oneDic[@"status"] isEqualToString:@"LS0002"]) {
            data.status = LCYLawyerLetterStatusDraft;
        } else if ([oneDic[@"status"] isEqualToString:@"LS0003"]) {
            data.status = LCYLawyerLetterStatusConfirm;
        } else if ([oneDic[@"status"] isEqualToString:@"LS0004"]) {
            data.status = LCYLawyerLetterStatusSend;
        } else if ([oneDic[@"status"] isEqualToString:@"LS0005"]) {
            data.status = LCYLawyerLetterStatusSavefile;
        }
        NSDate *date = [[LCYCommon sharedInstance] convertDate:oneDic[@"createAt"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日HH:mm"];
        data.commitTime = [formatter stringFromDate:date];
        [tempArray addObject:data];
    }
    self.simplifiedData = [NSArray arrayWithArray:tempArray];
}

- (void)reloadTableView {
    [self.icyTableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.simplifiedData) {
        return 0;
    }
    return [self.simplifiedData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCYLawyerLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerLetterCellIdentifier];
    LCYLawyerLetterSimplifiedData *data = self.simplifiedData[indexPath.row];
    cell.receiverLabel.text = data.receiver;
    cell.timeLabel.text = data.commitTime;
    cell.iconStatus = data.status;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showNew" sender:indexPath];
}

@end
