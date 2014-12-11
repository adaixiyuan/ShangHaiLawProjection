//
//  LCYOrderListViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYOrderListViewController.h"
#import "LCYNetworking.h"
#import "LCYOrderListCell.h"
#import "LCYOrderListModel.h"
#import "LCYCommon.h"
#import "MJRefresh.h"
#import "LCYOrderDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString *const UnParsedProduct = @"无法获取产品信息";

@interface LCYOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_statusKey;
}
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@property (copy, nonatomic) NSArray *icyModels;

@property (nonatomic) NSInteger skip;

@property (nonatomic) NSInteger limit;

@end

@implementation LCYOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.limit = 10;
    self.skip = 0;
    
    [self.navigationItem setTitle:@"我的订单"];
    
    // 隐藏多余的分割线
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.icyTableView setTableFooterView:footView];
    
    __weak __typeof(self) weakSelf = self;
    // 下拉和上拉刷新
    [self.icyTableView addHeaderWithCallback:^{
        [weakSelf refreshData:NO];
    }];
    [self.icyTableView addFooterWithCallback:^{
        [weakSelf refreshData:YES];
    }];
    [self.icyTableView setHeaderRefreshingText:@"正在刷新中......"];
    [self.icyTableView setFooterRefreshingText:@"正在加载......"];
    
    //[self refreshData:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshData:NO];
}
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = sender;
        LCYOrderListModel *model = self.icyModels[indexPath.row];
        LCYOrderDetailViewController *detailVC = [segue destinationViewController];
        detailVC.preOrderModel = model;
    }
}


#pragma mark - Actions
- (void)refreshData :(BOOL)append {
    if (!append) {
        self.skip = 0;
    }
    
    __weak __typeof(self) weakSelf = self;
    NSDictionary *parameters = @{
                                 @"skip":[NSNumber numberWithInteger:self.skip],
                                 @"limit":[NSNumber numberWithInteger:self.limit]
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LCYNetworking sharedInstance] getRequestWithApi:@"order/list" parameters:parameters success:^(NSDictionary *responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *items = responseObject[@"data"][@"items"];
        NSDictionary *statusModel = responseObject[@"data"][@"options"][@"category"];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *data in items) {
            LCYOrderListModel *model = [[LCYOrderListModel alloc] init];
            // 订单编号
            model.orderID = data[@"num"];
            // 下单时间
            NSString *createAt = data[@"createAt"];
            NSDate *createDate = [[LCYCommon sharedInstance] convertDate:createAt];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSDictionary    *zxyUser = responseObject[@"options"][@"user"];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            model.commitTime = [formatter stringFromDate:createDate];
            // 产品类型和名称
            if (data[@"$product"]) {
                // 购买
                model.type = LCYOrderListProductTypeBuy;
                // 产品名
                NSDictionary *productKeyModel = data[@"$product"][@"options"][@"category"];
                NSString *productKey = data[@"$product"][@"nameId"];
                NSString *productValue = productKeyModel[productKey][@"name"];
                // 产品数量
                NSString *count = data[@"count"];
                if([productValue isEqualToString:@"尊享版"]||[productValue isEqualToString:@"标准版"])
                {
                    model.productString = [NSString stringWithFormat:@"购买[%@]",productValue];
                }
                else
                {
                    model.productString = [NSString stringWithFormat:@"购买[%@]X%@",productValue,count];
                }
            } else if (data[@"$caseData"]) {
                // 案件委托
                model.type = LCYOrderListProductTypeDelegate;
                
                // 案件号
                NSString *caseString = data[@"$caseData"][@"num"];
                //                // 律师名
                                NSDictionary *userModel = data[@"$caseData"][@"options"][@"user"];
                                NSString *lawyerID = data[@"$caseData"][@"lawyer"];
                                NSString *lawyerName = userModel[lawyerID][@"name"];
                
                model.productString = [NSString stringWithFormat:@"案件委托[%@]律师[%@]代理费",caseString, lawyerName];
                //model.lawyer        = [zxyUser objectForKey:data[@"$caseData"][@"lawyer"]];
                //model.productString = [NSString stringWithFormat:@"案件委托[%@]律师[%@]代理费",caseString,model.lawyer];
            } else {
                // 激活法律卡
                model.type = LCYOrderListProductTypeActivate;
                
                // 卡号
                NSString *cardID = data[@"card"];
                model.productString = [NSString stringWithFormat:@"激活法率卡[%@]",cardID];
            }
            
            // 金额
            model.costMoney = [self toPriceFormatter:data[@"amount"]];
            // 当前状态
            NSString *statusKey = data[@"status"];
            _statusKey = statusKey;
            NSString *statusValue = statusModel[statusKey][@"name"];
            model.status = statusValue;
            
            // 数据id
            model.dbIdentifier = data[@"_id"];
            
            [tempArray addObject:model];
        }
        
        if (!append) {
            weakSelf.skip = weakSelf.limit;
            
            weakSelf.icyModels = tempArray;
            
        } else {
            weakSelf.skip += weakSelf.limit;
            
            NSMutableArray *muArray = [NSMutableArray arrayWithArray:weakSelf.icyModels];
            [muArray addObjectsFromArray:tempArray];
            weakSelf.icyModels = muArray;
        }
        
        if (append &&
            [tempArray count] == 0) {
            [weakSelf alertMessage:@"没有更多数据了。"];
        } else {
            [weakSelf.icyTableView reloadData];
        }
        [weakSelf.icyTableView headerEndRefreshing];
        [weakSelf.icyTableView footerEndRefreshing];
    } failed:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 访问失败，重新获取csrf
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
            UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"userLoginVC"];
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        });
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.icyModels) {
        return 0;
    } else {
        return [self.icyModels count];
    }
}

- (NSString *)toPriceFormatter:(NSString *)inputString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:inputString.intValue]];
    
    
    NSLog(@"Formatted number string:%@",string);
    return string;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCYOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYOrderListCellIdentifier];
    LCYOrderListModel *model = self.icyModels[indexPath.row];
    cell.icyIDLabel.text = [NSString stringWithFormat:@"订单编号：%@",model.orderID];
    cell.icyStartTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",model.commitTime];
    cell.icyProductLabel.text = [NSString stringWithFormat:@"%@", model.productString] ;
    cell.icyStatusLabel.text = model.status;
    cell.icyCostLabel.text = [NSString stringWithFormat:@"金额：%@元",model.costMoney];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
}

@end
