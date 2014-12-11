//
//  ZXY_AddCaseVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/12.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_AddCaseVC.h"
#import "ZXY_MyCaseChooseCell.h"
#import "ZXY_MyCaseFeeCell.h"
#import "ZXY_MyCaseChooseCityCell.h"
#import "ZXY_MyCaseChooseRoleCell.h"
#import "ZXY_MyCaseFileAttrCell.h"
#import "ZXY_MyCaseMoneyCell.h"
#import "ZXY_MyCaseBtnCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LawCaseTypeEntity.h"
#import "LawEntityHelper.h"
#import "LawCityEntity.h"
#import "ZXY_CityZoneVC.h"
#import "ELCImagePickerHeader.h"
#import "ZXY_WebVC.h"
#import "ZXY_SearchLawerVC.h"
#import "LCYLawyerDetailViewController.h"
#import "ZXY_LawReplyCell.h"
#import "ZXY_PayVC.h"
#import "ZXY_MyCaseTextCell.h"
#import "ZXY_MyCaseBaseCell.h"
#import "ZXY_MyCaseTitleCell.h"
#import "ZXY_MyCaseEvaluLawVC.h"
#import "ZXY_MyCaseDifferentVC.h"
#import "ZXY_LawCircleView.h"
#import "ZXY_MyCaseFeeForListCell.h"
#import "ZXY_MyCaseDownFileCell.h"
typedef enum
{
    DelegateInfoType   = 0,
    DelegateHandleType = 1,
    DelegatePayHistory = 2,
}CurrentDelegateType;
@interface ZXY_AddCaseVC ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,ZXY_ChooseCityDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,ZXY_LawReplyDelegate>
{
    __weak IBOutlet UIButton *cancelBtn;
    __weak IBOutlet UIButton *freshBtn;
    __weak IBOutlet UIView *delegateView;
    __weak IBOutlet UIButton *submitBtn;
    NSMutableArray *allFileArr;
    __weak IBOutlet UITableView *currentTable;
    NSMutableArray *allLawerArr;
    //NSMutableArray *allCaseType;
    //NSArray        *professionArr;
    UITextField    *moneyText;
    NSString       *moneyString;
    UIToolbar *topBar;
    NSDictionary *currentCase;
    LawCityEntity *_provinceEntity;
    LawCityEntity *_cityEntity;
    IBOutlet UIView *pickView;
    __weak IBOutlet UIPickerView *pickVC;
    NSString *_currentRole;
    UIActionSheet  *picherSheet;
    NSDictionary   *currentSelectAttr;
    NSString       *agencyCost;
    NSString       *total;
    NSString       *discounted;
    NSString       *_caseID;
    NSDictionary   *_currentCaseInfo;
    NSString       *_status;
    NSString       *_stage;
    BOOL           isFinish;
    NSMutableArray *replyLawyerArr;
    NSString *delegateLawID;
    UIColor  *originColor;
    NSString *floatMoney;
    NSDictionary *delegateLawDic;
    CurrentDelegateType currentPageType;
    NSMutableArray *replyArr  ; /**< 被告答辩状*/
    NSMutableArray *attorneyArr ; /**< 原告被告授权委托书*/
    NSMutableArray *complaint;   /**< 原告诉状*/
    NSMutableArray *evidenceListArr ;/**< 原告证据目录*/
    NSMutableArray *notiBookArr;  /**< 立案通知书*/
    NSMutableArray *caseFileArr ; /**< 诉讼费数据*/
    NSMutableArray *tokenArr    ; /**< 传票*/
    NSMutableArray *judgeArr    ; /**< 判决书*/
    NSDictionary   *lawLocations; /**< 律师相关地址等*/
    NSString       *realStatus;
    NSString       *realStage;
    NSString       *stopStatus;
    NSString       *stopStage;
    
    BOOL           isPeace;
    BOOL           needToPeace;
    NSMutableArray *peaceArr;
    
    BOOL          isDifferent;
    
    BOOL          isJieChu;
    
    BOOL          isCheXiao;
    
    BOOL          isComplete;
    
    NSInteger     numOfSection;
    
    BOOL          setHI;
    
    __weak IBOutlet NSLayoutConstraint *subBottomLay;
    
    __weak IBOutlet NSLayoutConstraint *btnBottomLay;
    
    NSDictionary *evaluateLawyer;
    
    NSArray      *feeListArr;
    
    UIView       *commentView;
}
- (IBAction)submitAction:(id)sender;
@property (nonatomic,strong)NSArray *professionArr;
@end

@implementation ZXY_AddCaseVC

- (void)viewDidLoad {
    originColor = [UIColor colorWithRed:252.0/255.0 green:107.0/255.0 blue:8.0/255.0 alpha:1];
    freshBtn.layer.cornerRadius = 4;
    cancelBtn.layer.cornerRadius = 4;
    freshBtn.layer.masksToBounds = YES;
    cancelBtn.layer.masksToBounds= YES;
    [super viewDidLoad];
    if(setHI)
    {
        [currentTable setHidden:YES];
    }
    topBar = [self toolBarWithRight:@"完成" andLeft:nil withRightBtnSel:@selector(hideKeyBoard) andLeftBtnSel:nil];
    if(allFileArr == nil)
    {
        allFileArr = [[NSMutableArray alloc] init];
    }
    [self initData];
    if(_status == nil)
    {
        [currentTable setTableFooterView:submitBtn];
        [submitBtn setHidden:NO];
        [self initThisView];
    }

    [self registLawersNoti];
    _currentRole = @"1";
    // Do any additional setup after loading the view.
    [self initNavi];
    
    [self loadCaseTypeData];
    
}

- (void)setLawyerList:(NSArray *)lawList
{
    allLawerArr = [NSMutableArray arrayWithArray:lawList];
    [currentTable reloadData];
}


- (void)startFromCaseID:(NSString *)caseID andStage:(NSString *)stage withStatud:(NSString *)status
{
    _caseID = caseID;
    realStage = [[NSString alloc] initWithString:stage];
    realStatus = [[NSString alloc] initWithString:status];
    _stage  = stage;
    _status = status;
    
    setHI = YES;
    if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"7"]) // 案件调解/撤诉
    {
        isPeace = YES;
    }
    else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"7"]) // 案件调解/撤诉
    {
        isPeace = YES;
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"6"]) // 已结束
    {
        isComplete = YES;
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"8"]) // 已调解或撤诉
    {
        isPeace = YES;
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"9"]) // 解除委托
    {
        isJieChu = YES;
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"10"]) // 提出异议
    {
        isDifferent = YES;
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"11"]) // 已撤销
    {
        isCheXiao = YES;
    }

}

