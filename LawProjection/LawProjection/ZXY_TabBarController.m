//
//  ZXY_TabBarController.m
//  LawProjection
//
//  Created by developer on 14-9-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_TabBarController.h"

@interface ZXY_TabBarController ()<UITabBarControllerDelegate>

@end

@implementation ZXY_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *userS = [UIStoryboard storyboardWithName:@"UserLoginRegist" bundle:nil];
    UIStoryboard *homeS = [UIStoryboard storyboardWithName:@"HomeTabVC" bundle:nil];
    UIStoryboard *tabLS = [UIStoryboard storyboardWithName:@"tabLawPageStory" bundle:nil];
    UIStoryboard *servS = [UIStoryboard storyboardWithName:@"ServicePageStory" bundle:nil];
    self.delegate = self;
    [self setViewControllers:[NSArray arrayWithObjects:homeS.instantiateInitialViewController,servS.instantiateInitialViewController,tabLS.instantiateInitialViewController,userS.instantiateInitialViewController, nil]];
    for(int i = 0;i<self.tabBar.items.count;i++)
    {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        NSString *selectImageName = [NSString stringWithFormat:@"tab_%dS",i];
        NSString *nonSeImageName  = [NSString stringWithFormat:@"tab_%dD",i];
        [item setSelectedImage:[UIImage imageNamed:selectImageName]];
        [item setImage:[UIImage imageNamed:nonSeImageName]];
        
    }
    
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
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController *navi = (UINavigationController *)viewController;
    [navi popToRootViewControllerAnimated:YES];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

//- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
//{
//    
//}

@end
