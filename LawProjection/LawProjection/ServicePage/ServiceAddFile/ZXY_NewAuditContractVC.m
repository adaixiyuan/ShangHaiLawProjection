//
//  ZXY_NewAuditContractVC.m
//  LawProjection
//
//  Created by 宇周 on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_NewAuditContractVC.h"
#import "ZXY_NewAuditTextCell.h"
#import "ZXY_NewAuditChooseCell.h"
#import "ZXY_NewAuditFileCell.h"
#import "ELCImagePickerHeader.h"
#import "ZXY_LawCircleView.h"
#import "ZXY_WebVC.h"
#import "Definition.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "PopupView.h"
//#define ONECOLOR [UIColor colorWithRed:23.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1];
//#define TWOCOLOR [UIColor colorWithRed:59.0/255.0 green:148.0/255.0 blue:223.0/255.0 alpha:1];
//#define THIRDCOLOR [UIColor colorWithRed:29.0/255.0 green:195.0/255.0 blue:142.0/255.0 alpha:1];
//#define FOURCOLOR [UIColor colorWithRed:92.0/255.0 green:205.0/255.0 blue:72.0/255.0 alpha:1];
//#define FIVECOLOR [UIColor colorWithRed:252.0/255.0 green:135.0/255.0 blue:70.0/255.0 alpha:1];
@interface ZXY_NewAuditContractVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray *allFileArr;
    NSMutableArray *auditFileArr;
    UITextView     *needsText;
    UIToolbar      *topBar   ;
    UIActionSheet  *picherSheet;
    NSString       *statusString;
    NSString       *commentString;
    BOOL           isDetail;
    NSString       *contractID;
    NSDictionary   *currentSelectAttr;
    __weak IBOutlet UITableView *currentTable;
    
    __weak IBOutlet UIButton *submitBtn;
}
- (IBAction)submitAction:(id)sender;
@end

@implementation ZXY_NewAuditContractVC

- (void)viewDidLoad {
    [super viewDidLoad];
    topBar = [self toolBarWithRight:@"完成" andLeft:nil withRightBtnSel:@selector(hideTextView) andLeftBtnSel:nil];
    if(allFileArr==nil)
    {
        allFileArr = [[NSMutableArray alloc] init];
    }
    [self initNavi];
    [self initCircleView];
    _popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
    _popView.ParentView = self.view;
    
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //终止识别
    [_iflyRecognizerView cancel];
    [_iflyRecognizerView setDelegate:nil];
    
    [super viewWillDisappear:animated];
}

