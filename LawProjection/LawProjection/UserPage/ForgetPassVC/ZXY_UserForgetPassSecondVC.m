//
//  ZXY_UserForgetPassSecondVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserForgetPassSecondVC.h"
#import "ZXY_LawCircleView.h"
#import <AFNetworking/AFNetworking.h>
#import "ZXY_UserForgetPassThirdVC.h"
@interface ZXY_UserForgetPassSecondVC ()
{
    UIColor *allThisBlueColor;
    NSDictionary *urlParameter;
    NSTimer *timerForCheck;
    NSInteger timerCount;
    NSDictionary *nextParameter;
    
    IBOutletCollection(UIImageView) NSArray *titleImage;
}
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *checkNumText;
@property (weak, nonatomic) IBOutlet UIButton *sendAnotherNum;
- (IBAction)sendAnotherNumAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end

@implementation ZXY_UserForgetPassSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    //[self initCircleView];
    [self initNavi];
    [self initTimerAction];
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds= YES;
    for(UIImageView *iV in titleImage)
    {
        iV.layer.cornerRadius=20;
        iV.layer.masksToBounds=YES;
    }
    // Do any additional setup after loading the view.
}


- (void)initCircleView
{
    ZXY_LawCircleView *circleView = [[ZXY_LawCircleView alloc] initWithPositionY:15];
    [circleView setNumOfCircle:3];
    [circleView setCircleInfo:[NSArray arrayWithObjects:@"1",@"2",@"3", nil]];
    [circleView setSelectIndex:1];
    [circleView setSelectBackColor:[UIColor colorWithRed:59.0/255.0 green:146.0/255.0 blue:23.0/255.0 alpha:1]];
    [self.view addSubview:circleView];
}

- (void)initView
{
    self.submitBtn.layer.cornerRadius  = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.backgroundColor = NAVIBARCOLOR;
    [self setLeftNaviItem:@"back_arrow"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.checkNumText resignFirstResponder];
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
            [self.sendAnotherNum setTitle:@"重新发送手机验证码" forState:UIControlStateNormal];
            [self.sendAnotherNum setTitle:@"重新发送手机验证码" forState:UIControlStateHighlighted];
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
    NSString *phone       = [urlParameter objectForKey:@"id"];
    NSString *csrfString  = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterString = [ZXY_APIFiles encode:csrfString];
    NSString *stringURL   = [NSString stringWithFormat:@"%@%@?_csrf=%@",API_HOST_URL,API_FORGETRESEND_URL,afterString];
    if(afterString)
    {
        stringURL   = [NSString stringWithFormat:@"%@%@?_csrf=%@",API_HOST_URL,API_FORGETRESEND_URL,afterString];
    }
    else
    {
        stringURL   = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_FORGETRESEND_URL];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:phone forKey:@"reguid"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",nil]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:stringURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"startLoadDataGET responseString is %@",operation.responseString);
        NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingMutableLeaves error:nil];
        if([dicInfo.allKeys containsObject:@"error"])
        {
            NSDictionary *errorDic = [dicInfo objectForKey:@"error"];
            NSString     *message  = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:@"" andContent:message];
        }
        else
        {
            NSDictionary *allHeader = [operation.response allHeaderFields];
            NSString *csrfString    = [ZXY_APIFiles getCSRFToken:allHeader];
            [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
        }
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
        NSString *phone       = [urlParameter objectForKey:@"id"];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_FORGETPASSTWO_URL];
        NSDictionary *parameter = @{
                                    @"id"  :phone,
                                    @"code":self.checkNumText.text
                                    };
        [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
            NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if([dicInfo.allKeys containsObject:@"error"])
            {
                NSDictionary *errorDic = [dicInfo objectForKey:@"error"];
                NSString     *message  = [errorDic objectForKey:@"message"];
                [self showAlertWarnningView:@"" andContent:message];
            }
            else
            {
                nextParameter = [dicInfo objectForKey:@"data"];
                [self performSegueWithIdentifier:@"toThirdForget" sender:self];
            }
        } errorBlock:^(NSError *error) {
            ;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toThirdForget"])
    {
        ZXY_UserForgetPassThirdVC *third = [segue destinationViewController];
        [third setParaments:nextParameter withPhone:[urlParameter objectForKey:@"id"]];
    }
}


@end
