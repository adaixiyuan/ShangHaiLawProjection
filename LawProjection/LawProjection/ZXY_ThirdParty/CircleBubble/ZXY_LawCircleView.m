//
//  ZXY_LawCircleView.m
//  LawProjection
//
//  Created by developer on 14-9-24.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_LawCircleView.h"

@interface ZXY_LawCircleView()
{
    NSInteger numOfCircle;
    NSInteger selectIndexOf;
    NSArray   *titlesOf;
    NSArray   *picArr;
    UIColor   *blueColor ;
    UIColor   *grayColor;
    CGRect    currentFrame;
    UIView    *contentView;
    UIColor   *backOfCircleSelColor;
    BOOL      isNOSelect;
}
@end


@implementation ZXY_LawCircleView

- (id)initForAdd
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    if(self)
    {
        [self initForMethod];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    if(self)
    {
        [self initForMethod];
    }
    return self;
}

- (id)initWithPositionY:(float)positionY
{
    self = [super initWithFrame:CGRectMake(0, positionY, [UIScreen mainScreen].bounds.size.width, 50)];
    if(self)
    {
        [self initForMethod];
    }
    return self;
}

- (void)initForMethod
{
    blueColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    grayColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    picArr = [NSArray arrayWithObjects:@"blue_arrow",@"light_blue_arrow",@"green_arrow",@"light_green_arrow", nil];
    self.backgroundColor = [UIColor clearColor];
    contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-20, self.frame.size.height-10)];
    contentView.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSAssert(titlesOf.count == numOfCircle, @"圆圈数量与标题数量不相同啊,是是傻");

    currentFrame = rect;
    if(![self.subviews containsObject:contentView])
    {
        [self addSubview:contentView];
    }
    [self drawCircleAndArrow];
}

- (void)drawCircleAndArrow
{
    float sizeForW = 9+20-2*numOfCircle;
    if(numOfCircle == 0)
    {
        numOfCircle = titlesOf.count;
    }
    for(int i = 0;i<numOfCircle;i++)
    {
        UIView *circleView ;
        UIImageView *arrowImage;
        if(i<numOfCircle-1)
        {
            if(i == 0)
            {
                circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[picArr objectAtIndex:i]]];
                arrowImage.frame = CGRectMake(40, 0, sizeForW, 15);
            }
            else
            {
                circleView = [[UIView alloc] initWithFrame:CGRectMake(i*(40+sizeForW), 0, 40, 40)];
                arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[picArr objectAtIndex:i]]];
                arrowImage.frame = CGRectMake(i*(40+sizeForW)+40, 0, sizeForW, 15);
            }
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = 20;
            arrowImage.center = CGPointMake(arrowImage.center.x, circleView.center.y);
            if(i == selectIndexOf)
            {
                if(isNOSelect == YES)
                {
                    circleView.backgroundColor = grayColor;
                }
                else
                {
                    circleView.backgroundColor = blueColor;
                    if(backOfCircleSelColor)
                    {
                        circleView.backgroundColor = backOfCircleSelColor;
                    }
                }
            }
            else
            {
                circleView.backgroundColor = grayColor;
            }
            arrowImage.contentMode = UIViewContentModeCenter;
            [contentView addSubview:circleView];
            [contentView addSubview:arrowImage];
        }
        else
        {
            circleView = [[UIView alloc] initWithFrame:CGRectMake(i*(40+sizeForW), 0, 40, 40)];
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = 20;
            if(i == selectIndexOf)
            {
                if(isNOSelect == YES)
                {
                    circleView.backgroundColor = grayColor;
                }
                else
                {
                    circleView.backgroundColor = blueColor;
                    if(backOfCircleSelColor)
                    {
                        circleView.backgroundColor = backOfCircleSelColor;
                    }
                }
            }
            else
            {
                circleView.backgroundColor = grayColor;
            }
            [contentView addSubview:circleView];
        }
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.font      = [UIFont systemFontOfSize:12];
        infoLabel.text = [titlesOf objectAtIndex:i];
        [circleView addSubview:infoLabel];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    UIView *lastView  = (UIView *)contentView.subviews.lastObject;
    float  lastVW     = lastView.frame.origin.x+lastView.frame.size.width;
    contentView.frame = CGRectMake(0, 0, lastVW, contentView.frame.size.height);
    contentView.center= CGPointMake(self.center.x, contentView.center.y);
}

- (NSArray *)producePositonXY
{
    return nil;
}

- (void)setNumOfCircle:(NSInteger)numberCir
{
    NSAssert(numberCir <=5, @"要那么多圆圈也没有用 最多只能五个的");
    numOfCircle = numberCir;
}

- (void)setCircleInfo:(NSArray *)titles
{
    NSAssert(titles.count != 0, @"0个标题，没有圆圈就不要用了吧");
    titlesOf = [NSArray arrayWithArray:titles];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    selectIndexOf = selectIndex;
}

- (void)setSelectBackColor:(UIColor *)backColor
{
    backOfCircleSelColor = backColor;
}

- (void)setISNOSelect:(BOOL)selectOr
{
    isNOSelect = selectOr;
}
@end
