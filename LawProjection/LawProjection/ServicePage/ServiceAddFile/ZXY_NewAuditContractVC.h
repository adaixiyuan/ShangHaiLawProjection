//
//  ZXY_NewAuditContractVC.h
//  LawProjection
//
//  Created by 宇周 on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
@class IFlyRecognizerView;
@class PopupView;
@interface ZXY_NewAuditContractVC : UIViewController<IFlyRecognizerViewDelegate>
- (void)setAuditInfo:(NSDictionary *)dicInfo;
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;

@property (nonatomic,strong) PopupView          * popView;

@end
