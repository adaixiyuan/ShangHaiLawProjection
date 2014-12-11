//
//  ZXY_LawCircleView.h
//  LawProjection
//
//  Created by developer on 14-9-24.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXY_LawCircleView : UIView
/**
 *  实例化方法 在页面的顶部加载此view
 *
 *  @return id
 */
- (id)initForAdd;

/**
 *  实例化方法 通过控制Y来决定此view的位置
 *
 *  @param positionY 纵坐标的大小
 *
 *  @return id
 */
- (id)initWithPositionY:(float)positionY;

/**
 *  设置圆圈的个数zui
 *
 *  @param numberCir 圆圈的个数
 */
- (void)setNumOfCircle:(NSInteger)numberCir;

/**
 *  设置圆圈上显示的信息
 *
 *  @param titles 圆圈标题的数组
 */
- (void)setCircleInfo:(NSArray *)titles;

/**
 *  设置那个圆圈需要显示蓝色
 *
 *  @param selectIndex 蓝色圆圈的位置
 */
- (void)setSelectIndex:(NSInteger)selectIndex;

/**
 *  设置被选择的背景颜色
 *
 *  @param backColor 背景颜色
 */
- (void)setSelectBackColor:(UIColor *)backColor;

/**
 *  如果不设置选择圆圈
 *
 *  @param selectOr 不设置选择圆圈
 */
- (void)setISNOSelect:(BOOL)selectOr;
@end
