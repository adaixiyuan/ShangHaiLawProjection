//
//  UIViewController+ZXY_VCCategory.h
//  LawProjection
//
//  Created by developer on 14-9-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 *  此类为UIViewController扩展类
 */
@interface UIViewController (ZXY_VCCategory)

/**
 *  判断一个字符串是不是数字
 *
 *  @param checkString 需要验证的字符串
 */
- (BOOL)isUserInputNum:(NSString *)checkString;

/**
 *  数字格式化城价格
 *
 *  @param  inputString 传递的数字字符串
 *
 *  @return 返回格式化之后的字符串
 */
- (NSString *)toPriceFormatter:(NSString *)inputString;
/**
 *  设置导航栏标题图片
 *
 *  @param imageName 图片名称
 */
- (void)setNaviTitleImage:(NSString *)imageName;


/**
 *  设置标题颜色
 *
 *  @param titleColor 所需要设置的标题颜色
 */
- (void)setNaviTitleColor:(UIColor *)titleColor;

/**
 *  为导航栏标题设置View
 *
 *  @param naviTitleView 用户自定义View
 */
- (void)setNaviTitleView:(UIView *)naviTitleView;

/**
 *  设置导航栏图片
 *
 *  @param imageName 图片名称
 */
- (void)setNaviBarImage:(NSString *)imageName;

/**
 *  为导航栏左面按钮设置图片
 *
 *  @param imageName 图片名称
 */
- (void)setLeftNaviItem:(NSString *)imageName;

/**
 *  为导航栏右面按钮设置图片
 *
 *  @param imageName 图片名称
 */
- (void)setRightNaviItem:(NSString *)imageName;

/**
 *  根据position取值来设置导航栏左边、标题、右边按钮的文字
 *
 *  @param title    文字内容
 *  @param position 可以取值0，1，2分别代表左边、标题、右边位置
 */
- (void)setNaviTitle:(NSString *)title withPositon:(NSInteger)position ;

/**
 *  导航栏左边按钮事件
 */
- (void)setNaviLeftAction;

/**
 *  导航栏右边按钮事件
 */
- (void)setNaviRightAction;

/**
 *  为用户的view设置圆角信息等
 *
 *  @param layView   传入的view
 *  @param cornerF   圆角参数
 *  @param lineColor 颜色
 *  @param lineWidth 线条宽度
 */
- (void)setViewLayer:(UIView *)layView withCorner:(CGFloat)cornerF byColor:(UIColor *)lineColor andLindBorder:(CGFloat)lineWidth;

/**
 *  直接弹出警告alert
 *
 *  @param titleString   标题
 *  @param contentString 内容
 */
- (void)showAlertWarnningView:(NSString *)titleString andContent:(NSString *)contentString;

/**
 *  返回toolbar
 *
 *  @param  参数见意思
 *
 *  @return 返回toolBar
 */
- (UIToolbar *)toolBarWithRight:(NSString *)rightName
                        andLeft:(NSString *)leftName
                        withRightBtnSel:(SEL)rightAction
                        andLeftBtnSel:(SEL)leftAction;
/**
 *  VC需要与服务器进行交互POST
 *
 *  @param urlString  API地址
 *  @param parameters 交互所需要的参数
 *  @param success    交互成功，服务器返回数据
 *  @param error      错误信息
 */
- (void)startLoadDataPOST:(NSString *)urlString withParameter:(NSDictionary *)parameters
         successBlock:(void(^)(NSData *responsData))success
           errorBlock:(void(^)(NSError *errorInfo))errorInfo;

/**
 *  VC需要与服务器进行交互GET
 *
 *  @param urlString  API地址
 *  @param parameters 交互所需要的参数
 *  @param success    交互成功，服务器返回数据
 *  @param error      错误信息
 */
- (void)startLoadDataGET:(NSString *)urlString withParameter:(NSDictionary *)parameters
             successBlock:(void(^)(NSData *responsData))success
               errorBlock:(void(^)(NSError *errorInfo))errorInfo;


/**
 *  VC需要与服务器进行带有csrf的字符串交互POST
 *
 *  @param urlString  API地址
 *  @param parameters 交互所需要的参数
 *  @param success    交互成功，服务器返回数据
 *  @param error      错误信息
 */
- (void)startLoadDataPOSTCSRF:(NSString *)urlString
                withPatameter:(NSDictionary *)parameters
                 successBlock:(void(^)(NSData *responseData))success
                   errorBlock:(void(^)(NSError *error))errorInfo;

/**
 *  VC需要与服务器进行带有csrf的字符串交互GET
 *
 *  @param urlString  API地址
 *  @param parameters 交互所需要的参数
 *  @param success    交互成功，服务器返回数据
 *  @param error      错误信息
 */
- (void)startLoadDataGETCSRF:(NSString *)urlString withPatameter:(NSDictionary *)parameters
                 successBlock:(void(^)(NSData *responseData))success
                   errorBlock:(void(^)(NSError *error))errorInfo;

/**
 *  VC需要与服务器进行带有csrf的字符串交互PUT
 *
 *  @param urlString  API地址
 *  @param parameters 交互所需要的参数
 *  @param success    交互成功，服务器返回数据
 *  @param error      错误信息
 */
-(void)startLoadDataPutCSRF:(NSString *)urlString
              withParameter:(NSDictionary *)parameters
               successBlock:(void(^)(NSData *responseData))success
                 errorBlock:(void(^)(NSError *error))errorInfo;

/**
 *  VC上传图片
 *
 *  @param urlString  API地址
 *  @param parameters 交互所需要的参数
 *  @param success    交互成功，服务器返回数据
 *  @param error      错误信息
 */
- (void)startUploadFileData:(NSData *)fileData
               withFileName:(NSString *)fileName
                andProgress:(NSProgress *__autoreleasing *)progress
            completeSuccess:(void (^) (NSDictionary *responseData))success
            completeError  :(void (^) (NSError *error))errorInfo;
@end
