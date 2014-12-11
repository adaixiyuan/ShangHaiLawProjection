//
//  ZXY_ServiceAuditVC.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ServiceAuditVC.h"
#import "ELCImagePickerHeader.h"
#import "ZXY_LawCircleView.h"
@interface ZXY_ServiceAuditVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSInteger maxPictures;
    NSMutableArray *imagesArr;
    UIActionSheet  *picherSheet;
}
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *allNeedImages;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UITextView *needsTextV;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)uploadAcion:(id)sender;

@end

@implementation ZXY_ServiceAuditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    maxPictures = 10;
    imagesArr = [[NSMutableArray alloc] init];
    [self initCircle];
    [self initNavi];
    [self layerWithBorder:self.firstView];
    [self layerWithBorder:self.secondView];
    // Do any additional setup after loading the view.
}

- (void)initNavi
{
    [self setLeftNaviItem:@"back_arrow"];
    [self setRightNaviItem:@"home_phone"];
    [self setNaviTitle:@"合同审核" withPositon:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)layerWithBorder:(UIView *)layerView
{
    layerView.layer.borderColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1].CGColor;
    layerView.layer.borderWidth = 1;
    layerView.layer.cornerRadius = 3;
    layerView.layer.masksToBounds = YES;
}

- (void)initCircle
{
    ZXY_LawCircleView *circleView = [[ZXY_LawCircleView alloc] initWithPositionY:5];
    [circleView setNumOfCircle:3];
    [circleView setCircleInfo:[NSArray arrayWithObjects:@"提交",@"审核",@"完成",nil]];
    UIColor *selectColor = NAVIBARCOLOR;
    [circleView setSelectBackColor:selectColor];
    [circleView setSelectIndex:0];
    [self.contentView addSubview:circleView];
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

- (IBAction)uploadAcion:(id)sender {
    [self chooseImage];
}

- (void)chooseImage
{
    if(imagesArr.count>=maxPictures)
    {
        [self.uploadBtn setUserInteractionEnabled:NO];
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
        [self.uploadBtn setUserInteractionEnabled:NO];
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
