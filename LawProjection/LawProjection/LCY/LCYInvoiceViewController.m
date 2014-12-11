//
//  LCYInvoiceViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYInvoiceViewController.h"
#import "LCYInvoiceDynamicCell.h"
#import "LCYInvoiceSegmentCell.h"
#import "LCYNetworking.h"
#import "LCYInvoiceModel.h"
#import "LCYLootView.h"
#import "LCYModifyTextViewController.h"
#import "ZXY_CityZoneVC.h"
#import "LawCityEntity.h"
#import "LCYInvoiceSwitchCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString *const IInvoiceTitle = @"发票抬头";
NSString *const IInvoiceAddress = @"详细地址";
NSString *const IInvoicePostCode = @"邮政编码";
NSString *const IInvoiceReceiver = @"收件人";

NSInteger const kCommitAlert = 3391;

@interface LCYInvoiceViewController () <UITableViewDelegate, UITableViewDataSource, LCYLootSource, LCYModifyTextViewDelegate, ZXY_ChooseCityDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIToolbar *tabtab;
    NSDictionary *_modernInfo;
    BOOL isFinish;
}
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@property (copy, nonatomic) NSArray *invoiceTypes;

@property (strong, nonatomic) LCYLootView *templatesLootView;

@property (copy, nonatomic) NSString *currentTemplateName;

@property (strong, nonatomic) LCYInvoiceModel *invoiceModel;

@property (strong, nonatomic) LCYLootView *invoiceTypeLootView;

@property (copy, nonatomic) NSString *icyUserID;

@end

@implementation LCYInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"发票详情"];
    if(self.invoiceModel == nil)
    {
        self.invoiceModel = [[LCYInvoiceModel alloc] init];
    }
    self.invoiceModel.invoicePrice = self.invoiceMoney;
    
    // 载入下拉菜单数据
    __weak __typeof(self) weakSelf = self;
    
    if(isFinish)
    {
        
    }
    else
    {
        [self.icyTableView setTableFooterView:tabtab];
    }
    // 载入用户名
    if (![[UserInfoDetail sharedInstance] isUserLogin]) {
        // 访问失败，重新登录
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UserLoginRegist"
                                                                 bundle:nil];
            UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"userLoginVC"];
            [weakSelf.navigationController pushViewController:viewController
                                                     animated:YES];
        });
    } else {
        self.icyUserID = [[UserInfoDetail sharedInstance] getUserID];
        
        // 载入发票类型下拉框
        NSDictionary *parameters = @{
                                     @"type":@"InvoiceType"
                                     };
        [[LCYNetworking sharedInstance] getRequestWithApi:@"category/list"
                                               parameters:parameters
                                                  success:^(NSDictionary *responseObject) {
                                                      NSArray *items = responseObject[@"data"][@"items"];
                                                      NSMutableArray *tempArray = [NSMutableArray array];
                                                      for (NSDictionary *info in items) {
                                                          LCYInvoiceInvoiceType *invoiceType = [[LCYInvoiceInvoiceType alloc] init];
                                                          invoiceType.typeName = info[@"name"];
                                                          invoiceType.typeID = info[@"categoryId"];
                                                          [tempArray addObject:invoiceType];
                                                      }
                                                      self.invoiceTypes = tempArray;
                                                  }
                                                   failed:^{
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                           // 访问失败，重新获取csrf
                                                           UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
                                                           UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"userLoginVC"];
                                                           [weakSelf.navigationController pushViewController:viewController
                                                                                                    animated:YES];
                                                       });
                                                   }];
    }
    if(isFinish)
    {
        
    }
}

