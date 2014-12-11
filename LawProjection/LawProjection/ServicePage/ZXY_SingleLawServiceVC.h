//
//  ZXY_SingleLawServiceVC.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    ServiceSingleConsult    = 0,
    ServiceSingleAudit      = 1,
    ServiceSingleDraft      = 2,
    ServiceSingleLetter     = 3,
    ServiceSingleTrain      = 4,
}ServiceSingleType;
@interface ZXY_SingleLawServiceVC : UIViewController
@property (nonatomic,strong) NSDictionary *dataDic;
- (void)setSingleServiceVCType:(ServiceSingleType)currentType;
@end
