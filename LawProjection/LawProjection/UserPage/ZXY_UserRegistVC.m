//
//  ZXY_UserRegistVC.m
//  LawProjection
//
//  Created by developer on 14-10-9.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserRegistVC.h"
#import "UserCell/ZXY_UserRegistCellHeader.h"
#import "ZXY_UserProtocalWebVC.h"
#import "ZXYProvider.h"
#import "LawCityEntity.h"
#import "ZXY_CityZoneVC.h"
#import <AFNetworking/AFNetworking.h>
#import "ZXY_SystemRelative.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZXY_CheckPhoneNumVC.h"

@interface ZXY_UserRegistVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ZXY_UserCheckNumDelegate,ZXY_UserProtocalDelegate,ZXY_ChooseCityDelegate,ZXY_UserRegistSexChooseDelegate>
{
    BOOL isPersonRegist;
    BOOL isUserReadProtocal;
    __weak IBOutlet UITableView *currentTableV;
    //************************//
    NSArray *firstRowOfCity;
    NSArray *allCityArr;
    //************************//
    
    UIToolbar *hideKeyBoardTop;
    UIButton  *checkNumPhoneBtn;
    //*************************//
    NSInteger sexInt;
    NSString *customerType;
    CGRect currentViewFrame;
    NSDictionary *parameters;
}
@property(nonatomic,strong) UITextField *phoneText;
@property(nonatomic,strong) UITextField *nameText;
@property(nonatomic,strong) UITextField *coorpText;
@property(nonatomic,strong) UITextField *cityText;
@property(nonatomic,strong) UITextField *passText;
@property(nonatomic,strong) UITextField *confirmPassText;
@end

@implementation ZXY_UserRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initToolBar];
    [self initData];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    currentViewFrame = self.view.frame;
    [super viewDidAppear:animated];
}

- (void)setNilBeforeReload
{
    self.phoneText.text = @"";
    self.nameText.text  = @"";
    self.coorpText.text = @"";
    self.cityText.text  = @"";
    self.passText.text  = @"";
    self.confirmPassText.text = @"";
    isUserReadProtocal = NO;
}


// !!!:键盘控制
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
    if (!CGRectContainsPoint(aRect, self.passText.frame.origin) ) {
        if(self.passText.isFirstResponder)
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(currentViewFrame.origin.x, currentViewFrame.origin.y-100, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    if (!CGRectContainsPoint(aRect, self.confirmPassText.frame.origin) ) {
        if(self.confirmPassText.isFirstResponder)
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(currentViewFrame.origin.x, currentViewFrame.origin.y-140, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(currentViewFrame.origin.x, currentViewFrame.origin.y, currentViewFrame.size.width, currentViewFrame.size.height);
    }];
}

#pragma mark - 实例化方法
- (void)initNavi
{
    [self initSegmentItems];
    [self setLeftNaviItem:@"back_arrow"];
}

- (void)initData
{
    isPersonRegist = NO;
    customerType = @"CT0001";
    sexInt = 1;
    isUserReadProtocal = NO;
    firstRowOfCity = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity" withContent:@"root" andKey:@"parent" orderBy:@"sort" isDes:YES];
}

- (void)initToolBar
{
    hideKeyBoardTop = [self toolBarWithRight:@"完成" andLeft:@"" withRightBtnSel:@selector(toolBarRightAction) andLeftBtnSel:nil];
}

- (void)toolBarRightAction
{
    [self.nameText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.coorpText resignFirstResponder];
    [self.passText resignFirstResponder];
    [self.confirmPassText resignFirstResponder];
    
}

- (void)initSegmentItems
{
    UISegmentedControl *segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"企业",@"个人", nil]];
    [segMent setSelectedSegmentIndex:0];
    segMent.frame = CGRectMake(0, 0, 160, 30);
    UIColor *naviColor = NAVIBARCOLOR;
    [segMent setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:naviColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [segMent setTintColor:[UIColor whiteColor]];
    [segMent addTarget:self action:@selector(chooseCoorOrPer:) forControlEvents:UIControlEventValueChanged];
    [self setNaviTitleView:segMent];

}


