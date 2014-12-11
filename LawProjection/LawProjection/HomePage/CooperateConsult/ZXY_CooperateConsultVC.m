//
//  ZXY_CooperateConsultVC.m
//  LawProjection
//
//  Created by developer on 14-9-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_CooperateConsultVC.h"
#import "ZXY_Coor_SubCell.h"
#import "ZXY_Coor_TabCell.h"
#import "ZXY_Coor_DataCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZXY_PayVC.h"
#import "ZXY_UserLoginVC.h"
@interface ZXY_CooperateConsultVC ()<UITableViewDataSource,UITableViewDelegate,TabDelegate,SubCellDelegate>
{
    __weak IBOutlet UITableView *currentTable;
    NSArray *dataForTable;
    BOOL isNormal;
    UIButton *specialBtn;
    UIButton *normalBtn;
    NSDictionary *nomarlDic;
    NSDictionary *specialDic;
    IBOutlet UIView *detailView;
    __weak IBOutlet UIImageView *detailImage;
    __weak IBOutlet UILabel *detailTitle;
    __weak IBOutlet UILabel *detailInfo;
    BOOL isShow;
    UIView *backView;
}
@end

@implementation ZXY_CooperateConsultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self initData];
    [self initNavi];
    [self startLoadMore];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self setNaviTitleImage:@"home_law"];
    [self setRightNaviItem:@"home_phone"];
    [self setLeftNaviItem:@"back_arrow"];
}

- (void)initData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"CooperateConsultPlist" withExtension:@"plist"];
    dataForTable = [NSArray arrayWithContentsOfURL:url];
    isNormal = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return dataForTable.count;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = [dataForTable objectAtIndex:indexPath.row];
    UITableViewCell *returnCell;
    if(indexPath.section == 0)
    {
        ZXY_Coor_TabCell *tabCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierTab];
        specialBtn = tabCell.specalBtn;
        normalBtn  = tabCell.normalBtn;
        tabCell.delegate = self;
        returnCell = tabCell;
    }
    else if(indexPath.section == 1)
    {
        ZXY_Coor_DataCell *dataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierData];
        dataCell.image_title.image = [UIImage imageNamed:[dataDic valueForKey:@"pic_name"]];
        dataCell.consultLbl.text   = [dataDic valueForKey:@"title"];
        if(isNormal)
        {
            dataCell.numLbl.text   = [dataDic valueForKey:@"normal"];
        }
        else
        {
            dataCell.numLbl.text   = [dataDic valueForKey:@"special"];
        }
        returnCell = dataCell
        ;
    }
    else
    {
        ZXY_Coor_SubCell *subCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierSub];
        subCell.delegate = self;
        returnCell = subCell ;
    }
    return returnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 60   ;
    }
    else if(indexPath.section == 1)
    {
        return 52;
    }
    else
    {
        return 52;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isShow)
    {
        return;
    }
    if(indexPath.section == 1)
    {
        NSDictionary *currentDid = [dataForTable objectAtIndex:indexPath.row];
        [self showDetailViewAlert:currentDid];
    }
}

- (void)showDetailViewAlert:(NSDictionary *)detailDic
{
    isShow = YES;
    if(backView == nil)
    {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backView.opaque = NO;
        UIImageView *backGr = [[UIImageView alloc] initWithFrame:backView.frame];
        [backView addSubview:backGr];
        backGr.backgroundColor = [UIColor lightGrayColor];
        backGr.alpha = 0.6;
    }
    [detailView setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
    //detailView.center = self.view.center;
    detailImage.image = [UIImage imageNamed:detailDic[@"pic_name"]];
    detailTitle.text  = detailDic[@"title"];
    detailInfo.text   = detailDic[@"description"];
    [backView addSubview:detailView];
    [self.view addSubview:backView];
    detailView.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        [detailView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished) {
        //[self.view setUserInteractionEnabled:NO];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetailAlert)];
        [detailView addGestureRecognizer:tap];
    }];
    
}

- (void)hideDetailAlert
{
    isShow = NO;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        [detailView setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
    } completion:^(BOOL finished) {
        [self.view setUserInteractionEnabled:YES];
        [backView removeFromSuperview];
        [detailView removeFromSuperview];
    }];

}