- (void)setDetailInfo:(NSDictionary *)modernInfo
{
    _modernInfo = modernInfo;
    NSDictionary *dataDic      = [modernInfo objectForKey:@"data"];
    NSString     *statusString = [dataDic objectForKey:@"status"];
    if([statusString isEqualToString:@"IS0001"]||statusString == nil)
    {
        isFinish = NO;
        return;
    }
    else
    {
        isFinish = YES;
        [tabtab setHidden:YES];
    }
    LCYInvoiceModel *newInvoiceModel = [[LCYInvoiceModel alloc] init];
    // 金额
    newInvoiceModel.invoicePrice = self.invoiceModel.invoicePrice;
    // 模版
   // newInvoiceModel.templateName = [NSString stringWithFormat:@"%@ %@ %@",type,subType,name];
    // 开具类型
    newInvoiceModel.customerType = dataDic[@"customerType"];
    // 发票类型
    LCYInvoiceInvoiceType *invoiceType = [[LCYInvoiceInvoiceType alloc] init];
    invoiceType.typeName = @"增值税普通发票";
    invoiceType.typeID = dataDic[@"invoiceType"];
    newInvoiceModel.invoiceType = invoiceType;
    // 发票抬头
    newInvoiceModel.invoiceTitle = dataDic[@"invoiceName"];
    // 邮寄地址
    LCYInvoiceLocation *province = [[LCYInvoiceLocation alloc] init];
    province.name = dataDic[@"address"][@"province"][@"name"];
    province.icyID = dataDic[@"address"][@"province"][@"id"];
    LCYInvoiceLocation *city = [[LCYInvoiceLocation alloc] init];
    city.name = dataDic[@"address"][@"city"][@"name"];
    city.icyID = dataDic[@"address"][@"city"][@"id"];
    LCYInvoiceLocation *town = [[LCYInvoiceLocation alloc] init];
    town.name = dataDic[@"address"][@"town"][@"name"];
    town.icyID = dataDic[@"address"][@"town"][@"id"];
    newInvoiceModel.province = province;
    newInvoiceModel.city = city;
    newInvoiceModel.town = town;
    // 详细地址
    newInvoiceModel.address = dataDic[@"address"][@"streets"];
    // 邮政编码
    newInvoiceModel.postCode = dataDic[@"address"][@"postcode"];
    // 收件人
    newInvoiceModel.receiver = dataDic[@"address"][@"recipient"];
    // 保存为模版
    newInvoiceModel.saveAsTemplate = NO;
    
    self.invoiceModel = newInvoiceModel;
    
    [self.icyTableView reloadData];

    
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

- (IBAction)submitButtonPressed:(id)sender {
    if ([self checkValid]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"正在提交"];
        
        NSDictionary *parameters;
        if (self.invoiceModel.saveAsTemplate) {
            parameters = @{
                           @"uid":self.icyUserID,
                           @"orderId":self.orderID,
                           @"data":@{
                                   @"customerType":self.invoiceModel.customerType,
                                   @"invoiceType":self.invoiceModel.invoiceType.typeID,
                                   @"invoiceName":self.invoiceModel.invoiceTitle,
                                   @"address":@{
                                           @"province":@{
                                                   @"id":self.invoiceModel.province.icyID,
                                                   @"name":self.invoiceModel.province.name
                                                   },
                                           @"city":@{
                                                   @"id":self.invoiceModel.city.icyID,
                                                   @"name":self.invoiceModel.city.name
                                                   },
                                           @"town":@{
                                                   @"id":self.invoiceModel.town.icyID,
                                                   @"name":self.invoiceModel.town.name
                                                   },
                                           @"streets":self.invoiceModel.address,
                                           @"postcode":self.invoiceModel.postCode,
                                            @"recipient":self.invoiceModel.receiver,
                                           },
                                  
                                   @"template":@"1"
                                   }
                           };
        } else {
            parameters = @{
                           @"uid":self.icyUserID,
                           @"orderId":self.orderID,
                           @"data":@{
                                   @"customerType":self.invoiceModel.customerType,
                                   @"invoiceType":self.invoiceModel.invoiceType.typeID,
                                   @"invoiceName":self.invoiceModel.invoiceTitle,
                                   @"address":@{
                                           @"province":@{
                                                   @"id":self.invoiceModel.province.icyID,
                                                   @"name":self.invoiceModel.province.name
                                                   },
                                           @"city":@{
                                                   @"id":self.invoiceModel.city.icyID,
                                                   @"name":self.invoiceModel.city.name
                                                   },
                                           @"town":@{
                                                   @"id":self.invoiceModel.town.icyID,
                                                   @"name":self.invoiceModel.town.name
                                                   },
                                           @"streets":self.invoiceModel.address,
                                           @"postcode":self.invoiceModel.postCode,
                                           @"recipient":self.invoiceModel.receiver,
                                           },
                                  
                                   }
                           };
        }
        NSLog(@"parameter = %@",parameters);
        __weak __typeof(self) weakSelf = self;
        [[LCYNetworking sharedInstance] postRequestWithApi:@"invoice/apply"
                                                parameters:parameters
                                                   success:^(NSDictionary *responseObject) {
                                                       [MBProgressHUD hideHUDForView:self.view
                                                                            animated:YES];
                                                       if (!responseObject[@"error"]) {
                                                           [weakSelf commitDone];
                                                       } else {
                                                           [weakSelf alertMessage:@"提交失败"];
                                                       }
                                                   }
                                                    failed:^{
                                                        [MBProgressHUD hideHUDForView:self.view
                                                                             animated:YES];
                                                        [weakSelf alertMessage:@"提交失败"];
                                                    }];
    }
}

