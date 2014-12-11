//
//  LCYLawyerLetterCell.h
//  LawProjection
//
//  Created by eagle on 14/10/31.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const LCYLawyerLetterCellIdentifier;

typedef NS_ENUM(NSUInteger, LCYLawyerLetterStatus) {
    LCYLawyerLetterStatusCommit,    /**< 提交 */
    LCYLawyerLetterStatusDraft,     /**< 起草 */
    LCYLawyerLetterStatusConfirm,   /**< 确认 */
    LCYLawyerLetterStatusSend,      /**< 发送 */
    LCYLawyerLetterStatusSavefile,  /**< 存档 */
};

@interface LCYLawyerLetterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic) LCYLawyerLetterStatus iconStatus;

@end
