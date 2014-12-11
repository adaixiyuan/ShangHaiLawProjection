//
//  ZXY_ContractReviewVCViewController.m
//  LawProjection
//
//  Created by 宇周 on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ContractReviewVCViewController.h"

@interface ZXY_ContractReviewVCViewController ()<UIAlertViewDelegate,UIWebViewDelegate>
{
    NSDictionary *fileInfo;
    NSString     *_contractID;
    __weak IBOutlet UIWebView *_currentWeb;
}
@end

@implementation ZXY_ContractReviewVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initWebView];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    [self initSegmentItems];
}

- (void)initWebView
{
    NSString *fileID    = @"";
    NSArray  *fileArr   = [fileInfo objectForKey:@"files"];
    for(int i = 0;i<fileArr.count;i++)
    {
        NSDictionary *currentDic = [fileArr objectAtIndex:i];
        if([[currentDic objectForKey:@"contentType"] isEqualToString:@"application/msword"])
        {
            fileID = [currentDic objectForKey:@"_id"];
        }
    }
    
//    NSString *csrfString= [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
//    NSString *afterCSRF = [ZXY_APIFiles encode:csrfString];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_currentWeb loadRequest:request];
}

- (void)initSegmentItems
{
    UISegmentedControl *segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"返回修改",@"定制完成", nil]];
    [segMent setMomentary:YES];
    segMent.frame = CGRectMake(0, 0, 160, 30);
    UIColor *naviColor = NAVIBARCOLOR;
    [segMent setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:naviColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [segMent setTintColor:[UIColor whiteColor]];
    [segMent addTarget:self action:@selector(submitOrChange:) forControlEvents:UIControlEventValueChanged];
    [self setNaviTitleView:segMent];
    
}

- (void)submitOrChange:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定结束本次合同起草服务吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *fileID    = @"";
        NSArray  *fileArr   = [fileInfo objectForKey:@"files"];
        for(int i = 0;i<fileArr.count;i++)
        {
            NSDictionary *currentDic = [fileArr objectAtIndex:i];
            if([[currentDic objectForKey:@"contentType"] isEqualToString:@"application/msword"])
            {
                fileID = [currentDic objectForKey:@"_id"];
            }
        }
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CONTRACTGENERATE_URL];
        NSDictionary *parameter = @{
                                    @"id":_contractID,
                                    @"fid":fileID
                                    };
        [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
                NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if([infoDic.allKeys containsObject:@"error"])
            {
                NSDictionary *errorInfo = [infoDic objectForKey:@"error"];
                NSString     *messageString =[errorInfo objectForKey:@"message"];
                [self showAlertWarnningView:@"" andContent:messageString];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        } errorBlock:^(NSError *error) {
            
        }];

    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"load error is %@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentViewInfo:(NSDictionary *)infoDic andContractID:(NSString *)contractID
{
    _contractID = contractID;
    fileInfo = infoDic;
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