- (BOOL)checkValid {
    // 发票类型
    if (!self.invoiceModel.invoiceType) {
        [self alertMessage:@"请选择发票类型。"];
        return NO;
    }
    // 发票抬头
    if (!self.invoiceModel.invoiceTitle ||
        self.invoiceModel.invoiceTitle.length == 0) {
        [self alertMessage:@"请输入发票抬头。"];
        return NO;
    } else if (self.invoiceModel.invoiceTitle.length < 2 ||
               self.invoiceModel.invoiceTitle.length > 50) {
        [self alertMessage:@"发票抬头请限制在2－50个汉字。"];
        return NO;
    }
    // 邮寄地址
    if (!self.invoiceModel.province || !self.invoiceModel.city || !self.invoiceModel.town) {
        [self alertMessage:@"请选择邮寄地址"];
        return NO;
    }
    // 详细地址
    if (!self.invoiceModel.address ||
        self.invoiceModel.address.length == 0) {
        [self alertMessage:@"请输入详细地址。"];
        return NO;
    } else if (self.invoiceModel.address.length < 5 ||
               self.invoiceModel.address.length > 120) {
        [self alertMessage:@"详细地址请限制在5－120个汉字。"];
        return NO;
    }
    // 邮政编码
    if (!self.invoiceModel.postCode) {
        [self alertMessage:@"请填写邮政编码"];
        return NO;
    } else {
        NSString *pattern = @"(^(\\d{6})$)";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
        if (![predicate evaluateWithObject:self.invoiceModel.postCode]) {
            [self alertMessage:@"请输入合法的邮政编码"];
            return NO;
        }
    }
    // 收件人
    if (!self.invoiceModel.receiver ||
        self.invoiceModel.receiver.length == 0) {
        [self alertMessage:@"请输入收件人。"];
        return NO;
    } else if (self.invoiceModel.receiver.length < 2 ||
               self.invoiceModel.receiver.length > 30) {
        [self alertMessage:@"收件人文字请限制在2－30个汉字。"];
        return NO;
    }
    // 用户名
    if (!self.icyUserID) {
        [self alertMessage:@"未能加载用户ID，请稍后。"];
        return NO;
    }
    return YES;
}

