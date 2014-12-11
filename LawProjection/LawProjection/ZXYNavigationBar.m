//
//  ZXYNavigationBar.m
//  LawProjection
//
//  Created by 周效宇 on 14-9-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYNavigationBar.h"
#define NAVIGATION_BTN_MARGIN 5
@implementation ZXYNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    UINavigationItem *navigationItem = [self topItem];
    
    for (UIView *subview in [self subviews]) {
        
        if (subview == [[navigationItem rightBarButtonItem] customView]) {
            
            CGRect newRightButtonRect = CGRectMake(self.frame.size.width - subview.frame.size.width - NAVIGATION_BTN_MARGIN,
                                                   (self.frame.size.height - subview.frame.size.height) / 2,
                                                   subview.frame.size.width,
                                                   subview.frame.size.height);
            [subview setFrame:newRightButtonRect];
        } else if (subview == [[navigationItem leftBarButtonItem] customView]) {
            
//            CGRect newLeftButtonRect = CGRectMake(NAVIGATION_BTN_MARGIN,
//                                                  (self.frame.size.height - subview.frame.size.height) / 2,
//                                                  subview.frame.size.width,
//                                                  subview.frame.size.height);
            CGRect newLeftButtonRect = CGRectMake(NAVIGATION_BTN_MARGIN+10,
                                                  (self.frame.size.height - subview.frame.size.height) / 2,
                                                  subview.frame.size.width,
                                                  subview.frame.size.height);
            [subview setFrame:newLeftButtonRect];
        }
    }
}

@end
