//
//  ZXY_SingleLawServiceVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_SingleLawServiceVC.h"
#import "ZXY_SingleServiceLowerCell.h"
#import "ZXY_SingleServiceUpperCell.h"
#import "ZXY_ServiceLetterVC.h"
#import <AFNetworking/AFNetworking.h>
#import "LawEntityHelper.h"
#import "UserServiceInfo.h"
#import "ZXY_UserLoginVC.h"
#import "ZXY_NewAuditContractVC.h"
#import "ZXY_ServiceContractAddVC.h"
#import "LCYLawyerNewLetterViewController.h"
#import "ZXY_FirstSctionDetailInfoVC.h"
#import "ZXY_SecondSectionDetailInfoVC.h"
#import "LCYLawyerLetterViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZXY_LetterAddVC.h"
#import "ZXY_PayVC.h"

@interface ZXY_SingleLawServiceVC ()<UIAlertViewDelegate>
{
    
    __weak IBOutlet UILabel *moreInfo;
    __weak IBOutlet UILabel *firstRow;
    __weak IBOutlet UILabel *secondRow;
    __weak IBOutlet UILabel *addNewServiceLbl;
    __weak IBOutlet UIActivityIndicatorView *waitIndicator;
    __weak IBOutlet UILabel *remainLbl;
    ServiceSingleType _currentType;
    NSString *serviceTypeID;
    NSDictionary *listInfo;
    __weak IBOutlet UIImageView *backImage;
    __weak IBOutlet UIView *addBtnOfView;
    __weak IBOutlet UILabel *productInfo;
    __weak IBOutlet UILabel *singlePrice;
    __weak IBOutlet UILabel *sumPrice;
    __weak IBOutlet UILabel *numLbl;
    __weak IBOutlet UIImageView *jianfaLbl;
    __weak IBOutlet UIImageView *jiafaLbl;
    NSDictionary    *productInfoDic;
    NSDictionary    *dataInfoOfThis;
    NSDictionary    *orderInfo;
    NSString        *productID;
    NSNumber        *disCountNum;
    NSString        *unitString;
    float           floatPrice;
    float           floatDiscount;
    BOOL            isFirstLoad;
    //NSDictionary    *productInfoDic;
}
- (IBAction)buyAction:(id)sender;
@end

@implementation ZXY_SingleLawServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES;
    moreInfo.textColor= [UIColor grayColor];
    [self initNavi];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    if(_currentType == ServiceSingleConsult||_currentType== ServiceSingleTrain)
    {
        [addBtnOfView setHidden:YES];
    }
    
    if(![UserInfoDetail sharedInstance].isUserLogin)
    {
        [addBtnOfView setHidden:YES];
    }
    backImage.backgroundColor = [UIColor grayColor];
    addNewServiceLbl.text = [self returnAddLblText];
        // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    numLbl.text = @"1";
    [self startDownRemain];
    [self startLoad];
    [self startGetServiceInfo];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    [self setNaviTitle:[self titleForThis] withPositon:1];
}

- (NSString *)titleForThis
{
    if(_currentType == ServiceSingleLetter)
    {
        serviceTypeID = @"ST0002";
        return @"签发律师函";
    }
    else if(_currentType == ServiceSingleAudit)
    {
        serviceTypeID = @"ST0004";
        return @"合同审核";
    }
    else if(_currentType == ServiceSingleDraft)
    {
        serviceTypeID = @"ST0003";
        return @"合同起草";
    }
    else if (_currentType == ServiceSingleTrain)
    {
         serviceTypeID = @"ST0005";
         return @"法律培训";
    }
    else
    {
        serviceTypeID = @"ST0001";
        return @"法律咨询";
    }

}

- (void)setSingleServiceVCType:(ServiceSingleType)currentType
{
    _currentType = currentType;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isFirstLoad = YES;
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(isFirstLoad)
    {
        if(_currentType == ServiceSingleTrain || _currentType==ServiceSingleConsult)
        {
            if([addBtnOfView isHidden])
            {
                productInfo.frame = CGRectMake(productInfo.frame.origin.x, productInfo.frame.origin.y-30, productInfo.frame.size.width, productInfo.frame.size.height);
                isFirstLoad = NO;
            }
        }
        
    }
}

