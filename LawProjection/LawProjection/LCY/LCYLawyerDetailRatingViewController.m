//
//  LCYLawyerDetailRatingViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/14.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYLawyerDetailRatingViewController.h"
#import "LCYNetworking.h"
#import "LCYGetRating.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LCYLawyerDetailRatingCell.h"

@interface LCYLawyerDetailRatingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@property (strong, nonatomic) LCYGetRatingBase *infoBase;

@end

@implementation LCYLawyerDetailRatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.icyTableView setTableFooterView:footerView];
    
    [self.navigationItem setTitle:@"客户评价"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *parameters = @{@"lawyer":self.lawyerID,
                                 @"skip":@0,
                                 @"limit":@1000};
    __weak __typeof(self) weakSelf = self;
    [[LCYNetworking sharedInstance] getRequestWithApi:@"appraise/list" parameters:parameters success:^(NSDictionary *responseObject) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.infoBase = [LCYGetRatingBase modelObjectWithDictionary:responseObject];
        [strongSelf.icyTableView reloadData];
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
    } failed:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf alertMessage:@"加载失败"];
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.infoBase) {
        return 0;
    } else {
        return [self.infoBase.data.items count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCYLawyerDetailRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailRatingCellIdentifier];
    LCYGetRatingItems *item = self.infoBase.data.items[indexPath.row];
    cell.icyTitleLabel.text = item.comment;
    cell.icyTimeLabel.text = [item.createAt substringToIndex:10];
    cell.icyTopLabel.text = [NSString stringWithFormat:@"服务态度：%@",@(item.attitude)];
    cell.icyMidLabel.text = [NSString stringWithFormat:@"专业性：%@",@(item.professional)];
    cell.icyBottomLabel.text = [NSString stringWithFormat:@"责任心：%@",@(item.responsibility)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCYGetRatingItems *item = self.infoBase.data.items[indexPath.row];
    CGSize labelSize = [item.comment boundingRectWithSize:CGSizeMake(210.0f, 2000.0f)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                  context:nil].size;
    NSLog(@"height = %@",@(labelSize.height));
    return 40.0f + labelSize.height;
}

@end
