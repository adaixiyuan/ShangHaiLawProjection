//
//  AppDelegate.m
//  LawProjection
//
//  Created by developer on 14-9-11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfoDetail.h"
#import "ZXYProvider.h"
#import "LawCityEntity.h"
#import "ZXYFileOperateHelper.h"
#import "AllServiceType.h"
#import "OrderStatusType.h"
#import "LawEntityHelper.h"
#import "LawCaseTypeEntity.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "iflyMSC/iflySetting.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "IFlyFlowerCollector.h"
#import "ZXY_PayVC.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
@interface AppDelegate ()<WXApiDelegate,TencentSessionDelegate>

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *passStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"savePassStatus"];
    NSString *nameStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"saveNameStatus"];
    if(passStatus==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"savePassStatus"];
    }
    if(nameStatus == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"saveNameStatus"];
    }
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundVerticalPositionAdjustment:-3 forBarMetrics:UIBarMetricsDefault];
    NSString *filePath = [[ZXYFileOperateHelper sharedInstance] documentPath];
    NSLog(@"文件夹位置 %@",filePath);
    NSLog(@"hello world222");
    [IFlySetting setLogFile:LVL_ALL];
    [WXApi registerApp:@"wx3408746713dcf824" ];
    [self performSelector:@selector(testLog) withObject:nil afterDelay:3];
    TencentOAuth *_tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1103506256"
                                            andDelegate:self];
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    // Override point for customization after application launch.
    //[IFlyFlowerCollector SetDebugMode:YES];
    [IFlyFlowerCollector SetCaptureUncaughtException:YES];
    [IFlyFlowerCollector SetAppid:[NSString stringWithFormat:@"%@", APPID_VALUE]];
   // [IFlyFlowerCollector SetAutoLocation:YES];

    if([[UserInfoDetail sharedInstance] isUserFirstInstall])
    {
        [self initServiceType];
        [self initPlaceJson];
        [self initOrderStatus];
        [self initCaseType];
    }
    return YES;
}

- (void) testLog
{
    NSLog(@"startstart");
    for (int i = 0; i < 1; i++)
    {
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"wx3408746713dcf824%d://",i]]];
    }
    NSLog(@"endend");
}


- (void)initServiceType
{
    NSString *serviceTypePath = [[NSBundle mainBundle]pathForResource:@"ServiceTypeJson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:serviceTypePath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *jsonArr = [jsonDic objectForKey:@"category"];
    [[ZXYProvider sharedInstance] saveDataToCoreDataArr:jsonArr withDBNam:@"AllServiceType" isDelete:YES];
    NSArray *allJson = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"AllServiceType"];
    for(AllServiceType *entity in allJson)
    {
        NSLog(@"name is %@",entity.name);
    }
}

- (void)initPlaceJson
{
    NSString *placeJsonPath = [[NSBundle mainBundle] pathForResource:@"lawCity" ofType:@"json"];
    NSData   *jsonData      = [NSData dataWithContentsOfFile:placeJsonPath];
    NSDictionary  *jsonDic       = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *jsonArr = [jsonDic objectForKey:@"data"];
    [[ZXYProvider sharedInstance] saveDataToCoreDataArr:jsonArr withDBNam:@"LawCityEntity" isDelete:YES];
    NSArray *allJson = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCityEntity"];
    for(LawCityEntity *entity in allJson)
    {
        NSLog(@"name is %@",entity.name);
        
    }
}

- (void)initOrderStatus
{
    NSString *placeJsonPath = [[NSBundle mainBundle] pathForResource:@"OrderStatusJson" ofType:@"json"];
    NSData   *jsonData      = [NSData dataWithContentsOfFile:placeJsonPath];
    NSDictionary  *jsonDic       = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *jsonArr = [jsonDic objectForKey:@"data"];
    [[ZXYProvider sharedInstance] saveDataToCoreDataArr:jsonArr withDBNam:@"OrderStatusType" isDelete:YES];
    NSArray *allJson = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"OrderStatusType"];
    for(OrderStatusType *entity in allJson)
    {
        NSLog(@"name is %@",entity.statusName);
        
    }

}

- (void)initCaseType
{
    NSString *placeJsonPath = [[NSBundle mainBundle] pathForResource:@"CaseTypeJson" ofType:@"json"];
    NSData   *jsonData      = [NSData dataWithContentsOfFile:placeJsonPath];
    NSDictionary  *jsonDic       = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *jsonDatas = [jsonDic objectForKey:@"data"];
    NSArray      *items     = [jsonDatas objectForKey:@"items"];
    [LawEntityHelper saveCaseType:items];
    NSArray *allJson = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"LawCaseTypeEntity"];
    for(LawCaseTypeEntity *entity in allJson)
    {
        NSLog(@"name is %@",entity.name);
        
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    NSString *strUrl = @"http://dajdklajdka?";
    //    url = [NSURL URLWithString:strUrl];
    NSString *scheme = [url scheme];
    if([scheme isEqualToString:@"ApliURL"])
    {
        [self parse:url application:application];
        return YES;
    }
    else if([scheme isEqualToString:@"wx3408746713dcf824"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }

#if __QQAPI_ENABLE__
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQAPIDemoEntry class]];
#endif
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Where from" message:url.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        //[alertView show];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *scheme = [url scheme];
    if([scheme isEqualToString:@"ApliURL"])
    {
        [self parse:url application:application];
        return YES;
    }
    else if([scheme isEqualToString:@"wx3408746713dcf824"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
#if __QQAPI_ENABLE__
    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQAPIDemoEntry class]];
#endif
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}


-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
       
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
            }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg;
        if(resp.errCode == 0)
        {
             strMsg = [NSString stringWithFormat:@"分享成功"];
        }
        else
        {
             strMsg = @"分享失败";
        }
        //NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      
    }
}


- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    if(self.currentPayVC)
    {
        [self.currentPayVC paymentResultApp:result];
    }
//    if (result)
//    {
//        
//        if (result.statusCode == 9000)
//        {
//            /*
//             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//             */
//            
//            //交易成功
//                        NSString* key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCa8VS/HSkSSVUYRp/0kJfNuReuT13F/KmqOfBU Fyv3u8g0NL61fmPIdz1DLzD5NmNAjHpYYOZEkB3r4tuq6MJmXuzlj10ESk9VZF83EIcpxVgdaVvk Jrzp6d1NnFl3lSJt9YcFCgcOUhUef1c9BEg69x2FkKF7MBI5Rzb1ZyMjgwIDAQAB";
//            			id<DataVerifier> verifier;
//                        verifier = CreateRSADataVerifier(key);
//            
//            			if ([verifier verifyString:result.resultString withSign:result.signString])
//                        {
//                            NSLog(@"交易成功 -- >%@",result.resultString);
//                            //验证签名成功，交易结果无篡改
//            			}
//            
//        }
//        else
//        {
//            //交易失败
//            NSLog(@"交易失败 -- >%@",result.resultString);
//        }
//    }
//    else
//    {
//        //失败
//        NSLog(@"交易失败 -- >%@",result.resultString);
//    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
    return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
    AlixPayResult * result = nil;
    
    if (url != nil && [[url host] compare:@"safepay"] == 0) {
        result = [self resultFromURL:url];
    }
    
    return result;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "duostec.self.LawProjection" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LawProjection" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LawProjection.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
