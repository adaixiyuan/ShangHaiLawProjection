//
//  ZXYTouchScollView.m
//  LawProjection
//
//  Created by 周效宇 on 14-9-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYTouchScollView.h"

@implementation ZXYTouchScollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesBegan:touches withEvent:event];
}
@end
