//
//  LCYModifyTextViewController.h
//  LawProjection
//
//  Created by eagle on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCYModifyTextViewController;

@protocol LCYModifyTextViewDelegate <NSObject>

- (void)modifyTextVC:(LCYModifyTextViewController *)viewController didFinishChangeText:(NSString *)text atField:(NSString *)identifier;

@end

@interface LCYModifyTextViewController : UIViewController

@property (copy, nonatomic) NSString *icyTitle;

@property (copy, nonatomic) NSString *icyIdentifier;

@property (weak, nonatomic) id<LCYModifyTextViewDelegate>delegate;

@end
