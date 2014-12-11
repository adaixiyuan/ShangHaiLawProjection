//
//  ZXY_ServiceContractAddVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ServiceContractAddVC.h"
#import "ZXY_UserLoginVC.h"
#import "ZXY_ContractJsonHeader.h"
#import "LawEntityHelper.h"
#import "ZXY_ContractFirstCell.h"
#import "ZXY_ContractNeedCell.h"
#import "ZXY_ContractSecondCell.h"
#import "ZXY_ContractSubmitCell.h"
#import "ContractType.h"
#import "ZXY_LawCircleView.h"
#import "ZXY_AnswerQuestionVC.h"
#import "ZXY_ContractListVC.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Definition.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "PopupView.h"

typedef enum {
    MainType   = 1,
    SecondType = 2,
    ThirdType  = 3,
    FourthType = 4
}CurrentContractType;
@interface ZXY_ServiceContractAddVC ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    NSInteger currentRowNum;
    UITextView *needsTextV;
    NSString   *needsString;
    CGRect currentViewFrame;
    NSMutableArray *allContractType;
    ContractType *parentContract;
    ContractType *subContract;
    ContractType *thirdContract;
    ContractType *fourthContract;
    CurrentContractType _currentType;
    NSInteger thirdRowType;
    NSInteger fourthRowType;
    NSArray *dataForPicker;
    NSDictionary *checkInfo;
    NSDictionary *detailDicInfo;
    NSString *_currentStatus;
    UIView   *circleView;
    BOOL hasFourRow;
    BOOL isDetail;
    BOOL isDrafting;
    BOOL isOther;
    NSString *_contractID;
    IBOutlet UIView *pickerView;
    __weak IBOutlet UIPickerView *pickerController;
    __weak IBOutlet UITableView *currentTCV;
    NSDictionary *questionDicForNext;
    NSDictionary *answerDicForNext;
    BOOL isShowAnswer;
    BOOL isBegain;
    UIToolbar *topBar;
}
@end

@implementation ZXY_ServiceContractAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    _popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
    _popView.ParentView = self.view;
    
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;

    // Do any additional setup after loading the view.
    [self initNavi];
    [self startLoad];
    if(isDetail)
    {
        
    }
    else
    {
        [self initData];
    }
    [self draCircle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentViewFrame = self.view.frame;
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)isDetailView:(NSDictionary *)detailDic
{
    isDetail = YES;
    detailDicInfo = detailDic;
    NSString *statusString = [detailDicInfo objectForKey:@"status"];
    _currentStatus = statusString;
    if([detailDicInfo[@"type"] isEqualToString:@"NW2999"])
    {
        isOther = YES;
        currentRowNum = 3;
        thirdRowType  = 5;
    }
}

- (void)initViewForTable
{
    [self initDetailData];
}

- (void)initDetailData
{
    NSString *parentType   = [detailDicInfo objectForKey:@"type1"];
    NSString *subchileType = [detailDicInfo objectForKey:@"type"];
    _contractID            = [detailDicInfo objectForKey:@"_id"];
    parentContract         = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:parentType andKey:@"contractType"] objectAtIndex:0];
    subContract            = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:subchileType andKey:@"contractType"] objectAtIndex:0];
    NSString *roleType     = [detailDicInfo objectForKey:@"role"];
    if(roleType == nil)
    {
        roleType = @"0";
    }
    NSString *targetType   = [detailDicInfo objectForKey:@"target"];
    if(targetType == nil)
    {
        targetType = @"0";
    }
    if([targetType isEqualToString:@"0"]&&[roleType isEqualToString:@"0"])
    {
        currentRowNum = 2;
    }
    else if(![targetType isEqualToString:@"0"]&&[roleType isEqualToString:@"0"])
    {
        thirdContract = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:targetType andKey:@"contractType"] objectAtIndex:0];
        currentRowNum = 3;
        thirdRowType = 3;
        hasFourRow = NO;
    }
    else if([targetType isEqualToString:@"0"]&&![roleType isEqualToString:@"0"])
    {
        
        currentRowNum = 3;
        thirdRowType  = 4;
        hasFourRow    = NO;
        thirdContract = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:roleType andKey:@"contractType"] objectAtIndex:0];
    }
    else
    {
        thirdContract = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:targetType andKey:@"contractType"] objectAtIndex:0];
        fourthContract= [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:roleType andKey:@"contractType"] objectAtIndex:0];
        currentRowNum = 4;
        thirdRowType  = 3;
        hasFourRow    = YES;
    }
    if(isOther)
    {
        currentRowNum = 3;
        thirdRowType  = 5;
    }

    [currentTCV reloadData];
}

