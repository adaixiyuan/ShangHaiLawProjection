//
//  UIViewController+ZXY_VCCategory.m
//  LawProjection
//
//  Created by developer on 14-9-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "UIViewController+ZXY_VCCategory.h"
#import <AFNetworking/AFNetworking.h>
#import "ZXY_SystemRelative.h"
@implementation UIViewController (ZXY_VCCategory)
#pragma mark - 数据处理
- (BOOL)isUserInputNum:(NSString *)checkString
{
    BOOL isNum = YES;
    NSCharacterSet *checkSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
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

#pragma mark - 页面处理
- (void)setNaviTitleImage:(NSString *)imageName
{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.navigationItem.titleView = imageV;
}

- (void)setNaviTitleView:(UIView *)naviTitleView
{
    self.navigationItem.titleView = naviTitleView;
}

- (void)setNaviBarImage:(NSString *)imageName
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:imageName] forBarMetrics:UIBarMetricsDefault];
}

- (void)setLeftNaviItem:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [leftBtn setImage:image forState:UIControlStateNormal];
    //[leftBtn setImage:image forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(setNaviLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setRightNaviItem:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [leftBtn setImage:image forState:UIControlStateNormal];
    //[leftBtn setImage:image forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(setNaviRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setNaviTitleColor:(UIColor *)titleColor
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleColor,NSForegroundColorAttributeName, nil]];
}

- (void)setNaviTitle:(NSString *)title withPositon:(NSInteger)position
{
    if(position == 1)
    {
        self.title = title;
       
        return;
    }
    else if (position == 0)
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 60, 40)];
        [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [leftBtn setTitle:title forState:UIControlStateNormal];
        [leftBtn setTitle:title forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(setNaviLeftAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
        self.navigationItem.leftBarButtonItem = item;
        return;
    }
    else
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 80 , 40)];
//        leftBtn.layer.cornerRadius = 4;
//        leftBtn.layer.masksToBounds= YES;
//        leftBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        leftBtn.layer.borderWidth  = 1;
        [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [leftBtn setTitle:title forState:UIControlStateNormal];
        [leftBtn setTitle:title forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(setNaviRightAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.rightBarButtonItem = item;

        return;
    }
}

- (void)setNaviLeftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNaviRightAction
{
   
    NSString *phoneNumber = @"4008607766";
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (void)setViewLayer:(UIView *)layView withCorner:(CGFloat)cornerF byColor:(UIColor *)lineColor andLindBorder:(CGFloat)lineWidth
{
    layView.layer.cornerRadius = cornerF;
    layView.layer.borderWidth  = lineWidth;
    layView.layer.borderColor  =lineColor.CGColor;
    layView.layer.masksToBounds = YES;
}

- (void)showAlertWarnningView:(NSString *)titleString andContent:(NSString *)contentString
{
    UIAlertView *alertWar = [[UIAlertView alloc] initWithTitle:titleString message:contentString delegate:nil cancelButtonTitle:ZXY_VALUES_WARN otherButtonTitles:nil, nil];
    [alertWar show];
    
    //UIAlertController *alert = [[UIAlertController alloc] init]
}


- (UIToolbar *)toolBarWithRight:(NSString *)rightName andLeft:(NSString *)leftName withRightBtnSel:(SEL)rightAction andLeftBtnSel:(SEL)leftAction{
    
    
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    topBar.barTintColor = [UIColor colorWithRed:221.0/255.0 green:245.0/255.0 blue:254.0/255.0 alpha:1];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 80, 40);
    [leftBtn setTitle:leftName forState:UIControlStateNormal];
    if(leftAction)
    {
        [leftBtn addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 80, 40);
    [rightBtn setTitle:rightName forState:UIControlStateNormal];
    if(rightAction)
    {
        [rightBtn addTarget:self action:rightAction forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *spaceFlex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *leftBtnItem  = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    NSArray *array = [NSArray arrayWithObjects:leftBtnItem,spaceFlex,rightBtnItem, nil];
    [topBar setItems:array];
    return topBar;
}

#pragma mark - 数据加载
- (void)startLoadDataPOST:(NSString *)urlString withParameter:(NSDictionary *)parameters successBlock:(void (^)(NSData *))success errorBlock:(void (^)(NSError *))errorInfo
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/plain", nil]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"startLoadDataGET responseString is %@",operation.responseString);
        if(success)
        {
            NSDictionary *allHeader = [operation.response allHeaderFields];
            NSString *csrfString    = [ZXY_APIFiles getCSRFToken:allHeader];
            [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
            success(operation.responseData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"startLoadDataPOST error is %@",error);
        if(errorInfo)
        {
           errorInfo(error);
        }
    }];
}

- (void)startLoadDataGET:(NSString *)urlString withParameter:(NSDictionary *)parameters successBlock:(void (^)(NSData *))success errorBlock:(void (^)(NSError *))errorInfo
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/plain", nil]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"startLoadDataGET responseString is %@",operation.responseString);
        if(success)
        {
            NSDictionary *allHeader = [operation.response allHeaderFields];
            NSString *csrfString    = [ZXY_APIFiles getCSRFToken:allHeader];
            [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
            success(operation.responseData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"startLoadDataGET error is %@",error);
        if(errorInfo)
        {
            errorInfo(error);
        }
    }];
}

- (void)startLoadDataPOSTCSRF:(NSString *)urlString withPatameter:(NSDictionary *)parameters successBlock:(void (^)(NSData *))success errorBlock:(void (^)(NSError *))errorInfo
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *csrfString  = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterString = [ZXY_APIFiles encode:csrfString];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?_csrf=%@",afterString]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/plain",@"application/json", nil]];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"startLoadDataGET responseString is %@",operation.responseString);
        if(success)
        {
            NSDictionary *allHeader = [operation.response allHeaderFields];
            NSString *csrfString    = [ZXY_APIFiles getCSRFToken:allHeader];
            [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
            success(operation.responseData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"startLoadDataPOST error is %@",error);
        if(errorInfo)
        {
            errorInfo(error);
        }
    }];

}

