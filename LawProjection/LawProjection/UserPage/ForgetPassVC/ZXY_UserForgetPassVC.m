//
//  ZXY_UserForgetPassVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserForgetPassVC.h"

#import "ZXY_LawCircleView.h"
#import "ZXY_UserForgetPassSecondVC.h"

@interface ZXY_UserForgetPassVC ()<UITextFieldDelegate>
{
    UIColor *allThisBlueColor;
    __weak IBOutlet UITextField *userName;
    __weak IBOutlet UITextField *userPhone;
    NSDictionary *phoneDic;
    IBOutletCollection(UIImageView) NSArray *titleImage;
}
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;


@end

@implementation ZXY_UserForgetPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
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
}

- (void)initThisView
{
    allThisBlueColor                      = [UIColor colorWithRed:25.0/255.0 green:194.0/255.0 blue:254.0/255.0 alpha:1];
    self.nextStepBtn.backgroundColor      = allThisBlueColor;
    self.nextStepBtn.layer.cornerRadius   = 4;
    self.nextStepBtn.layer.masksToBounds  = YES;
    
}

- (void)initCircleView
{
    ZXY_LawCircleView *circleView = [[ZXY_LawCircleView alloc] initWithPositionY:15];
    [circleView setNumOfCircle:3];
    [circleView setCircleInfo:[NSArray arrayWithObjects:@"1",@"2",@"3", nil]];
    [circleView setSelectIndex:0];
    [circleView setSelectBackColor:allThisBlueColor];
    [self.view addSubview:circleView];
    
}


- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setNaviTitle:@"忘记密码" withPositon:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == userPhone)
    {
        if([self isUserInputNum:string]||[string isEqualToString:@"\n"])
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userName resignFirstResponder];
    [userPhone resignFirstResponder];
    
}
- (IBAction)nextStepAction:(id)sender {
    NSLog(@"hello world");
    UITextField *currentText = (UITextField *)sender;
    if(currentText == userName)
    {
        [userPhone becomeFirstResponder];
    }
    else
    {
        [self nextStepActionBTN:nil];
    }
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


- (IBAction)nextStepActionBTN:(id)sender
{
    if([self checkUserInput])
    {
        NSString *urlString     = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_FORGETPASSONE_URL];
        NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userName.text,@"username",userPhone.text,@"id", nil];
        [self startLoadDataPOST:urlString withParameter:parameter successBlock:^(NSData *responsData) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingMutableLeaves error:nil];
            if([responseDic.allKeys containsObject:@"error"])
            {
                NSDictionary *errorDic       = [responseDic objectForKey:@"error"];
                NSString     *messageString  = [errorDic objectForKey:@"message"];
                [self showAlertWarnningView:nil andContent:messageString];
                
            }
            else
            {
                phoneDic= [NSDictionary dictionaryWithObject:userPhone.text forKey:@"id"];
                [self performSegueWithIdentifier:@"toCheckPhoneNumVC" sender:self];
            }
        } errorBlock:^(NSError *errorInfo) {
            
        }];
        
    }
}

- (BOOL)checkUserInput
{
    BOOL isValidate = YES;
    NSString *errorInfo;
    if(userName.text.length == 0)
    {
        errorInfo = @"请输入用户名";
        isValidate = NO;
    }
    else if(userPhone.text.length != 11||![self isUserInputNum:userPhone.text])
    {
        errorInfo = @"请输入正确的手机号码";
        isValidate = NO;
    }
    if(isValidate)
    {
        return YES;
    }
    else
    {
        [self showAlertWarnningView:nil andContent:errorInfo];
        return NO;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toCheckPhoneNumVC"])
    {
        ZXY_UserForgetPassSecondVC *secondVC = [segue destinationViewController];
        [secondVC setURLParameter:phoneDic];
    }
}



@end
