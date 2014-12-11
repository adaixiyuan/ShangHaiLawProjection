//
//  ZXY_LetterAddVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_LetterAddVC.h"
#import "ZXY_LetteAttrCell.h"
#import "ZXY_LetterBtnCell.h"
#import "ZXY_LetterChooseCityCell.h"
#import "ZXY_LetterTextFCell.h"
#import "ZXY_LetterTextVCell.h"
#import "ZXY_CityZoneVC.h"
#import "LawCityEntity.h"
#import "ZXY_LawCircleView.h"
#import "ZXY_WebVC.h"
#import "Definition.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "PopupView.h"
#import "ELCImagePickerHeader.h"
#import "ZXY_NewAuditFileCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZXY_LetterVoiceTextCell.h"

@interface ZXY_LetterAddVC ()<UITextFieldDelegate,UITextViewDelegate,ZXY_ChooseCityDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet UIButton *submitBtn;
    NSMutableArray *allFileArr;
    NSMutableArray *returnArr;
    __weak IBOutlet UITableView *currentTV;
    NSString *currentUserType;
    NSInteger voiceType;
    NSString *nameString;
    NSString *phoneString;
    NSString *representString;
    NSString *codeString;
    NSString *detailString;
    NSString *companyString;
    NSString *descipString;
    NSString *expectString;
    UIToolbar *topBar;
    LawCityEntity *provinceE;
    LawCityEntity *cityE;
    LawCityEntity *streetE;
    NSString *statusString;
    UIActionSheet *picherSheet;
    NSDictionary   *currentSelectAttr;
    NSDictionary   *letterInfo;
    BOOL isDetail;
    BOOL isAddInfo ;
}

@property (nonatomic,weak) UITextField *nameText;
@property (nonatomic,weak) UITextField *phoneText;
@property (nonatomic,weak) UITextField *representText;
@property (nonatomic,weak) UITextField *codeText;
@property (nonatomic,weak) UITextField *detailAddress;
@property (nonatomic,weak) UITextField *companyName;
@property (nonatomic,weak) UITextView  *descipTV;
@property (nonatomic,weak) UITextView  *expectTV;

@end

@implementation ZXY_LetterAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(currentUserType == nil)
    {
        currentUserType = @"CT0001";
    }
    
    if(statusString == nil)
    {
        statusString = @"LS0001";
        isAddInfo = YES;
    }
    if(allFileArr == nil)
    {
        allFileArr = [[NSMutableArray alloc] init];
    }
    
    if(returnArr == nil)
    {
        returnArr  = [[NSMutableArray alloc] init];
    }
    [self initNavi];
    [currentTV setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self registerForKeyboardNotifications];
    topBar = [self toolBarWithRight:@"完成" andLeft:nil withRightBtnSel:@selector(hideKeyBoard) andLeftBtnSel:nil];
    [self initCircle:statusString];
    _popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
    _popView.ParentView = self.view;
    
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;

    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    [self initSegmentItems];
}

- (void)initCircle:(NSString *)status
{
    if(status == nil)
    {
        status = @"LS0001";
        statusString = status;
        isAddInfo = YES;
    }
    
    UIView *circleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70.0f)];
    ZXY_LawCircleView *circle = [[ZXY_LawCircleView alloc] initWithPositionY:15.0f];
    [circle setNumOfCircle:5];
    [circle setCircleInfo:@[@"提交", @"起草", @"确认", @"发送", @"存档"]];
    [circleBackgroundView addSubview:circle];
    UIColor *selectColor;
    NSInteger index;
    if([status isEqualToString:@"LS0001"])
    {
        selectColor = [UIColor colorWithRed:0.0 green:205.0/255.0 blue:1.0 alpha:1.0];
        index = 0;
        [currentTV setTableFooterView:submitBtn];
    }
    else if ([status isEqualToString:@"LS0002"])
    {
        selectColor = [UIColor colorWithRed:72.0/255.0 green:166.0/255.0 blue:230.0/255.0 alpha:1.0];
        [currentTV setTableFooterView:submitBtn];
        index = 1;
    }
    else if ([status isEqualToString:@"LS0003"])
    {
        index = 2;
        selectColor = [UIColor colorWithRed:4.0/255.0 green:203.0/255.0 blue:160.0/255.0 alpha:1.0];
        [submitBtn setTitle:@"确认发送" forState:UIControlStateNormal];
        [submitBtn setTitle:@"确认发送" forState:UIControlStateHighlighted];
        [currentTV setTableFooterView:submitBtn];
        returnArr = [letterInfo objectForKey:@"document"];
    }
    else if ([status isEqualToString:@"LS0004"])
    {
        [submitBtn setEnabled:NO];
        returnArr = [letterInfo objectForKey:@"document"];
        [submitBtn setTitle:@"无法操作" forState:UIControlStateNormal];
        [submitBtn setBackgroundColor:[UIColor lightGrayColor]];
        //[submitBtn setTitle:@"确认发送" forState:UIControlStateHighlighted];
        index = 3;
        selectColor = [UIColor colorWithRed:107.0/255.0 green:211.0/255.0 blue:90.0/255.0 alpha:1.0];
    }
    else
    {
        [submitBtn setEnabled:NO];
        returnArr = [letterInfo objectForKey:@"document"];
        [submitBtn setTitle:@"无法操作" forState:UIControlStateNormal];
        //[submitBtn setTitle:@"确认发送" forState:UIControlStateHighlighted];
        [submitBtn setBackgroundColor:[UIColor lightGrayColor]];
        index = 4;
        selectColor = [UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:88.0/255.0 alpha:1.0];
    }
    [circle setSelectIndex:index];
    [circle setSelectBackColor:selectColor];
    [circleBackgroundView addSubview:circle];
    [currentTV setTableHeaderView:circleBackgroundView];
    
}