- (void)commitDone {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"提交完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.tag = kCommitAlert;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kCommitAlert) {
        if (self.doneBlock) {
            self.doneBlock();
        }
        NSArray *allC = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[allC objectAtIndex:allC.count-3] animated:YES];
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isFinish)
    {
        return 8;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isFinish)
    {
        switch (indexPath.row) {
            case 0:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"发票金额";
                cell.icyContentLabel.text = self.invoiceModel.invoicePrice;
                return cell;
                break;
            }
//            case 1:
//            {
//                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
//                cell.icyTitleLabel.text = @"发票模版";
//                if (!self.invoiceModel.templateName) {
//                    cell.icyContentLabel.text = @"请选择模版";
//                } else {
//                    cell.icyContentLabel.text = self.invoiceModel.templateName;
//                }
//                return cell;
//                break;
//            }
            case 1:
            {
                LCYInvoiceSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceSegmentCellIdentifier];
                __weak __typeof(self) weakSelf = self;
                [cell setSegmentChanged:^(NSInteger toIndex) {
                    if (toIndex == 0) {
                        weakSelf.invoiceModel.customerType = customerTypeEnterprise;
                    } else {
                        weakSelf.invoiceModel.customerType = customerTypePersonal;
                    }
                }];
                if(isFinish)
                {
                    [cell.icySegmentControl setEnabled:NO];
                }
                cell.icyTitleLabel.text = @"开具类型";
                [cell.icySegmentControl setTitle:@"企业" forSegmentAtIndex:0];
                [cell.icySegmentControl setTitle:@"个人" forSegmentAtIndex:1];
                if ([self.invoiceModel.customerType isEqualToString:customerTypeEnterprise]) {
                    [cell.icySegmentControl setSelectedSegmentIndex:0];
                } else {
                    [cell.icySegmentControl setSelectedSegmentIndex:1];
                }
                return cell;
                break;
            }
            case 2:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"发票类型";
                if (!self.invoiceModel.invoiceType) {
                    cell.icyContentLabel.text = @"";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.invoiceType.typeName;
                }
                return cell;
                break;
            }
            case 3:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"发票抬头";
                if (!self.invoiceModel.invoiceTitle ||
                    self.invoiceModel.invoiceTitle.length == 0) {
                    cell.icyContentLabel.text = @"";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.invoiceTitle;
                }
                return cell;
                break;
            }
            case 4:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"邮寄地址";
                if (!self.invoiceModel.province ||
                    !self.invoiceModel.city ||
                    !self.invoiceModel.town) {
                    cell.icyContentLabel.text = @"";
                } else {
                    NSString *location = [NSString stringWithFormat:@"%@ %@ %@",self.invoiceModel.province.name, self.invoiceModel.city.name,self.invoiceModel.town.name];
                    cell.icyContentLabel.text = location;
                }
                return cell;
                break;
            }
            case 5:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"详细地址";
                if (!self.invoiceModel.address ||
                    self.invoiceModel.address.length == 0) {
                    cell.icyContentLabel.text = @"请填写";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.address;
                }
                return cell;
                break;
            }
            case 6:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"邮政编码";
                if (!self.invoiceModel.postCode ||
                    self.invoiceModel.postCode.length == 0) {
                    cell.icyContentLabel.text = @"请输入";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.postCode;
                }
                return cell;
                break;
            }
            case 7:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"收件人";
                if (!self.invoiceModel.receiver ||
                    self.invoiceModel.receiver.length == 0) {
                    cell.icyContentLabel.text = @"请输入";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.receiver;
                }
                return cell;
                break;
                
            }
