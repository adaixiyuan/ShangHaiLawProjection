//
//  LCYLawyerDetailViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYLawyerDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "LCYNetworking.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LCYLawyerDetailModel.h"
#import "LCYLawyerDetailPortraitCell.h"
#import "LCYLawyerDetailCommonCell.h"
#import "LCYYellowStarCell.h"
#import "LCYCommon.h"
#import "ZXY_WebVC.h"
#import "LCYLawyerDetailFileCell.h"
#import "LCYLawyerDetailCareerCell.h"
#import "LCYLawyerDetailRatingCell.h"
#import "LCYLawyerDetailRatingViewController.h"
#import "ZXY_LawyerResCell.h"
#import "LCYLawyerDetailFacelessCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface LCYLawyerDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSDictionary *_responseDic;
}
@property (strong, nonatomic) LCYLawyerDetailModel *icyModel;
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@end

@implementation LCYLawyerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton addTarget:self action:@selector(backNavigation:) forControlEvents:UIControlEventTouchUpInside];
    [backBarButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backBarButton sizeToFit];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
    
    // 客户评价
    UIButton *ratingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ratingButton addTarget:self action:@selector(ratingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [ratingButton setTitle:@"客户评价" forState:UIControlStateNormal];
    [ratingButton sizeToFit];
    UIBarButtonItem *ratingItem = [[UIBarButtonItem alloc] initWithCustomView:ratingButton];
    [self.navigationItem setRightBarButtonItem:ratingItem];
    
    // 导航栏中间
    [self.navigationItem setTitle:@"律师详情"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在加载"];
    
    __weak __typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"id":self.lawyerID};
    [[LCYNetworking sharedInstance] getRequestWithApi:@"lawyer/getDetail" parameters:parameters success:^(NSDictionary *responseObject) {
        _responseDic = responseObject;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        weakSelf.icyModel = [[LCYLawyerDetailModel alloc] init];
        // 解析数据
        // 姓名
        weakSelf.icyModel.name = responseObject[@"data"][@"name"];
        // 评分
        NSArray *allArr = responseObject[@"data"][@"rating"];
        if(allArr.count >0 )
        {
            weakSelf.icyModel.attitudeRating = [responseObject[@"data"][@"rating"][0][@"attitudeAvg"] floatValue];
            weakSelf.icyModel.professionRating = [responseObject[@"data"][@"rating"][0][@"professionalAvg"] floatValue];
            weakSelf.icyModel.responsibilityRating = [responseObject[@"data"][@"rating"][0][@"responsibilityAvg"] floatValue];
            weakSelf.icyModel.attitudeFloat = [responseObject[@"data"][@"rating"][0][@"attitudeAvg"] floatValue];
            weakSelf.icyModel.professionFloat = [responseObject[@"data"][@"rating"][0][@"professionalAvg"] floatValue];
            weakSelf.icyModel.responsibilityFloat = [responseObject[@"data"][@"rating"][0][@"responsibilityAvg"] floatValue];

        }
        // 合伙人
        weakSelf.icyModel.copartner = [responseObject[@"data"][@"extend"][@"copartner"] isEqualToString:@"1"] ? YES : NO;
        // 所在律所
        weakSelf.icyModel.office = responseObject[@"data"][@"extend"][@"lawFirm"];
        // 所在地区
        weakSelf.icyModel.province = responseObject[@"data"][@"extend"][@"area"][@"province"][@"name"];
        weakSelf.icyModel.city = responseObject[@"data"][@"extend"][@"area"][@"city"][@"name"];
        weakSelf.icyModel.town = responseObject[@"data"][@"extend"][@"area"][@"town"][@"name"];
        NSDictionary *extendDic  = [responseObject[@"data"] objectForKey:@"extend"];
        NSArray *photeDic   = [extendDic objectForKey:@"workPhoto"] ;
        if(photeDic.count)
        {
            NSString     *photoID    = [[photeDic objectAtIndex:0] objectForKey:@"fileId"];
            NSString     *photoURL   = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,photoID];
            weakSelf.icyModel.portraitURL = photoURL;
        }
        // 年龄
        NSString *birthString = responseObject[@"data"][@"extend"][@"birthday"];
        NSDate *birthDate = [[LCYCommon sharedInstance] convertDate:birthString];
        NSDate *currentDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *birthComponents = [calendar components:NSCalendarUnitYear fromDate:birthDate];
        NSDateComponents *currentComponents = [calendar components:NSCalendarUnitYear fromDate:currentDate];
        weakSelf.icyModel.age = currentComponents.year - birthComponents.year;
        
        // 职业起始时间
        NSString *careerString = responseObject[@"data"][@"extend"][@"licenseStartDate"];
        NSDate *careerDate = [[LCYCommon sharedInstance] convertDate:careerString];
        NSDateFormatter *careerFormatter = [[NSDateFormatter alloc] init];
        [careerFormatter setDateFormat:@"yyyy年MM月dd日"];
        weakSelf.icyModel.careerStartTime = [careerFormatter stringFromDate:careerDate];
        
        // 擅长领域
        NSArray *expertiseNames = responseObject[@"data"][@"expertiseName"];
        weakSelf.icyModel.expertFields = expertiseNames;
        weakSelf.icyModel.expertString = [expertiseNames componentsJoinedByString:@","];
        
        // 个人简介
        weakSelf.icyModel.brief = responseObject[@"data"][@"extend"][@"profile"];
        
        // 办案经验
        weakSelf.icyModel.experiences = responseObject[@"data"][@"extend"][@"judgment"];
        
        // 个人履历
        NSArray *careerArray = responseObject[@"data"][@"extend"][@"career"];
        if (careerArray) {
            self.icyModel.careerArray = careerArray;
        } else {
            self.icyModel.careerArray = [NSArray array];
        }
        
        [weakSelf.icyTableView reloadData];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showRating"]) {
        LCYLawyerDetailRatingViewController *ratingVC = [segue destinationViewController];
        ratingVC.lawyerID = self.lawyerID;
    }
}