- (void)coorTabBarChanged:(BOOL)_isNormal
{
    if(isShow)
    {
        return;
    }
    isNormal = _isNormal;
    [currentTable reloadData];
}

- (void)submitBuyInfoDelegate
{
    NSString *subInfo = @"普通版";
    if(!isNormal)
    {
        subInfo = @"加强版";
    }
    NSLog(@"%@",subInfo);
    [self buyAction:nil];
}

- (void)startLoadMore
{
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_USER_SERVICELISTSINGLE];
    NSDictionary *dicParameter = @{
                                   @"nameId":@"PPN002"
                                   };
    [self startLoadDataGETCSRF:stringURL withPatameter:dicParameter successBlock:^(NSData *responseData) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        specialDic = responseDic;
        NSNumber *price = [responseDic[@"data"][@"items"] objectAtIndex:0][@"price"];
        NSString *specialString = [NSString stringWithFormat:@"尊享版%@元/年",price];
        [specialBtn setTitle:specialString forState:UIControlStateNormal];
        [specialBtn setTitle:specialString forState:UIControlStateHighlighted];
        [self startLoadNormal];
        
    } errorBlock:^(NSError *error) {
        ;
    }];
}

- (void)startLoadNormal
{
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_USER_SERVICELISTSINGLE];
    NSDictionary *dicParameter = @{
                                   @"nameId":@"PPN001"
                                   };
    [self startLoadDataGETCSRF:stringURL withPatameter:dicParameter successBlock:^(NSData *responseData) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        nomarlDic  = responseDic;
        NSNumber *price = [responseDic[@"data"][@"items"] objectAtIndex:0][@"price"];
        NSString *specialString = [NSString stringWithFormat:@"标准版%@元/年",price];
        [normalBtn setTitle:specialString forState:UIControlStateNormal];
        [normalBtn setTitle:specialString forState:UIControlStateHighlighted];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
    }];
}

- (IBAction)buyAction:(id)sender
{
    
    NSString *_id ;
    NSArray *items ;
    if(isNormal)
    {
        items = nomarlDic[@"data"][@"items"];
    }
    else
    {
        items = specialDic[@"data"][@"items"];
    }
    
    for(int i =0 ;i<items.count;i++)
    {
        _id = [[items objectAtIndex:i] objectForKey:@"_id"];
    }
    NSString *uid = [[UserInfoDetail sharedInstance] getUserID];
    NSString *countString = @"1";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_BUYACTION_GETINFO];
    NSDictionary *parameter;
    @try {
        parameter = @{
                                    @"productId":_id,
                                    @"type":@"product",
                                    @"uid":uid,
                                    @"count":[NSNumber numberWithInt:countString.intValue]
                                    };
    }
    @catch (NSException *exception) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserLoginVC *loginVC = [story instantiateViewControllerWithIdentifier:@"userLoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;

    }
    @finally {
        
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([returnDic.allKeys containsObject:@"error"])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *errorDic = [returnDic objectForKey:@"error"];
            NSString     *message  = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:@"" andContent:message];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *orderInfo = [returnDic objectForKey:@"data"];
            UIStoryboard *story     = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
            ZXY_PayVC    *payVC     = [story instantiateViewControllerWithIdentifier:@"payV"];
            if(isNormal)
            {
                //items = nomarlDic[@"data"][@"items"];
                NSString *priceString = [nomarlDic[@"data"][@"items"]objectAtIndex:0][@"price"];
                [payVC setOrderInfo:orderInfo andProductInfo:nomarlDic[@"data"] withPrice:priceString.floatValue andNum:@"1" isLCY:NO];
                
            }
            else
            {
                //items = specialDic[@"data"][@"items"];
                NSString *priceString = [specialDic[@"data"][@"items"]objectAtIndex:0][@"price"];
                [payVC setOrderInfo:orderInfo andProductInfo:specialDic[@"data"] withPrice:priceString.floatValue andNum:@"1" isLCY:NO];
            }

            [self.navigationController pushViewController:payVC animated:YES];
            
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWarnningView:@"提示" andContent:@"出现错误"];
    }];
    
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
