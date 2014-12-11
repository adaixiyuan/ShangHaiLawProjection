//
//  ZXY_Coor_TabCell.m
//  LawProjection
//
//  Created by developer on 14-9-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_Coor_TabCell.h"
NSString *const cellIdentifierTab = @"ZXY_Coor_TabCellID";
#define BTNCOLOROFTHIS [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1 ]
@interface ZXY_Coor_TabCell()



- (IBAction)normalAction:(id)sender;
- (IBAction)specialAction:(id)sender;

@end

@implementation ZXY_Coor_TabCell

- (void)awakeFromNib {
    // Initialization code
    [self changeTabBarISNormal:YES];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)normalAction:(id)sender
{
    [self changeTabBarISNormal:YES];
    if([self.delegate respondsToSelector:@selector(coorTabBarChanged:)])
    {
        [self.delegate coorTabBarChanged:YES];
    }
}

- (IBAction)specialAction:(id)sender
{
    [self changeTabBarISNormal:NO];
    if([self.delegate respondsToSelector:@selector(coorTabBarChanged:)])
    {
        [self.delegate coorTabBarChanged:NO];
    }
}

- (void)changeTabBarISNormal:(BOOL)isNormal
{
    if(isNormal)
    {
        [self.specalBtn setBackgroundColor:[UIColor whiteColor]];
        [self.specalBtn setTitleColor:BTNCOLOROFTHIS forState:UIControlStateNormal];
        [self.specalBtn setTitleColor:BTNCOLOROFTHIS forState:UIControlStateHighlighted];
        [self.normalBtn setBackgroundColor:BTNCOLOROFTHIS];
        [self.normalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.normalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.specalBtn setBackgroundColor:BTNCOLOROFTHIS];
        [self.specalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.specalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.normalBtn setBackgroundColor:[UIColor whiteColor]];
        [self.normalBtn setTitleColor:BTNCOLOROFTHIS forState:UIControlStateNormal];
        [self.normalBtn setTitleColor:BTNCOLOROFTHIS forState:UIControlStateHighlighted];
    }
}
@end