//            case 9:
//            {
//                LCYInvoiceSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceSwitchCellIdentifier];
//                __weak __typeof(self) weakSelf = self;
//                [cell setSwitchValueChangeBlock:^(BOOL state) {
//                    weakSelf.invoiceModel.saveAsTemplate = state;
//                }];
//                cell.icyTitleLabel.text = @"保存为模版";
//                if (self.invoiceModel.saveAsTemplate) {
//                    [cell.icySwitch setOn:YES];
//                } else {
//                    [cell.icySwitch setOn:NO];
//                }
//                return cell;
//                break;
//            }
                
            default:
                return nil;
                break;
        }

    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"发票金额";
                cell.icyContentLabel.text = self.invoiceModel.invoicePrice;
                return cell;
                break;
            }
            case 1:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"发票模版";
                if (!self.invoiceModel.templateName) {
                    cell.icyContentLabel.text = @"请选择模版";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.templateName;
                }
                return cell;
                break;
            }
            case 2:
            {
                LCYInvoiceSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceSegmentCellIdentifier];
                __weak __typeof(self) weakSelf = self;
                [cell setSegmentChanged:^(NSInteger toIndex) {
                    if (toIndex == 0) {
                        weakSelf.invoiceModel.customerType = customerTypeEnterprise;
                    } else {
                        weakSelf.invoiceModel.customerType = customerTypePersonal;
                    }
                }];
                cell.icyTitleLabel.text = @"开具类型";
                [cell.icySegmentControl setTitle:@"企业" forSegmentAtIndex:0];
                [cell.icySegmentControl setTitle:@"个人" forSegmentAtIndex:1];
                if ([self.invoiceModel.customerType isEqualToString:customerTypeEnterprise]) {
                    [cell.icySegmentControl setSelectedSegmentIndex:0];
                } else {
                    [cell.icySegmentControl setSelectedSegmentIndex:1];
                }
                return cell;
                break;
            }
            case 3:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"发票类型";
                if (!self.invoiceModel.invoiceType) {
                    cell.icyContentLabel.text = @"请选择";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.invoiceType.typeName;
                }
                return cell;
                break;
            }
            case 4:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"发票抬头";
                if (!self.invoiceModel.invoiceTitle ||
                    self.invoiceModel.invoiceTitle.length == 0) {
                    cell.icyContentLabel.text = @"请输入";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.invoiceTitle;
                }
                return cell;
                break;
            }
            case 5:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"邮寄地址";
                if (!self.invoiceModel.province ||
                    !self.invoiceModel.city ||
                    !self.invoiceModel.town) {
                    cell.icyContentLabel.text = @"请选择";
                } else {
                    NSString *location = [NSString stringWithFormat:@"%@ %@ %@",self.invoiceModel.province.name, self.invoiceModel.city.name,self.invoiceModel.town.name];
                    cell.icyContentLabel.text = location;
                }
                return cell;
                break;
            }
            case 6:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"详细地址";
                if (!self.invoiceModel.address ||
                    self.invoiceModel.address.length == 0) {
                    cell.icyContentLabel.text = @"请填写";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.address;
                }
                return cell;
                break;
            }
            case 7:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"邮政编码";
                if (!self.invoiceModel.postCode ||
                    self.invoiceModel.postCode.length == 0) {
                    cell.icyContentLabel.text = @"请输入";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.postCode;
                }
                return cell;
                break;
            }
            case 8:
            {
                LCYInvoiceDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceDynamicCellIdentifier];
                cell.icyTitleLabel.text = @"收件人";
                if (!self.invoiceModel.receiver ||
                    self.invoiceModel.receiver.length == 0) {
                    cell.icyContentLabel.text = @"请输入";
                } else {
                    cell.icyContentLabel.text = self.invoiceModel.receiver;
                }
                return cell;
                break;
                
            }
            case 9:
            {
                LCYInvoiceSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYInvoiceSwitchCellIdentifier];
                __weak __typeof(self) weakSelf = self;
                [cell setSwitchValueChangeBlock:^(BOOL state) {
                    weakSelf.invoiceModel.saveAsTemplate = state;
                }];
                cell.icyTitleLabel.text = @"保存为模版";
                if (self.invoiceModel.saveAsTemplate) {
                    [cell.icySwitch setOn:YES];
                } else {
                    [cell.icySwitch setOn:NO];
                }
                return cell;
                break;
            }
                
            default:
                return nil;
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isFinish)
    {
        return;
    }
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
        {
            // 模版
            self.templatesLootView = [[LCYLootView alloc] initWithDataSource:self];
            [self.templatesLootView show];
            break;
        }
        case 2:
            break;
        case 3:{
            // 发票类型
            if (!self.invoiceTypes) {
                [self alertMessage:@"正在获取发票类型，请稍后选择。"];
            } else {
                self.invoiceTypeLootView = [[LCYLootView alloc] initWithDataSource:self];
                [self.invoiceTypeLootView show];
            }
            break;
        }
        case 4:
            // 抬头
        {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LCYLawyerLetter"
                                                                 bundle:nil];
            LCYModifyTextViewController *modifyVC = [storyBoard instantiateViewControllerWithIdentifier:@"modityTextVC"];
            modifyVC.icyIdentifier = IInvoiceTitle;
            modifyVC.delegate = self;
            [self.navigationController pushViewController:modifyVC
                                                 animated:YES];
            break;
        }
        case 5: {
            // 邮寄地址
            UIStoryboard *citySB = [UIStoryboard storyboardWithName:@"UserLoginRegist"
                                                             bundle:nil];
            ZXY_CityZoneVC *cityVC = [citySB instantiateViewControllerWithIdentifier:@"cityVC"];
            cityVC.delegate = self;
            [self.navigationController pushViewController:cityVC
                                                 animated:YES];
            break;
        }
        case 6:{
            // 详细地址
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LCYLawyerLetter"
                                                                 bundle:nil];
            LCYModifyTextViewController *modifyVC = [storyBoard instantiateViewControllerWithIdentifier:@"modityTextVC"];
            modifyVC.icyIdentifier = IInvoiceAddress;
            modifyVC.delegate = self;
            [self.navigationController pushViewController:modifyVC
                                                 animated:YES];
            break;
        }
        case 7:
        {
            // 邮政编码
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LCYLawyerLetter"
                                                                 bundle:nil];
            LCYModifyTextViewController *modifyVC = [storyBoard instantiateViewControllerWithIdentifier:@"modityTextVC"];
            modifyVC.icyIdentifier = IInvoicePostCode;
            modifyVC.delegate = self;
            [self.navigationController pushViewController:modifyVC
                                                 animated:YES];
            break;
        }
            break;
        case 8:
        {
            // 收件人
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LCYLawyerLetter"
                                                                 bundle:nil];
            LCYModifyTextViewController *modifyVC = [storyBoard instantiateViewControllerWithIdentifier:@"modityTextVC"];
            modifyVC.icyIdentifier = IInvoiceReceiver;
            modifyVC.delegate = self;
            [self.navigationController pushViewController:modifyVC
                                                 animated:YES];
            break;
        }
        case 9:
            break;
            
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        if (!self.invoiceModel.address ||
            [self.invoiceModel.address isEqualToString:@""]) {
            return 44.0f;
        } else {
            CGSize size = [self.invoiceModel.address boundingRectWithSize:CGSizeMake(200.0f, 40000.0f)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{
                                                                            NSFontAttributeName:[UIFont systemFontOfSize:13.0f]
                                                                            }
                                                                  context:nil].size;
            return size.height + 28.0f >= 44 ? size.height + 28.0f : 44.0f;
        }
    } else {
        return 44.0f;
    }
}