- (void)setStatus:(NSString *)statusString
{
    if([statusString isEqualToString:@"1"])
    {
        _currentStatus = @"1";
    }
    else
    {
       _currentStatus  = @"2";
    }
}



- (void)initData
{
    isDrafting = NO;
    
    currentRowNum = 2;
    allContractType = [[NSMutableArray alloc] init];
    if(_currentStatus == nil)
    {
        _currentStatus = @"1";
    }
}

- (void)draCircle
{
    if(circleView == nil)
    {
        circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    }
    ZXY_LawCircleView *lawCircle = [[ZXY_LawCircleView alloc] initWithPositionY:10];
    [lawCircle setNumOfCircle:2];
    [lawCircle setCircleInfo:[NSArray arrayWithObjects:@"起草",@"完成", nil]];
    
    if([_currentStatus isEqualToString:@"1"])
    {
        [lawCircle setSelectBackColor:[UIColor colorWithRed:23.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]];
        [lawCircle setSelectIndex:0];
    }
    else if([_currentStatus isEqualToString:@"2"])
    {
        [lawCircle setSelectBackColor:[UIColor colorWithRed:59.0/255.0 green:148.0/255.0 blue:223.0/255.0 alpha:1]];
        [lawCircle setSelectIndex:1];
    }
    else
    {
        [lawCircle setISNOSelect:YES];
    }
    [circleView addSubview:lawCircle];
    [currentTCV setTableHeaderView:circleView];
}

