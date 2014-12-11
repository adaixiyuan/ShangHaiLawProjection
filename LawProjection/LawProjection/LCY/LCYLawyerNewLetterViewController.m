//
//  LCYLawyerNewLetterViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYLawyerNewLetterViewController.h"
#import "LCYNewLetterCell.h"
#import "ZXY_LawCircleView.h"
#import "UIImage+Resize.h"
#import "LCYUploader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "LCYModifyTextViewController.h"
#import "LCYNewLetterDynamicCell.h"
#import "ZXY_CityZoneVC.h"
#import "LawCityEntity.h"
#import <AFNetworking/AFNetworking.h>
#import "LCYNetworking.h"
#import "LCYWebViewController.h"

NSString *const modifyIdentifierEnterprese  = @"企业名称";
NSString *const modifyIdentifierPersonName  = @"负责人";
NSString *const modifyIdentifierTelephone   = @"电话";
NSString *const modifyIdentifierAddress     = @"详细地址";
NSString *const modifyIdentifierPostcode    = @"邮政编码";
NSString *const modifyIdentifierQuestion    = @"问题描述";
NSString *const modifyIdentifierExpection   = @"您的期望";

NSString *const placeHolderForEmptyCell     = @"请填写";

NSInteger const kSuccessAlert = 3391;

CGSize const kImageMaxSize = {300.0f, 300.0f};

@interface LCYLawyerNewLetterViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LCYModifyTextViewDelegate, ZXY_ChooseCityDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@property (nonatomic) LCYNewLetterType currentType;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) LCYNewLetterModel *icyModel;

@property (nonatomic) BOOL isFirstLoad;

@property (copy, nonatomic) NSString *icyUserID;

@property (nonatomic) LCYLawyerLetterStatus currentStatus;


@property (weak, nonatomic) IBOutlet UISegmentedControl *icySegmentControl;

@property (strong, nonatomic) NSString *configFlag;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *icyCommitButtonItem;

@end

@implementation LCYLawyerNewLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    UIBarButtonItem *fixBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBarButtonItem.width = 44.0f;
    [self.navigationItem setLeftBarButtonItems:@[backBarButtonItem, fixBarButtonItem]];
    
    if (!self.icyModel) {
        // TableHeader
        UIView *circleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70.0f)];
        ZXY_LawCircleView *circle = [[ZXY_LawCircleView alloc] initWithPositionY:15.0f];
        [circle setNumOfCircle:5];
        [circle setCircleInfo:@[@"提交", @"起草", @"确认", @"发送", @"存档"]];
        [circleBackgroundView addSubview:circle];
        [self.icyTableView setTableHeaderView:circleBackgroundView];
        
        // model
        self.icyModel = [[LCYNewLetterModel alloc] init];
        
        self.currentType = LCYNewLetterTypeEnterprise;
    } else {
        UIView *circleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70.0f)];
        ZXY_LawCircleView *circle = [[ZXY_LawCircleView alloc] initWithPositionY:15.0f];
        [circle setNumOfCircle:5];
        [circle setCircleInfo:@[@"提交", @"起草", @"确认", @"发送", @"存档"]];
        [circleBackgroundView addSubview:circle];
        UIColor *selectColor;
        NSInteger index;
        switch (self.currentStatus) {
            case LCYLawyerLetterStatusCommit:
                index = 0;
                selectColor = [UIColor colorWithRed:0.0 green:205.0/255.0 blue:1.0 alpha:1.0];
                break;
            case LCYLawyerLetterStatusDraft:
                index = 1;
                selectColor = [UIColor colorWithRed:72.0/255.0 green:166.0/255.0 blue:230.0/255.0 alpha:1.0];
                break;
            case LCYLawyerLetterStatusConfirm:
                index = 2;
                selectColor = [UIColor colorWithRed:4.0/255.0 green:203.0/255.0 blue:160.0/255.0 alpha:1.0];
                break;
            case LCYLawyerLetterStatusSend:
                index = 3;
                selectColor = [UIColor colorWithRed:107.0/255.0 green:211.0/255.0 blue:90.0/255.0 alpha:1.0];
                break;
            case LCYLawyerLetterStatusSavefile:
                index = 4;
                selectColor = [UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:88.0/255.0 alpha:1.0];
                break;
                
            default:
                index = 0;
                selectColor = [UIColor colorWithRed:0.0 green:205.0/255.0 blue:1.0 alpha:1.0];
                break;
        }
        [circle setSelectIndex:index];
        [self.icyTableView setTableHeaderView:circleBackgroundView];
        
        self.currentType = self.icyModel.type;
        if (self.currentType == LCYNewLetterTypePersonal) {
            [self.icySegmentControl setSelectedSegmentIndex:1];
        }
    }
    
    self.isFirstLoad = YES;
    
}

