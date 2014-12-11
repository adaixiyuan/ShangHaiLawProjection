//
//  ZXY_SearchLawerVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-9-23.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_SearchLawerVC.h"
#import "ZXY_CityZoneVC.h"
#import "LawCityEntity.h"
#import "LawCaseTypeEntity.h"
#import "LawEntityHelper.h"
#import "ZXY_LawerListVC.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString *const SearchLawerVCID = @"searchLawerID";
@interface ZXY_SearchLawerVC ()<UIPickerViewDataSource,UIPickerViewDelegate,ZXY_ChooseCityDelegate>
{
    __weak IBOutlet UIView *superOfPick;
    __weak IBOutlet UIPickerView *pickView;
    __weak IBOutlet UILabel *locationLbl;
    __weak IBOutlet UILabel *professionalLbl;
    __weak IBOutlet UITextField *keywordLbl;/**< 关键词 可选*/
    NSArray *professionArr;
    NSArray *locationArr;    /**< 地址 必选*/
    LawCaseTypeEntity *selectCaseType; /**< 案件类型 必选*/
    __weak IBOutlet UIButton *submitBtn;
    BOOL _isChoose;
}
- (IBAction)finishSelectProfession:(id)sender;
- (IBAction)submitAction:(id)sender;
@end

@implementation ZXY_SearchLawerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initTap];
    //[self initData];
    // Do any additional setup after loading the view.
}
- (IBAction)hideThis:(id)sender {
    [keywordLbl resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CATEGORY_URL];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"CaseType",@"type", nil];
//    [self startLoadDataGETCSRF:stringURL withParameter:parameter successBlock:^(NSData *responsData) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingMutableLeaves error:nil];
//        NSDictionary *jsonDatas = [jsonDic objectForKey:@"data"];
//        NSArray      *items     = [jsonDatas objectForKey:@"items"];
//        [LawEntityHelper saveCaseType:items];
//        NSArray *allJson = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCaseTypeEntity"];
//        for(LawCaseTypeEntity *entity in allJson)
//        {
//            NSLog(@"name is %@",entity.name);
//            
//        }
//        [self initData];
//
//    } errorBlock:^(NSError *errorInfo) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
//    }];
    [self startLoadDataGETCSRF:stringURL withPatameter:parameter successBlock:^(NSData *responseData) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *jsonDatas = [jsonDic objectForKey:@"data"];
        NSArray      *items     = [jsonDatas objectForKey:@"items"];
        [LawEntityHelper saveCaseType:items];
        NSArray *allJson = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCaseTypeEntity"];
        for(LawCaseTypeEntity *entity in allJson)
        {
            NSLog(@"name is %@",entity.name);
            
        }
        [self initData]; ;
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWarnningView:@"提示" andContent:@"数据获取错误，请重新登录"];
    }];
}

- (void)initData
{
    professionArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCaseTypeEntity"];
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"查找律师" withPositon:1];
    UIColor *naviColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:naviColor forKey:NSForegroundColorAttributeName]];
    [self setRightNaviItem:@"home_phone"];
}

- (void)initTap
{
    UITapGestureRecognizer *locationtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLocation)];
    locationLbl.userInteractionEnabled = YES;
    [locationLbl addGestureRecognizer:locationtap];
    
    UITapGestureRecognizer *professionalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProfessional)];
    professionalLbl.userInteractionEnabled = YES;
    [professionalLbl addGestureRecognizer:professionalTap];
    
}

- (void)selectLocation
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
    ZXY_CityZoneVC *cityZone = [story instantiateViewControllerWithIdentifier:@"cityVC"];
    [cityZone setLevel:YES];
    cityZone.delegate = self;
    [self.navigationController pushViewController:cityZone animated:YES];
}

- (void)selectProfessional
{
    [keywordLbl resignFirstResponder];
    CGSize pickerProfessionS = superOfPick.frame.size;
    if(selectCaseType == nil)
    {
        LawCaseTypeEntity *caseTypeEntity = [professionArr objectAtIndex:0];
        selectCaseType = caseTypeEntity;
        professionalLbl.text = [NSString stringWithFormat:@"擅长领域    %@",selectCaseType.name];
    }
    if(![self.view.subviews containsObject:superOfPick])
    {
        superOfPick.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
        [self.view addSubview:superOfPick];
    }
    else
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        superOfPick.frame = CGRectMake(0, self.view.frame.size.height-pickerProfessionS.height, pickerProfessionS.width, pickerProfessionS.height);
    }];

}

