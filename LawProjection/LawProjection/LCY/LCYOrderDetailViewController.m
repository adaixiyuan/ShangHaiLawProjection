//
//  LCYOrderDetailViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYOrderDetailViewController.h"
#import "LCYOrderDetailHeadCell.h"
#import "LCYNetworking.h"
#import "LCYOrderListDetailModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LCYCommon.h"
#import "LCYOrderDetailContentCell.h"
#import "LCYOrderDetailFootCell.h"
#import "LCYInvoiceViewController.h"
#import "ZXY_PayVC.h"
#import "ZXY_UserLoginVC.h"

NSString *const SInvoiceNo = @"未开具";        /**< 未开具 */
NSString *const SInvoiceIn = @"开具中";        /**< 开具中 */
NSString *const SInvoiceDone = @"已开具";      /**< 已开具 */

@interface LCYOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    NSDictionary *currentZXYDic;
    NSDictionary *modernDic;
    NSString     *moneyForPay;
    __weak IBOutlet UIView *btnView;
    __weak IBOutlet UIButton *ensureBtn;
    __weak IBOutlet UIButton *cancelBtn;
    __weak IBOutlet UIButton *singleBtn;
    __weak IBOutlet UITableView *currentTV;
}

@property (strong, nonatomic) LCYOrderListDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;



@property (copy, nonatomic) NSString *invoiceStatus;

@property (copy, nonatomic) NSArray *invoiceTemplates;

/**
 *  订单已经付款完成
 */
@property (nonatomic) BOOL fDone;

/**
 *  发票状态为未开具
 */
@property (nonatomic) BOOL fStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonAction;

@end

@implementation LCYOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fDone = NO;
    self.fStatus = NO;
    
    self.invoiceStatus = @"";
    ensureBtn.layer.cornerRadius = 4;
    ensureBtn.layer.masksToBounds = YES;
    
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.masksToBounds= YES;
    
    singleBtn.layer.cornerRadius = 4;
    singleBtn.layer.masksToBounds=YES;
    [self.navigationItem setTitle:@"订单详情"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    // 获取订单详细信息
    NSDictionary *parameters =  @{ @"id":self.preOrderModel.dbIdentifier };
    [[LCYNetworking sharedInstance] getRequestWithApi:@"order/getDetail" parameters:parameters success:^(NSDictionary *responseObject) {
        // 解析数据
        NSDictionary *data = responseObject[@"data"];
        if (data) {
            [weakSelf parseData:data];
            [weakSelf.icyTableView reloadData];
        }
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failed:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            // 访问失败，重新获取csrf
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
            UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"userLoginVC"];
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        });
    }];
    
    // 获取发票信息和模版信息
    NSDictionary *invoiceParameters = @{@"id":self.preOrderModel.dbIdentifier};
    [[LCYNetworking sharedInstance] getRequestWithApi:@"invoice/getOneByOrder" parameters:invoiceParameters success:^(NSDictionary *responseObject) {
        if (responseObject[@"data"][@"status"]) {
            modernDic = responseObject;
            NSString *invoiceStatus = responseObject[@"data"][@"status"];
            if ([invoiceStatus isEqualToString:@"IS0002"]) {
                weakSelf.invoiceStatus = SInvoiceIn;
            } else if ([invoiceStatus isEqualToString:@"IS0003"]) {
                weakSelf.invoiceStatus = SInvoiceDone;
            } else {
                weakSelf.invoiceStatus = SInvoiceNo;
            }
            weakSelf.invoiceTemplates = responseObject[@"data"][@"template"][@"items"];
            weakSelf.fStatus = YES;
        } else if (responseObject[@"data"]){
            weakSelf.invoiceStatus = SInvoiceNo;
            weakSelf.invoiceTemplates = responseObject[@"data"][@"template"][@"items"];
            weakSelf.fStatus = YES;
        } else {
            weakSelf.invoiceStatus = nil;
        }
        [currentTV reloadData];
    } failed:^{
        ;
    }];
}

