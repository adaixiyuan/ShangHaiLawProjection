//
//  ZXY_UserServiceDetailInfoVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-25.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserServiceDetailInfoVC.h"
#import "OrderStatusType.h"
#import "AllServiceType.h"

@interface ZXY_UserServiceDetailInfoVC ()
{
    __weak IBOutlet UILabel *orderCode;
    
    __weak IBOutlet UILabel *orderStatus;
    
    __weak IBOutlet UILabel *orderTime;
    
    __weak IBOutlet UILabel *orderNameNum;
    
    __weak IBOutlet UILabel *orderPrice;
    
    __weak IBOutlet UILabel *orderName;
    
    __weak IBOutlet UILabel *orderFirst;
    
    __weak IBOutlet UILabel *orderNorms;
    
    IBOutletCollection(UILabel) NSArray *orderOthers;
    
    IBOutletCollection(UILabel) NSArray *orderNormOthers;
    
    __weak IBOutlet UILabel *orderBuySum;
    
    __weak IBOutlet UILabel *orderSinglePrice;
    
    __weak IBOutlet UIButton *fpOrFkBtn;
    
    NSDictionary *orderInfoDetail ;
}
- (IBAction)fpOrFkAction:(id)sender;

@end

@implementation ZXY_UserServiceDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self startLoadData];
    // Do any additional setup after loading the view.
}




- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:@"订单详情" withPositon:1 ];
    [self setRightNaviItem:@"home_phone"];
}


- (void)setUserOrderInfoDic:(NSDictionary *)userDic
{
    orderInfoDetail = [NSDictionary dictionaryWithDictionary:userDic];
}

- (void)startLoadData
{
    NSString *numOfNum = [orderInfoDetail objectForKey:@"num"];
    NSString *timeDate = [orderInfoDetail objectForKey:@"createAt"];
    NSNumber *countNum  = [orderInfoDetail objectForKey:@"count"];
    NSNumber *amountNum = [orderInfoDetail objectForKey:@"amount"];
    NSString *statusId  = [orderInfoDetail objectForKey:@"status"];
    NSNumber *singlePrice = [orderInfoDetail objectForKey:@"price"];
    NSArray  *statusArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"OrderStatusType" withContent:statusId andKey:@"statusID"];
    NSDictionary *productDic = [orderInfoDetail objectForKey:@"$product"];
    NSDictionary *optionsDic = [productDic objectForKey:@"options"];
    NSDictionary *categoryName = [optionsDic objectForKey:@"category"];
    NSDictionary *subCate      = [categoryName objectForKey:[productDic objectForKey:@"nameId"]];
    NSString     *serviceType  = [subCate objectForKey:@"categoryId"];
    if(statusArr.count)
    {
        OrderStatusType *orderType = [statusArr objectAtIndex:0];
        orderStatus.text           = orderType.statusName;
    }
    orderName.text          = [subCate objectForKey:@"name"];
    orderCode.text          = [NSString stringWithFormat:@"订单编号：%@",numOfNum];
    orderNameNum.text       = [NSString stringWithFormat:@"%@ X%@",[subCate objectForKey:@"name"],countNum.stringValue];
    orderPrice.text         = [NSString stringWithFormat:@"金额：%@ 元",[amountNum stringValue]];
    orderTime.text          = [NSString stringWithFormat:@"下单时间：%@",timeDate];
    orderBuySum.text        = [NSString stringWithFormat:@"购买数量：%@",countNum.stringValue];
    orderSinglePrice.text   = [NSString stringWithFormat:@"单价：%@",singlePrice];
    if([serviceType hasPrefix:@"PPN"])
    {
        orderFirst.text = @"法律咨询";
        orderNorms.text = @"无限次";
        NSArray *otherArr = [NSArray arrayWithObjects:@"签发律师函",@"合同起草",@"合同审核",@"法律培训", nil];
        
        if([serviceType isEqualToString:@"PPN001"])
        {
            for(UILabel *subLbl in orderOthers)
            {
                NSArray *otherNormArr = [NSArray arrayWithObjects:@"2 份",@"8 份",@"8 份",@"2 项", nil];
                NSInteger index = [orderOthers indexOfObject:subLbl];
                NSString *title = [otherArr objectAtIndex:index];
                subLbl.text = title;
                UILabel *normsLbl = [orderNormOthers objectAtIndex:index];
                normsLbl.text     = [otherNormArr objectAtIndex:index];
            }
        }
        else
        {
            
            for(UILabel *subLbl in orderOthers)
            {
                NSArray *otherNormArr = [NSArray arrayWithObjects:@"6 份",@"15 份",@"15 份",@"6 项", nil];
                NSInteger index = [orderOthers indexOfObject:subLbl];
                NSString *title = [otherArr objectAtIndex:index];
                subLbl.text = title;
                UILabel *normsLbl = [orderNormOthers objectAtIndex:index];
                normsLbl.text     = [otherNormArr objectAtIndex:index];
            }

        }
    }
    else
    {
        if([orderName.text isEqualToString:@"法律咨询"])
        {
            orderNorms.text = @"60 分钟";
        }
        else
        {
            NSArray *serviceArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"AllServiceType" withContent:serviceType andKey:@"categoryId"];
            if(serviceArr.count >0)
            {
                AllServiceType *allType = [serviceArr objectAtIndex:0];
                orderNorms.text = [NSString stringWithFormat:@"1 %@",allType.value];
            }
        }
        for(UILabel *subLbl in orderOthers)
        {
            NSInteger index = [orderOthers indexOfObject:subLbl];
            [subLbl setHidden:YES];
            UILabel *normsLbl = [orderNormOthers objectAtIndex:index];
            [normsLbl setHidden:YES];
        }
        
    }
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

- (IBAction)fpOrFkAction:(id)sender {
}
@end
