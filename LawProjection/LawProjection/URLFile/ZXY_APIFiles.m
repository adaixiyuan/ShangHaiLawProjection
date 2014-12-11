//
//  ZXY_APIFiles.m
//  LawProjection
//
//  Created by developer on 14-9-23.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_APIFiles.h"
NSString *const API_HOST_URL        = @"http://42.192.0.11:4001/";
NSString *const API_AUDIT_URL       = @"contractAudit/list";
NSString *const API_CONTRACT_URL    = @"contract/list";
NSString *const API_LETTERLIST_URL  = @"letter/list";
NSString *const API_USERLOGIN_URL   = @"user/quickLogin";
NSString *const API_USERREGISTCHECK_URL = @"user/validate" ;
NSString *const API_SERVICE_LIST_URL= @"service/sumList";
NSString *const API_SERVICE_ALL_TYPE= @"service/list";
NSString *const API_SERVICE_LETTER  = @"letter/list";
NSString *const API_USER_ORDERLIST  = @"order/list";
NSString *const API_USER_LAWTRAIN   = @"train/list";
NSString *const API_USER_SERVICELISTSINGLE = @"product/list";
NSString *const API_USER_CASE_LIST  = @"case/list";
NSString *const API_CASEMONEY_URL   = @"case/computeCost";
NSString *const API_CASEADD_URL     = @"case/add";
NSString *const API_CASEDETAIL_URL  = @"case/getDetail";
NSString *const API_CASEUPDATE_URL  = @"case/update";
NSString *const API_CASECANCEL_URL  = @"case/cancel";
NSString *const API_CASEENSURE_URL  = @"case/pay";
NSString *const API_CASECONFIRM_URL = @"case/confirm";
NSString *const API_CASEEVALUATE    = @"case/appraiseLawyer";
NSString *const API_CASEDIFER       = @"case/object";

NSString *const API_USER_LAWCONSULT = @"consult/list";
NSString *const API_DRAFTLIST_URL   = @"contract/list";
NSString *const API_AUDITLIST_URL   = @"contractAudit/list";
NSString *const API_ORDERDETAIL_URL = @"order/getDetail";
NSString *const API_LAWERLIST_URL   = @"lawyer/list";
NSString *const API_SENDMESSAGE_URL = @"user/resendSMS";
NSString *const API_USERVERIFY_URL  = @"user/verify";
NSString *const API_CAPTCODE_URL    = @"captcha/****";
NSString *const API_PRODUCTDETAIL_URL = @"product/getDetail";
NSString *const API_FORGETPASSONE_URL = @"user/forget/step1ForAPP";
NSString *const API_FORGETPASSTWO_URL = @"user/forget/step2";
NSString *const API_FORGETPASSTHREE_URL = @"user/forget/step3";

NSString *const API_FORGETRESEND_URL  = @"user/forgetResendSMS";
NSString *const API_RESETPASS_URL     = @"user/update";

NSString *const API_USERLOGOUT_URL    = @"user/logout";
NSString *const API_CATEGORY_URL      = @"category/list";
NSString *const API_ADDCONTRACT_URL   = @"contract/add";
NSString *const API_CHECKCONTRACT_URL = @"contract/findLegalDoc";
NSString *const API_CONTRACTUPDATE_URL= @"contract/update";
NSString *const API_CONTRACTQUESTION_URL = @"legaldoc/get";
NSString *const API_CONTRACTPREVIEW_URL  = @"contract/preview";
NSString *const API_CONTRAcTVIEWPDF_URL  = @"file/viewPdf";
NSString *const API_CONTRACTGENERATE_URL = @"contract/generate";
NSString *const API_CONTRACTAUDITADD_URL = @"contractAudit/add";
NSString *const API_REVIEWUPDATE_URL     = @"contractAudit/update";
NSString *const API_CONTRACTANQUES_URL   = @"legaldoc/get";

NSString *const API_UPDATEUSERINFO_URL   = @"user/update";
NSString *const API_ACTIVECARD_URL       = @"activateCard/activate";

NSString *const API_DOWNLOAD_URL      = @"file/download.json";

NSString *const API_BUYACTION_GETINFO = @"order/add";
NSString *const API_APLINOTY_URL      = @"pay/notify";
NSString *const API_APLRETURN_URL     = @"pay/return";
NSString *const API_FINISHPAY_URL     = @"order/finishPay";
NSString *const API_CANCEL_URL        = @"order/update";
NSString *const API_APLMOREsECURITY_URL = @"order/getSafeCloudByAPP";
NSString *const API_ORDERDETAILTEMPLETE_URL   = @"invoice/getOneByOrder";

NSString *const API_PROF_URL          = @"order/uploadProof";
NSString *const API_SUCCESSPAY_URL    = @"order/finishPay";
NSString *const API_LETTERADD_URL     = @"letter/add";
NSString *const API_LETTERUPDATE_URL  = @"letter/update";
NSString *const API_LALALA_URL        = @"http://42.192.0.11:4001/file/categoryFile?category=lawyerContractTemplate";

NSString *const API_UNIPAY_URL        = @"order/getOrderTn";

@implementation ZXY_APIFiles
static ZXY_APIFiles *currentInstance=nil;
+(ZXY_APIFiles *)mainApi
{
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(currentInstance == nil)
        {
            currentInstance = [[super allocWithZone:NULL] init];
        }
    });
    return currentInstance;
}

// !!!:实例化
+ (id)allocWithZone:(NSZone *)zone
{
    return [self mainApi];
}

+ (id)copyWithZone:(NSZone *)zone
{
    return [self mainApi];
}

+ (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self mainApi];
}

- (id)mutableCopy
{
    return [[ZXY_APIFiles alloc] init];
}

- (id)copy
{
    return [[ZXY_APIFiles alloc] init];
}

- (id)init
{
    if(currentInstance)
    {
        return currentInstance;
    }
    else
    {
        self = [super init];
        return self;
    }
}
// !!!:实例化结束
+ (NSString*) encode:(NSString *)string
{
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (__bridge CFStringRef)string,
                                                                                NULL,
                                                                                (CFStringRef)@"!*'();:@&=+$,./?%#[]",
                                                                                kCFStringEncodingUTF8);
}

+ (NSString*) getCSRFToken:(NSDictionary *)dic
{
    NSString *csrfString ;
    if([dic.allKeys containsObject:@"csrftoken"])
    {
        csrfString = [dic objectForKey:@"csrftoken"];
    }
    else
    {
        csrfString = @"error";
    }
    return csrfString;
}
@end
