//
//  ZXY_MyCaseEvaluLawVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/23.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_MyCaseEvaluLawVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface ZXY_MyCaseEvaluLawVC ()<UITextViewDelegate>
{
    __weak IBOutlet UILabel *oneRowLbl;
    
    __weak IBOutlet UILabel *twoRowLbl;
    
    __weak IBOutlet UILabel *threeLbl;
    
    __weak IBOutlet UITextView *commentText;
    
    IBOutletCollection(UIButton) NSArray *startOneRow;
    
    IBOutletCollection(UIButton) NSArray *startTwoRow;
    
    IBOutletCollection(UIButton) NSArray *startThirdRow;
    NSString *firstScore;
    NSString *secondScore;
    NSString *thirdScore;
    
    NSString *_caseID;
}
@end

@implementation ZXY_MyCaseEvaluLawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    firstScore = @"4";
    secondScore = @"4";
    thirdScore = @"4";
    commentText.delegate = self;
    UIToolbar *topBar = [self toolBarWithRight:@"完成" andLeft:nil withRightBtnSel:@selector(hideKeyBoard) andLeftBtnSel:nil];
    [commentText setInputAccessoryView:topBar];
    commentText.layer.cornerRadius = 4;
    commentText.layer.masksToBounds= YES;
    commentText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    commentText.layer.borderWidth = 1;
    [self initNavi];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    [self setNaviTitle:@"评价律师" withPositon:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}


- (void)setCaseID:(NSString *)caseID
{
    _caseID = caseID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)firstAction:(id)sender {
    UIButton *selectBtn = (UIButton *)sender;
    NSInteger currentBtnIndex = [startOneRow indexOfObject:selectBtn];
    firstScore = [NSString stringWithFormat:@"%d",currentBtnIndex+1];
    switch (currentBtnIndex) {
        case 0:
            oneRowLbl.text = @"很不满意";
            break;
        case 1:
            oneRowLbl.text = @"不满意";
            break;
        case 2:
            oneRowLbl.text = @"一般";
            break;
        case 3:
            oneRowLbl.text = @"满意";
            break;
        case 4:
            oneRowLbl.text = @"很满意";
            break;
        default:
            break;
    }

    for(int i = 0;i<startOneRow.count;i++)
    {
        UIButton *btnn = [startOneRow objectAtIndex:i];
        if(i<=currentBtnIndex)
        {
            [btnn setImage:[UIImage imageNamed:@"yellowStar"] forState:UIControlStateNormal];
        }
        else
        {
            [btnn setImage:[UIImage imageNamed:@"grayStar"] forState:UIControlStateNormal];
        }
    }
    
}

- (IBAction)secondAction:(id)sender {
    UIButton *selectBtn = (UIButton *)sender;
    NSInteger currentBtnIndex = [startTwoRow indexOfObject:selectBtn];
    secondScore = [NSString stringWithFormat:@"%d",currentBtnIndex+1];
    switch (currentBtnIndex) {
        case 0:
            twoRowLbl.text = @"很不满意";
            break;
        case 1:
            twoRowLbl.text = @"不满意";
            break;
        case 2:
            twoRowLbl.text = @"一般";
            break;
        case 3:
            twoRowLbl.text = @"满意";
            break;
        case 4:
            twoRowLbl.text = @"很满意";
            break;
        default:
            break;
    }
    for(int i = 0;i<startTwoRow.count;i++)
    {
        UIButton *btnn = [startTwoRow objectAtIndex:i];
        if(i<=currentBtnIndex)
        {
            [btnn setImage:[UIImage imageNamed:@"yellowStar"] forState:UIControlStateNormal];
        }
        else
        {
            [btnn setImage:[UIImage imageNamed:@"grayStar"] forState:UIControlStateNormal];
        }
    }

}

- (IBAction)thirdAction:(id)sender {
    UIButton *selectBtn = (UIButton *)sender;
    NSInteger currentBtnIndex = [startThirdRow indexOfObject:selectBtn];
    thirdScore = [NSString stringWithFormat:@"%d",currentBtnIndex+1];
    switch (currentBtnIndex) {
        case 0:
            threeLbl.text = @"很不满意";
            break;
        case 1:
            threeLbl.text = @"不满意";
            break;
        case 2:
            threeLbl.text = @"一般";
            break;
        case 3:
            threeLbl.text = @"满意";
            break;
        case 4:
            threeLbl.text = @"很满意";
            break;
        default:
            break;
    }

    for(int i = 0;i<startThirdRow.count;i++)
    {
        UIButton *btnn = [startThirdRow objectAtIndex:i];
        if(i<=currentBtnIndex)
        {
            [btnn setImage:[UIImage imageNamed:@"yellowStar"] forState:UIControlStateNormal];
        }
        else
        {
            [btnn setImage:[UIImage imageNamed:@"grayStar"] forState:UIControlStateNormal];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-100, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+100, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
- (IBAction)submitAction:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASEEVALUATE];
    if(commentText.text == nil)
    {
        commentText.text = @"";
    }
    NSDictionary *parameter = @{
                                @"uid":[[UserInfoDetail sharedInstance] getUserID],
                                @"attitude":[NSNumber numberWithInt:firstScore.intValue],
                                @"professional":[NSNumber numberWithInt:secondScore.intValue],
                                @"responsibility":[NSNumber numberWithInt:thirdScore.intValue],
                                @"comment":commentText.text,
                                @"id":_caseID
                                };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];;
    [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([resDic.allKeys containsObject:@"error"])
        {
            [self showAlertWarnningView:@"提示" andContent:@"[评价失败，请联系客服。]"];
        }
        else
        {
            NSArray *allVC = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[allVC objectAtIndex:allVC.count-3] animated:YES];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
        [self showAlertWarnningView:@"提示" andContent:@"[评价失败，请联系客服。]"];
    }];
}
- (IBAction)cancelAction:(id)sender {
    NSArray *allVC = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[allVC objectAtIndex:allVC.count-3] animated:YES];
}

- (void)hideKeyBoard
{
    [commentText resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