- (void)resetCircle
{
    if(circleView == nil)
    {
        circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    }
    else
    {
        for(UIView *subview in circleView.subviews)
        {
            [subview removeFromSuperview];
        }
    }
    ZXY_LawCircleView *lawCircle = [[ZXY_LawCircleView alloc] initWithPositionY:10];
    [lawCircle setNumOfCircle:2];
    [lawCircle setCircleInfo:[NSArray arrayWithObjects:@"起草",@"完成", nil]];
    if([_currentStatus isEqualToString:@"1"])
    {
        [lawCircle setSelectIndex:0];
    }
    else
    {
        [lawCircle setSelectIndex:1];
    }
    [circleView addSubview:lawCircle];
    [currentTCV setTableHeaderView:circleView];
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:@"合同起草" withPositon:1 ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableV数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isDetail&&[_currentStatus isEqualToString:@"2"])
    {
     
        if([detailDicInfo[@"type"] isEqualToString:@"NW2999"])
        {
            return currentRowNum +1;
        }

        return currentRowNum +2;
    }
    return currentRowNum+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == currentRowNum)
    {
        return 48;
    }
    else if (indexPath.row == currentRowNum+1)
    {
        return 48;
    }
    else
    {
        if(indexPath.row == 0)
        {
            return 51;
        }
        else if (indexPath.row == 1)
        {
            return 51;
        }
        else if(indexPath.row == 2)
        {
            if(thirdRowType == 5)
            {
                return 140;
            }
            else
            {
                return 51;
            }
        }
        return 51;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow = indexPath.row;
    if(currentRow == 0)
    {
        ZXY_ContractFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:ContractFirstCellID];
        firstCell.titleLbl.text = @"文书种类：";
        [firstCell.questionBtn setHidden:NO];
        firstCell.lalaBlock = ^()
        {
            [self showAlertWarnningView:@"提示" andContent:@"如您有任何疑问或有特殊定制需求，可直接拨打法率热线4008607766！\n如您未找到相应文本或有特殊定制需求，也可选择其他，并将需求告知，法率网将在标准期限内给您反馈！"];
        };
        if(parentContract)
        {
            firstCell.valueLbl.text = parentContract.typeName;
        }
        else
        {
            firstCell.valueLbl.text = @"请选择";
        }
        return firstCell;
    }
    else if (currentRow == 1)
    {
        ZXY_ContractFirstCell *secontCell = [tableView dequeueReusableCellWithIdentifier:ContractFirstCellID];
        secontCell.titleLbl.text = @"目录名称：";
        [secontCell.questionBtn setHidden:YES];
        if(subContract)
        {
            secontCell.valueLbl.text = subContract.typeName;
        }
        else
        {
            secontCell.valueLbl.text = @"请选择";
        }
        return secontCell;
    }
    else if (currentRow==currentRowNum)
    {
        ZXY_ContractSubmitCell *submitCell = [tableView dequeueReusableCellWithIdentifier:ContractSubmitCellID];
        if([_currentStatus isEqualToString:@"2"])
        {
            [submitCell.submitBtn setTitle:@"查看相关附件" forState:UIControlStateNormal];
            [submitCell.submitBtn setTitle:@"查看相关附件" forState:UIControlStateHighlighted];
            submitCell.submitBlock = ^()
            {
                [self toAttrList];
            };
        }
        else if(isDetail)
        {
            if(isOther)
            {
                [submitCell.submitBtn setHidden:YES];
            }
            [submitCell.submitBtn setTitle:@"填写相关信息" forState:UIControlStateNormal];
            [submitCell.submitBtn setTitle:@"填写相关信息" forState:UIControlStateHighlighted];
            submitCell.submitBlock = ^()
            {
                 [self needToAnserQuestion];
            };
        }
        else
        {
        
            if(isBegain)
            {
                [submitCell.submitBtn setTitle:@"填写相关信息" forState:UIControlStateNormal];
                [submitCell.submitBtn setTitle:@"填写相关信息" forState:UIControlStateHighlighted];
                submitCell.submitBlock = ^()
                {
                   
                   [self getAnswer];
                };

            }
            else
            {
                if(thirdRowType == 5)
                {
                    // !!!:修改其他
                    [submitCell.submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
                    [submitCell.submitBtn setTitle:@"提交申请" forState:UIControlStateHighlighted];
                    submitCell.submitBlock = ^()
                    {
                        [self submitOtherInfo];
                    };
                }
                else
                {
                    [submitCell.submitBtn setTitle:@"开始起草" forState:UIControlStateNormal];
                    [submitCell.submitBtn setTitle:@"开始起草" forState:UIControlStateHighlighted];
                    submitCell.submitBlock = ^()
                    {
                        [self submitAction];
                    };
                }
            }
        }
        return submitCell;
    }
    else if (currentRow == currentRowNum+1 )
    {
        if(isDetail)
        {
            ZXY_ContractSubmitCell *submitCell = [tableView dequeueReusableCellWithIdentifier:ContractSubmitCellID];
            [submitCell.submitBtn setTitle:@"查看问题" forState:UIControlStateNormal];
            [submitCell.submitBtn setTitle:@"查看问题" forState:UIControlStateHighlighted];
            submitCell.submitBlock = ^()
            {
                [self showAnswerQuestion];
            };
            return submitCell
            ;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if(currentRow == 2)
        {
            if(thirdRowType == 3)
            {
                ZXY_ContractFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:ContractFirstCellID];
                [firstCell.questionBtn setHidden:YES];
                firstCell.titleLbl.text = @"合同细分：";
                if(thirdContract)
                {
                    firstCell.valueLbl.text = thirdContract.typeName;
                }
                else
                {
                    firstCell.valueLbl.text = @"请选择";
                }
                return firstCell;
            }
            else if(thirdRowType == 4)
            {
                ZXY_ContractSecondCell *segCell = [tableView dequeueReusableCellWithIdentifier:ContractSecondCell];
                if(isBegain)
                {
                    [segCell.selectSeg setEnabled:NO];
                }
                NSArray *subArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:subContract.contractType andKey:@"parentID"];
                if(subArr.count>0)
                {
                    if(isDetail)
                    {
                        [segCell.selectSeg setEnabled:NO];
                        NSInteger index = [subArr indexOfObject:thirdContract];
                        segCell.selectIndex = index;
                    }
                    else
                    {
                        thirdContract = [subArr objectAtIndex:0];
                    }
                }
                segCell.allContractType = subArr;
                segCell.selectRoleBlock = ^(ContractType *selectType)
                {
                    thirdContract = selectType;
                };
                [segCell setNeedsDisplay];
                return segCell;
            }
            else
            {
                // !!!:修改其他
                ZXY_ContractNeedCell *cell = [tableView dequeueReusableCellWithIdentifier:ContractNeedCellID];
                needsTextV = cell.needTextV;
                needsTextV.delegate = self;
                if(topBar == nil)
                {
                    topBar = [self toolBarWithRight:@"完成" andLeft:nil withRightBtnSel:@selector(hideKeyboard) andLeftBtnSel:nil];
                }
                [needsTextV setInputAccessoryView:topBar];
                if(needsString)
                {
                    needsTextV.text = needsString;
                }
                if(isDetail)
                {
                    needsTextV.text = [detailDicInfo objectForKey:@"comment"];
                    needsTextV.userInteractionEnabled = NO;
                    [cell.speechBtn  setHidden:YES];
                }
                cell.currentBlock = ^(void)
                {
                    NSLog(@"hello world");
                    [self startListenning:nil];
                };
                return cell;
            }
        }
        else
        {
            if(hasFourRow)
            {
                ZXY_ContractSecondCell *segCell = [tableView dequeueReusableCellWithIdentifier:ContractSecondCell];
                if(isBegain)
                {
                    [segCell.selectSeg setEnabled:NO];
                }
                NSArray *subArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:thirdContract.contractType andKey:@"parentID"];
                if(subArr.count>0)
                {
                    if(isDetail)
                    {
                        [segCell.selectSeg setUserInteractionEnabled:NO];
                        NSInteger index = [subArr indexOfObject:fourthContract];
                        segCell.selectIndex = index;
                    }
                    else
                    {
                        fourthContract = [subArr objectAtIndex:0];
                    }
                }
                segCell.allContractType = subArr;
                segCell.selectRoleBlock = ^(ContractType *selectType)
                {
                    fourthContract = selectType;
                };
                [segCell setNeedsDisplay];
                return segCell;
            }
            else
            {
                ZXY_ContractSecondCell *segCell = [tableView dequeueReusableCellWithIdentifier:ContractSecondCell];
                return segCell;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        if(isBegain)
        {
            return;
        }
        _currentType = MainType;
        [self showPickerView];
    }
    else if(indexPath.row == 1)
    {
        if(isBegain)
        {
            return;
        }
        // !!!:修改其他
        if(parentContract == nil || thirdRowType == 5)
        {
            return;
        }
        // !!!:修改其他结束
        _currentType = SecondType;
        [self showPickerView];
    }
    else if (currentRowNum == indexPath.row)
    {
        return;
    }
    else
    {
        if(indexPath.row == 2)
        {
            if(isBegain)
            {
                return;
            }
            if(subContract == nil)
            {
                return;
            }
            if(thirdRowType == 5)
            {
                return;
            }
            _currentType = ThirdType;
            [self showPickerView];
        }
        
    }
}

