//
//  ZXY_ChangeUserInfoVC.h
//  LawProjection
//
//  Created by 宇周 on 14/11/6.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZXY_ChangeUserInfoDelegate <NSObject>
- (void)changeUserInfo:(NSString *)changeValue withKey:(NSString *)dbKey;
@end
@interface ZXY_ChangeUserInfoVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *changeText;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak,nonatomic) id<ZXY_ChangeUserInfoDelegate>delegate;
- (void)setChangeInfo:(NSString *)originalValue withKey:(NSString *)dbKey isNum:(BOOL)isNum;
- (IBAction)changeAction:(id)sender;
@end