//case LCYLawyerLetterStatusCommit:
//self.icyIconBackView.backgroundColor = [UIColor colorWithRed:0.0 green:205.0/255.0 blue:1.0 alpha:1.0];
//self.icyIconLabel.text = @"提交";
//break;
//case LCYLawyerLetterStatusDraft:
//self.icyIconBackView.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:166.0/255.0 blue:230.0/255.0 alpha:1.0];
//self.icyIconLabel.text = @"起草";
//break;
//case LCYLawyerLetterStatusConfirm:
//self.icyIconBackView.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:203.0/255.0 blue:160.0/255.0 alpha:1.0];
//self.icyIconLabel.text = @"确认";
//break;
//case LCYLawyerLetterStatusSend:
//self.icyIconBackView.backgroundColor = [UIColor colorWithRed:107.0/255.0 green:211.0/255.0 blue:90.0/255.0 alpha:1.0];
//self.icyIconLabel.text = @"发送";
//break;
//case LCYLawyerLetterStatusSavefile:
//self.icyIconBackView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:88.0/255.0 alpha:1.0];
//self.icyIconLabel.text = @"存档";
//break;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isFirstLoad) {
        self.isFirstLoad = NO;
        __weak __typeof(self) weakSelf = self;
        if (![[UserInfoDetail sharedInstance] isUserLogin]) {
            // 访问失败，重新登录
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
            UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"userLoginVC"];
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        } else {
            self.icyUserID = [[UserInfoDetail sharedInstance] getUserID];
        }
    }
}

- (void)configExistModel:(LCYNewLetterModel *)model currentStatus:(LCYLawyerLetterStatus)status{
    self.currentStatus = status;
    self.icyModel = model;
    self.configFlag = @"icylydia";
    [self.editButtonItem setTitle:@"更新信息"];
    
    if (status == LCYLawyerLetterStatusSend ||
        status == LCYLawyerLetterStatusSavefile) {
        [self.editButtonItem setEnabled:NO];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showModify"]) {
        LCYModifyTextViewController *modifyVC = [segue destinationViewController];
        modifyVC.icyIdentifier = sender;
        modifyVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"showWeb"]) {
        LCYWebViewController *webVC = [segue destinationViewController];
        webVC.evidence = sender;
    }
}

- (void)backNavigation:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIEdgeInsets contentInset = self.icyTableView.contentInset;
    contentInset.bottom = 44.0f;
    [self.icyTableView setContentInset:contentInset];
    
    UIEdgeInsets scrollIndicatorInsets = self.icyTableView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = 44.0f;
    [self.icyTableView setScrollIndicatorInsets:scrollIndicatorInsets];
}

#pragma mark - Actions
- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.currentType = LCYNewLetterTypeEnterprise;
    } else {
        self.currentType = LCYNewLetterTypePersonal;
    }
    [self.icyTableView reloadData];
}

- (void)pickImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照后上传", @"从相册上传", nil];
    [actionSheet showInView:self.view];
}

- (void)getCity {
    UIStoryboard *citySB = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
    ZXY_CityZoneVC *cityVC = [citySB instantiateViewControllerWithIdentifier:@"cityVC"];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}
