//
//  LCYLootView.h
//  JunHeOC
//
//  Created by eagle on 14/10/29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCYLootView;

@protocol LCYLootSource <NSObject>

/**
 *  向LootView提供内容条数
 *
 *  @param lootView 当前lootView指针，用于区分不同的lootView
 *
 *  @return 内容条数
 */
- (NSInteger)numberOfRowsInlootView:(LCYLootView *)lootView;

/**
 *  向LootView提供每一行的文字
 *
 *  @param lootView 当前lootView指针，用于区分不同的lootView
 *  @param row      所在行数
 *
 *  @return 内容文字
 */
- (NSString *)lootView:(LCYLootView *)lootView textAtRow:(NSInteger)row;

@optional

/**
 *  向LootView提供题目，如果没有提供，默认为“请选择”
 *
 *  @param lootView 当前lootView指针，用于区分不同的lootView
 *
 *  @return 题目
 */
- (NSString *)titleForLootView:(LCYLootView *)lootView;

/**
 *  选择一个内容，并且点击确定按钮后的回调
 *
 *  @param lootView 当前lootView指针，用于区分不同的lootView
 *  @param index    选择的是第几行
 */
- (void)lootView:(LCYLootView *)lootView didSelectItemAtIndex:(NSInteger)index;

/**
 *  点击取消按钮后的回调
 *
 *  @param lootView 当前lootView指针，用于区分不同的lootView
 */
- (void)lootViewDidCancel:(LCYLootView *)lootView;

@end

@interface LCYLootView : UIView

@property (weak, nonatomic) id<LCYLootSource>lootSource;

- (instancetype)initWithDataSource:(id<LCYLootSource>)lootSource;

- (void)show;

- (void)hide;

@end
