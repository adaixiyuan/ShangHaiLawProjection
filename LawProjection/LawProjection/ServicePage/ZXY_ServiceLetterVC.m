//
//  ZXY_ServiceLetterVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ServiceLetterVC.h"
#import "ZXY_LawCircleView.h"
#import "ELCImagePickerHeader.h"

@interface ZXY_ServiceLetterVC ()<ELCImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL isPerson;
    __weak IBOutlet UIView *contentView;
    NSMutableArray *imagesArr;
    UIActionSheet *picherSheet;
    NSInteger maxPictures;
}
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *allNeedImages;
@property (weak, nonatomic) IBOutlet UITextField *titleNameText;
@property (weak, nonatomic) IBOutlet UITextField *chargeManNameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *cityDetailText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *titleNameValue;
@property (weak, nonatomic) IBOutlet UITextField *chargeManValue;
@property (weak, nonatomic) IBOutlet UITextField *phoneValue;
@property (weak, nonatomic) IBOutlet UITextField *cityValue;
@property (weak, nonatomic) IBOutlet UITextField *cityDetailValue;
@property (weak, nonatomic) IBOutlet UITextField *codeValue;
@property (weak, nonatomic) IBOutlet UITextField *questionText;
@property (weak, nonatomic) IBOutlet UITextField *questionValue;
@property (weak, nonatomic) IBOutlet UITextField *desireText;
@property (weak, nonatomic) IBOutlet UITextField *desireValue;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIButton *firstEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdEditBtn;
- (IBAction)editBtnAction:(id)sender;

//*********************************************//
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *textBackImage;
//*********************************************//
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *secondTextBack;

@end

@implementation ZXY_ServiceLetterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initView];
    [self initCircle];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    imagesArr = [[NSMutableArray alloc] init];
    maxPictures = 10;
}

- (void)initView
{
    if(self.isUserAdd)
    {
        [self.firstEditBtn setHidden:YES];
        [self.secondEditBtn setHidden:YES];
        self.titleNameValue.text = @"";
        self.chargeManValue.text = @"";
        self.phoneValue.text        = @"";
        self.codeValue.text         = @"";
        self.cityDetailValue.text   = @"";
        self.cityValue.text         = @"";
        self.questionValue.text     = @"";
        self.desireValue.text       = @"";
    }
    else
    {
        [self.firstEditBtn setHidden:NO];
        [self.secondEditBtn setHidden:NO];
    }
    [self layerWithBorder:self.firstView];
    [self layerWithBorder:self.secondView];
    [self layerWithBorder:self.thirdView];
    
}

- (void)initCircle
{
    ZXY_LawCircleView *circleView = [[ZXY_LawCircleView alloc] initWithPositionY:10];
    [circleView setNumOfCircle:5];
    [circleView setCircleInfo:[NSArray arrayWithObjects:@"提交",@"起草",@"确认",@"发送",@"存档", nil]];
    UIColor *selectColor = NAVIBARCOLOR;
    [circleView setSelectBackColor:selectColor];
    [circleView setSelectIndex:0];
    [contentView addSubview:circleView];
}

- (void)layerWithBorder:(UIView *)layerView
{
    layerView.layer.borderColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1].CGColor;
    layerView.layer.borderWidth = 1;
    layerView.layer.cornerRadius = 3;
    layerView.layer.masksToBounds = YES;
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    [self initSegmentItems];
}

- (void)initSegmentItems
{
    UISegmentedControl *segMent = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"企业",@"个人", nil]];
    [segMent setSelectedSegmentIndex:0];
    segMent.frame = CGRectMake(0, 0, 160, 30);
    UIColor *naviColor = NAVIBARCOLOR;
    [segMent setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:naviColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [segMent setTintColor:[UIColor whiteColor]];
    [segMent addTarget:self action:@selector(chooseCoorOrPer:) forControlEvents:UIControlEventValueChanged];
    [self setNaviTitleView:segMent];
    
}

- (void)chooseCoorOrPer:(id)sender
{
    NSLog(@"segment change");
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0)
    {
        isPerson = NO;
    }
    else
    {
        isPerson = YES;
    }
    [self startAnnimation];
}