#pragma mark - ==============初始化===================
- (void)startInitDetail
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASEDETAIL_URL];
    NSDictionary *parameter = @{
                                @"id":_caseID
                               };
    [self startLoadDataGETCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(![returnDic.allKeys containsObject:@"data"])
        {
            if([returnDic.allKeys containsObject:@"error"])
            {
                [self showAlertWarnningView:@"提示" andContent:returnDic[@"error"][@"message"]];
            }
            else
            {
                [[UserInfoDetail sharedInstance] userLogOut];
                [self performSelector:@selector(toLoginVC) withObject:nil afterDelay:1];
                
            }
        }
        else
        {
            _currentCaseInfo   = returnDic[@"data"];
            NSNumber *roleNum = _currentCaseInfo[@"role"];
            _currentRole     = roleNum.stringValue;
            if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"0"])
            {
                isFinish = NO;
            }
            else
            {
                isFinish = YES;
            }
            if([_currentCaseInfo objectForKey:@"registerFile"])
            {
                notiBookArr = [_currentCaseInfo objectForKey:@"registerFile"];
            }
            
            if([_currentCaseInfo objectForKey:@"peace"])
            {
                peaceArr = [_currentCaseInfo objectForKey:@"peace"];
            }
            
            if([_currentCaseInfo objectForKey:@"summons"])
            {
                tokenArr = [_currentCaseInfo objectForKey:@"summons"];
            }
            
            if([_currentCaseInfo objectForKey:@"decree"])
            {
                judgeArr = [_currentCaseInfo objectForKey:@"decree"];
            }
            
            if([_currentCaseInfo objectForKey:@"legalCostFile"])
            {
                caseFileArr = [_currentCaseInfo objectForKey:@"legalCostFile"];
            }
            if([_currentCaseInfo.allKeys containsObject:@"postAddress"])
            {
                lawLocations = [_currentCaseInfo objectForKey:@"postAddress"];
                
            }
            
            if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"7"]) // 案件调解/撤诉
            {
                _stage  = _currentCaseInfo[@"stopStage"];
                _status = _currentCaseInfo[@"stopStatus"];
                isPeace = YES;
                peaceArr = _currentCaseInfo[@"peace"];
            }
            else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"7"]) // 案件调解/撤诉
            {
                _stage  = _currentCaseInfo[@"stopStage"];
                _status = _currentCaseInfo[@"stopStatus"];
                isPeace = YES;
                peaceArr = _currentCaseInfo[@"peace"];
            }
            else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"6"]) // 已结束
            {
                if([_currentCaseInfo objectForKey:@"_appraise"])
                {
                    evaluateLawyer = [_currentCaseInfo objectForKey:@"_appraise"];
                }
            }
            else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"8"]) // 已调解或撤诉
            {
                _stage  = _currentCaseInfo[@"stopStage"];
                _status = _currentCaseInfo[@"stopStatus"];
            }
            else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"9"]) // 接触委托
            {
                _stage  = _currentCaseInfo[@"stopStage"];
                _status = _currentCaseInfo[@"stopStatus"];
            }
            else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"10"]) // 提出异议
            {
                _stage  = _currentCaseInfo[@"stopStage"];
                _status = _currentCaseInfo[@"stopStatus"];
            }
            else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"11"]) // 已撤销
            {
                _stage  = _currentCaseInfo[@"stopStage"];
                _status = _currentCaseInfo[@"stopStatus"];
            }
           
            //if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"2"])
            
            if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"2"]) // 签署诉讼&代理文件
            {
                if(isPeace)
                {
                    numOfSection = 0;
                }
            }
            else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"2"]) // 签署诉讼&代理文件
            {
                if([_currentRole isEqualToString:@"1"])
                {
                    numOfSection = 5;
                }
                else
                {
                    numOfSection = 4;
                }
            }
            else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"3"]) // 法院受理
            {
                if([_currentRole isEqualToString:@"1"])
                {
                    numOfSection = 5;
                }
                else
                {
                    numOfSection = 4;
                }

            }
            else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"3"]) // 法院受理
            {
                if([_currentRole isEqualToString:@"1"])
                {
                    numOfSection = 8;
                }
                else
                {
                    numOfSection = 4;
                }
            }
            else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"4"]) // 开庭
            {
                if([_currentRole isEqualToString:@"1"])
                {
                    numOfSection = 8;
                }
                else
                {
                    numOfSection = 4;
                }

            }
            else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"4"]) // 开庭
            {
                if([_currentRole isEqualToString:@"1"])
                {
                    numOfSection = 11;
                }
                else
                {
                    numOfSection = 7;
                }

            }
            else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"5"]) // 判决
            {
                if([_currentRole isEqualToString:@"1"])
                {
                    numOfSection = 11;
                }
                else
                {
                    numOfSection = 7;
                }
            }
            else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"5"]) // 判决
            {
                if([_currentRole isEqualToString:@"1"])
                {
                    numOfSection = 13;
                }
                else
                {
                    numOfSection = 9;
                }
            }
            else if ([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"6"])
            {
                if([_currentRole isEqualToString:@"1"])
                {
                    numOfSection = 13;
                }
                else
                {
                    numOfSection = 9;
                }

            }

            
            if([_currentCaseInfo.allKeys containsObject:@"reply"])
            {
                replyArr = [_currentCaseInfo objectForKey:@"reply"];
            }
            
            if([_currentCaseInfo.allKeys containsObject:@"attorneyFile"])
            {
                attorneyArr = [_currentCaseInfo objectForKey:@"attorneyFile"];
            }
            
            if([_currentCaseInfo.allKeys containsObject:@"complaint"])
            {
                complaint = [_currentCaseInfo objectForKey:@"complaint"];
            }
            
            if([_currentCaseInfo.allKeys containsObject:@"evidenceList"])
            {
                evidenceListArr = [_currentCaseInfo objectForKey:@"evidenceList"];
            }
            NSNumber *costNum  = _currentCaseInfo[@"costs"];
            agencyCost         = costNum.stringValue;
            NSNumber *totalNum = _currentCaseInfo[@"adviceFee"];
            total = totalNum.stringValue;
            NSNumber *disNum   = _currentCaseInfo[@"discount"];
            discounted = disNum.stringValue;
            
            NSNumber *moneyNum = _currentCaseInfo[@"amount"];
            moneyString      = moneyNum.stringValue;
            NSString *typeString = _currentCaseInfo[@"type"];
            currentCase      = _currentCaseInfo[@"options"][@"category"][typeString];
            if(allFileArr == nil)
            {
                allFileArr = [[NSMutableArray alloc] init];
            }
            NSArray *files = _currentCaseInfo[@"files"];
            for(NSDictionary *fileInfo in files)
            {
                NSString *fileName = [fileInfo objectForKey:@"fileName"];
                NSString *fileId   = [fileInfo objectForKey:@"fileId"];
                NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:fileName,@"name",fileId,@"fileId",@"YES",@"isUpload", nil];
                [allFileArr addObject:fileDic];
                
            }
            NSArray *lawyers = _currentCaseInfo[@"intention"];
            if(allLawerArr == nil)
            {
                allLawerArr = [[NSMutableArray alloc] init];
            }
            for(NSString *lawyerInfo in lawyers)
            {
                NSDictionary *userDic = _currentCaseInfo[@"options"][@"user"];
                NSDictionary *currentLawyer = userDic[lawyerInfo];
                [allLawerArr addObject:currentLawyer];
            }
            
            NSDictionary *provinceDic = _currentCaseInfo[@"location"][@"province"];
            NSDictionary *cityDic     = _currentCaseInfo[@"location"][@"city"];
            _provinceEntity           = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:provinceDic[@"id"] andKey:@"cityID"] objectAtIndex:0];
            _cityEntity               = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:cityDic[@"id"] andKey:@"cityID"] objectAtIndex:0];
            if(replyLawyerArr == nil)
            {
                replyLawyerArr = [[NSMutableArray alloc] init];
            }
            if(_currentCaseInfo[@"lawyer"])
            {
                delegateLawID = _currentCaseInfo[@"lawyer"];
            }
            NSDictionary *allReplyDic = [_currentCaseInfo objectForKey:@"intentionReply"];
            for(NSString *currentKey in allReplyDic.allKeys)
            {
                
                NSDictionary *userDic = _currentCaseInfo[@"options"][@"user"];
                NSDictionary *currentLawyer = userDic[currentKey];
                NSString *departString = @"";
                if(currentLawyer[@"extend"][@"lawFirm"])
                {
                    departString = currentLawyer[@"extend"][@"lawFirm"];
                }
                NSDictionary *currentL = [allReplyDic objectForKey:currentKey];
                NSDictionary *tempDic = @{
                                                 @"name":currentLawyer[@"name"],
                                                 @"phone":currentLawyer[@"id"],
                                                 @"_id" :currentLawyer[@"_id"],
                                                 @"fee" :currentL[@"fee"],
                                                 @"mode":currentL[@"mode"],
                                                 @"note":currentL[@"note"],
                                                 @"percent":currentL[@"percent"],
                                                 @"depart" :departString
                                                 };
                if([currentKey isEqualToString:delegateLawID])
                {
                    delegateLawDic = tempDic;
                }
                [replyLawyerArr addObject:tempDic];
            }
            if(lawLocations == nil)
            {
                NSString *lawID = _currentCaseInfo[@"lawyer"];
                if(lawID)
                {
                    NSDictionary  *allL  = _currentCaseInfo[@"options"][@"user"];
                    lawLocations = @{
                                     @"recipient":allL[lawID][@"name"]
                                     };
                }
            }
            feeListArr = _currentCaseInfo[@"_casePay"];
            [self initTitleSegment];
            [self setBtnOfStatus];
            [self initThisView];
            [currentTable reloadData];
            [currentTable setHidden:NO];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[UserInfoDetail sharedInstance] userLogOut];
        [self performSelector:@selector(toLoginVC) withObject:nil afterDelay:1];;
    }];

}

- (void)initTitleSegment
{
    UISegmentedControl *segMent;
    
    //[self setNaviTitleView:segMent];

    if(_status == nil)
    {
        currentPageType = DelegateInfoType;
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        [self setNaviTitle:@"案件委托" withPositon:1 ];
        return;
    }
    if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"1"]) // 双方磋商
    {
        currentPageType = DelegateInfoType;
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        [self setNaviTitle:@"案件委托" withPositon:1 ];
        return;
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"0"]) // 双方磋商
    {
        currentPageType = DelegateInfoType;
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        [self setNaviTitle:@"案件委托" withPositon:1 ];
        return;
    }
    else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"1"]) // 托管代理费
    {
        currentPageType = DelegateInfoType;
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        [self setNaviTitle:@"案件委托" withPositon:1 ];
        return;
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"2"]) // 签署诉讼&代理文件
    {
        if(isPeace)
        {
            currentPageType = DelegateHandleType;
            segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"委托信息",@"代理信息",@"费用托管记录", nil]];
            [segMent setWidth:85 forSegmentAtIndex:2];
            [segMent setWidth:75 forSegmentAtIndex:1];
            [segMent setWidth:75 forSegmentAtIndex:0];
            [segMent setSelectedSegmentIndex:1];

        }
        else
        {
            segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"委托信息",@"费用托管记录", nil]];
            currentPageType = DelegateInfoType;
            [segMent setWidth:90 forSegmentAtIndex:1];
            [segMent setWidth:90 forSegmentAtIndex:0];
            [segMent setSelectedSegmentIndex:0];
        }
    }
    else  // 签署诉讼&代理文件
    {
        segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"委托信息",@"代理信息",@"费用托管记录", nil]];
        [segMent setWidth:85 forSegmentAtIndex:2];
        [segMent setWidth:75 forSegmentAtIndex:1];
        [segMent setWidth:75 forSegmentAtIndex:0];
        [segMent setSelectedSegmentIndex:1];
        currentPageType = DelegateHandleType;
    }
    //segMent.frame = CGRectMake(20, 0, 270, 30);
    UIColor *naviColor = NAVIBARCOLOR;
    [segMent setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:naviColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [segMent setTintColor:[UIColor whiteColor]];
    [segMent addTarget:self action:@selector(chooseTabPageType:) forControlEvents:UIControlEventValueChanged];
    [self setNaviTitleView:segMent];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setBtnOfStatus
{
    if(isComplete || isJieChu || isDifferent || isCheXiao)
    {
    }
    else
    {
        if(_status == nil)
        {
            [currentTable setTableFooterView:submitBtn];
            [submitBtn setHidden:NO];
            [delegateView setHidden:YES];
        }
        if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"1"]) // 双方磋商
        {
            [submitBtn setHidden:YES];
            [delegateView setHidden:NO];
            [currentTable setTableFooterView:delegateView];
            [freshBtn setTitle:@"确定委托" forState:UIControlStateNormal];
            
        }
        else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"0"]) // 双方磋商
        {
            [submitBtn setHidden:YES];
            [delegateView setHidden:NO];
            [currentTable setTableFooterView:delegateView];
            
        }
        
        else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"1"]) // 托管代理费
        {
            [submitBtn setHidden:YES];
            [delegateView setHidden:NO];
            [freshBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"撤销委托" forState:UIControlStateNormal];
            [currentTable setTableFooterView:delegateView];
            
        }
        else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"2"]) // 签署诉讼&代理文件
        {
            if(isPeace)
            {
                [currentTable setTableFooterView:submitBtn];
                [submitBtn setHidden:NO];
                [delegateView setHidden:YES];
                [submitBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            }
        }
        else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"2"]) // 签署诉讼&代理文件
        {
            [submitBtn setHidden:YES];
            [delegateView setHidden:NO];
            [freshBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"提出异议" forState:UIControlStateNormal];
            [currentTable setTableFooterView:delegateView];
            
        }
        else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"3"]) // 法院受理
        {
            if(isPeace)
            {
                [currentTable setTableFooterView:submitBtn];
                [submitBtn setHidden:NO];
                [delegateView setHidden:YES];
                [submitBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            }
        }
        else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"3"]) // 法院受理
        {
            [submitBtn setHidden:YES];
            [delegateView setHidden:NO];
            [freshBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"提出异议" forState:UIControlStateNormal];
            [currentTable setTableFooterView:delegateView];
        }
        else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"4"]) // 开庭
        {
            if(isPeace)
            {
                [currentTable setTableFooterView:submitBtn];
                [submitBtn setHidden:NO];
                [delegateView setHidden:YES];
                [submitBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            }
        }
        else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"4"]) // 开庭
        {
            [submitBtn setHidden:YES];
            [delegateView setHidden:NO];
            [freshBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"提出异议" forState:UIControlStateNormal];
            [currentTable setTableFooterView:delegateView];
        }
        else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"5"]) // 判决
        {
            if(isPeace)
            {
                [currentTable setTableFooterView:submitBtn];
                [submitBtn setHidden:NO];
                [delegateView setHidden:YES];
                [submitBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            }
        }
        else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"5"]) // 判决
        {
            [submitBtn setHidden:YES];
            [delegateView setHidden:NO];
            [freshBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            [cancelBtn setTitle:@"提出异议" forState:UIControlStateNormal];
            [currentTable setTableFooterView:delegateView];
        }
        else if([_currentCaseInfo[@"status"] isEqualToString:@"0"]&&[_currentCaseInfo[@"stage"] isEqualToString:@"7"]) // 案件调解/撤诉
        {
            [currentTable setTableFooterView:submitBtn];
            [submitBtn setHidden:NO];
            [submitBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
            [delegateView setHidden:YES];
        }
        
        else if([_currentCaseInfo[@"status"] isEqualToString:@"0"]&&[_currentCaseInfo[@"stage"] isEqualToString:@"7"])
        {
//            if(isPeace)
//            {
//                [currentTable setTableFooterView:submitBtn];
//                [submitBtn setHidden:NO];
//                [delegateView setHidden:YES];
//                [submitBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
//            }
        }
        
    }

}

