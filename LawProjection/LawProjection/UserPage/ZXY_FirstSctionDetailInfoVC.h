//
//  ZXY_FirstSctionDetailInfoVC.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    UserOrderType    =0,
    LawTrainType     =1,
    LawConsultType   =2,
    MyCaseType       =3,
}FirstSectionType;
@interface ZXY_FirstSctionDetailInfoVC : UIViewController
- (void)setFirstSectionType:(FirstSectionType)currentType;
@end
