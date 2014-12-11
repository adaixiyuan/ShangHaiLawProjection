//
//  ZXY_UserChangePasswordVC.m
//  LawProjection
//
//  Created by 宇周 on 14/10/30.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserChangePasswordVC.h"
#import "ZXY_UserLoginVC.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ZXY_UserChangePasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *originalPass;
@property (weak, nonatomic) IBOutlet UITextField *freshPass;
@property (weak, nonatomic) IBOutlet UITextField *confirmPass;
@property (weak, nonatomic) IBOutlet UIButton *changePassBtn;
- (IBAction)changeBtnAction:(id)sender;

@end

@implementation ZXY_UserChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initNavi];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"修改密码" withPositon:1];
    [self setRightNaviItem:@"home_phone"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)initView
{
    self.changePassBtn.layer.cornerRadius  = 4;
    self.changePassBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isPassValidate
{
    BOOL isValidate = YES;
    if(self.originalPass.text.length < 6||self.originalPass.text.length>20)
    {
        isValidate = NO;
        [self showAlertWarnningView:@"" andContent:@"请正确输入原始密码"];
    }
    else if(self.freshPass.text.length<6||self.freshPass.text.length>20)
    {
        isValidate = NO;
        [self showAlertWarnningView:@"" andContent:@"密码为6-20个字符，应同时包含数字和字母。"];
    }
    else if (![self.freshPass.text isEqualToString:self.confirmPass.text])
    {
        isValidate = NO;
        [self showAlertWarnningView:@"" andContent:@"两次输入的密码不一致"];
    }
    else if (![self isPassValidate:self.freshPass.text])
    {
        isValidate = NO;
    }
    else
    {
        isValidate = YES;
    }
    return isValidate;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeBtnAction:(id)sender {
    if([self isPassValidate])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *originalString = self.originalPass.text;
        NSString *freshString    = self.freshPass.text;
        NSString *urlString      = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_RESETPASS_URL];
        NSDictionary *parameter  = [NSDictionary dictionaryWithObjectsAndKeys:originalString,@"orignal",freshString,@"password", nil];
        [self startLoadDataPutCSRF:urlString withParameter:parameter successBlock:^(NSData *responseData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *currentDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if([currentDic.allKeys containsObject:@"error"])
            {
                NSDictionary *errorDic = [currentDic objectForKey:@"error"];
                NSString *errorMessage = [errorDic objectForKey:@"message"];
                [self showAlertWarnningView:@"" andContent:errorMessage];
            }
            else
            {
                [[UserInfoDetail sharedInstance] setUserPass:self.freshPass.text];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
            ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
            loginVC.onComplete = ^()
            {
                [self changeBtnAction:nil];
            };
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
    }
}
@end
