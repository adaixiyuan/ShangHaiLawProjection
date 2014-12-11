//
//  ZXY_PayVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/7.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_PayVC.h"
#import "ZXY_PayOneCell.h"
#import "ZXY_PayTwoCell.h"
#import "UIImage+Resize.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LCYUploader.h"
#import "ZXY_WebVC.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"
#import "ZXY_WebForPay.h"
#import "AppDelegate.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"

@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end


@interface ZXY_PayVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UPPayPluginDelegate>
{
    __weak IBOutlet UIButton *submitForOff;
    NSDictionary *_orderInfo;
    NSDictionary *_productInfo;
    NSInteger    payType;
    IBOutlet UIView *offLineView;
    IBOutlet UIView *oneLineView;
    __weak IBOutlet UILabel *aliPayLBL;
    __weak IBOutlet UILabel *uniPayLBL;
    __weak IBOutlet UILabel *orderNumLBL;
    NSDictionary *imageDic;
    __weak IBOutlet UITableView *currentTable;
    CGSize  _kImageMaxSize ;
    BOOL isFirst;
    Product *_product;
    BOOL isSuccess;
    SEL _result;
    UIAlertView *alertViews;
    __weak IBOutlet UILabel *orderName;
    __weak IBOutlet UILabel *orderNum;
    __weak IBOutlet UILabel *orderPrice;
    __weak IBOutlet UIButton *aliBtn;
    __weak IBOutlet UIButton *uniBtn;
    __weak IBOutlet UIImageView *confrimImage;
    NSString *_productName;
    NSString *_productCost;
    NSString *_productNum;
    NSInteger payTypes;/**< 支付方式 1.支付宝支付 2.银联支付 0.没有选择*/
    NSString *uniOrderPay;
}
@property (weak, nonatomic) IBOutlet UIButton *confrimPaybtn;
- (IBAction)submitAction:(id)sender;
@property (nonatomic,strong)UIImagePickerController *imagePicker;
@end