- (void)startDownRemain
{
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
        return;
    }
    if(_currentType == ServiceSingleTrain || _currentType == ServiceSingleConsult)
    {
        [addBtnOfView setHidden:YES];
        return;
    }
    else
    {
        [waitIndicator startAnimating];
        backImage.backgroundColor = [UIColor grayColor];
        [remainLbl setHidden:YES];
        [addNewServiceLbl setTextColor:[UIColor whiteColor]];
        [addNewServiceLbl setText:[self returnAddLblText]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        NSString *csrfToken = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
        NSString *realCSRF  = [ZXY_APIFiles encode:csrfToken];
        NSString *urlString = [NSString stringWithFormat:@"%@%@?_csrf=%@",API_HOST_URL,API_SERVICE_LIST_URL,realCSRF];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *data = [operation responseData];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
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
                if(serviceInfoArr.count >0)
                {
                    UserServiceInfo *serviceInfo = [serviceInfoArr objectAtIndex:0];
                    NSNumber *remainNum = [serviceInfo remainAmounttotal];
                    NSInteger remainInt = remainNum.integerValue;
                    if(remainInt >0)
                    {
//                        [remainLbl setHidden:NO];
                        NSString *reaminString = [NSString stringWithFormat:@"(%ld)",(long)remainInt];
                        UIColor *naviClor = NAVIBARCOLOR;
                        [addNewServiceLbl setTextColor:[UIColor whiteColor]];
                        addNewServiceLbl.userInteractionEnabled = YES;
                        addNewServiceLbl.text = [NSString stringWithFormat:@"%@%@",[self returnAddLblText],reaminString];
                        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAddService)];
                        [addNewServiceLbl addGestureRecognizer:tapGes];
                        backImage.backgroundColor = naviClor;
                    }
                    else
                    {
//                        [remainLbl setHidden:NO];
//                        remainLbl.text = [NSString stringWithFormat:@"(0)"];
//                        remainLbl.textColor = [UIColor grayColor];
                    }
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [addBtnOfView setHidden:YES];
            [waitIndicator stopAnimating];
            //        [self performSegueWithIdentifier:@"toLoginVC" sender:self];
            //                NSLog(@"%@",error);
        }];
    }
    
}

- (void)startLoad
{
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
        return;
    }
    NSString *urlString ;
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    if(_currentType == ServiceSingleLetter)
    {
        urlString = [NSString stringWithFormat:@"%@%@?_csrf=%@&limit=%d&skip=%d",API_HOST_URL,API_LETTERLIST_URL,afterCSRF,2,0];
    }
    else if (_currentType == ServiceSingleAudit)
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&skip=%d&limit=%d",API_HOST_URL,API_AUDITLIST_URL,afterCSRF,0,2];
    }
    else if (_currentType == ServiceSingleDraft)
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&skip=%d&limit=%d",API_HOST_URL,API_DRAFTLIST_URL,afterCSRF,0,2];
    }
    else if (_currentType == ServiceSingleConsult)
    {
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&limit=%d&skip=%d",API_HOST_URL,API_USER_LAWCONSULT,afterCSRF,2,0];
    }
    else
    {
        NSString *downLoadMode ;
        downLoadMode = @"user";
        urlString  = [NSString stringWithFormat:@"%@%@?_csrf=%@&mode=%@&skip=%d&limit=%d",API_HOST_URL,API_USER_LAWTRAIN,afterCSRF,downLoadMode,0,2];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *currentHeader = [operation.response allHeaderFields];
        NSString *csrfString = [ZXY_APIFiles getCSRFToken:currentHeader];
        [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
        NSLog(@"%@",operation.responseString);
        NSData *returnData = [operation responseData];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        dataInfoOfThis = [NSDictionary dictionaryWithDictionary:jsonDic];
        [self loadRowData:dataInfoOfThis];
        [moreInfo setUserInteractionEnabled:YES];
        moreInfo.textColor = NAVIBARCOLOR;
        UITapGestureRecognizer *tapMore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreInfo)];
        [moreInfo addGestureRecognizer:tapMore];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
//        [self showAlertWarnningView:@"提示" andContent:@"登陆超时请重新登陆"];
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
//        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
////        loginVC.onComplete = ^()
////        {
////            [self startLoad];
////        };
//        [self.navigationController pushViewController:loginVC animated:YES];
        //[self performSegueWithIdentifier:@"toLoginVC" sender:self];
    }];


}