- (void)startLoadDataGETCSRF:(NSString *)urlString withPatameter:(NSDictionary *)parameters successBlock:(void (^)(NSData *))success errorBlock:(void (^)(NSError *))errorInfo
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *csrfString  = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterString = [ZXY_APIFiles encode:csrfString];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?_csrf=%@",afterString]];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/plain", nil]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"startLoadDataGET responseString is %@",operation.responseString);
        if(success)
        {
            NSDictionary *allHeader = [operation.response allHeaderFields];
            NSString *csrfString    = [ZXY_APIFiles getCSRFToken:allHeader];
            [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
            success(operation.responseData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"startLoadDataGET error is %@",error);
        if(errorInfo)
        {
            errorInfo(error);
        }
    }];

}

-(void)startLoadDataPutCSRF:(NSString *)urlString withParameter:(NSDictionary *)parameters successBlock:(void(^)(NSData *))success errorBlock:(void(^)(NSError *))errorInfo
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *csrfString  = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterString = [ZXY_APIFiles encode:csrfString];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?_csrf=%@",afterString]];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/plain", nil]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"startLoadDataPUT responseString is %@",operation.responseString);
        if(success)
        {
            NSDictionary *allHeader = [operation.response allHeaderFields];
            NSString *csrfString    = [ZXY_APIFiles getCSRFToken:allHeader];
            [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
            success(operation.responseData);
        }
;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"startLoadDataPUT error is %@",error);
        if(errorInfo)
        {
            errorInfo(error);
        }
    }];
    
}

- (void)startUploadFileData:(NSData *)fileData withFileName:(NSString *)fileName andProgress:(NSProgress *__autoreleasing *)progress completeSuccess:(void (^)(NSDictionary *))success completeError:(void (^)(NSError *))errorInfo
{
    if(![ZXY_SystemRelative isNetAvilible])
    {
        [self showAlertWarnningView:@"提示" andContent:@"当前无网络连接"];
        return;
    }
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    NSString *URLString = [API_HOST_URL stringByAppendingString:[NSString stringWithFormat:@"file/upload.json?_csrf=%@",afterCSRF]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
    } error:nil];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  if (error) {
                                                                      NSLog(@"Error in progress: %@", error);
                                                                      if (errorInfo) {
                                                                          dispatch_async(dispatch_get_main_queue(),^{errorInfo(error);});
                                                                      }
                                                                  } else {
                                                                      NSDictionary *dic = responseObject;
                                                                      NSLog(@"response object = %@", dic);
                                                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                                      NSString *token = httpResponse.allHeaderFields[@"csrftoken"];
                                                                      if (token) {
                                                                          [[UserInfoDetail sharedInstance] setOthersInfo:token withKey:ZXY_VALUES_CSRF];
                                                                      }
                                                                      
                                                                      if (success) {
                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                              success(dic);
                                                                          });
                                                                      }
                                                                  }
                                                              }];
    
    [uploadTask resume];

};

- (NSString *)toPriceFormatter:(NSString *)inputString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:inputString.intValue]];
    
    
    NSLog(@"Formatted number string:%@",string);
    return string;
}
@end
