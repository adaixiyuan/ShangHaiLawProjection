//
//  ZXY_HomeTabVC.m
//  LawProjection
//
//  Created by developer on 14-9-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_HomeTabVC.h"
#import "UIViewController+ZXY_VCCategory.h"
#import "ZXY_HomeLetterVC.h"
#import "ZXY_LawAuditVC.h"
#import "ZXY_SingleLawServiceVC.h"
#import "ZXY_TabLawPage.h"
#import "ZXYScrollView.h"
#import "ZXY_UserActiveVC.h"
@interface ZXY_HomeTabVC ()<ZXYScrollDataSource,ZXYScrollDelegate>
{
    NSArray *imageArr;
    __weak IBOutlet ZXYScrollView *myScroll;
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation ZXY_HomeTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    imageArr = [NSArray arrayWithObjects:@"ad1",@"ad3",@"ad2", nil];
    myScroll.dataSource = self;
    myScroll.delegate = self;
    //self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 455);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goodLawer:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"tabLawPageStory" bundle:nil];
    ZXY_TabLawPage *law = [story instantiateViewControllerWithIdentifier:@"goodLaw"];
    [law setLeftNaviItem:@"back_arrow"];
    [self.navigationController pushViewController:law animated:YES];
}
- (IBAction)draftContract:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
    ZXY_SingleLawServiceVC *single = [story instantiateViewControllerWithIdentifier:@"single"];
    [single setSingleServiceVCType:ServiceSingleDraft];
    [self.navigationController pushViewController:single animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%f,%f,%f",self.contentScrollView.frame.size.height,self.contentScrollView.contentSize.height,self.contentScrollView.frame.origin.y);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self setNaviTitleImage:@"home_law"];
    [self setRightNaviItem:@"home_phone"];
}
- (IBAction)coorp_consultAction:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"HomeTabVC" bundle:nil];
    UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"home_ConsultVC"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)letterAction:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
    ZXY_SingleLawServiceVC *single = [story instantiateViewControllerWithIdentifier:@"single"];
    [single setSingleServiceVCType:ServiceSingleLetter];
    [self.navigationController pushViewController:single animated:YES];
}

- (IBAction)lawAuditAction:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
    ZXY_SingleLawServiceVC *single = [story instantiateViewControllerWithIdentifier:@"single"];
    [single setSingleServiceVCType:ServiceSingleAudit];
    [self.navigationController pushViewController:single animated:YES];
}

#pragma mark - scrollDelegate
- (NSInteger)numberOfPages
{
    return 3;
}

- (UIView *)viewAtIndexPage:(NSInteger)index
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myScroll.frame.size.width, 73)];
    imageV.image        = [UIImage imageNamed:[imageArr objectAtIndex:index]];
    return imageV;
}

-(BOOL)shouldTurnAutoWithTime
{
    return YES;
}

-(NSTimeInterval)turnTimeInterVal
{
    return 3;
}

-(BOOL)shouldClickAtIndex:(NSInteger)index;
{
    return YES;
}

-(void)afterClickAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
    if(index == 0)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
        ZXY_SingleLawServiceVC *single = [story instantiateViewControllerWithIdentifier:@"single"];
        [single setSingleServiceVCType:ServiceSingleConsult];
        [self.navigationController pushViewController:single animated:YES];
    }
    else if (index == 2)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
        ZXY_UserActiveVC *loginVC = [story instantiateViewControllerWithIdentifier:@"jihuo"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
        ZXY_SingleLawServiceVC *single = [story instantiateViewControllerWithIdentifier:@"single"];
        [single setSingleServiceVCType:ServiceSingleTrain];
        [self.navigationController pushViewController:single animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