#pragma mark - 显示与隐藏pickerView

- (void)showPickerView
{
    if(isDetail)
    {
        return;
    }
    [pickerController reloadComponent:0];
    if(parentContract == nil)
    {
        NSArray *allParent = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:@"1" andKey:@"typeValue"];
        if(allParent.count>0)
        {
            parentContract = [allParent objectAtIndex:0];
            [currentTCV reloadData];
        }
    }
    else
    {
        if(_currentType == MainType)
        {
            NSArray *allParent = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:@"1" andKey:@"typeValue"];
            NSInteger index = [allParent indexOfObject:parentContract];
            [pickerController selectRow:index inComponent:0 animated:NO];
        }
        else
        {
            [pickerController selectRow:0 inComponent:0 animated:NO];
        }
    }
    CGSize pickerProfessionS = pickerView.frame.size;
    if(![self.view.subviews containsObject:pickerView])
    {
        pickerView.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
        [self.view addSubview:pickerView];
    }
    else
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        pickerView.frame = CGRectMake(0, self.view.frame.size.height-pickerProfessionS.height, pickerProfessionS.width, pickerProfessionS.height);
    }];

}

- (IBAction)hidePickerView:(id)sender
{
    CGSize pickerProfessionS = pickerView.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        pickerView.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
    }completion:^(BOOL finished) {
        [pickerView removeFromSuperview];
    }];
}


