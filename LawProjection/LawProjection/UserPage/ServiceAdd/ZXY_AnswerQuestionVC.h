//
//  ZXY_AnswerQuestionVC.h
//  LawProjection
//
//  Created by 宇周 on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXY_AnswerQuestionVC : UIViewController
- (void)setQuestionInfo:(NSDictionary *)allQuestion andAnswerD:(NSDictionary *)answerD andID:(NSString *)contractID;
- (void)setQuestionInfo:(NSDictionary *)allQuestion andAnswer:(NSDictionary *)allAnswerD;
@end