#pragma mark - table代理数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isPersonRegist)
    {
        return 7;
    }
    else
    {
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow = indexPath.row;
    ZXY_UserTabListTVCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"hello"];
    if(textCell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ZXY_UserTabListTVCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ZXY_UserTabListTVCell class]])
            {
                textCell = (ZXY_UserTabListTVCell *)oneObject;
            }
        }
    }
    ZXY_UserTabListBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:userTabListBtnCellID];
    ZXY_UserRegistProtocalCell *protocalCell = [tableView dequeueReusableCellWithIdentifier:userRegistProtocalCellID];
    ZXY_UserRegistTabWithSexCell *sexCell = [tableView dequeueReusableCellWithIdentifier:UserRegistTabWithSexCellID];
    checkNumPhoneBtn = btnCell.registBtn;
    protocalCell.delegate = self;
    btnCell.delegate      = self;
    sexCell.delegate = self;
    if(currentRow == 0)
    {
        textCell.textInput.placeholder = @"输入手机号码(登录账号)";
        self.phoneText = textCell.textInput;
        [self.phoneText setInputAccessoryView:hideKeyBoardTop];
        self.phoneText.delegate = self;
        return textCell;
    }
    else if (currentRow == 1)
    {
        if(isPersonRegist)
        {
            sexCell.nameText.placeholder = @"输入姓名";
            
            self.nameText = sexCell.nameText;
            [self.nameText setInputAccessoryView:hideKeyBoardTop];
            return sexCell;
        }
        else
        {
            textCell.textInput.placeholder = @"输入企业名称";
            self.coorpText = textCell.textInput;
            textCell.textBackImage.image   = [UIImage imageNamed:@"user_textIn"];
            [self.coorpText setInputAccessoryView:hideKeyBoardTop];
            return textCell;
        }
        
    }
    else if (currentRow == 2)
    {
        if(isPersonRegist)
        {
            textCell.textInput.placeholder = @"选择所在地";
            self.cityText = textCell.textInput;
            [textCell.textInput setSecureTextEntry:NO];
            self.cityText.delegate = self;
            textCell.textBackImage.image   = [UIImage imageNamed:@"textInWithArr"];
            return textCell;
        }
        else
        {
            sexCell.nameText.placeholder = @"输入联系人姓名";
            self.nameText = sexCell.nameText;
            [self.nameText setInputAccessoryView:hideKeyBoardTop];
            return sexCell;
        }
        
    }
    else if(currentRow == 3)
    {
        if(isPersonRegist)
        {
            textCell.textBackImage.image   = [UIImage imageNamed:@"user_textIn"];
            textCell.textInput.placeholder = @"请输入密码";
            self.passText = textCell.textInput;
            [self.passText setInputAccessoryView:hideKeyBoardTop];
            [textCell.textInput setSecureTextEntry:YES];
            return textCell;
        }
        else
        {
            textCell.textInput.placeholder = @"选择所在地";
            [textCell.textInput setSecureTextEntry:NO];
            textCell.textBackImage.image   = [UIImage imageNamed:@"textInWithArr"];
            self.cityText = textCell.textInput;
            self.cityText.delegate = self;
            return textCell;
        }
    }
    else if (currentRow == 4)
    {
        if(isPersonRegist)
        {
            textCell.textInput.placeholder = @"请再次输入密码";
            self.confirmPassText = textCell.textInput;
            [self.confirmPassText setInputAccessoryView:hideKeyBoardTop];
            [textCell.textInput setSecureTextEntry:YES];
            return textCell;

        }
        else
        {
            textCell.textInput.placeholder = @"请输入密码";
            textCell.textBackImage.image   = [UIImage imageNamed:@"user_textIn"];
            self.passText = textCell.textInput;
            [self.passText setInputAccessoryView:hideKeyBoardTop];
            [textCell.textInput setSecureTextEntry:YES];
            return textCell;

        }
    }
    else if(currentRow == 5)
    {
        if(isPersonRegist)
        {
            return protocalCell;
        }
        else
        {
            textCell.textInput.placeholder = @"请再次输入密码";
            self.confirmPassText = textCell.textInput;
            [self.confirmPassText setInputAccessoryView:hideKeyBoardTop];
            [textCell.textInput setSecureTextEntry:YES];
            return textCell;
        }
    }
    else if (currentRow == 6)
    {
        if(isPersonRegist)
        {
            if(isUserReadProtocal)
            {
                [checkNumPhoneBtn setEnabled:YES];
            }
            else
            {
                [checkNumPhoneBtn setEnabled:NO];
            }

            return btnCell;
        }
        else
        {
            
            return protocalCell;
        }
    }
    else
    {
        if(isUserReadProtocal)
        {
            [checkNumPhoneBtn setEnabled:YES];
        }
        else
        {
            [checkNumPhoneBtn setEnabled:NO];
        }

        return btnCell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow = indexPath.row;
    if(currentRow == 5)
    {
        if(isPersonRegist)
        {
            return 36;
        }
        else
        {
            return 52;
        }
    }
    else if (currentRow == 6)
    {
        if(isPersonRegist)
        {
            return 52;
        }
        else
        {
            return 36;
        }
    }
    else
    {
        return 53;
    }
    
}