@implementation ZXY_PayVC
@synthesize result = _result;
- (void)viewDidLoad {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.currentPayVC = self;
    [super viewDidLoad];
    isFirst = YES;
    [self initNavi];
    [self initSegmentItems];
    payType =0;
    _kImageMaxSize = CGSizeMake(300, 300);
    _result = @selector(paymentResult:);
    [self initThisView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    self.confrimPaybtn.layer.cornerRadius = 4;
    self.confrimPaybtn.layer.masksToBounds=YES;
    [super viewWillAppear:animated];
    if(isFirst)
    {
        isFirst = NO;
        [self.view addSubview:oneLineView];
        orderNumLBL.text = [NSString stringWithFormat:@"订单号：%@",[_orderInfo objectForKey:@"num"] ];
    }
}

- (void)initThisView
{
    orderName.text = _productName;
    orderPrice.text = [NSString stringWithFormat:@"应付金额：%@",[self toPriceFormatter:_productCost]];
    if(_productNum)
    {
        orderNum.text= [NSString stringWithFormat:@"购买数量：%@",_productNum];
    }
    else
    {
        [orderNum setHidden:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
}

- (void)setOrderInfo:(NSDictionary *)orderInfo andProductInfo:(NSDictionary *)productInfo withPrice:(float)price andNum:(NSString *)numString isLCY:(BOOL)isLCY
{
    if(!isLCY)
    {
        
        _orderInfo = orderInfo;
        _productInfo = productInfo;
        _product = [[Product alloc] init];
        NSDictionary *options = [_productInfo objectForKey:@"options"];
        NSDictionary *cateDic = [options objectForKey:@"category"];
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *name ;
        NSArray *items = [_productInfo objectForKey:@"items"];
        for(int i =0 ;i<cateDic.allKeys.count;i++)
        {
            name = [cateDic objectForKey:[cateDic.allKeys objectAtIndex:i]];
        }
        _product.subject   = [NSString stringWithFormat:@"【法率网】%@ X %@",[name objectForKey:@"name"],numString ];
        _product.body      = [NSString stringWithFormat:@"【法率网】%@ X %@",[_productInfo objectForKey:@"name"], productInfo[@"count"]];
        _product.orderId   = [_orderInfo objectForKey:@"_id"];
        _product.price     = price;
        _productName       = _product.subject;
        _productCost       = [NSString stringWithFormat:@"%f",price];
        _productNum = numString;
    }
    else
    {
        _orderInfo = orderInfo;
        _productInfo = [productInfo objectForKey:@"$product"];
        _product = [[Product alloc] init];
        _product.subject = [NSString stringWithFormat:@"【法率网】%@ X %@",[_productInfo objectForKey:@"name"], productInfo[@"count"]];
        _product.body = [NSString stringWithFormat:@"【法率网】%@ X %@",[_productInfo objectForKey:@"name"], productInfo[@"count"]];
        _product.orderId  = [_orderInfo objectForKey:@"_id"];
        _product.price    = price;
        _productName       = _product.subject;
        _productCost       = [NSString stringWithFormat:@"%f",price];
        _productNum = productInfo[@"count"];
    }
}

- (void)setOrderInfo:(NSDictionary *)orderInfo andTitle:(NSString *)titleString andPrice:(float)price withNumString:(NSString *)numString
{
    _orderInfo = orderInfo;
    _product = [[Product alloc] init];
    _product.subject   = titleString;
    _product.body      = titleString;
    _product.orderId   = [_orderInfo objectForKey:@"_id"];
    _product.price     = price;
    
    _productName       = _product.subject;
    _productCost       = [NSString stringWithFormat:@"%f",price];
    _productNum = @"1";
}

- (void)setOrderInfo:(NSDictionary *)orderInfo andPrice:(float)price withNumString:(NSString *)numString
{
    _orderInfo = orderInfo;
    _product = [[Product alloc] init];
    _product.subject   = @"案件委托";
    _product.body      = @"案件委托";
    _product.orderId   = [_orderInfo objectForKey:@"_id"];
    _product.price     = price;
    
    _productName       = _product.subject;
    _productCost       = [NSString stringWithFormat:@"%f",price];
    _productNum = numString;

}

- (void)initSegmentItems
{
    UISegmentedControl *segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"在线支付",@"线下支付", nil]];
    [segMent setSelectedSegmentIndex:0];
    segMent.frame = CGRectMake(0, 0, 160, 30);
    UIColor *naviColor = NAVIBARCOLOR;
    [segMent setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:naviColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [segMent setTintColor:[UIColor whiteColor]];
    [segMent addTarget:self action:@selector(choosePayMethod:) forControlEvents:UIControlEventValueChanged];
    [self setNaviTitleView:segMent];
    
}

- (void)choosePayMethod:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0)
    {
        payType =0;
        //[self.view addSubview:oneLineView];
        [oneLineView setHidden:NO];
        [currentTable setHidden:YES];
        [submitForOff setHidden:YES];
        //[offLineView removeFromSuperview];
    }
    else
    {
        payType =1;
        //[oneLineView removeFromSuperview];
        [oneLineView setHidden:YES];
        [currentTable setHidden:NO];
        [submitForOff setHidden:NO];
       // [self.view addSubview:offLineView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 5;
    }
    else
    {
        if(imageDic == nil)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    if(section == 0)
    {
        return 69;
    }
    else
    {
        if(imageDic == nil)
        {
            return 47;
        }
        else
        {
            if(row == 0)
            {
                return 69;
            }
            else
            {
                return 47;
            }
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXY_PayOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:PayOneCellID];
    ZXY_PayTwoCell *twoCell = [tableView dequeueReusableCellWithIdentifier:PayTwoCellID];
    NSInteger currentRow     = indexPath.row;
    NSInteger currentSection = indexPath.section;
    if(currentSection == 0)
    {
        if(currentRow == 0)
        {
            oneCell.titleLBL.text = @"订单号";
            oneCell.valueLBL.text = [_orderInfo objectForKey:@"num"];
            return oneCell;
        }
        else if (currentRow == 1)
        {
            oneCell.titleLBL.text = @"银行类型";
            oneCell.valueLBL.text = @"民生银行";
            return oneCell;
        }
        else if (currentRow == 2)
        {
            oneCell.titleLBL.text = @"银行账户";
            oneCell.valueLBL.text = @"627032090";
            return oneCell;
        }
        else if (currentRow == 3)
        {
            oneCell.titleLBL.text = @"开户名";
            oneCell.valueLBL.text = @"上海法率信息技术有限公司";
            return oneCell;
        }
        else
        {
            oneCell.titleLBL.text = @"开户行地址";
            oneCell.valueLBL.text = @"中国民生银行股份有限公司上海普陀支行";
            return oneCell;
        }
    }
    else
    {
        if(imageDic == nil)
        {
            return twoCell;
        }
        else
        {
            if(currentRow == 0)
            {
                oneCell.titleLBL.text = @"文件名称";
                oneCell.valueLBL.text = [imageDic objectForKey:@"fileName"];
                return oneCell;
            }
            else
            {
                return twoCell;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(imageDic == nil)
        {
            [self pickImage];
        }
        else
        {
            if(indexPath.row == 0)
            {
                ZXY_WebVC *web = [[ZXY_WebVC alloc] init];
                NSString *stringURL = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,[imageDic objectForKey:@"fileId"]];
                [web setDownLoadURL:stringURL];
                [self.navigationController pushViewController:web animated:YES];
            }
            else
            {
                [self pickImage];
            }
        }
    }
}

- (void)pickImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照后上传", @"从相册上传", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 拍照后上传
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        // 从相册上传
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    UIImage *scaledImage = [UIImage imageWithImage:pickedImage scaledToFitToSize:_kImageMaxSize];
    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *timeString = [formatter stringFromDate:date];
    
    NSString *fileName = [NSString stringWithFormat:@"iOS%@.jpg", timeString];
    
    [self uploadImageData:imageData withName:fileName];
}

- (void)uploadImageData:(NSData *)imageData withName:(NSString *)name {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在上传"];
    __weak __typeof(self) weakSelf = self;
    [[LCYUploader sharedInstance] uploadImageData:imageData progress:nil fileName:name successBlock:^(NSDictionary *object) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSString *fileName = object[@"data"][0][@"name"];
        NSString *fileID = object[@"data"][0][@"_id"];
        if (!fileName || !fileID) {
            [self showAlertWarnningView:@"" andContent:@"出现错误！"];
        } else {
            imageDic = @{
                         @"fileName":fileName,
                         @"fileId"  :fileID
                         };
            [currentTable reloadData];
        }
    } failedBlock:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         [self showAlertWarnningView:@"" andContent:@"出现错误！"];
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

// !!!:先下支付
- (IBAction)submitAction:(id)sender {
    if(imageDic == nil)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请上传付款凭证"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_PROF_URL];
    NSDictionary *dataPara = @{
                               @"payProof":[NSArray arrayWithObject:imageDic]
                               };
    
    NSDictionary *idPara   = @{
                               @"id":[_orderInfo objectForKey:@"_id"],
                               @"data":dataPara
                               };
//    [self startLoadDataPOSTCSRF:stringURL withPatameter:idPara successBlock:^(NSData *responseData) {
//        ;
//    } errorBlock:^(NSError *error) {
//        
//    }];
    [self startLoadDataPutCSRF:stringURL withParameter:idPara successBlock:^(NSData *responseData) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dicIngo = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([dicIngo.allKeys containsObject:@"error"])
        {
            NSDictionary *errorDic = [dicIngo objectForKey:@"error"];
            [self showAlertWarnningView:@"提示" andContent:[errorDic objectForKey:@"message"]];
            
        }
        else
        {
            [self showAlertWarnningView:@"提示" andContent:@"凭证上传成功，请等待法率网的开通服务通知。"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertWarnningView:@"提示" andContent:@"出现错误"];
    }];
}

 // !!!:支付宝支付相关
- (IBAction)alyPayAction:(id)sender
{
    if(payTypes == 0 || payTypes == 2)
    {
        [aliBtn setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
        [uniBtn setImage:[UIImage imageNamed:@"blueReg"] forState:UIControlStateNormal];
        payTypes = 1;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 612)
    {
        if(buttonIndex == 0)
        {
            if(isSuccess)
            {
                [self showAlertWarnningView:@"提示" andContent:@"支付成功"];
                [self successPay];
            }
            else
            {
                [self showAlertWarnningView:@"提示" andContent:@"支付失败"];
            }
        }
        else
        {
            [self showAlertWarnningView:@"提示" andContent:@"支付失败"];
        }
    }
}

- (void)successPay
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_SUCCESSPAY_URL];
    NSDictionary *parameter = @{
                                @"orderId":[_orderInfo objectForKey:@"id"]
                                };
    [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([returnDic.allKeys containsObject:@"error"])
        {
            NSDictionary *errorDic = [returnDic objectForKey:@"error"];
            NSString *errorString  = [errorDic objectForKey:@"message"];
            [self showAlertWarnningView:@"提示" andContent:errorString];
        }
        else
        {
            [self showAlertWarnningView:@"提示" andContent:@"购买成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } errorBlock:^(NSError *error) {
        [self showAlertWarnningView:@"提示" andContent:@"支付失败，请联系客服"];
;
    }];
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //结果处理
//#if ! __has_feature(objc_arc)
//    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
//#else
//    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
//#endif
    AlixPayResult *result = [[AlixPayResult alloc] initWithString:resultd];
    //[alertViews dismissWithClickedButtonIndex:1 animated:YES];
    if (resultd)
    {
        
        if (result.statusCode == 9000)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            //交易失败
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"交易失败 -- >%@",result.resultString);
            NSString *message = [NSString stringWithFormat:@"%@",result.statusMessage];
            [self showAlertWarnningView:@"提示" andContent:message];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            isSuccess = NO;
        }
    }
    else
    {
        //失败
        NSLog(@"交易失败 -- >%@",result.statusMessage);
        NSString *message = [NSString stringWithFormat:@"%@",result.statusMessage];
        [self showAlertWarnningView:@"提示" andContent:message];
        isSuccess = NO;
    }
    
}

- (void)paymentResultApp:(AlixPayResult *)resultd
{
    if (resultd)
    {
        
        if (resultd.statusCode == 9000)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            //交易失败
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"交易失败 -- >%@",resultd.resultString);
            NSString *message = [NSString stringWithFormat:@"%@",resultd.statusMessage];
            [self showAlertWarnningView:@"提示" andContent:message];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            isSuccess = NO;
        }
    }
    else
    {
        //失败
        NSLog(@"交易失败 -- >%@",resultd.statusMessage);
        NSString *message = [NSString stringWithFormat:@"%@",resultd.statusMessage];
        [self showAlertWarnningView:@"提示" andContent:message];
        isSuccess = NO;
    }

}