# pragma mark - pickerVC数据源和代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_currentType == MainType)
    {
        dataForPicker = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:@"1" andKey:@"typeValue"];
        return dataForPicker.count;
    }
    else if (_currentType == SecondType)
    {
        dataForPicker = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:parentContract.contractType  andKey:@"parentID"];
    }
    else if (_currentType == ThirdType)
    {
        dataForPicker = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:subContract.contractType  andKey:@"parentID"];
    }
    else
    {
        dataForPicker = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:thirdContract.contractType  andKey:@"parentID"];
    }
    return dataForPicker.count+1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(_currentType == MainType)
    {
        ContractType *currentContract = [dataForPicker objectAtIndex:row];
        return currentContract.typeName;
    }
    else
    {
        if(row == 0)
        {
            return @"";
        }
        else
        {
            ContractType *currentContract = [dataForPicker objectAtIndex:row-1];
            return currentContract.typeName;
        }
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(_currentType == MainType)
    {
        ContractType *currentContract = [dataForPicker objectAtIndex:row];
        parentContract = currentContract;
        subContract    = nil;
        thirdContract  = nil;
        currentRowNum  = 2;
// !!!:修改其他
        if([parentContract.typeName isEqualToString:@"其他"])
        {
             NSArray *allChild = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:parentContract.contractType  andKey:@"parentID"];
            if(allChild.count>0)
            {
                ContractType *currentContract = [allChild objectAtIndex:0];
                subContract                   = currentContract;
                currentRowNum = 3;
                thirdRowType  = 5;
            }

        }
        else
        {
            thirdRowType = 0;
        }
// !!!:修改其他结束
    }
    else if (_currentType == SecondType)
    {
        if(row == 0)
        {
            subContract = nil;
            currentRowNum = 2;
            thirdContract = nil;
            [currentTCV reloadData];
            return;
        }
        ContractType *currentContract = [dataForPicker objectAtIndex:row-1];
        subContract  =  currentContract;
        NSArray *allChild = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:subContract.contractType  andKey:@"parentID"];
        thirdContract = nil;
        if(allChild.count>0)
        {
            ContractType *currentContract = [allChild objectAtIndex:0];
            if([currentContract.typeValue isEqualToString:@"3"])
            {
                currentRowNum=3;
                thirdRowType = 3;
            }
            else if([currentContract.typeValue isEqualToString:@"4"])
            {
                currentRowNum =3;
                thirdRowType = 4;
            }
        }
        else
        {
            thirdRowType = 0;
            currentRowNum = 2;
        }
    }
    else if (_currentType == ThirdType)
    {
        if(row == 0)
        {
            currentRowNum = 2;
            thirdContract = nil;
            hasFourRow = NO;
            currentRowNum = 3;
            [currentTCV reloadData];
            return;
        }

        ContractType *currentContract = [dataForPicker objectAtIndex:row-1];
        thirdContract  = currentContract;
        NSArray *allChild = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:thirdContract.contractType  andKey:@"parentID"];
        if(allChild.count>0)
        {
            hasFourRow = YES;
            currentRowNum = 4;
        }
        else
        {
            hasFourRow = NO;
            currentRowNum = 3;
        }

    }
    else
    {
        //fourthContract = currentContract;
    }
    [currentTCV reloadData];
}



