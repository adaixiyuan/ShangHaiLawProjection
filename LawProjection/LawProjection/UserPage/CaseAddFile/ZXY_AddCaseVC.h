//
//  ZXY_AddCaseVC.h
//  LawProjection
//
//  Created by 宇周 on 14/11/12.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXY_AddCaseVC : UIViewController
- (void)startFromCaseID:(NSString *)caseID andStage:(NSString *)stage withStatud:(NSString *)status;
- (void)setLawyerList:(NSArray *)lawList;
@end