//- (void)payFinish
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_FINISHPAY_URL];
//    NSDictionary *parameter = @{
//                                @"orderId":[_orderInfo objectForKey:@"_id"],
//                                };
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self startLoadDataPOSTCSRF:urlString withPatameter:parameter successBlock:^(NSData *responseData) {
//        NSDictionary *allDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
//        if([allDic.allKeys containsObject:@"error"])
//        {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [self showAlertWarnningView:@"提示" andContent:@"支付失败，请联系客服人员"];
//        }
//        else
//        {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//             [self showAlertWarnningView:@"提示" andContent:@"支付成功"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    } errorBlock:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
//    }];
//}

-(NSString*)getOrderInfo
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //Product *product = [[Product alloc] init];
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.returnUrl = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_APLRETURN_URL];
    order.tradeNO = _product.orderId; //订单ID（由商家自行制定）
    order.productName = _product.subject; //商品标题
    order.productDescription = _product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",_product.price]; //商品价格
    order.notifyURL =  [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_APLINOTY_URL]; //回调URL
    
    return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}
//
-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}
//- (IBAction)onLinePayAction:(id)sender
//{
//    [self performSegueWithIdentifier:@"toPayWeb" sender:self];
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"toPayWeb"])
//    {
//        ZXY_WebForPay *webForPay = [segue destinationViewController];
//        [webForPay setThisURLParameter:_orderInfo];
//    }
//}
- (IBAction)uniPayAction:(id)sender
{
    if(payTypes == 0 || payTypes == 1)
    {
        [uniBtn setImage:[UIImage imageNamed:@"blueRegSelect"] forState:UIControlStateNormal];
        [aliBtn setImage:[UIImage imageNamed:@"blueReg"] forState:UIControlStateNormal];
        payTypes = 2;
    }

}

