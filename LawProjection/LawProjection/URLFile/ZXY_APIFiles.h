//
//  ZXY_APIFiles.h
//  LawProjection
//
//  Created by developer on 14-9-23.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
FOUNDATION_EXPORT NSString *const API_HOST_URL;/**< 数据传输主要接口*/
FOUNDATION_EXPORT NSString *const API_AUDIT_URL; /**< 审核中的合同 */
FOUNDATION_EXPORT NSString *const API_CONTRACT_URL; /**< 合同起草一览 */
FOUNDATION_EXPORT NSString *const API_LETTERLIST_URL;   /**< 签发律师函*/
FOUNDATION_EXPORT NSString *const API_USERLOGIN_URL; /**< 用户登录*/
FOUNDATION_EXPORT NSString *const API_USERREGISTCHECK_URL ; /**< 用户注册之前的验证 */
FOUNDATION_EXPORT NSString *const API_SERVICE_LIST_URL; /**< 用户所有的服务*/
FOUNDATION_EXPORT NSString *const API_SERVICE_ALL_TYPE; /**< 用户所有服务类型*/
FOUNDATION_EXPORT NSString *const API_SERVICE_LETTER  ; /**< 获取签发律师函*/
FOUNDATION_EXPORT NSString *const API_USER_ORDERLIST      ; /**< 用户订单*/
FOUNDATION_EXPORT NSString *const API_USER_LAWTRAIN   ; /**< 用户的法律培训 */
FOUNDATION_EXPORT NSString *const API_USER_LAWCONSULT ; /**< 用户的法律咨询*/
FOUNDATION_EXPORT NSString *const API_USER_SERVICELISTSINGLE ; /**< 单项法律服务 法律咨询ST0001 签发律师函ST0002 合同审核ST0004 法律培训ST0005 合同定制ST0002 标准版PPN001 尊享版PPN002*/
FOUNDATION_EXPORT NSString *const API_USER_CASE_LIST ; /**< 我的案件一览*/
FOUNDATION_EXPORT NSString *const API_CASEMONEY_URL ; /**< 我的案件计算起诉金额*/
FOUNDATION_EXPORT NSString *const API_CASEADD_URL;    /**< 新增我的案件*/
FOUNDATION_EXPORT NSString *const API_CASEDETAIL_URL; /**< 案件详情*/
FOUNDATION_EXPORT NSString *const API_CASEUPDATE_URL; /**< 更新案件*/
FOUNDATION_EXPORT NSString *const API_CASECANCEL_URL  ;/**< 撤销委托*/
FOUNDATION_EXPORT NSString *const API_CASEENSURE_URL;  /**< 确定委托*/
FOUNDATION_EXPORT NSString *const API_CASECONFIRM_URL; /**< 确认并付款*/
FOUNDATION_EXPORT NSString *const API_CASEEVALUATE;   /**< 评估律师*/
FOUNDATION_EXPORT NSString *const API_CASEDIFER;     /**< 提出异议*/

FOUNDATION_EXPORT NSString *const API_AUDITLIST_URL ; /**< 合同审核一览*/
FOUNDATION_EXPORT NSString *const API_DRAFTLIST_URL; /**< 合同起草一览*/
FOUNDATION_EXPORT NSString *const API_ORDERDETAIL_URL; /**< 获取订单详细*/
FOUNDATION_EXPORT NSString *const API_LAWERLIST_URL  ; /**< 获取律师组信息*/
FOUNDATION_EXPORT NSString *const API_SENDMESSAGE_URL; /**< 用户根据电话号码发送信息*/
FOUNDATION_EXPORT NSString *const API_USERVERIFY_URL;  /**< 用户注册第二页面验证*/
FOUNDATION_EXPORT NSString *const API_CAPTCODE_URL  ; /**< 获取图片验证码*/