- (void)loadRowData:(NSDictionary *)jsonDic
{
    NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
    NSDictionary *optionDic = [dataDic objectForKey:@"options"];
    //NSDictionary *userDic  = [optionDic objectForKey:@"user"];
    NSArray *allArray = [dataDic objectForKey:@"items"];
    NSDictionary *cateDic = [optionDic objectForKey:@"category"];
    
    if(_currentType == ServiceSingleAudit)
    {
        for(int i = 0;i<allArray.count;i++)
        {
            NSDictionary *dicInfo = [allArray objectAtIndex:i];
            if(i == 0)
            {
                NSArray *originalArr = [dicInfo objectForKey:@"originalContract"];
                NSDictionary *firstForshowDic = [originalArr objectAtIndex:0];
                firstRow.text = [firstForshowDic objectForKey:@"fileName"];
            }
            else if (i == 1)
            {
                NSArray *originalArr = [dicInfo objectForKey:@"originalContract"];
                NSDictionary *firstForshowDic = [originalArr objectAtIndex:0];
                secondRow.text = [firstForshowDic objectForKey:@"fileName"];
            }
        }
    }
    else if (_currentType == ServiceSingleConsult)
    {
        for(int i = 0;i<allArray.count;i++)
        {
            NSDictionary *dicInfo = [allArray objectAtIndex:i];
            if(i == 0)
            {
                NSString *content   = [dicInfo objectForKey:@"question"];
                firstRow.text       = content;
            }
            else if (i == 1)
            {
                NSString *content   = [dicInfo objectForKey:@"question"];
                secondRow.text       = content;
            }
        }

    }
    else if (_currentType == ServiceSingleDraft)
    {
        for(int i = 0;i<allArray.count;i++)
        {
            NSDictionary *dicInfo = [allArray objectAtIndex:i];
            if(i == 0)
            {
                NSString *typeString      = [dicInfo objectForKey:@"type"];
                NSString *firstRowString  = [[cateDic objectForKey:typeString] objectForKey:@"name"];
                firstRow.text       = firstRowString;
            }
            else if (i == 1)
            {
                NSString *typeString      = [dicInfo objectForKey:@"type"];
                NSString *firstRowString  = [[cateDic objectForKey:typeString] objectForKey:@"name"];
                secondRow.text       = firstRowString;
            }
        }

    }
    else if (_currentType == ServiceSingleLetter)
    {
        for(int i = 0;i<allArray.count;i++)
        {
            NSDictionary *dicInfo = [allArray objectAtIndex:i];
            if(i == 0)
            {
                if([[dicInfo objectForKey:@"type" ] isEqualToString:@"CT0001"])
                {
                    NSString *firstRowString  = [dicInfo objectForKey:@"represents"];
                    firstRow.text       = firstRowString;
                }
                else
                {
                    NSString *firstRowString  = [dicInfo objectForKey:@"name"];
                    firstRow.text       = firstRowString;
                }
            }
            else if (i == 1)
            {
                if([[dicInfo objectForKey:@"type" ] isEqualToString:@"CT0001"])
                {
                    NSString *firstRowString  = [dicInfo objectForKey:@"represents"];
                    secondRow.text       = firstRowString;
                }
                else
                {
                    NSString *firstRowString  = [dicInfo objectForKey:@"name"];
                    secondRow.text       = firstRowString;
                }

            }
        }

    }
    else
    {
        for(int i = 0;i<allArray.count;i++)
        {
            NSDictionary *dicInfo = [allArray objectAtIndex:i];
            if(i == 0)
            {
                NSString *firstRowString  = [dicInfo objectForKey:@"name"];
                firstRow.text       = firstRowString;
            }
            else if (i == 1)
            {
                NSString *firstRowString  = [dicInfo objectForKey:@"name"];
                secondRow.text       = firstRowString;
            }
        }

    }
    
}