- (void)backNavigation:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ratingButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showRating" sender:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.icyModel) {
        return 0;
    } else {
        return 7 + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            // 擅长领域
//            return [self.icyModel.expertFields count];
            return 1;
            break;
        case 5:
            return 1;
            break;
        case 6:
            return [self.icyModel.experiences count];
            break;
            
        case 7:
            return [self.icyModel.careerArray count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        // 头像
        LCYLawyerDetailPortraitCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailPortraitCellIdentifier];
        cell.icyLabel.text = self.icyModel.name;
        [cell.icyImageView sd_setImageWithURL:[NSURL URLWithString:self.icyModel.portraitURL]];
        return cell;
    } else if (indexPath.section == 1) {
        // 评分
        LCYYellowStarCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYYellowStarCellIdentifier];
        
        switch (indexPath.row) {
            case 0:
//                weakSelf.icyModel.attitudeRating = [responseObject[@"data"][@"rating"][0][@"attitudeAvg"] floatValue];
//                weakSelf.icyModel.professionRating = [responseObject[@"data"][@"rating"][0][@"professionalAvg"] floatValue];
//                weakSelf.icyModel.responsibilityRating = [responseObject[@"data"][@"rating"][0][@"responsibilityAvg"] floatValue];
                cell.icyTitleLabel.text = @"服务态度";
                cell.icyContentLabel.text = [NSString stringWithFormat:@"%.1f分",self.icyModel.attitudeFloat];
                [cell makeRating:self.icyModel.attitudeRating andFloat:self.icyModel.attitudeFloat];
                break;
            case 1:
                cell.icyTitleLabel.text = @"专业性";
                cell.icyContentLabel.text = [NSString stringWithFormat:@"%.1f分",self.icyModel.professionFloat];
                [cell makeRating:self.icyModel.professionRating andFloat:self.icyModel.professionFloat];
                break;
            case 2:
                cell.icyTitleLabel.text = @"责任心";
                cell.icyContentLabel.text = [NSString stringWithFormat:@"%.1f分",self.icyModel.responsibilityFloat];
                [cell makeRating:self.icyModel.responsibilityRating andFloat:self.icyModel.responsibilityFloat];
                break;
                
            default:
                break;
                
        }
        
        return cell;
    } else if (indexPath.section == 2) {
        LCYLawyerDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailCommonCellIdentifier];
        switch (indexPath.row) {
            case 0:
                cell.icyTitleLabel.text = @"合伙人";
                cell.icyContentLabel.text = self.icyModel.copartner ? @"是" : @"否";
                break;
                
            case 1:
                cell.icyTitleLabel.text = @"所在律所";
                cell.icyContentLabel.text = self.icyModel.office;
                break;
            case 2:
                cell.icyTitleLabel.text = @"所在地区";
                cell.icyContentLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.icyModel.province, self.icyModel.city, self.icyModel.town];
                break;
                
            default:
                break;
        }
        return cell;
    }else if (indexPath.section == 3) {
        LCYLawyerDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailCommonCellIdentifier];
        switch (indexPath.row) {
            case 0:
                cell.icyTitleLabel.text = @"年龄";
                cell.icyContentLabel.text = [NSString stringWithFormat:@"%@岁",[NSNumber numberWithInteger:self.icyModel.age]];
                break;
                
            case 1:
                cell.icyTitleLabel.text = @"执业起始时间";
                cell.icyContentLabel.text = self.icyModel.careerStartTime;
                break;
                
            default:
                break;
        }
        return cell;
    } else if (indexPath.section == 4) {
        // 擅长领域
        LCYLawyerDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailCommonCellIdentifier];
        cell.icyTitleLabel.text = @"";