- (IBAction)submmitButtonPressed:(UIBarButtonItem *)sender {
    if (!self.configFlag) {
        if ([self checkValid]) {
            // 数据都可用，上传开始
            NSString *type = self.currentType == LCYNewLetterTypeEnterprise ? @"CT0001" : @"CT0002";
            NSString *represents = self.currentType == LCYNewLetterTypeEnterprise ? self.icyModel.receiverName : @"";
            NSString *problem = self.icyModel.question;
            NSString *phone = self.icyModel.telephone;
            NSString *name = self.currentType == LCYNewLetterTypeEnterprise ? @"" : self.icyModel.receiverName;
            NSString *expectation = self.icyModel.expectation;
            NSString *corporate = self.currentType == LCYNewLetterTypeEnterprise ? self.icyModel.enterprise : @"";
            
            NSString *uid = self.icyUserID;
            
            NSDictionary *province = @{@"id":self.icyModel.province.icyID,
                                       @"name":self.icyModel.province.name};
            NSDictionary *city = @{@"id":self.icyModel.city.icyID,
                                   @"name":self.icyModel.city.name};
            NSDictionary *town = @{@"id":self.icyModel.town.icyID,
                                   @"name":self.icyModel.town.name};
            
            
            NSDictionary *address = @{@"postcode":self.icyModel.postCode,
                                      @"streets":self.icyModel.address,
                                      @"province":province,
                                      @"city":city,
                                      @"town":town};
            
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (LCYNewLetterEvidence *oneEvidence in self.icyModel.evidence) {
                NSDictionary *dictionary = @{@"fileId":oneEvidence.fileID,@"fileName":oneEvidence.fileName};
                [tempArray addObject:dictionary];
            }
            NSArray *evidences = [NSArray arrayWithArray:tempArray];
            
            NSDictionary *parameters = @{
                                         @"uid" : uid,
                                         @"data": @{
                                                 @"address":address,
                                                 @"corporate":corporate,
                                                 @"evidences":evidences,
                                                 @"expectation":expectation,
                                                 @"name":name,
                                                 @"phone":phone,
                                                 @"problem":problem,
                                                 @"represents":represents,
                                                 @"type":type
                                                 }
                                         };
            __weak __typeof(self) weakSelf = self;
            [[LCYNetworking sharedInstance] postRequestWithApi:@"letter/add" parameters:parameters success:^(NSDictionary *responseObject) {
                if (responseObject[@"data"][@"_id"]) {
                    // 成功
                    [weakSelf commitDone];
                } else {
                    [weakSelf parseError:@"提交失败"];
                }
            } failed:^{
                [weakSelf parseError:@"提交失败"];
            }];
            //        NSLog(@"posting to %@ with parameter %@\n-----------------",URLString, parameters);
            //        [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"request header =>>>>>>>%@\n====>%@",operation.request.allHTTPHeaderFields,[[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
            //            NSLog(@"success-->%@",operation.responseString);
            //            // 刷新CSRF
            //            NSDictionary *currentHeader = [operation.response allHeaderFields];
            //            NSString *csrfString = [ZXY_APIFiles getCSRFToken:currentHeader];
            //            [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
            //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            NSLog(@"error==>%@",error);
            //            NSLog(@"response===>%@",operation.responseString);
            //        }];
        }
    } else {
        if ([self checkValid]) {
            // 数据都可用，上传开始
            NSString *type = self.currentType == LCYNewLetterTypeEnterprise ? @"CT0001" : @"CT0002";
            NSString *represents = self.currentType == LCYNewLetterTypeEnterprise ? self.icyModel.receiverName : @"";
            NSString *problem = self.icyModel.question;
            NSString *phone = self.icyModel.telephone;
            NSString *name = self.currentType == LCYNewLetterTypeEnterprise ? @"" : self.icyModel.receiverName;
            NSString *expectation = self.icyModel.expectation;
            NSString *corporate = self.currentType == LCYNewLetterTypeEnterprise ? self.icyModel.enterprise : @"";
            
            NSString *dbID = self.icyModel.dbIdentifier;
            
            NSDictionary *province = @{@"id":self.icyModel.province.icyID,
                                       @"name":self.icyModel.province.name};
            NSDictionary *city = @{@"id":self.icyModel.city.icyID,
                                   @"name":self.icyModel.city.name};
            NSDictionary *town = @{@"id":self.icyModel.town.icyID,
                                   @"name":self.icyModel.town.name};
            
            
            NSDictionary *address = @{@"postcode":self.icyModel.postCode,
                                      @"streets":self.icyModel.address,
                                      @"province":province,
                                      @"city":city,
                                      @"town":town};
            
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (LCYNewLetterEvidence *oneEvidence in self.icyModel.evidence) {
                NSDictionary *dictionary = @{@"fileId":oneEvidence.fileID,@"fileName":oneEvidence.fileName};
                [tempArray addObject:dictionary];
            }
            NSArray *evidences = [NSArray arrayWithArray:tempArray];
            
            NSDictionary *parameters = @{
                                         @"filter": @{
                                                 @"id" : dbID
                                                 },
                                         @"data": @{
                                                 @"address":address,
                                                 @"corporate":corporate,
                                                 @"evidences":evidences,
                                                 @"expectation":expectation,
                                                 @"name":name,
                                                 @"phone":phone,
                                                 @"problem":problem,
                                                 @"represents":represents,
                                                 @"type":type
                                                 }
                                         };
            __weak __typeof(self) weakSelf = self;
            [[LCYNetworking sharedInstance] putRequestWithApi:@"letter/update" parameters:parameters success:^(NSDictionary *responseObject) {
                if (!responseObject[@"error"]) {
                    // 成功
                    [weakSelf commitDone];
                } else {
                    NSString *message = responseObject[@"error"][@"message"];
                    if (message) {
                        [weakSelf parseError:[NSString stringWithFormat:@"提交失败:%@",message]];
                    } else {
                        [weakSelf parseError:[NSString stringWithFormat:@"提交失败。"]];
                    }
                    
                }
            } failed:^{
                [weakSelf parseError:@"提交失败"];
            }];
        }
    }
    
}