#pragma mark - 表格代理方法
- (void)userChooseProtocal
{
    if(isUserReadProtocal)
    {
        isUserReadProtocal = NO;
        [checkNumPhoneBtn setEnabled:NO];
    }
    else
    {
        isUserReadProtocal = YES;
        [checkNumPhoneBtn setEnabled:YES];
    }
}

- (void)userReviewProtocal
{
    [self performSegueWithIdentifier:@"toProtocalWebVC" sender:self];
}

- (BOOL)checkUserInput
{
    BOOL isUserInputValide = YES;
    if(isPersonRegist)
    {
        if(self.phoneText.text.length != 11)
        {
            isUserInputValide = NO;
            [self showAlertWarnningView:@"" andContent:@"请输入正确的手机号码。"];
        }

        else if(self.nameText.text.length == 0)
        {
            isUserInputValide = NO;
            [self showAlertWarnningView:@"" andContent:@"请输入正确的姓名。"];
        }
        else if (self.cityText.text.length == 0)
        {
            isUserInputValide = NO;
            [self showAlertWarnningView:@"" andContent:@"请选择完整的省、市。"];
        }

        else if(![self isPassValidate])
        {
            isUserInputValide = NO;
        }
    }
    else
    {
        if(self.phoneText.text.length != 11)
        {
            isUserInputValide = NO;
            [self showAlertWarnningView:@"" andContent:@"请输入正确的手机号码。"];
        }
        else if(self.coorpText.text.length <2 || self.coorpText.text.length>50)
        {
            isUserInputValide = NO;
            [self showAlertWarnningView:@"" andContent:@"请输入正确的企业名称。长度2-50个字符。"];
        }
        else if(self.nameText.text.length == 0)
        {
            isUserInputValide = NO;
            [self showAlertWarnningView:@"" andContent:@"请输入正确的联系人。"];
        }
        else if (self.cityText.text.length == 0)
        {
            isUserInputValide = NO;
            [self showAlertWarnningView:@"" andContent:@"请选择完整的省、市。"];
        }
        else if (![self isPassValidate])
        {
            isUserInputValide = NO;
        }
    }
    return isUserInputValide;
}

- (BOOL)isPassValidate
{
    BOOL isPassValidate = YES;
    if(self.passText.text.length < 6||self.passText.text.length>20)
    {
        isPassValidate = NO;
        [self showAlertWarnningView:@"" andContent:@"密码为6-20个字符，应同时包含数字和字母。"];
    }
    else if(![self.passText.text isEqualToString:self.confirmPassText.text])
    {
        isPassValidate = NO;
        [self showAlertWarnningView:@"" andContent:@"两次输入的密码不一致"];
    }
    else if(![self isPassValidate:self.passText.text])
    {
        isPassValidate = NO;
    }
    else
    {
        isPassValidate = YES;
    }
    return isPassValidate;
}

- (void)checkPhoneNum
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    if(![self checkUserInput])
    {
        return;
    }
    NSString *userNameString  = self.nameText.text;
    NSString *phoneString     = self.phoneText.text;
    NSString *coorpString     = self.coorpText.text;
    NSString *passString      = self.passText.text;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_USERREGISTCHECK_URL];
    LawCityEntity *cityEntity = [allCityArr objectAtIndex:1];
    LawCityEntity *provinceEntity = [allCityArr objectAtIndex:0];
    NSDictionary *cityDic     = [NSDictionary dictionaryWithObjectsAndKeys:cityEntity.name,@"name",cityEntity.cityID,@"id", nil] ;
    NSDictionary *provinceDic = [NSDictionary dictionaryWithObjectsAndKeys:provinceEntity.name,@"name",provinceEntity.cityID,@"id", nil];
    NSDictionary *areaDics     = [NSDictionary dictionaryWithObjectsAndKeys:provinceDic,@"province",cityDic,@"city", nil];
