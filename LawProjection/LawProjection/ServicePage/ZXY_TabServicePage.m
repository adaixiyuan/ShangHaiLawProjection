//
//  ZXY_TabServicePage.m
//  LawProjection
//
//  Created by developer on 14-9-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_TabServicePage.h"
#import "UIViewController+ZXY_VCCategory.h"
#import "ZXY_SingleLawServiceVC.h"

@interface ZXY_TabServicePage ()
{
    NSArray *allServiceArr;
    NSDictionary *sendDic;
    ServiceSingleType selectType;
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
- (IBAction)serviceBtnAction:(id)sender;

@end

@implementation ZXY_TabServicePage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initData];
        // Do any additional setup after loading the view.
}

- (void)initData
{
    NSString *servicePListPath = [[NSBundle mainBundle] pathForResource:@"SingleLawServicePlist" ofType:@"plist"];
    allServiceArr = [[NSArray alloc] initWithContentsOfFile:servicePListPath];
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self setNaviTitleImage:@"home_law"];
    [self setRightNaviItem:@"home_phone"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toDetailSingle"])
    {
        ZXY_SingleLawServiceVC *singleLawServiceVC = [segue destinationViewController];
        [singleLawServiceVC setSingleServiceVCType:selectType];
    }
}


- (IBAction)serviceBtnAction:(id)sender {
    UIButton *clickBtn = (UIButton *)sender;
    NSInteger btnTag = clickBtn.tag;
    for(NSDictionary *dic in allServiceArr)
    {
        if([[dic objectForKey:@"btnID"] integerValue]==btnTag)
        {
            selectType = [(NSNumber *)[dic objectForKey:@"id"] integerValue];
            break;
        }
    }
    [self performSegueWithIdentifier:@"toDetailSingle" sender:self];
    
    
}
@end
