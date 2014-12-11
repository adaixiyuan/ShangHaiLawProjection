//
//  LCYModifyTextViewController.m
//  LawProjection
//
//  Created by eagle on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYModifyTextViewController.h"

@interface LCYModifyTextViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *icyTextField;

@end

@implementation LCYModifyTextViewController

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
    
    if (self.title) {
        [self.navigationItem setTitle:self.title];
    } else if (self.icyIdentifier) {
        [self.navigationItem setTitle:self.icyIdentifier];
    }
    
    [self.icyTextField becomeFirstResponder];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(modifyTextVC:didFinishChangeText:atField:)]) {
            [self.delegate modifyTextVC:self didFinishChangeText:self.icyTextField.text atField:self.icyIdentifier];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)backNavigation:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