- (void)chooseTabPageType:(id)sender
{
    UISegmentedControl *segNow = (UISegmentedControl *)sender;
    if(segNow.selectedSegmentIndex == 0)
    {
        currentPageType = DelegateInfoType;
        if([_stage isEqualToString:@"0"]&&[_status isEqualToString:@"0"])
        {
        
        }
        else if ([_stage isEqualToString:@"1"]&&[_status isEqualToString:@"0"])
        {
        
        }
        else if ([_stage isEqualToString:@"1"]&&[_status isEqualToString:@"1"])
        {
        
        }
        else if (_status == nil)
        {
        
        }
        else
        {
            [currentTable setTableFooterView:nil];
        }
    }
    else if (segNow.selectedSegmentIndex == 1)
    {
        if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"2"])
        {
            currentPageType = DelegatePayHistory;
            if([_stage isEqualToString:@"0"]&&[_status isEqualToString:@"0"])
            {
                
            }
            else if ([_stage isEqualToString:@"1"]&&[_status isEqualToString:@"0"])
            {
                
            }
            else if ([_stage isEqualToString:@"1"]&&[_status isEqualToString:@"1"])
            {
                
            }
            else if (_status == nil)
            {
                
            }
            else
            {
                [currentTable setTableFooterView:nil];
            }

        }
        else
        {
            currentPageType = DelegateHandleType;
            [self setBtnOfStatus];
        }
    }
    else
    {
        currentPageType = DelegatePayHistory;
        if([_stage isEqualToString:@"0"]&&[_status isEqualToString:@"0"])
        {
            
        }
        else if ([_stage isEqualToString:@"1"]&&[_status isEqualToString:@"0"])
        {
            
        }
        else if ([_stage isEqualToString:@"1"]&&[_status isEqualToString:@"1"])
        {
            
        }
        else if (_status == nil)
        {
            
        }
        else
        {
            [currentTable setTableFooterView:nil];
        }

    }
    [currentTable reloadData];
}

- (void)initThisView
{
    UIView *titleViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, currentTable.frame.size.width, 140)];
    ZXY_LawCircleView *lawcir = [[ZXY_LawCircleView alloc] initWithPositionY:10];
    UIColor *selectColor      = NAVIBARCOLOR;
    UIImageView *backImage    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, titleViewHeader.frame.size.width, 20)];
    backImage.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:195.0/255.0 blue:142.0/255.0 alpha:1];
    UILabel *firstLbl         = [[UILabel alloc] initWithFrame:CGRectMake(8, 60, titleViewHeader.frame.size.width, 20)];
    //[firstLbl setBackgroundColor:[UIColor colorWithRed:29.0/255.0 green:195.0/255.0 blue:142.0/255.0 alpha:1]];
    [firstLbl setTextColor:[UIColor whiteColor]];
    [firstLbl setFont:[UIFont systemFontOfSize:14]];
    UILabel *secondLbl        = [[UILabel alloc] initWithFrame:CGRectMake(8, 80, titleViewHeader.frame.size.width, 20)];
    [secondLbl setNumberOfLines:1];
    [secondLbl setFont:[UIFont systemFontOfSize:14]];
    [secondLbl setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *thirdLbl        = [[UILabel alloc] initWithFrame:CGRectMake(8, 100, titleViewHeader.frame.size.width, 20)];
    [thirdLbl setNumberOfLines:1];
    [thirdLbl setFont:[UIFont systemFontOfSize:14]];
    [thirdLbl setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *fourLbl        = [[UILabel alloc] initWithFrame:CGRectMake(8, 120, titleViewHeader.frame.size.width, 20)];
    [fourLbl setNumberOfLines:1];
    [fourLbl setFont:[UIFont systemFontOfSize:14]];
    [fourLbl setTextAlignment:NSTextAlignmentLeft];

    if(_status == nil)
    {
        [submitBtn setHidden:NO];
        [delegateView setHidden:YES];
        [lawcir setNumOfCircle:3];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"提交",@"磋商",@"代理", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:0];
        titleViewHeader.frame = CGRectMake(0, 0, currentTable.frame.size.width, 55);
        
    }
    if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"1"]) // 双方磋商
    {
        [submitBtn setHidden:YES];
        [delegateView setHidden:NO];
        [freshBtn setTitle:@"确定委托" forState:UIControlStateNormal];
        [lawcir setNumOfCircle:3];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"提交",@"磋商",@"代理", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:1];
        
        
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"0"]) // 双方磋商
    {
        [submitBtn setHidden:YES];
        [delegateView setHidden:NO];
        [lawcir setNumOfCircle:3];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"提交",@"磋商",@"代理", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:1];
        
        
    }
    
    else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"1"]) // 托管代理费
    {
        [submitBtn setHidden:YES];
        [delegateView setHidden:NO];
        [freshBtn setTitle:@"去付款" forState:UIControlStateNormal];
        [cancelBtn setTitle:@"撤销委托" forState:UIControlStateNormal];
        [lawcir setNumOfCircle:3];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"提交",@"磋商",@"代理", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:2];
        
       
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"2"]) // 签署诉讼&代理文件
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:0];
        
    }
    else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"2"]) // 签署诉讼&代理文件
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:0];
        
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"3"]) // 法院受理
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:1];
    }
    else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"3"]) // 法院受理
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:1];
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"4"]) // 开庭
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:2];
    }
    else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"4"]) // 开庭
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:2];
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"5"]) // 判决
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:3];
    }
    else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"5"]) // 判决
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:3];
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"7"]) // 案件调解/撤诉
    {
        
    }
    else if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"7"]) // 案件调解/撤诉
    {
            }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"6"]) // 已结束
    {
        [lawcir setNumOfCircle:5];
        [lawcir setCircleInfo:[NSArray arrayWithObjects:@"文件",@"受理",@"开庭",@"判决",@"评价", nil]];
        [lawcir setSelectBackColor:selectColor];
        [lawcir setSelectIndex:4];
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"8"]) // 已调解或撤诉
    {
        
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"9"]) // 接触委托
    {
       
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"10"]) // 提出异议
    {
        
    }
    else if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"11"]) // 已撤销
    {
        
        //titleViewHeader.frame = CGRectMake(0, 0, currentTable.frame.size.width, 60);
    }
    
    //实例化label
    if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"1"]) // 双方磋商
    {
       
        firstLbl.text = @"请选择律师后确定委托关系。";
        secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"0"]) // 双方磋商
    {
        
        firstLbl.text = @" 请耐心等待意向律师的回复。";
        secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        
    }
    
    else if([realStatus isEqualToString:@"1"]&&[realStage isEqualToString:@"1"]) // 托管代理费
    {
        
        firstLbl.text = @" 您的案件托管代理费未完成支付。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
        
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"2"]) // 签署诉讼&代理文件
    {
       
        firstLbl.text = @"请耐心等待律师上传诉讼/代理文件。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"1"]&&[realStage isEqualToString:@"2"]) // 签署诉讼&代理文件
    {
       
        firstLbl.text = @"律师已上传诉讼/代理文件，请确认。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"3"]) // 法院受理
    {
        firstLbl.text = @"请耐心等待律师上传法院受理文件。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"1"]&&[realStage isEqualToString:@"3"]) // 法院受理
    {
        firstLbl.text = @"律师已上传法院受理文件，请确认。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"4"]) // 开庭
    {
        firstLbl.text = @"请耐心等待律师更新开庭信息。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"1"]&&[realStage isEqualToString:@"4"]) // 开庭
    {
        firstLbl.text = @"律师已上传开庭信息，请确认。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"5"]) // 判决
    {
        firstLbl.text = @"请耐心等待律师上传判决书/裁决书。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"1"]&&[realStage isEqualToString:@"5"]) // 判决
    {
        firstLbl.text = @"律师已上传判决书/裁决书，请确认。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"7"]) // 案件调解/撤诉
    {
        firstLbl.text = @"律师已上传法院调解书/撤诉裁定，请确认。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
             secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
    }
    else if([realStatus isEqualToString:@"1"]&&[realStage isEqualToString:@"7"]) // 案件调解/撤诉
    {
        firstLbl.text = @"律师已上传法院调解书/撤诉裁定，请确认。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
        
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"6"]) // 已结束
    {
        firstLbl.text = @"案件受理流程已结束。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
        
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"8"]) // 已调解或撤诉
    {
        firstLbl.text = @"案件已经调解或撤诉。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
        
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"9"]) // 接触委托
    {
        firstLbl.text = @"已经解除委托关系。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
        
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"10"]) // 提出异议
    {
        firstLbl.text = @"该案件您已提出异议，请等待法率网处理。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@ ",_currentCaseInfo[@"num"]];
            thirdLbl.text =  [NSString stringWithFormat:@"受理律师:%@",lawLocations[@"recipient"]];
            fourLbl.text  =  [NSString stringWithFormat:@"律师代理费:%@  托管费余额:%@",_currentCaseInfo[@"fee"],[feeListArr lastObject][@"left"]];
        }
        @catch (NSException *exception) {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
        
    }
    else if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"11"]) // 已撤销
    {
        firstLbl.text = @"该委托已经撤销。";
        @try {
            secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @catch (NSException *exception) {
           secondLbl.text = [NSString stringWithFormat:@"案件编号:%@",_currentCaseInfo[@"num"]];
        }
        @finally {
            
        }
        
    }

    [titleViewHeader addSubview:backImage];
    [titleViewHeader addSubview:firstLbl];
    [titleViewHeader addSubview:secondLbl];
    [titleViewHeader addSubview:thirdLbl];
    [titleViewHeader addSubview:fourLbl];
    [titleViewHeader addSubview:lawcir];
    titleViewHeader.clipsToBounds = YES;
    [currentTable setTableHeaderView:titleViewHeader];

}

- (void)toLoginVC
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self performSegueWithIdentifier:@"toLoginVC" sender:self];
}


