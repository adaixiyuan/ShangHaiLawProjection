//
//  ZXY_ServiceContractAddVC.h
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
@class IFlyRecognizerView;
@class PopupView;
@interface ZXY_ServiceContractAddVC : UIViewController<IFlyRecognizerViewDelegate>
- (void)setStatus:(NSString *)statusString;
- (void)isDetailView:(NSDictionary *)detailDic;
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;

@property (nonatomic,strong) PopupView          * popView;
@end