//    NSData *jsonData          = [NSJSONSerialization dataWithJSONObject:areaDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString      = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
//    NSDictionary *areaDics     = @{
//                                  @"city":@{
//                                          @"name":cityEntity.name,
//                                          @"id"  :cityEntity.cityID
//                                          },
//                                  @"province":@{
//                                          @"name":provinceEntity.name,
//                                          @"id"  :provinceEntity.cityID
//                                          }
//                                  };
   // NSLog(@"%@",jsonString);
    NSDictionary *params;
    if([customerType isEqualToString:@"CT0001"])
    {
        params                = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"lawyerFlag",customerType,@"customerType",phoneString,@"id",[NSNumber numberWithInt:1],@"type", areaDics,@"area",phoneString,@"mobile",@"",@"email",[NSNumber numberWithInt:sexInt].stringValue,@"sex",passString,@"password",passString,@"password2",coorpString,@"companyName",userNameString,@"name",nil];
    }
    else
    {
        params                = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"lawyerFlag",customerType,@"customerType",phoneString,@"id",[NSNumber numberWithInt:1],@"type", areaDics,@"area",phoneString,@"mobile",[NSNumber numberWithInt:sexInt].stringValue,@"sex",passString,@"password",passString,@"password2",userNameString,@"name",@"",@"email",nil];
    }
    parameters = [NSDictionary dictionaryWithDictionary:params];
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer              = [AFHTTPResponseSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@",operation.responseString);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *allHeader = [operation.response allHeaderFields];
        NSString *csrfString    = [ZXY_APIFiles getCSRFToken:allHeader];
        [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
        if([jsonDic.allKeys containsObject:@"error"])
        {
            NSDictionary *errorDic = [jsonDic objectForKey:@"error"];
            NSString *message      = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:nil andContent:message];
        }
        else
        {
            [self performSegueWithIdentifier:@"toCheckNum" sender:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    //[self performSegueWithIdentifier:@"toCheckNum" sender:self];
}

// !!!:选择性别
- (void)chooseSexWithID:(NSInteger)sexID
{
    sexInt = sexID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据处理判断手机号码是否是数字，以及地址的代理
-  (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==self.cityText)
    {
        [self showPickController];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.phoneText)
    {
        if([self isUserInputNum:string])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

// !!!:选择城市
- (void)showPickController
{
    [self toolBarRightAction];
    [self performSegueWithIdentifier:@"toCityZone" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toCityZone"])
    {
        ZXY_CityZoneVC *cityVC = [segue destinationViewController];
        [cityVC setLevel:YES];
        cityVC.delegate = self;
    }
    if([segue.identifier isEqualToString:@"toCheckNum"])
    {
        ZXY_CheckPhoneNumVC *checkPhone = [segue destinationViewController];
        [checkPhone setURLParameter:parameters];
    }
}

// !!!:选择城市代理
- (void)userChooseCityDelegate:(LawCityEntity *)provinceEntity andCityEntity:(LawCityEntity *)cityEntity withZoneEntity:(LawCityEntity *)zoneEntity
{
    allCityArr = [NSArray arrayWithObjects:provinceEntity,cityEntity,zoneEntity, nil];
    for(LawCityEntity *entity in allCityArr)
    {
        NSLog(@"%@",entity.name);
        
    }
    self.cityText.text = [NSString stringWithFormat:@"%@ %@",provinceEntity.name,cityEntity.name];
}

// !!!:判断用户输入的是否为数字
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

// !!!:密码应该包含数字大小写字母 此处判断
- (BOOL)isPassValidate:(NSString *)passWord
{
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    
    BOOL isValidate = YES;
    if(![self judgeRange:termArray1 Password:passWord])
    {
        isValidate = NO;
    }
    else if(![self judgeRange:termArray2 Password:passWord])
    {
        isValidate = NO;
    }
    
    if(isValidate)
    {
        return YES;
    }
    else
    {
        [self showAlertWarnningView:nil andContent:@"密码为6-20个字符，应同时包含数字和字母。"];
        return NO;
    }
}


- (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password

{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
            
        {
            result =YES;
        }
        
    }
    return result;
    
}


#pragma mark - 控件方法选择个人还是企业注册

- (void)chooseCoorOrPer:(id)sender
{
    NSLog(@"segment change");
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0)
    {
        isPersonRegist = NO;
        customerType = @"CT0001";
    }
    else
    {
        isPersonRegist = YES;
        customerType = @"CT0002";
    }
    [self setNilBeforeReload];
    [currentTableV reloadData];
}

- (void)tapChooseCity
{
    NSLog(@"hello world");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