- (void)startAnnimation
{
    float needToMove =0;
    if(isPerson)
    {
        needToMove = -23;
        self.titleNameText.text = @"收函人姓名：";
        [self.chargeManNameText setHidden:YES];
        [self.chargeManValue setHidden:YES];
        UIImageView *imageForHidden = [self.textBackImage objectAtIndex:1];
        [imageForHidden setHidden:YES];
    }
    else
    {
        needToMove = 23;
        self.titleNameText.text = @"收函企业名称：";
        [self.chargeManNameText setHidden:NO];
        [self.chargeManValue setHidden:NO];
        UIImageView *imageForHidden = [self.textBackImage objectAtIndex:1];
        [imageForHidden setHidden:NO];
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect phoneValueRect = self.phoneValue.frame;
        CGRect PhoneTextRect  = self.phoneText.frame;
        CGRect cityValueRect  = self.cityValue.frame;
        CGRect cityTextRect   = self.cityText.frame;
        CGRect cityDetailTextRect = self.cityDetailText.frame;
        CGRect cityDetailValueRect = self.cityDetailValue.frame;
        CGRect codeTextRect   = self.codeText.frame;
        CGRect codeValueRect  = self.codeValue.frame;
        self.phoneValue.frame = CGRectMake(phoneValueRect.origin.x, phoneValueRect.origin.y+needToMove, phoneValueRect.size.width, phoneValueRect.size.height);
        self.phoneText.frame  = CGRectMake(PhoneTextRect.origin.x, PhoneTextRect.origin.y+needToMove, PhoneTextRect.size.width, PhoneTextRect.size.height);
        self.cityText.frame   = CGRectMake(cityTextRect.origin.x, cityTextRect.origin.y+needToMove, cityTextRect.size.width, cityTextRect.size.height);
        self.cityValue.frame  = CGRectMake(cityValueRect.origin.x,cityValueRect.origin.y+needToMove, cityValueRect.size.width, cityValueRect.size.height);
        self.cityDetailValue.frame = CGRectMake(cityDetailValueRect.origin.x, cityDetailValueRect.origin.y+needToMove, cityDetailValueRect.size.width, cityDetailValueRect.size.height);
        self.cityDetailText.frame  = CGRectMake(cityDetailTextRect.origin.x, cityDetailTextRect.origin.y+needToMove, cityDetailTextRect.size.width, cityDetailTextRect.size.height);
        self.codeText.frame   = CGRectMake(codeTextRect.origin.x, codeTextRect.origin.y+needToMove, codeTextRect.size.width, codeTextRect.size.height);
        self.codeValue.frame  = CGRectMake(codeValueRect.origin.x, codeValueRect.origin.y+needToMove, codeValueRect.size.width, codeValueRect.size.height);
        for(int i = 0 ;i<self.textBackImage.count;i++)
        {
            if(i>1)
            {
                UIImageView *currentImage = [self.textBackImage objectAtIndex:i];
                CGRect imageRect = currentImage.frame;
                currentImage.frame = CGRectMake(imageRect.origin.x, imageRect.origin.y+needToMove, imageRect.size.width, imageRect.size.height);
            }
        }
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

- (IBAction)editBtnAction:(id)sender {
    UIButton *editBtn = (UIButton *)sender;
    if(editBtn == self.thirdEditBtn)
    {
        [self chooseImage];
    }
}

- (void)chooseImage
{
    if(imagesArr.count>=maxPictures)
    {
        [self.thirdEditBtn setUserInteractionEnabled:NO];
        return;
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
            picherSheet = [[UIActionSheet alloc] initWithTitle:@"请选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图库选取",@"拍照选取", nil];
    }
    else
    {
        
        picherSheet = [[UIActionSheet alloc] initWithTitle:@"请选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图库选取", nil];
    }
    [picherSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        
        if(buttonIndex == 0)
        {
            ELCImagePickerController *pickerController = [[ELCImagePickerController alloc] initImagePicker];
            [pickerController setMaximumImagesCount:maxPictures-imagesArr.count];
            pickerController.returnsOriginalImage = NO;
            pickerController.returnsImage = YES;
            pickerController.onOrder = YES;
            pickerController.imagePickerDelegate = self;
            [self presentViewController:pickerController animated:YES completion:^{
                
            }];
        }
        else if (buttonIndex == 1)
        {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImage.allowsEditing = NO;
            pickerImage.delegate = self;
            [self presentViewController:pickerImage animated:YES completion:^{
                
            }];

        }
    }
    else
    {
        ELCImagePickerController *pickerController = [[ELCImagePickerController alloc] initImagePicker];
        [pickerController setMaximumImagesCount:maxPictures-imagesArr.count];
        pickerController.returnsOriginalImage = NO;
        pickerController.returnsImage = YES;
        pickerController.onOrder = YES;
        pickerController.imagePickerDelegate = self;
        [self presentViewController:pickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(imagesArr.count+info.count>=maxPictures)
    {
        [self.thirdEditBtn setUserInteractionEnabled:NO];
    }
    for(NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [imagesArr addObject:image];
            }
        }
    }
    for(int i = 0 ;i<imagesArr.count;i++)
    {
        UIImage *images  =  (UIImage *)[imagesArr objectAtIndex:i];
        UIImageView *currentImageView = [self.allNeedImages objectAtIndex:i];
        [currentImageView setImage:images];
    }
}
@end