- (void)moreInfo
{
    if(![[UserInfoDetail sharedInstance] isUserLogin])
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
        //[self performSegueWithIdentifier:@"toLoginVC" sender:self];
        return;

    }
    //firstSectionID
    //secondSectionID
    if(_currentType == ServiceSingleConsult)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_FirstSctionDetailInfoVC *first = [story instantiateViewControllerWithIdentifier:@"firstSectionID"];
        [first setFirstSectionType:LawConsultType];
        [self.navigationController pushViewController:first animated:YES];
    }
    else if (_currentType == ServiceSingleAudit)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_SecondSectionDetailInfoVC *second = [story instantiateViewControllerWithIdentifier:@"secondSectionID"];
        [second setSecondSectionType:SecondAuditType];
        [self.navigationController pushViewController:second animated:YES];
    }
    else if (_currentType == ServiceSingleTrain)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_FirstSctionDetailInfoVC *first = [story instantiateViewControllerWithIdentifier:@"firstSectionID"];
        [first setFirstSectionType:LawTrainType];
        [self.navigationController pushViewController:first animated:YES];
    }
    else if (_currentType == ServiceSingleDraft)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_SecondSectionDetailInfoVC *second = [story instantiateViewControllerWithIdentifier:@"secondSectionID"];
        [second setSecondSectionType:SecondDraftType];
        [self.navigationController pushViewController:second animated:YES];
    }
    else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_SecondSectionDetailInfoVC *vc = [story instantiateViewControllerWithIdentifier:@"secondSectionID"];
        [vc setSecondSectionType:SecondLetterType];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)returnAddLblText
{
    if(_currentType == ServiceSingleLetter)
    {
        //serviceTypeID = @"ST0002";
        return @"新的签发";
    }
    else if(_currentType == ServiceSingleAudit)
    {
        //serviceTypeID = @"ST0004";
        return @"新的审核";
    }
    else if(_currentType == ServiceSingleDraft)
    {
        //serviceTypeID = @"ST0003";
        return @"新的起草";
    }
    else if (_currentType == ServiceSingleTrain)
    {
         return @"";
    }
    else
    {
        return @"";
    }
}