# pragma mark - 加载数据
- (void)startLoad
{
    [currentTCV setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [[NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CATEGORY_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paramater = [NSDictionary dictionaryWithObjectsAndKeys:@"知识库文书分类",@"type", nil];
    [self startLoadDataGETCSRF:urlString withPatameter:paramater successBlock:^(NSData *responseData) {
        [currentTCV setHidden:NO];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        ZXYContractType *contractType = [ZXYContractType modelObjectWithDictionary:jsonDic];
        ZXYData *contractData         = contractType.data;
        NSArray *contractArr          = contractData.items;
        [LawEntityHelper saveContractType:contractArr];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(isDetail)
        {
            [self initViewForTable];
        }
    } errorBlock:^(NSError *error) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        loginVC.onComplete = ^()
        {
            [self startLoad];
        };
        [self.navigationController pushViewController:loginVC animated:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


- (void)submitAction
{
    if([self checkInfo])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSLog(@"数据填写齐全可以提交:%@-->%@-->%@-->%@",parentContract.typeName,subContract.typeName,thirdContract.typeName,fourthContract.typeName);
        NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CHECKCONTRACT_URL];
        NSString *target    = @"0";
        NSString *role      = @"";
        
        if(thirdContract)
        {
            if([thirdContract.typeValue isEqualToString:@"3"])
            {
                target = thirdContract.contractType;
                if(fourthContract)
                {
                    role = fourthContract.contractType;
                }
            }
            else
            {
                role   = thirdContract.contractType;
            }
        }
        
        NSDictionary *parameters = @{
                                     @"type1"    :[NSString stringWithFormat:@"%@", parentContract.contractType ],
                                     @"type2"    :[NSString stringWithFormat:@"%@", subContract.contractType ],
                                     @"type"     :[NSString stringWithFormat:@"%@", subContract.contractType ],
                                     @"name"     :[[NSString stringWithFormat:@"%@.docx",subContract.typeName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                     @"status"   :@"1",
                                     @"role"     :role,
                                     @"target"   :target,
                                     @"uid"      :[[UserInfoDetail sharedInstance] getUserID]
                                     };
        NSDictionary *currentParameter = [NSDictionary dictionaryWithObjectsAndKeys:parameters,@"data", nil];
        
        [self startLoadDataPOSTCSRF:stringURL withPatameter:currentParameter successBlock:^(NSData *responseData) {
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if([infoDic.allKeys containsObject:@"error"])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                //NSDictionary *errorDic = [infoDic objectForKey:@"error"];
                [self showAlertWarnningView:@"" andContent:@"您选择的文书，法率网暂时不支持自助生成，请拨打法率网热线电话咨询。"];
                return ;
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                checkInfo = infoDic;
                UIAlertView *currentAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定消费合同起草服务吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
                
                [currentAlert show];
                
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
;
        }];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 9000)
    {
        if(buttonIndex == 0)
        {
            NSDictionary *parameters = @{
                                         @"type1"    :parentContract.contractType,
                                         @"type2"    :subContract.contractType,
                                         @"type"     :subContract.contractType,
                                         @"name"     :[[NSString stringWithFormat:@"%@.docx",subContract.typeName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                         @"status"   :@"1",
                                         @"role"     :@"",
                                         @"target"   :@"0",
                                         @"uid"      :[[UserInfoDetail sharedInstance] getUserID],
                                         @"comment"  :needsTextV.text
                                         };
            NSDictionary *currentParameter = [NSDictionary dictionaryWithObjectsAndKeys:parameters,@"data", nil];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_ADDCONTRACT_URL];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self startLoadDataPOSTCSRF:urlString withPatameter:currentParameter successBlock:^(NSData *responseData) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *currentDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if([currentDic.allKeys containsObject:@"error"])
                {
                    //            NSDictionary *errorDic    = [currentDic objectForKey:@"error"];
                    //            NSString     *errorString = [errorDic objectForKey:@"message"];
                    [self showAlertWarnningView:@"" andContent:@"您购买的【合同起草】服务剩余数量为0，请先购买相应服务。"];
                }
                else
                {
                    _contractID = currentDic[@"data"][@"_id"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } errorBlock:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
            }];

        }
        return;
    }
    if(buttonIndex == 0)
    {
        //[currentTCV setUserInteractionEnabled:NO];
        isBegain = YES;
        [currentTCV reloadData];
        NSLog(@"heloo ");
        NSString *target    = @"0";
        NSString *role      = @"";
        
        if(thirdContract)
        {
            if([thirdContract.typeValue isEqualToString:@"3"])
            {
                target = thirdContract.contractType;
                if(fourthContract)
                {
                    role = fourthContract.contractType;
                }
            }
            else
            {
                role   = thirdContract.contractType;
            }
        }
        
        NSDictionary *parameters = @{
                                     @"type1"    :parentContract.contractType,
                                     @"type2"    :subContract.contractType,
                                     @"type"     :subContract.contractType,
                                     @"name"     :[[NSString stringWithFormat:@"%@.docx",subContract.typeName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                     @"status"   :@"1",
                                     @"role"     :role,
                                     @"target"   :target,
                                     @"uid"      :[[UserInfoDetail sharedInstance] getUserID],
                                     
                                     };
        NSDictionary *currentParameter = [NSDictionary dictionaryWithObjectsAndKeys:parameters,@"data", nil];
        [self begainAdd:currentParameter];
    }
}

- (void)begainAdd:(NSDictionary *)parameter
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_ADDCONTRACT_URL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *currentDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([currentDic.allKeys containsObject:@"error"])
        {
//            NSDictionary *errorDic    = [currentDic objectForKey:@"error"];
//            NSString     *errorString = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:@"" andContent:@"您购买的【合同起草】服务剩余数量为0，请先购买相应服务。"];
        }
        else
        {
            _contractID = currentDic[@"data"][@"_id"];
            [self performSegueWithIdentifier:@"toAnswerVC" sender:self];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
    }];
}

- (void)needToAnserQuestion
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *parentType   = [detailDicInfo objectForKey:@"type1"];
    NSString *subchileType = [detailDicInfo objectForKey:@"type"];
    parentContract         = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:parentType andKey:@"contractType"] objectAtIndex:0];
    subContract            = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:subchileType andKey:@"contractType"] objectAtIndex:0];
    NSString *roleType     = [detailDicInfo objectForKey:@"role"];
    if(roleType == nil || [roleType isEqualToString:@"0"])
    {
        roleType = @"";
    }
    NSString *targetType   = [detailDicInfo objectForKey:@"target"];
    if(targetType == nil || [targetType isEqualToString:@"0"])
    {
        targetType = @"";
    }

    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CONTRACTQUESTION_URL];
    NSDictionary *getParameter = @{
                                   @"id"     :  [detailDicInfo objectForKey:@"_id"],
                                   @"type"   :  [detailDicInfo objectForKey:@"type"],
                                   @"target" :  targetType,
                                   @"role"   :  roleType
                                   };
    [self startLoadDataGETCSRF:urlString withPatameter:getParameter successBlock:^(NSData *responseData) {
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([infoDic.allKeys containsObject:@"error"])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //NSDictionary *errorDic = [infoDic objectForKey:@"error"];
            [self showAlertWarnningView:@"" andContent:@"您选择的文书，法率网暂时不支持自助生成，请拨打法率网热线电话咨询。"];
            return ;
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            checkInfo = infoDic;
            [self getAnswer];
        }

    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)getAnswer
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,@"contract/get"];
    NSDictionary *parameter = @{
                                @"id":_contractID
                                };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self startLoadDataGETCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",[dic description]) ;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        answerDicForNext = dataDic;
        [self performSegueWithIdentifier:@"toAnswerVC" sender:self];
        
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)toAttrList
{
    [self performSegueWithIdentifier:@"toAttrList" sender:self];
}

