//
//  LCYLootView.m
//  JunHeOC
//
//  Created by eagle on 14/10/29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "LCYLootView.h"
#import "AppDelegate.h"
#import "LCYCommon.h"

#define LOOT_INTERACT_HEIGHT    260.0f
#define LOOT_INTERACT_WIDTH     200.0f
#define LOOT_HEAD_HEIGHT        44.0f
#define LOOT_FOOT_HEIGHT        44.0f

#define KLOOT_TABLE_UNSELECTED  -10

#define THEME_COLOR [UIColor colorWithRed:0.0f green:205.0f/255.0f blue:1.0f alpha:1.0f]

@interface LCYLootView ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *interactView;

@property (nonatomic) NSInteger selectedRowIndex;

@end

@implementation LCYLootView

- (instancetype)initWithDataSource:(id<LCYLootSource>)lootSource{
    if (self = [super init]) {
        NSAssert([lootSource conformsToProtocol:@protocol(LCYLootSource)], @"ICYLYDIA:数据源必须满足LCYLootSource协议!");
        NSAssert([lootSource respondsToSelector:@selector(numberOfRowsInlootView:)], @"ICYLYDIA:数据源必须实现 numberOfRowsInlootView: 方法!");
        NSAssert([lootSource respondsToSelector:@selector(lootView:textAtRow:)], @"ICYLYDIA:数据源必须实现 lootView:textAtRow: 方法!");
        
        self.lootSource = lootSource;
        
        
        
        // 设置没有选中任何一行
        self.selectedRowIndex = KLOOT_TABLE_UNSELECTED;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        // 半透明层，禁用一切原有的点击事件
        self.maskView = [[UIView alloc] init];
        [self.maskView setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        [self.maskView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.7f]];
        
        // 交互层
        self.interactView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LOOT_INTERACT_WIDTH, LOOT_INTERACT_HEIGHT)];
        self.interactView.center = self.maskView.center;
        [self.interactView setBackgroundColor:THEME_COLOR];
        
        // 数据层，提供用户操作
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, LOOT_HEAD_HEIGHT, LOOT_INTERACT_WIDTH, LOOT_INTERACT_HEIGHT - LOOT_HEAD_HEIGHT - LOOT_FOOT_HEIGHT)
                                                      style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.center = CGPointMake(self.interactView.bounds.size.width / 2.0, self.interactView.bounds.size.height / 2.0);
        
        // 圆角
        CALayer *interactLayer = self.interactView.layer;
        [interactLayer setCornerRadius:6.0f];
        
        // 题目
        UILabel *headLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LOOT_INTERACT_WIDTH, LOOT_HEAD_HEIGHT)];
        if ([self.lootSource respondsToSelector:@selector(titleForLootView:)]) {
            headLabel.text = [self.lootSource titleForLootView:self];
        } else {
            headLabel.text = @"请选择";
        }
        [headLabel setTextColor:[UIColor whiteColor]];
        [headLabel setTextAlignment:NSTextAlignmentCenter];
        [self.interactView addSubview:headLabel];
        
        // 确定按钮
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setFrame:CGRectMake(22.0f, LOOT_INTERACT_HEIGHT - LOOT_FOOT_HEIGHT + 8.0f, 64.0f, 28.0f)];
        [doneButton setBackgroundColor:[UIColor clearColor]];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        CALayer *doneButtonLayer = doneButton.layer;
        [doneButtonLayer setCornerRadius:4.0f];
        [doneButtonLayer setBorderColor:[[UIColor whiteColor] CGColor]];
        [doneButtonLayer setBorderWidth:(1.0f / [UIScreen mainScreen].scale)];
        [self.interactView addSubview:doneButton];
        
        // 取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setFrame:CGRectMake(114.0f, LOOT_INTERACT_HEIGHT - LOOT_FOOT_HEIGHT + 8.0f, 64.0f, 28.0f)];
        [cancelButton setBackgroundColor:[UIColor clearColor]];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        CALayer *cancelButtonLayer = cancelButton.layer;
        [cancelButtonLayer setCornerRadius:4.0f];
        [cancelButtonLayer setBorderColor:[[UIColor whiteColor] CGColor]];
        [cancelButtonLayer setBorderWidth:(1.0f / [UIScreen mainScreen].scale)];
        [self.interactView addSubview:cancelButton];
        
        // 设置缩小
        [self.interactView addSubview:self.tableView];
        [self.interactView setTransform:CGAffineTransformMakeScale(0.001, 0.001)];
        
        [self.maskView addSubview:self.interactView];
    }
    return self;
}

- (void)show {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.maskView];
    
    [UIView animateWithDuration:0.35
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.interactView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                     }
                     completion:^(BOOL finished) {
                         ;
                     }];
}

- (void)hide {
    [self.maskView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)doneButtonPressed:(id)sender {
    if (self.selectedRowIndex != KLOOT_TABLE_UNSELECTED) {
        if ([self.lootSource respondsToSelector:@selector(lootView:didSelectItemAtIndex:)]) {
            [self.lootSource lootView:self didSelectItemAtIndex:self.selectedRowIndex];
        }
        [self hide];
    }
}

- (void)cancelButtonPressed:(id)sender {
    if ([self.lootSource respondsToSelector:@selector(lootViewDidCancel:)]) {
        [self.lootSource lootViewDidCancel:self];
    }
    [self hide];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.lootSource numberOfRowsInlootView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LCYLootViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setTintColor:THEME_COLOR];
    }
    cell.textLabel.text = [self.lootSource lootView:self textAtRow:indexPath.row];
    if (self.selectedRowIndex == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedRowIndex == indexPath.row) {
        self.selectedRowIndex = KLOOT_TABLE_UNSELECTED;
    } else {
        self.selectedRowIndex = indexPath.row;
    }
    [self.tableView reloadData];
}

@end
