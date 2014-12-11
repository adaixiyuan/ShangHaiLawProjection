//
//  LCYYellowStarCell.m
//  LawProjection
//
//  Created by eagle on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYYellowStarCell.h"

NSString *const LCYYellowStarCellIdentifier = @"LCYYellowStarCellIdentifier";

@interface LCYYellowStarCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViews;

@end

@implementation LCYYellowStarCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeRating:(NSInteger)rating andFloat:(float)realValue{
    for (UIImageView *imageView in self.starImageViews) {
        if (imageView.tag <= rating) {
            imageView.image = [UIImage imageNamed:@"yellowStar"];
        } else {
            if(imageView.tag == rating+1)
            {
                if(realValue>rating)
                {
                    imageView.image = [UIImage imageNamed:@"doubleStar"];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:@"grayStar"];
                }
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"grayStar"];
            }
        }
    }
}

@end