//        cell.icyContentLabel.text = self.icyModel.expertFields[indexPath.row];
        cell.icyContentLabel.text = self.icyModel.expertString;
        return cell;
    } else if (indexPath.section == 5) {
        LCYLawyerDetailFacelessCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailFacelessCellIdentifier];
        cell.facelessLabel.text = self.icyModel.brief;
        return cell;
//        LCYLawyerDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailCommonCellIdentifier];
//        cell.icyTitleLabel.text = @"律师简介";
//        cell.icyContentLabel.text = self.icyModel.brief;
//        ZXY_LawyerResCell *cells = [tableView dequeueReusableCellWithIdentifier:LawyerResCellIDS];
//        cells.contentLbl.text    = self.icyModel.brief;
//        return cell;
    } else if (indexPath.section == 6) {
        LCYLawyerDetailFileCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailFileCellIdentifier];
//        LCYLawyerDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailCommonCellIdentifier];
//        cell.icyTitleLabel.text = @"";
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.icyModel.experiences[indexPath.row][@"fileName"]
                                                                               attributes:@{NSForegroundColorAttributeName: [UIColor blueColor],
                                                                                            NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        cell.icyFileLabel.attributedText = attributedString;
        return cell;
    } else if (indexPath.section == 7) {
        // 职业经历
        LCYLawyerDetailCareerCell *cell = [tableView dequeueReusableCellWithIdentifier:LCYLawyerDetailCareerCellIdentifier];
        cell.icyComLabel.text = self.icyModel.careerArray[indexPath.row][@"careerCompany"];
        cell.icyJobLabel.text = self.icyModel.careerArray[indexPath.row][@"careerJob"];
        NSString *st = self.icyModel.careerArray[indexPath.row][@"careerStart"];
        NSString *ed = self.icyModel.careerArray[indexPath.row][@"careerEnd"];
        cell.icyTimeLabel.text = [NSString stringWithFormat:@"%@-%@", st, ed];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeHolder"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120.0f;
    } else if (indexPath.section == 5) {
        CGSize size = [self.icyModel.brief boundingRectWithSize:CGSizeMake(304.0f, 40000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
        return size.height + 16.0f >= 44 ? size.height + 16.0f : 44.0f;
    } else if (indexPath.section == 6) {
        NSString *contentString = self.icyModel.experiences[indexPath.row][@"fileName"];
        CGSize size = [contentString boundingRectWithSize:CGSizeMake(290, 40000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size;
        return size.height + 24.0f >= 44 ? size.height + 24.0f : 44.0f;
    } else if (indexPath.section == 7) {
        return 54.0f;
    }
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"评分";
    } else if (section == 4) {
        return @"擅长领域";
    } else if( section == 5) {
        return @"律师简介";
    } else if (section == 6) {
        return @"办案经验";
    } else if (section == 7) {
        return @"职业经历";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) {
        NSString *fileID = self.icyModel.experiences[indexPath.row][@"fileId"];
        NSString *fileName = self.icyModel.experiences[indexPath.row][@"fileName"];
        NSString *URLString = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
        ZXY_WebVC *web = [[ZXY_WebVC alloc] init];
        web.title = fileName;
        [web setDownLoadURL:URLString];
        [self.navigationController pushViewController:web animated:YES];
        return;
    } else if (indexPath.section == 0) {
//        [self performSegueWithIdentifier:@"showRating" sender:nil];
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

@end