- (IBAction)confirmPayAction:(id)sender {
    if(payTypes == 0)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请选择支付方式。"];
        return;
    }
    else if (payTypes == 1)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_APLMOREsECURITY_URL];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_product.orderId,@"orderId", nil];
        [self startLoadDataGETCSRF:urlString withPatameter:parameters successBlock:^(NSData *responseData) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *appScheme = @"ApliURL";
            NSString* orderInfo = [self getOrderInfo];
            NSString* signedStr = [self doRsa:orderInfo];
            
            NSLog(@"%@",signedStr);
            
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderInfo, signedStr, @"RSA"];
            
            [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];;
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
        }];
        
    }
    else
    {
        //[self showAlertWarnningView:@"提示" andContent:@"银联支付功能暂时还没有"];
        [self startUniPay];
    }
}


- (void)startUniPay
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_UNIPAY_URL];
    NSDictionary *parameter = @{
                                @"orderId":_orderInfo[@"_id"]
                                };
    [self startLoadDataGETCSRF:stringURL withPatameter:parameter successBlock:^(NSData *responseData) {
        NSDictionary *currentDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        if([currentDic.allKeys containsObject:@"error"])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
            [self showAlertWarnningView:@"提示" andContent:@"获取订单信息失败"];
        }
        else
        {
            NSDictionary *dataDic = [currentDic objectForKey:@"data"];
            NSString     *tnString = [dataDic objectForKey:@"tn"];
            NSString     *modeType = [dataDic objectForKey:@"transType"];
            [UPPayPlugin startPay:tnString mode:@"00" viewController:self delegate:self];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];;
    }];
}

-(void)UPPayPluginResult:(NSString*)result
{
    NSLog(@"%@",result);
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *message = @"";
    if([result isEqualToString:@"cancel"])
    {
        message = @"用户取消操作。";
        [self showAlertWarnningView:@"提示" andContent:message];
    }
    else if ([result isEqualToString:@"success"])
    {
        message = @"支付成功。";
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        message = @"支付失败，请联系客服人员。";
        [self showAlertWarnningView:@"提示" andContent:message];
    }
    
//    if([result isEqualToString:@"success"])
//    {
//        [self payFinish];
//    }
}
@end