FOUNDATION_EXPORT NSString *const API_FORGETPASSONE_URL ; /**< 忘记密码第一步骤 */
FOUNDATION_EXPORT NSString *const API_FORGETPASSTWO_URL ; /**< 忘记密码第二步骤 */
FOUNDATION_EXPORT NSString *const API_FORGETPASSTHREE_URL ; /**< 忘记密码第三步骤 */
FOUNDATION_EXPORT NSString *const API_FORGETRESEND_URL  ; /**< 忘记密码重新发送验证码*/
FOUNDATION_EXPORT NSString *const API_RESETPASS_URL     ; /**< 用户修改密码*/

FOUNDATION_EXPORT NSString *const API_USERLOGOUT_URL    ; /**< 用户注销*/

FOUNDATION_EXPORT NSString *const API_CATEGORY_URL      ; /**< 类别接口*/
FOUNDATION_EXPORT NSString *const API_PRODUCTDETAIL_URL; /**< 获取产品关于用户*/
FOUNDATION_EXPORT NSString *const API_ADDCONTRACT_URL   ; /**< 增加合同起草*/
FOUNDATION_EXPORT NSString *const API_CHECKCONTRACT_URL; /**< 合同起草模板校验*/
FOUNDATION_EXPORT NSString *const API_CONTRACTUPDATE_URL;/**< 合同起草提交答案*/
FOUNDATION_EXPORT NSString *const API_CONTRACTQUESTION_URL;/**< 没有答题的合同继续答题*/
FOUNDATION_EXPORT NSString *const API_CONTRACTPREVIEW_URL;/**< 预览合同/contract/preview*/
FOUNDATION_EXPORT NSString *const API_CONTRAcTVIEWPDF_URL; /**< 预览与提交*/
FOUNDATION_EXPORT NSString *const API_CONTRACTGENERATE_URL;/**< 合同生成*/
FOUNDATION_EXPORT NSString *const API_CONTRACTANQUES_URL;/**< 答案和显示*/
FOUNDATION_EXPORT NSString *const API_CANCEL_URL;/**< 订单取消*/
FOUNDATION_EXPORT NSString *const API_APLMOREsECURITY_URL;/**< 高额支付安全云*/

FOUNDATION_EXPORT NSString *const API_UPDATEUSERINFO_URL ; /**< 更改用户信息*/
FOUNDATION_EXPORT NSString *const API_CONTRACTAUDITADD_URL;/**< 合同审核增加*/
FOUNDATION_EXPORT NSString *const API_CONTRACTAUDIT_URL;/**< */
FOUNDATION_EXPORT NSString *const API_REVIEWUPDATE_URL ;/**< 合同审核更新*/
FOUNDATION_EXPORT NSString *const API_ACTIVECARD_URL;/**< 激活法律卡*/
FOUNDATION_EXPORT NSString *const API_ORDERDETAILTEMPLETE_URL;/**< 订单模板*/

FOUNDATION_EXPORT NSString *const API_DOWNLOAD_URL    ; /**< 文件下载*/

FOUNDATION_EXPORT NSString *const API_BUYACTION_GETINFO ;/**< 生成订单*/
FOUNDATION_EXPORT NSString *const API_SUCCESSPAY_URL;/**< 订单完成*/
FOUNDATION_EXPORT NSString *const API_APLINOTY_URL; /**< 支付宝的noti*/
FOUNDATION_EXPORT NSString *const API_PROF_URL ;/**< 上传付款凭证*/
FOUNDATION_EXPORT NSString *const API_APLRETURN_URL;/**< 支付宝return*/
FOUNDATION_EXPORT NSString *const API_FINISHPAY_URL;/**< 完成支付*/

FOUNDATION_EXPORT NSString *const API_LETTERADD_URL ;/**< 增加律师函*/
FOUNDATION_EXPORT NSString *const API_LETTERUPDATE_URL; /**< 更新律师函*/
FOUNDATION_EXPORT NSString *const API_LALALA_URL ;

FOUNDATION_EXPORT NSString *const API_UNIPAY_URL;/**< 银联获取订单号的接口*/
@interface ZXY_APIFiles : NSObject
+(ZXY_APIFiles *)mainApi;
+ (NSString*) encode:(NSString *)string;
+ (NSString*) getCSRFToken:(NSDictionary *)dic;
@end
