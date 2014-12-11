//
//  ZXY_CheckPhoneNumVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_CheckPhoneNumVC.h"
#import <AFNetworking/AFNetworking.h>
#import "ZXY_SystemRelative.h"
#import "LawEntityHelper.h"
#import "UserInfoEntity.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface ZXY_CheckPhoneNumVC ()
{
    NSTimer *timerForCheck;
    NSInteger timerCount;
    NSMutableDictionary *urlParameter;
}
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UITextField *checkNumText;
@property (weak, nonatomic) IBOutlet UIButton *sendAnotherNum;
- (IBAction)sendAnotherNumAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end

@implementation ZXY_CheckPhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initData];
    [self initTimerAction];
    [self initView];
    
    // Do any additional setup after loading the view.
}

- (void)initView
{
    self.submitBtn.layer.cornerRadius  = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.backgroundColor = NAVIBARCOLOR;
}

- (void)initData
{
    timerCount = 60;
}

- (void)initNavi
{
    //[self.navigationItem setHidesBackButton:YES ];
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"手机号码验证" withPositon:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}



- (void)initTimerAction
{
    if(timerForCheck==nil)
    {
        timerForCheck = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionForCheckBtnText) userInfo:nil repeats:YES];
        [timerForCheck fire];
    }
    else
    {
        
    }
}

- (void)timerActionForCheckBtnText
{
    if(timerCount >= 0)
    {
        [self.sendAnotherNum setEnabled:NO];
        if(![ZXY_SystemRelative isIOS8])
        {
            self.sendAnotherNum.titleLabel.text = [NSString stringWithFormat:@"%ld 秒后可重新发送",(long)timerCount];
        }
        else
        {
            [self.sendAnotherNum setTitle:[NSString stringWithFormat:@"%ld 秒后可重新发送",(long)timerCount] forState:UIControlStateNormal];
            [self.sendAnotherNum setTitle:[NSString stringWithFormat:@"%ld 秒后可重新发送",(long)timerCount] forState:UIControlStateHighlighted];
        }
    }
    else
    {
        [self.sendAnotherNum setUserInteractionEnabled:YES];
        [self.sendAnotherNum setEnabled:YES];
        if([ZXY_SystemRelative isIOS8])
        {
            [self.sendAnotherNum setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.sendAnotherNum setTitle:@"发送验证码" forState:UIControlStateHighlighted];
        }
        else
        {
            self.sendAnotherNum.titleLabel.text = @"发送验证码";
        }



        [timerForCheck invalidate];
        timerForCheck = nil;
        timerCount=60;
    }
    timerCount--;
}

- (void)sendAnotherMessage
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    NSString *phone       = [urlParameter objectForKey:@"id"];
    NSString *csrfString  = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterString = [ZXY_APIFiles encode:csrfString];
    NSString *stringURL   = [NSString stringWithFormat:@"%@%@?_csrf=%@",API_HOST_URL,API_SENDMESSAGE_URL,afterString];
    if(afterString)
    {
        stringURL   = [NSString stringWithFormat:@"%@%@?_csrf=%@",API_HOST_URL,API_SENDMESSAGE_URL,afterString];
    }
    else
    {
        stringURL   = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_SENDMESSAGE_URL];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:phone forKey:@"reguid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",nil]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:stringURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"startLoadDataGET responseString is %@",operation.responseString);
        NSDictionary *allHeader = [operation.response allHeaderFields];
        NSString *csrfString    = [ZXY_APIFiles getCSRFToken:allHeader];
        [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)sendAnotherNumAction:(id)sender {
    if(timerForCheck==nil)
    {
        timerForCheck = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionForCheckBtnText) userInfo:nil repeats:YES];
        [timerForCheck fire];
        [self sendAnotherMessage];
    }
    else
    {
        
    }
}

- (IBAction)submitAction:(id)sender
{
    if(self.checkNumText.text.length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *phone       = [urlParameter objectForKey:@"id"];
        NSString *csrfString  = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
        NSString *afterString = [ZXY_APIFiles encode:csrfString];
        NSString *stringURL = [NSString stringWithFormat:@"%@%@?_csrf=%@",API_HOST_URL,API_USERVERIFY_URL,afterString];
        [urlParameter setObject:phone forKey:@"customerId"];
        [urlParameter setObject:self.checkNumText.text forKey:@"code"];
        [self startLoadDataPOST:stringURL withParameter:urlParameter successBlock:^(NSData *responsData) {
            NSDictionary *currentDic = [NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingMutableLeaves error:nil];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([currentDic.allKeys containsObject:@"error"])
            {
                NSDictionary *errorDic = [currentDic objectForKey:@"error"];
                NSString     *message  = [errorDic objectForKey:@"message"];
                [self showAlertWarnningView:@"" andContent:message];
            }
            else
            {
               
                NSString *loginURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_USERLOGIN_URL];
                NSString *password = [urlParameter objectForKey:@"password"];
                NSString *uid      = [urlParameter objectForKey:@"mobile"];
                NSDictionary *parameter = @{
                                            @"name":uid,
                                            @"password":password
                                            };
                [self startLoadDataPOST:loginURL withParameter:parameter successBlock:^(NSData *responsData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingMutableLeaves error:nil];
                    if([dic.allKeys containsObject:@"error"])
                    {
                        NSDictionary *errorDic = [dic objectForKey:@"error"];
                        NSString *codeString   = [errorDic objectForKey:@"code"];
                        NSString *errorInfo    ;
                        if([codeString isEqualToString:@"D1006"])
                        {
                            errorInfo  =  @"密码错误";
                        }
                        if([codeString isEqualToString:@"D1004"])
                        {
                            errorInfo  =  @"账号不存在";
                        }
                        [self showAlertWarnningView:@"" andContent:errorInfo];
                    }
                    else
                    {
                        [LawEntityHelper saveUserInfo:dic];
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
                        [self showAlertWarnningView:@"提示" andContent:@"您已成功注册法率网"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }

                } errorBlock:^(NSError *errorInfo) {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
               

            }
        } errorBlock:^(NSError *errorInfo) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlertWarnningView:nil andContent:@"系统出现错误"];
        }];
    }
    else
    {
        [self showAlertWarnningView:nil andContent:@"请输入验证码"];
    }
}

- (void)setURLParameter:(NSDictionary *)parameter
{
    urlParameter = [NSMutableDictionary dictionaryWithDictionary:parameter];
}

@end
