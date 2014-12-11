//
//  ZXY_SecondSectionDetailInfoVC.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    SecondLetterType=0,
    SecondAuditType =1,
    SecondDraftType =2,
    SecondCaseType  =3,
}SecondSectionType;
@interface ZXY_SecondSectionDetailInfoVC : UIViewController
- (void)setSecondSectionType:(SecondSectionType)currentType;

@end
