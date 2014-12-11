//
//  ZXY_UserInfoListVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-19.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserInfoListVC.h"
#import "ZXY_UserInfoListVCCell.h"
#import "UserInfoDetail.h"
#import "UserInfoEntity.h"
#import "ZXY_ChangeUserInfoVC.h"
#import "ZXY_CityZoneVC.h"
#import "LawCityEntity.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LawEntityHelper.h"

@interface ZXY_UserInfoListVC ()<UITableViewDataSource,UITableViewDelegate,ZXY_ChangeUserInfoDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ZXY_ChooseCityDelegate>
{
    UserInfoEntity *userEntity;
    BOOL isPerson;
    BOOL selectIsNum;
    NSString *selectValue;
    NSString *selectKey;
    __weak IBOutlet UITableView *currentTable;
    IBOutlet UIView *datePickV;
    __weak IBOutlet UIDatePicker *datePickVC;
    IBOutlet UIView *pickV;
    __weak IBOutlet UIPickerView *pickVC;
    NSNumber *currentSex;
}
- (IBAction)hideDatePickV:(id)sender;
- (IBAction)hidePickV:(id)sender;
- (IBAction)dateChange:(id)sender;
@end

@implementation ZXY_UserInfoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self initData];
    [self initNavi];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (void)loadData
{
    [currentTable setHidden:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringURL = [NSString stringWithFormat:@"%@user/getRegInfo",API_HOST_URL];
    [self startLoadDataGETCSRF:stringURL withPatameter:nil successBlock:^(NSData *responseData) {
        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([userInfo.allKeys containsObject:@"error"])
        {
            [self performSelector:@selector(toLoginView) withObject:nil afterDelay:1];
            [[UserInfoDetail sharedInstance] userLogOut];
        }
        else
        {
            [currentTable setHidden:NO];
            [LawEntityHelper saveUserInfo:userInfo];
            [self initData];
            [currentTable reloadData];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } errorBlock:^(NSError *error) {
        [self performSelector:@selector(toLoginView) withObject:nil afterDelay:1];
        [[UserInfoDetail sharedInstance] userLogOut];
    }];
}

- (void)toLoginView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self performSegueWithIdentifier:@"toLoginVC" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:userEntity.name withPositon:1];
    [self setNaviTitle:@"保存" withPositon:2];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)initData
{
   NSArray *userArr =  [[ZXYProvider sharedInstance] readCoreDataFromDB:@"UserInfoEntity"];
    if(userArr.count >0)
    {
        userEntity = (UserInfoEntity *)[userArr objectAtIndex:0];
        NSString *customerType = userEntity.customerType;
        if([customerType isEqualToString:@"CT0001"])
        {
            isPerson = NO;
        }
        else
        {
            isPerson = YES;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(isPerson)
        {
            return 2;
        }
        return 3;
    }
    else if (section == 1)
    {
        if(isPerson)
        {
            return 6;
        }
        else
        {
            return 6;
        }
    }
    else
    {
        if(isPerson)
        {
            return 4;
        }
        else
        {
            return 4;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_UserInfoListVCCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoListVCCellID];
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLbl.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1];
    if(isPerson)
    {
        if(indexPath.section == 0)
        {
            NSInteger currentRow = indexPath.row;
            if(currentRow == 0)
            {
                cell.titleLbl.text = @"用户类型";
                if(isPerson)
                {
                     cell.valueLbl.text = @"个人";
                }
                else
                {
                     cell.valueLbl.text = @"公司";
                }
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                return cell;
            }
            else if(currentRow == 1)
            {
                cell.titleLbl.text = @"手机号码";
                cell.valueLbl.text = userEntity.userinfoentityID;
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                return cell;
            }
            else if(currentRow == 2)
            {
                cell.titleLbl.text = @"企业名称";
                cell.valueLbl.text = userEntity.companyName;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else
            {
                cell.titleLbl.text = @"企业注册时间";
                cell.valueLbl.text = userEntity.companyRegDate;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
        }
        else if (indexPath.section == 1)
        {
            NSInteger currentRow = indexPath.row;
            if(currentRow == 0)
            {
                cell.titleLbl.text = @"姓名";
                cell.valueLbl.text = userEntity.name;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 1)
            {
                cell.titleLbl.text = @"性别";
                NSNumber *sexNum = userEntity.sexNum;
                NSInteger setInt = sexNum.integerValue;
                if(setInt == 0)
                {
                    cell.valueLbl.text = @"女士";
                }
                else
                {
                    cell.valueLbl.text = @"先生";
                }
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 2)
            {
                cell.titleLbl.text = @"所在地";
                NSString *cityName = userEntity.cityName;
                NSString *provinceName = userEntity.provinceName;
                cell.valueLbl.text = [NSString stringWithFormat:@"%@  %@",provinceName,cityName];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 3)
            {
                if(isPerson)
                {
                    cell.titleLbl.text = @"绑定电话1";
                    cell.valueLbl.text = userEntity.phone1;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    return cell;
                }
                cell.titleLbl.text = @"详细地址";
                NSString *cityName = userEntity.detailAddress;
                cell.valueLbl.text = [NSString stringWithFormat:@"%@",cityName];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 4)
            {
                if(isPerson)
                {
                    cell.titleLbl.text = @"绑定电话2";
                    cell.valueLbl.text = userEntity.phone2;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    return cell;
                }
                cell.titleLbl.text = @"绑定电话1";
                cell.valueLbl.text = userEntity.phone1;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 5)
            {
                if(isPerson)
                {
                    cell.titleLbl.text = @"出生年月日";
                    cell.valueLbl.text = userEntity.birthday;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    return cell;
                }
                cell.titleLbl.text = @"绑定电话2";
                cell.valueLbl.text = userEntity.phone2;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else
            {
                cell.titleLbl.text = @"出生年月日";
                cell.valueLbl.text = userEntity.birthday;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
        }
        else
        {
            NSInteger currentRow = indexPath.row;
            if(currentRow == 0)
            {
                cell.titleLbl.text = @"所在行业";
                cell.valueLbl.text = userEntity.coorbelong;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 1)
            {
                cell.titleLbl.text = @"关心领域";
                cell.valueLbl.text = userEntity.focus;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if(currentRow ==2)
            {
                cell.titleLbl.text = @"修改密码";
                cell.valueLbl.text = @"";
                
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else
            {
                cell.titleLbl.text = @"退出登录";
                cell.valueLbl.text = @"";
                cell.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:209.0/255.0 blue:122.0/255.0 alpha:1];
                [cell.titleLbl setTextColor:[UIColor whiteColor]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }

        }
    }
    else
    {
        if(indexPath.section == 0)
        {
            NSInteger currentRow = indexPath.row;
            if(currentRow == 0)
            {
                cell.titleLbl.text = @"用户类型";
                if(isPerson)
                {
                    cell.valueLbl.text = @"个人";
                }
                else
                {
                    cell.valueLbl.text = @"公司";
                }
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                return cell;
            }
            else if(currentRow == 1)
            {
                cell.titleLbl.text = @"手机号码";
                cell.valueLbl.text = userEntity.userinfoentityID;
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                return cell;
            }
            else
            {
                cell.titleLbl.text = @"企业名称";
                cell.valueLbl.text = userEntity.companyName;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
        }
        else if (indexPath.section == 1)
        {
            NSInteger currentRow = indexPath.row;
            if(currentRow == 0)
            {
                cell.titleLbl.text = @"联系人";
                cell.valueLbl.text = userEntity.name;
                NSLog(@"%@",userEntity.name);
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 1)
            {
                cell.titleLbl.text = @"性别";
                NSNumber *sexNum = userEntity.sexNum;
                NSInteger setInt = sexNum.integerValue;
                if(setInt == 0)
                {
                    cell.valueLbl.text = @"女士";
                }
                else
                {
                    cell.valueLbl.text = @"先生";
                }
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 2)
            {
                cell.titleLbl.text = @"所在地";
                NSString *cityName = userEntity.cityName;
                NSString *provinceName = userEntity.provinceName;
                cell.valueLbl.text = [NSString stringWithFormat:@"%@  %@",provinceName,cityName];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 3)
            {
                cell.titleLbl.text = @"详细地址";
                NSString *cityName = userEntity.detailAddress;
                cell.valueLbl.text = [NSString stringWithFormat:@"%@",cityName];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 4)
            {
                cell.titleLbl.text = @"绑定电话1";
                cell.valueLbl.text = userEntity.phone1;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else
            {
                cell.titleLbl.text = @"绑定电话2";
                cell.valueLbl.text = userEntity.phone2;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
//            else
//            {
//                cell.titleLbl.text = @"出生年月日";
//                cell.valueLbl.text = userEntity.birthday;
//                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//                return cell;
//            }
        }
        else
        {
            NSInteger currentRow = indexPath.row;
            if(currentRow == 0)
            {
                cell.titleLbl.text = @"企业所在行业";
                cell.valueLbl.text = userEntity.coorbelong;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if (currentRow == 1)
            {
                cell.titleLbl.text = @"企业注册时间：";
                cell.valueLbl.text = userEntity.companyRegDate;
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else if(currentRow ==2)
            {
                cell.titleLbl.text = @"修改密码";
                cell.valueLbl.text = @"";
                
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
            else
            {
                cell.titleLbl.text = @"退出登录";
                cell.valueLbl.text = @"";
                cell.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:209.0/255.0 blue:122.0/255.0 alpha:1];
                [cell.titleLbl setTextColor:[UIColor whiteColor]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isPerson)
    {
        if(indexPath.section == 2)
        {
            if(indexPath.row == 3)
            {
                [[UserInfoDetail sharedInstance] userLogOut];
                [[ZXYProvider sharedInstance] deleteCoreDataFromDB:@"UserInfoEntity"];
                [[UserInfoDetail sharedInstance] setOthersInfo:nil withKey:ZXY_VALUES_CSRF];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if(indexPath.row == 2)
            {
                [self performSegueWithIdentifier:@"toChangePassVC" sender:self];
            }
            
            if(indexPath.row == 0)
            {
                // !!!:修改所在行业
                selectValue = userEntity.coorbelong;
                selectKey   = @"coorbelong";
                selectIsNum = NO;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
            
            if(indexPath.row == 1)
            {
               // !!!:修改关心领域
                selectKey  = @"focus";
                selectIsNum= NO;
                selectValue= userEntity.focus;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
        }
        NSInteger currentRow = indexPath.row;
        NSInteger currentSection = indexPath.section;
        if(currentSection == 0)
        {
            if(currentRow == 2)
            {
               // !!!:修改企业名称
                selectValue = userEntity.companyName;
                selectKey   = @"companyName";
                selectIsNum = NO;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
            else if (currentRow == 3)
            {
               // !!!:修改企业注册时间
                selectValue = userEntity.companyRegDate;
                selectKey   = @"companyRegDate";
                selectIsNum = NO;
                [self showDatePickV];
    //            [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
        }
        else if (currentSection == 1)
        {
            if(currentRow == 0)
            {
                //!!!:修改用户名称
                selectValue  = userEntity.name;
                selectKey    = @"name";
                selectIsNum  = NO;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
            else if (currentRow == 1)
            {
                // !!!:修改性别
                currentSex = userEntity.sexNum;
                [self showPickV];
            }
            else if (currentRow == 2)
            {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
                ZXY_CityZoneVC *cityZone = [story instantiateViewControllerWithIdentifier:@"cityVC"];
                cityZone.delegate = self;
                [cityZone setLevel:YES];
                [self.navigationController pushViewController:cityZone animated:YES];
            }
            
            else if (currentRow == 3)
            {
                if(isPerson)
                {
                    selectValue   = userEntity.phone1;
                    selectKey     = @"phone1";
                    selectIsNum   = YES;
                    [self performSegueWithIdentifier:@"toChangeView" sender:self];
                    return;
                }
                selectValue   = userEntity.detailAddress;
                selectKey     = @"detailAddress";
                selectIsNum   = NO;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];

            }
            
            else if (currentRow == 4)
            {
               // !!!:修改绑定电话1
                if(isPerson)
                {
                    selectValue  = userEntity.phone2;
                    selectKey    = @"phone2";
                    selectIsNum  = YES;
                    [self performSegueWithIdentifier:@"toChangeView" sender:self];
                    return;
                }
                selectValue   = userEntity.phone1;
                selectKey     = @"phone1";
                selectIsNum   = YES;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
            else if (currentRow == 5)
            {
                if(isPerson)
                {
                    selectValue = userEntity.birthday;
                    selectKey   = @"birthday";
                    [self showDatePickV];
                    return;
                }
                // !!!:修改绑定电话2
                selectValue  = userEntity.phone2;
                selectKey    = @"phone2";
                selectIsNum  = YES;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
            else if (currentRow == 6)
            {
                // !!!:修改出生年月日
                selectValue = userEntity.birthday;
                selectKey   = @"birthday";
                [self showDatePickV];
            }
        }
    }
    else
    {
        if(indexPath.section == 2)
        {
            if(indexPath.row == 3)
            {
                [[UserInfoDetail sharedInstance] userLogOut];
                [[ZXYProvider sharedInstance] deleteCoreDataFromDB:@"UserInfoEntity"];
                [[UserInfoDetail sharedInstance] setOthersInfo:nil withKey:ZXY_VALUES_CSRF];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if(indexPath.row == 2)
            {
                [self performSegueWithIdentifier:@"toChangePassVC" sender:self];
            }
            
            if(indexPath.row == 0)
            {
                // !!!:修改所在行业
                selectValue = userEntity.coorbelong;
                selectKey   = @"coorbelong";
                selectIsNum = NO;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
            
            if(indexPath.row == 1)
            {
                // !!!:修改关心领域
                selectValue = userEntity.companyRegDate;
                selectKey   = @"companyRegDate";
                selectIsNum = NO;
                [self showDatePickV];
            }
        }
        NSInteger currentRow = indexPath.row;
        NSInteger currentSection = indexPath.section;
        if(currentSection == 0)
        {
            if(currentRow == 2)
            {
                // !!!:修改企业名称
                selectValue = userEntity.companyName;
                selectKey   = @"companyName";
                selectIsNum = NO;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
//            else if (currentRow == 3)
//            {
//                // !!!:修改企业注册时间
//                selectValue = userEntity.companyRegDate;
//                selectKey   = @"companyRegDate";
//                selectIsNum = NO;
//                [self showDatePickV];
//                //            [self performSegueWithIdentifier:@"toChangeView" sender:self];
//            }
        }
        else if (currentSection == 1)
        {
            if(currentRow == 0)
            {
                //!!!:修改用户名称
                selectValue  = userEntity.name;
                selectKey    = @"name";
                selectIsNum  = NO;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
            else if (currentRow == 1)
            {
                // !!!:修改性别
                currentSex = userEntity.sexNum;
                [self showPickV];
            }
            else if (currentRow == 2)
            {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
                ZXY_CityZoneVC *cityZone = [story instantiateViewControllerWithIdentifier:@"cityVC"];
                cityZone.delegate = self;
                [cityZone setLevel:YES];
                [self.navigationController pushViewController:cityZone animated:YES];
            }
            
            else if (currentRow == 3)
            {
//                if(isPerson)
//                {
//                    selectValue   = userEntity.phone1;
//                    selectKey     = @"phone1";
//                    selectIsNum   = YES;
//                    [self performSegueWithIdentifier:@"toChangeView" sender:self];
//                    return;
//                }
                selectValue   = userEntity.detailAddress;
                selectKey     = @"detailAddress";
                selectIsNum   = NO;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
                
            }
            
            else if (currentRow == 4)
            {
                // !!!:修改绑定电话1
//                if(isPerson)
//                {
//                    selectValue  = userEntity.phone2;
//                    selectKey    = @"phone2";
//                    selectIsNum  = YES;
//                    [self performSegueWithIdentifier:@"toChangeView" sender:self];
//                    return;
//                }
                selectValue   = userEntity.phone1;
                selectKey     = @"phone1";
                selectIsNum   = YES;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
            else if (currentRow == 5)
            {
//                if(isPerson)
//                {
//                    selectValue = userEntity.birthday;
//                    selectKey   = @"birthday";
//                    [self showDatePickV];
//                    return;
//                }
                // !!!:修改绑定电话2
                selectValue  = userEntity.phone2;
                selectKey    = @"phone2";
                selectIsNum  = YES;
                [self performSegueWithIdentifier:@"toChangeView" sender:self];
            }
//            else if (currentRow == 6)
//            {
//                // !!!:修改出生年月日
//                selectValue = userEntity.birthday;
//                selectKey   = @"birthday";
//                [self showDatePickV];
//            }
        }

    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0)
    {
        return @"先生";
    }
    else
    {
        return @"女士";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row == 0)
    {
        [[ZXYProvider sharedInstance] updateDataFormCoreData:@"UserInfoEntity" withContent:[NSNumber numberWithInt:1] andKey:@"sexNum"];
    }
    else
    {
        [[ZXYProvider sharedInstance] updateDataFormCoreData:@"UserInfoEntity" withContent:[NSNumber numberWithInt:0] andKey:@"sexNum"];
    }
    [self initData];
    [currentTable reloadData];
}

- (void)changeUserInfo:(NSString *)changeValue withKey:(NSString *)dbKey
{
    [[ZXYProvider sharedInstance] updateDataFormCoreData:@"UserInfoEntity" withContent:changeValue andKey:dbKey];
    NSArray *userArr =  [[ZXYProvider sharedInstance] readCoreDataFromDB:@"UserInfoEntity"];
    
    if(userArr.count >0)
    {
        userEntity = (UserInfoEntity *)[userArr objectAtIndex:0];
        NSString *customerType = userEntity.customerType;
        if([customerType isEqualToString:@"CT0001"])
        {
            isPerson = NO;
        }
        else
        {
            isPerson = YES;
        }
        NSLog(@"%@",userEntity.name);
    }
    [currentTable reloadData];
}

- (void)showDatePickV
{
    NSString *dateString     = selectValue;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    if(dateString==nil || dateString.length == 0)
    {
        
        [datePickVC setDate:[NSDate date]];

    }
    else
    {
        NSDate *currentDate = [formatter dateFromString:dateString];
        [datePickVC setDate:currentDate];
    }
        CGSize pickerProfessionS = datePickV.frame.size;
    if(![self.view.subviews containsObject:datePickV])
    {
        datePickV.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
        [self.view addSubview:datePickV];
    }
    else
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        datePickV.frame = CGRectMake(0, self.view.frame.size.height-pickerProfessionS.height, pickerProfessionS.width, pickerProfessionS.height);
    }];

}

- (void)userChooseCityDelegate:(LawCityEntity *)provinceEntity andCityEntity:(LawCityEntity *)cityEntity withZoneEntity:(LawCityEntity *)zoneEntity
{
    [[ZXYProvider sharedInstance]updateDataFormCoreData:@"UserInfoEntity" withContent:provinceEntity.cityID andKey:@"provinceID"];
    [[ZXYProvider sharedInstance]updateDataFormCoreData:@"UserInfoEntity" withContent:provinceEntity.name andKey:@"provinceName"];
    [[ZXYProvider sharedInstance]updateDataFormCoreData:@"UserInfoEntity" withContent:cityEntity.cityID andKey:@"cityID"];
    [[ZXYProvider sharedInstance]updateDataFormCoreData:@"UserInfoEntity" withContent:cityEntity.name andKey:@"cityName"];
    [currentTable reloadData];
}

- (void)showPickV
{
    [pickVC reloadAllComponents];
    if(currentSex.integerValue == 1)
    {
        [pickVC selectRow:0 inComponent:0 animated:NO];
    }
    else
    {
        [pickVC selectRow:1 inComponent:0 animated:NO];
    }
    
    CGSize pickerProfessionS = pickV.frame.size;
    if(![self.view.subviews containsObject:pickV])
    {
        pickV.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
        [self.view addSubview:pickV];
    }
    else
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        pickV.frame = CGRectMake(0, self.view.frame.size.height-pickerProfessionS.height, pickerProfessionS.width, pickerProfessionS.height);
    }];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toChangeView"])
    {
        ZXY_ChangeUserInfoVC *changeInfo = [segue destinationViewController];
        [changeInfo setChangeInfo:selectValue withKey:selectKey isNum:selectIsNum];
        changeInfo.delegate = self;
    }
}


- (IBAction)hideDatePickV:(id)sender {
    CGSize pickerProfessionS = datePickV.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        datePickV.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
    }completion:^(BOOL finished) {
        [datePickV removeFromSuperview];
    }];
}

- (IBAction)hidePickV:(id)sender {
    CGSize pickerProfessionS = pickV.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        pickV.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
    }completion:^(BOOL finished) {
        [pickV removeFromSuperview];
    }];

}

- (IBAction)dateChange:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [formatter stringFromDate:datePicker.date];
    [[ZXYProvider sharedInstance] updateDataFormCoreData:@"UserInfoEntity" withContent:dateString andKey:selectKey];
    [self initData];
    [currentTable reloadData];
}

#pragma mark - 保存到服务器
- (void)setNaviRightAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_UPDATEUSERINFO_URL];
    NSDictionary *cityDic = @{
                              @"name":userEntity.cityName,
                              @"id"  :userEntity.cityID
                              };
    NSDictionary *provinceDic = @{
                                  @"name":userEntity.provinceName,
                                  @"id":userEntity.provinceID
                                  };
    NSDictionary *areaDic ;
    if(isPerson)
    {
        
        areaDic = @{
                    @"city":cityDic,
                    @"province":provinceDic
                    };
    }
    else
    {
        areaDic = @{
                    @"city":cityDic,
                    @"province":provinceDic,
                    @"streets":userEntity.detailAddress
                    };
    }
    NSString *nameString = userEntity.name;
    if(nameString == nil)
    {
        nameString = @"";
    }
    NSString *sexString  = userEntity.sexNum.stringValue;
    if(sexString == nil)
    {
        sexString = @"";
    }
    NSString *customerType = userEntity.customerType;
    if(customerType == nil)
    {
        customerType = @"";
    }
    NSString *phone1String = userEntity.phone1;
    if(phone1String == nil)
    {
        phone1String = @"";
    }
    NSString *phone2String = userEntity.phone2;
    if(phone2String == nil)
    {
        phone2String = @"";
    }
    NSString *industryString = userEntity.coorbelong;
    if(industryString == nil)
    {
        industryString = @"";
    }
    NSString *focusString    = userEntity.focus;
    if(focusString == nil)
    {
        focusString = @"";
    }
    NSString *birthdayString = userEntity.birthday;
    if(birthdayString == nil)
    {
        birthdayString = @"";
    }
    NSString *companyReg = userEntity.companyRegDate;
    if(companyReg == nil)
    {
        companyReg = @"";
    }
    
    NSString *comName = userEntity.companyName;
    if(comName == nil)
    {
        comName = @"";
    }
    NSDictionary *parameter = @{
                                @"name":nameString,
                                @"sex":sexString,
                                @"phone1":phone1String,
                                @"phone2":phone2String,
                                @"industry":industryString,
                                @"customerType":customerType,
                                @"area":areaDic,
                                @"birthday":birthdayString,
                                @"focus":focusString,
                                };
    if(!isPerson)
    {
        parameter = @{
                      @"name":nameString,
                      @"sex":sexString,
                      @"phone1":phone1String,
                      @"phone2":phone2String,
                      @"industry":industryString,
                      @"customerType":customerType,
                      @"area":areaDic,
                      @"birthday":birthdayString,
                      @"focus":focusString,
                      @"companyRegDate":companyReg,
                      @"companyName" : comName
                      };
    }
    [self startLoadDataPutCSRF:urlString withParameter:parameter successBlock:^(NSData *responseData) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWarnningView:@"" andContent:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];;
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWarnningView:@"" andContent:@"保存失败，登陆超时，请退出重新登陆"];
    }];
//    [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
//        
//    } errorBlock:^(NSError *error) {
//        
//    }];
}
@end
