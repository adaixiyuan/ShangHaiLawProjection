//
//  ZXY_MyCaseDifferentVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/23.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_MyCaseDifferentVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface ZXY_MyCaseDifferentVC ()<UITextViewDelegate>
{
    NSString *_caseID;
    IBOutletCollection(UIButton) NSArray *buttonS;
    __weak IBOutlet UIButton *submitBtn;
    __weak IBOutlet UIButton *cancelBtn;
    __weak IBOutlet UITextView *commentText;
    NSString *indexString;
}
@end

@implementation ZXY_MyCaseDifferentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    commentText.delegate = self;
    UIToolbar *topBar = [self toolBarWithRight:@"完成" andLeft:nil withRightBtnSel:@selector(hideKeyBoard) andLeftBtnSel:nil];
    [commentText setInputAccessoryView:topBar];
    [self initNavi];
    commentText.layer.cornerRadius = 4;
    commentText.layer.masksToBounds = YES;
    commentText.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    commentText.layer.borderWidth = 1;
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    [self setNaviTitle:@"提出异议" withPositon:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyBoard
{
    [commentText resignFirstResponder];
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


- (void)setCaseID:(NSString *)caseID
{
    _caseID = caseID;
}

- (IBAction)buttonSelect:(id)sender {
    UIButton *currentBtn = (UIButton *)sender;
    NSInteger indexOfBtn = [buttonS indexOfObject:currentBtn];
    indexString = [NSString stringWithFormat:@"%d",indexOfBtn+1];
    if(indexOfBtn == 3)
    {
        [commentText setEditable:YES];
        commentText.userInteractionEnabled = YES;
        commentText.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        [commentText setEditable:NO];
        commentText.userInteractionEnabled = NO;
        commentText.backgroundColor = [UIColor lightGrayColor];
    }
    for(UIButton *bb in buttonS)
    {
        if(bb == currentBtn)
        {
            [bb setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
        }
        else
        {
            [bb setImage:[UIImage imageNamed:@"blueReg"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)submitAction:(id)sender {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CASEDIFER];
    if(indexString == nil)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请选择提出异议的理由。"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if(commentText.text == nil)
    {
        commentText.text = @"";
    }
    NSDictionary *parameter = @{
                                @"id":_caseID,
                                @"objection":indexString,
                                @"objectionNote":commentText.text
                                };
    [self startLoadDataPutCSRF:urlString withParameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([resDic.allKeys containsObject:@"error"])
        {
            [self showAlertWarnningView:@"提示" andContent:@"[提出失败，请联系客服。]"];
        }
        else
        {
            NSArray *allVC = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[allVC objectAtIndex:allVC.count-3] animated:YES];
        }
;
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
         [self showAlertWarnningView:@"提示" andContent:@"[提出失败，请联系客服。]"];
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
