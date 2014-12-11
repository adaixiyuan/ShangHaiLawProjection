//
//  LCYLawyerNewLetterViewController.h
//  LawProjection
//
//  Created by eagle on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCYNewLetterModel.h"
#import "LCYLawyerLetterCell.h"


@interface LCYLawyerNewLetterViewController : UIViewController

- (void)configExistModel:(LCYNewLetterModel *)model currentStatus:(LCYLawyerLetterStatus)status;

@end
