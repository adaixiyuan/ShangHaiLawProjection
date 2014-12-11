//
//  ZXY_UserLoginVC.h
//  LawProjection
//
//  Created by developer on 14-10-9.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ZXY_UserLoginComplete)();
@interface ZXY_UserLoginVC : UIViewController
@property (nonatomic,strong)ZXY_UserLoginComplete onComplete;
@end