- (void)parseData:(NSDictionary *)data {
    currentZXYDic = data;
    NSDictionary *statusModel = data[@"options"][@"category"];
    
    self.detailModel = [[LCYOrderListDetailModel alloc] init];
    // 订单编号
    self.detailModel.orderID = data[@"num"];
    // 下单时间
    NSString *createAt = data[@"createAt"];
    NSDate *createDate = [[LCYCommon sharedInstance] convertDate:createAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd      HH:mm"];
    self.detailModel.commitTime = [formatter stringFromDate:createDate];
    // 产品类型和名称
    if (data[@"$product"]) {
        // 购买
        self.detailModel.type = LCYOrderListProductTypeBuy;
        // 产品名
        NSDictionary *productKeyModel = data[@"$product"][@"options"][@"category"];
        NSString *productKey = data[@"$product"][@"nameId"];
        NSString *productValue = productKeyModel[productKey][@"name"];
        // 产品数量
        NSString *count = data[@"count"];
        self.detailModel.productString = [NSString stringWithFormat:@"购买[%@]X%@",productValue,count];if([productValue isEqualToString:@"尊享版"]||[productValue isEqualToString:@"标准版"])
        {
            self.detailModel.productString = [NSString stringWithFormat:@"购买[%@]",productValue];
        }
        else
        {
            self.detailModel.productString = [NSString stringWithFormat:@"购买[%@]X%@",productValue,count];
        }

    } else if (data[@"$caseData"]) {
        // 案件委托
        self.detailModel.type = LCYOrderListProductTypeDelegate;
        
        // 案件号
        NSString *caseString = data[@"$caseData"][@"num"];
        self.detailModel.productString = [NSString stringWithFormat:@"案件[%@]代理费",caseString];
    } else {
        // 激活法律卡
        self.detailModel.type = LCYOrderListProductTypeActivate;
        
        // 卡号
        NSString *cardID = data[@"card"];
        self.detailModel.productString = [NSString stringWithFormat:@"激活法率卡[%@]",cardID];
    }
    
    // 金额
    self.detailModel.costMoney = [NSString stringWithFormat:@"%@",data[@"amount"]];
    // 当前状态
    NSString *statusKey = data[@"status"];
    NSString *statusValue = statusModel[statusKey][@"name"];
    self.detailModel.status = statusValue;
    
    // 数据id
    self.detailModel.dbIdentifier = data[@"_id"];
    
    if (self.detailModel.type != LCYOrderListProductTypeDelegate) {
        // 产品名称
        if (self.detailModel.type == LCYOrderListProductTypeBuy) {
            NSDictionary *productKeyModel = data[@"$product"][@"options"][@"category"];
            NSString *productKey = data[@"$product"][@"nameId"];
            NSString *productValue = productKeyModel[productKey][@"name"];
            self.detailModel.productName = productValue;
        } else {
            self.detailModel.productName = @"激活法律卡";
        }
        
        
        // 服务项目
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *serviceTypesInfo;
        if (self.detailModel.type == LCYOrderListProductTypeBuy) {
            serviceTypesInfo = data[@"$product"][@"serviceTypesInfo"];
        } else {
            serviceTypesInfo = data[@"$card"][@"serviceTypesInfo"];
        }
        if (serviceTypesInfo) {
            for (NSDictionary *info in serviceTypesInfo) {
                LCYOrderListDetailServiceItem *item = [[LCYOrderListDetailServiceItem alloc] init];
                item.name = info[@"serviceTypeName"];
                NSInteger quantity = [info[@"quantity"] integerValue];
                if (quantity > 5000) {
                    item.countString = @"无限次";
                } else {
                    item.countString = [NSString stringWithFormat:@"%@%@",info[@"quantity"], info[@"serviceTypeUnit"]];
                }
                [tempArray addObject:item];
            }
        }
        self.detailModel.serviceItems = tempArray;
        
        // 购买数量
        if (self.detailModel.type == LCYOrderListProductTypeBuy) {
            NSString *count = data[@"count"];
            self.detailModel.buyNumberString = [NSString stringWithFormat:@"购买数量  %@",count];
        } else {
            self.detailModel.buyNumberString = @"购买数量  1";
        }
        
        // 总金额
        self.detailModel.totalCostMoney = [NSString stringWithFormat:@"单价：%@元",data[@"price"]];
    }
    
    [self initSelfViewBtn];
}

//- (void)refreshInvoiceButtonItem {
//    if (self.detailModel.type != LCYOrderListProductTypeActivate) {
//        if ([self.detailModel.status isEqualToString:@"已完成"]) {
//            self.fDone = YES;
//        }
//        else if([self.detailModel.status isEqualToString:@"等待付款"])
//        {
//            self.fDone = NO;
//            [self.invoiceButtonItem setEnabled:YES];
//            self.invoiceButtonItem.title = @"付款";
//        }
//    }
//    if (self.fDone) {
//        if (self.invoiceStatus) {
//            if ([self.invoiceStatus isEqualToString:SInvoiceNo]) {
//                [self.invoiceButtonItem setTitle:@"索取发票"];
//                [self.invoiceButtonItem setEnabled:YES];
//            } else if ([self.invoiceStatus isEqualToString:SInvoiceDone]) {
//                [self.invoiceButtonItem setEnabled:NO];
//                self.invoiceButtonItem.title = @"已开具";
//            } else {
//                [self.invoiceButtonItem setEnabled:NO];
//                self.invoiceButtonItem.title = @"发票开具中";
//            }
//        }
//    }
//}

- (void)initSelfViewBtn
{
    if([self.detailModel.status isEqualToString:@"已完成"])
    {
        if(!(self.detailModel.type == LCYOrderListProductTypeActivate))
        {
            [singleBtn setHidden:NO];
            [singleBtn setTitle:@"索取发票" forState:UIControlStateNormal];
        }
    }
    else if ([self.detailModel.status isEqualToString:@"等待付款"])
    {
        if(!(self.detailModel.type == LCYOrderListProductTypeDelegate))
        {
            [ensureBtn setHidden:NO];
            [cancelBtn setHidden:NO];
        }
        else
        {
            [singleBtn setTitle:@"付款" forState:UIControlStateNormal];
            [singleBtn setHidden:NO];
            [singleBtn removeTarget:self action:@selector(invoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [singleBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
      //
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //__weak __typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"showInvoice"]) {
        LCYInvoiceViewController *invoiceVC = [segue destinationViewController];
        invoiceVC.orderID = self.detailModel.dbIdentifier;
        invoiceVC.invoiceMoney = self.detailModel.costMoney;
        invoiceVC.invoiceTemplates = self.invoiceTemplates;
        [invoiceVC setDetailInfo:modernDic];
        [invoiceVC setDoneBlock:^{
            //[weakSelf.invoiceButtonItem setEnabled:NO];
        }];
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.detailModel) {
        return 0;
    } else {
        if (self.detailModel.type == LCYOrderListProductTypeDelegate) {
            return 1;
        } else {
            return 1 + 1 + self.detailModel.serviceItems.count + 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LCYOrderDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYOrderDetailHeadCellIdentifier];
        cell.icyIDLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.detailModel.orderID];
        cell.icyStartTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",self.detailModel.commitTime];
        cell.icyProductLabel.text = [NSString stringWithFormat:@"%@", self.detailModel.productString ];
        cell.icyStatusLabel.text = self.detailModel.status;
        cell.icyCostLabel.text = [NSString stringWithFormat:@"应付金额：%@元",self.detailModel.costMoney];
        cell.invoiceType.text  = [NSString stringWithFormat:@"发票状态：%@",self.invoiceStatus];
        moneyForPay = self.detailModel.costMoney;
        return cell;
    } else {
        if (indexPath.row == 1) {
            // 产品名称
            LCYOrderDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYOrderDetailContentCellIdentifier];
            cell.icyTitleLabel.text = @"产品名称：";
            cell.icyContntLabel.text = self.detailModel.productName;
            cell.icyAccessoryLabel.text = @"";
            return cell;
        } else if (indexPath.row == 2 + self.detailModel.serviceItems.count) {
            // 总价格
            LCYOrderDetailFootCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYOrderDetailFootCellIdentifer];
            cell.buyCountLabel.text = self.detailModel.buyNumberString;
            cell.totalCostLabel.text = self.detailModel.totalCostMoney;
            return cell;
        } else {
            // 服务项目
            LCYOrderDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYOrderDetailContentCellIdentifier];
            if (indexPath.row == 2) {
                cell.icyTitleLabel.text = @"服务项目：";
            } else {
                cell.icyTitleLabel.text = @"";
            }
            LCYOrderListDetailServiceItem *item = self.detailModel.serviceItems[indexPath.row - 2];
            cell.icyContntLabel.text = item.name;
            cell.icyAccessoryLabel.text = item.countString;
            return cell;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 108.0f;
    } else {
        NSInteger contentStart = 1;
        NSInteger contentEnd = self.detailModel.serviceItems.count + 1;
        if (indexPath.row >= contentStart && indexPath.row <= contentEnd) {
            return 25.0f;
        } else {
            return 75.0f;
        }
    }
}

//- (IBAction)btnAction:(id)sender
//{
//    if (self.fDone) {
//        if (self.invoiceStatus) {
//            if ([self.invoiceStatus isEqualToString:SInvoiceNo]) {
//                [self performSegueWithIdentifier:@"showInvoice" sender:self];
////                [self.invoiceButtonItem setTitle:@"索取发票"];
////                [self.invoiceButtonItem setEnabled:YES];
//            } else if ([self.invoiceStatus isEqualToString:SInvoiceDone]) {
////                [self.invoiceButtonItem setEnabled:NO];
////                self.invoiceButtonItem.title = @"已开具";
//            } else {
////                [self.invoiceButtonItem setEnabled:NO];
////                self.invoiceButtonItem.title = @"发票开具中";
//            }
//        }
//    }
////    if([self.invoiceButtonItem.title isEqualToString:@"付款"])
////    {
////        NSString *orderID = self.detailModel.orderID;
////        NSString *_id     = self.detailModel.dbIdentifier;
////        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"num",_id,@"_id", nil];
////        UIStoryboard *story = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
////        ZXY_PayVC *pay      = [story instantiateViewControllerWithIdentifier:@"payV"];
////        [pay setOrderInfo:dic andProductInfo:currentZXYDic withPrice:moneyForPay.floatValue andNum:currentZXYDic[@"num"] isLCY:YES];
////        [self.navigationController pushViewController:pay animated:YES];
////    }
//
//}
- (IBAction)invoiceBtnAction:(id)sender {
    [self performSegueWithIdentifier:@"showInvoice" sender:self];
}

- (IBAction)payAction:(id)sender {
    NSString *orderID = self.detailModel.orderID;
    NSString *_id     = self.detailModel.dbIdentifier;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"num",_id,@"_id", nil];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
    ZXY_PayVC *pay      = [story instantiateViewControllerWithIdentifier:@"payV"];
    //[pay setOrderInfo:dic andProductInfo:currentZXYDic withPrice:moneyForPay.floatValue andNum:currentZXYDic[@"num"] isLCY:YES];
    if(self.detailModel.type == LCYOrderListProductTypeDelegate)
    {
        [pay setOrderInfo:dic andTitle:self.detailModel.productString andPrice:moneyForPay.floatValue withNumString:currentZXYDic[@"num"]];
    }
    else
    {
         [pay setOrderInfo:dic andProductInfo:currentZXYDic withPrice:moneyForPay.floatValue andNum:currentZXYDic[@"num"] isLCY:YES];
    }
    [self.navigationController pushViewController:pay animated:YES];
}

- (IBAction)cancelAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定取消订单么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 5000;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(buttonIndex == 1)
    {
        if (buttonIndex == 1)
        {
            NSString *_id     = self.detailModel.dbIdentifier;
            NSString *utlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CANCEL_URL];
            NSDictionary *idPar = @{
                                        @"id":_id
                                        };
            NSDictionary *statusPar = @{
                                        @"status":@"OS0004"
                                        };
            NSDictionary *parameter = @{
                                        @"filter":idPar,
                                        @"data"  :statusPar
                                        };
            [self startLoadDataPutCSRF:utlString withParameter:parameter successBlock:^(NSData *responseData) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if([returnDic.allKeys containsObject:@"error"])
                {
                    [self showAlertWarnningView:@"提示" andContent:@"取消订单失败请联系客服人员。"];
                }
                else
                {
                    [self showAlertWarnningView:@"提示" andContent:@"取消订单成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } errorBlock:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
                ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
                [self.navigationController pushViewController:loginVC animated:YES];
                //[self performSegueWithIdentifier:@"toLoginVC" sender:self];
;
            }];
        }
    }
}
@end