- (BOOL)checkInfo
{
    BOOL isValidate = YES;
    NSString *errorInfo;
    if(parentContract == nil)
    {
        errorInfo = @"文书种类不能为空。";
        isValidate = NO;
    }
    else if (subContract == nil)
    {
        errorInfo = @"目录名称不能为空。";
        isValidate = NO;
    }
    else
    {
        NSArray *allChild = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"ContractType" withContent:subContract.contractType  andKey:@"parentID"];
        if(allChild.count >0)
        {
            ContractType *isFourType = [allChild objectAtIndex:0];
            if([isFourType.typeValue isEqualToString:@"3"])
            {
               if(thirdContract == nil)
               {
                   isValidate = NO;
                   errorInfo  = @"合同细分不能为空。";
               }
            }
        }
    }
    if(isValidate)
    {
        return YES;
    }
    else
    {
        [self showAlertWarnningView:@"" andContent:errorInfo];
        return NO;
    }
}

- (void)submitOtherInfo
{
    if(needsTextV.text.length<5 || needsTextV.text.length>500)
    {
        [self showAlertWarnningView:@"" andContent:@"请输入您的需求。长度5-500个字符"];
    }
    else
    {
        [needsTextV resignFirstResponder];
        UIAlertView *currentAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要申请合同起草吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        currentAlert.tag = 9000;
        [currentAlert show];
    }
    
}