#pragma mark - LCYLootDataSource
- (NSInteger)numberOfRowsInlootView:(LCYLootView *)lootView {
    if (lootView == self.templatesLootView) {
        return [self.invoiceTemplates count];
    }
    else if (lootView == self.invoiceTypeLootView) {
        return [self.invoiceTypes count];
    }
    else {
        return 0;
    }
}

- (NSString *)lootView:(LCYLootView *)lootView textAtRow:(NSInteger)row {
    if (lootView == self.templatesLootView) {
        NSDictionary *data = self.invoiceTemplates[row];
        NSString *type = [data[@"template"][@"customerType"] isEqualToString:@"CT0001"] ? @"企业" : @"个人";
        NSString *subType = [data[@"template"][@"invoiceType"] isEqualToString:@"IT0001"] ? @"增值税普通发票" : @"未知";
        NSString *name = data[@"template"][@"invoiceName"];
        return [NSString stringWithFormat:@"%@ %@ %@",type,subType,name];
    }
    else if (lootView == self.invoiceTypeLootView) {
        LCYInvoiceInvoiceType *type = self.invoiceTypes[row];
        return type.typeName;
    }
    else {
        return @"";
    }
}

- (void)lootView:(LCYLootView *)lootView didSelectItemAtIndex:(NSInteger)index {
    if (lootView == self.templatesLootView) {
        NSDictionary *data = self.invoiceTemplates[index];
        NSString *type = [data[@"template"][@"customerType"] isEqualToString:@"CT0001"] ? @"企业" : @"个人";
        NSString *subType = [data[@"template"][@"invoiceType"] isEqualToString:@"IT0001"] ? @"增值税普通发票" : @"未知";
        NSString *name = data[@"template"][@"invoiceName"];
        
        // 解析模版
        LCYInvoiceModel *newInvoiceModel = [[LCYInvoiceModel alloc] init];
        // 金额
        newInvoiceModel.invoicePrice = self.invoiceModel.invoicePrice;
        // 模版
        newInvoiceModel.templateName = [NSString stringWithFormat:@"%@ %@ %@",type,subType,name];
        // 开具类型
        newInvoiceModel.customerType = data[@"template"][@"customerType"];
        // 发票类型
        LCYInvoiceInvoiceType *invoiceType = [[LCYInvoiceInvoiceType alloc] init];
        invoiceType.typeName = @"增值税普通发票";
        invoiceType.typeID = data[@"template"][@"invoiceType"];
        newInvoiceModel.invoiceType = invoiceType;
        // 发票抬头
        newInvoiceModel.invoiceTitle = data[@"template"][@"invoiceName"];
        // 邮寄地址
        LCYInvoiceLocation *province = [[LCYInvoiceLocation alloc] init];
        province.name = data[@"template"][@"address"][@"province"][@"name"];
        province.icyID = data[@"template"][@"address"][@"province"][@"id"];
        LCYInvoiceLocation *city = [[LCYInvoiceLocation alloc] init];
        city.name = data[@"template"][@"address"][@"city"][@"name"];
        city.icyID = data[@"template"][@"address"][@"city"][@"id"];
        LCYInvoiceLocation *town = [[LCYInvoiceLocation alloc] init];
        town.name = data[@"template"][@"address"][@"town"][@"name"];
        town.icyID = data[@"template"][@"address"][@"town"][@"id"];
        newInvoiceModel.province = province;
        newInvoiceModel.city = city;
        newInvoiceModel.town = town;
        // 详细地址
        newInvoiceModel.address = data[@"template"][@"address"][@"streets"];
        // 邮政编码
        newInvoiceModel.postCode = data[@"template"][@"address"][@"postcode"];
        // 收件人
        newInvoiceModel.receiver = data[@"template"][@"address"][@"recipient"];
        // 保存为模版
        newInvoiceModel.saveAsTemplate = NO;
        
        self.invoiceModel = newInvoiceModel;
        
        [self.icyTableView reloadData];
    } else if (lootView == self.invoiceTypeLootView) {
        LCYInvoiceInvoiceType *type = self.invoiceTypes[index];
        self.invoiceModel.invoiceType = type;
        [self.icyTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - LCYTextEdit
- (void)modifyTextVC:(LCYModifyTextViewController *)viewController didFinishChangeText:(NSString *)text atField:(NSString *)identifier {
    if ([identifier isEqualToString:IInvoiceTitle]) {
        self.invoiceModel.invoiceTitle = text;
        [self.icyTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
    } else if ([identifier isEqualToString:IInvoiceAddress]) {
        self.invoiceModel.address = text;
        [self.icyTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
    } else if ([identifier isEqualToString:IInvoicePostCode]) {
        self.invoiceModel.postCode = text;
        [self.icyTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
    } else if ([identifier isEqualToString:IInvoiceReceiver]) {
        self.invoiceModel.receiver = text;
        [self.icyTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)startLoad
{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_ORDERDETAILTEMPLETE_URL];
//    NSDictionary *parameter = @{
//                                 @"id":self.orderID
//                                 };
//    []
}

#pragma mark - ChooseCity

- (void)userChooseCityDelegate:(LawCityEntity *)provinceEntity andCityEntity:(LawCityEntity *)cityEntity withZoneEntity:(LawCityEntity *)zoneEntity {
    if (!self.invoiceModel.province) {
        self.invoiceModel.province = [[LCYInvoiceLocation alloc] init];
    }
    if (!self.invoiceModel.city) {
        self.invoiceModel.city = [[LCYInvoiceLocation alloc] init];
    }
    if (!self.invoiceModel.town) {
        self.invoiceModel.town = [[LCYInvoiceLocation alloc] init];
    }
    
    self.invoiceModel.province.name = provinceEntity.name;
    self.invoiceModel.province.icyID = provinceEntity.cityID;
    self.invoiceModel.city.name = cityEntity.name;
    self.invoiceModel.city.icyID = cityEntity.cityID;
    self.invoiceModel.town.name = zoneEntity.name;
    self.invoiceModel.town.icyID = zoneEntity.cityID;
    [self.icyTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]]
                             withRowAnimation:UITableViewRowAnimationNone];
}

@end