- (BOOL)checkValid {
    if (self.currentType == LCYNewLetterTypeEnterprise) {
        // 企业
        // 企业名称
        if (!self.icyModel.enterprise) {
            [self parseError:@"请填写企业名称"];
            return NO;
        } else {
            if (self.icyModel.enterprise.length < 2 || self.icyModel.enterprise.length > 50) {
                [self parseError:@"企业名称请限定在2-50个汉字"];
                return NO;
            }
        }
        // 收件人姓名
        if (!self.icyModel.receiverName) {
            [self parseError:@"请填写负责人姓名"];
            return NO;
        } else {
            if (self.icyModel.receiverName.length < 2 || self.icyModel.receiverName.length > 30) {
                [self parseError:@"负责人姓名请限定在2-30个汉字"];
                return NO;
            }
        }
    } else {
        // 个人
        // 收件人姓名
        if (!self.icyModel.receiverName) {
            [self parseError:@"请填写收函人姓名"];
            return NO;
        } else {
            if (self.icyModel.receiverName.length < 2 || self.icyModel.receiverName.length > 30) {
                [self parseError:@"收函人姓名请限定在2-30个汉字"];
                return NO;
            }
        }
    }
    
    // 联系电话
    if (!self.icyModel.telephone) {
        [self parseError:@"请填写联系电话"];
        return NO;
    } else {
        NSString *pattern = @"(^(\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
        if (![predicate evaluateWithObject:self.icyModel.telephone]) {
            [self parseError:@"请输入合法的电话号码，固定电话区号后请用'-'链接。"];
            return NO;
        }
    }
    
    // 收件地区
    if (!self.icyModel.province || !self.icyModel.city || !self.icyModel.town) {
        [self parseError:@"请选择收函人所在地"];
        return NO;
    }
    
    // 详细地址
    if (!self.icyModel.address) {
        [self parseError:@"请填写详细地址"];
        return NO;
    } else {
        if (self.icyModel.address.length < 5 || self.icyModel.address.length > 120) {
            [self parseError:@"收函人姓名请限定在5-120个汉字"];
            return NO;
        }
    }
    
    // 邮编
    if (!self.icyModel.postCode) {
        [self parseError:@"请填写邮政编码"];
        return NO;
    } else {
        NSString *pattern = @"(^(\\d{6})$)";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
        if (![predicate evaluateWithObject:self.icyModel.postCode]) {
            [self parseError:@"请输入合法的邮政编码"];
            return NO;
        }
    }
    
    // 问题描述
    if (!self.icyModel.question) {
        [self parseError:@"请填写问题描述"];
        return NO;
    } else {
        if (self.icyModel.question.length < 5 || self.icyModel.question.length > 500) {
            [self parseError:@"问题描述请限定在5-500个汉字"];
            return NO;
        }
    }
    
    // 您的期望
    if (!self.icyModel.expectation) {
        [self parseError:@"请填写您的期望"];
        return NO;
    } else {
        if (self.icyModel.expectation.length < 5 || self.icyModel.expectation.length > 500) {
            [self parseError:@"您的期望请限定在5-500个汉字"];
            return NO;
        }
    }
    
    // 证据材料
    if (!self.icyModel.evidence || self.icyModel.evidence.count == 0) {
        [self parseError:@"请上传您的证据材料"];
        return NO;
    } else if (self.icyModel.evidence.count > 10) {
        [self parseError:@"您最多可以上传10个证据材料"];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currentType == LCYNewLetterTypeEnterprise) {
        // 企业
        switch (section) {
            case 0:
                return 6;
                break;
            case 1:
                return 2;
            case 2:
                if (!self.icyModel.evidence) {
                    return 1;
                } else {
                    return self.icyModel.evidence.count + 1;
                }
            default:
                return 0;
                break;
        }
    } else {
        // 个人
        switch (section) {
            case 0:
                return 5;
                break;
            case 1:
                return 2;
            case 2:
                if (!self.icyModel.evidence) {
                    return 1;
                } else {
                    return self.icyModel.evidence.count + 1;
                }
            default:
                return 0;
                break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentType == LCYNewLetterTypeEnterprise) {
        // 企业
        if (indexPath.section == 0) {
            LCYNewLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYNewLetterCellIdentifier];
            if (indexPath.row == 0) {
                // 企业名称
                cell.titleLable.text = @"收函企业名称";
                if (!self.icyModel.enterprise ||
                    [self.icyModel.enterprise isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.enterprise;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 1) {
                // 代表人
                cell.titleLable.text = @"法定代表人或负责人";
                if (!self.icyModel.receiverName ||
                    [self.icyModel.receiverName isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.receiverName;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 2) {
                // 电话
                cell.titleLable.text = @"收函对象电话";
                if (!self.icyModel.telephone ||
                    [self.icyModel.telephone isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.telephone;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 3) {
                // 省市
                cell.titleLable.text = @"收函地区";
                if (!self.icyModel.province.name ||
                    [self.icyModel.province.name isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.icyModel.province.name, self.icyModel.city.name, self.icyModel.town.name];
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 4) {
                // 地址
                cell.titleLable.text = @"详细地址";
                if (!self.icyModel.address ||
                    [self.icyModel.address isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.address;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 5) {
                // 邮编
                cell.titleLable.text = @"邮政编码";
                if (!self.icyModel.postCode ||
                    [self.icyModel.postCode isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.postCode;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            }
            return cell;
        } else if (indexPath.section == 2) {
            if (!self.icyModel.evidence || self.icyModel.evidence.count == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCYNewLetterUploadIdentifier"];
                return cell;
            } else {
                if (indexPath.row == self.icyModel.evidence.count) {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCYNewLetterUploadIdentifier"];
                    return cell;
                } else if (indexPath.row == 0) {
                    LCYNewLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYNewLetterCellIdentifier];
                    cell.titleLable.text = @"证据材料";
                    LCYNewLetterEvidence *evidence = self.icyModel.evidence[indexPath.row];
                    cell.contentLabel.text = evidence.fileName;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                    return cell;
                } else {
                    LCYNewLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYNewLetterCellIdentifier];
                    cell.titleLable.text = @"";
                    LCYNewLetterEvidence *evidence = self.icyModel.evidence[indexPath.row];
                    cell.contentLabel.text = evidence.fileName;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                    return cell;
                }
            }
        } else {
            LCYNewLetterDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYNewLetterDynamicCellIdentifier];
            if (indexPath.row == 0) {
                cell.icyTitleLabel.text = @"问题描述";
                if (!self.icyModel.question ||
                    [self.icyModel.question isEqualToString:@""]) {
                    cell.icyContentLabel.text = @"请填写";
                    [cell.icyContentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.icyContentLabel.text = self.icyModel.question;
                    [cell.icyContentLabel setTextColor:[UIColor blackColor]];
                }
                [cell.icyContentLabel sizeToFit];
            } else {
                cell.icyTitleLabel.text = @"您的期望";
                if (!self.icyModel.expectation ||
                    [self.icyModel.expectation isEqualToString:@""]) {
                    cell.icyContentLabel.text = @"请填写";
                    [cell.icyContentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.icyContentLabel.text = self.icyModel.expectation;
                    [cell.icyContentLabel setTextColor:[UIColor blackColor]];
                }
                [cell.icyContentLabel sizeToFit];
            }
            return cell;
        }
    } else {
        // 个人
        if (indexPath.section == 0) {
            LCYNewLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYNewLetterCellIdentifier];
            if (indexPath.row == 0) {
                // 收函人姓名
                cell.titleLable.text = @"收函人姓名";
                if (!self.icyModel.receiverName ||
                    [self.icyModel.receiverName isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.receiverName;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 1) {
                // 电话
                cell.titleLable.text = @"收函对象电话";
                if (!self.icyModel.telephone ||
                    [self.icyModel.telephone isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.telephone;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 2) {
                // 省市
                cell.titleLable.text = @"收函地区";
                if (!self.icyModel.province.name ||
                    [self.icyModel.province.name isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.icyModel.province.name, self.icyModel.city.name, self.icyModel.town.name];
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 3) {
                // 地址
                cell.titleLable.text = @"详细地址";
                if (!self.icyModel.address ||
                    [self.icyModel.address isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.address;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            } else if (indexPath.row == 4) {
                // 邮编
                cell.titleLable.text = @"邮政编码";
                if (!self.icyModel.postCode ||
                    [self.icyModel.postCode isEqualToString:@""]) {
                    cell.contentLabel.text = placeHolderForEmptyCell;
                    [cell.contentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.contentLabel.text = self.icyModel.postCode;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                }
            }
            return cell;
        } else if (indexPath.section == 2) {
            if (!self.icyModel.evidence || self.icyModel.evidence.count == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCYNewLetterUploadIdentifier"];
                return cell;
            } else {
                if (indexPath.row == self.icyModel.evidence.count) {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCYNewLetterUploadIdentifier"];
                    return cell;
                } else if (indexPath.row == 0) {
                    LCYNewLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYNewLetterCellIdentifier];
                    cell.titleLable.text = @"证据材料";
                    LCYNewLetterEvidence *evidence = self.icyModel.evidence[indexPath.row];
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                    cell.contentLabel.text = evidence.fileName;
                    return cell;
                } else {
                    LCYNewLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYNewLetterCellIdentifier];
                    cell.titleLable.text = @"";
                    LCYNewLetterEvidence *evidence = self.icyModel.evidence[indexPath.row];
                    cell.contentLabel.text = evidence.fileName;
                    [cell.contentLabel setTextColor:[UIColor blackColor]];
                    return cell;
                }
            }
        } else {
            LCYNewLetterDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYNewLetterDynamicCellIdentifier];
            if (indexPath.row == 0) {
                cell.icyTitleLabel.text = @"问题描述";
                if (!self.icyModel.question ||
                    [self.icyModel.question isEqualToString:@""]) {
                    cell.icyContentLabel.text = @"请填写";
                    [cell.icyContentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.icyContentLabel.text = self.icyModel.question;
                    [cell.icyContentLabel setTextColor:[UIColor blackColor]];
                }
                [cell.icyContentLabel sizeToFit];
            } else {
                cell.icyTitleLabel.text = @"您的期望";
                if (!self.icyModel.expectation ||
                    [self.icyModel.expectation isEqualToString:@""]) {
                    cell.icyContentLabel.text = @"请填写";
                    [cell.icyContentLabel setTextColor:[UIColor lightGrayColor]];
                } else {
                    cell.icyContentLabel.text = self.icyModel.expectation;
                    [cell.icyContentLabel setTextColor:[UIColor blackColor]];
                }
                [cell.icyContentLabel sizeToFit];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentType == LCYNewLetterTypeEnterprise) {
        // 企业
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    // 企业
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierEnterprese];
                    break;
                case 1:
                    // 负责人
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierPersonName];
                    break;
                case 2:
                    // 电话
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierTelephone];
                    break;
                case 3:
                    // 地区
                    [self getCity];
                    break;
                case 4:
                    // 地址
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierAddress];
                    break;
                case 5:
                    // 邮编
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierPostcode];
                    break;
                default:
                    break;
            }
        } else if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                    // 问题
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierQuestion];
                    break;
                case 1:
                    // 期望
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierExpection];
                    break;
                default:
                    break;
            }
        } else {
            if (!self.icyModel.evidence || self.icyModel.evidence.count == 0) {
                [self pickImage];
            } else {
                if (indexPath.row == self.icyModel.evidence.count) {
                    [self pickImage];
                } else {
                    LCYNewLetterEvidence *evidence = self.icyModel.evidence[indexPath.row];
                    [self performSegueWithIdentifier:@"showWeb" sender:evidence];
                }
            }
        }
    } else {
        // 个人
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    // 负责人
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierPersonName];
                    break;
                case 1:
                    // 电话
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierTelephone];
                    break;
                case 2:
                    // 地区
                    [self getCity];
                    break;
                case 3:
                    // 地址
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierAddress];
                    break;
                case 4:
                    // 邮编
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierPostcode];
                    break;
                default:
                    break;
            }
        } else if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                    // 问题
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierQuestion];
                    break;
                case 1:
                    // 期望
                    [self performSegueWithIdentifier:@"showModify" sender:modifyIdentifierExpection];
                    break;
                default:
                    break;
            }
        } else {
            if (!self.icyModel.evidence || self.icyModel.evidence.count == 0) {
                [self pickImage];
            } else {
                if (indexPath.row == self.icyModel.evidence.count) {
                    [self pickImage];
                } else {
                    LCYNewLetterEvidence *evidence = self.icyModel.evidence[indexPath.row];
                    [self performSegueWithIdentifier:@"showWeb" sender:evidence];
                }
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f; // header height
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        // 需要计算
        if (indexPath.row == 0) {
            // 问题描述
            if (!self.icyModel.question ||
                [self.icyModel.question isEqualToString:@""]) {
                return 44.0f;
            } else {
                CGSize size = [self.icyModel.question boundingRectWithSize:CGSizeMake(200.0f, 40000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
                return size.height + 16.0f >= 44 ? size.height + 16.0f : 44.0f;
            }
        } else {
            // 期望
            if (!self.icyModel.expectation ||
                [self.icyModel.expectation isEqualToString:@""]) {
                return 44.0f;
            } else {
                CGSize size = [self.icyModel.expectation boundingRectWithSize:CGSizeMake(200.0f, 40000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
                return size.height + 16.0f >= 44 ? size.height + 16.0f : 44.0f;
            }
        }
    } else {
        return 44.0f;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (!self.icyModel.evidence ||
            [self.icyModel.evidence count] == 0) {
            return NO;
        } else {
            if (indexPath.row < self.icyModel.evidence.count) {
                return YES;
            }
        }
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除数据源
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.icyModel.evidence];
        [tempArray removeObjectAtIndex:indexPath.row];
        self.icyModel.evidence = tempArray;
        // 删除该行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 拍照后上传
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else if(buttonIndex == 1){
        // 从相册上传
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
    
    }
}

#pragma mark - UIImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    UIImage *scaledImage = [UIImage imageWithImage:pickedImage scaledToFitToSize:kImageMaxSize];
    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *timeString = [formatter stringFromDate:date];
    
    NSString *fileName = [NSString stringWithFormat:@"iOS%@.jpg", timeString];
    
    [self uploadImageData:imageData withName:fileName];
}

- (void)uploadImageData:(NSData *)imageData withName:(NSString *)name {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在上传"];
    __weak __typeof(self) weakSelf = self;
    [[LCYUploader sharedInstance] uploadImageData:imageData progress:nil fileName:name successBlock:^(NSDictionary *object) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSString *fileName = object[@"data"][0][@"name"];
        NSString *fileID = object[@"data"][0][@"_id"];
        if (!fileName || !fileID) {
            [weakSelf parseError:@"解析失败"];
        } else {
            LCYNewLetterEvidence *evidence = [[LCYNewLetterEvidence alloc] init];
            evidence.fileName = fileName;
            evidence.fileID = fileID;
            NSMutableArray *tempArray = weakSelf.icyModel.evidence?[NSMutableArray arrayWithArray:weakSelf.icyModel.evidence]:[NSMutableArray array];
            [tempArray addObject:evidence];
            weakSelf.icyModel.evidence = tempArray;
            [weakSelf.icyTableView reloadData];
        }
    } failedBlock:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf parseError:@"上传失败"];
    }];
}

