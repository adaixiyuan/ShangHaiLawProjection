//
//  ZXY_LawAuditVCViewController.m
//  LawProjection
//
//  Created by developer on 14-9-24.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_LawAuditVC.h"
NSString *const LAWAUDITVCID = @"LawAuditVCID";
@interface ZXY_LawAuditVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL isMainBody;
    BOOL isMainChoose;
    __weak IBOutlet UIImageView *mainImageS;
    __weak IBOutlet UIImageView *secondImageS;
    __weak IBOutlet UIImageView *roleImage;
    __weak IBOutlet UILabel *roleLbl;
    UIToolbar *topBar;
    __weak IBOutlet UIPickerView *currentPicker;
}
@property (strong, nonatomic) IBOutlet UIView *pickerView;

@end

@implementation ZXY_LawAuditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewImage];
    [self initViewLa];
    // Do any additional setup after loading the view.
}

- (void)initViewImage
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectMainBody)];
    mainImageS.userInteractionEnabled = YES;
    [mainImageS addGestureRecognizer:tapGes];
    
    UITapGestureRecognizer *tapGesO = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNoMainBody)];
    secondImageS.userInteractionEnabled = YES;
    [secondImageS addGestureRecognizer:tapGesO];
}

- (void)initViewLa
{
    topBar = [self toolBarWithRight:@"完成" andLeft:@"" withRightBtnSel:@selector(hidePickView) andLeftBtnSel:nil];
    [self.pickerView addSubview:topBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hidePickView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
    }];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(isMainBody)
    {
        return 3;
    }
    else
    {
        return 4;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(isMainBody)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(isMainBody)
    {
        return @"测试行1";
    }
    else
    {
        return @"测试行2";
    }
}

- (void)selectMainBody
{
    isMainBody = YES;
    [currentPicker reloadAllComponents];
    [self.view addSubview:self.pickerView];
    self.pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(0, self.view.frame.size.height-self.pickerView.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    }];
}

- (void)selectNoMainBody
{
    isMainBody = NO;
    [currentPicker reloadAllComponents];
    [self.view addSubview:self.pickerView];
    self.pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(0, self.view.frame.size.height-self.pickerView.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    }];
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