- (void)initData
{
    if(agencyCost == nil)
    {
        agencyCost = @"";
    }
    if(total == nil)
    {
        total      = @"";
    }
    if(discounted == nil)
    {
        discounted = @"";
    }
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setRightNaviItem:@"home_phone"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadCaseTypeData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CATEGORY_URL];
    NSDictionary *parameter = @{
                                @"type":@"CaseType"
                                };
    [self startLoadDataGETCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *jsonDatas = [jsonDic objectForKey:@"data"];
        NSArray      *items     = [jsonDatas objectForKey:@"items"];
        [self initData:items];
        
        if(_caseID)
        {
            [self startInitDetail];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWarnningView:@"提示" andContent:@"网络连接超时"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)initData:(NSArray *)currentProfess
{
    self.professionArr   = [[NSArray alloc] initWithArray:currentProfess];
    if(currentCase == nil)
    {
        currentCase = [self.professionArr objectAtIndex:0];
    }
    if(_caseID== nil)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [currentTable reloadData];
    }

    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(currentPageType == DelegateInfoType)
    {
        

        if(isFinish)
        {
//            if([realStatus isEqualToString:@"0"]&&[realStage isEqualToString:@"11"])
//            {
//                if(replyLawyerArr.count == 0)
//                {
//                    return 3;
//                }
//                
//            }

            if(replyLawyerArr.count == 0)
            {
                return 4;
            }
                        return 5;
            
        }
        return 4;
    }
    else if(currentPageType == DelegateHandleType)
    {
        if(isPeace)
        {
            if(evaluateLawyer)
            {
                return numOfSection+4;
            }
            return numOfSection+2;
        }
        else
        {
            if(evaluateLawyer)
            {
                return numOfSection+2;
            }
            return numOfSection;
        }
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // !!!:Tab One
    if(currentPageType == DelegateInfoType)
    {
        if(section == 0)
        {
            return 4;
        }
        else if (section == 1)
        {
            if(isFinish)
            {
                return allFileArr.count;
            }
            return allFileArr.count +1;
        }
        else if (section == 2)
        {
            if(isFinish)
            {
                return allLawerArr.count;
            }
            if(_caseID)
            {
                return allLawerArr.count;
            }
            return allLawerArr.count +1;
        }
        else if(section == 3)
        {
            return 1;
        }
        else
        {
            return replyLawyerArr.count;
        }
    }
    // !!!:TAB Two
    else if(currentPageType == DelegateHandleType)
    {
        if(numOfSection>section)
        {
            if([_currentRole isEqualToString:@"1"])
            {
                if(section == 0)
                {
                    return 1;
                }
                else if(section == 1)
                {
                    return complaint.count;
                }
                else if(section == 2)
                {
                    return evidenceListArr.count;
                }
                else if(section == 3)
                {
                    return attorneyArr.count;
                }
                else if (section == 4)
                {
                    return 5;
                }
                else if (section == 5)
                {
                    return 1;
                }
                else if (section == 6)
                {
                    return notiBookArr.count;
                }
                else if (section == 7)
                {
                    return caseFileArr.count;
                }
                else if (section == 8)
                {
                    return 1;
                }
                else if (section == 9)
                {
                    return tokenArr.count;
                }
                else if (section == 10)
                {
                    return 4;
                }
                else if (section == 11)
                {
                    return 1;
                }
                else
                {
                    return judgeArr.count;
                }
            }
            else
            {
                if(section == 0)
                {
                    return 1;
                }
                else if(section == 1)
                {
                    return replyArr.count;
                }
                else if(section==2)
                {
                    return  attorneyArr.count;
                }
                else if (section == 3)
                {
                    return 5;
                }
                else if (section == 4)
                {
                    return 1;
                }
                else if (section == 5)
                {
                    return tokenArr.count;
                }
                else if (section == 6)
                {
                    return 4;
                }
                else if (section == 7)
                {
                    return 1;
                }
                else
                {
                    return judgeArr.count;
                }
            }
        }
        else
        {
            if(isPeace)
            {
                if(section == numOfSection)
                {
                    return 1;
                }
                else if(section == numOfSection+1)
                {
                    return peaceArr.count;
                }
                else if (section == numOfSection +2)
                {
                    return 1;
                }
                else
                {
                    return 2;
                }
            }
            else
            {
                if(section == numOfSection)
                {
                    return 1;
                }
                else
                {
                    return 2;
                }

            }
        }
    }
    else
    {
        return feeListArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow     = indexPath.row;
    NSInteger currentSection = indexPath.section;

    if(currentPageType == DelegateInfoType)
    {
        if(currentSection == 0)
        {
            return 52;
        }
        else if (currentSection == 1)
        {
            if(currentRow == allFileArr.count )
            {
                return 50;
            }
            else
            {
                return 38;
            }
        }
        else if(currentSection == 2)
        {
            if(currentRow == allLawerArr.count )
            {
                return 50;
            }
            else
            {
                return 38;
            }

        }
        else if(currentSection == 3)
        {
            return 118;
        }
        else
        {
            return 212;
        }
    }
    else if(currentPageType == DelegateHandleType)
    {
        if(numOfSection>currentSection)
        {
            if([_currentRole isEqualToString:@"1"])
            {
                if(currentSection == 2||currentSection == 1||currentSection == 3||currentSection == 6||currentSection == 7||currentSection == 9||currentSection == 12||currentSection == 4)
                {
                    return 38;
                }
                else if (currentSection == 0||currentSection==5||currentSection==8||currentSection==11)
                {
                    return 52;
                }
                else
                {
                     if(currentRow == 0||currentRow == 1)
                     {
                         return 46;
                     }
                    else
                    {
                        return 130;
                    }
                }
                
            }
            else
            {
                if(currentSection==8||currentSection == 1||currentSection == 2||currentSection == 3||currentSection == 5)
                {
                    return 38;
                }
                else if(currentSection == 0||currentSection==4||currentSection==7)
                {
                    return 52;
                }
                else
                {
                    if(currentRow == 0||currentRow == 1)
                    {
                        return 46;
                    }
                    else
                    {
                        return 130;
                    }
                }
            }
        }
        else
        {
            if(isPeace)
            {
                if(currentSection == numOfSection)
                {
                    return 52;
                }
                else if(currentSection == numOfSection+1){
                    return 38;
                }
                else if (currentSection == numOfSection +2)
                {
                    return 52;
                }
                else
                {
                     if(currentRow == 1)
                     {
                         return 130;
                     }
                    return 46;
                }
            }
            else if (evaluateLawyer)
            {
                if (currentSection == numOfSection)
                {
                    return 52;
                }
                else
                {
                    if(currentRow == 1)
                    {
                        return 130;
                    }
                    return 46;
                }

            }
        }
    }
    else
    {
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow = indexPath.row;
    NSInteger currentSection = indexPath.section;
    // !!!:TabOne
    if(currentPageType == DelegateInfoType)
    {
        if(currentSection == 0)
        {
            if(currentRow == 0)
            {
                ZXY_MyCaseChooseCell *chooseCell = [tableView dequeueReusableCellWithIdentifier:MyCaseChooseCellID];
                if(currentCase)
                {
                    chooseCell.valueLbl.text = [currentCase objectForKey:@"name"];
                }
                return chooseCell;
            }
            else if (currentRow == 1)
            {
                ZXY_MyCaseChooseRoleCell *roleCell = [tableView dequeueReusableCellWithIdentifier:MyCaseChooseRoleCellID];
                if([_currentRole isEqualToString:@"1"])
                {
                    [roleCell.roleSeg setSelectedSegmentIndex:0];
                }
                else
                {
                    [roleCell.roleSeg setSelectedSegmentIndex:1];
                }
                if(isFinish)
                {
                    roleCell.userInteractionEnabled = NO;
                }
                roleCell.currentRole = ^(NSString *roleID)
                {
                    _currentRole = roleID;
                };
                return roleCell;
            }
            else if (currentRow == 2)
            {
                ZXY_MyCaseMoneyCell *moneyCell = [tableView dequeueReusableCellWithIdentifier:MyCaseMoneyCellID];
                moneyText = moneyCell.valueLbl;
                if(moneyString)
                {
                    moneyText.text = moneyString;
                }
                moneyText.delegate = self;
                moneyText.returnKeyType = UIReturnKeyDone;
                [moneyText addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];
                [moneyText setInputAccessoryView:topBar];
                return moneyCell;
            }
            else
            {
                ZXY_MyCaseChooseCityCell *cityCell = [tableView dequeueReusableCellWithIdentifier:MyCaseChooseCityCellID];
                if(_provinceEntity)
                {
                    NSString *locationString = [NSString stringWithFormat:@"%@ %@",_provinceEntity.name,_cityEntity.name];
                    cityCell.valueLbl.text = locationString;
                }
                return cityCell;
            }
        }
        else if (currentSection == 1)
        {
            if(currentRow == allFileArr.count)
            {
                ZXY_MyCaseBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCaseBtnCellID];
                cell.titleLbl.text = @"上传文件";
                return cell;
            }
            else
            {
                ZXY_MyCaseFileAttrCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCaseFileAttrCellID];
                //return fileCell;
                NSDictionary *imageInfo = [allFileArr objectAtIndex:currentRow];
                //cell.indexLbl.text         = [NSString stringWithFormat:@"%d",indexPath.row+1];
                cell.titleLbl.text          = [imageInfo objectForKey:@"name"];
                if([imageInfo[@"isUpload"] isEqualToString:@"NO"])
                {
                    cell.stateLbl.text = @"等待";
                }
                else if ([imageInfo[@"isUpload"] isEqualToString:@"YES"])
                {
                    cell.stateLbl.text = @"操作";
                }
                else
                {
                    cell.stateLbl.text = @"上传中";
                }
                return cell;
            }
        }
        else if(currentSection == 2)
        {
            if(currentRow == allLawerArr.count)
            {
                ZXY_MyCaseBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCaseBtnCellID];
                cell.titleLbl.text = @"选择律师";
                return cell;
            }
            else
            {
                ZXY_MyCaseFileAttrCell *fileCell = [tableView dequeueReusableCellWithIdentifier:MyCaseFileAttrCellID];
                NSDictionary *currentDic = [allLawerArr objectAtIndex:indexPath.row];
                fileCell.titleLbl.text      = [currentDic objectForKey:@"name"];
                fileCell.stateLbl.text      = @"";
                return fileCell;
            }

        }
        else if(currentSection == 3)
        {
            ZXY_MyCaseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCaseFeeCellID];
            cell.agencyCostLbl.text = agencyCost;
            cell.totalLbl.text      = total;
            cell.discountedLbl.text = discounted;
            if(agencyCost.length>0)
            {
                [cell.tipsLbl setHidden:NO];
            }
            else
            {
                [cell.tipsLbl setHidden:YES];
            }
            if(!([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"1"])&&!([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"0"])&&!(_status == nil))
            {
                [cell.tipsLbl setHidden:YES];
                [cell.finalLbl setHidden:NO];
                [cell.finalYuan setHidden:NO];
                [cell.finalValueLbl setHidden:NO];
                cell.finalValueLbl.text = delegateLawDic[@"fee"];
            }
            if(allLawerArr.count == 0)
            {
                if(_status!=nil)
                {
                    [cell.tipsLbl setHidden:YES];
                    [cell.finalLbl setHidden:YES];
                    [cell.finalYuan setHidden:YES];
                    [cell.finalValueLbl setHidden:YES];
                }
            }
            return cell;
        }
        else
        {
            ZXY_LawReplyCell *replyCell = [tableView dequeueReusableCellWithIdentifier:LawReplyCellID];
            replyCell.delegate = self;
            NSDictionary *replyLawer = [replyLawyerArr objectAtIndex:currentRow];
            replyCell.lawyerNameLbl.text  = replyLawer[@"name"];
            replyCell.lawyerPhoneLbl.text = replyLawer[@"phone"];
            NSString *noteString = [replyLawer objectForKey:@"note"];
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:noteString];
            NSRange contentRange = {0,[content length]};
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
            [replyCell.cummentBtn.titleLabel setAttributedText:content];
            [replyCell.cummentBtn setTitle:replyLawer[@"note"] forState:UIControlStateNormal];
            [replyCell.cummentBtn addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
            NSString *lawID               = replyLawer[@"_id"];
            replyCell.lawyerID = lawID;
            if(![_status isEqualToString:@"0"]&&[_stage isEqualToString:@"1"])
            {
                [replyCell.selectBtn setUserInteractionEnabled:NO];
            }
            
            if([lawID isEqualToString:delegateLawID])
            {
                [replyCell.selectBtn setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
            }
            else
            {
                [replyCell.selectBtn setImage:[UIImage imageNamed:@"blueReg"] forState:UIControlStateNormal];
            }
            NSString *mode = replyLawer[@"mode"];
            if([mode isEqualToString:@"1"])
            {
                replyCell.modeLbl.text = @"一般代理";
                
            }
            else
            {
                replyCell.modeLbl.text = @"风险代理";
                replyCell.ratioLbl.text = [NSString stringWithFormat:@"%@%%",replyLawer[@"percent"]];
            }
            replyCell.feeLbl.text = replyLawer[@"fee"];
            
            return replyCell;
        }
    }
    // !!!:TabTwo
    else if(currentPageType == DelegateHandleType)
    {
        ZXY_MyCaseTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:MyCaseTitleCellID];
        if(numOfSection>currentSection)
        {
            ZXY_MyCaseFileAttrCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCaseFileAttrCellID];
            ZXY_MyCaseTextCell     *textCell = [tableView dequeueReusableCellWithIdentifier:MyCaseTextCellID];
            ZXY_MyCaseBaseCell     *baseCell  =[tableView dequeueReusableCellWithIdentifier:MyCaseBaseCellID];
            if([_currentRole isEqualToString:@"1"])
            {
                if(currentSection == 1)
                {
                    NSDictionary *fileRow = [complaint objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if (currentSection == 2)
                {
                    NSDictionary *fileRow = [evidenceListArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if(currentSection == 3)
                {
                    NSDictionary *fileRow = [attorneyArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if (currentSection == 6)
                {
                    NSDictionary *fileRow = [notiBookArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if (currentSection == 7)
                {
                    NSDictionary *fileRow = [caseFileArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if (currentSection == 9)
                {
                    NSDictionary *fileRow = [tokenArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if (currentSection == 12)
                {
                    NSDictionary *fileRow = [judgeArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if (currentSection == 4)
                {
                    if(currentRow == 0)
                    {
                        ZXY_MyCaseDownFileCell *downCell = [tableView dequeueReusableCellWithIdentifier:MyCaseDownFileCellID];
                        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:downCell.titleLbl.text];
                        NSRange ranges = {0,downCell.titleLbl.text.length};
                        [attribute addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:ranges];
                        [downCell.titleLbl setAttributedText:attribute];
                        return downCell;
                    }
                    else if(currentRow == 1)
                    {
                        baseCell.titleLbl.text = @"回寄地址";
                        baseCell.valueLbl.text = [NSString stringWithFormat:@"%@ %@ %@",lawLocations[@"province"][@"name"],lawLocations[@"city"][@"name"],lawLocations[@"town"][@"name"]];
                        return baseCell;
                    }
                    else if (currentRow == 2)
                    {
                        baseCell.titleLbl.text = @"回寄详细地址";
                        baseCell.valueLbl.text = lawLocations[@"streets"];
                        return baseCell;
                    }
                    else if (currentRow == 3)
                    {
                        baseCell.titleLbl.text = @"邮政编码";
                        baseCell.valueLbl.text = lawLocations[@"postcode"];
                        return baseCell;
                    }
                    else
                    {
                        baseCell.titleLbl.text = @"收件人";
                        baseCell.valueLbl.text = lawLocations[@"recipient"];
                        return baseCell;
                    }
                }
                else if (currentSection == 10)
                {
                    if(currentRow == 0)
                    {
                        baseCell.titleLbl.text = @"庭审时间";
                        baseCell.valueLbl.text = [self dateFromISODateString:[_currentCaseInfo objectForKey:@"trialDate"] ];
                        return baseCell;
                    }
                    else if (currentRow == 1)
                    {
                        baseCell.titleLbl.text = @"庭审地点";
                        baseCell.valueLbl.text = [_currentCaseInfo objectForKey:@"trialPlace"];
                        return baseCell;
                    }
                    else if (currentRow == 2)
                    {
                        textCell.titleLbl.text = @"争议焦点";
                        textCell.valueLbl.text = [_currentCaseInfo objectForKey:@"trialFocus"];
                        return textCell;
                    }
                    else
                    {
                        textCell.titleLbl.text = @"各方意见";
                        textCell.valueLbl.text = [_currentCaseInfo objectForKey:@"trialComment"];
                        return textCell;
                    }
                }
                else
                {
                    if(currentSection == 0)
                    {
                        titleCell.titleLbl.text = @"【诉讼&代理文件】";
                    }
                    else if (currentSection == 5)
                    {
                        titleCell.titleLbl.text = @"【法院受理】";
                    }
                    else if (currentSection == 8)
                    {
                        titleCell.titleLbl.text = @"【开庭】";
                    }
                    else
                    {
                        titleCell.titleLbl.text = @"【判决】";
                    }
                    return titleCell;
                }
            }
            else
            {
                if(currentSection == 1)
                {
                    NSDictionary *fileRow = [replyArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if(currentSection == 2)
                {
                    NSDictionary *fileRow = [attorneyArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if (currentSection == 3)
                {
                    if(currentRow == 0)
                    {
                        ZXY_MyCaseDownFileCell *downCell = [tableView dequeueReusableCellWithIdentifier:MyCaseDownFileCellID];
                        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:downCell.titleLbl.text];
                        NSRange ranges = {0,downCell.titleLbl.text.length};
                        [attribute addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:ranges];
                        [downCell.titleLbl setAttributedText:attribute];
                        return downCell;

                    }

                    else if(currentRow == 1)
                    {
                        baseCell.titleLbl.text = @"回寄地址";
                        baseCell.valueLbl.text = [NSString stringWithFormat:@"%@ %@ %@",lawLocations[@"province"][@"name"],lawLocations[@"city"][@"name"],lawLocations[@"town"][@"name"]];
                        return baseCell;
                    }
                    else if (currentRow == 2)
                    {
                        baseCell.titleLbl.text = @"回寄详细地址";
                        baseCell.valueLbl.text = lawLocations[@"streets"];
                        return baseCell;
                    }
                    else if (currentRow == 3)
                    {
                        baseCell.titleLbl.text = @"邮政编码";
                        baseCell.valueLbl.text = lawLocations[@"postcode"];
                        return baseCell;
                    }
                    else
                    {
                        baseCell.titleLbl.text = @"收件人";
                        baseCell.valueLbl.text = lawLocations[@"recipient"];
                        return baseCell;
                    }
                }
                else if (currentSection == 5)
                {
                    NSDictionary *fileRow = [tokenArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                
                else if (currentSection == 6)
                {
                    if(currentRow == 0)
                    {
                        baseCell.titleLbl.text = @"庭审时间";
                        baseCell.valueLbl.text = [self dateFromISODateString:[_currentCaseInfo objectForKey:@"trialDate"] ];
                        return baseCell;
                    }
                    else if (currentRow == 1)
                    {
                        baseCell.titleLbl.text = @"庭审地点";
                        baseCell.valueLbl.text = [_currentCaseInfo objectForKey:@"trialPlace"];
                        return baseCell;
                    }
                    else if (currentRow == 2)
                    {
                        textCell.titleLbl.text = @"争议焦点";
                        textCell.valueLbl.text = [_currentCaseInfo objectForKey:@"trialFocus"];
                        return textCell;
                    }
                    else
                    {
                        textCell.titleLbl.text = @"各方意见";
                        textCell.valueLbl.text = [_currentCaseInfo objectForKey:@"trialComment"];
                        return textCell;
                    }
                }

                else if (currentSection == 8)
                {
                    NSDictionary *fileRow = [judgeArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else
                {
                    if(currentSection == 0)
                    {
                        titleCell.titleLbl.text = @"【诉讼&代理文件】";
                    }
                    else if (currentSection == 4)
                    {
                        titleCell.titleLbl.text = @"【开庭】";
                    }
                    else
                    {
                        titleCell.titleLbl.text = @"【判决】";
                    }
                    return titleCell;
                }

            }
        }
        else
        {
            if(isPeace)
            {
                if(currentSection == numOfSection)
                {
                    ZXY_MyCaseTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:MyCaseTitleCellID];
                    titleCell.titleLbl.text = @"【调解/撤诉】";
                    return titleCell;
                }
                else if (currentSection == numOfSection+1)
                {
                    ZXY_MyCaseFileAttrCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCaseFileAttrCellID];
                    NSDictionary *fileRow = [peaceArr objectAtIndex:currentRow];
                    cell.titleLbl.text    = [fileRow objectForKey:@"fileName"];
                    cell.stateLbl.text    = @"";
                    return cell;
                }
                else if (currentSection == numOfSection +2)
                {
                    ZXY_MyCaseTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:MyCaseTitleCellID];
                    titleCell.titleLbl.text = @"【对律师评价】";
                    return titleCell;
                }
                else
                {
                    if(currentRow == 0)
                    {
                        ZXY_MyCaseBaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:MyCaseBaseCellID];
                        baseCell.titleLbl.text = @"对律师评分";
                        baseCell.valueLbl.text = [NSString stringWithFormat:@"服务态度:%@ 专业性:%@ 责任心:%@",evaluateLawyer[@"attitude"],evaluateLawyer[@"professional"],evaluateLawyer[@"responsibility"]];
                        return baseCell;
                    }
                    else
                    {
                        ZXY_MyCaseTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:MyCaseTextCellID];
                        textCell.titleLbl.text       = @"对律师评价";
                        textCell.valueLbl.text       = evaluateLawyer[@"comment"];
                        return textCell;
                    }
                }
            }
            else
            {
                if (currentSection == numOfSection)
                {
                    ZXY_MyCaseTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:MyCaseTitleCellID];
                    titleCell.titleLbl.text = @"【对律师评价】";
                    return titleCell;
                }
                else
                {
                    if(currentRow == 0)
                    {
                        ZXY_MyCaseBaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:MyCaseBaseCellID];
                        baseCell.titleLbl.text = @"对律师评分";
                        baseCell.valueLbl.text = [NSString stringWithFormat:@"服务态度:%@ 专业性:%@ 责任心:%@",evaluateLawyer[@"attitude"],evaluateLawyer[@"professional"],evaluateLawyer[@"responsibility"]];
                        return baseCell;
                    }
                    else
                    {
                        ZXY_MyCaseTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:MyCaseTextCellID];
                        textCell.titleLbl.text       = @"对律师评价";
                        textCell.valueLbl.text       = evaluateLawyer[@"comment"];
                        return textCell;
                    }
                }
            }

        }
    }
    else
    {
        NSDictionary *currentFee = [feeListArr objectAtIndex:currentRow];
        ZXY_MyCaseFeeForListCell *feeCell = [tableView dequeueReusableCellWithIdentifier:MyCaseFeeForListCellID];
        feeCell.feeIndex.text  = [NSString stringWithFormat:@"%d",currentRow+1];
        
        NSString *dates = [currentFee objectForKey:@"createAt"];
        NSString *countNum = [currentFee objectForKey:@"amount"];
        NSString *commissionNum = [currentFee objectForKey:@"commission"];
        NSString *allNum        = [NSString stringWithFormat:@"%d",countNum.integerValue+commissionNum.integerValue];
        feeCell.feeTime.text = [NSString stringWithFormat:@"时间 ：%@",[self dateFromISODateString:dates]];
        feeCell.feeCost.text = [NSString stringWithFormat:@"金额 ：%@",[self toPriceFormatter:allNum]];
        NSString *typeString = @"";
        NSNumber *typeNum    = [currentFee objectForKey:@"type"];
        if(typeNum.intValue == 1)
        {
            typeString = @"支付代理费";
        }
        else if (typeNum.intValue == 2)
        {
            typeString = @"退款";
        }
        else
        {
            typeString = @"托管代理费";
        }
        feeCell.feeType.text = typeString;
        feeCell.feeLeft.text = [NSString stringWithFormat:@"已托管余额 ：%@",[self toPriceFormatter:currentFee[@"left"]]];
        return feeCell;
    }
}

- (NSString *)dateFromISODateString:(NSString *)isodate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"];
    NSDate *currentDate = [dateFormatter dateFromString:isodate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringDate    =    [dateFormatter stringFromDate:currentDate];
    return stringDate;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // !!!:Tab One
    if(currentPageType == DelegateInfoType)
    {
        if(section == 0)
        {
            return @"";
        }
        else if (section == 1)
        {
            return @"相关文件";
        }
        else if(section == 2)
        {
            return @"意向律师";
        }
        else if(section == 3)
        {
            return @"";
        }
        else
        {
            if(isFinish)
            {
                if(allLawerArr.count == 0)
                {
                    return @"";
                }
                return @"律师回复";
            }
            else
            {
                return @"";
            }
        }
    }
    // !!!:Tab Two
    else if(currentPageType == DelegateHandleType)
    {
        if(section<numOfSection)
        {
            if([_currentRole isEqualToString:@"1"])
            {
                if(section == 1)
                {
                    return @"诉状";
                }
                else if (section == 2)
                {
                   return @"证据目录";
                }
                else if(section == 3)
                {
                   return @"授权委托书";
                }
                else if (section == 6)
                {
                   return @"立案受理通知书";
                }
                else if (section == 7)
                {
                    return @"诉讼费收据";
                }
                else if(section == 9)
                {
                    return @"传票";
                }
                else if(section == 12)
                {
                    return @"判决书/裁决书";
                }
                else
                {
                    return nil;
                }
            }
            else
            {
                if (section == 1)
                {
                    return @"答辩状";
                }
                else if(section == 2)
                {
                    return @"授权委托书";
                }
                else if (section == 5)
                {
                    return @"传票";
                }
                else if (section == 8)
                {
                    return @"判决书/裁决书";
                }
                else
                {
                    return nil;
                }
            }
            
        }
        else
        {
            if(isPeace)
            {
                if(section == numOfSection)
                {
                    return nil;
                }
                else if (section == numOfSection+1)
                {
                    return @"法院调解书/撤诉裁定";
                }
                else
                {
                    return nil;
                }
            }
            else
            {
                if (section == numOfSection)
                {
                    return nil;
                }
                else
                {
                    return nil;
                }

            }
        }
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(currentPageType == DelegateInfoType)
    {
        if(section == 1)
        {
            return 25;
        }
        if(section == 2 || section == 4)
        {
            return 25;
        }
        return 5;
    }
    else if(currentPageType == DelegateHandleType)
    {
        if(section<numOfSection)
        {
            if([_currentRole isEqualToString:@"1"])
            {
                if(section == 1)
                {
                    return 25;
                }
                else if (section == 2)
                {
                    return 25;
                }
                else if(section == 3)
                {
                    return 25;
                }
                else if (section == 6)
                {
                    return 25;
                }
                else if (section == 7)
                {
                    return 25;
                }
                else if(section == 9)
                {
                    return 25;
                }
                else if(section == 12)
                {
                    return 25;
                }
                else
                {
                    return 1;
                }

            }
            else
            {
                if (section == 1)
                {
                    return 25;
                }
                else if(section == 2)
                {
                    return 25;
                }
                else if (section == 5)
                {
                    return 25;
                }
                else if (section == 8)
                {
                    return 25;
                }
                else
                {
                    return 1;
                }
            }
        }
        else
        {
            if(isPeace)
            {
                if(section == numOfSection)
                {
                    return 1;
                }
                else if(section == numOfSection+1)
                {
                    return 25;
                }
                else
                {
                    return 1;
                }
            }
            else
            {
                if(section == numOfSection)
                {
                    return 1;
                }
                else
                {
                    return 1;
                }

            }
        }
    }
    else
    {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow     = indexPath.row;
    NSInteger currentSection = indexPath.section;
    // !!!:Tab One
    if(currentPageType == DelegateInfoType)
    {
        if(currentSection == 0&& currentRow == 0)
        {
            if(isFinish)
            {
                return;
            }
            [self showPickAction:nil];
        }
        if(currentSection == 0&& currentRow == 3)
        {
            if(isFinish)
            {
                return;
            }
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
            ZXY_CityZoneVC *cityZone = [story instantiateViewControllerWithIdentifier:@"cityVC"];
            [cityZone setLevel:YES];
            cityZone.delegate = self;
            [self.navigationController pushViewController:cityZone animated:YES];
        }
        if(currentSection == 1&&currentRow == allFileArr.count)
        {
            if(isFinish)
            {
                return;
            }
            [self chooseImage];
        }
        
        if(currentSection == 1 &&currentRow <allFileArr.count)
        {
            NSDictionary *currentDic = [allFileArr objectAtIndex:currentRow];
            if([currentDic[@"isUpload"] isEqualToString:@"YES"])
            {
                currentSelectAttr = currentDic;
                if(!isFinish)
                {
                    UIActionSheet *sheet     = [[UIActionSheet alloc] initWithTitle:@"您要" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看附件",@"删除附件", nil];
                    sheet.tag = 5000;
                    [sheet showInView:self.view];
                }
                else
                {
                    UIActionSheet *sheet     = [[UIActionSheet alloc] initWithTitle:@"您要" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看附件", nil];
                    sheet.tag = 5001;
                    [sheet showInView:self.view];
                }
                
            }
            
        }
        
        if(currentSection == 2&& currentRow == allLawerArr.count)
        {
            [self selectLawyers];
        }
        if(currentSection == 2&& currentRow < allLawerArr.count)
        {
            NSDictionary *currentDic = [allLawerArr objectAtIndex:currentRow];
            NSString *currentID = currentDic[@"_id"];
            UIStoryboard *icyStoryboard = [UIStoryboard storyboardWithName:@"LCYLawyerDetail" bundle:nil];
            LCYLawyerDetailViewController *lawyerDetailVC = [icyStoryboard instantiateInitialViewController];
            lawyerDetailVC.lawyerID = currentID;
            [self.navigationController pushViewController:lawyerDetailVC animated:YES];
        }
        if(currentSection == 4)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    // !!!:Tab Two
    else if(currentPageType == DelegateHandleType)
    {
        if(currentSection < numOfSection)
        {
            if([_currentRole isEqualToString:@"1"])
            {
                if(currentSection == 1)
                {
                    NSDictionary *fileInfos  = [complaint objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if (currentSection == 2)
                {
                    NSDictionary *fileInfos  = [evidenceListArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if(currentSection == 3)
                {
                    NSDictionary *fileInfos  = [attorneyArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if (currentSection == 4)
                {
                    if(currentRow == 0)
                    {
                        NSLog(@"下载三方律师");
                        ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                        webVC.title = @"聘请律师三方协议";
                        [webVC setDownLoadURL:API_LALALA_URL];
                        [self.navigationController pushViewController:webVC animated:YES];
                    }

                }
                
                else if(currentSection == 6)
                {
                    NSDictionary *fileInfos  = [notiBookArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if(currentSection == 7)
                {
                    NSDictionary *fileInfos  = [caseFileArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if(currentSection == 9)
                {
                    NSDictionary *fileInfos  = [tokenArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if(currentSection == 12)
                {
                    NSDictionary *fileInfos  = [judgeArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
            }
            else
            {
                if (currentSection == 1)
                {
                    NSDictionary *fileInfos  = [replyArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if(currentSection == 2)
                {
                    NSDictionary *fileInfos  = [attorneyArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if (currentSection == 3)
                {
                    // TODO:下载三方律师
                    if(currentRow == 0)
                    {
                        NSLog(@"下载三方律师");
                        ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                        webVC.title = @"聘请律师三方协议";
                        [webVC setDownLoadURL:API_LALALA_URL];
                        [self.navigationController pushViewController:webVC animated:YES];
                    }
                }
                
                else if(currentSection == 5)
                {
                    NSDictionary *fileInfos  = [tokenArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else if(currentSection == 8)
                {
                    NSDictionary *fileInfos  = [judgeArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }

            }
        }
        else
        {
            if(isPeace)
            {
                if(currentSection == numOfSection)
                {
                    return;
                }
                else if (currentSection == numOfSection+1)
                {
                    NSDictionary *fileInfos  = [peaceArr objectAtIndex:currentRow];
                    NSString     *fileID     = [fileInfos objectForKey:@"fileId"];
                    NSString     *fileName   = [fileInfos objectForKey:@"fileName"];
                    NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
                    ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
                    webVC.title = fileName;
                    [webVC setDownLoadURL:stringURL];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                else
                {
                    return;
                }
            }
        }
    }
    else
    {
        return;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isFinish)
    {
        return NO;
    }
    if(_caseID)
    {
        return NO;
    }
    if(indexPath.section == 2)
    {
        if(allLawerArr.count == 0)
        {
            return NO;
        }
        if(allLawerArr.count>indexPath.row)
        {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        if(allLawerArr.count>indexPath.row)
        {
           if(editingStyle == UITableViewCellEditingStyleDelete)
           {
               NSDictionary *deleteRow = [allLawerArr objectAtIndex:indexPath.row];
               [allLawerArr removeObject:deleteRow];
               [currentTable reloadData];
           }
        }
    }

}

// !!!:选择器相关
- (void)showPickAction:(id)sender
{
    if(isFinish)
    {
        return;
    }
    [self hideKeyBoard];
    CGSize pickerProfessionS = pickView.frame.size;
    if(![self.view.subviews containsObject:pickView])
    {
        pickView.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
        [self.view addSubview:pickView];
    }
    else
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        pickView.frame = CGRectMake(0, self.view.frame.size.height-pickerProfessionS.height, pickerProfessionS.width, pickerProfessionS.height);
    }];

}

- (IBAction)hidePickAction:(id)sender {
    CGSize pickerProfessionS = pickView.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        pickView.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
    }completion:^(BOOL finished) {
        [pickView removeFromSuperview];
    }];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.professionArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *entity = [self.professionArr objectAtIndex:row];
    return [entity objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *entity = [self.professionArr objectAtIndex:row];
    currentCase = entity;
    [currentTable reloadData];
    [self countCaseMoney];
}

// !!!:选择器相关结束


// !!!:计算起诉金额
- (void)countCaseMoney
{
    if([self checkForCaseMoney])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASEMONEY_URL];
        NSDictionary *parameter = @{
                                    @"uid":[[UserInfoDetail sharedInstance] getUserID],
                                    @"caseType":currentCase[@"categoryId"],
                                    @"area":_provinceEntity.name,
                                    @"amount":moneyString
                                    };
        [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([responseDic.allKeys containsObject:@"error"])
            {
                NSDictionary *errorDic = [responseDic objectForKey:@"error"];
                NSString     *errorString = [errorDic objectForKey:@"message"];
                [self showAlertWarnningView:@"提示" andContent:errorString];
            }
            else
            {
                discounted = responseDic[@"data"][@"legalCost"][@"discounted"];
                agencyCost = responseDic[@"data"][@"agencyCost"];
                total      = responseDic[@"data"][@"legalCost"][@"total"];
                [currentTable reloadData];
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
        }];
    }
    else
    {
        agencyCost = @"";
        total      = @"";
        discounted = @"";
    }
    
}

- (BOOL)checkForCaseMoney
{
     if(currentCase == nil)
     {
         return NO;
     }
     if(![self isUserInputNum:moneyString]||moneyString==nil)
     {
         return NO;
     }
     if(_provinceEntity == nil)
     {
         return NO;
     }
    return YES;
}

// !!!:选择律师

- (void)selectLawyers
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"tabLawPageStory" bundle:nil];
    ZXY_SearchLawerVC *searchLaw = [story instantiateViewControllerWithIdentifier:@"searchLawerID"];
    [searchLaw setIsChoose:YES];
    [self.navigationController pushViewController:searchLaw animated:YES];
}

// !!!:选择回复律师
- (void)sendSelectLawID:(NSString *)lawID
{
    delegateLawID = lawID;
    [currentTable reloadData];
}

- (void)notiMethod:(NSNotification *)notiArr
{
    allLawerArr = [NSMutableArray arrayWithArray:[notiArr object]];
    [currentTable reloadData];
    NSLog(@"%d",self.professionArr.count);
}

- (void)registLawersNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiMethod:) name:@"lawyersNoti" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lawyersNoti" object:nil];
}

// !!!:选择律师结束
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(isFinish)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-40, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+40, self.view.frame.size.width, self.view.frame.size.height);
    }];
    if(textField == moneyText)
    {
        moneyString = moneyText.text;
        [self countCaseMoney];
    }
}

- (void)hideKeyBoard
{
    [moneyText resignFirstResponder];
}

- (void)userChooseCityDelegate:(LawCityEntity *)provinceEntity andCityEntity:(LawCityEntity *)cityEntity withZoneEntity:(LawCityEntity *)zoneEntity
{
    _provinceEntity = provinceEntity;
    _cityEntity     = cityEntity;
    [currentTable reloadData];
    [self countCaseMoney];
}

// !!!:上传文件
- (void)chooseImage
{
    if(allFileArr.count>=10)
    {
        [self showAlertWarnningView:@"" andContent:@"最多只能选择十张照片"];
        return;
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        picherSheet = [[UIActionSheet alloc] initWithTitle:@"请选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图库选取",@"拍照选取", nil];
    }
    else
    {
        
        picherSheet = [[UIActionSheet alloc] initWithTitle:@"请选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图库选取", nil];
    }
    [picherSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 5000)
    {
        if(buttonIndex == 0)
        {
            NSString     *fileID     = [currentSelectAttr objectForKey:@"fileId"];
            NSString     *fileName   = [currentSelectAttr objectForKey:@"name"];
            NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
            ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
            webVC.title = fileName;
            [webVC setDownLoadURL:stringURL];
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else if (buttonIndex == 1)
        {
            [allFileArr removeObject:currentSelectAttr];
            [currentTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    else if (actionSheet.tag == 5001)
    {
        if(buttonIndex == 0)
        {
            NSString     *fileID     = [currentSelectAttr objectForKey:@"fileId"];
            NSString     *fileName   = [currentSelectAttr objectForKey:@"name"];
            NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
            ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
            webVC.title = fileName;
            [webVC setDownLoadURL:stringURL];
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        
        if(buttonIndex == 0)
        {
            ELCImagePickerController *pickerController = [[ELCImagePickerController alloc] initImagePicker];
            [pickerController setMaximumImagesCount:10-allFileArr.count];
            pickerController.returnsOriginalImage = NO;
            pickerController.returnsImage = YES;
            pickerController.onOrder = YES;
            pickerController.imagePickerDelegate = self;
            [self presentViewController:pickerController animated:YES completion:^{
                
            }];
        }
        else if (buttonIndex == 1)
        {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImage.allowsEditing = NO;
            pickerImage.delegate = self;
            [self presentViewController:pickerImage animated:YES completion:^{
                
            }];
            
        }
    }
    else
    {
        ELCImagePickerController *pickerController = [[ELCImagePickerController alloc] initImagePicker];
        [pickerController setMaximumImagesCount:10-allFileArr.count];
        pickerController.returnsOriginalImage = NO;
        pickerController.returnsImage = YES;
        pickerController.onOrder = YES;
        pickerController.imagePickerDelegate = self;
        [self presentViewController:pickerController animated:YES completion:^{
            
        }];
    }
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(allFileArr.count+info.count>10)
    {
        [self showAlertWarnningView:@"" andContent:@"最多只能选择十张图片"];
        return;
    }
    for(NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image      = [dict objectForKey:UIImagePickerControllerOriginalImage];
                NSString *imageName = [self stringForImageName];
                NSMutableDictionary *imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageName,@"name",image,@"data",@"NO",@"isUpload", nil];
                [allFileArr addObject:imageInfo];
            }
        }
    }
    [self performSelectorInBackground:@selector(uploadImage) withObject:nil];
}

- (NSString *)stringForImageName
{
    NSDateFormatter *dateFormtter = [[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *currentDateString = [dateFormtter stringFromDate:[NSDate date]];
    int valueOne   = arc4random_uniform(10);
    int valueTwo   = arc4random_uniform(10);
    int valueThree = arc4random_uniform(10);
    NSString *returnString = [NSString stringWithFormat:@"%@%d%d%d.jpg",currentDateString,valueOne,valueTwo,valueThree];
    return returnString;
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(allFileArr.count+1>10)
    {
        [self showAlertWarnningView:@"" andContent:@"最多只能选择十张图片"];
        return;
    }
    
    NSString *imageName = [self stringForImageName];
    NSMutableDictionary *imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageName,@"name",image,@"data",@"NO",@"isUpload", nil];
    [allFileArr addObject:imageInfo];
    
    [self performSelectorInBackground:@selector(uploadImage) withObject:nil];
    //[currentTable reloadData];
}

- (BOOL)isUpOver
{
    BOOL over = YES;
    for(NSMutableDictionary *imageInfo in allFileArr)
    {
        if([[imageInfo objectForKey:@"isUpload"] isEqualToString:@"NO"])
        {
            over = NO;
        }
    }
    return YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)uploadImage
{
    __block BOOL canContinue = YES;
    __block BOOL canDown = YES;
    __block int  currentIndex=0;
    while (canContinue) {
        if(canDown)
        {
            
            NSMutableDictionary *fileInfo = [allFileArr objectAtIndex:currentIndex];
            if([fileInfo[@"isUpload"] isEqualToString:@"NO"])
            {
                canDown = NO;
                UIImage *image = [fileInfo objectForKey:@"data"];
                NSString *fileString = [fileInfo objectForKey:@"name"];
                [fileInfo setObject:@"current" forKey:@"isUpload"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [currentTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                });
                
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                [self startUploadFileData:imageData withFileName:fileString andProgress:nil completeSuccess:^(NSDictionary *responseData) {
                    NSArray *dataDic = [responseData objectForKey:@"data"];
                    NSString     *fileId  = [[dataDic objectAtIndex:0] objectForKey:@"_id"];
                    [fileInfo setObject:fileId forKey:@"fileId"];
                    [fileInfo setObject:@"YES" forKey:@"isUpload"];
                    [currentTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    currentIndex ++;
                    if(currentIndex >= allFileArr.count)
                    {
                        canContinue = NO;
                        //                        dispatch_sync(dispatch_get_main_queue(), ^{
                        //                            [currentTable reloadData];
                        //                        });
                    }
                    else
                    {
                        canDown = YES;
                    }
                    
                } completeError:^(NSError *error) {
                    currentIndex++;
                    [fileInfo setObject:@"NO" forKey:@"isUpload"];
                    if(currentIndex >= allFileArr.count)
                    {
                        canContinue = NO;
                        //                        dispatch_sync(dispatch_get_main_queue(), ^{
                        //                            [currentTable reloadData];
                        //                        });
                    }
                    else
                    {
                        canDown = YES;
                    }
                    
                }];
            }
            else
            {
                currentIndex ++;
                if(currentIndex >= allFileArr.count)
                {
                    canContinue = NO;
                    //                    dispatch_sync(dispatch_get_main_queue(), ^{
                    //                        [currentTable reloadData];
                    //                    });
                }
                else
                {
                    canDown = YES;
                }
                
            }
            
        }
        
    }
    NSLog(@"结束了");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// !!!:提交相关

- (IBAction)submitAction:(id)sender
{
    UIButton *confrimBtns = (UIButton *)sender;
    if([confrimBtns.titleLabel.text isEqualToString:@"确认并支付"])
    {
        NSLog(@"下一话题");
        NSString *alertMsg;
        if ([_currentRole isEqualToString:@"2"]) {
            if ([realStage isEqualToString:@"2"]) {
                //打款10%
                alertMsg = @"确认后将支付给律师10%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"4"]) {
                //打款60%
                alertMsg = @"确认后将支付给律师60%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"5"]) {
                //打款30%(剩)
                alertMsg = @"确认后将支付给律师30%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"7"]) {
                //打款剩余所有
                alertMsg = @"确认后将支付给律师所有剩余的代理费，您确定要继续吗？";
            }
        } else {
            if ([realStage isEqualToString:@"2"]) {
                //打款10%
                alertMsg = @"确认后将支付给律师10%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"3"] || [realStage isEqualToString:@"4"]) {
                //打款30%
                alertMsg = @"确认后将支付给律师30%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"5"]) {
                //打款30%(剩)
                alertMsg = @"确认后将支付给律师30%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"7"]) {
                //打款剩余所有
                alertMsg = @"确认后将支付给律师所有剩余的代理费，您确定要继续吗？";
            }
        }
        UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        confirmAlert.tag = 5005;
        [confirmAlert show];
        return;
    }

    else if([self isUserInputValidate])
    {
        UIAlertView *sAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定提交案件委托吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        sAlert.tag = 5000;
        [sAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == 5000) // 提交
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASEADD_URL];
            NSDictionary *urlParameter = [self toSubmitParameter];
            [self startLoadDataPOSTCSRF:urlString withPatameter:urlParameter successBlock:^(NSData *responseData) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if([responseDic.allKeys containsObject:@"error"])
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self showAlertWarnningView:@"提示" andContent:responseDic[@"error"][@"message"]];
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } errorBlock:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
            }];
        }
        else if (alertView.tag == 5001) //更新
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASEUPDATE_URL];
            NSDictionary *dataDic = [self toSubmitParameter][@"data"];
            NSDictionary *idDic   = @{
                                      @"id":_caseID
                                      };
            NSDictionary *parameter = @{
                                        @"filter":idDic,
                                        @"data":dataDic
                                        };
            [self startLoadDataPutCSRF:stringURL withParameter:parameter successBlock:^(NSData *responseData) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if([responseDic.allKeys containsObject:@"error"])
                {
                    [self showAlertWarnningView:@"提示" andContent:@"更新委托失败，请联系客服。"];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } errorBlock:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
            }];

        }
        else if (alertView.tag == 5002) //撤销代理
        {
            [self cancelDelegate];
        }
        else if (alertView.tag == 5003) // 确定委托
        {
            [self ensuerDelegate];
        }
        else if (alertView.tag == 5004 || alertView.tag == 5005) // 确认并购买
        {
            [self nextStepDelegate];
        }
        else if (alertView.tag == 6000) // 提出异议
        {
            [self performSegueWithIdentifier:@"toYIYI" sender:nil];
        }
    }
}

- (NSDictionary *)toSubmitParameter
{
    NSDictionary *locationPDic = @{
                                   @"name":_provinceEntity.name,
                                   @"id"  :_provinceEntity.cityID
                                   };
    NSDictionary *loactionCDic = @{
                                   @"name":_cityEntity.name,
                                   @"id"  :_cityEntity.cityID
                                   };
    NSDictionary *locationDic  = @{
                                   @"province":locationPDic,
                                   @"city":loactionCDic
                                   };
    NSMutableArray *fileParameter = [[NSMutableArray alloc] init];
    for(NSDictionary *fileInfo in allFileArr)
    {
        NSDictionary *fileParameterInfo = @{
                                            @"fileName":fileInfo[@"name"],
                                            @"fileId"  :fileInfo[@"fileId"]
                                            };
        [fileParameter addObject:fileParameterInfo];
    }
    
    NSMutableArray *lawParameter = [[NSMutableArray alloc] init];
    for(NSDictionary *lawInfo in allLawerArr)
    {
        [lawParameter addObject:lawInfo[@"_id"]];
    }
    NSDictionary *parameterData = @{
                                    @"amount":moneyString,
                                    @"location":locationDic,
                                    @"role":_currentRole,
                                    @"adviceFee":total,
                                    @"discount":discounted,
                                    @"costs":agencyCost,
                                    @"type":[currentCase objectForKey:@"categoryId"],
                                    @"files":fileParameter,
                                    @"intention":lawParameter
                                    };
    return @{
             @"uid":[[UserInfoDetail sharedInstance] getUserID],
             @"data":parameterData
             };
    
}

- (BOOL)isUserInputValidate
{
    BOOL validate = YES;
    if(![self isUserInputNum:moneyString]||moneyString ==nil || [moneyString isEqualToString:@""])
    {
        [self showAlertWarnningView:@"提示" andContent:@"起诉金额不能为空并且必须为整数。"];
        validate = NO;
    }
    else if (_provinceEntity == nil)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请选择完整的省、市。"];
        validate = NO;
    }
    else if (allFileArr.count==0||allFileArr.count>10)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请上传相关文件。最多可上传10个文件。"];
        validate = NO;
    }
    else if (allLawerArr.count==0||allLawerArr.count>3)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请选择意向代理律师，最多可选择三位意向律师。"];
        validate = NO;
    }
    for(NSDictionary *imageInfo in allFileArr)
    {
        NSString *statusStrings  = imageInfo[@"isUpload"];
        if(![statusStrings isEqualToString:@"YES"])
        {
            [self showAlertWarnningView:@"提示" andContent:@"还有正在上传中的文件"];
            validate = NO;
            break;
        }
    }

    if(validate)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (IBAction)freshAction:(id)sender
{
    UIButton *confrimBtns = (UIButton *)sender;
    if([confrimBtns.titleLabel.text isEqualToString:@"确认并支付"])
    {
        NSString *alertMsg;
        if ([_currentRole isEqualToString:@"2"]) {
            if ([realStage isEqualToString:@"2"]) {
                //打款10%
                alertMsg = @"确认后将支付给律师10%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"4"]) {
                //打款60%
                alertMsg = @"确认后将支付给律师60%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"5"]) {
                //打款30%(剩)
                alertMsg = @"确认后将支付给律师30%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"7"]) {
                //打款剩余所有
                alertMsg = @"确认后将支付给律师所有剩余的代理费，您确定要继续吗？";
            }
        } else {
            if ([realStage isEqualToString:@"2"]) {
                //打款10%
                alertMsg = @"确认后将支付给律师10%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"3"] || [realStage isEqualToString:@"4"]) {
                //打款30%
                alertMsg = @"确认后将支付给律师30%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"5"]) {
                //打款30%(剩)
                alertMsg = @"确认后将支付给律师30%的代理费，您确定要继续吗？";
            } else if ([realStage isEqualToString:@"7"]) {
                //打款剩余所有
                alertMsg = @"确认后将支付给律师所有剩余的代理费，您确定要继续吗？";
            }
        }
        UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        confirmAlert.tag = 5004;
        [confirmAlert show];
        return;
        return;
    }
    if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"0"])
    {
        if([self isUserInputValidate])
        {
            UIAlertView *sAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定更新案件委托吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            sAlert.tag = 5001;
            [sAlert show];
        }
        
    }
    if([_status isEqualToString:@"0"]&&[_stage isEqualToString:@"1"])
    {
        if(delegateLawID==nil)
        {
            [self showAlertWarnningView:@"" andContent:@"请选择代理律师"];
            return;
        }
        NSString *lawyerName ;
        NSString *lawyerDe;
        for(NSDictionary *lawyerInfo in replyLawyerArr)
        {
            if([lawyerInfo[@"_id"] isEqualToString:delegateLawID])
            {
                lawyerName = lawyerInfo[@"name"];
                floatMoney = lawyerInfo[@"fee"];
                lawyerDe   = lawyerInfo[@"depart"];
                break;
            }
        }
        NSString *alertString = [NSString stringWithFormat:@"您确定选择 %@ 的 %@ 为本案件的代理律师吗？",lawyerDe,lawyerName];
        UIAlertView *alert    = [[UIAlertView alloc] initWithTitle:@"提示" message:alertString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 5003;
        [alert show];
    }
    
    if([_status isEqualToString:@"1"]&&[_stage isEqualToString:@"1"])
    {
        UIStoryboard *icyStoryboard = [UIStoryboard storyboardWithName:@"LCYOrderList" bundle:nil];
        [self.navigationController pushViewController:icyStoryboard.instantiateInitialViewController animated:YES];
    }
}

- (IBAction)cancelAction:(id)sender
{
    UIButton *canButton = (UIButton *)sender;
    if([canButton.titleLabel.text isEqualToString:@"撤销委托"])
    {
        UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定撤销本次委托吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alerts.tag = 5002;
            [alerts show];
    }
    else if ([canButton.titleLabel.text isEqualToString:@"提出异议"])
    {
         [self performSegueWithIdentifier:@"toYIYI" sender:nil];
    }
}

- (void)cancelDelegate
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASECANCEL_URL];
    NSDictionary *paramenter = @{
                                 @"id":_caseID
                                 };
    [self startLoadDataPutCSRF:urlString withParameter:paramenter successBlock:^(NSData *responseData) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([returnDic.allKeys containsObject:@"error"])
        {
            [self showAlertWarnningView:@"提示" andContent:@"撤销委托失败，请联系客服。"];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWarnningView:@"提示" andContent:@"撤销委托失败，请联系客服。"];;
    }];
}

- (void)nextStepDelegate
{
//    [self performSegueWithIdentifier:@"toEvaluate" sender:nil];
//    return;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASECONFIRM_URL];
    NSDictionary *parameter = @{
                                @"id":_caseID
                                };
    [self startLoadDataPutCSRF:urlString withParameter:parameter successBlock:^(NSData *responseData) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([returnDic.allKeys containsObject:@"error"])
        {
            [self showAlertWarnningView:@"提示" andContent:@"[确认失败，请联系客服。]"];
            return ;
        }
        else
        {
            if(isPeace)
            {
                [self performSegueWithIdentifier:@"toEvaluate" sender:nil];
                return;
            }
            else if([realStage isEqualToString:@"5"]&&[realStatus isEqualToString:@"1"])
            {
                [self performSegueWithIdentifier:@"toEvaluate" sender:nil];
                return;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
;
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWarnningView:@"提示" andContent:@"[确认失败，请联系客服。]"];;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toEvaluate"])
    {
        ZXY_MyCaseEvaluLawVC *eva = [segue destinationViewController];
        [eva setCaseID:_caseID];
    }
    if([segue.identifier isEqualToString:@"toYIYI"])
    {
        ZXY_MyCaseDifferentVC *dV = [segue destinationViewController];
        [dV setCaseID:_caseID];
    }
    
    
}

- (void)showComment:(id)sender
{
    UIButton *btns = (UIButton *)sender;
    if(commentView == nil)
    {
        commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else
    {
        for(UIView *sV in commentView.subviews)
        {
            [sV removeFromSuperview];
        }
    }
    commentView.opaque = NO;
    UIImageView *backGr = [[UIImageView alloc] initWithFrame:commentView.frame];
    [commentView addSubview:backGr];
    backGr.backgroundColor = [UIColor lightGrayColor];
    backGr.alpha = 0.6;
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake((commentView.frame.size.width-280)/2, 20, 280, commentView.frame.size.height-40)];
    textV.text = btns.titleLabel.text;
    [textV setEditable:NO];
    [commentView addSubview:textV];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCommentView)];
    [commentView addGestureRecognizer:tapges];
    [self.view addSubview:commentView];
}

- (void)hideCommentView
{
    [commentView removeFromSuperview];
}

- (void)ensuerDelegate
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASEENSURE_URL];
    NSDictionary *parameter = @{
                                @"uid":[[UserInfoDetail sharedInstance] getUserID],
                                @"caseId":_caseID,
                                @"selectLawyerId":delegateLawID
                                };
    [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([returnDic.allKeys containsObject:@"error"])
        {
            [self showAlertWarnningView:@"提示" andContent:@"撤销委托失败，请联系客服。"];
        }
        else
        {
            UIStoryboard *story     = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
            ZXY_PayVC    *payVC     = [story instantiateViewControllerWithIdentifier:@"payV"];
            [payVC setOrderInfo:[returnDic objectForKey:@"data"] andPrice:floatMoney.floatValue withNumString:nil];
            [self.navigationController pushViewController:payVC animated:YES];
        }

    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
    }];
}

@end