- (void)initCircleView
{
    ZXY_LawCircleView *circleView = [[ZXY_LawCircleView alloc] initWithPositionY:10 ];
    [circleView setCircleInfo:[NSArray arrayWithObjects:@"提交",@"审核",@"完成", nil]];
    [circleView setNumOfCircle:3];
    if(statusString == nil)
    {
        statusString = @"AAS001";
        [circleView setSelectBackColor:[UIColor colorWithRed:23.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]];
    }
    else
    {
        [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
        [submitBtn setTitle:@"确认" forState:UIControlStateHighlighted];
    }
    if([statusString isEqualToString:@"AAS001"])
    {
        [circleView setSelectBackColor:[UIColor colorWithRed:23.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]];
        [circleView setSelectIndex:0];
    }
    else if ([statusString isEqualToString:@"AAS002"])
    {
        [circleView setSelectBackColor:[UIColor colorWithRed:59.0/255.0 green:148.0/255.0 blue:223.0/255.0 alpha:1]];
        //needsText.editable= NO;
        //[submitBtn setEnabled:NO];
        [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
        [submitBtn setTitle:@"确认" forState:UIControlStateHighlighted];
        [circleView setSelectIndex:1];
    }
    else
    {
        [circleView setSelectBackColor:[UIColor colorWithRed:29.0/255.0 green:195.0/255.0 blue:142.0/255.0 alpha:1]];
        needsText.editable = NO;
        [submitBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [submitBtn setTitle:@"已完成" forState:UIControlStateHighlighted];
        [submitBtn setEnabled:NO];
        [circleView setSelectIndex:2];
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [headerView addSubview:circleView];
    [currentTable setTableHeaderView:headerView];
}

- (void)initNavi
{
    [self setNaviBarImage:@"home_navi"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self setNaviTitle:@"合同审核" withPositon:1 ];
    [self setRightNaviItem:@"home_phone"];
    [self setLeftNaviItem:@"back_arrow"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAuditInfo:(NSDictionary *)dicInfo
{
    isDetail = YES;
    contractID = [dicInfo objectForKey:@"_id"];
    if(allFileArr==nil)
    {
        allFileArr = [[NSMutableArray alloc] init];
    }
    statusString     = [dicInfo objectForKey:@"status"];
    commentString    = [dicInfo objectForKey:@"comment"];
    NSArray *allFile = [dicInfo objectForKey:@"originalContract"];
    for(NSDictionary *fileInfo in allFile)
    {
        NSString *fileName = [fileInfo objectForKey:@"fileName"];
        NSString *fileId   = [fileInfo objectForKey:@"fileId"];
        NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:fileName,@"name",fileId,@"fileId",@"YES",@"isUpload", nil];
        [allFileArr addObject:fileDic];
    }
    if([statusString isEqualToString:@"AAS003"])
    {
        auditFileArr = [dicInfo objectForKey:@"auditedContract"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 1;
    }
    else if(section == 0)
    {
        if(![statusString isEqualToString:@"AAS003"])
        {
            return allFileArr.count+1;
        }
        else
        {
            return allFileArr.count;
        }
    }
    else
    {
        if(auditFileArr == nil)
        {
            return 0;
        }
        return auditFileArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentSection = indexPath.section;
    //NSInteger currentRow     = indexPath.row;
    if(currentSection == 0)
    {
        return 40;
    }
    else
    {
        return 136;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 5;
    }
    else
    {
        return 15;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 2)
    {
        if(auditFileArr == 0)
        {
            return nil;
        }
        return @"审核意见";
    }
    
    if(section == 0)
    {
        return @"合同原件";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow     = indexPath.row;
    NSInteger currentSection = indexPath.section;
    if(currentSection == 1)
    {
        ZXY_NewAuditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NewAuditTextCellID];
        UIButton *cellBtn = cell.recordBtn;
        cell.btnBlock = ^(void)
        {
            if([statusString isEqualToString:@"AAS003"])
            {
                
            }
            else
            {
                [self startListenning:cellBtn];
            }
        };
        needsText                  = cell.contentText;
        if([statusString isEqualToString:@"AAS003"])
        {
            [needsText setUserInteractionEnabled:NO];
            cell.userInteractionEnabled = NO;
            [cell.recordBtn setHidden:YES];
        }
        if(commentString)
        {
            needsText.text = commentString;
        }
        needsText.delegate         = self;
        [needsText setInputAccessoryView:topBar];
        return cell;
    }
    else if(currentSection == 0)
    {
        if(currentRow < allFileArr.count)
        {
            NSDictionary *imageInfo = [allFileArr objectAtIndex:currentRow];
            ZXY_NewAuditFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NewAuditFileCellID];
            cell.indexLbl.text         = [NSString stringWithFormat:@"%d",indexPath.row+1];
            cell.fileLbl.text          = [imageInfo objectForKey:@"name"];
            if([imageInfo[@"isUpload"] isEqualToString:@"NO"])
            {
                cell.statusLblw.text = @"等待";
            }
            else if ([imageInfo[@"isUpload"] isEqualToString:@"YES"])
            {
                cell.statusLblw.text = @"操作";
            }
            else
            {
                cell.statusLblw.text = @"上传中";
            }
            return cell;
        }
        else
        {
            ZXY_NewAuditChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NewAuditChooseCellID];
            return cell;
        }
    }
    else
    {
        ZXY_NewAuditFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NewAuditFileCellID];
        cell.fileLbl.text          = [[auditFileArr objectAtIndex:indexPath.row] objectForKey:@"fileName"];
        cell.indexLbl.text         = [NSString stringWithFormat:@"%d",indexPath.row+1];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentRow     = indexPath.row;
    NSInteger currentSection = indexPath.section;
    if(currentSection == 0&&currentRow == allFileArr.count)
    {
        [self chooseImage];
    }
    
    if(currentSection == 0 &&currentRow <allFileArr.count)
    {
        NSDictionary *currentDic = [allFileArr objectAtIndex:currentRow];
        if([currentDic[@"isUpload"] isEqualToString:@"YES"])
        {
            currentSelectAttr = currentDic;
            if(![statusString isEqualToString:@"AAS003"])
            {
                UIActionSheet *sheet     = [[UIActionSheet alloc] initWithTitle:@"您要" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看附件",@"删除附件", nil];
                sheet.tag = 5000;
                [sheet showInView:self.view];
            }
            else
            {
                UIActionSheet *sheet     = [[UIActionSheet alloc] initWithTitle:@"您要" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看附件", nil];
                sheet.tag = 5001;
                [sheet showInView:self.view];
            }
           
        }

    }
    
    if(currentSection == 2)
    {
        NSDictionary *currentDic = [auditFileArr objectAtIndex:currentRow];
        NSString     *fileID     = [currentDic objectForKey:@"fileId"];
        NSString     *fileName   = [currentDic objectForKey:@"fileName"];
        NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
        ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
        webVC.title = fileName;
        [webVC setDownLoadURL:stringURL];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.origin.y-40, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.origin.y+40, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}


- (void)chooseImage
{
    if(allFileArr.count>=10)
    {
        [self showAlertWarnningView:@"" andContent:@"最多只能选择十张照片"];
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
    if(actionSheet.tag == 5000)
    {
        if(buttonIndex == 0)
        {
            NSString     *fileID     = [currentSelectAttr objectForKey:@"fileId"];
            NSString     *fileName   = [currentSelectAttr objectForKey:@"name"];
            NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
            ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
            webVC.title = fileName;
            [webVC setDownLoadURL:stringURL];
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else if (buttonIndex == 1)
        {
            [allFileArr removeObject:currentSelectAttr];
            [currentTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }

    }
    else if (actionSheet.tag == 5001)
    {
        if(buttonIndex == 0)
        {
            NSString     *fileID     = [currentSelectAttr objectForKey:@"fileId"];
            NSString     *fileName   = [currentSelectAttr objectForKey:@"name"];
            NSString     *stringURL  = [NSString stringWithFormat:@"%@%@?fileId=%@",API_HOST_URL,API_DOWNLOAD_URL,fileID];
            ZXY_WebVC    *webVC      = [[ZXY_WebVC alloc] init];
            webVC.title = fileName;
            [webVC setDownLoadURL:stringURL];
            [self.navigationController pushViewController:webVC animated:YES];
        }

    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        
        if(buttonIndex == 0)
        {
            ELCImagePickerController *pickerController = [[ELCImagePickerController alloc] initImagePicker];
            [pickerController setMaximumImagesCount:10-allFileArr.count];
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
        [pickerController setMaximumImagesCount:10-allFileArr.count];
        pickerController.returnsOriginalImage = NO;
        pickerController.returnsImage = YES;
        pickerController.onOrder = YES;
        pickerController.imagePickerDelegate = self;
        [self presentViewController:pickerController animated:YES completion:^{
            
        }];
    }
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(allFileArr.count+info.count>10)
    {
        [self showAlertWarnningView:@"" andContent:@"最多只能选择十张图片"];
        return;
    }
    for(NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image      = [dict objectForKey:UIImagePickerControllerOriginalImage];
                NSString *imageName = [self stringForImageName];
//                NSDictionary *imageInfo = @{
//                                            @"name"    :imageName,
//                                            @"data"    :image,
//                                            @"isUpload":@"NO"
//                                            };
                NSMutableDictionary *imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageName,@"name",image,@"data",@"NO",@"isUpload", nil];
                [allFileArr addObject:imageInfo];
            }
        }
    }
    //[currentTable reloadData];
    [self performSelectorInBackground:@selector(uploadImage) withObject:nil];
}

- (NSString *)stringForImageName
{
    NSDateFormatter *dateFormtter = [[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *currentDateString = [dateFormtter stringFromDate:[NSDate date]];
    int valueOne   = arc4random_uniform(10);
    int valueTwo   = arc4random_uniform(10);
    int valueThree = arc4random_uniform(10);
    NSString *returnString = [NSString stringWithFormat:@"%@%d%d%d.jpg",currentDateString,valueOne,valueTwo,valueThree];
    return returnString;
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(allFileArr.count+1>10)
    {
        [self showAlertWarnningView:@"" andContent:@"最多只能选择十张图片"];
        return;
    }

    NSString *imageName = [self stringForImageName];
    NSMutableDictionary *imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageName,@"name",image,@"data",@"NO",@"isUpload", nil];
    [allFileArr addObject:imageInfo];
    
    [self performSelectorInBackground:@selector(uploadImage) withObject:nil];
    //[currentTable reloadData];
}

- (BOOL)isUpOver
{
    BOOL over = YES;
    for(NSMutableDictionary *imageInfo in allFileArr)
    {
        if([[imageInfo objectForKey:@"isUpload"] isEqualToString:@"NO"])
        {
            over = NO;
        }
    }
    return YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)hideTextView
{
    [needsText resignFirstResponder];
}

- (void)uploadImage
{
    __block BOOL canContinue = YES;
    __block BOOL canDown = YES;
    __block int  currentIndex=0;
    while (canContinue) {
        if(canDown)
        {
            
            NSMutableDictionary *fileInfo = [allFileArr objectAtIndex:currentIndex];
            if([fileInfo[@"isUpload"] isEqualToString:@"NO"])
            {
                canDown = NO;
                UIImage *image = [fileInfo objectForKey:@"data"];
                NSString *fileString = [fileInfo objectForKey:@"name"];
                [fileInfo setObject:@"current" forKey:@"isUpload"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [currentTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                });
                
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                [self startUploadFileData:imageData withFileName:fileString andProgress:nil completeSuccess:^(NSDictionary *responseData) {
                    NSArray *dataDic = [responseData objectForKey:@"data"];
                    NSString     *fileId  = [[dataDic objectAtIndex:0] objectForKey:@"_id"];
                    [fileInfo setObject:fileId forKey:@"fileId"];
                    [fileInfo setObject:@"YES" forKey:@"isUpload"];
                    [currentTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    currentIndex ++;
                    if(currentIndex >= allFileArr.count)
                    {
                        canContinue = NO;
//                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            [currentTable reloadData];
//                        });
                    }
                    else
                    {
                        canDown = YES;
                    }

                } completeError:^(NSError *error) {
                    currentIndex++;
                    [fileInfo setObject:@"NO" forKey:@"isUpload"];
                    if(currentIndex >= allFileArr.count)
                    {
                        canContinue = NO;
//                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            [currentTable reloadData];
//                        });
                    }
                    else
                    {
                        canDown = YES;
                    }

                }];
            }
            else
            {
                currentIndex ++;
                if(currentIndex >= allFileArr.count)
                {
                    canContinue = NO;
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [currentTable reloadData];
//                    });
                }
                else
                {
                    canDown = YES;
                }
                
            }
            
        }

    }
    NSLog(@"结束了");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAction:(id)sender {
    if(allFileArr.count == 0)
    {
        [self showAlertWarnningView:@"提示" andContent:@"请上传您要审核的合同"];
        return;
    }
    
    if(needsText.text.length >500)
    {
        [self showAlertWarnningView:@"提示" andContent:@"需求不能多于500个字"];
        return;
    }
    
    for(NSDictionary *imageInfo in allFileArr)
    {
        NSString *statusStrings  = imageInfo[@"isUpload"];
        if(![statusStrings isEqualToString:@"YES"])
        {
            [self showAlertWarnningView:@"提示" andContent:@"还有正在上传中的文件"];
            return;
        }
    }
    if(isDetail)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定更新合同审核信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定消费合同审核服务吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        
        NSString *stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_CONTRACTAUDITADD_URL];
        if(isDetail)
        {
            stringURL = [NSString stringWithFormat:@"%@%@",API_HOST_URL,API_REVIEWUPDATE_URL];
        }
        NSDictionary *parameter = [self parameterForURL];
        if(isDetail)
        {
            [self startLoadDataPutCSRF:stringURL withParameter:parameter successBlock:^(NSData *responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if([dic.allKeys containsObject:@"error"])
                {
                    [self showAlertWarnningView:@"提示 " andContent:@"您购买的【合同审核】服务剩余数量为0，请先购买相应服务。"];
                    return ;
                }
                else
                {
                    [self showAlertWarnningView:@"" andContent:@"提交成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } errorBlock:^(NSError *error) {
                
            }];

        }
        else
        {
            [self startLoadDataPOSTCSRF:stringURL withPatameter:parameter successBlock:^(NSData *responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                if([dic.allKeys containsObject:@"error"])
                {
                    [self showAlertWarnningView:@"提示 " andContent:@"您购买的【合同审核】服务剩余数量为0，请先购买相应服务。"];
                    return ;
                }
                else
                {
                    [self showAlertWarnningView:@"" andContent:@"提交成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } errorBlock:^(NSError *error) {
                ;
            }];
        }

    }
}

- (NSDictionary *)parameterForURL
{
    NSString *commentStrings = needsText.text;
    NSMutableArray *paraArr = [[NSMutableArray alloc] init];
    for(NSDictionary *fileInfo in allFileArr)
    {
        NSDictionary *paraFile = [NSDictionary dictionaryWithObjectsAndKeys:[fileInfo objectForKey:@"fileId"],@"fileId",[fileInfo objectForKey:@"name"], @"fileName",nil];
        [paraArr addObject:paraFile];
    }
    NSString *uid = [NSString stringWithFormat:@"%@",[[UserInfoDetail sharedInstance] getUserID] ];
    NSDictionary *paraDic = @{
                              @"comment":commentStrings,
                              @"originalContract":paraArr
                              };
    NSDictionary *dataParameter ;
    if(!isDetail)
    {
        dataParameter = @{
                          @"data":paraDic,
                          @"uid" :uid
                          };
    }
    else
    {
        NSDictionary *filterDic = @{
                                    @"id":contractID
                                    };
        dataParameter = @{
                          @"data":paraDic,
                          @"filter" :filterDic
                          };
    }

    return dataParameter;
}

#pragma mark - 语音录入功能
- (void)startListenning:(id)sender
{
    [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //设置结果数据格式，可设置为json，xml，plain，默认为json。
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [_iflyRecognizerView start];
    
    NSLog(@"start listenning...");
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    needsText.text = [NSString stringWithFormat:@"%@%@",needsText.text,result];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    [self.view addSubview:_popView];
    
    [_popView setText:@"识别结束"];
    
    NSLog(@"errorCode:%d",[error errorCode]);
}

@end