- (void)setLetterDetail:(NSDictionary *)letterDic
{
    isDetail= YES;
    letterInfo = letterDic;
    statusString = [letterInfo objectForKey:@"status"];
    descipString = [letterInfo objectForKey:@"problem"];
    currentUserType = [letterInfo objectForKey:@"type"];
    representString = [letterInfo objectForKey:@"represents"];
    companyString   = [letterInfo objectForKey:@"corporate"];
    expectString    = [letterInfo objectForKey:@"expectation"];
    nameString      = [letterInfo objectForKey:@"name"];
    phoneString     = [letterInfo objectForKey:@"phone"];
    NSDictionary *address = [letterInfo objectForKey:@"address"];
    detailString   = [address objectForKey:@"streets"];
    codeString     = [address objectForKey:@"postcode"];
    provinceE      = [self getEntityByID:[[address objectForKey:@"province"]objectForKey:@"id"]];
    streetE          = [self getEntityByID:[[address objectForKey:@"town"]objectForKey:@"id"]];
    cityE          = [self getEntityByID:[[address objectForKey:@"city"]objectForKey:@"id"]];
    if(allFileArr == nil)
    {
        allFileArr = [[NSMutableArray alloc] init];
    }
    NSArray *allFile = [letterInfo objectForKey:@"evidences"];
    for(NSDictionary *fileInfo in allFile)
    {
        NSString *fileName = [fileInfo objectForKey:@"fileName"];
        NSString *fileId   = [fileInfo objectForKey:@"fileId"];
        NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:fileName,@"name",fileId,@"fileId",@"YES",@"isUpload", nil];
        [allFileArr addObject:fileDic];
    }

}

- (LawCityEntity *)getEntityByID:(NSString *)cityID
{
    NSArray *entitys = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:cityID andKey:@"cityID"];
    if(entitys.count > 0)
    {
        return [entitys objectAtIndex:0];
    }
    return nil;
}

- (void)initSegmentItems
{
    UISegmentedControl *segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"企业",@"个人", nil]];
    if([currentUserType isEqualToString:@"CT0001"])
    {
        [segMent setSelectedSegmentIndex:0];
    }
    else
    {
        [segMent setSelectedSegmentIndex:1];
    }
    segMent.frame = CGRectMake(0, 0, 160, 30);
    //UIColor *naviColor = NAVIBARCOLOR;
    [segMent setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [segMent setTintColor:[UIColor blueColor]];
    [segMent addTarget:self action:@selector(chooseCoorOrPer:) forControlEvents:UIControlEventValueChanged];
    if([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])
    {
        //[segMent setEnabled:YES];
        [segMent setUserInteractionEnabled:YES];
    }
    else
    {
        //[segMent setEnabled:NO];
        [segMent setUserInteractionEnabled:NO];
    }
    [self setNaviTitleView:segMent];
    
}

//if ([dicInfo[@"status"] isEqualToString:@"LS0001"]) {
//    cell.statusImage.backgroundColor = [UIColor colorWithRed:0.0 green:205.0/255.0 blue:1.0 alpha:1.0];
//} else if ([dicInfo[@"status"] isEqualToString:@"LS0002"]) {
//    cell.statusImage.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:166.0/255.0 blue:230.0/255.0 alpha:1.0];
//} else if ([dicInfo[@"status"] isEqualToString:@"LS0003"]) {
//    cell.statusImage.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:203.0/255.0 blue:160.0/255.0 alpha:1.0];
//} else if ([dicInfo[@"status"] isEqualToString:@"LS0004"]) {
//    cell.statusImage.backgroundColor = [UIColor colorWithRed:107.0/255.0 green:211.0/255.0 blue:90.0/255.0 alpha:1.0];
//} else if ([dicInfo[@"status"] isEqualToString:@"LS0005"]) {
//    cell.statusImage.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:88.0/255.0 alpha:1.0];
//}