- (void)startGetServiceInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_USER_SERVICELISTSINGLE];
    NSDictionary *parameter = @{
                                @"nameId":serviceTypeID
                                };
    [self startLoadDataGETCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        
        productInfoDic = [dicInfo objectForKey:@"data"];
        NSArray *items = [productInfoDic objectForKey:@"items"];
        
        NSDictionary *showInfo = [items objectAtIndex:0];
        //NSDictionary *dataForShow = [dicInfo objectForKey:@""]
                /**
         *
         */
        productID        = [showInfo objectForKey:@"_id"];
        [self startGetDisCount];
        productInfo.text = showInfo[@"description"];
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)startGetDisCount
{
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_PRODUCTDETAIL_URL];
    NSDictionary *parameter = @{
                                @"id":productID
                                };
    [self startLoadDataGETCSRF:stringURL withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        disCountNum = responseDic[@"data"][@"discount"];
        NSArray *items = [productInfoDic objectForKey:@"items"];
        NSString *nameID = responseDic[@"data"][@"product"][@"nameId"];
        NSString *idStirng = responseDic[@"data"][@"product"][@"options"][@"category"][nameID][@"_id"];
        NSDictionary *showInfo = [items objectAtIndex:0];
        NSNumber *price  = showInfo[@"price"];
        floatPrice = price.floatValue;
        if([[UserInfoDetail sharedInstance] isUserLogin])
        {
            floatDiscount   = disCountNum.floatValue;
        }
        else
        {
            floatDiscount   = 100;
        }
        float    currentPrice = floatDiscount*floatPrice/100;
        
        unitString          = [responseDic[@"data"][@"serviceTypeInfo"][@"items"] objectAtIndex:0][@"value"];
        NSArray   *allServices = responseDic[@"data"][@"serviceTypeInfo"][@"items"];
        for(int i = 0;i<allServices.count;i++)
        {
            NSDictionary *currentP = [allServices objectAtIndex:i];
            if([[currentP objectForKey:@"_id"] isEqualToString:idStirng])
            {
                unitString = [currentP objectForKey:@"value"];
                if([unitString isEqualToString:@"分钟"])
                {
                    unitString = @"小时";
                }

            }
        }
        singlePrice.text = [NSString stringWithFormat:@"单价:%.0f元/%@",price.floatValue,unitString];
        sumPrice.text    = [NSString stringWithFormat:@"总计:%.0f元",currentPrice];
        
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMethod)];
        [jiafaLbl addGestureRecognizer:tapGes];
        
        UITapGestureRecognizer *tapGesTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subtracteMethod)];
        [jianfaLbl addGestureRecognizer:tapGesTwo];

    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)startAddService
{
    
    NSLog(@"可以添加");
    if(_currentType == ServiceSingleLetter)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_LetterAddVC *vc = [story instantiateViewControllerWithIdentifier:@"letterVCID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_currentType == ServiceSingleAudit)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"ZXY_NewServiceStory" bundle:nil];
        ZXY_NewAuditContractVC *auditVC  =  [story instantiateInitialViewController];
        [self.navigationController pushViewController:auditVC animated:YES];
    }
    else if (_currentType == ServiceSingleDraft)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_ServiceContractAddVC *vc = [story instantiateViewControllerWithIdentifier:@"contractAdd"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)addMethod
{
    NSString *valueNumber = numLbl.text;
    NSInteger num = valueNumber.integerValue;
    numLbl.text = [NSString stringWithFormat:@"%d",num+1];
    //NSArray *items = [productInfoDic objectForKey:@"items"];
    //NSDictionary *showInfo = [items objectAtIndex:0];
    //NSNumber     *price    = [showInfo objectForKey:@"price"];
    
    //floatPrice = price.floatValue;
    floatDiscount   = disCountNum.floatValue;
    float    currentPrice = floatDiscount*floatPrice/100;
    sumPrice.text    = [NSString stringWithFormat:@"总计:%.0f元",currentPrice*(num+1)];
}

- (void)subtracteMethod
{
    NSString *valueNumber = numLbl.text;
    NSInteger num = valueNumber.integerValue;
    if(num == 1)
    {
        return;
    }
    numLbl.text = [NSString stringWithFormat:@"%d",num-1];
    //NSArray *items = [productInfoDic objectForKey:@"items"];
    //NSDictionary *showInfo = [items objectAtIndex:0];
    //NSNumber     *price    = [showInfo objectForKey:@"price"];
    //floatPrice = price.floatValue;
    floatDiscount   = disCountNum.floatValue;
    float    currentPrice = floatDiscount*floatPrice/100;
    sumPrice.text    = [NSString stringWithFormat:@"总计：%.0f元 ",currentPrice*(num-1)];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toLetterVC"])
    {
        ZXY_ServiceLetterVC *letterVC = [segue destinationViewController];
        letterVC.isUserAdd = YES;
    }
    if([segue.identifier isEqualToString:@"toPayView"])
    {
        ZXY_PayVC *pay = [segue destinationViewController];
        NSArray *items = [productInfoDic objectForKey:@"items"];
        
        NSDictionary *showInfo = [items objectAtIndex:0];
        NSString *singlePrices     = [showInfo objectForKey:@"price"];
        NSString *numStrings       = numLbl.text;
        float currentPrice         = singlePrices.floatValue * numStrings.floatValue*floatDiscount*0.01;
        [pay setOrderInfo:orderInfo andProductInfo:productInfoDic withPrice:currentPrice andNum:numLbl.text  isLCY:NO];
    }
}


- (IBAction)buyAction:(id)sender
{
    if(productInfoDic == nil)
    {
        return;
    }
    NSString *_id ;
    NSArray *items = [productInfoDic objectForKey:@"items"];
    for(int i =0 ;i<items.count;i++)
    {
        _id = [[items objectAtIndex:i] objectForKey:@"_id"];
    }
    NSString *uid = [[UserInfoDetail sharedInstance] getUserID];
    NSString *countString = numLbl.text;
    NSDictionary *parameter;
    @try {
        parameter = @{
                      @"productId":_id,
                      @"type":@"product",
                      @"uid":uid,
                      @"count":[NSNumber numberWithInt:countString.intValue]
                      };
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您是否确定购买该产品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    @catch (NSException *exception) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    @finally {
        
    }

}

- (void)startBuy
{
    if(productInfoDic == nil)
    {
        return;
    }
    //NSDictionary *options = [productInfoDic objectForKey:@"options"];
    //NSDictionary *cateDic = [options objectForKey:@"category"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *_id ;
    NSArray *items = [productInfoDic objectForKey:@"items"];
    for(int i =0 ;i<items.count;i++)
    {
        _id = [[items objectAtIndex:i] objectForKey:@"_id"];
    }
    NSString *uid = [[UserInfoDetail sharedInstance] getUserID];
    NSString *countString = numLbl.text;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_BUYACTION_GETINFO];
    NSDictionary *parameter;
    @try {
        parameter = @{
                      @"productId":_id,
                      @"type":@"product",
                      @"uid":uid,
                      @"count":[NSNumber numberWithInt:countString.intValue]
                      };
        
    }
    @catch (NSException *exception) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    @finally {
        
    }
    [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([returnDic.allKeys containsObject:@"error"])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *errorDic = [returnDic objectForKey:@"error"];
            NSString     *message  = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:@"" andContent:message];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            orderInfo = [returnDic objectForKey:@"data"];
            [self performSegueWithIdentifier:@"toPayView" sender:self];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        // [self showAlertWarnningView:@"提示" andContent:@"出现错误"];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self startBuy];
    }
}
@end
