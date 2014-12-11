//
//  ZXY_PayVC.h
//  LawProjection
//
//  Created by 宇周 on 14/11/7.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlixPayResult;
@interface Product : NSObject{
@private
    float _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *orderId;
@end

@interface ZXY_PayVC : UIViewController

@property (nonatomic, assign) SEL result;

- (void)setOrderInfo:(NSDictionary *)orderInfo andProductInfo:(NSDictionary *)productInfo withPrice:(float)price andNum:(NSString *)numString isLCY:(BOOL)isLCY;
- (void)setOrderInfo:(NSDictionary *)orderInfo andPrice:(float)price withNumString:(NSString *)numString;
- (void)setOrderInfo:(NSDictionary *)orderInfo andTitle:(NSString *)titleString andPrice:(float)price withNumString:(NSString *)numString;
-(void)paymentResult:(NSString *)result;
-(void)paymentResultApp:(AlixPayResult *)result;
@end
