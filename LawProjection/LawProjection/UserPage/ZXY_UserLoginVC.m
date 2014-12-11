//
//  ZXY_UserLoginVC.m
//  LawProjection
//
//  Created by developer on 14-10-9.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserLoginVC.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZXY_SystemRelative.h"
#import "LawEntityHelper.h"
#import "UserInfoDetail.h"
#import "UserInfoEntity.h"
#import "ZXYProvider.h"

@interface ZXY_UserLoginVC ()
{
    MBProgressHUD *progress;
}
@property (weak, nonatomic) IBOutlet UIView *forTTTLabelView;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPass;
- (IBAction)loginAction:(id)sender;
- (IBAction)registAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *savePassBtn;
- (IBAction)savePassAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveNameBtn;
- (IBAction)saveNameAction:(id)sender;

@end

@implementation ZXY_UserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
   
    [self toCheckSaveInfo];
    // Do any additional setup after loading the view.
}

- (void)toCheckSaveInfo
{
    NSString *passStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"savePassStatus"];
    NSString *nameStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"saveNameStatus"];
    if([nameStatus isEqualToString:@"0"])
    {
    
    }
    else
    {
        if([nameStatus isEqualToString:@"1"])
        {
            self.userName.text = [[UserInfoDetail sharedInstance] getUserPhone];
            [self.saveNameBtn setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
            if([passStatus isEqualToString:@"1"])
            {
                self.userPass.text = [[UserInfoDetail sharedInstance] getUserPass];
                [self.savePassBtn setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self initForgetView];
}

- (void)initHUB
{
    progress = [[MBProgressHUD alloc] initWithView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"登录" withPositon:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)initForgetView
{
    TTTAttributedLabel *labelForget = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, self.forTTTLabelView.frame.size.width, self.forTTTLabelView.frame.size.height)];
    labelForget.font = [UIFont systemFontOfSize:14];
    labelForget.textColor = SYSTEMDEFAULTCOLOR;
    labelForget.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    NSString *forgetText = @" 忘记密码 ？";
    [labelForget setText:forgetText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange underLineRange = [[mutableAttributedString string] rangeOfString:@" 忘记密码 ？"];
        [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:underLineRange];
        return mutableAttributedString;
    }];
    [self.forTTTLabelView addSubview:labelForget];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPassAction)];
    [self.forTTTLabelView addGestureRecognizer:tapGes];
    self.forTTTLabelView.userInteractionEnabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)forgetPassAction
{
    [self performSegueWithIdentifier:@"toForgetVC" sender:self];
}

- (IBAction)loginAction:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"" andContent:@"当前无网络连接"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    [self.userName resignFirstResponder];
    [self.userPass resignFirstResponder];
    if([self checkLoginInput])
    {
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_USERLOGIN_URL];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.userName.text,@"name",self.userPass.text, @"password",nil];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
         manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",operation.responseString);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSData *data = [operation responseData];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if([dic.allKeys containsObject:@"error"])
            {
                NSDictionary *errorDic = [dic objectForKey:@"error"];
                NSString *codeString   = [errorDic objectForKey:@"code"];
                //NSString *errorInfo    ;
                if([codeString isEqualToString:@"D1006"])
                {
                    //errorInfo  =  @"密码错误";
                }
                if([codeString isEqualToString:@"D1004"])
                {
                    //errorInfo  =  @"账号不存在";
                }
                [self showAlertWarnningView:@"" andContent:@"用户名与密码不匹配。"];
            }
            else
            {
                [LawEntityHelper saveUserInfo:dic];
                NSDictionary *allHeader = operation.response.allHeaderFields;
                NSString *csrftoken     = [ZXY_APIFiles getCSRFToken:allHeader];
                [[UserInfoDetail sharedInstance] setOthersInfo:csrftoken withKey:ZXY_VALUES_CSRF];
                UserInfoEntity *userEntity = [[[ZXYProvider sharedInstance] readCoreDataFromDB:@"UserInfoEntity"] objectAtIndex:0];
                [[UserInfoDetail sharedInstance] setUserID:userEntity.userinfo_id];
                if(userEntity.type.integerValue == 1)
                {
                    [[UserInfoDetail sharedInstance] setUserName:userEntity.companyName];
                }
                else
                {
                    [[UserInfoDetail sharedInstance] setUserName:userEntity.name];
                }
                [[UserInfoDetail sharedInstance] setUserPass:self.userPass.text];
                [[UserInfoDetail sharedInstance]setUserPhone:userEntity.userinfoentityID];
                if(self.onComplete)
                {
                    self.onComplete();
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"error=====>%@",[error debugDescription]);
        }];
    }
    else
    {
        return;
    }
}

- (void)setNaviLeftAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)checkLoginInput
{
    if(self.userName.text.length == 0)
    {
        [self showAlertWarnningView:@"错误提示" andContent:@"请输入用户名"];
        return NO;
    }
    if(self.userPass.text.length == 0)
    {
        [self showAlertWarnningView:@"错误提示" andContent:@"请输入密码"];
        return NO;
    }
    return YES;
}

- (IBAction)registAction:(id)sender
{
    [self performSegueWithIdentifier:@"toRegistView" sender:self];
}
- (IBAction)savePassAction:(id)sender {
    NSString *passStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"savePassStatus"];
   // NSString *nameStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"saveNameStatus"];
    if([passStatus isEqualToString:@"1"])
    {
        [self.savePassBtn setImage:[UIImage imageNamed:@"blueReg"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"savePassStatus"];
    }
    else
    {
        [self.savePassBtn setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"savePassStatus"];
        [self.saveNameBtn setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"saveNameStatus"];

    }
}
- (IBAction)saveNameAction:(id)sender {
   // NSString *passStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"savePassStatus"];
    NSString *passStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"saveNameStatus"];
    if([passStatus isEqualToString:@"1"])
    {
        [self.saveNameBtn setImage:[UIImage imageNamed:@"blueReg"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"saveNameStatus"];
        [self.savePassBtn setImage:[UIImage imageNamed:@"blueReg"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"savePassStatus"];
    }
    else
    {
        [self.saveNameBtn setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"saveNameStatus"];
    }

}
- (IBAction)hideThisText:(id)sender {
    [self.userName resignFirstResponder];
    [self.userPass resignFirstResponder];
}
- (IBAction)toForgetActionBtnAction:(id)sender {
    [self forgetPassAction];
}
@end
