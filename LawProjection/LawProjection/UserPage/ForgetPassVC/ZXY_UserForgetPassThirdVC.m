//
//  ZXY_UserForgetPassThirdVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserForgetPassThirdVC.h"
#import "ZXY_LawCircleView.h"
@interface ZXY_UserForgetPassThirdVC ()
{
    UIColor *allThisBlueColor;
    NSDictionary *parameter;
    __weak IBOutlet UITextField *passText;
    __weak IBOutlet UITextField *confirmPass;
    NSString *phoneStirng;
    
    IBOutletCollection(UIImageView) NSArray *titleImage;
}
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
- (IBAction)submitAction:(id)sender;
@end

@implementation ZXY_UserForgetPassThirdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initThisView];
    //[self initCircleView];
    [self initNavi];
    self.nextStepBtn.layer.cornerRadius = 4;
    self.nextStepBtn.layer.masksToBounds=YES;
    for(UIImageView *iV in titleImage)
    {
        iV.layer.cornerRadius=20;
        iV.layer.masksToBounds=YES;
    }
    // Do any additional setup after loading the view.
}

- (void)initThisView
{
    allThisBlueColor = [UIColor colorWithRed:25.0/255.0 green:194.0/255.0 blue:254.0/255.0 alpha:1];
    self.nextStepBtn.backgroundColor = allThisBlueColor;
}

- (void)initCircleView
{
    ZXY_LawCircleView *circleView = [[ZXY_LawCircleView alloc] initWithPositionY:15];
    [circleView setNumOfCircle:3];
    [circleView setCircleInfo:[NSArray arrayWithObjects:@"1",@"2",@"3", nil]];
    [circleView setSelectIndex:2];
    [circleView setSelectBackColor:[UIColor colorWithRed:27.0/255.0 green:195.0/255.0 blue:143.0/255.0 alpha:1]];
    [self.view addSubview:circleView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [passText resignFirstResponder];
    [confirmPass resignFirstResponder];
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"忘记密码" withPositon:1];
}

- (void)setParaments:(NSDictionary *)dicInfo withPhone:(NSString *)phone;
{
    parameter = dicInfo;
    phoneStirng = phone;
}

- (BOOL)isPassValidate
{
    BOOL isPassValidate = YES;
    if(passText.text.length < 6||passText.text.length>20)
    {
        isPassValidate = NO;
        [self showAlertWarnningView:@"" andContent:@"密码为6-20个字符，应同时包含数字和字母。"];
    }
    else if(![passText.text isEqualToString:confirmPass.text])
    {
        isPassValidate = NO;
        [self showAlertWarnningView:@"" andContent:@"两次输入的密码不一致"];
    }
    else if(![self isPassValidate:passText.text])
    {
        isPassValidate = NO;
    }
    else
    {
        isPassValidate = YES;
    }
    return isPassValidate;
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

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [passText resignFirstResponder];
//    [confirmPass resignFirstResponder];
//}

- (IBAction)submitAction:(id)sender
{
    if([self isPassValidate])
    {
        NSString *urlString      = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_FORGETPASSTHREE_URL];
        NSString *_uid           = [parameter objectForKey:@"uid"];
        NSDictionary *parameters  =  @{
                                      @"_id"      :_uid,
                                      @"id"       :phoneStirng,
                                      @"password" :passText.text
                                      };
        [self startLoadDataPOSTCSRF:urlString withPatameter:parameters successBlock:^(NSData *responseData) {
            NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if([dicInfo.allKeys containsObject:@"error"])
            {
                NSDictionary *errorDic = [dicInfo objectForKey:@"error"];
                NSString     *message  = [errorDic objectForKey:@"message"];
                [self showAlertWarnningView:@"" andContent:message];
            }
            else
            {
                [self showAlertWarnningView:@"" andContent:@"密码修改成功"];
                [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:1] animated:YES];
                
            }

        } errorBlock:^(NSError *error) {
            ;
        }];
    }
}
@end
