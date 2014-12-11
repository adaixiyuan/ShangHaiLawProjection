//
//  ZXY_UserActiveVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-23.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserActiveVC.h"

@interface ZXY_UserActiveVC ()
{
    UIToolbar *topBar;
}
@property (weak, nonatomic) IBOutlet UITextField *cardNumLbl;
@property (weak, nonatomic) IBOutlet UITextField *passwordLbl;
@property (weak, nonatomic) IBOutlet UIButton *activeBtn;
- (IBAction)startActive:(id)sender;

@end

@implementation ZXY_UserActiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    topBar = [self toolBarWithRight:@"完成" andLeft:nil withRightBtnSel:@selector(hideKeyBoard) andLeftBtnSel:nil];
    [self.cardNumLbl setInputAccessoryView:topBar];
    [self.passwordLbl setInputAccessoryView:topBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:@"激活法率卡" withPositon:1 ];
    [self setRightNaviItem:@"home_phone"];
}

- (void)initView
{
    self.activeBtn.layer.cornerRadius = 4;
    self.activeBtn.layer.masksToBounds = YES;
}

- (void)hideKeyBoard
{
    [self.cardNumLbl resignFirstResponder];
    [self.passwordLbl resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startActive:(id)sender
{
    if([self checkUserInputInfo])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_ACTIVECARD_URL];
        NSDictionary *parameter = @{
                                    @"cardId":self.cardNumLbl.text,
                                    @"password":self.passwordLbl.text
                                    };
        [self startLoadDataGETCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if([dic.allKeys containsObject:@"error"])
            {
                NSDictionary *errorDic = [dic objectForKey:@"error"];
                NSString     *errorString = [errorDic objectForKey:@"message"];
                [self showAlertWarnningView:@"提示" andContent:errorString];
            }
            else
            {
                [self showAlertWarnningView:@"提示" andContent:@"您的法率卡已成功激活"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            ;
        } errorBlock:^(NSError *error) {
            ;
        }];
    }
}

- (BOOL)checkUserInputInfo
{
    BOOL isValidate = YES;
    NSString *messageString=@"";
    if(self.cardNumLbl.text.length == 0)
    {
        messageString = @"请填写卡号";
        isValidate = NO;
    }
    else if (self.passwordLbl.text.length == 0)
    {
        messageString = @"请填写密码";
        isValidate = NO;
    }
    else
    {
        isValidate = YES;
    }
    if(isValidate)
    {
        return YES;
    }
    else
    {
        [self showAlertWarnningView:@"" andContent:messageString];
        return NO;
    }
}
@end