- (void)showAnswerQuestion
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"显示问题");
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CONTRACTANQUES_URL];
    NSString *roleString = detailDicInfo[@"role"]!=nil?detailDicInfo[@"role"]:@"";
    NSString *targetString = detailDicInfo[@"target"]!=nil?detailDicInfo[@"target"]:@"";
    if(roleString == nil || [roleString isEqualToString:@"0"])
    {
        roleString = @"";
    }
    //NSString *targetType   = [detailDicInfo objectForKey:@"target"];
    if(targetString == nil || [targetString isEqualToString:@"0"])
    {
        targetString = @"";
    }
    NSDictionary *dicPara = @{
                              @"id":detailDicInfo[@"_id"],
                              @"type":detailDicInfo[@"type"],
                              @"target":targetString,
                              @"role":roleString
                                  
                              };
    NSLog(@"%@",[dicPara description]);
    [self startLoadDataGETCSRF:urlString withPatameter:dicPara successBlock:^(NSData *responseData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",[jsonDic description]);
        if([jsonDic.allKeys containsObject:@"error"])
        {
            [self showAlertWarnningView:@"" andContent:@"合同起草问题查询失败，请联系客服。"];
        }
        else
        {
            questionDicForNext = jsonDic;
            answerDicForNext   = detailDicInfo;
            isShowAnswer = YES;
            [self performSegueWithIdentifier:@"toAnswerVC" sender:self];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlertWarnningView:@"" andContent:@"网络连接错误！"];
    }];
}

#pragma mark - 语音录入功能
- (void)startListenning:(id)sender
{
    [needsTextV resignFirstResponder];
    [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //设置结果数据格式，可设置为json，xml，plain，默认为json。
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [_iflyRecognizerView start];
    
    NSLog(@"start listenning...");
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    needsTextV.text = [NSString stringWithFormat:@"%@%@",needsTextV.text,result];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    [self.view addSubview:_popView];
    
    [_popView setText:@"识别结束"];
    
    NSLog(@"errorCode:%d",[error errorCode]);
}

#pragma mark - Navigation
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, needsTextV.frame.origin) ) {
        if(needsTextV.isFirstResponder)
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(currentViewFrame.origin.x, currentViewFrame.origin.y-170, self.view.frame.size.width, self.view.frame.size.height);
            }];
    }
//    if (!CGRectContainsPoint(aRect, self.confirmPassText.frame.origin) ) {
//        if(self.confirmPassText.isFirstResponder)
//            [UIView animateWithDuration:0.3 animations:^{
//                self.view.frame = CGRectMake(currentViewFrame.origin.x, currentViewFrame.origin.y-140, self.view.frame.size.width, self.view.frame.size.height);
//            }];
//    }
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(currentViewFrame.origin.x, currentViewFrame.origin.y, currentViewFrame.size.width, currentViewFrame.size.height);
    }];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == needsTextV)
    {
        needsString = needsTextV.text;
    }
}

- (void)hideKeyboard
{
    [needsTextV resignFirstResponder];
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toAnswerVC"])
    {
        ZXY_AnswerQuestionVC *answerVC = [segue destinationViewController];
        if(isShowAnswer)
        {
            [answerVC setQuestionInfo:questionDicForNext andAnswer:answerDicForNext];
        }
        else
        {
            [answerVC setQuestionInfo:checkInfo andAnswerD:answerDicForNext andID:_contractID];
        }
    }
    if([segue.identifier isEqualToString:@"toAttrList"])
    {
        ZXY_ContractListVC *list = [segue destinationViewController];
        [list setAttrInfoDic:detailDicInfo];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