- (void)userChooseCityDelegate:(LawCityEntity *)provinceEntity andCityEntity:(LawCityEntity *)cityEntity withZoneEntity:(LawCityEntity *)zoneEntity
{
    locationArr = [NSArray arrayWithObjects:provinceEntity,cityEntity, nil];
    [self setLocationLblText];
}

- (void)setLocationLblText
{
    if(locationArr.count == 2)
    {
        LawCityEntity *provinceEntity = [locationArr objectAtIndex:0];
        LawCityEntity *cityEntity    = [locationArr objectAtIndex:1];
        //LawCityEntity *zoneEntity    = [locationArr objectAtIndex:2];
        locationLbl.text = [NSString stringWithFormat:@"选择所在地   %@ %@ ",provinceEntity.name,cityEntity.name];
    }
    else
    {
        [self showAlertWarnningView:@"错误" andContent:@"没有选择地区错误"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return professionArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LawCaseTypeEntity *caseType = [professionArr objectAtIndex:row];
    return caseType.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LawCaseTypeEntity *select = [professionArr objectAtIndex:row];
    selectCaseType = select;
    professionalLbl.text = [NSString stringWithFormat:@"擅长领域        %@",selectCaseType.name];
}

- (IBAction)finishSelectProfession:(id)sender
{
    CGSize pickerProfessionS = superOfPick.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        superOfPick.frame = CGRectMake(0, self.view.frame.size.height, pickerProfessionS.width, pickerProfessionS.height);
    }completion:^(BOOL finished) {
        [superOfPick removeFromSuperview];
    }];
}

- (IBAction)submitAction:(id)sender {
    if([self checkSubmitCondition])
    {
        [self performSegueWithIdentifier:@"toLawListTC" sender:self];
    }
    else
    {
        return;
    }
}

- (BOOL)checkSubmitCondition
{
    BOOL isValidate = YES;
//    if(locationArr.count <3)
//    {
//        [self showAlertWarnningView:nil andContent:@"请选择地址"];
//        isValidate = NO;
//    }
//    else if (selectCaseType==nil)
//    {
//        [self showAlertWarnningView:nil andContent:@"请选择案件类型"];
//        isValidate = NO;
//    }
    return isValidate;
    
}

- (NSDictionary *)toParameterForLawList
{
    NSString *keywordString=@"";
    NSDictionary   *areaData;
    NSString *caseType     = @"" ;
    if(keywordLbl.text.length != 0)
    {
        keywordString = keywordLbl.text;
    }
    if(locationArr.count == 3)
    {
        areaData = [self toJsonDataForArea];
    }
    if(selectCaseType!=nil)
    {
        caseType = selectCaseType.categoryId;
    }
    NSString *provinceID ;
    NSString *cityID;
    if(locationArr.count)
    {
        LawCityEntity *provinceEntity = [locationArr objectAtIndex:0];
        LawCityEntity *cityEntity     = [locationArr objectAtIndex:1];
        provinceID = provinceEntity.cityID;
        cityID     = cityEntity.cityID;
    }

    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:keywordString,@"lawyerName",provinceID,@"provinceID",cityID,@"cityID",caseType,@"expertise", nil];
    return paramDic;
}

- (NSDictionary *)toJsonDataForArea
{
    LawCityEntity *provinceEntity = [locationArr objectAtIndex:0];
    LawCityEntity *cityEntity     = [locationArr objectAtIndex:1];
    LawCityEntity *townEntity     = [locationArr objectAtIndex:2];
    NSDictionary  *provinceDic    = [NSDictionary dictionaryWithObjectsAndKeys:provinceEntity.name,@"name",provinceEntity.cityID,@"id", nil];
    NSDictionary  *cityDic        = [NSDictionary dictionaryWithObjectsAndKeys:cityEntity.name,@"name",cityEntity.cityID,@"id", nil];
    NSDictionary  *townDic        = [NSDictionary dictionaryWithObjectsAndKeys:townEntity.name,@"name",townEntity.cityID,@"id", nil];
    NSDictionary *jsonDic         = [NSDictionary dictionaryWithObjectsAndKeys:provinceDic,@"province",cityDic,@"city",townDic,@"town", nil];
    
    return jsonDic;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keywordLbl resignFirstResponder];
}

- (void)setIsChoose:(BOOL)isChoose
{
    _isChoose = isChoose;
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"toLawListTC"])
     {
         ZXY_LawerListVC *lawerList = [segue destinationViewController];
         if(_isChoose)
         {
             [lawerList setIsChoose:YES];
         }
         [lawerList setURLParameters:[self toParameterForLawList]];
     }
 }



@end