- (void)parseError:(NSString *)errorString {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)commitDone {
    UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交成功。" delegate:self
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
    doneAlert.tag = kSuccessAlert;
    [doneAlert show];
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kSuccessAlert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - LCYModifyViewControllerDelegate
- (void)modifyTextVC:(LCYModifyTextViewController *)viewController didFinishChangeText:(NSString *)text atField:(NSString *)identifier {
    if ([identifier isEqualToString:modifyIdentifierEnterprese]) {
        self.icyModel.enterprise = text;
    } else if ([identifier isEqualToString:modifyIdentifierPersonName]) {
        self.icyModel.receiverName = text;
    } else if ([identifier isEqualToString:modifyIdentifierTelephone]) {
        self.icyModel.telephone = text;
    } else if ([identifier isEqualToString:modifyIdentifierAddress]) {
        self.icyModel.address = text;
    } else if ([identifier isEqualToString:modifyIdentifierPostcode]) {
        self.icyModel.postCode = text;
    } else if ([identifier isEqualToString:modifyIdentifierQuestion]) {
        self.icyModel.question = text;
    } else if ([identifier isEqualToString:modifyIdentifierExpection]) {
        self.icyModel.expectation = text;
    }
    [self.icyTableView reloadData];
}

#pragma mark - ZXYChooseCicyDelegate
- (void)userChooseCityDelegate:(LawCityEntity *)provinceEntity andCityEntity:(LawCityEntity *)cityEntity withZoneEntity:(LawCityEntity *)zoneEntity {
    if (!self.icyModel.province) {
        self.icyModel.province = [[LCYNewLetterLocation alloc] init];
    }
    if (!self.icyModel.city) {
        self.icyModel.city = [[LCYNewLetterLocation alloc] init];
    }
    if (!self.icyModel.town) {
        self.icyModel.town = [[LCYNewLetterLocation alloc] init];
    }
    
    self.icyModel.province.name = provinceEntity.name;
    self.icyModel.province.icyID = provinceEntity.cityID;
    self.icyModel.city.name = cityEntity.name;
    self.icyModel.city.icyID = cityEntity.cityID;
    self.icyModel.town.name = zoneEntity.name;
    self.icyModel.town.icyID = cityEntity.cityID;
    [self.icyTableView reloadData];
}

@end