- (void)chooseCoorOrPer:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0)
    {
        currentUserType = @"CT0001";
    }
    else
    {
        currentUserType = @"CT0002";
    }
    [currentTV reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if([currentUserType isEqualToString:@"CT0001"])
        {
            return 8;
        }
        else
        {
            return 7;
        }
    }
    else if (section == 1)
    {
        if([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])
        {
            return allFileArr.count+1;
        }
        else
        {
            return allFileArr.count;
        }
    }
    else
    {
        return returnArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentSection = indexPath.section;
    NSInteger currentRow     = indexPath.row;
    if(currentSection == 0)
    {
        if([currentUserType isEqualToString:@"CT0001"])
        {
            if(currentRow == 0 || currentRow == 4)
            {
                return 79;
            }
            if(currentRow == 6 || currentRow == 7)
            {
                return 128;
            }
            else
            {
                return 49;
            }
        }
        else
        {
            if(currentRow == 3)
            {
                return 79;
            }
            if(currentRow == 5 || currentRow == 6)
            {
                return 128;
            }
            else
            {
                return 49;
            }

        }
    }
    else if (currentSection == 1)
    {
        if(currentRow == allFileArr.count)
        {
            return 52;
        }
        return 38;
    }
    else
    {
        return 38;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentSection = indexPath.section;
    NSInteger currentRow     = indexPath.row;
    //ZXY_LetteAttrCell *attCell = [tableView dequeueReusableCellWithIdentifier:LetterAttrCellID];
    ZXY_LetterBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:LetterBtnCellID];
    ZXY_LetterChooseCityCell *chooseCityCell = [tableView dequeueReusableCellWithIdentifier:LetterChooseCityCellID];
    ZXY_LetterTextFCell *textFCell = [tableView dequeueReusableCellWithIdentifier:LetterTextFCellID];
    textFCell.valueLbl.text = @"";
    ZXY_LetterTextVCell *textVCell = [tableView dequeueReusableCellWithIdentifier:LetterTextVCell];
    ZXY_LetterVoiceTextCell *voiceTextCell = [tableView dequeueReusableCellWithIdentifier:LetterVoiceTextCellID];
    if(currentSection == 0)
    {
        if([currentUserType isEqualToString:@"CT0001"])
        {
            if(currentRow == 0)
            {
                voiceTextCell.titleLbl.text = @"収函企业名称";
                self.companyName = voiceTextCell.valueLbl;
                self.companyName.delegate = self;
                if(!([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])){
                    [voiceTextCell.voiceBtn setHidden:YES];
                }
//                UIToolbar *companyTop = [self toolBarWithRight:@"完成" andLeft:@"语音输入" withRightBtnSel:@selector(hideKeyBoard) andLeftBtnSel:@selector(startListenning:)];
//                [self.companyName setInputAccessoryView:companyTop];
                voiceTextCell.currentBlock = ^()
                {
                    voiceType = 3;
                    [self startListenning:nil];
                };
                [self initCircle:statusString];
                if(companyString)
                {
                    
                    voiceTextCell.valueLbl.text = [NSString stringWithFormat:@"%@",companyString];
                }
                return voiceTextCell;
            }
            
            else if(currentRow == 1)
            {
                textFCell.titleLbl.text = @"法定代表人或负责人";
                self.representText = textFCell.valueLbl;
                self.representText.delegate = self;
                [self.representText setInputAccessoryView:topBar];
                if(representString)
                {
                    textFCell.valueLbl.text = [NSString stringWithFormat:@"%@",representString];
                }
                return textFCell;
            }

            
            else if(currentRow == 2)
            {
                textFCell.titleLbl.text = @"收函对象电话";
                self.phoneText = textFCell.valueLbl;
                self.phoneText.delegate = self;
                [self.phoneText setInputAccessoryView:topBar];
                if(phoneString)
                {
                    textFCell.valueLbl.text = [NSString stringWithFormat:@"%@",phoneString];
                }
                return textFCell;
            }
            
            else if(currentRow == 3)
            {
                if(provinceE)
                {
                    chooseCityCell.valueLbl.text = [NSString stringWithFormat:@"%@  %@  %@",provinceE.name,cityE.name,streetE.name];
                }
                return chooseCityCell;
            }
            
            else if(currentRow == 4)
            {
                voiceTextCell.titleLbl.text = @"详细地址";
                self.detailAddress = voiceTextCell.valueLbl;
                self.detailAddress.delegate = self;
                [self.detailAddress setInputAccessoryView:topBar];
                if(!([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])){
                    [voiceTextCell.voiceBtn setHidden:YES];
                }
//                UIToolbar *companyTop = [self toolBarWithRight:@"完成" andLeft:@"语音输入" withRightBtnSel:@selector(hideKeyBoard) andLeftBtnSel:@selector(startListenning:)];
//                [self.detailAddress setInputAccessoryView:companyTop];
                voiceTextCell.currentBlock = ^()
                {
                    voiceType = 4;
                    [self startListenning:nil];
                };

                if(detailString)
                {
                    voiceTextCell.valueLbl.text = [NSString stringWithFormat:@"%@",detailString];
                }
                return voiceTextCell;
            }
            
            else if(currentRow == 5)
            {
                textFCell.titleLbl.text = @"邮政编码";
                self.codeText = textFCell.valueLbl;
                self.codeText.delegate = self;
                [self.codeText setInputAccessoryView:topBar];
                if(codeString)
                {
                    textFCell.valueLbl.text = [NSString stringWithFormat:@"%@",codeString];
                }
                return textFCell;
            }
            
            else if (currentRow == 6)
            {
                textVCell.titleLbl.text =@"问题描述(500字以内)";
                self.descipTV = textVCell.contentTV;
                self.descipTV.delegate = self;
                [self.descipTV setInputAccessoryView:topBar];
                textVCell.btnBlock = ^(){
                    NSLog(@"问题描述");
                    voiceType = 1;
                    [self startListenning:nil];
                };
                if(!([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])){
                    [textVCell.voiceBtn setHidden:YES];
                }
                if(descipString)
                {
                    textVCell.contentTV.text = [NSString stringWithFormat:@"%@",descipString];
                }
                return textVCell;
            }
            else
            {
                textVCell.titleLbl.text =@"您的期望(500字以内)";
                textVCell.btnBlock = ^(){
                    NSLog(@"您的其挖个");
                    voiceType = 2;
                    [self startListenning:nil];
                };
                if(!([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])){
                    [textVCell.voiceBtn setHidden:YES];
                }
                self.expectTV = textVCell.contentTV;
                self.expectTV.delegate = self;
                [self.expectTV setInputAccessoryView:topBar];
                if(expectString)
                {
                    textVCell.contentTV.text = [NSString stringWithFormat:@"%@",expectString];
                }
                return textVCell;
            }


        }
        else
        {
            if(currentRow == 0)
            {
                textFCell.titleLbl.text = @"收函人姓名";
                self.nameText = textFCell.valueLbl;
                self.nameText.delegate = self;
                [self.nameText setInputAccessoryView:topBar];
                if(nameString)
                {
                    textFCell.valueLbl.text = [NSString stringWithFormat:@"%@",nameString];
                }
                return textFCell;
            }
            else if(currentRow == 1)
            {
                textFCell.titleLbl.text = @"收函对象电话";
                self.phoneText = textFCell.valueLbl;
                self.phoneText.delegate = self;
                [self.phoneText setInputAccessoryView:topBar];
                if(phoneString)
                {
                    textFCell.valueLbl.text = [NSString stringWithFormat:@"%@",phoneString];
                }
                return textFCell;
            }
            
            else if(currentRow == 2)
            {
                if(provinceE)
                {
                    chooseCityCell.valueLbl.text = [NSString stringWithFormat:@"%@  %@  %@",provinceE.name,cityE.name,streetE.name];
                }

                return chooseCityCell;
            }
            
            else if(currentRow == 3)
            {
                voiceTextCell.titleLbl.text = @"详细地址";
                self.detailAddress = voiceTextCell.valueLbl;
                self.detailAddress.delegate = self;
                [self.detailAddress setInputAccessoryView:topBar];
                if(!([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])){
                    [voiceTextCell.voiceBtn setHidden:YES];
                }
//                UIToolbar *companyTop = [self toolBarWithRight:@"完成" andLeft:@"语音输入" withRightBtnSel:@selector(hideKeyBoard) andLeftBtnSel:@selector(startListenning:)];
//                [self.detailAddress setInputAccessoryView:companyTop];
                voiceTextCell.currentBlock = ^()
                {
                    voiceType = 4;
                    [self startListenning:nil];
                };

                if(detailString)
                {
                    voiceTextCell.valueLbl.text = [NSString stringWithFormat:@"%@",detailString];
                }
                return voiceTextCell;
            }
            
            else if(currentRow == 4)
            {
                textFCell.titleLbl.text = @"邮政编码";
                self.codeText = textFCell.valueLbl;
                self.codeText.delegate = self;
                [self.codeText setInputAccessoryView:topBar];
                if(codeString)
                {
                    textFCell.valueLbl.text = [NSString stringWithFormat:@"%@",codeString];
                }
                return textFCell;
            }
            
            else if (currentRow == 5)
            {
                textVCell.titleLbl.text =@"问题描述(500字以内)";
                self.descipTV = textVCell.contentTV;
                self.descipTV.delegate = self;
                [self.descipTV setInputAccessoryView:topBar];
                textVCell.btnBlock = ^(){
                    NSLog(@"问题描述");
                    voiceType = 1;
                    [self startListenning:nil];
                };
                if(!([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])){
                    [textVCell.voiceBtn setHidden:YES];
                }
                if(descipString)
                {
                    textVCell.contentTV.text = [NSString stringWithFormat:@"%@",descipString];
                }
                return textVCell;
            }
            else
            {
                textVCell.titleLbl.text =@"您的期望(500字以内)";
                textVCell.btnBlock = ^(){
                    NSLog(@"您的期望");
                    voiceType = 2;
                    [self startListenning:nil];
                };
                if(!([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])){
                    [textVCell.voiceBtn setHidden:YES];
                }
                self.expectTV = textVCell.contentTV;
                self.expectTV.delegate = self;
                [self.expectTV setInputAccessoryView:topBar];
                if(expectString)
                {
                    textVCell.contentTV.text = [NSString stringWithFormat:@"%@",expectString];
                }
                return textVCell;
            }
            
        }
    }
    else if (currentSection == 1)
    {
        if(currentRow == allFileArr.count)
        {
            return btnCell;
        }
        else
        {
            NSDictionary *imageInfo = [allFileArr objectAtIndex:currentRow];
            ZXY_NewAuditFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NewAuditFileCellID];
            cell.indexLbl.text         = [NSString stringWithFormat:@"%d",indexPath.row+1];
            cell.fileLbl.text          = [imageInfo objectForKey:@"name"];
            if([imageInfo[@"isUpload"] isEqualToString:@"NO"])
            {
                cell.statusLblw.text = @"等待";
            }
            else if ([imageInfo[@"isUpload"] isEqualToString:@"YES"])
            {
                cell.statusLblw.text = @"操作";
            }
            else
            {
                cell.statusLblw.text = @"上传中";
            }
            return cell;
            
        }
        
    }
    else
    {
        NSDictionary *imageInfo = [returnArr objectAtIndex:currentRow];
        ZXY_NewAuditFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NewAuditFileCellID];
        cell.indexLbl.text         = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.fileLbl.text          = [imageInfo objectForKey:@"fileName"];
