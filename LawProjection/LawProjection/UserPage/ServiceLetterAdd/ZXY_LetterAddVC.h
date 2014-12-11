//
//  ZXY_LetterAddVC.h
//  LawProjection
//
//  Created by 宇周 on 14/11/11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
@class IFlyRecognizerView;
@class PopupView;

@interface ZXY_LetterAddVC : UIViewController<UITableViewDataSource,UITableViewDelegate,IFlyRecognizerViewDelegate>
- (void)setLetterDetail:(NSDictionary *)letterDic ;
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;

@property (nonatomic,strong) PopupView          * popView;

@end