//        if([imageInfo[@"isUpload"] isEqualToString:@"NO"])
//        {
//            cell.statusLblw.text = @"等待";
//        }
//        else if ([imageInfo[@"isUpload"] isEqualToString:@"YES"])
//        {
//            cell.statusLblw.text = @"完成";
//        }
//        else
//        {
//            cell.statusLblw.text = @"上传中";
//        }
        return cell;
        //return attCell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section ==2)
    {
        if(returnArr.count == 0)
        {
            return 1;
        }
        return 30;
    }
    else
    {
        return 15;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return @"证据材料";
    }
     if(section == 2)
     {
         if(returnArr.count == 0)
         {
             return nil;
         }

         return @"律师函草稿";
     }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentSection = indexPath.section;
    NSInteger currentRow     = indexPath.row;
    if(currentSection == 0)
    {
        if([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])
        {
            if([currentUserType isEqualToString: @"CT0001"])
            {
                if(currentRow == 3)
                {
                    [self getCity];
                }
            }
            else
            {
                if(currentRow == 2)
                {
                    [self getCity];
                }
            }
        }
        else
        {
            return;
        }
    }
    
    if(currentSection == 1&&currentRow == allFileArr.count)
    {
        if([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"]){
            [self chooseImage];
        }
        else
        {
            return;
        }
    }

    
    if(currentSection == 1 &&currentRow <allFileArr.count)
    {
        NSDictionary *currentDic = [allFileArr objectAtIndex:currentRow];
        if([currentDic[@"isUpload"] isEqualToString:@"YES"])
        {
            currentSelectAttr = currentDic;
            if([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])
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
    else if(currentSection == 2)
    {
        if(![statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])
        {
            NSDictionary *currentDic = [returnArr objectAtIndex:currentRow];
            NSString     *fileID     = [currentDic objectForKey:@"fileId"];
            NSString     *fileName   = [currentDic objectForKey:@"fileName"];
            NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
            ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
            webVC.title = fileName;
            [webVC setDownLoadURL:stringURL];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }

}

- (void)getCity {
    UIStoryboard *citySB = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
    ZXY_CityZoneVC *cityVC = [citySB instantiateViewControllerWithIdentifier:@"cityVC"];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)userChooseCityDelegate:(LawCityEntity *)provinceEntity andCityEntity:(LawCityEntity *)cityEntity withZoneEntity:(LawCityEntity *)zoneEntity
{
    provinceE = provinceEntity;
    cityE     = cityEntity;
    streetE   = zoneEntity;
    [currentTV reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])
    {
        
        if(textField == self.companyName)
        {
            voiceType = 3;
        }
        else if (textField == self.detailAddress)
        {
            voiceType = 4;
        }
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([statusString isEqualToString:@"LS0001"]||[statusString isEqualToString:@"LS0002"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.nameText)
    {
        nameString = [NSString stringWithFormat:@"%@",self.nameText.text ];
    }
    
    if(textField == self.representText)
    {
        representString = [NSString stringWithFormat:@"%@",self.representText.text ];
    }
    
    if(textField == self.phoneText)
    {
        phoneString = [NSString stringWithFormat:@"%@",self.phoneText.text];
    }
    
    if(textField == self.companyName)
    {
        companyString = [NSString stringWithFormat:@"%@",self.companyName.text];
    }
    
    if(textField == self.detailAddress)
    {
        detailString = [NSString stringWithFormat:@"%@",self.detailAddress.text];
    }
    
    if(textField == self.codeText)
    {
        codeString = [NSString stringWithFormat:@"%@",self.codeText.text];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == self.descipTV)
    {
        descipString = [NSString stringWithFormat:@"%@",self.descipTV.text];
    }
    
    if(textView == self.expectTV)
    {
        expectString = [NSString stringWithFormat:@"%@",self.expectTV.text];
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)removeNoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    currentTV.contentInset = contentInsets;
    currentTV.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.nameText.frame.origin) ) {
//        if([self.nameText isFirstResponder])
//        [currentTV scrollRectToVisible:self.nameText.frame animated:YES];
//    }
//    if (!CGRectContainsPoint(aRect, self.representText.frame.origin) ) {
//        if([self.representText isFirstResponder])
//        [currentTV scrollRectToVisible:self.representText.frame animated:YES];
//    }
//    if (!CGRectContainsPoint(aRect, self.companyName.frame.origin) ) {
//        if([self.companyName isFirstResponder])
//        [currentTV scrollRectToVisible:self.companyName.frame animated:YES];
//    }
//    if (!CGRectContainsPoint(aRect, self.phoneText.frame.origin) ) {
//        if([self.phoneText isFirstResponder])
//        [currentTV scrollRectToVisible:self.phoneText.frame animated:YES];
//    }
//    if (!CGRectContainsPoint(aRect, self.codeText.frame.origin) ) {
//        if([self.codeText isFirstResponder])
//        [currentTV scrollRectToVisible:self.codeText.frame animated:YES];
//    }
//    if (!CGRectContainsPoint(aRect, self.detailAddress.frame.origin) ) {
//        if([self.detailAddress isFirstResponder])
//        [currentTV scrollRectToVisible:self.detailAddress.frame animated:YES];
//    }
//    if (!CGRectContainsPoint(aRect, self.descipTV.frame.origin) ) {
//        if([self.descipTV isFirstResponder])
//        [currentTV scrollRectToVisible:self.descipTV.frame animated:YES];
//    }
//    if (!CGRectContainsPoint(aRect, self.expectTV.frame.origin) ) {
//        if([self.expectTV isFirstResponder])
//        [currentTV scrollRectToVisible:[currentTV convertRect:self.expectTV.frame toView:currentTV] animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    currentTV.contentInset = contentInsets;
    currentTV.scrollIndicatorInsets = contentInsets;
}

- (void)hideKeyBoard
{
    [self.nameText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.representText resignFirstResponder];
    [self.codeText resignFirstResponder];
    [self.companyName resignFirstResponder];
    [self.detailAddress resignFirstResponder];
    [self.descipTV resignFirstResponder];
    [self.expectTV resignFirstResponder];
}

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
            [currentTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
                //                NSDictionary *imageInfo = @{
                //                                            @"name"    :imageName,
                //                                            @"data"    :image,
                //                                            @"isUpload":@"NO"
                //                                            };
                NSMutableDictionary *imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageName,@"name",image,@"data",@"NO",@"isUpload", nil];
                [allFileArr addObject:imageInfo];
            }
        }
    }
    //[currentTable reloadData];
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
                    [currentTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                });
                
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                [self startUploadFileData:imageData withFileName:fileString andProgress:nil completeSuccess:^(NSDictionary *responseData) {
                    NSArray *dataDic = [responseData objectForKey:@"data"];
                    NSString     *fileId  = [[dataDic objectAtIndex:0] objectForKey:@"_id"];
                    [fileInfo setObject:fileId forKey:@"fileId"];
                    [fileInfo setObject:@"YES" forKey:@"isUpload"];
                    [currentTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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

- (IBAction)submitAction:(id)sender {
    
    if([currentUserType isEqualToString:@"CT0001"]&&(companyString.length>20||companyString.length<2))
    {
        [self showAlertWarnningView:@"提示" andContent:@"请输入正确的企业名称。长度2-50个字符。"];
        return;
    }
    
    if([currentUserType isEqualToString:@"CT0001"]&&(representString.length>20||representString.length<2))
    {
        [self showAlertWarnningView:@"提示" andContent:@"请输入正确的法定代表人或负责人姓名。"];
        return;
    }
    
    if([currentUserType isEqualToString:@"CT0002"]&&(nameString.length>20||nameString.length<2))
    {
        [self showAlertWarnningView:@"提示" andContent:@"请输入正确的收函人姓名。"];
        return;
    }
    
    if(![self isUserInputNum:phoneString]||phoneString.length<6)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请输入正确的电话号码。"];
        return;
    }
    
    if(!provinceE)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请选择完整的省、市、区。"];
        return;
    }
    
    if(detailString.length<5||detailString.length>120)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请输入正确的详细地址。长度5-120个字符。"];
        return;
    }

    
    if(!(codeString.length == 6 && [self isUserInputNum:codeString]))
    {
        [self showAlertWarnningView:@"提示" andContent:@"请输入正确的邮政编码。"];
        return;
    }
    
    
    if(descipString.length<5 || descipString.length>500)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请输入问题描述。长度5-500个字符。"];
        return;
    }
    
    if(expectString.length<5 || expectString.length > 500)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请输入您的期望。长度5-500个字符。"];
        return;
    }
    
    if(allFileArr.count == 0)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请上传证据材料。最多可上传10个文件。"];
        return;
    }

    for(NSDictionary *imageInfo in allFileArr)
    {
        NSString *statusStrings  = imageInfo[@"isUpload"];
        if(![statusStrings isEqualToString:@"YES"])
        {
            [self showAlertWarnningView:@"提示" andContent:@"还有没有上传的附件"];
            return;
        }
    }
    if([statusString isEqualToString:@"LS0001"])
    {
        if(isAddInfo)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定消费签发律师函服务吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag = 7000;
            [alertView show];

        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定更新签发律师函的信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag = 7000;
            [alertView show];
        }
    }
    else if ([statusString isEqualToString:@"LS0002"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定更新签发律师函的信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 7001;
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定发送吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 7002;
        [alertView show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 7000 || alertView.tag ==7001)
    {
        if(buttonIndex == 1)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_LETTERADD_URL];
            if(isDetail)
            {
                stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_LETTERUPDATE_URL];
            }
            NSDictionary *parameter = [self parameterForURL];
            if(isDetail)
            {
                [self startLoadDataPutCSRF:stringURL withParameter:parameter successBlock:^(NSData *responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if([dic.allKeys containsObject:@"error"])
                    {
                        [self showAlertWarnningView:@"提示 " andContent:@"您购买的【签发律师函】服务剩余数量为0，请先购买相应服务。"];
                        return ;
                    }
                    else
                    {
                        //[self showAlertWarnningView:@"" andContent:@""];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                } errorBlock:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                
            }
            else
            {
                [self startLoadDataPOSTCSRF:stringURL withPatameter:parameter successBlock:^(NSData *responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if([dic.allKeys containsObject:@"error"])
                    {
                        [self showAlertWarnningView:@"提示 " andContent:@"您购买的【签发律师函】服务剩余数量为0，请先购买相应服务。"];
                        return ;
                    }
                    else
                    {
                        //[self showAlertWarnningView:@"" andContent:@"购买成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } errorBlock:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];;
                }];
            }
            
        }
    }
    else
    {
        NSString *stringURL = [NSString stringWithFormat:@"%@letter/confirm",API_HOST_URL];
        NSDictionary *parameter = @{
                                    @"id":[letterInfo objectForKey:@"_id"]
                                    };
        [self startLoadDataPutCSRF:stringURL withParameter:parameter successBlock:^(NSData *responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([dic.allKeys containsObject:@"error"])
            {
                [self showAlertWarnningView:@"提示 " andContent:@"确认失败，请联系客服。"];
                return ;
            }
            else
            {
                [self showAlertWarnningView:@"" andContent:@"确认成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
;
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];;
        }];
    }
}


- (NSDictionary *)parameterForURL
{
        NSMutableArray *paraArr = [[NSMutableArray alloc] init];
    for(NSDictionary *fileInfo in allFileArr)
    {
        NSDictionary *paraFile = [NSDictionary dictionaryWithObjectsAndKeys:[fileInfo objectForKey:@"fileId"],@"fileId",[fileInfo objectForKey:@"name"], @"fileName",nil];
        [paraArr addObject:paraFile];
    }
    NSString *uid = [NSString stringWithFormat:@"%@",[[UserInfoDetail sharedInstance] getUserID] ];
    NSDictionary *cityDic     = [NSDictionary dictionaryWithObjectsAndKeys:cityE.name,@"name",cityE.cityID,@"id", nil] ;
    NSDictionary *provinceDic = [NSDictionary dictionaryWithObjectsAndKeys:provinceE.name,@"name",provinceE.cityID,@"id", nil];
    NSDictionary *townDic = [NSDictionary dictionaryWithObjectsAndKeys:streetE.name,@"name",streetE.cityID,@"id", nil];
    NSDictionary *areaDics     = [NSDictionary dictionaryWithObjectsAndKeys:provinceDic,@"province",cityDic,@"city",townDic,@"town",codeString,@"postcode",detailString ,@"streets",nil];
    if(nameString == nil)
    {
        nameString = @"";
    }
    if(representString == nil)
    {
        representString = @"";
    }
    if(companyString == nil)
    {
        companyString = @"";
    }
    NSDictionary *dataParameter = @{
                                    @"type":currentUserType,
                                    @"corporate":companyString,
                                    @"represents":representString,
                                    @"name":nameString,
                                    @"phone":phoneString,
                                    
                                    @"address":areaDics,
                                    @"expectation":expectString,
                                    @"problem":descipString,
                                    @"evidences":paraArr,
                                    
                                    };
    NSDictionary *returnDic = @{
                                    @"data":dataParameter,
                                    @"uid":uid
                                    };
    if(isDetail)
    {
        NSDictionary *filterDic  = @{
                                     @"id":[letterInfo objectForKey:@"_id"]
                                     };
        returnDic          = @{
                                    @"data":dataParameter,
                                    @"filter":filterDic
                                    };
    }
    
    return returnDic;
}

- (BOOL)isUserInputNum:(NSString *)checkString
{
    BOOL isNum = YES;
    NSCharacterSet *checkSet = [NSCharacterSet characterSetWithCharactersInString:ZXY_VALUES_NUMBER];
    int i = 0;
    while (i<checkString.length) {
        
        NSString *rangeString = [checkString substringWithRange:NSMakeRange(i, 1)];
        NSRange  subRange     = [rangeString rangeOfCharacterFromSet:checkSet];
        if(subRange.length == 0)
        {
            isNum = NO;
            break;
        }
        i++;
    }
    return isNum;
}


- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)startListenning:(id)sender
{
    [self.descipTV resignFirstResponder];
    [self.companyName resignFirstResponder];
    [self.detailAddress resignFirstResponder];
    [self.nameText resignFirstResponder];
    [self.codeText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    
    [self.expectTV resignFirstResponder];
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
    //needsText.text = [NSString stringWithFormat:@"%@%@",needsText.text,result];
    if(voiceType == 1)
    {
        self.descipTV.text = [NSString stringWithFormat:@"%@%@",self.descipTV.text,result];
        descipString = self.descipTV.text;
    }
    else if(voiceType == 2)
    {
       self.expectTV.text = [NSString stringWithFormat:@"%@%@",self.expectTV.text,result];
        expectString = self.expectTV.text;
    }
    else if (voiceType == 3)
    {
        self.companyName.text = [NSString stringWithFormat:@"%@%@",self.companyName.text,result];
        companyString = self.companyName.text;
    }
    else
    {
        self.detailAddress.text = [NSString stringWithFormat:@"%@%@",self.detailAddress.text,result];
        detailString  = self.detailAddress.text;
    }
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


- (void)dealloc
{
    [self removeNoti];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
